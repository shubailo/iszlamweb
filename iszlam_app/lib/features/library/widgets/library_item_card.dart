import 'package:flutter/material.dart';
import '../screens/markdown_reader_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../models/library_item.dart';
import '../services/audio_service.dart';
import '../../auth/auth_service.dart';
import '../../admin_tools/screens/admin_upload_book_screen.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../providers/library_filter_provider.dart';

class LibraryItemCard extends ConsumerWidget {
  final LibraryItem item;
  final bool isLarge;
  final bool isSquare;

  const LibraryItemCard({
    super.key, 
    required this.item, 
    this.isLarge = false,
    this.isSquare = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = isLarge ? 140.0 : (isSquare ? 120.0 : null);
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );
    
    return GestureDetector(
      onTap: () {
        if (item.type == LibraryItemType.audio) {
          ref.read(audioServiceProvider.notifier).playItem(item);
        } else if (item.type == LibraryItemType.book) {
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (_) => MarkdownReaderScreen(item: item),
            ),
          );
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    item.imageUrl != null 
                        ? Image.network(
                            item.imageUrl!, 
                            fit: BoxFit.cover,
                             errorBuilder: (context, error, stackTrace) => _PlaceholderCover(type: item.type),
                          )
                        : _PlaceholderCover(type: item.type),
                    
                    if (item.type == LibraryItemType.audio)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white),
                        ),
                      ),

                    if (isAdmin)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Row(
                          children: [
                            _AdminIcon(
                              icon: Icons.edit,
                              color: Colors.blue,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AdminUploadBookScreen(
                                      book: {
                                        'id': item.id,
                                        'title': item.title,
                                        'author': item.author,
                                        'description': item.description,
                                        'category_id': item.categoryId,
                                        'cover_url': item.imageUrl,
                                        'file_url': item.fileUrl,
                                        'metadata': item.metadata,
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            _AdminIcon(
                              icon: Icons.delete,
                              color: Colors.red,
                              onTap: () => _confirmDelete(context, ref),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            // Info
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    item.type == LibraryItemType.audio ? 'AUDIO' : 'KÖNYV',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: item.type == LibraryItemType.audio ? GardenPalette.gildedGold : GardenPalette.emeraldTeal,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: GardenPalette.midnightForest,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                   Text(
                    item.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: GardenPalette.midnightForest.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Törlés megerősítése'),
        content: Text('Biztosan törölni szeretnéd a következőt: "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mégse'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteBook(item.id);
              ref.invalidate(libraryCatalogProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Törlés', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _AdminIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(200),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 4,
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

class _PlaceholderCover extends StatelessWidget {
  final LibraryItemType type;

  const _PlaceholderCover({required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: type == LibraryItemType.audio ? GardenPalette.midnightForest : GardenPalette.emeraldTeal.withAlpha(50),
      child: Center(
        child: Icon(
          type == LibraryItemType.audio ? Icons.mic : Icons.menu_book, 
          color: type == LibraryItemType.audio ? Colors.white : GardenPalette.emeraldTeal,
          size: 32
        ),
      ),
    );
  }
}
