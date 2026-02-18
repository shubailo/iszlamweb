import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../screens/create_post_screen.dart';

class CreatePostBar extends ConsumerWidget {
  final String mosqueId;

  const CreatePostBar({
    super.key,
    required this.mosqueId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GardenPalette.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: GardenPalette.lightGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            backgroundColor: GardenPalette.lightGrey,
            radius: 18,
            child: Icon(Icons.person, color: GardenPalette.grey),
          ),
          const SizedBox(width: 12),

          // Input Field (Fake)
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToCreatePost(context, 0), // 0 = Text tab
              child: Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: GardenPalette.offWhite,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: GardenPalette.lightGrey),
                ),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create Post',
                  style: GoogleFonts.outfit(
                    color: GardenPalette.grey,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Action Icons
          _ActionIcon(
            icon: Icons.image_outlined,
            onTap: () => _navigateToCreatePost(context, 1), // 1 = Image tab
          ),
          _ActionIcon(
            icon: Icons.link,
            onTap: () => _navigateToCreatePost(context, 2), // 2 = Link tab
          ),
          _ActionIcon(
            icon: Icons.poll_outlined,
            onTap: () => _navigateToCreatePost(context, 3), // 3 = Poll tab
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePost(BuildContext context, int initialTab) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreatePostScreen(
          mosqueId: mosqueId,
          initialTab: initialTab,
        ),
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: GardenPalette.grey,
          size: 24,
        ),
      ),
    );
  }
}
