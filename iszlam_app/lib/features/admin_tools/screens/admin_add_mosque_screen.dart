import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/admin_repository.dart';
import '../../../core/theme/garden_palette.dart';

class AdminAddMosqueScreen extends ConsumerStatefulWidget {
  const AdminAddMosqueScreen({super.key});

  @override
  ConsumerState<AdminAddMosqueScreen> createState() => _AdminAddMosqueScreenState();
}

class _AdminAddMosqueScreenState extends ConsumerState<AdminAddMosqueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latController = TextEditingController();
  final _lngController = TextEditingController();
  
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _descriptionController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(adminRepositoryProvider);
      
      final lat = double.tryParse(_latController.text);
      final lng = double.tryParse(_lngController.text);

      await repo.createMosque({
        'name': _nameController.text,
        'address': _addressController.text,
        'city': _cityController.text,
        'description': _descriptionController.text.isEmpty ? null : _descriptionController.text,
        'latitude': lat,
        'longitude': lng,
        'created_by': Supabase.instance.client.auth.currentUser?.id,
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mecset sikeresen hozzáadva!')),
        );
        Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Új mecset hozzáadása', style: GoogleFonts.playfairDisplay()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildField('Név', _nameController, Icons.mosque),
              _buildField('Város', _cityController, Icons.location_city),
              _buildField('Cím', _addressController, Icons.map),
              _buildField('Leírás', _descriptionController, Icons.description, maxLines: 3),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildField('Szélesség (Lat)', _latController, Icons.explore, keyboardType: TextInputType.number)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildField('Hosszúság (Lng)', _lngController, Icons.explore, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GardenPalette.leafyGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSubmitting 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('HOZZÁADÁS'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, IconData icon, {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: GardenPalette.leafyGreen),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (value) => value == null || value.isEmpty ? 'Kérjük, töltse ki' : null,
      ),
    );
  }
}
