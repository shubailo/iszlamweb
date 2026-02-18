import 'package:flutter/material.dart';

/// Raw color primitives. These are design tokens — NOT semantic.
/// Use [AppTheme] for semantic mapping (light vs dark).
class GardenPalette {
  GardenPalette._();

  // ── Greens ──
  static const Color leafyGreen = Color(0xFF43A047);     // Green 600 (Primary)
  static const Color lightGreen = Color(0xFF66BB6A);     // Green 400
  static const Color paleGreen = Color(0xFFA5D6A7);      // Green 200
  static const Color deepGreen = Color(0xFF2E7D32);      // Green 800
  static const Color midnightGreen = Color(0xFF0C1B1A);  // Dark forest (for dark theme)

  // ── Neutrals ──
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF757575);
  static const Color charcoal = Color(0xFF424242);
  static const Color nearBlack = Color(0xFF212121);

  // ── Accents ──
  static const Color amber = Color(0xFFB28900);
  static const Color gold = Color(0xFFD4AF37);
  static const Color paleGold = Color(0xFFF5E6C4);

  // ── Status ──
  static const Color errorRed = Color(0xFFD32F2F);

  // ── Gradients ──
  static const LinearGradient greenGradient = LinearGradient(
    colors: [leafyGreen, deepGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGreenGradient = LinearGradient(
    colors: [leafyGreen, lightGreen],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ═══════════════════════════════════════════════════════
  // LEGACY ALIASES — kept so 30+ files don't need renaming.
  // These map to LIGHT theme values.
  // TODO: Migrate widgets to Theme.of(context), then remove.
  // ═══════════════════════════════════════════════════════
  static const Color midnightForest = white;        // Background
  static const Color velvetNavy = offWhite;          // Surface / Card
  static const Color obsidian = lightGrey;           // Subtle depth
  static const Color emeraldTeal = leafyGreen;       // Primary accent
  static const Color vibrantEmerald = lightGreen;    // Secondary accent
  static const Color gildedGold = leafyGreen;        // Was gold, now green (monochrome)
  static const Color shimmerGold = paleGreen;         // Was gold shimmer
  static const Color royalNavy = lightGrey;           // Dividers
  static const Color ivory = nearBlack;               // Primary text
  static const Color mutedSilver = darkGrey;          // Secondary text
  static const Color warningRed = errorRed;
  static const Color glassWhite = Color(0x08000000);  // Subtle overlay
  static const Color glassText = nearBlack;           // Overlay text

  static const LinearGradient deepDepthGradient = greenGradient;
  static const LinearGradient vibrantEmeraldGradient = subtleGreenGradient;
  static const LinearGradient goldShimmerGradient = subtleGreenGradient;
}
