import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/extensions/snackbar_helpers.dart';
import '../../../core/widgets/garden_input_decoration.dart';
import '../models/admin_models.dart';
import 'package:iszlamweb_app/features/library/providers/library_provider.dart';
import '../services/admin_repository.dart';

class AdminUploadBookScreen extends ConsumerStatefulWidget {
  final AdminBook? book;
  const AdminUploadBookScreen({super.key, this.book});

  @override
  ConsumerState<AdminUploadBookScreen> createState() => _AdminUploadBookScreenState();
}

class _AdminUploadBookScreenState extends ConsumerState<AdminUploadBookScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descController = TextEditingController();
  final _pagesController = TextEditingController();
  
  String? _selectedCategoryId;
  List<AdminCategory> _categories = [];
  
  Uint8List? _bookFileBytes;
  String? _bookFileName;
  
  Uint8List? _epubFileBytes;
  String? _epubFileName;
  
  Uint8List? _coverFileBytes;
  String? _coverFileName;
  
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _descController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _descController.text = widget.book!.description ?? '';
      _selectedCategoryId = widget.book!.categoryId;
      
      final metadata = widget.book!.metadata as Map<String, dynamic>?;
      if (metadata != null) {
        _pagesController.text = metadata['pages']?.toString() ?? '';
      }
    }
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await ref.read(adminRepositoryProvider).getCategories();
      if (mounted) {
        setState(() {
          _categories = cats;
          // Filter for books or both
          _categories = cats.where((c) => c.type != 'audio').toList();
        });
      }
    } catch (e) {
      if (mounted) context.showError('Error loading categories: $e');
    }
  }

  Future<void> _pickBookFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _bookFileBytes = result.files.first.bytes;
        _bookFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickEpubFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['epub'],
      withData: true,
    );

    if (result != null) {
      setState(() {
        _epubFileBytes = result.files.first.bytes;
        _epubFileName = result.files.first.name;
      });
    }
  }

  Future<void> _pickCoverFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _coverFileBytes = result.files.first.bytes;
        _coverFileName = result.files.first.name;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.book == null && _bookFileBytes == null) {
      context.showError('Please select a book file');
      return;
    }


    setState(() => _isLoading = true);

    try {
      final repo = ref.read(adminRepositoryProvider);
      final timestamp = DateTime.now().millisecondsSinceEpoch;

      // Upload PDF
      String? bookUrl = widget.book?.fileUrl;
      if (_bookFileBytes != null) {
        final safeBookName = '${timestamp}_${_bookFileName!.replaceAll(RegExp(r'[^a-zA-Z0-9\.]'), '_')}';
        bookUrl = await repo.uploadFile(
          bucket: 'library_files',
          path: safeBookName,
          bytes: _bookFileBytes!,
          contentType: 'application/pdf',
        );
      }

      // Upload EPUB
      String? epubUrl = widget.book?.epubUrl;
      if (_epubFileBytes != null) {
        final safeEpubName = '${timestamp}_${_epubFileName!.replaceAll(RegExp(r'[^a-zA-Z0-9\.]'), '_')}';
        epubUrl = await repo.uploadFile(
          bucket: 'library_files',
          path: safeEpubName,
          bytes: _epubFileBytes!,
          contentType: 'application/epub+zip',
        );
      }

      // At least one file format is required
      if ((bookUrl == null || bookUrl.isEmpty) && (epubUrl == null || epubUrl.isEmpty)) {
        throw Exception('At least a PDF or EPUB file is required.');
      }

      String? coverUrl = widget.book?.coverUrl;
      if (_coverFileBytes != null) {
        final safeCoverName = '${timestamp}_${_coverFileName!.replaceAll(RegExp(r'[^a-zA-Z0-9\.]'), '_')}';
        coverUrl = await repo.uploadFile(
          bucket: 'covers',
          path: safeCoverName,
          bytes: _coverFileBytes!,
          contentType: 'image/jpeg',
        );
      }

      final bookData = {
        'title': _titleController.text,
        'author': _authorController.text,
        'description': _descController.text,
        'category_id': _selectedCategoryId,
        'file_url': bookUrl,
        'epub_url': epubUrl,
        'cover_url': coverUrl,
        'metadata': {
          'pages': _pagesController.text,
          'format': epubUrl != null ? 'epub' : 'pdf',
        },
      };

      if (widget.book != null) {
        await repo.updateBook(widget.book!.id, bookData);
      } else {
        await repo.createBook(
          title: bookData['title'] as String,
          author: bookData['author'] as String,
          description: bookData['description'] as String?,
          categoryId: bookData['category_id'] as String?,
          fileUrl: bookData['file_url'] as String?,
          epubUrl: bookData['epub_url'] as String?,
          coverUrl: bookData['cover_url'] as String?,
          metadata: bookData['metadata'] as Map<String, dynamic>,
        );
      }

      if (mounted) {
        context.showSuccess(widget.book != null ? 'Book updated!' : 'Book uploaded!');
        ref.invalidate(adminBooksProvider);
        // Explicitly trigger library sync so it shows up in the user catalog immediately
        ref.read(libraryServiceProvider).syncBooks();
        context.pop();
      }
    } catch (e) {
      if (mounted) context.showError('Operation failed: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Upload Book', style: GoogleFonts.playfairDisplay(color: GardenPalette.nearBlack)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: GardenPalette.nearBlack),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: GardenPalette.lightGrey, height: 1),
        ),
      ),
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
                style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                decoration: GardenInputDecoration.standard(label: 'Title'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Author
              TextFormField(
                controller: _authorController,
                style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                decoration: GardenInputDecoration.standard(label: 'Author'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryId,
                style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                decoration: GardenInputDecoration.standard(label: 'Category'),
                items: _categories.map((c) {
                  return DropdownMenuItem<String>(
                    value: c.id,
                    child: Text(c.labelHu, style: GoogleFonts.outfit(color: GardenPalette.nearBlack)),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedCategoryId = v),
              ),

              const SizedBox(height: 16),
              
              // Description
              TextFormField(
                controller: _descController,
                maxLines: 3,
                style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                decoration: GardenInputDecoration.standard(label: 'Description'),
              ),
              const SizedBox(height: 16),

              // Metadata
              TextFormField(
                controller: _pagesController,
                style: GoogleFonts.outfit(color: GardenPalette.nearBlack),
                decoration: GardenInputDecoration.standard(label: 'Pages (optional)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              // File Pickers
              _FilePickerCard(
                label: 'PDF File',
                fileName: _bookFileName,
                onPick: _pickBookFile,
                icon: Icons.picture_as_pdf,
              ),
              const SizedBox(height: 12),
              _FilePickerCard(
                label: 'EPUB File (Flowing Reader)',
                fileName: _epubFileName,
                onPick: _pickEpubFile,
                icon: Icons.auto_stories,
              ),
              const SizedBox(height: 12),
              _FilePickerCard(
                label: 'Cover Image',
                fileName: _coverFileName,
                onPick: _pickCoverFile,
                icon: Icons.image,
              ),

              const SizedBox(height: 32),

              // Submit
              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: GardenPalette.leafyGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isLoading 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) 
                  : Text(widget.book != null ? 'UPDATE BOOK' : 'UPLOAD BOOK', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilePickerCard extends StatelessWidget {
  final String label;
  final String? fileName;
  final VoidCallback onPick;
  final IconData icon;

  const _FilePickerCard({
    required this.label,
    this.fileName,
    required this.onPick,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: GardenPalette.lightGrey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: GardenPalette.leafyGreen),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                  if (fileName != null)
                    Text(fileName!, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            if (fileName == null)
              const Text('Select', style: TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
