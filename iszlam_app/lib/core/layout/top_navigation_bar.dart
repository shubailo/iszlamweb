import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../theme/garden_palette.dart';
import '../localization/hungarian_strings.dart';

class TopNavigationBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const TopNavigationBar({super.key, required this.navigationShell});

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: GardenPalette.midnightForest,
        border: Border(
          bottom: BorderSide(
            color: GardenPalette.emeraldTeal.withValues(alpha: 0.12),
          ),
        ),
      ),
      child: Row(
        children: [
          // Logo
          Text(
            'Iszlam.com',
            style: GoogleFonts.playfairDisplay(
              color: GardenPalette.gildedGold,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          _NavButton(
            label: H.worship,
            icon: Icons.mosque,
            isSelected: navigationShell.currentIndex == 0,
            onTap: () => _goBranch(0),
          ),
          const SizedBox(width: 24),
          _NavButton(
            label: H.myCommunity,
            icon: Icons.people,
            isSelected: navigationShell.currentIndex == 1,
            onTap: () => _goBranch(1),
          ),
          const SizedBox(width: 24),
          _NavButton(
            label: H.library,
            icon: Icons.local_library,
            isSelected: navigationShell.currentIndex == 2,
            onTap: () => _goBranch(2),
          ),
          const SizedBox(width: 24),
          _NavButton(
            label: H.more,
            icon: Icons.menu,
            isSelected: navigationShell.currentIndex == 3,
            onTap: () => _goBranch(3),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? GardenPalette.emeraldTeal.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? GardenPalette.emeraldTeal
                  : GardenPalette.ivory.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isSelected
                    ? GardenPalette.emeraldTeal
                    : GardenPalette.ivory.withValues(alpha: 0.5),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
