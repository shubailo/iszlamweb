import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../models/library_item.dart';
import '../providers/library_filter_provider.dart';
import '../services/audio_service.dart';
import '../screens/markdown_reader_screen.dart';
import '../../auth/services/auth_service.dart';
import '../../admin_tools/services/admin_repository.dart';

class LibrarySidebar extends ConsumerWidget {
  final VoidCallback? onItemTap;
  const LibrarySidebar({super.key, this.onItemTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allItems = ref.watch(libraryCatalogProvider);
    final filter = ref.watch(libraryFilterProvider);
    final categoriesAsync = ref.watch(adminCategoriesProvider);
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    // Simulate "ongoing readings" — first 3 books
    final ongoingBooks = allItems
        .where((i) => i.type == LibraryItemType.book)
        .take(3)
        .toList();

    return Container(
      width: 280,
      color: GardenPalette.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Text(
                H.libraryTitle.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: GardenPalette.leafyGreen,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Type filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _SidebarTypeItem(
                  icon: Icons.apps,
                  label: H.allItems,
                  isSelected: filter.typeFilter == null,
                  onTap: () {
                    ref.read(libraryFilterProvider.notifier).setTypeFilter(null);
                    onItemTap?.call();
                  },
                ).animate().fadeIn(duration: 300.ms),
                _SidebarTypeItem(
                  icon: Icons.menu_book_outlined,
                  label: H.books,
                  isSelected: filter.typeFilter == LibraryItemType.book,
                  onTap: () {
                    ref.read(libraryFilterProvider.notifier).setTypeFilter(LibraryItemType.book);
                    onItemTap?.call();
                  },
                ).animate().fadeIn(delay: 40.ms, duration: 300.ms),
                _SidebarTypeItem(
                  icon: Icons.mic_outlined,
                  label: H.khutbas,
                  isSelected: filter.typeFilter == LibraryItemType.audio,
                  onTap: () {
                    ref.read(libraryFilterProvider.notifier).setTypeFilter(LibraryItemType.audio);
                    onItemTap?.call();
                  },
                ).animate().fadeIn(delay: 80.ms, duration: 300.ms),
              ],
            ),
          ),

          // Scrollable middle section
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Ongoing Readings section
                _SectionHeader(
                  icon: Icons.auto_stories_outlined,
                  label: H.continueReading,
                ).animate().fadeIn(duration: 300.ms),

                const SizedBox(height: 8),

                ...ongoingBooks.asMap().entries.map((entry) {
                  return _OngoingReadingItem(
                    item: entry.value,
                    progress: 0.12 + (entry.key * 0.25),
                  ).animate()
                      .fadeIn(delay: (entry.key * 80).ms, duration: 300.ms)
                      .slideX(begin: -0.06, end: 0);
                }),

                const SizedBox(height: 24),

                // Categories section
                _SectionHeader(
                  icon: Icons.filter_list,
                  label: H.categories,
                  trailing: isAdmin ? GestureDetector(
                    onTap: () => _showAddCategoryDialog(context, ref),
                    child: Icon(Icons.add_circle_outline, size: 16, color: GardenPalette.leafyGreen),
                  ) : null,
                ).animate().fadeIn(delay: 200.ms, duration: 300.ms),

                const SizedBox(height: 8),

                categoriesAsync.when(
                  data: (categories) {
                    return Column(
                      children: categories.asMap().entries.map((entry) {
                        final catData = entry.value;
                        final category = LibraryCategory(
                          id: catData['id'],
                          label: catData['label_hu'],
                          slug: catData['slug'],
                        );
                        final count = allItems.where((i) => i.categoryId == category.id).length;
                        
                        return _SidebarCategoryItem(
                          category: category,
                          count: count,
                          isSelected: filter.categoryId == category.id,
                          isAdmin: isAdmin,
                          onDelete: () => _confirmDeleteCategory(context, ref, category),
                          onTap: () {
                            final notifier = ref.read(libraryFilterProvider.notifier);
                            if (filter.categoryId == category.id) {
                              notifier.setCategory('all');
                            } else {
                              notifier.setCategory(category.id);
                            }
                            onItemTap?.call();
                          },
                        ).animate()
                            .fadeIn(delay: (250 + entry.key * 60).ms, duration: 300.ms)
                            .slideX(begin: -0.06, end: 0);
                      }).toList(),
                    );
                  },
                  loading: () => const Center(child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                  )),
                  error: (e, _) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          // Audio player status (pinned at bottom)
          _AudioStatusWidget(),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final slugController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Új kategória'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Megnevezés (HU)'),
            ),
            TextField(
              controller: slugController,
              decoration: const InputDecoration(labelText: 'Slug (azonosító)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
          TextButton(
            onPressed: () async {
              if (titleController.text.isNotEmpty && slugController.text.isNotEmpty) {
                await ref.read(adminRepositoryProvider).createCategory(
                  labelHu: titleController.text,
                  slug: slugController.text,
                  type: 'both',
                );
                ref.invalidate(adminCategoriesProvider);
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Hozzáadás'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, WidgetRef ref, LibraryCategory category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kategória törlése'),
        content: Text('Biztosan törölni szeretnéd a(z) "${category.label}" kategóriát?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteCategory(category.id);
              ref.invalidate(adminCategoriesProvider);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Törlés', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SidebarTypeItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarTypeItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? GardenPalette.leafyGreen.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? GardenPalette.leafyGreen : GardenPalette.darkGrey,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? GardenPalette.nearBlack
                      : GardenPalette.nearBlack.withValues(alpha: 0.7),
                ),
              ),
              if (isSelected) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: GardenPalette.leafyGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;

  const _SectionHeader({required this.icon, required this.label, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, size: 14, color: GardenPalette.grey),
          const SizedBox(width: 8),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              color: GardenPalette.darkGrey,
            ),
          ),
          if (trailing != null) ...[
            const Spacer(),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _SidebarCategoryItem extends StatelessWidget {
  final LibraryCategory category;
  final int count;
  final bool isSelected;
  final bool isAdmin;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _SidebarCategoryItem({
    required this.category,
    required this.count,
    required this.isSelected,
    required this.isAdmin,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? GardenPalette.leafyGreen.withValues(alpha: 0.08)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isSelected ? GardenPalette.leafyGreen : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  category.label,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? GardenPalette.nearBlack
                        : GardenPalette.nearBlack.withValues(alpha: 0.7),
                  ),
                ),
              ),
              if (isAdmin)
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 16,
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? GardenPalette.leafyGreen.withValues(alpha: 0.15)
                      : GardenPalette.offWhite,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? GardenPalette.leafyGreen
                        : GardenPalette.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OngoingReadingItem extends StatelessWidget {
  final LibraryItem item;
  final double progress;

  const _OngoingReadingItem({
    required this.item,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MarkdownReaderScreen(item: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              // Mini cover
              Container(
                width: 36,
                height: 48,
                decoration: BoxDecoration(
                  gradient: GardenPalette.subtleGreenGradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.menu_book, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: GardenPalette.nearBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: GardenPalette.lightGrey,
                        valueColor: const AlwaysStoppedAnimation(
                            GardenPalette.leafyGreen),
                        minHeight: 4,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        color: GardenPalette.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioStatusWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioServiceProvider);
    final item = audioState.currentItem;

    if (item == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: GardenPalette.lightGrey),
      ),
      child: Row(
        children: [
          Icon(
            audioState.isPlaying ? Icons.pause_circle : Icons.play_circle,
            color: GardenPalette.leafyGreen,
            size: 28,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: GardenPalette.nearBlack,
                  ),
                ),
                Text(
                  audioState.isPlaying ? 'Lejátszás…' : 'Szünetel',
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    color: GardenPalette.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }
}
