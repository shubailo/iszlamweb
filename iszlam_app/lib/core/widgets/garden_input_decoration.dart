import 'package:flutter/material.dart';
import '../theme/garden_palette.dart';

/// Shared [InputDecoration] factory for consistent form styling across admin screens.
class GardenInputDecoration {
  GardenInputDecoration._();

  static InputDecoration standard({
    required String label,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: GardenPalette.charcoal),
      filled: true,
      fillColor: GardenPalette.offWhite,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: GardenPalette.lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: GardenPalette.leafyGreen, width: 2),
      ),
      suffixIcon: suffixIcon,
    );
  }
}
