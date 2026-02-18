# Plan: Layout Consolidation + Shared Components

## Goal
Consolidate navigation from 5 tabs → 4 tabs, merge Community + Discover, and create shared dark-themed components.

---

## Phase 1: Shared Component Library

> [!IMPORTANT]
> Create reusable widgets FIRST so all screens use them consistently.

### [NEW] `lib/core/widgets/garden_card.dart`
- Dark glassmorphic card (`midnightForest` 40% opacity, emerald border 8%)
- Used by: Community, Library, Discover content

### [NEW] `lib/core/widgets/garden_section_header.dart`
- Gold label text, optional icon, optional "View All" action
- Replaces per-screen `_buildSectionHeader()` methods

### [NEW] `lib/core/widgets/garden_search_bar.dart`
- Dark search field with emerald accent
- Used by: merged Community/Discover, Quran search

### [NEW] `lib/core/widgets/garden_empty_state.dart`
- Dark empty state with emerald icon, ivory text
- Replaces per-screen empty states

---

## Phase 2: Navigation Consolidation (5 → 4 tabs)

### New Tab Structure
| # | Tab | Content | Route |
|---|-----|---------|-------|
| 1 | **Szentély** | Worship dashboard (unchanged) | `/` |
| 2 | **Közösség** | Merged Community + Discover | `/community` |
| 3 | **Könyvtár** | Library (unchanged) | `/library` |
| 4 | **Több** | Settings + account | `/more` |

### [MODIFY] `lib/core/layout/responsive_navigation_shell.dart`
- Remove 5th tab (More icon → 4 items)
- Update `_items` list to 4 entries

### [MODIFY] `lib/core/layout/top_navigation_bar.dart`
- Remove 5th `_NavButton`

### [MODIFY] `lib/main.dart`
- Remove the `Discover` branch from `StatefulShellRoute`
- Rename `my-community` route to `/community`

---

## Phase 3: Merge Community + Discover

### [MODIFY] `lib/features/community/screens/my_community_screen.dart`
- **Background**: `GardenPalette.obsidian`
- **Tabs**: Add 2 new tabs: "Felfedezés" (Discover) and "Közeli" (Nearby)
- Absorb Discover's featured carousel, mosque browser, and resources grid
- Use shared `GardenCard`, `GardenSectionHeader`, `GardenSearchBar`
- Dark tab bar (gold indicator, velvet background)
- Final tab list: `Hírfolyam | Mecsetek | Események | Felfedezés`

### [DELETE] `lib/features/discovery/screens/discover_screen.dart`
- Content absorbed into Community tabs

---

## Phase 4: Dark Theme — Community & Cards

### [MODIFY] `_CommunityCard` (inside `my_community_screen.dart`)
- Replace white `Card` → `GardenCard`
- Text: ivory titles, muted subtitles
- Loading spinners: emerald

### [MODIFY] Empty states
- Replace inline empty states → `GardenEmptyState`

---

## Phase 5: Verification
- [ ] `flutter analyze` passes
- [ ] 4 tabs visible in bottom bar
- [ ] Community screen shows merged content (Feed, Mosques, Events, Discover)
- [ ] All screens use obsidian background
- [ ] No orphan imports to `discover_screen.dart`
- [ ] Shared widgets render consistently
