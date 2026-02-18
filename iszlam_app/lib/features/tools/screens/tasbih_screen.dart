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
    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
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
      appBar: AppBar(
        title: Text('Tasbih', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.flag_outlined, color: GardenPalette.leafyGreen),
            onSelected: (val) => setState(() { _goal = val; _count = 0; _saveData(); }),
            itemBuilder: (_) => _presetGoals.map((g) =>
              PopupMenuItem(value: g, child: Text('Cél: $g')),
            ).toList(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: GardenPalette.nearBlack),
            onPressed: _reset,
            tooltip: 'Visszaállítás',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Dhikr text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    _dhikrList[_selectedDhikr],
                    style: GoogleFonts.amiri(
                      fontSize: 36,
                      color: GardenPalette.nearBlack,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _dhikrTranslations[_selectedDhikr],
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      color: GardenPalette.darkGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Dhikr selector dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_dhikrList.length, (i) =>
                GestureDetector(
                  onTap: () => setState(() { _selectedDhikr = i; _count = 0; }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _selectedDhikr ? 12 : 8,
                    height: i == _selectedDhikr ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i == _selectedDhikr
                          ? GardenPalette.leafyGreen
                          : GardenPalette.lightGrey,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Counter circle
            GestureDetector(
              onTap: _increment,
              child: AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                ),
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [GardenPalette.deepGreen, GardenPalette.leafyGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: GardenPalette.leafyGreen.withValues(alpha: 0.3),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Progress ring
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          backgroundColor: Colors.white.withAlpha(40),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      // Count display
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$_count',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '/ $_goal',
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              color: Colors.white.withAlpha(180),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Érintsd meg a számláláshoz',
              style: GoogleFonts.outfit(
                fontSize: 13,
                color: GardenPalette.darkGrey,
              ),
            ),
            const Spacer(),
            // Total counter and goal info
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              decoration: BoxDecoration(
                color: GardenPalette.offWhite,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: GardenPalette.lightGrey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Összes számolás', style: GoogleFonts.outfit(fontSize: 12, color: GardenPalette.darkGrey)),
                      Text('$_totalCount', style: GoogleFonts.playfairDisplay(fontSize: 20, color: GardenPalette.leafyGreen, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Cél', style: GoogleFonts.outfit(fontSize: 12, color: GardenPalette.darkGrey)),
                      Text('$_goal', style: GoogleFonts.playfairDisplay(fontSize: 20, color: GardenPalette.nearBlack, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
