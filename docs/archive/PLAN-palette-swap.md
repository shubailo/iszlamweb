# Plan: Al Quran Palette Swap (Option B)

## Overview
Shift `GardenPalette` hex values to match Greentech Al Quran's warmer teal-green + muted amber palette. **Single-file change**, zero layout code modifications.

## Color Mapping

| Token | Current (Sanctuary) | → New (Al Quran) | Rationale |
|-------|--------------------|--------------------|-----------|
| `midnightForest` | `#042D24` | `#0C1B1A` | Al Quran dark green-black |
| `velvetNavy` | `#041022` | `#112222` | Warmer dark teal |
| `obsidian` | `#020408` | `#0A0F0F` | Teal-tinted depth |
| `emeraldTeal` | `#0DB69D` | `#00897B` | Al Quran's signature teal (Teal 600) |
| `vibrantEmerald` | `#06C270` | `#2E7D32` | Al Quran classic green |
| `gildedGold` | `#D4AF37` | `#C5A059` | Muted amber (Al Quran star/bookmark) |
| `shimmerGold` | `#F7E7CE` | `#E8D5A8` | Warmer shimmer |
| `royalNavy` | `#1B3B6F` | `#1A3333` | Teal-navy blend |
| `glassWhite` | `#33FFFFFF` | No change | |
| `ivory` | `#FDFCF0` | `#F5F5F0` | Slightly cooler off-white |
| `offWhite` | `#F8F9FA` | No change | |
| `mutedSilver` | `#C0C0C0` | No change | |
| `warningRed` | `#CF6679` | No change | |

### Gradient Updates
| Gradient | Change |
|----------|--------|
| `vibrantEmeraldGradient` | `#20C9B6` → `#26A69A`, plus new endpoint colors |
| `deepDepthGradient` | `#063A2E` → `#0D2B2B`, flows into new `midnightForest` |
| `goldShimmerGradient` | Uses new `gildedGold` + `shimmerGold` automatically |

## Files Modified

#### [MODIFY] [garden_palette.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/theme/garden_palette.dart)
- Update 8 color constants
- Update 2 gradient start colors

## Verification
1. `flutter analyze` — ensure no issues
2. Hot restart — visually inspect Home, Worship, More, Quran screens
3. Confirm gold accents, teal headers, depth gradients look cohesive
