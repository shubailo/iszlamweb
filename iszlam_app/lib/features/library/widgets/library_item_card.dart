import 'package:flutter/material.dart';
import '../screens/book_reader_screen.dart';
import '../screens/epub_reader_screen.dart';
import '../screens/markdown_reader_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/garden_palette.dart';
import '../models/library_item.dart';
import '../services/audio_service.dart';
import '../../auth/services/auth_service.dart';
import '../../admin_tools/screens/admin_upload_book_screen.dart';
import '../../admin_tools/models/admin_models.dart';
import '../../admin_tools/services/admin_repository.dart';
import 'package:iszlamweb_app/features/library/providers/library_provider.dart';

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
          // Priority: EPUB (flowing) > PDF (original) > Markdown (text)
          final hasEpub = item.epubUrl != null && item.epubUrl!.isNotEmpty;
          final isPdf = item.mediaUrl.toLowerCase().endsWith('.pdf') || 
                        (item.metadata?.toLowerCase() == 'pdf');
          
          Widget reader;
          if (hasEpub) {
            reader = EpubReaderScreen(item: item);
          } else if (isPdf) {
            reader = BookReaderScreen(
              bookId: item.id,
              title: item.title,
              filePath: item.mediaUrl,
              downloadUrl: item.fileUrl,
            );
          } else {
            reader = MarkdownReaderScreen(item: item);
          }

          Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => reader),
          );
        }
      },
      child: Container(
        width: width,
        height: isSquare ? 180 : 250, // Fixed height for premium feel
        margin: const EdgeInsets.only(bottom: 12),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Cover Image Background
            Positioned.fill(
              bottom: 40, // Leave space for the info card overlap
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
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
                      
                      // Dark gradient overlay
                      if (item.type == LibraryItemType.audio || isAdmin)
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withAlpha(80),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withAlpha(40),
                              ],
                            ),
                          ),
                        ),

                      if (item.type == LibraryItemType.audio)
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(40),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white.withAlpha(100), width: 1),
                            ),
                            child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
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
                                        book: AdminBook(
                                          id: item.id,
                                          title: item.title,
                                          author: item.author,
                                          description: item.description,
                                          categoryId: item.categoryId,
                                          coverUrl: item.imageUrl,
                                          fileUrl: item.fileUrl,
                                          metadata: null,
                                        ),
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
            ),
            
            // Overlapping Info Card
            Positioned(
              bottom: 0,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(30),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.type == LibraryItemType.audio ? 'AUDIO' : 'KÖNYV',
                      style: GoogleFonts.outfit(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: GardenPalette.leafyGreen,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: GardenPalette.nearBlack,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: GardenPalette.charcoal,
                      ),
                    ),
                  ],
                ),
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
              await ref.read(libraryServiceProvider).removeBook(item.id);
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
      color: type == LibraryItemType.audio ? GardenPalette.white : GardenPalette.leafyGreen.withAlpha(50),
      child: Center(
        child: Icon(
          type == LibraryItemType.audio ? Icons.mic : Icons.menu_book, 
          color: type == LibraryItemType.audio ? Colors.white : GardenPalette.leafyGreen,
          size: 32
        ),
      ),
    );
  }
}
