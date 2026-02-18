import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../auth/auth_service.dart';
import '../models/dua.dart';
import '../providers/duas_provider.dart';
import '../widgets/edit_dua_dialog.dart';
import '../../admin_tools/services/admin_repository.dart';

class AzkarDetailScreen extends ConsumerWidget {
  final DuaCategory category;

  const AzkarDetailScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(categoryDuasProvider(category.id));
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text(
          category.nameHu,
          style: GoogleFonts.playfairDisplay(
            fontWeight: FontWeight.w700,
            color: GardenPalette.nearBlack,
          ),
        ),
        backgroundColor: GardenPalette.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
      ),
      body: itemsAsync.when(
        data: (items) => _AzkarPageView(items: items, isAdmin: isAdmin, categoryId: category.id),
        loading: () => const Center(
            child: CircularProgressIndicator(color: GardenPalette.leafyGreen)),
        error: (err, stack) => Center(
            child: Text('Hiba: $err',
                style: const TextStyle(color: GardenPalette.errorRed))),
      ),
    );
  }
}

class _AzkarPageView extends ConsumerStatefulWidget {
  final List<Dua> items;
  final bool isAdmin;
  final String categoryId;

  const _AzkarPageView({
    required this.items, 
    required this.isAdmin,
    required this.categoryId,
  });

  @override
  ConsumerState<_AzkarPageView> createState() => _AzkarPageViewState();
}

class _AzkarPageViewState extends ConsumerState<_AzkarPageView> {
  late PageController _pageController;
  late List<int> _remainingCounts;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _remainingCounts =
        widget.items.map((item) => item.repeatCount).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTapCounter() {
    if (_remainingCounts[_currentPage] > 0) {
      setState(() {
        _remainingCounts[_currentPage]--;
      });

      if (_remainingCounts[_currentPage] == 0 &&
          _currentPage < widget.items.length - 1) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: List.generate(widget.items.length + (widget.isAdmin ? 1 : 0), (i) {
              final isAddPage = i == widget.items.length;
              final done = !isAddPage && _remainingCounts[i] == 0;
              final active = i == _currentPage;
              return Expanded(
                child: Container(
                  height: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isAddPage
                        ? (active ? GardenPalette.leafyGreen : GardenPalette.lightGrey)
                        : (done
                            ? GardenPalette.leafyGreen
                            : active
                                ? GardenPalette.nearBlack.withValues(alpha: 0.6)
                                : GardenPalette.lightGrey),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),

        // Page view
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.items.length + (widget.isAdmin ? 1 : 0),
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              if (widget.isAdmin && index == widget.items.length) {
                return _buildAdminAddDua(context);
              }
              final item = widget.items[index];
              final remaining = _remainingCounts[index];
              final total = item.repeatCount;

              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Card(
                  color: GardenPalette.offWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: GardenPalette.lightGrey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Page indicator + Admin actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 48), // Spacer to balance admin icons
                            Text(
                              '${index + 1} / ${widget.items.length}',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                color: GardenPalette.darkGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (widget.isAdmin)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                                    onPressed: () => _showEditDuaDialog(context, item),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                                    onPressed: () => _confirmDeleteDua(context, item),
                                  ),
                                ],
                              )
                            else
                              const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Arabic Text
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                  Text(
                                    item.vocalizedText ?? item.arabicText,
                                    style: GoogleFonts.lateef(
                                      fontSize: 32,
                                      height: 1.4,
                                      color: GardenPalette.nearBlack,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                  if (item.reference != null && item.reference!.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Divider(color: GardenPalette.lightGrey),
                                    const SizedBox(height: 8),
                                    Text(
                                      item.reference!,
                                      style: GoogleFonts.outfit(
                                        fontSize: 12,
                                        color: GardenPalette.darkGrey,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.center,
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                  if (item.translationHu != null) ...[
                                    const SizedBox(height: 16),
                                    Text(
                                      item.translationHu!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      color: GardenPalette.charcoal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Counter
                        GestureDetector(
                          onTap: _onTapCounter,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: remaining == 0
                                  ? const LinearGradient(
                                      colors: [
                                        GardenPalette.leafyGreen,
                                        GardenPalette.lightGreen,
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        GardenPalette.deepGreen,
                                        GardenPalette.leafyGreen,
                                      ],
                                    ),
                              boxShadow: [
                                BoxShadow(
                                  color: GardenPalette.leafyGreen
                                      .withValues(alpha: 0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: remaining == 0
                                  ? const Icon(Icons.check,
                                      color: Colors.white, size: 36)
                                  : Text(
                                      '$remaining',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          remaining == 0
                              ? 'Kész ✓'
                              : 'Koppints! ($remaining/$total)',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: remaining == 0
                                ? GardenPalette.leafyGreen
                                : GardenPalette.darkGrey,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  Widget _buildAdminAddDua(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      child: Card(
        color: GardenPalette.offWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: GardenPalette.lightGrey, width: 2),
        ),
        child: InkWell(
          onTap: () => _showEditDuaDialog(context),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_circle_outline, color: GardenPalette.leafyGreen, size: 64),
              const SizedBox(height: 16),
              Text(
                'ÚJ DUA HOZZÁADÁSA',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: GardenPalette.leafyGreen,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ehhez a kategóriához',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: GardenPalette.darkGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDuaDialog(BuildContext context, [Dua? item]) {
    showDialog(
      context: context,
      builder: (context) => EditDuaDialog(dua: item, categoryId: widget.categoryId),
    );
  }

  void _confirmDeleteDua(BuildContext context, Dua item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dua törlése'),
        content: Text('Biztosan törölni szeretnéd a(z) "${item.titleHu}" duát?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Mégse')),
          TextButton(
            onPressed: () async {
              await ref.read(adminRepositoryProvider).deleteDua(item.id);
              ref.invalidate(categoryDuasProvider(widget.categoryId));
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Törlés', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

