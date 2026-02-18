import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../auth/auth_service.dart';
import '../models/dua.dart';
import '../providers/duas_provider.dart';
import '../widgets/edit_dua_category_dialog.dart';
import 'azkar_detail_screen.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../../worship/widgets/worship_sidebar.dart';

class AzkarCategoriesScreen extends ConsumerWidget {
  const AzkarCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(duaCategoriesProvider);
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: !isDesktop ? const WorshipSidebar() : null,
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
                          Builder(
                            builder: (context) => IconButton(
                              icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
                              onPressed: () => Scaffold.of(context).openDrawer(),
                            ),
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
                  if (isAdmin && index == categories.length) {
                    return _buildAdminAddCard(context);
                  }
                  final category = categories[index];
                  return _CategoryCard(
                    name: category.nameHu,
                    isAdmin: isAdmin,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AzkarDetailScreen(category: category),
                        ),
                      );
                    },
                    onEdit: () => _showEditCategoryDialog(context, category),
                    onDelete: () => _confirmDeleteCategory(context, ref, category),
                  );
                },
                childCount: categories.length + (isAdmin ? 1 : 0),
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
  final bool isAdmin;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CategoryCard({
    required this.name, 
    required this.onTap,
    this.isAdmin = false,
    this.onEdit,
    this.onDelete,
  });

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
                if (isAdmin)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                        onPressed: onEdit,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: onDelete,
                      ),
                    ],
                  )
                else
                  Icon(Icons.arrow_forward_ios, color: GardenPalette.grey, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildAdminAddCard(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: InkWell(
      onTap: () => _showEditCategoryDialog(context),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: GardenPalette.leafyGreen.withAlpha(50), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, color: GardenPalette.leafyGreen),
            const SizedBox(width: 8),
            Text(
              'ÚJ KATEGÓRIA',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                color: GardenPalette.leafyGreen,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

void _showEditCategoryDialog(BuildContext context, [DuaCategory? category]) {
  showDialog(
    context: context,
    builder: (context) => EditDuaCategoryDialog(category: category),
  );
}

void _confirmDeleteCategory(BuildContext context, WidgetRef ref, DuaCategory category) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Kategória törlése'),
      content: Text('Biztosan törölni szeretnéd a(z) "${category.nameHu}" kategóriát és az összes hozzá tartozó duát?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
        TextButton(
          onPressed: () async {
            await ref.read(adminRepositoryProvider).deleteDuaCategory(category.id);
            ref.invalidate(duaCategoriesProvider);
            if (context.mounted) Navigator.pop(context);
          },
          child: const Text('Törlés', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
