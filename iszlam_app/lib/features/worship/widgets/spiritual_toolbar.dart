import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';

class SpiritualToolbar extends StatelessWidget {
  const SpiritualToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110, // Fixed height for the toolbar row
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        children: [
          _ToolCard(
            label: 'Tasbih',
            icon: Icons.grid_goldenratio, // Abstract beads icon
            onTap: () {
              showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel: 'Tasbih',
                pageBuilder: (c, a1, a2) => const _SimpleTasbihDialog(),
              );
            },
          ),
          const SizedBox(width: 14),
          _ToolCard(
            label: 'Qibla',
            icon: Icons.explore,
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kibla irány hamarosan!')));
            },
          ),
          const SizedBox(width: 14),
          _ToolCard(
            label: 'Quran',
            icon: Icons.menu_book,
            onTap: () {},
          ),
          const SizedBox(width: 14),
          _ToolCard(
            label: 'Mecsetek',
            icon: Icons.mosque,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ToolCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ToolCard({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        border: Border.all(color: GardenPalette.lightGrey.withAlpha(100), width: 0.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: GardenPalette.leafyGreen, size: 28),
              const SizedBox(height: 10),
              Text(
                label.toUpperCase(), 
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, 
                  fontSize: 11, 
                  color: GardenPalette.nearBlack,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimpleTasbihDialog extends StatefulWidget {
  const _SimpleTasbihDialog();

  @override
  State<_SimpleTasbihDialog> createState() => _SimpleTasbihDialogState();
}

class _SimpleTasbihDialogState extends State<_SimpleTasbihDialog> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        width: 300,
        decoration: BoxDecoration(
          color: GardenPalette.white,
          border: Border.all(color: GardenPalette.leafyGreen.withAlpha(100)),
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
                  color: GardenPalette.leafyGreen,
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
                    color: GardenPalette.offWhite,
                    border: Border.all(color: GardenPalette.leafyGreen.withAlpha(60)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: GardenPalette.leafyGreen.withAlpha(20), blurRadius: 30)
                    ]
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
                    child: Text('BEZÁRÁS', style: GoogleFonts.outfit(color: GardenPalette.darkGrey, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                  TextButton(
                    onPressed: () => setState(() => count = 0),
                    child: Text('VISSZAÁLLÍTÁS', style: GoogleFonts.outfit(color: GardenPalette.leafyGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
