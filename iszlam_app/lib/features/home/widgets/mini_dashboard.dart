import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../../../core/theme/garden_palette.dart';
import '../../library/providers/reading_progress_provider.dart';
import '../../library/models/book_progress.dart';

class MiniDashboard extends ConsumerWidget {
  const MiniDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final readingProgressAsync = ref.watch(recentReadingProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            H.continueReading.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              color: GardenPalette.leafyGreen.withAlpha(200),
            ),
          ),
          const SizedBox(height: 16),
          readingProgressAsync.when(
            data: (progressList) {
              if (progressList.isEmpty) {
                return _buildEmptyState(context);
              }
              return SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: progressList.length,
                  itemBuilder: (context, index) {
                    return _buildReadingCard(context, progressList[index]);
                  },
                ),
              );
            },
            loading: () => const SizedBox(
              height: 140,
              child: Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen)),
            ),
            error: (e, s) => const Text('Hiba történt a betöltéskor.', style: TextStyle(color: GardenPalette.nearBlack)),
          ),
        ],
      ),
    );
  }

  Widget _buildReadingCard(BuildContext context, BookProgress progress) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        border: Border.all(color: GardenPalette.lightGrey.withAlpha(100), width: 0.5),
      ),
      child: InkWell(
        onTap: () => context.go('/library'),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: GardenPalette.leafyGreen.withAlpha(15),
                      border: Border.all(color: GardenPalette.leafyGreen.withAlpha(30)),
                    ),
                    child: const Icon(Icons.menu_book, size: 18, color: GardenPalette.leafyGreen),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: GardenPalette.nearBlack,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${(progress.progress * 100).toInt()}% kész',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: GardenPalette.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      Text(
                        'FOLYTATÁS',
                        style: GoogleFonts.outfit(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: GardenPalette.leafyGreen,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: progress.progress,
                    backgroundColor: GardenPalette.lightGrey.withAlpha(40),
                    valueColor: const AlwaysStoppedAnimation<Color>(GardenPalette.leafyGreen),
                    minHeight: 2,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        border: Border.all(color: GardenPalette.lightGrey.withAlpha(80), width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.library_books_outlined, color: GardenPalette.leafyGreen, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Nincs folyamatban lévő olvasásod.',
              style: GoogleFonts.outfit(
                fontSize: 14,
                color: GardenPalette.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
