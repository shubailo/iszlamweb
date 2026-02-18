# 🧠 Brainstorm: PDF Reader Improvements (from References)

## Context

Our current PDF reader (`BookReaderScreen`) uses `pdfrx` with a basic overlay (page counter, close button). The `references/` folder contains **mihon** (manga reader, Kotlin), **Kotatsu** (manga reader, Kotlin), and **Mi-raj** (Islamic app, Flutter). These apps have battle-tested reader UX patterns we can adapt.

---

## Findings from Reference Code

### 📍 mihon — `ReaderContentOverlay.kt`
A composable brightness/color tint overlay that draws a semi-transparent canvas over the reading area.
- Supports brightness range -100 to +100
- Supports custom color tint with BlendMode

**Takeaway:** We can implement a **Night Mode** overlay — a dark tint layer over the PDF with adjustable brightness. This is trivially portable to Flutter using `ColorFiltered` or a `Container` overlay.

---

### 📍 mihon — `ReaderPageActionsDialog.kt`
When a user long-presses a page, a bottom sheet with 4 actions appears:
- 📋 Set as Cover
- 📋 Copy to Clipboard
- 📤 Share
- 💾 Save

**Takeaway:** We should add a **long-press page context menu** with relevant actions: *Share Page*, *Save Page as Image*, *Bookmark Page*. This adds significant interactivity.

---

### 📍 mihon — `ReaderPageIndicator.kt`
A minimal page counter with **outlined text** (stroke + fill technique) for high contrast over any background.

**Takeaway:** Replace our basic `Text` page indicator with an **outlined page counter** that's always readable regardless of PDF page color.

---

### 📍 mihon — `ReaderSettingsDialog.kt`
A **3-tab modal** accessible while reading:
1. **Reading Mode** — vertical/horizontal scroll, right-to-left
2. **General** — orientation lock, animation style
3. **Color Filter** — brightness, sepia, custom tint

The dialog automatically removes its dim overlay when the Color Filter tab is active (so you can see the effect live).

**Takeaway:** We should build an **in-reader settings sheet** instead of navigating to a separate settings page. Tabs for: *View Mode*, *Display* (brightness, background), *Behavior* (auto-scroll).

---

### 📍 Kotatsu — `ReaderSettingsFragment.kt`
Comprehensive preference-based settings:
- **Zoom Mode**: Fit Center, Fit Width, Fit Height, etc.
- **Orientation Lock**: Auto, Free, Portrait, Landscape
- **Reader Animation**: Page flip style
- **Reader Background**: White, Black, Theme-based
- **Crop**: Whitespace removal
- **Tap Actions**: Configurable tap zones

**Takeaway:** From this we should prioritize: (1) **Zoom mode selector** (fit-width vs fit-page), (2) **Background color toggle** (white vs dark), (3) **Keep-screen-on** toggle.

---

### 📍 Mi-raj — `quran_page.dart`
Uses an `AnimationController` for subtle UI transitions and a calligraphy header widget.

**Takeaway:** We should add **auto-hide AppBar** with smooth animation (fade out after 3s, tap to show). This is a common immersive reading pattern.

---

## 💡 Recommendation — 3 Options

### Option A: "Immersive Reader" (Quick Wins)
Add the most impactful features from the references with minimal effort:
- ✅ Night Mode overlay (from mihon `ReaderContentOverlay`)
- ✅ Outlined page indicator (from mihon `ReaderPageIndicator`)
- ✅ Auto-hide AppBar (from Mi-raj `AnimationController`)

✅ **Pros:** High visual impact, low risk, 2-3 hours of work
❌ **Cons:** No deep interactivity yet
📊 **Effort:** Low

---

### Option B: "Interactive Reader" (Full Feature Set)
All of Option A plus rich interactivity:
- ✅ Everything in Option A
- ✅ In-reader settings bottom sheet (3 tabs: View / Display / Behavior)
- ✅ Zoom mode selector (fit-width, fit-page)
- ✅ Keep-screen-on toggle

✅ **Pros:** Premium reading experience matching established readers
❌ **Cons:** ~1 day of work, more testing needed
📊 **Effort:** Medium

---

### Option C: "Power Reader" (Full Pro)
All of Option B plus advanced features:
- ✅ Everything in Option B
- ✅ Long-press page actions (save page, share, bookmark)
- ✅ Configurable tap zones (tap left/right to page)
- ✅ Reading direction (LTR/RTL) for Arabic texts
- ✅ Auto-scroll mode

✅ **Pros:** Professional-grade, nothing on the market matches it
❌ **Cons:** 2-3 days of work, significant complexity
📊 **Effort:** High

---

## 💡 Recommendation

**Option B: "Interactive Reader"** — it gives the Premium reading feel with Night Mode, smart zoom, and an in-reader settings sheet. It takes the best patterns from mihon and Kotatsu without the complexity of configurable tap zones.

Start with Option A, then iterate into Option B once the quick wins are validated.

What direction would you like to explore?
