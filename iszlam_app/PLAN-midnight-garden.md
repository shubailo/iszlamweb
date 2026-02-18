# PLAN: Midnight Garden UI Overhaul

Transform iszlam.com into a premium, immersive "Midnight Garden" experience using deep forest greens, sapphire navies, and shimmering gold accents.

## [OVERVIEW]
**Project Type:** MOBILE (Flutter Web/Android)
**Goal:** Replace the sterile "Sharp Emerald" look with a rich, ethereal dark theme featuring "Arched Portals" for content revelation.

## [TECH STACK]
- **Animation:** `flutter_animate` (Portals, shimmering gold shimmer)
- **Theming:** Custom `AppTheme` with `ThemeData` extensions for gilded variations.
- **Typography:** `Playfair Display` (Luxury Headers) + `Outfit` (Technical Readability).
- **Backend:** `supabase_flutter` (remains unchanged).

## [FILE STRUCTURE]
- `lib/core/theme/garden_palette.dart` [NEW] - Design tokens for the new palette.
- `lib/core/widgets/arched_portal.dart` [NEW] - Reusable reveal animation component.
- `lib/core/widgets/gilded_divider.dart` [NEW] - Stylized gold flourish.

## [TASK BREAKDOWN]

### Phase 1: Foundation (The Palette)
- **Task ID:** foundation_001
- **Name:** Implement Garden Palette Design Tokens
- **Agent:** `mobile-developer`
- **Skill:** `frontend-design`
- **Input:** Option C constraints.
- **Output:** `garden_palette.dart` with HSL-defined Forest Green, Deep Navy, and Gilded Gold.
- **Verify:** `flutter analyze` pass + color check.

### Phase 2: Core Atmosphere (The Portal)
- **Task ID:** portal_001
- **Name:** Build `ArchedPortal` Reveal Component
- **Agent:** `mobile-developer`
- **Skill:** `animation-guide`
- **Input:** "Aperture revelation" concept.
- **Output:** A custom widget using `ClipPath` (Arch shape) + `flutter_animate` for mask expansion.
- **Verify:** Visual confirmation of content "sliding/revealing" through the arch.

### Phase 3: Home Evolution
- **Task ID:** home_001
- **Name:** Refactor Home to "Midnight Garden"
- **Agent:** `mobile-developer`
- **Skill:** `frontend-design`
- **Output:** Updated `HomeScreen` & `DailyWisdomHero` with dark immersive backgrounds and portal effects.
- **Verify:** Matches Option C mock-up logic.

### Phase 4: Gilded Accents
- **Task ID:** polish_001
- **Name:** Implement Shimmering Gold Shaders
- **Agent:** `mobile-developer`
- **Skill:** `visual-effects`
- **Output:** `GildedFlourish` widget using gradients and linear shimmer animations for icons and borders.
- **Verify:** Gold elements feel "metallic" and alive.

## [PHASE X: VERIFICATION]
- [ ] No mesh gradients (Forbidden)
- [ ] No default blue (Forbidden)
- [ ] `ux_audit.py` passes for accessibility
- [ ] 0 issues in `flutter analyze`
- [ ] "Wow" factor confirmed by manual run
