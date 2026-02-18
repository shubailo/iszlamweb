import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../auth/services/auth_service.dart';
import '../providers/asmaul_husna_provider.dart';
import '../widgets/edit_asma_dialog.dart';
import '../models/asmaul_husna.dart';
import '../../worship/widgets/worship_sidebar.dart';

class AsmaulHusnaScreen extends ConsumerWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(asmaulHusnaProvider);
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: !isDesktop ? const WorshipSidebar() : null,
      appBar: AppBar(
        title: Text('Allah 99 Neve', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: !isDesktop ? Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ) : null,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
      ),
      body: namesAsync.when(
        data: (names) => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: names.length,
          itemBuilder: (context, index) {
            final name = names[index];
            return _buildNameCard(context, ref, name, isAdmin);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen)),
        error: (e, _) => Center(child: Text('Hiba: $e', style: GoogleFonts.outfit(color: GardenPalette.errorRed))),
      ),
    );
  }


  Widget _buildNameCard(BuildContext context, WidgetRef ref, dynamic name, bool isAdmin) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GardenPalette.lightGrey),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          title: Row(
            children: [
              // Number badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: GardenPalette.leafyGreen.withValues(alpha: 0.12),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${name.number}',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.leafyGreen,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              // Transliteration + Meaning
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.transliteration,
                      style: GoogleFonts.outfit(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: GardenPalette.nearBlack,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      name.meaningHu,
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
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdmin)
                _AdminActionButton(
                  icon: Icons.edit_outlined,
                  color: Colors.blue,
                  onTap: () => _showEditAsmaDialog(context, asma: name),
                )
              else
                Text(
                  name.arabic,
                  style: GoogleFonts.lateef(
                    fontSize: 36,
                    color: GardenPalette.leafyGreen,
                    fontWeight: FontWeight.bold,
                  ),
                  textDirection: TextDirection.rtl,
                ),
              const SizedBox(width: 8),
               const Icon(Icons.keyboard_arrow_down, color: GardenPalette.darkGrey),
            ],
          ),
          children: [
            const Divider(height: 1, color: GardenPalette.lightGrey),
            const SizedBox(height: 16),
            
            // Expanded Content
            _buildDetailSection(
              title: 'MIT JELENT?',
              content: name.descriptionHu ?? 'Hamarosan...',
              icon: Icons.lightbulb_outline,
            ),
            const SizedBox(height: 16),
             _buildDetailSection(
              title: 'EREDET',
              content: name.originHu ?? 'Hamarosan...',
              icon: Icons.history,
            ),
            const SizedBox(height: 16),
             _buildDetailSection(
              title: 'EMLÍTÉSEK A KORÁNBAN',
              content: name.mentionsHu ?? 'Hamarosan...',
              icon: Icons.menu_book,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required String content,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: GardenPalette.leafyGreen, size: 16),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: GardenPalette.leafyGreen,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: GardenPalette.nearBlack,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  void _showEditAsmaDialog(BuildContext context, {AsmaulHusna? asma}) {
    showDialog(
      context: context,
      builder: (context) => EditAsmaDialog(asma: asma),
    );
  }
}


class _AdminActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withAlpha(20),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
