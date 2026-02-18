import 'package:shared_preferences/shared_preferences.dart';

// ── Enums (Mihon-style) ──

enum ReaderZoomMode { fitPage, fitWidth }

enum ReadingMode {
  pagerLeftToRight,
  pagerRightToLeft,
  verticalScroll,
  webtoon,
}

enum ReaderOrientation {
  free,
  portrait,
  landscape,
  portraitReversed,
  landscapeReversed,
}

enum ImageScaleType {
  fitScreen,
  stretch,
  fitWidth,
  fitHeight,
  originalSize,
  smartFit,
}

enum TapZonePreset {
  defaultNav,
  lShaped,
  kindlish,
  edgeOnly,
  rightAndLeft,
  disabled,
}

enum TappingInvertMode { none, horizontal, vertical, both }

// ── Preferences ──

class ReaderPreferences {
  // Keys
  static const _ns = 'reader_';

  final SharedPreferences _prefs;

  ReaderPreferences._(this._prefs);

  static Future<ReaderPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return ReaderPreferences._(prefs);
  }

  // ── Helpers ──
  T _getEnum<T extends Enum>(String key, T fallback, List<T> values) {
    try {
      final idx = _prefs.getInt('$_ns$key');
      if (idx == null) return fallback;
      return values[idx.clamp(0, values.length - 1)];
    } catch (_) {
      return fallback;
    }
  }

  void _setEnum<T extends Enum>(String key, T v) =>
      _prefs.setInt('$_ns$key', v.index);

  bool _getBool(String key, [bool fallback = false]) =>
      _prefs.getBool('$_ns$key') ?? fallback;
  void _setBool(String key, bool v) => _prefs.setBool('$_ns$key', v);

  int _getInt(String key, [int fallback = 0]) =>
      _prefs.getInt('$_ns$key') ?? fallback;
  void _setInt(String key, int v) => _prefs.setInt('$_ns$key', v);

  double _getDouble(String key, [double fallback = 0.0]) =>
      _prefs.getDouble('$_ns$key') ?? fallback;
  void _setDouble(String key, double v) => _prefs.setDouble('$_ns$key', v);

  // ═══════════════════════════════════════
  //  GENERAL
  // ═══════════════════════════════════════

  // Reading mode
  ReadingMode get readingMode =>
      _getEnum('reading_mode', ReadingMode.verticalScroll, ReadingMode.values);
  set readingMode(ReadingMode v) => _setEnum('reading_mode', v);

  // Orientation lock
  ReaderOrientation get orientation =>
      _getEnum('orientation', ReaderOrientation.free, ReaderOrientation.values);
  set orientation(ReaderOrientation v) => _setEnum('orientation', v);

  // Page transitions
  bool get pageTransitions => _getBool('page_transitions', true);
  set pageTransitions(bool v) => _setBool('page_transitions', v);

  // Double tap animation speed (ms)
  int get doubleTapAnimSpeed => _getInt('double_tap_anim_speed', 500);
  set doubleTapAnimSpeed(int v) => _setInt('double_tap_anim_speed', v);

  // Show page number
  bool get showPageNumber => _getBool('show_page_number', true);
  set showPageNumber(bool v) => _setBool('show_page_number', v);

  // Fullscreen (immersive)
  bool get fullscreen => _getBool('fullscreen', true);
  set fullscreen(bool v) => _setBool('fullscreen', v);

  // Draw under cutout
  bool get drawUnderCutout => _getBool('draw_under_cutout', true);
  set drawUnderCutout(bool v) => _setBool('draw_under_cutout', v);

  // Keep screen on
  bool get keepScreenOn => _getBool('keep_screen_on', true);
  set keepScreenOn(bool v) => _setBool('keep_screen_on', v);

  // ═══════════════════════════════════════
  //  IMAGE & ZOOM
  // ═══════════════════════════════════════

  // Zoom mode (legacy)
  ReaderZoomMode get zoomMode =>
      _getEnum('zoom_mode', ReaderZoomMode.fitPage, ReaderZoomMode.values);
  set zoomMode(ReaderZoomMode v) => _setEnum('zoom_mode', v);

  // Image scale type (Mihon-style)
  ImageScaleType get imageScaleType =>
      _getEnum('image_scale_type', ImageScaleType.fitScreen, ImageScaleType.values);
  set imageScaleType(ImageScaleType v) => _setEnum('image_scale_type', v);

  // Landscape zoom
  bool get landscapeZoom => _getBool('landscape_zoom', true);
  set landscapeZoom(bool v) => _setBool('landscape_zoom', v);

  // Navigate to pan
  bool get navigateToPan => _getBool('navigate_to_pan', true);
  set navigateToPan(bool v) => _setBool('navigate_to_pan', v);

  // Crop borders
  bool get cropBorders => _getBool('crop_borders');
  set cropBorders(bool v) => _setBool('crop_borders', v);

  // ═══════════════════════════════════════
  //  COLOR FILTER
  // ═══════════════════════════════════════

  // Night mode (sepia overlay)
  bool get nightMode => _getBool('night_mode');
  set nightMode(bool v) => _setBool('night_mode', v);

  double get nightIntensity => _getDouble('night_intensity', 0.5);
  set nightIntensity(double v) => _setDouble('night_intensity', v);

  // Custom brightness
  bool get customBrightness => _getBool('custom_brightness');
  set customBrightness(bool v) => _setBool('custom_brightness', v);

  int get customBrightnessValue => _getInt('custom_brightness_value');
  set customBrightnessValue(int v) => _setInt('custom_brightness_value', v);

  // Grayscale
  bool get grayscale => _getBool('grayscale');
  set grayscale(bool v) => _setBool('grayscale', v);

  // Inverted colors
  bool get invertedColors => _getBool('inverted_colors');
  set invertedColors(bool v) => _setBool('inverted_colors', v);

  // ═══════════════════════════════════════
  //  CONTROLS / NAVIGATION
  // ═══════════════════════════════════════

  // RTL mode
  bool get rtlMode => _getBool('rtl_mode');
  set rtlMode(bool v) => _setBool('rtl_mode', v);

  // Auto-scroll speed (0 = off, 1-3 = slow/medium/fast)
  int get autoScrollSpeed => _getInt('auto_scroll_speed');
  set autoScrollSpeed(int v) => _setInt('auto_scroll_speed', v);

  // Tap zone preset
  TapZonePreset get tapZonePreset =>
      _getEnum('tap_zone_preset', TapZonePreset.defaultNav, TapZonePreset.values);
  set tapZonePreset(TapZonePreset v) => _setEnum('tap_zone_preset', v);

  // Tap inversion
  TappingInvertMode get tappingInvertMode =>
      _getEnum('tapping_invert_mode', TappingInvertMode.none, TappingInvertMode.values);
  set tappingInvertMode(TappingInvertMode v) => _setEnum('tapping_invert_mode', v);

  // Read with long tap
  bool get readWithLongTap => _getBool('read_with_long_tap', true);
  set readWithLongTap(bool v) => _setBool('read_with_long_tap', v);

  // Volume key navigation
  bool get readWithVolumeKeys => _getBool('read_with_volume_keys');
  set readWithVolumeKeys(bool v) => _setBool('read_with_volume_keys', v);

  bool get readWithVolumeKeysInverted => _getBool('read_with_volume_keys_inverted');
  set readWithVolumeKeysInverted(bool v) => _setBool('read_with_volume_keys_inverted', v);

  // Show navigation overlay on start
  bool get showNavigationOverlayOnStart => _getBool('show_nav_overlay_on_start');
  set showNavigationOverlayOnStart(bool v) => _setBool('show_nav_overlay_on_start', v);

  // ═══════════════════════════════════════
  //  WEBTOON-SPECIFIC
  // ═══════════════════════════════════════

  bool get cropBordersWebtoon => _getBool('crop_borders_webtoon');
  set cropBordersWebtoon(bool v) => _setBool('crop_borders_webtoon', v);

  int get webtoonSidePadding => _getInt('webtoon_side_padding');
  set webtoonSidePadding(int v) => _setInt('webtoon_side_padding', v);

  bool get webtoonDisableZoomOut => _getBool('webtoon_disable_zoom_out');
  set webtoonDisableZoomOut(bool v) => _setBool('webtoon_disable_zoom_out', v);

  bool get webtoonDoubleTapZoom => _getBool('webtoon_double_tap_zoom', true);
  set webtoonDoubleTapZoom(bool v) => _setBool('webtoon_double_tap_zoom', v);

  // ═══════════════════════════════════════
  //  FLASH ON PAGE CHANGE
  // ═══════════════════════════════════════

  bool get flashOnPageChange => _getBool('flash_on_page_change');
  set flashOnPageChange(bool v) => _setBool('flash_on_page_change', v);

  int get flashDurationMillis => _getInt('flash_duration_millis', 100);
  set flashDurationMillis(int v) => _setInt('flash_duration_millis', v);
}
