# PLAN: Sanctuary and Navigation Restructuring

## Goal Description
Enhance the Sanctuary page by moving daily quotes to the top and conditionally showing user activity vs. a full prayer timetable based on auth state. Restructure global navigation tab orders for different platforms (Desktop vs. Mobile) and set the initial landing page to Community.

## Proposed Changes

### [Navigation & Routing]

#### [MODIFY] [app_router.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/routing/app_router.dart)
- Change `initialLocation` to `/community` (applies after onboarding).
- Keep branch indices as is (0: Sanctuary, 1: Community, 2: Library, 3: More) but handle visual reordering in UI components.

#### [MODIFY] [top_navigation_bar.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/layout/top_navigation_bar.dart)
- Reorder navigation buttons for Desktop: 
    1. Community (Branch 1)
    2. Library (Branch 2)
    3. Sanctuary (Branch 0)
    4. More (Branch 3)

#### [MODIFY] [responsive_navigation_shell.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/layout/responsive_navigation_shell.dart)
- Ensure mobile bottom bar remains in the order: [Sanctuary, Community, Library, More].

### [Worship / Sanctuary]

#### [MODIFY] [sanctuary_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/worship/screens/sanctuary_screen.dart)
- Move `DailyInspirationCard` to the top of the `CustomScrollView`.
- Detect auth state using `ref.watch(authStreamProvider)`.
- If logged in: Show "My Journey" (Hero + Stats).
- If guest: Show full Prayer Timetable (reusing `PrayerTimesScreen` components).

## Verification Plan

### Manual Verification
- Verify initial landing on Community Feed (after onboarding).
- Check Desktop tab order: [Közösség, Könyvtár, Hit élet, Több].
- Check Mobile tab order: [Hit élet, Közösség, Könyvtár, Több].
- Test Guest view: Sanctuary page should display the full prayer timetable.
- Test Logged-in view: Sanctuary page should display Daily Quote (top) -> My Journey Hero -> Stats.
