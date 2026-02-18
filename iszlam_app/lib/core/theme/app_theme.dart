import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'garden_palette.dart';

class AppTheme {
  AppTheme._();

  // Compatibility getter
  static const Color primaryGold = GardenPalette.leafyGreen;

  static TextStyle get headlineMedium => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: GardenPalette.leafyGreen,
      );

  // ═══════════════════════════════════════
  //  LIGHT THEME (Active — Al Quran Style)
  // ═══════════════════════════════════════
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: GardenPalette.white,
      primaryColor: GardenPalette.leafyGreen,

      colorScheme: const ColorScheme.light(
        primary: GardenPalette.leafyGreen,
        onPrimary: GardenPalette.white,
        secondary: GardenPalette.lightGreen,
        onSecondary: GardenPalette.white,
        surface: GardenPalette.white,
        onSurface: GardenPalette.nearBlack,
        surfaceContainerHigh: GardenPalette.offWhite,
        error: GardenPalette.errorRed,
        onError: GardenPalette.white,
      ),

      // Typography — ALL dark text on light backgrounds
      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: GardenPalette.nearBlack,
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: GardenPalette.leafyGreen,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: GardenPalette.nearBlack,
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 17,
          color: GardenPalette.nearBlack,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 15,
          color: GardenPalette.darkGrey,
        ),
        labelSmall: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: GardenPalette.darkGrey,
          letterSpacing: 1.5,
        ),
      ),

      // AppBar — transparent with green text
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: GardenPalette.leafyGreen,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: GardenPalette.leafyGreen,
        ),
      ),

      // Cards — white with subtle shadow
      cardTheme: CardThemeData(
        color: GardenPalette.white,
        elevation: 2,
        shadowColor: Colors.black.withAlpha(15),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          side: BorderSide(color: GardenPalette.lightGrey, width: 0.5),
        ),
      ),

      // Buttons — green
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GardenPalette.leafyGreen,
          foregroundColor: GardenPalette.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // Navigation Bar — white with green indicators
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: GardenPalette.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: GardenPalette.leafyGreen.withAlpha(30),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: GardenPalette.leafyGreen);
          }
          return const IconThemeData(color: GardenPalette.grey);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: GardenPalette.leafyGreen,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: GardenPalette.grey,
          );
        }),
      ),

      // Dividers
      dividerTheme: const DividerThemeData(
        color: GardenPalette.lightGrey,
        thickness: 1,
      ),
    );
  }

  // ═══════════════════════════════════════
  //  DARK THEME (Ready for future use)
  // ═══════════════════════════════════════
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: GardenPalette.midnightGreen,
      primaryColor: GardenPalette.gold,

      colorScheme: const ColorScheme.dark(
        primary: GardenPalette.gold,
        onPrimary: GardenPalette.midnightGreen,
        secondary: GardenPalette.leafyGreen,
        onSecondary: GardenPalette.white,
        surface: Color(0xFF112222),
        onSurface: Color(0xFFF5F5F0),
        surfaceContainerHigh: Color(0xFF1A2A2A),
        error: GardenPalette.errorRed,
        onError: GardenPalette.white,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.playfairDisplay(
          fontSize: 42,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFF5F5F0),
          letterSpacing: -1.5,
        ),
        displayMedium: GoogleFonts.playfairDisplay(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: GardenPalette.gold,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF5F5F0),
          letterSpacing: 0.5,
        ),
        bodyLarge: GoogleFonts.outfit(
          fontSize: 17,
          color: const Color(0xFFF5F5F0),
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.outfit(
          fontSize: 15,
          color: const Color(0xFFC0C0C0),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: GardenPalette.gold,
        elevation: 0,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          color: GardenPalette.gold,
        ),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF112222),
        elevation: 8,
        shadowColor: Colors.black.withAlpha(100),
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          side: BorderSide(color: GardenPalette.gold.withAlpha(30), width: 0.5),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xFF112222),
        indicatorColor: GardenPalette.gold.withAlpha(40),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: GardenPalette.gold);
          }
          return const IconThemeData(color: GardenPalette.grey);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: GardenPalette.gold,
            );
          }
          return GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: GardenPalette.grey,
          );
        }),
      ),
    );
  }

  // Legacy alias for old code that references darkGardenTheme
  static ThemeData get darkGardenTheme => darkTheme;
}
