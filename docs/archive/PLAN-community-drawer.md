# Plan: Reddit-Style Community Layout

## Goal
Refactor `MyCommunityScreen` to use a "Reddit-style" layout: a main feed with a side drawer (mobile) or persistent sidebar (desktop) for navigation between communities.

---

## Phase 1: State Management
### [NEW] `lib/features/community/providers/community_navigation_provider.dart`
- `CommunityNavigationState`: Holds selected community ID (or `null` for "All") and view mode (Feed, Events, About).
- `CommunityNavigationNotifier`: Actions to select community, switch view, join new.

## Phase 2: Sidebar Component
### [NEW] `lib/features/community/widgets/community_sidebar.dart`
- **Header**: "Közösségeim"
- **List Item**: "Összes" (All) - default
- **Section**: "Mecsetek" (list of joined mosques)
- **Section**: "Csoportok" (list of joined groups)
- **Footer Button**: "+ Felfedezés" (opens Discover modal/screen)
- **Styling**: Dark theme (`midnightForest`), gold selection indicator.

## Phase 3: Screen Refactor
### [MODIFY] `lib/features/community/screens/my_community_screen.dart`
- **Structure**:
  - `Scaffold` with `appBar` leading icon:
    - Mobile: Menu icon (opens `Drawer`)
    - Desktop: Hidden (sidebar is permanent)
  - `body`: Row (Desktop) or just Feed (Mobile)
    - **Desktop**: `CommunitySidebar` (250px) + Vertical Divider + Feed Area
    - **Mobile**: `CommunitySidebar` is passed to `Scaffold.drawer`

- **AppBar Title**: Dynamic based on selected community (e.g., "Mecset 1" or "Közösségem")
- **Actions**: Filter/More buttons relevant to the *selected* community.

## Phase 4: Feed Logic
### [MODIFY] `lib/features/community/screens/community_feed_screen.dart`
- Watch `CommunityNavigationState`.
- If "All" selected -> Show combined feed (current behavior).
- If specific ID selected -> Filter feed by that ID.

## Phase 5: Verification
- [ ] Mobile: Hamburger menu opens drawer.
- [ ] Desktop: Sidebar visible on left.
- [ ] Selection updates feed content.
- [ ] "Discover" button works.
