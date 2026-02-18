import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../../../core/theme/garden_palette.dart';

class GuestDiscoveryGrid extends ConsumerWidget {
  const GuestDiscoveryGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final features = [
      (title: H.worship, icon: Icons.mosque, route: '/worship'),
      (title: H.library, icon: Icons.local_library, route: '/library'),
      (title: H.community, icon: Icons.people, route: '/community'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            H.exploreIslam.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: GardenPalette.white.withAlpha(150),
            ),
          ),
          const SizedBox(height: 32),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: features.length,
            itemBuilder: (context, index) {
              final feature = features[index];
              return _DiscoveryTile(
                title: feature.title,
                icon: feature.icon,
                onTap: () => context.go(feature.route),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DiscoveryTile extends StatefulWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DiscoveryTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_DiscoveryTile> createState() => _DiscoveryTileState();
}

class _DiscoveryTileState extends State<_DiscoveryTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isHovered 
                    ? GardenPalette.white.withAlpha(50) 
                    : GardenPalette.white.withAlpha(20), 
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: GardenPalette.white.withAlpha(_isHovered ? 15 : 5),
                  blurRadius: _isHovered ? 30 : 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: GardenPalette.white.withAlpha(10),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(widget.icon, color: GardenPalette.white, size: 24),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.arrow_forward, color: GardenPalette.white, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
