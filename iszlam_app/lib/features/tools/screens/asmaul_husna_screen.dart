import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';

class _HusnaName {
  final int number;
  final String arabic;
  final String transliteration;
  final String meaning;

  const _HusnaName({
    required this.number,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
  });

  factory _HusnaName.fromJson(Map<String, dynamic> json) {
    return _HusnaName(
      number: json['number'] as int,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      meaning: json['meaning'] as String,
    );
  }
}

class AsmaulHusnaScreen extends StatefulWidget {
  const AsmaulHusnaScreen({super.key});

  @override
  State<AsmaulHusnaScreen> createState() => _AsmaulHusnaScreenState();
}

class _AsmaulHusnaScreenState extends State<AsmaulHusnaScreen> {
  List<_HusnaName> _names = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/data/99_names.json');
      final List<dynamic> jsonList = json.decode(jsonStr);
      setState(() {
        _names = jsonList.map((e) => _HusnaName.fromJson(e)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text('Allah 99 Neve', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen));
    }
    if (_error != null) {
      return Center(
        child: Text('Hiba: $_error', style: GoogleFonts.outfit(color: GardenPalette.errorRed)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _names.length,
      itemBuilder: (context, index) {
        final name = _names[index];
        return _buildNameCard(name);
      },
    );
  }

  Widget _buildNameCard(_HusnaName name) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: GardenPalette.offWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: GardenPalette.lightGrey),
      ),
      child: Row(
        children: [
          // Number badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: GardenPalette.leafyGreen.withValues(alpha: 0.12),
            ),
            alignment: Alignment.center,
            child: Text(
              '${name.number}',
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: GardenPalette.leafyGreen,
              ),
            ),
          ),
          const SizedBox(width: 14),
          // Transliteration + Meaning
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.transliteration,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: GardenPalette.nearBlack,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  name.meaning,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: GardenPalette.darkGrey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Arabic
          Text(
            name.arabic,
            style: GoogleFonts.amiri(
              fontSize: 26,
              color: GardenPalette.leafyGreen,
              fontWeight: FontWeight.bold,
            ),
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
