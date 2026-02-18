import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';

class PageActionsSheet extends StatelessWidget {
  final int pageNumber;
  final VoidCallback onBookmark;
  final VoidCallback onShare;
  final VoidCallback onSaveAsImage;

  const PageActionsSheet({
    super.key,
    required this.pageNumber,
    required this.onBookmark,
    required this.onShare,
    required this.onSaveAsImage,
  });

  static Future<void> show(
    BuildContext context, {
    required int pageNumber,
    required VoidCallback onBookmark,
    required VoidCallback onShare,
    required VoidCallback onSaveAsImage,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: GardenPalette.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      useSafeArea: true,
      useRootNavigator: true,
      builder: (_) => PageActionsSheet(
        pageNumber: pageNumber,
        onBookmark: onBookmark,
        onShare: onShare,
        onSaveAsImage: onSaveAsImage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: GardenPalette.lightGrey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'Page $pageNumber',
              style: GoogleFonts.playfairDisplay(
                color: GardenPalette.nearBlack,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ActionButton(
                  icon: Icons.bookmark_add_outlined,
                  label: 'Bookmark',
                  onTap: () {
                    onBookmark();
                    Navigator.pop(context);
                  },
                ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () {
                    onShare();
                    Navigator.pop(context);
                  },
                ),
                _ActionButton(
                  icon: Icons.save_alt_outlined,
                  label: 'Save',
                  onTap: () {
                    onSaveAsImage();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: GardenPalette.leafyGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: GardenPalette.leafyGreen, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: GardenPalette.nearBlack,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
