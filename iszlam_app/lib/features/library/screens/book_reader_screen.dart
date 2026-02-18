import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/reading_progress.dart';
import '../providers/library_provider.dart';
import '../services/library_service.dart';
import '../services/reader_preferences.dart';
import '../widgets/page_actions_sheet.dart';
import '../widgets/reader_settings_sheet.dart';

class BookReaderScreen extends ConsumerStatefulWidget {
  final String bookId;
  final String title;
  final String filePath;
  final String? downloadUrl;

  const BookReaderScreen({
    super.key,
    required this.bookId,
    required this.title,
    required this.filePath,
    this.downloadUrl,
  });

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen>
    with TickerProviderStateMixin {
  late PdfViewerController _pdfController;
  late LibraryService _libraryService;
  int _currentPage = 1;
  int _totalPages = 0;

  // Overlay animation
  late AnimationController _overlayAnimController;
  late Animation<double> _overlayOpacity;
  bool _isOverlayVisible = true;
  Timer? _autoHideTimer;
  static const _autoHideDuration = Duration(seconds: 4);

  // Preferences
  ReaderPreferences? _prefs;
  bool _nightMode = false;
  double _nightIntensity = 0.5;
  bool _keepScreenOn = true;
  ReaderZoomMode _zoomMode = ReaderZoomMode.fitPage;
  bool _rtlMode = false;
  int _autoScrollSpeed = 0;
  bool _grayscale = false;
  bool _invertedColors = false;
  ReadingMode _readingMode = ReadingMode.verticalScroll;
  bool _showPageNumber = true;
  TapZonePreset _tapZonePreset = TapZonePreset.defaultNav;
  bool _readWithVolumeKeys = false;
  bool _readWithVolumeKeysInverted = false;
  ReaderOrientation _orientation = ReaderOrientation.free;

  // Focus node for keyboard events
  final FocusNode _focusNode = FocusNode();

  // Auto-scroll timer
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _libraryService = ref.read(libraryServiceProvider);

    final progress = _libraryService.getProgress(widget.bookId);
    if (progress != null && progress.currentPage > 1) {
      _currentPage = progress.currentPage;
    }

    _overlayAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _overlayOpacity = CurvedAnimation(
      parent: _overlayAnimController,
      curve: Curves.easeInOut,
    );
    _overlayAnimController.value = 1.0;

    _loadPreferences();
    _resetAutoHideTimer();

    // Enter immersive mode immediately on reader open
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _loadPreferences() async {
    final prefs = await ReaderPreferences.load();
    if (mounted) {
      setState(() {
        _prefs = prefs;
        _nightMode = prefs.nightMode;
        _nightIntensity = prefs.nightIntensity;
        _keepScreenOn = prefs.keepScreenOn;
        _zoomMode = prefs.zoomMode;
        _rtlMode = prefs.rtlMode;
        _autoScrollSpeed = prefs.autoScrollSpeed;
        _grayscale = prefs.grayscale;
        _invertedColors = prefs.invertedColors;
        _readingMode = prefs.readingMode;
        _showPageNumber = prefs.showPageNumber;
        _tapZonePreset = prefs.tapZonePreset;
        _readWithVolumeKeys = prefs.readWithVolumeKeys;
        _readWithVolumeKeysInverted = prefs.readWithVolumeKeysInverted;
        _orientation = prefs.orientation;
      });
      _applyWakelock();
      _applyAutoScroll();
      _applyOrientation();
    }
  }

  void _applyPreferences() {
    if (!mounted || _prefs == null) return;
    setState(() {
      _nightMode = _prefs!.nightMode;
      _nightIntensity = _prefs!.nightIntensity;
      _keepScreenOn = _prefs!.keepScreenOn;
      _zoomMode = _prefs!.zoomMode;
      _rtlMode = _prefs!.rtlMode;
      _autoScrollSpeed = _prefs!.autoScrollSpeed;
      _grayscale = _prefs!.grayscale;
      _invertedColors = _prefs!.invertedColors;
      _readingMode = _prefs!.readingMode;
      _showPageNumber = _prefs!.showPageNumber;
      _tapZonePreset = _prefs!.tapZonePreset;
      _readWithVolumeKeys = _prefs!.readWithVolumeKeys;
      _readWithVolumeKeysInverted = _prefs!.readWithVolumeKeysInverted;
      _orientation = _prefs!.orientation;
    });
    _applyWakelock();
    _applyAutoScroll();
    _applyOrientation();
  }

  void _applyWakelock() {
    _keepScreenOn ? WakelockPlus.enable() : WakelockPlus.disable();
  }

  void _applyOrientation() {
    final orientations = switch (_orientation) {
      ReaderOrientation.free => <DeviceOrientation>[],
      ReaderOrientation.portrait => [DeviceOrientation.portraitUp],
      ReaderOrientation.landscape => [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      ReaderOrientation.portraitReversed => [DeviceOrientation.portraitDown],
      ReaderOrientation.landscapeReversed => [DeviceOrientation.landscapeRight],
    };
    SystemChrome.setPreferredOrientations(orientations);
  }

  // Auto-scroll: advance by 1 page at intervals
  void _applyAutoScroll() {
    _autoScrollTimer?.cancel();
    if (_autoScrollSpeed == 0) return;

    final durations = {1: 12, 2: 7, 3: 3}; // seconds per page
    final seconds = durations[_autoScrollSpeed] ?? 7;

    _autoScrollTimer = Timer.periodic(Duration(seconds: seconds), (_) {
      if (_currentPage < _totalPages) {
        _goToPage(_currentPage + (_rtlMode ? -1 : 1));
      } else {
        _autoScrollTimer?.cancel();
      }
    });
  }

  void _toggleNightMode() {
    setState(() => _nightMode = !_nightMode);
    _prefs?.nightMode = _nightMode;
    _resetAutoHideTimer();
  }

  void _openSettings() {
    if (_prefs == null) return;
    ReaderSettingsSheet.show(context, _prefs!, _applyPreferences);
  }

  void _resetAutoHideTimer() {
    _autoHideTimer?.cancel();
    _autoHideTimer = Timer(_autoHideDuration, () {
      if (mounted && _isOverlayVisible) _hideOverlay();
    });
  }

  void _toggleOverlay() {
    _isOverlayVisible ? _hideOverlay() : _showOverlay();
  }

  void _showOverlay() {
    setState(() => _isOverlayVisible = true);
    _overlayAnimController.forward();
    _resetAutoHideTimer();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _hideOverlay() {
    _overlayAnimController.reverse().then((_) {
      if (mounted) setState(() => _isOverlayVisible = false);
    });
    _autoHideTimer?.cancel();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _saveProgress() {
    if (_totalPages == 0) return;
    final progress = ReadingProgress(
      bookId: widget.bookId,
      currentPage: _currentPage,
      percentage: _currentPage / _totalPages,
      lastReadAt: DateTime.now(),
    );
    _libraryService.saveProgress(progress);
    if (mounted) {
      ref.invalidate(libraryBooksProvider);
    }
  }

  void _goToPage(int page) {
    if (!mounted || _totalPages < 1) return;
    final clamped = page.clamp(1, _totalPages);
    _pdfController.goToPage(pageNumber: clamped);
    setState(() => _currentPage = clamped);
    _saveProgress();
  }

  void _goNextPage() => _goToPage(_currentPage + (_rtlMode ? -1 : 1));
  void _goPrevPage() => _goToPage(_currentPage + (_rtlMode ? 1 : -1));

  void _showPageActions() {
    PageActionsSheet.show(
      context,
      pageNumber: _currentPage,
      onBookmark: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmarked page $_currentPage'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onShare: () {
        final url = widget.downloadUrl ?? widget.filePath;
        final shareText = '📖 ${widget.title} — Page $_currentPage\n$url';
        Clipboard.setData(ClipboardData(text: shareText));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Link copied to clipboard'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      onSaveAsImage: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Page saved to gallery'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _saveProgress();
    _autoHideTimer?.cancel();
    _autoScrollTimer?.cancel();
    _overlayAnimController.dispose();
    _focusNode.dispose();
    WakelockPlus.disable();
    SystemChrome.setPreferredOrientations([]); // Reset orientation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  PdfViewerParams _buildPdfParams() {
    final isWebtoonOrVertical = _readingMode == ReadingMode.webtoon ||
        _readingMode == ReadingMode.verticalScroll;
    return PdfViewerParams(
      maxScale: _zoomMode == ReaderZoomMode.fitWidth ? 4.0 : 2.5,
      scrollPhysics: const BouncingScrollPhysics(),
      panAxis: isWebtoonOrVertical ? PanAxis.aligned : PanAxis.free,
      verticalCacheExtent: 4.0,
      horizontalCacheExtent: 2.0,
      limitRenderingCache: false,
      onePassRenderingScaleThreshold: 3.5,
      layoutPages: _readingMode == ReadingMode.webtoon ? _webtoonLayout : null,
      onViewerReady: (document, controller) {
        if (!mounted) return;
        setState(() => _totalPages = document.pages.length);
      },
      onPageChanged: (pageNumber) {
        if (!mounted) return;
        setState(() => _currentPage = pageNumber ?? 1);
        _saveProgress();
      },
    );
  }

  Widget _wrapWithFilters(Widget child) {
    Widget result = child;

    if (_grayscale) {
      result = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0.2126, 0.7152, 0.0722, 0, 0,
          0,      0,      0,      1, 0,
        ]),
        child: result,
      );
    }

    if (_invertedColors) {
      result = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          -1,  0,  0, 0, 255,
           0, -1,  0, 0, 255,
           0,  0, -1, 0, 255,
           0,  0,  0, 1,   0,
        ]),
        child: result,
      );
    }

    return result;
  }

  // Webtoon continuous vertical layout
  PdfPageLayout _webtoonLayout(
    List<PdfPage> pages,
    PdfViewerParams params,
  ) {
    const gap = 2.0;
    final pageLayouts = <Rect>[];
    double y = 0;
    double maxW = 0;
    for (final page in pages) {
      final w = page.width;
      final h = page.height;
      pageLayouts.add(Rect.fromLTWH(0, y, w, h));
      y += h + gap;
      if (w > maxW) maxW = w;
    }
    return PdfPageLayout(
      pageLayouts: pageLayouts,
      documentSize: Size(maxW, y),
    );
  }

  void _handleKeyEvent(KeyEvent event) {
    if (!_readWithVolumeKeys) return;
    if (event is! KeyDownEvent) return;

    final isVolumeUp = event.logicalKey == LogicalKeyboardKey.audioVolumeUp;
    final isVolumeDown = event.logicalKey == LogicalKeyboardKey.audioVolumeDown;

    if (!isVolumeUp && !isVolumeDown) return;

    if (_readWithVolumeKeysInverted) {
      isVolumeUp ? _goNextPage() : _goPrevPage();
    } else {
      isVolumeUp ? _goPrevPage() : _goNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLocal = widget.filePath.isNotEmpty && !widget.filePath.startsWith('http');
    final screenWidth = MediaQuery.of(context).size.width;

    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // PDF Viewer with visual filters
          _wrapWithFilters(
            isLocal
                ? PdfViewer.file(
                    widget.filePath,
                    controller: _pdfController,
                    initialPageNumber: _currentPage,
                    params: _buildPdfParams(),
                  )
                : PdfViewer.uri(
                    Uri.parse(widget.downloadUrl ?? widget.filePath),
                    controller: _pdfController,
                    initialPageNumber: _currentPage,
                    params: _buildPdfParams(),
                  ),
          ),

          // Night Mode Overlay
          if (_nightMode)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Color.lerp(
                    Colors.transparent,
                    const Color(0xCC1A1A0A),
                    _nightIntensity,
                  ),
                ),
              ),
            ),

          // Tap Zones — dynamic based on preset
          _buildTapZones(screenWidth),

          // Outlined Page Indicator
          if (_totalPages > 0 && _showPageNumber)
            Positioned(
              bottom: _isOverlayVisible ? 80 : 16,
              left: 0,
              right: 0,
              child: _OutlinedPageIndicator(
                currentPage: _currentPage,
                totalPages: _totalPages,
              ),
            ),

          // Auto-scroll indicator
          if (_autoScrollSpeed > 0)
            Positioned(
              top: 80,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      ['', 'Slow', 'Med', 'Fast'][_autoScrollSpeed],
                      style: const TextStyle(color: Colors.amber, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),

          // Animated AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _overlayOpacity,
              child: AppBar(
                title: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                backgroundColor: GardenPalette.white.withValues(alpha: 0.9),
                foregroundColor: GardenPalette.nearBlack,
                elevation: 1,
                shadowColor: Colors.black.withValues(alpha: 0.05),
                iconTheme: const IconThemeData(color: GardenPalette.leafyGreen),
                actions: [
                  if (_rtlMode)
                    const Padding(
                      padding: EdgeInsets.only(right: 4),
                      child: Icon(Icons.format_textdirection_r_to_l, color: GardenPalette.leafyGreen, size: 16),
                    ),
                  IconButton(
                    icon: Icon(
                      _nightMode ? Icons.light_mode : Icons.dark_mode_outlined,
                      color: _nightMode ? Colors.amber : GardenPalette.leafyGreen,
                    ),
                    tooltip: _nightMode ? 'Day Mode' : 'Night Mode',
                    onPressed: _toggleNightMode,
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: GardenPalette.leafyGreen),
                    tooltip: 'Reader Settings',
                    onPressed: _openSettings,
                  ),
                ],
              ),
            ),
          ),

          // Animated Bottom Bar with Page Slider
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _overlayOpacity,
              child: Container(
                color: GardenPalette.white.withValues(alpha: 0.9),
                padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_totalPages > 1)
                        Directionality(
                          textDirection: _rtlMode ? TextDirection.rtl : TextDirection.ltr,
                          child: SliderTheme(
                            data: SliderThemeData(
                              activeTrackColor: Colors.white70,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: Colors.white,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 2,
                              overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                            ),
                            child: Slider(
                              value: _currentPage.toDouble().clamp(1, _totalPages.toDouble()),
                              min: 1,
                              max: _totalPages.toDouble(),
                              onChanged: (v) => _goToPage(v.toInt()),
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          children: [
                            Text(
                              '$_currentPage / $_totalPages',
                              style: const TextStyle(color: GardenPalette.nearBlack, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const Spacer(),
                            if (_totalPages > 0)
                              Text(
                                '${((_currentPage / _totalPages) * 100).toInt()}%',
                                style: const TextStyle(color: GardenPalette.nearBlack, fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  // ═══════════════════════════════════════
  //  TAP ZONE PRESETS
  // ═══════════════════════════════════════

  Widget _buildTapZones(double screenWidth) {
    // Reinforce non-nullability for Web/async edge cases
    final preset = _tapZonePreset;

    if (preset == TapZonePreset.disabled) {
      return Positioned.fill(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _toggleOverlay,
          onLongPress: _showPageActions,
          child: const SizedBox.expand(),
        ),
      );
    }

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: switch (preset) {
              TapZonePreset.defaultNav => _defaultZones(w),
              TapZonePreset.lShaped => _lShapedZones(w, h),
              TapZonePreset.kindlish => _kindlishZones(w),
              TapZonePreset.edgeOnly => _edgeZones(w),
              TapZonePreset.rightAndLeft => _rightAndLeftZones(w),
              TapZonePreset.disabled => [],
            },
          );
        },
      ),
    );
  }

  List<Widget> _defaultZones(double w) => [
    Positioned(left: 0, top: 0, bottom: 0, width: w * 0.33,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.33, top: 0, bottom: 0, width: w * 0.34,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _toggleOverlay, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.67, top: 0, bottom: 0, width: w * 0.33,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goNextPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
  ];

  List<Widget> _lShapedZones(double w, double h) => [
    Positioned(left: 0, top: 0, bottom: 0, width: w * 0.33,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.33, bottom: 0, right: 0, height: h * 0.25,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.33, top: h * 0.15, right: 0, height: h * 0.6,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _toggleOverlay, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.33, top: 0, right: 0, height: h * 0.15,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goNextPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
  ];

  List<Widget> _kindlishZones(double w) => [
    Positioned(left: 0, top: 0, bottom: 0, width: w * 0.2,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.2, top: 0, bottom: 0, width: w * 0.3,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _toggleOverlay, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.5, top: 0, bottom: 0, width: w * 0.5,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goNextPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
  ];

  List<Widget> _edgeZones(double w) => [
    Positioned(left: 0, top: 0, bottom: 0, width: w * 0.12,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.12, top: 0, bottom: 0, width: w * 0.76,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _toggleOverlay, onLongPress: _showPageActions, child: const SizedBox.expand())),
    Positioned(left: w * 0.88, top: 0, bottom: 0, width: w * 0.12,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goNextPage, onLongPress: _showPageActions, child: const SizedBox.expand())),
  ];

  List<Widget> _rightAndLeftZones(double w) => [
    Positioned(left: 0, top: 0, bottom: 0, width: w * 0.5,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goPrevPage, onLongPress: _toggleOverlay, child: const SizedBox.expand())),
    Positioned(left: w * 0.5, top: 0, bottom: 0, width: w * 0.5,
      child: GestureDetector(behavior: HitTestBehavior.translucent, onTap: _goNextPage, onLongPress: _toggleOverlay, child: const SizedBox.expand())),
  ];
}

/// Outlined page indicator inspired by mihon's ReaderPageIndicator.
class _OutlinedPageIndicator extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _OutlinedPageIndicator({
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    if (currentPage <= 0 || totalPages <= 0) return const SizedBox.shrink();

    final text = '$currentPage / $totalPages';

    return Center(
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = const Color(0xFF2D2D2D),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Color(0xFFEBEBEB),
            ),
          ),
        ],
      ),
    );
  }
}
