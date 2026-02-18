import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/library_item.dart';

class EpubReaderScreen extends StatefulWidget {
  final LibraryItem item;

  const EpubReaderScreen({super.key, required this.item});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  final _epubController = EpubController();
  List<EpubChapter> _chapters = [];
  bool _isLoading = true;

  void _downloadPdf() async {
    final pdfUrl = widget.item.fileUrl;
    if (pdfUrl != null && pdfUrl.isNotEmpty) {
      final uri = Uri.parse(pdfUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PDF not available for this book.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final epubUrl = widget.item.mediaUrl;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.item.title,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GardenPalette.nearBlack,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: GardenPalette.nearBlack),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: GardenPalette.nearBlack),
            onSelected: (value) {
              if (value == 'download_pdf') _downloadPdf();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'download_pdf',
                child: Row(
                  children: [
                    Icon(Icons.download, color: GardenPalette.leafyGreen, size: 20),
                    const SizedBox(width: 8),
                    const Text('Download PDF'),
                  ],
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: GardenPalette.lightGrey, height: 1),
        ),
      ),
      drawer: _chapters.isNotEmpty
          ? Drawer(
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Chapters',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = _chapters[index];
                          return ListTile(
                            title: Text(
                              chapter.title,
                              style: GoogleFonts.outfit(fontSize: 14),
                            ),
                            onTap: () {
                              _epubController.display(cfi: chapter.href);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: Stack(
        children: [
          EpubViewer(
            epubSource: EpubSource.fromUrl(epubUrl),
            epubController: _epubController,
            displaySettings: EpubDisplaySettings(
              flow: EpubFlow.paginated,
              snap: true,
            ),
            onChaptersLoaded: (chapters) {
              setState(() => _chapters = chapters);
            },
            onEpubLoaded: () {
              setState(() => _isLoading = false);
            },
            onRelocated: (value) {
              // Could save reading progress here
            },
          ),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: GardenPalette.leafyGreen),
                    const SizedBox(height: 16),
                    Text(
                      'Loading book...',
                      style: GoogleFonts.outfit(color: GardenPalette.charcoal),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
