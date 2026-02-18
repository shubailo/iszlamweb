# Plan: Full Light Theme Migration (Option A)

## Overview
Migrate the entire app from dark "Sanctuary" aesthetic to a **light, Al Quran-inspired theme**. White/cream backgrounds, deep teal headers, dark text, gold/amber accents.

## Strategy: Palette Inversion in `garden_palette.dart`

Instead of editing ~30 files, we **redefine the semantic meaning** of existing color tokens. Every file already uses `GardenPalette.obsidian` for backgrounds and `GardenPalette.ivory` for text — we simply **swap their values**.

> [!IMPORTANT]
> This is still a **single-file change** to `garden_palette.dart`. The trick is inverting the dark↔light roles of the existing tokens so all screens inherit the new look automatically.

## Color Mapping

| Token | Current Value | → New Value | Role Change |
|-------|--------------|-------------|-------------|
| `obsidian` | `#0A0F0F` (near-black) | `#F5F5F0` (off-white) | Background: dark→light |
| `midnightForest` | `#0C1B1A` (dark green) | `#FAFAFA` (white-grey) | Scaffold BG: dark→light |
| `velvetNavy` | `#112222` (dark teal) | `#FFFFFF` (white) | Card surface: dark→light |
| `ivory` | `#F5F5F0` (off-white) | `#212121` (near-black) | Primary text: light→dark |
| `offWhite` | `#F8F9FA` | `#F0F0F0` | Subtle BG (stays light) |
| `mutedSilver` | `#C0C0C0` | `#757575` | Secondary text (darker for contrast) |
| `emeraldTeal` | `#00897B` | `#00695C` | Teal 800 (Al Quran header) |
| `vibrantEmerald` | `#2E7D32` | `#00796B` | Secondary teal |
| `gildedGold` | `#C5A059` | `#B28900` | Warmer amber |
| `shimmerGold` | `#E8D5A8` | `#F5E6C4` | Light gold |
| `royalNavy` | `#1A3333` | `#E0E0E0` | Border/divider: dark→light grey |
| `glassWhite` | `#33FFFFFF` | `#22000000` | Glass overlay: white→black tint |
| `glassText` | `#FFFFFF` | `#212121` | Glass text: white→dark |

### Gradient Updates
| Gradient | New Colors |
|----------|-----------|
| `deepDepthGradient` | `#00695C` → `#00796B` → `#004D40` (teal header gradient) |
| `vibrantEmeraldGradient` | `#26A69A` → `#00897B` → `#00695C` |
| `goldShimmerGradient` | Stays gold-to-shimmer (auto-uses new values) |

## Files Modified

#### [MODIFY] [garden_palette.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/theme/garden_palette.dart)
- Invert all 13 color constants
- Update 2 gradients (deepDepth becomes teal header, not dark BG)

> [!NOTE]
> Because the `deepDepthGradient` was used for dark header backgrounds, after inversion it should become the **teal header gradient** (Al Quran's `#00695C` → `#004D40` teal band).

## Verification

1. `flutter analyze` — confirm no issues
2. Hot restart → visually check:
   - **Home screen**: White/cream background, dark text, teal header
   - **More screen**: White cards, dark text, teal accents
   - **Prayer screen**: Teal header with countdown, white list background
   - **Library screen**: White background, dark text
   - **Bottom nav bar**: Should auto-adapt to light surface
3. Check all text remains readable (dark-on-light contrast)
