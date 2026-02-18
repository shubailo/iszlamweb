import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/mosque.dart';
import '../models/mosque_group.dart';
import '../services/community_service.dart';
import '../providers/group_provider.dart';

class CreateGroupDialog extends ConsumerStatefulWidget {
  final String mosqueId;

  const CreateGroupDialog({super.key, required this.mosqueId});

  @override
  ConsumerState<CreateGroupDialog> createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends ConsumerState<CreateGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _leaderController = TextEditingController();
  final _timeController = TextEditingController();
  
  CommunityPrivacyType _privacyType = CommunityPrivacyType.public;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _leaderController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final now = DateTime.now();
      final group = MosqueGroup(
        id: const Uuid().v4(),
        mosqueId: widget.mosqueId,
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        leaderName: _leaderController.text.trim(),
        meetingTime: _timeController.text.trim(),
        privacyType: _privacyType,
        createdAt: now,
        updatedAt: now,
      );

      await ref.read(communityServiceProvider).createGroup(group);
      
      if (mounted) {
        ref.invalidate(mosqueGroupsProvider(widget.mosqueId));
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
                  'Create a Group',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: GardenPalette.nearBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a new study circle or group.',
                  style: GoogleFonts.outfit(color: GardenPalette.grey),
                ),
                const SizedBox(height: 24),

                // Name
                _buildTextField(
                  label: 'Group Name',
                  controller: _nameController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Leader
                _buildTextField(
                  label: 'Leader Name',
                  controller: _leaderController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                 // Time
                _buildTextField(
                  label: 'Meeting Time',
                  controller: _timeController,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  hint: 'e.g. Fridays after Maghrib',
                ),
                const SizedBox(height: 16),

                // Description
                _buildTextField(
                  label: 'Description',
                  controller: _descController,
                  maxLines: 3,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
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
                        backgroundColor: GardenPalette.emeraldTeal,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: _isSubmitting 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('CREATE GROUP', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
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
    String? hint,
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
            hintText: hint,
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
