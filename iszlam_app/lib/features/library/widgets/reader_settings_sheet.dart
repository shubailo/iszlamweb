import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../services/reader_preferences.dart';

class ReaderSettingsSheet extends StatefulWidget {
  final ReaderPreferences prefs;
  final VoidCallback onChanged;

  const ReaderSettingsSheet({
    super.key,
    required this.prefs,
    required this.onChanged,
  });

  static Future<void> show(BuildContext context, ReaderPreferences prefs, VoidCallback onChanged) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: GardenPalette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      builder: (_) => ReaderSettingsSheet(prefs: prefs, onChanged: onChanged),
    );
  }

  @override
  State<ReaderSettingsSheet> createState() => _ReaderSettingsSheetState();
}

class _ReaderSettingsSheetState extends State<ReaderSettingsSheet> {
  // ── Local state mirrors ──
  late ReadingMode _readingMode;
  late ReaderOrientation _orientation;
  late bool _pageTransitions;
  late int _doubleTapAnimSpeed;
  late bool _showPageNumber;
  late bool _cropBorders;

  late bool _nightMode;
  late double _nightIntensity;
  late bool _keepScreenOn;
  late ReaderZoomMode _zoomMode;
  late bool _rtlMode;
  late int _autoScrollSpeed;
  late bool _fullscreen;

  late bool _grayscale;
  late bool _invertedColors;
  late bool _customBrightness;
  late int _customBrightnessValue;

  late TapZonePreset _tapZonePreset;
  late bool _readWithVolumeKeys;
  late bool _readWithVolumeKeysInverted;

  late int _webtoonSidePadding;

  @override
  void initState() {
    super.initState();
    final p = widget.prefs;
    _readingMode = p.readingMode;
    _orientation = p.orientation;
    _pageTransitions = p.pageTransitions;
    _doubleTapAnimSpeed = p.doubleTapAnimSpeed;
    _showPageNumber = p.showPageNumber;
    _cropBorders = p.cropBorders;

    _nightMode = p.nightMode;
    _nightIntensity = p.nightIntensity;
    _keepScreenOn = p.keepScreenOn;
    _zoomMode = p.zoomMode;
    _rtlMode = p.rtlMode;
    _autoScrollSpeed = p.autoScrollSpeed;
    _fullscreen = p.fullscreen;

    _grayscale = p.grayscale;
    _invertedColors = p.invertedColors;
    _customBrightness = p.customBrightness;
    _customBrightnessValue = p.customBrightnessValue;

    _tapZonePreset = p.tapZonePreset;
    _readWithVolumeKeys = p.readWithVolumeKeys;
    _readWithVolumeKeysInverted = p.readWithVolumeKeysInverted;

    _webtoonSidePadding = p.webtoonSidePadding;
  }

  void _save() {
    final p = widget.prefs;
    p.readingMode = _readingMode;
    p.orientation = _orientation;
    p.pageTransitions = _pageTransitions;
    p.doubleTapAnimSpeed = _doubleTapAnimSpeed;
    p.showPageNumber = _showPageNumber;
    p.cropBorders = _cropBorders;

    p.nightMode = _nightMode;
    p.nightIntensity = _nightIntensity;
    p.keepScreenOn = _keepScreenOn;
    p.zoomMode = _zoomMode;
    p.rtlMode = _rtlMode;
    p.autoScrollSpeed = _autoScrollSpeed;
    p.fullscreen = _fullscreen;

    p.grayscale = _grayscale;
    p.invertedColors = _invertedColors;
    p.customBrightness = _customBrightness;
    p.customBrightnessValue = _customBrightnessValue;

    p.tapZonePreset = _tapZonePreset;
    p.readWithVolumeKeys = _readWithVolumeKeys;
    p.readWithVolumeKeysInverted = _readWithVolumeKeysInverted;

    p.webtoonSidePadding = _webtoonSidePadding;

    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: GardenPalette.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            TabBar(
              indicatorColor: GardenPalette.leafyGreen,
              labelColor: GardenPalette.nearBlack,
              unselectedLabelColor: GardenPalette.darkGrey,
              labelStyle: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold, fontSize: 14),
              unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 13),
              tabs: const [
                Tab(text: 'Reading'),
                Tab(text: 'General'),
                Tab(text: 'Filter'),
              ],
            ),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: TabBarView(
                  children: [
                    SingleChildScrollView(child: _buildReadingModeTab()),
                    SingleChildScrollView(child: _buildGeneralTab()),
                    SingleChildScrollView(child: _buildFilterTab()),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TAB 1: Reading Mode
  // ═══════════════════════════════════════

  Widget _buildReadingModeTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Reading Mode'),
          _ReadingModeSelector(
            selected: _readingMode,
            onChanged: (v) { setState(() => _readingMode = v); _save(); },
          ),
          const SizedBox(height: 16),
          _sectionHeader('Orientation'),
          _OrientationSelector(
            selected: _orientation,
            onChanged: (v) { setState(() => _orientation = v); _save(); },
          ),
          const SizedBox(height: 16),
          _switchRow(Icons.swap_horiz, 'Page Transitions', _pageTransitions, (v) {
            setState(() => _pageTransitions = v); _save();
          }),
          _switchRow(Icons.crop, 'Crop Borders', _cropBorders, (v) {
            setState(() => _cropBorders = v); _save();
          }),
          if (_readingMode == ReadingMode.webtoon) ...[
            const SizedBox(height: 8),
            _sectionHeader('Webtoon Settings'),
            _SettingsRow(
              icon: Icons.padding,
              label: 'Side Padding: $_webtoonSidePadding%',
              trailing: SizedBox(
                width: 150,
                child: Slider(
                  value: _webtoonSidePadding.toDouble(),
                  min: 0, max: 25, divisions: 25,
                  activeColor: GardenPalette.leafyGreen,
                  inactiveColor: GardenPalette.lightGrey,
                  onChanged: (v) {
                    setState(() => _webtoonSidePadding = v.round());
                    _save();
                  },
                ),
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TAB 2: General
  // ═══════════════════════════════════════

  Widget _buildGeneralTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _switchRow(Icons.dark_mode_outlined, 'Night Mode', _nightMode, (v) {
            setState(() => _nightMode = v); _save();
          }),
          if (_nightMode) ...[
            const SizedBox(height: 8),
            Text('Overlay Intensity', style: GoogleFonts.outfit(color: GardenPalette.darkGrey, fontSize: 12, fontWeight: FontWeight.w500)),
            Slider(
              value: _nightIntensity, min: 0.1, max: 0.9,
              thumbColor: GardenPalette.leafyGreen,
              activeColor: GardenPalette.leafyGreen,
              inactiveColor: GardenPalette.lightGrey,
              onChanged: (v) { setState(() => _nightIntensity = v); _save(); },
            ),
          ],
          const SizedBox(height: 8),
          _SettingsRow(
            icon: Icons.zoom_in_outlined,
            label: 'Zoom Mode',
            trailing: SegmentedButton<ReaderZoomMode>(
              segments: const [
                ButtonSegment(value: ReaderZoomMode.fitPage, label: Text('Page', style: TextStyle(fontSize: 12))),
                ButtonSegment(value: ReaderZoomMode.fitWidth, label: Text('Width', style: TextStyle(fontSize: 12))),
              ],
              selected: {_zoomMode},
              onSelectionChanged: (v) { setState(() => _zoomMode = v.first); _save(); },
              style: _segmentedStyle,
            ),
          ),
          const Divider(height: 24),
          _switchRow(Icons.screen_lock_portrait_outlined, 'Keep Screen On', _keepScreenOn, (v) {
            setState(() => _keepScreenOn = v); _save();
          }),
          _switchRow(Icons.fullscreen, 'Fullscreen', _fullscreen, (v) {
            setState(() => _fullscreen = v); _save();
          }),
          _switchRow(Icons.numbers, 'Show Page Number', _showPageNumber, (v) {
            setState(() => _showPageNumber = v); _save();
          }),
          _switchRow(Icons.format_textdirection_r_to_l_outlined, 'RTL (Arabic)', _rtlMode, (v) {
            setState(() => _rtlMode = v); _save();
          }),
          const SizedBox(height: 8),
          _SettingsRow(
            icon: Icons.speed_outlined,
            label: 'Auto-Scroll',
            trailing: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 0, label: Text('Off', style: TextStyle(fontSize: 11))),
                ButtonSegment(value: 1, label: Text('Slow', style: TextStyle(fontSize: 11))),
                ButtonSegment(value: 2, label: Text('Med', style: TextStyle(fontSize: 11))),
                ButtonSegment(value: 3, label: Text('Fast', style: TextStyle(fontSize: 11))),
              ],
              selected: {_autoScrollSpeed},
              onSelectionChanged: (v) { setState(() => _autoScrollSpeed = v.first); _save(); },
              style: _segmentedStyle.copyWith(visualDensity: VisualDensity.compact),
            ),
          ),
          const Divider(height: 24),
          _sectionHeader('Navigation'),
          _SettingsRow(
            icon: Icons.touch_app_outlined,
            label: 'Tap Zones',
            trailing: DropdownButton<TapZonePreset>(
              value: _tapZonePreset,
              underline: const SizedBox.shrink(),
              style: GoogleFonts.outfit(color: GardenPalette.nearBlack, fontSize: 14),
              items: TapZonePreset.values.map((e) => DropdownMenuItem(
                value: e,
                child: Text(_tapZoneName(e)),
              )).toList(),
              onChanged: (v) { if (v != null) { setState(() => _tapZonePreset = v); _save(); } },
            ),
          ),
          _switchRow(Icons.volume_up, 'Volume Key Nav', _readWithVolumeKeys, (v) {
            setState(() => _readWithVolumeKeys = v); _save();
          }),
          if (_readWithVolumeKeys)
            _switchRow(Icons.swap_vert, 'Invert Volume Keys', _readWithVolumeKeysInverted, (v) {
              setState(() => _readWithVolumeKeysInverted = v); _save();
            }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  TAB 3: Color Filter
  // ═══════════════════════════════════════

  Widget _buildFilterTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _switchRow(Icons.brightness_6, 'Custom Brightness', _customBrightness, (v) {
            setState(() => _customBrightness = v); _save();
          }),
          if (_customBrightness) ...[
            Slider(
              value: _customBrightnessValue.toDouble(),
              min: -100, max: 100, divisions: 200,
              activeColor: GardenPalette.leafyGreen,
              inactiveColor: GardenPalette.lightGrey,
              label: '${_customBrightnessValue > 0 ? '+' : ''}$_customBrightnessValue',
              onChanged: (v) {
                setState(() => _customBrightnessValue = v.round());
                _save();
              },
            ),
          ],
          const Divider(height: 16),
          _switchRow(Icons.filter_b_and_w, 'Grayscale', _grayscale, (v) {
            setState(() => _grayscale = v); _save();
          }),
          _switchRow(Icons.invert_colors, 'Inverted Colors', _invertedColors, (v) {
            setState(() => _invertedColors = v); _save();
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.playfairDisplay(
          fontSize: 16, fontWeight: FontWeight.bold,
          color: GardenPalette.nearBlack,
        ),
      ),
    );
  }

  Widget _switchRow(IconData icon, String label, bool value, ValueChanged<bool> onChanged) {
    return _SettingsRow(
      icon: icon,
      label: label,
      trailing: Switch(
        value: value,
        activeThumbColor: GardenPalette.white,
        activeTrackColor: GardenPalette.leafyGreen,
        inactiveThumbColor: GardenPalette.white,
        inactiveTrackColor: GardenPalette.lightGrey,
        onChanged: onChanged,
      ),
    );
  }

  ButtonStyle get _segmentedStyle => ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? GardenPalette.white : GardenPalette.nearBlack),
    backgroundColor: WidgetStateProperty.resolveWith((states) =>
        states.contains(WidgetState.selected) ? GardenPalette.leafyGreen : Colors.transparent),
    side: WidgetStateProperty.all(const BorderSide(color: GardenPalette.lightGrey)),
  );

  String _tapZoneName(TapZonePreset p) => switch (p) {
    TapZonePreset.defaultNav => 'Default',
    TapZonePreset.lShaped => 'L-shaped',
    TapZonePreset.kindlish => 'Kindle-ish',
    TapZonePreset.edgeOnly => 'Edge',
    TapZonePreset.rightAndLeft => 'Right & Left',
    TapZonePreset.disabled => 'Disabled',
  };
}

// ═══════════════════════════════════════
//  CUSTOM WIDGETS
// ═══════════════════════════════════════

class _ReadingModeSelector extends StatelessWidget {
  final ReadingMode selected;
  final ValueChanged<ReadingMode> onChanged;

  const _ReadingModeSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: ReadingMode.values.map((mode) {
        final isSelected = mode == selected;
        return ChoiceChip(
          label: Text(_label(mode)),
          selected: isSelected,
          onSelected: (_) => onChanged(mode),
          selectedColor: GardenPalette.leafyGreen,
          backgroundColor: GardenPalette.lightGrey,
          labelStyle: TextStyle(
            color: isSelected ? GardenPalette.white : GardenPalette.nearBlack,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  String _label(ReadingMode m) => switch (m) {
    ReadingMode.pagerLeftToRight => 'LTR ▶',
    ReadingMode.pagerRightToLeft => '◀ RTL',
    ReadingMode.verticalScroll => '↕ Vertical',
    ReadingMode.webtoon => '📜 Webtoon',
  };
}

class _OrientationSelector extends StatelessWidget {
  final ReaderOrientation selected;
  final ValueChanged<ReaderOrientation> onChanged;

  const _OrientationSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8, runSpacing: 8,
      children: ReaderOrientation.values.map((o) {
        final isSelected = o == selected;
        return ChoiceChip(
          label: Text(_label(o)),
          selected: isSelected,
          onSelected: (_) => onChanged(o),
          selectedColor: GardenPalette.leafyGreen,
          backgroundColor: GardenPalette.lightGrey,
          labelStyle: TextStyle(
            color: isSelected ? GardenPalette.white : GardenPalette.nearBlack,
            fontSize: 12,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide.none,
        );
      }).toList(),
    );
  }

  String _label(ReaderOrientation o) => switch (o) {
    ReaderOrientation.free => '🔄 Free',
    ReaderOrientation.portrait => '📱 Portrait',
    ReaderOrientation.landscape => '🖥️ Landscape',
    ReaderOrientation.portraitReversed => '🔃 Portrait ↕',
    ReaderOrientation.landscapeReversed => '🔃 Landscape ↔',
  };
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: GardenPalette.leafyGreen, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                color: GardenPalette.nearBlack,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
