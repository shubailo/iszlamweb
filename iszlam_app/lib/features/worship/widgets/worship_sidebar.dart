import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../providers/worship_view_provider.dart';

/// Reddit-style sidebar for the Worship feature.
/// Used as `Scaffold.drawer` on mobile, permanent panel on desktop.
class WorshipSidebar extends ConsumerWidget {
  final VoidCallback? onItemTap;

  const WorshipSidebar({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(worshipViewProvider);

    return Container(
      width: 260,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text(
                'HITÉLET',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: GardenPalette.leafyGreen,
                ),
              ),
            ),

            // Sanctuary (Dashboard)
            _SidebarItem(
              icon: Icons.home_outlined,
              label: 'Imaidők',
              isSelected: selected == WorshipView.sanctuary,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.sanctuary);
                onItemTap?.call();
              },
            ).animate().fadeIn(duration: 300.ms),

            const _SidebarDivider(),

            // Features section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Text(
                'ESZKÖZÖK',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: GardenPalette.darkGrey,
                ),
              ),
            ),

            _SidebarItem(
              icon: Icons.auto_stories_outlined,
              label: H.quran,
              isSelected: selected == WorshipView.quran,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.quran);
                onItemTap?.call();
              },
            ).animate().fadeIn(delay: 60.ms, duration: 300.ms).slideX(begin: -0.08, end: 0),

            _SidebarItem(
              icon: Icons.menu_book_outlined,
              label: H.duas,
              isSelected: selected == WorshipView.duas,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.duas);
                onItemTap?.call();
              },
            ).animate().fadeIn(delay: 120.ms, duration: 300.ms).slideX(begin: -0.08, end: 0),

            _SidebarItem(
              icon: Icons.explore_outlined,
              label: H.qibla,
              isSelected: selected == WorshipView.qibla,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.qibla);
                onItemTap?.call();
              },
            ).animate().fadeIn(delay: 180.ms, duration: 300.ms).slideX(begin: -0.08, end: 0),

            _SidebarItem(
              icon: Icons.star_outline,
              label: 'Allah 99 Neve',
              isSelected: selected == WorshipView.names99,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.names99);
                onItemTap?.call();
              },
            ).animate().fadeIn(delay: 240.ms, duration: 300.ms).slideX(begin: -0.08, end: 0),

            _SidebarItem(
              icon: Icons.radio_button_checked_outlined,
              label: H.tasbih,
              isSelected: selected == WorshipView.tasbih,
              onTap: () {
                ref.read(worshipViewProvider.notifier).select(WorshipView.tasbih);
                onItemTap?.call();
              },
            ).animate().fadeIn(delay: 300.ms, duration: 300.ms).slideX(begin: -0.08, end: 0),

            const Spacer(),

            // Missed prayers button

          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? GardenPalette.leafyGreen.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? GardenPalette.leafyGreen : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? GardenPalette.leafyGreen : GardenPalette.darkGrey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? GardenPalette.nearBlack
                      : GardenPalette.nearBlack.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarDivider extends StatelessWidget {
  const _SidebarDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: Divider(
        height: 1,
        color: GardenPalette.lightGrey,
      ),
    );
  }
}
