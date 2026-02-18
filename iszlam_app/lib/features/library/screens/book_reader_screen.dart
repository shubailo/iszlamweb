import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfrx/pdfrx.dart';
import '../models/book.dart';
import '../models/reading_progress.dart';
import '../providers/library_provider.dart';

class BookReaderScreen extends ConsumerStatefulWidget {
  final Book book;

  const BookReaderScreen({super.key, required this.book});

  @override
  ConsumerState<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends ConsumerState<BookReaderScreen> {
  late PdfViewerController _pdfController;
  int _currentPage = 1;
  int _totalPages = 0;
  bool _isOverlayVisible = true;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    // Load initial progress
    final progress = ref.read(libraryServiceProvider).getProgress(widget.book.id);
    if (progress != null && progress.currentPage > 1) {
       // Controller doesn't support initialPage yet directly in constructor in older versions?
       // Wait, pdfrx supports initialPage in PdfViewer.file
       _currentPage = progress.currentPage;
    }
  }
  
  void _saveProgress() {
    if (_totalPages == 0) return;
    
    final progress = ReadingProgress(
      bookId: widget.book.id,
      currentPage: _currentPage,
      percentage: _currentPage / _totalPages,
      lastReadAt: DateTime.now(),
    );
    ref.read(libraryServiceProvider).saveProgress(progress);
    // Refresh library list to update progress bars
    ref.invalidate(libraryBooksProvider);
  }

  @override
  void dispose() {
    _saveProgress();
    // _pdfController.dispose(); // Not needed for pdfrx controller in newer versions or valid?
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PdfViewer.file(
            widget.book.filePath,
            controller: _pdfController,
            initialPageNumber: _currentPage,
            params: PdfViewerParams(
              onViewerReady: (document, controller) {
                setState(() {
                  _totalPages = document.pages.length;
                });
              },
              onPageChanged: (pageNumber) {
                setState(() {
                  _currentPage = pageNumber ?? 1;
                });
                _saveProgress();
              },
               // Tap to toggle overlay
               // onViewerTouch: ... implemented by gesture detector wrapper?
            ),
          ),
          
          // Overlay (App Bar)
          if (_isOverlayVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppBar(
                title: Text(widget.book.title, style: const TextStyle(fontSize: 16)),
                backgroundColor: Colors.black.withValues(alpha: 0.7),
                elevation: 0,
                iconTheme: const IconThemeData(color: Colors.white),
                titleTextStyle: const TextStyle(color: Colors.white),
              ),
            ),

          // Overlay (Bottom Bar)
          if (_isOverlayVisible)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withValues(alpha: 0.7),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      '$_currentPage / $_totalPages',
                       style: const TextStyle(color: Colors.white),
                     ),
                     // Slider could go here
                  ],
                ),
              ),
            ),
            
            // Toggle Overlay Gesture (Transparent)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                   // This blocks PDF interaction? No, PDF viewer consumes gestures.
                   // We need a specific gesture configuration or use viewer parameters.
                   // pdfrx handles scroll/zoom. Tap is tricky.
                   // Let's rely on a Floating Button for menu or assume Always On for now.
                   setState(() {
                     _isOverlayVisible = !_isOverlayVisible;
                   });
                },
                child: IgnorePointer(child: Container()), // Pass through
              ),
            ),
        ],
      ),
    );
  }
}
