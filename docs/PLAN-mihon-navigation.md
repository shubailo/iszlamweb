# Plan: Mihon Navigation Update

This plan outlines the steps to update the mobile navigation bar to match the Mihon app's Material 3 aesthetics and implement animated icons for "Library" and "More".

## Project Type: MOBILE (Flutter)

## Success Criteria
- [ ] Navigation bar matches Mihon's Material 3 design (80dp height, solid background, pill indicator).
- [ ] "Library" icon performs a path-morphing-like animation when selected.
- [ ] "More" icon performs a "dots bouncing" animation when selected.
- [ ] Navigation functionality remains identical to current implementation.

## Tech Stack
- Flutter (existing)
- `flutter_animate` (for easy micro-animations)
- Custom `AnimatedWidget` for complex icon animations.

## Proposed Changes

### UI & Navigation
- **[MODIFY] [responsive_navigation_shell.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/layout/responsive_navigation_shell.dart)**:
    - Replace `_GlassBottomBar` with a new `_MihonBottomBar`.
    - Implement the Material 3 design tokens (height, padding, colors).
    - Integrate the new animated icon widgets.

### Icons & Animations
- **[NEW] [animated_library_icon.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/shared/widgets/animated_library_icon.dart)**:
    - Custom painter or composite widget to replicate Mihon's library entry animation.
- **[NEW] [animated_more_icon.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/shared/widgets/animated_more_icon.dart)**:
    - Widget representing three dots that animate vertically based on selection state.

## Task Breakdown

### Phase 1: Foundation & Research
- [ ] Analyze exact Mihon color palette from `references/mihon`.
- [ ] Extract path data for Library icon if doing custom painting.

### Phase 2: Implementation
- [ ] Create `AnimatedMoreIcon` widget with jumping dots animation.
- [ ] Create `AnimatedLibraryIcon` widget (using simplified path morphing or rotation/scaling to mimic effect).
- [ ] Replace `_GlassBottomBar` with `_MihonBottomBar` in `responsive_navigation_shell.dart`.
- [ ] Update theme/colors to match Mihon's M3 style.

### Phase 3: Verification
- [ ] Verify animations trigger correctly on tab switch.
- [ ] Verify responsive layout (isDesktop check still works).
- [ ] Check color contrast and accessibility.

## Phase X: Verification
- [ ] Run `flutter analyze`
- [ ] Manual test on emulator/device
- [ ] Verify no breaking changes in navigation shell
