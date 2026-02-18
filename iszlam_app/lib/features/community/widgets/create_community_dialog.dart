import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/mosque.dart';
import '../services/community_service.dart';
import '../providers/mosque_provider.dart';

class CreateCommunityDialog extends ConsumerStatefulWidget {
  const CreateCommunityDialog({super.key});

  @override
  ConsumerState<CreateCommunityDialog> createState() => _CreateCommunityDialogState();
}

class _CreateCommunityDialogState extends ConsumerState<CreateCommunityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _descController = TextEditingController();
  
  CommunityPrivacyType _privacyType = CommunityPrivacyType.public;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final mosque = Mosque(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        description: _descController.text.trim(),
        privacyType: _privacyType,
        // Helper: In a real app, creator would be admin
      );

      await ref.read(communityServiceProvider).createMosque(mosque);
      
      if (mounted) {
        ref.invalidate(mosqueListProvider);
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: GardenPalette.white,
      child: Container(
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create a Community',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.nearBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a new mosque or center to the network.',
                  style: GoogleFonts.outfit(color: GardenPalette.grey),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField(
                  label: 'Name',
                  controller: _nameController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // City
                _buildTextField(
                  label: 'City',
                  controller: _cityController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Address
                _buildTextField(
                  label: 'Address',
                  controller: _addressController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  controller: _descController,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),

                // Privacy
                Text('Privacy Type', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                DropdownButtonFormField<CommunityPrivacyType>(
                  initialValue: _privacyType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  items: CommunityPrivacyType.values.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.name.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (v) => setState(() => _privacyType = v!),
                ),

                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'CANCEL',
                        style: GoogleFonts.outfit(
                          color: GardenPalette.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GardenPalette.leafyGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: _isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('CREATE COMMUNITY', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: GardenPalette.lightGrey),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }
}
