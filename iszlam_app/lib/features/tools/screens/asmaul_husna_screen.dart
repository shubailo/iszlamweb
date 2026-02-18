import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../auth/auth_service.dart';
import '../providers/asmaul_husna_provider.dart';
import '../widgets/edit_asma_dialog.dart';
import 'asmaul_husna_detail_screen.dart';
import '../../../shared/models/asmaul_husna.dart';

class AsmaulHusnaScreen extends ConsumerWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(asmaulHusnaProvider);
    final isAdmin = ref.watch(isAdminProvider).maybeWhen(
      data: (v) => v,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text('Allah 99 Neve', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AsmaulHusnaDetailScreen(name: name),
              ),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
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
                const SizedBox(width: 12),
                // Arabic or Admin buttons
                if (isAdmin)
                  _AdminActionButton(
                    icon: Icons.edit_outlined,
                    color: Colors.blue,
                    onTap: () => _showEditAsmaDialog(context, asma: name),
                  )
                else
                  Text(
                    name.arabic,
                    style: GoogleFonts.amiri(
                      fontSize: 26,
                      color: GardenPalette.leafyGreen,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
              ],
            ),
          ),
        ),
      ),
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
