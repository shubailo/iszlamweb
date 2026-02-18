import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/garden_palette.dart';

/// Consistent inline error display widget.
class GardenErrorView extends StatelessWidget {
  final String message;

  const GardenErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          message,
          style: GoogleFonts.outfit(color: GardenPalette.errorRed),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
