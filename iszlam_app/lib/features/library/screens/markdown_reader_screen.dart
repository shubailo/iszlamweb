import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../models/library_item.dart';

class MarkdownReaderScreen extends StatefulWidget {
  final LibraryItem item;

  const MarkdownReaderScreen({super.key, required this.item});

  @override
  State<MarkdownReaderScreen> createState() => _MarkdownReaderScreenState();
}

class _MarkdownReaderScreenState extends State<MarkdownReaderScreen> {
  String? _markdownData;
  bool _isLoading = true;
  double _fontSize = 18.0;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadMarkdown();
  }

  Future<void> _loadMarkdown() async {
    try {
      final mdPath = widget.item.mediaUrl.replaceAll('.pdf', '.md');
      final content = await rootBundle.loadString(mdPath);
      if (mounted) {
        setState(() {
          _markdownData = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _markdownData = "# Hiba a betöltéskor\n\nNem található a könyv szöveges változata. Kérlek ellenőrizd a fájlt.\n\n($e)";
          _isLoading = false;
        });
      }
    }
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  Color get _backgroundColor => _isDarkMode ? const Color(0xFF1E1E1E) : GardenPalette.nearBlack;
  Color get _textColor => _isDarkMode ? const Color(0xFFE0E0E0) : Colors.black87;
  Color get _headingColor => _isDarkMode ? const Color(0xFFFFFFFF) : GardenPalette.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, 
      appBar: AppBar(
        title: Text(
          widget.item.title,
          style: GoogleFonts.playfairDisplay(
            color: _headingColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: _backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _headingColor),
        actions: [
           IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: _isDarkMode ? "Világos mód" : "Sötét mód",
          ),
          IconButton(
            icon: const Icon(Icons.remove),
            onPressed: () => setState(() => _fontSize = (_fontSize - 2).clamp(12.0, 32.0)),
          ),
           Center(child: Text("${_fontSize.toInt()}", style: TextStyle(color: _headingColor))),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => setState(() => _fontSize = (_fontSize + 2).clamp(12.0, 32.0)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Markdown(
              data: _markdownData ?? '',
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.merriweather( // Serif font for reading
                  fontSize: _fontSize,
                  height: 1.6,
                  color: _textColor,
                ),
                h1: GoogleFonts.playfairDisplay(
                  fontSize: _fontSize * 1.6,
                  fontWeight: FontWeight.bold,
                  color: _headingColor,
                ),
                h2: GoogleFonts.playfairDisplay(
                  fontSize: _fontSize * 1.4,
                  fontWeight: FontWeight.bold,
                  color: _headingColor,
                ),
                h3: GoogleFonts.playfairDisplay(
                  fontSize: _fontSize * 1.2,
                  fontWeight: FontWeight.bold,
                  color: _headingColor,
                ),
                strong: TextStyle(fontWeight: FontWeight.bold, color: _textColor),
                em: TextStyle(fontStyle: FontStyle.italic, color: _textColor),
                blockquote: GoogleFonts.merriweather(
                  fontSize: _fontSize,
                  fontStyle: FontStyle.italic,
                  color: _textColor.withAlpha(180),
                ),
                blockquoteDecoration: BoxDecoration(
                  color: _isDarkMode ? Colors.white.withAlpha(10) : GardenPalette.leafyGreen.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: GardenPalette.leafyGreen, width: 4)),
                ),
              ),
            ),
    );
  }
}
