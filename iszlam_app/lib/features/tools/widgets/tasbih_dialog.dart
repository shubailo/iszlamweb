import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';

class TasbihDialog extends StatefulWidget {
  const TasbihDialog({super.key});

  @override
  State<TasbihDialog> createState() => _TasbihDialogState();
}

class _TasbihDialogState extends State<TasbihDialog> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 300,
        decoration: BoxDecoration(
          color: GardenPalette.midnightForest,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: GardenPalette.gildedGold.withAlpha(80)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(60),
              blurRadius: 30,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DIGITÁLIS TASZBIH',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: GardenPalette.gildedGold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => setState(() => count++),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: GardenPalette.velvetNavy,
                    border: Border.all(
                        color: GardenPalette.gildedGold.withAlpha(50)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: GardenPalette.gildedGold.withAlpha(15),
                          blurRadius: 30)
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$count',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 54,
                      color: GardenPalette.nearBlack,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('BEZÁRÁS',
                        style: GoogleFonts.outfit(
                            color: GardenPalette.mutedSilver,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => count = 0),
                    child: Text('VISSZAÁLLÍTÁS',
                        style: GoogleFonts.outfit(
                            color: GardenPalette.gildedGold,
                            fontSize: 11,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
