import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../providers/azkar_provider.dart';
import 'azkar_detail_screen.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(azkarCategoriesProvider);
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    isDesktop ? 24 : 16, isDesktop ? 24 : 16, isDesktop ? 24 : 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isDesktop)
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: GardenPalette.nearBlack),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Duák Gyűjteménye',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: GardenPalette.nearBlack,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'Duák Gyűjteménye',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: GardenPalette.nearBlack,
                        ),
                      ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),

          // Category list
          categoriesAsync.when(
            data: (categories) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = categories[index];
                  return _CategoryCard(
                    name: category.nameHu ?? category.name,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AzkarDetailScreen(category: category),
                        ),
                      );
                    },
                  );
                },
                childCount: categories.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen)),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(
                child: Text('Hiba: $err', style: const TextStyle(color: GardenPalette.errorRed)),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _CategoryCard({required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GardenPalette.offWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: GardenPalette.lightGrey),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: GardenPalette.leafyGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.menu_book, color: GardenPalette.leafyGreen, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: GardenPalette.nearBlack,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: GardenPalette.grey, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
