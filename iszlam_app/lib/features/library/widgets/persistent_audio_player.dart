import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../services/audio_service.dart';

class PersistentAudioPlayer extends ConsumerWidget {
  const PersistentAudioPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final item = audioState.currentItem;

    // Only show if a track is loaded
    if (item == null) return const SizedBox.shrink();

    return Container(
      height: 64,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GardenPalette.midnightForest, // Dark theme for player
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // 1. Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: item.imageUrl != null 
              ? Image.network(
                  item.imageUrl!, 
                  width: 64, 
                  height: 64, 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 64, height: 64, color: GardenPalette.emeraldTeal,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  ),
                )
              : Container(
                  width: 64, 
                  height: 64, 
                  color: GardenPalette.emeraldTeal,
                   child: const Icon(Icons.music_note, color: Colors.white),
                ),
          ),
          
          // 2. Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: Colors.white.withAlpha(180),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Controls
          IconButton(
            onPressed: () {
               ref.read(audioServiceProvider.notifier).playItem(item); // Toggles play/pause
            },
            icon: Icon(
              audioState.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: Colors.white,
              size: 32,
            ),
          ),
          
          IconButton(
            onPressed: () {
               ref.read(audioServiceProvider.notifier).close();
            },
            icon: const Icon(Icons.close, color: Colors.white54, size: 20),
          ),
          
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
