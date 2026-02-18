import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/extensions/snackbar_helpers.dart';
import '../models/dua.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../providers/duas_provider.dart';

class EditDuaCategoryDialog extends ConsumerStatefulWidget {
  final DuaCategory? category;

  const EditDuaCategoryDialog({super.key, this.category});

  @override
  ConsumerState<EditDuaCategoryDialog> createState() => _EditDuaCategoryDialogState();
}

class _EditDuaCategoryDialogState extends ConsumerState<EditDuaCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _iconController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.nameHu ?? '');
    _iconController = TextEditingController(text: widget.category?.iconName ?? 'menu_book');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final data = {
        'name_hu': _nameController.text.trim(),
        'icon_name': _iconController.text.trim(),
      };

      if (widget.category != null) {
        await repo.updateDuaCategory(widget.category!.id, data);
      } else {
        await repo.createDuaCategory(data);
      }

      ref.invalidate(duaCategoriesProvider);
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.category != null ? 'Kategória Szerkesztése' : 'Új Kategória',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: GardenPalette.leafyGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Kategória neve (Magyar)',
                validator: (v) => v!.isEmpty ? 'Kötelező' : null,
              ),
              _buildTextField(
                controller: _iconController,
                label: 'Ikon neve (Material Icon)',
                helper: 'Pl: menu_book, favorite, list',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? helper,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          helperText: helper,
          filled: true,
          fillColor: GardenPalette.offWhite,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        validator: validator,
      ),
    );
  }
}
