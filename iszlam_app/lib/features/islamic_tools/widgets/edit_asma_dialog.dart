import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/extensions/snackbar_helpers.dart';
import '../models/asmaul_husna.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../providers/asmaul_husna_provider.dart';

class EditAsmaDialog extends ConsumerStatefulWidget {
  final AsmaulHusna? asma;

  const EditAsmaDialog({super.key, this.asma});

  @override
  ConsumerState<EditAsmaDialog> createState() => _EditAsmaDialogState();
}

class _EditAsmaDialogState extends ConsumerState<EditAsmaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _numberController;
  late TextEditingController _arabicController;
  late TextEditingController _transliterationController;
  late TextEditingController _meaningController;
  late TextEditingController _descriptionController;
  late TextEditingController _originController;
  late TextEditingController _mentionsController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.asma?.number.toString() ?? '');
    _arabicController = TextEditingController(text: widget.asma?.arabic ?? '');
    _transliterationController = TextEditingController(text: widget.asma?.transliteration ?? '');
    _meaningController = TextEditingController(text: widget.asma?.meaningHu ?? '');
    _descriptionController = TextEditingController(text: widget.asma?.descriptionHu ?? '');
    _originController = TextEditingController(text: widget.asma?.originHu ?? '');
    _mentionsController = TextEditingController(text: widget.asma?.mentionsHu ?? '');
  }

  @override
  void dispose() {
    _numberController.dispose();
    _arabicController.dispose();
    _transliterationController.dispose();
    _meaningController.dispose();
    _descriptionController.dispose();
    _originController.dispose();
    _mentionsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final data = {
        'number': int.parse(_numberController.text),
        'arabic': _arabicController.text.trim(),
        'transliteration': _transliterationController.text.trim(),
        'meaning_hu': _meaningController.text.trim(),
        'description_hu': _descriptionController.text.trim(),
        'origin_hu': _originController.text.trim(),
        'mentions_hu': _mentionsController.text.trim(),
      };

      if (widget.asma != null) {
        await repo.updateAsma(widget.asma!.id, data);
      } else {
        await repo.createAsma(data);
      }

      ref.invalidate(asmaulHusnaProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        context.showError('Hiba: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: GardenPalette.white,
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.asma != null ? 'Név Szerkesztése' : 'Új Név Hozzáadása',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.leafyGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildTextField(
                        controller: _numberController,
                        label: 'Sorszám',
                        keyboardType: TextInputType.number,
                        validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: _buildTextField(
                        controller: _arabicController,
                        label: 'Arabul',
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.lateef(fontSize: 28),
                        validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _transliterationController,
                  label: 'Átírás',
                  validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                ),
                _buildTextField(
                  controller: _meaningController,
                  label: 'Magyar jelentés',
                  validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                ),
                _buildTextField(
                  controller: _descriptionController,
                  label: 'Mit jelent? (Bővebben)',
                  maxLines: 4,
                ),
                _buildTextField(
                  controller: _originController,
                  label: 'Eredet / Etimológia',
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _mentionsController,
                  label: 'Említések a Koránban',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GardenPalette.leafyGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('MENTÉS', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('MÉGSE', style: GoogleFonts.outfit(color: GardenPalette.grey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    TextDirection? textDirection,
    TextStyle? style,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textDirection: textDirection,
        maxLines: maxLines,
        style: style ?? GoogleFonts.outfit(color: GardenPalette.nearBlack),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: GardenPalette.darkGrey),
          filled: true,
          fillColor: GardenPalette.offWhite,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: GardenPalette.lightGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: GardenPalette.lightGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: GardenPalette.leafyGreen, width: 2),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
