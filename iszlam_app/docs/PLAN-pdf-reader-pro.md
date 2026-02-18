# PLAN: PDF Reader Pro (Phased Enhancement)

Progressively upgrade `BookReaderScreen` from a basic PDF viewer into a premium, immersive reading experience. Inspired by mihon, Kotatsu, and Mi-raj reference code.

> [!IMPORTANT]
> Each phase builds on the previous one. Phase A can ship independently.

---

## Phase A: Immersive Reader (Quick Wins)

| # | Task | What Changes | Reference |
|---|------|-------------|-----------|
| A1 | **Night Mode Overlay** | Add a `Container` overlay with adjustable opacity + sepia tint. Toggle via moon icon in AppBar. Persist preference with `SharedPreferences`. | mihon `ReaderContentOverlay.kt` |
| A2 | **Outlined Page Indicator** | Replace plain `Text('$page / $total')` with a dual-layer text widget (stroke + fill) for contrast on any background. Move indicator to a floating center-bottom position. | mihon `ReaderPageIndicator.kt` |
| A3 | **Auto-Hide Overlay** | Use `AnimationController` to fade out the AppBar and bottom bar after 3 seconds of inactivity. Tap anywhere to toggle. Replace current `_isOverlayVisible` bool with animated opacity. | Mi-raj `quran_page.dart` |

### Files Modified
- [MODIFY] [book_reader_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/screens/book_reader_screen.dart) — All 3 tasks modify this file

### Verification
- [ ] Night mode toggle darkens the reading area
- [ ] Page indicator is readable on both white and dark PDF pages
- [ ] Overlay auto-hides after 3s, reappears on tap

---

## Phase B: Interactive Reader (Settings & Zoom)

| # | Task | What Changes | Reference |
|---|------|-------------|-----------|
| B1 | **In-Reader Settings Sheet** | Create a `showModalBottomSheet` with 2 tabs: **Display** (night mode slider, sepia toggle, background color) and **Behavior** (keep-screen-on toggle, scroll direction). | mihon `ReaderSettingsDialog.kt` |
| B2 | **Zoom Mode Selector** | Add fit-width / fit-page toggle to the settings sheet. Map to `pdfrx` controller's `setZoom` or layout params. | Kotatsu `ReaderSettingsFragment.kt` |
| B3 | **Keep Screen On** | Add `WakelockPlus` dependency. Toggle via settings sheet. Persist preference. | Kotatsu `ReaderSettingsFragment.kt` |
| B4 | **Page Slider** | Add a `Slider` widget to the bottom bar for quick navigation between pages. Wire to `_pdfController.goToPage()`. | General UX pattern |

### Files Modified / Created
- [MODIFY] [book_reader_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/screens/book_reader_screen.dart)
- [NEW] [reader_settings_sheet.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/widgets/reader_settings_sheet.dart) — Bottom sheet widget
- [NEW] [reader_preferences.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/services/reader_preferences.dart) — SharedPreferences wrapper

### Verification
- [ ] Settings sheet opens from the AppBar gear icon
- [ ] Night mode brightness slider adjusts overlay intensity in real-time
- [ ] Fit-width / fit-page toggles correctly
- [ ] Keep-screen-on prevents display sleep
- [ ] Page slider accurately navigates to selected page

---

## Phase C: Power Reader (Advanced Features)

| # | Task | What Changes | Reference |
|---|------|-------------|-----------|
| C1 | **Page Actions Menu** | Long-press on a page shows a bottom sheet: *Bookmark Page*, *Share Page*, *Save as Image*. | mihon `ReaderPageActionsDialog.kt` |
| C2 | **Tap Zones** | Divide screen into 3 vertical zones: left tap = previous page, center tap = toggle overlay, right tap = next page. | Kotatsu tap actions grid |
| C3 | **RTL Reading Direction** | Add a right-to-left toggle in settings for Arabic/Hebrew texts. Reverses page navigation and swipe direction. | Kotatsu `ReaderMode` |
| C4 | **Auto-Scroll Mode** | Timer-based auto-scroll with configurable speed (slow/medium/fast). Toggle via FAB. | General UX pattern |

### Files Modified / Created
- [MODIFY] [book_reader_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/screens/book_reader_screen.dart)
- [MODIFY] [reader_settings_sheet.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/widgets/reader_settings_sheet.dart) — Add RTL toggle
- [NEW] [page_actions_sheet.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/widgets/page_actions_sheet.dart) — Long-press action sheet

### Verification
- [ ] Long-press shows page action menu with working Share/Save/Bookmark
- [ ] Tap zones correctly map to previous/toggle/next
- [ ] RTL mode reverses navigation direction
- [ ] Auto-scroll smoothly advances pages at chosen speed

---

## Phase X: Final Verification

- [ ] All Phase A features working in isolation
- [ ] Phase B settings sheet properly persists and restores preferences
- [ ] Phase C features don't conflict with Phase A/B gestures
- [ ] `flutter analyze` passes with no issues
- [ ] Existing EPUB reader and Markdown reader are unaffected
