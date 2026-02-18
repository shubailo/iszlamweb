import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/garden_palette.dart';

/// Light-themed search bar with green accent.
class GardenSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;

  const GardenSearchBar({
    super.key,
    this.hintText = 'Keresés...',
    this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Container(
        decoration: BoxDecoration(
          color: GardenPalette.offWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: GardenPalette.lightGrey,
          ),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: GoogleFonts.outfit(
            color: GardenPalette.nearBlack,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: GoogleFonts.outfit(
              color: GardenPalette.darkGrey,
              fontSize: 14,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: GardenPalette.leafyGreen.withValues(alpha: 0.6),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}
