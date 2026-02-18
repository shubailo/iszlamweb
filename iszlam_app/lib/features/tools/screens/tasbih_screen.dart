import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/garden_palette.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _totalCount = 0;
  int _goal = 33;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  static const _presetGoals = [33, 99, 100, 500, 1000];

  final _dhikrList = [
    'سُبْحَانَ اللّهِ',
    'الْحَمْدُ لِلّهِ',
    'اللّهُ أَكْبَرُ',
    'لَا إِلَهَ إِلَّا اللّهُ',
    'أَسْتَغْفِرُ اللّهَ',
    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّهِ',
  ];
  final _dhikrTranslations = [
    'Szubhán Alláh (Dicsőség Allahnak)',
    'Alhamdulilláh (Hála Allahnak)',
    'Alláhu Akbar (Allah a Legnagyobb)',
    'Lá iláha illalláh (Nincs isten Allahon kívül)',
    'Asztag-firulláh (Allah bocsánatát kérem)',
    'Lá havla va lá quvvata illá billáh',
  ];

  int _selectedDhikr = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _loadData();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _totalCount = prefs.getInt('tasbih_total') ?? 0;
      _goal = prefs.getInt('tasbih_goal') ?? 33;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tasbih_total', _totalCount);
    await prefs.setInt('tasbih_goal', _goal);
  }

  void _increment() {
    HapticFeedback.lightImpact();
    _pulseController.forward().then((_) => _pulseController.reverse());

    setState(() {
      _count++;
      _totalCount++;
      if (_count >= _goal) {
        HapticFeedback.heavyImpact();
        _count = 0;
        _selectedDhikr = (_selectedDhikr + 1) % _dhikrList.length;
      }
    });
    _saveData();
  }

  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() => _count = 0);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _goal > 0 ? _count / _goal : 0.0;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar (Garden Style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // Spacer to center the title
                  Text(
                    'TASBIH',
                    style: GoogleFonts.playfairDisplay(
                      color: GardenPalette.leafyGreen,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      PopupMenuButton<int>(
                        icon: const Icon(Icons.flag_outlined, color: GardenPalette.leafyGreen),
                        onSelected: (val) => setState(() { _goal = val; _count = 0; _saveData(); }),
                        itemBuilder: (_) => _presetGoals.map((g) =>
                          PopupMenuItem(value: g, child: Text('Cél: $g', style: GoogleFonts.outfit())),
                        ).toList(),
                        color: GardenPalette.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: GardenPalette.leafyGreen),
                        onPressed: _reset,
                        tooltip: 'Visszaállítás',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Dhikr Section (Clean Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: GardenPalette.offWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GardenPalette.lightGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      _dhikrList[_selectedDhikr],
                      style: GoogleFonts.amiri(
                        fontSize: 36,
                        color: GardenPalette.leafyGreen,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _dhikrTranslations[_selectedDhikr],
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        color: GardenPalette.charcoal,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // Counter Button (Modern Minimal)
            GestureDetector(
              onTap: _increment,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                ),
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: GardenPalette.white,
                    border: Border.all(color: GardenPalette.lightGrey, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: GardenPalette.leafyGreen.withAlpha(15),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress Ring
                      SizedBox(
                        width: 250,
                        height: 250,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          backgroundColor: GardenPalette.lightGrey.withValues(alpha: 0.5),
                          valueColor: const AlwaysStoppedAnimation(GardenPalette.leafyGreen),
                        ),
                      ),
                      // Count
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_count',
                            style: GoogleFonts.outfit(
                              fontSize: 90,
                              fontWeight: FontWeight.w900,
                              color: GardenPalette.nearBlack,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: GardenPalette.leafyGreen.withAlpha(20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'CÉL: $_goal',
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: GardenPalette.leafyGreen,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Total Counter Footer
            Padding(
              padding: const EdgeInsets.all(32),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: GardenPalette.offWhite,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: GardenPalette.lightGrey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'ÖSSZES SZÁMOLÁS:',
                      style: GoogleFonts.outfit(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                        color: GardenPalette.darkGrey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_totalCount',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: GardenPalette.leafyGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
