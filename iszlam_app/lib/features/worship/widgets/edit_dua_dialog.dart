import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/dua.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../providers/duas_provider.dart';

class EditDuaDialog extends ConsumerStatefulWidget {
  final Dua? dua;
  final String categoryId;

  const EditDuaDialog({super.key, this.dua, required this.categoryId});

  @override
  ConsumerState<EditDuaDialog> createState() => _EditDuaDialogState();
}

class _EditDuaDialogState extends ConsumerState<EditDuaDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _arabicController;
  late TextEditingController _vocalizedController;
  late TextEditingController _translationController;
  late TextEditingController _referenceController;
  late TextEditingController _repeatController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.dua?.titleHu ?? '');
    _arabicController = TextEditingController(text: widget.dua?.arabicText ?? '');
    _vocalizedController = TextEditingController(text: widget.dua?.vocalizedText ?? '');
    _translationController = TextEditingController(text: widget.dua?.translationHu ?? '');
    _referenceController = TextEditingController(text: widget.dua?.reference ?? '');
    _repeatController = TextEditingController(text: widget.dua?.repeatCount.toString() ?? '1');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _arabicController.dispose();
    _vocalizedController.dispose();
    _translationController.dispose();
    _referenceController.dispose();
    _repeatController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final data = {
        'category_id': widget.categoryId,
        'title_hu': _titleController.text.trim(),
        'arabic_text': _arabicController.text.trim(),
        'vocalized_text': _vocalizedController.text.trim(),
        'translation_hu': _translationController.text.trim(),
        'reference': _referenceController.text.trim(),
        'repeat_count': int.tryParse(_repeatController.text) ?? 1,
      };

      if (widget.dua != null) {
        await repo.updateDua(widget.dua!.id, data);
      } else {
        await repo.createDua(data);
      }

      ref.invalidate(categoryDuasProvider(widget.categoryId));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hiba: $e'), backgroundColor: GardenPalette.errorRed),
        );
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
                  widget.dua != null ? 'Dua Szerkesztése' : 'Új Dua Hozzáadása',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.leafyGreen,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  controller: _titleController,
                  label: 'Cím (pl: Reggeli ima)',
                  validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                ),
                _buildTextField(
                  controller: _arabicController,
                  label: 'Arab szöveg',
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(fontSize: 18),
                  validator: (v) => v!.isEmpty ? 'Kötelező' : null,
                ),
                _buildTextField(
                  controller: _vocalizedController,
                  label: 'Arab szöveg (Vokalizált)',
                  maxLines: 3,
                  textDirection: TextDirection.rtl,
                  style: GoogleFonts.amiri(fontSize: 18),
                ),
                _buildTextField(
                  controller: _translationController,
                  label: 'Magyar fordítás',
                  maxLines: 3,
                ),
                _buildTextField(
                  controller: _referenceController,
                  label: 'Forrás (pl: Korán 2:255)',
                ),
                _buildTextField(
                  controller: _repeatController,
                  label: 'Ismétlések száma',
                  keyboardType: TextInputType.number,
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
                      : Text('MENTÉS', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
    int maxLines = 1,
    TextInputType? keyboardType,
    TextDirection? textDirection,
    TextStyle? style,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        textDirection: textDirection,
        style: style,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: GardenPalette.offWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: validator,
      ),
    );
  }
}
