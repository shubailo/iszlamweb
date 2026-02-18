# Plan: Theme Infrastructure Refactor

## Goal
Properly separate design choices into `AppTheme` to allow for a future Dark Mode, while keeping the current "Simple Nature" light look active.

## Strategy

### 1. Refactor `GardenPalette` (The Primitives)
Instead of "magic" inverted tokens, we will define explicit **Primitives**.
*   **Primitives**: `pureWhite`, `offWhite`, `leafyGreen`, `deepTeal`, `black`, `grey700`.
*   **Legacy Aliases**: Keep `obsidian`, `ivory`, etc., pointing to **Light Primitives** so existing widgets stay light. mapping will be explicit.

### 2. Refactor `AppTheme` (The Configuration)
Define two distinct themes using the Primitives:
*   **`lightTheme`**: Uses `pureWhite` scaffold, `leafyGreen` primary.
*   **`darkTheme`**: Uses `midnightGreen` scaffold, `gold` primary (preserving the old "Sanctuary" look as the dark option).

### 3. Benefit
*   **Future-proof**: To enable dynamic switching later, we just need to replace `GardenPalette.obsidian` usage with `Theme.of(context).scaffoldBackgroundColor`.
*   **Clean Code**: No more "inverted meaning" confusion. `obsidian` in the palette will be marked as `@Deprecated('Use Theme.of(context) instead')` eventually.

## Files Modified

#### [MODIFY] [garden_palette.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/theme/garden_palette.dart)
- Define `Colors` (Primitives) like `leafyGreen`, `offWhite`
- Mark legacy semantic tokens as `@deprecated`

#### [MODIFY] [app_theme.dart](file:///c:/Users/shuba/Desktop/iszlamweb_app/iszlam_app/lib/core/theme/app_theme.dart)
- Define `lightTheme` with `ColorScheme.light` (Primary: Green, Surface: White, OnSurface: Black)
- Define `darkTheme` with `ColorScheme.dark` (Primary: Gold, Surface: Midnight, OnSurface: White)

#### [MIGRATE] [All Widgets]
- Replace `GardenPalette.midnightForest` → `Theme.of(context).scaffoldBackgroundColor`
- Replace `GardenPalette.velvetNavy` → `Theme.of(context).cardColor`
- Replace `GardenPalette.ivory` → `Theme.of(context).textTheme.bodyLarge.color` or `onSurface`
- **Crucial**: This fixes the "unreadable text" issue by ensuring text color automatically switches based on the background.

## Verification
1. `flutter analyze`
2. Hot restart - Verify text contrast is perfect (Black on White).
3. Switch theme mode in `main.dart` to test Dark Mode restoration.
