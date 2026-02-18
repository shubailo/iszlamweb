# PLAN: Mihon Reader Integration

Replicate the comprehensive reader and settings experience from the Mihon (formerly Tachiyomi) ecosystem within our Flutter application. This plan covers all reading modes, deep configuration options, and navigation adjustments requested.

## User Review Required

> [!IMPORTANT]
> **Reading Mode Migration**
> We are moving from a single-mode PDF reader to a multi-mode architecture (Paged LTR/RTL, Vertical, and Webtoon). Some settings (like `zoomMode`) might behave differently in Webtoon mode.

> [!NOTE]
> **Navigation Bar Behavior**
> On mobile, the app's main `navigationBar` will be programmatically hidden upon entering `BookReaderScreen` to maximize immersion, and restored upon exit.

---

## 🎯 Success Criteria
- [ ] **Reading Modes**: Fully functional LTR, RTL, Vertical, and Webtoon views.
- [ ] **Settings Parity**: All 20+ Mihon preference flags integrated into our Settings Panel.
- [ ] **Visual Filters**: Real-time Grayscale and Inversion filters for PDF content.
- [ ] **Navigation**: Customizable tap-zones and Volume Key page turns.
- [ ] **Seamless Experience**: Bottom bar auto-hiding on mobile.

---

## 📋 Task Breakdown

### Phase 0: Foundation & State (P0)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T0.1 | Expand `ReaderPreferences` | `mobile-developer` | `clean-code` | Add all missing Mihon flags (orientation, transitions, etc.) to `ReaderPreferences` service. |
| T0.2 | Bottom Bar visibility logic | `mobile-developer` | `clean-code` | Implement a way to toggle the main app's NavigationBar visibility when in the Reader. |

### Phase 1: Rendering Engine (Reading Modes) (P1)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T1.1 | Implement Layout Switching | `mobile-developer` | `clean-code` | Update `PdfViewerParams` to swap `layoutPages` dynamically between Paged and Column (Webtoon) layouts. |
| T1.2 | Orientation & Cutout Support | `mobile-developer` | `clean-code` | Add support for locking orientation and drawing under device cutouts. |

### Phase 2: UI & Settings Sheet (P1)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T2.1 | Settings Sheet Expansion | `mobile-developer` | `frontend-design` | Add a third tab ("Filter") and expand existing tabs to accommodate the full list of Mihon options. |
| T2.2 | Visual Filters Implementation | `mobile-developer` | `clean-code` | Wrap `PdfViewer` in a `ColorFiltered` widget controlled by the new settings. |

### Phase 3: Advanced Controls (P2)
| Task ID | Name | Agent | Skills | INPUT → OUTPUT → VERIFY |
|---------|------|-------|--------|-------------------------|
| T3.1 | Customizable Tap Zones | `mobile-developer` | `clean-code` | Implement multiple navigation presets (Default, Kindle-ish, Edge-only). |
| T3.2 | Volume Key Support | `mobile-developer` | `clean-code` | Listen for hardware volume button events to trigger page turns. |

---

## 🛠️ Tech Stack
- **PDF Engine**: `pdfrx`
- **State**: Riverpod + `ReaderPreferences`
- **Persistence**: `shared_preferences`
- **Hardware**: `services` (for Volume hooks)

---

## 🧪 Phase X: Final Verification
- [ ] Verify Paged vs Webtoon mode rendering.
- [ ] Verify Grayscale and Invert filters work on light/dark mode.
- [ ] Verify Bottom Bar hides and reappears correctly on navigation.
- [ ] Verify all new settings in `ReaderPreferences` persist across app restarts.
