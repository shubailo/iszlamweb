# Protocol: UI Unification (Royal Garden)

## Goal
Unify the application's design under the "Royal Garden" theme (Deep Emerald, Gold, Obsidian), eliminating standard Material Design elements in favor of a premium, spiritual aesthetic.

## Scope
- **Navigation**: Custom Bottom Bar with glassmorphism and animated icons.
- **Library**: Redesign `LibraryScreen` to match `QuranScreen` (dark background, custom cards).
- **More**: Redesign `MoreScreen` to match the dashboard aesthetic.
- **Typography**: Enforce `GoogleFonts.playfairDisplay` for headers and `GoogleFonts.outfit` for UI text.

## Phase 1: Navigation Redesign
### [MODIFY] [scaffold_with_nav_bar.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/navigation/scaffold_with_nav_bar.dart)
- Remove standard `NavigationBar`.
- Implement a floating, glassmorphic bottom bar.
- Use `GardenPalette.midnightForest.withOpacity(0.9)` as base.
- Active items: Emerald Glow + Gold Icon.
- Inactive items: Ivory with 50% opacity.

## Phase 2: Library Overhaul
### [MODIFY] [library_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/library/screens/library_screen.dart)
- **Background**: `GardenPalette.obsidian` or `deepDepthGradient`.
- **AppBar**: Custom SliverAppBar with `GardenPalette.midnightForest`.
- **Tabs**: Custom tab indicators (Gold underline or pill shape).
- **Book List**:
  - Replace `ListTile` with custom `BookCard` widget.
  - Dark container color (`midnightForest` with opacity).
  - Cover art placeholder with Islamic geometric pattern if missing.
  - Typography: White text, gold author name.

## Phase 3: "More" Screen Update
### [MODIFY] [more_screen.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/features/more/screens/more_screen.dart)
- **Header**: Large "Beállítások" text in Playfair Display (Gold).
- **List Items**:
  - Custom tiles with subtle dark gradients.
  - Icons in Emerald circles.
  - Remove standard dividers; use spacing or subtle borders.

## Phase 4: Verification
- Verify visibility of text on dark backgrounds.
- Check navigation responsiveness on mobile vs web.
- Ensure performant routing with the new bottom bar.
