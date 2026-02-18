import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../admin_tools/screens/admin_upload_book_screen.dart';

class AdminAddCard extends StatelessWidget {
  const AdminAddCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminUploadBookScreen()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: GardenPalette.leafyGreen.withAlpha(50),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GardenPalette.leafyGreen.withAlpha(30),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  color: GardenPalette.leafyGreen,
                  size: 32,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'ÚJ TARTALOM',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: GardenPalette.leafyGreen,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
