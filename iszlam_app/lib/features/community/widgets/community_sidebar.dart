import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/mosque_provider.dart';
import '../providers/group_provider.dart';

/// Reddit-style sidebar listing joined communities.
/// Used as `Scaffold.drawer` on mobile, permanent panel on desktop.
class CommunitySidebar extends ConsumerWidget {
  final VoidCallback? onItemTap;

  const CommunitySidebar({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedMosqueIdProvider);
    final mosquesAsync = ref.watch(mosqueListProvider);

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
                'KÖZÖSSÉGEIM',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: GardenPalette.leafyGreen,
                ),
              ),
            ),

            // "All" option
            _SidebarItem(
              icon: Icons.home_outlined,
              label: 'Összes',
              isSelected: selectedId == null,
              onTap: () {
                ref.read(selectedMosqueIdProvider.notifier).update(null);
                onItemTap?.call();
              },
            ).animate().fadeIn(duration: 300.ms),

            const _SidebarDivider(),

            // Mosques section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Text(
                'MECSETEK',
                style: GoogleFonts.outfit(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: GardenPalette.darkGrey,
                ),
              ),
            ),

            // Mosque list
            mosquesAsync.when(
              data: (mosques) => Column(
                children: mosques
                    .asMap()
                    .entries
                    .map((e) => _SidebarItem(
                          icon: Icons.mosque_outlined,
                          label: e.value.name,
                          isSelected: selectedId == e.value.id,
                          onTap: () {
                            ref
                                .read(selectedMosqueIdProvider.notifier)
                                .update(e.value.id);
                            onItemTap?.call();
                          },
                        )
                            .animate()
                            .fadeIn(
                                delay: (e.key * 60).ms,
                                duration: 300.ms)
                            .slideX(begin: -0.08, end: 0))
                    .toList(),
              ),
              loading: () => Padding(
                padding: const EdgeInsets.all(20),
                child: LinearProgressIndicator(
                  backgroundColor: GardenPalette.lightGrey,
                  color: GardenPalette.leafyGreen,
                  minHeight: 2,
                ),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Hiba',
                    style: TextStyle(
                        color: GardenPalette.errorRed, fontSize: 12)),
              ),
            ),

            // Groups section (show for selected mosque)
            if (selectedId != null) ...[
              const _SidebarDivider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
                child: Text(
                  'CSOPORTOK',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                    color: GardenPalette.darkGrey,
                  ),
                ),
              ),
              Consumer(
                builder: (context, ref, _) {
                  final groupsAsync =
                      ref.watch(mosqueGroupsProvider(selectedId));
                  return groupsAsync.when(
                    data: (groups) => Column(
                      children: groups
                          .map((g) => _SidebarItem(
                                icon: g.isPrivate
                                    ? Icons.lock_outline
                                    : Icons.group_outlined,
                                label: g.name,
                                subtitle: g.meetingTime,
                                isSelected: false,
                                onTap: () => onItemTap?.call(),
                              ))
                          .toList(),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (e, _) => const SizedBox.shrink(),
                  );
                },
              ),
            ],

            const Spacer(),

            // Discover button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onItemTap?.call(),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      gradient: GardenPalette.vibrantEmeraldGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.explore,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Felfedezés',
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.subtitle,
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
                color: isSelected
                    ? GardenPalette.leafyGreen
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected
                    ? GardenPalette.leafyGreen
                    : GardenPalette.darkGrey,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? GardenPalette.nearBlack
                            : GardenPalette.nearBlack.withValues(alpha: 0.7),
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          color: GardenPalette.darkGrey,
                        ),
                      ),
                  ],
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
