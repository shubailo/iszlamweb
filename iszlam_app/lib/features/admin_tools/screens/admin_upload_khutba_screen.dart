import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/extensions/snackbar_helpers.dart';
import '../../../core/widgets/garden_input_decoration.dart';
import '../models/admin_models.dart';
import '../services/admin_repository.dart';

class AdminUploadKhutbaScreen extends ConsumerStatefulWidget {
  const AdminUploadKhutbaScreen({super.key});

  @override
  ConsumerState<AdminUploadKhutbaScreen> createState() => _AdminUploadKhutbaScreenState();
}

class _AdminUploadKhutbaScreenState extends ConsumerState<AdminUploadKhutbaScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _speakerController = TextEditingController();
  final _descController = TextEditingController();
  final _dateController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  List<AdminCategory> _categories = [];
  
  Uint8List? _audioFileBytes;
  String? _audioFileName;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _speakerController.dispose();
    _descController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await ref.read(adminRepositoryProvider).getCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
          // Filter for audio or both
          _categories = cats.where((c) => c.type != 'book').toList();
        });
      }
    } catch (e) {
      if (mounted) context.showError('Error loading categories: $e');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _audioFileBytes = result.files.first.bytes;
        _audioFileName = result.files.first.name;
      });
    }
  }

  Future<void> _upload() async {
    if (!_formKey.currentState!.validate()) return;
    if (_audioFileBytes == null) {
      context.showError('Please select an audio file');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(adminRepositoryProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // 1. Upload Audio File
      final safeName = '${timestamp}_${_audioFileName!.replaceAll(RegExp(r'[^a-zA-Z0-9\.]'), '_')}';
      final audioUrl = await repo.uploadFile(
        bucket: 'library_files', // Or 'khutbas' if separate
        path: 'audio/$safeName',
        bytes: _audioFileBytes!,
        contentType: 'audio/mpeg', // Simplified
      );

      // 2. Create DB Record
      await repo.createKhutba(
        title: _titleController.text,
        speaker: _speakerController.text,
        date: _selectedDate,
        categoryId: _selectedCategoryId, // Now nullable
        audioUrl: audioUrl,
        description: _descController.text,
      );

      if (mounted) {
        context.showSuccess('Khutba uploaded successfully!');
        context.pop();
      }
    } catch (e) {
      if (mounted) context.showError('Upload failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Khutba', style: GoogleFonts.playfairDisplay())),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: GardenInputDecoration.standard(label: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Speaker
              TextFormField(
                controller: _speakerController,
                decoration: GardenInputDecoration.standard(label: 'Speaker'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Date
              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _pickDate,
                decoration: GardenInputDecoration.standard(label: 'Date', suffixIcon: const Icon(Icons.calendar_today)),
              ),
              const SizedBox(height: 16),

              // Category
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                decoration: GardenInputDecoration.standard(label: 'Category (optional)'),
                items: _categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Text(c.labelHu),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),
              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: GardenInputDecoration.standard(label: 'Description'),
              ),
              const SizedBox(height: 24),

              // File Picker
              InkWell(
                onTap: _pickAudioFile,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: GardenPalette.lightGrey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.mic, color: GardenPalette.leafyGreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Audio File (MP3)', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                            if (_audioFileName != null)
                              Text(_audioFileName!, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      if (_audioFileName == null)
                        const Text('Select', style: TextStyle(color: Colors.blue)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit
              ElevatedButton(
                onPressed: _isLoading ? null : _upload,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: GardenPalette.leafyGreen,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('UPLOAD KHUTBA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
