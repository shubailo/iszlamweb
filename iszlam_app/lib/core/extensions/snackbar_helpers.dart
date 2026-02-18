import 'package:flutter/material.dart';
import '../theme/garden_palette.dart';

/// Convenience extension for showing styled snackbars.
extension SnackbarHelpers on BuildContext {
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: GardenPalette.leafyGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: GardenPalette.errorRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
