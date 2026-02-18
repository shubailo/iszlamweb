import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../features/library/widgets/persistent_audio_player.dart';
import '../localization/hungarian_strings.dart';
import '../theme/garden_palette.dart';
import '../widgets/animated_library_icon.dart';
import '../widgets/animated_more_icon.dart';
import 'top_navigation_bar.dart';

class ResponsiveNavigationShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ResponsiveNavigationShell({
    required this.navigationShell,
    super.key,
  });

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.lightGrey,
      body: Column(
        children: [
          if (isDesktop)
            TopNavigationBar(navigationShell: navigationShell),

          Expanded(
            child: Stack(
              children: [
                navigationShell,
                if (isDesktop)
                 const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: PersistentAudioPlayer(),
                  ),
              ],
            ),
          ),

          if (!isDesktop)
             const Align(
                alignment: Alignment.bottomCenter,
                child: PersistentAudioPlayer(),
             ),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: isDesktop
          ? null
          : _BottomBar(
              currentIndex: navigationShell.currentIndex,
              onTap: _goBranch,
            ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomBar({
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.mosque_outlined, Icons.mosque, H.worship),
    (Icons.people_outline, Icons.people, H.myCommunity),
    (null, null, H.library), // Custom animated icon
    (null, null, H.more),    // Custom animated icon
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final isActive = i == currentIndex;
              final item = _items[i];
              
              final iconColor = isActive 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

              final icon = switch (i) {
                2 => AnimatedLibraryIcon(isSelected: isActive, size: 24, color: iconColor),
                3 => AnimatedMoreIcon(isSelected: isActive, size: 24, color: iconColor),
                _ => Icon(isActive ? item.$2 : item.$1, size: 24, color: iconColor),
              };

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 64,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? theme.colorScheme.primary.withValues(alpha: 0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          icon,
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.$3,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isActive 
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
