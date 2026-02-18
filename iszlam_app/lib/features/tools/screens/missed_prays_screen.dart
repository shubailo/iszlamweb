import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/garden_palette.dart';

class MissedPraysScreen extends StatefulWidget {
  const MissedPraysScreen({super.key});

  @override
  State<MissedPraysScreen> createState() => _MissedPraysScreenState();
}

class _MissedPraysScreenState extends State<MissedPraysScreen> {
  final _prayers = <String, int>{
    'Fajr (Szubh)': 0,
    'Dhuhr (Zuhr)': 0,
    'Asr': 0,
    'Maghrib': 0,
    'Isha': 0,
    'Vitr': 0,
  };

  final _icons = <String, IconData>{
    'Fajr (Szubh)': Icons.wb_twilight_outlined,
    'Dhuhr (Zuhr)': Icons.wb_sunny_outlined,
    'Asr': Icons.sunny_snowing,
    'Maghrib': Icons.nightlight_outlined,
    'Isha': Icons.dark_mode_outlined,
    'Vitr': Icons.auto_awesome_outlined,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (final key in _prayers.keys) {
        _prayers[key] = prefs.getInt('missed_$key') ?? 0;
      }
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    for (final entry in _prayers.entries) {
      await prefs.setInt('missed_${entry.key}', entry.value);
    }
  }

  void _increment(String name) {
    HapticFeedback.lightImpact();
    setState(() => _prayers[name] = (_prayers[name] ?? 0) + 1);
    _saveData();
  }

  void _decrement(String name) {
    if ((_prayers[name] ?? 0) <= 0) return;
    HapticFeedback.lightImpact();
    setState(() => _prayers[name] = (_prayers[name] ?? 0) - 1);
    _saveData();
  }

  int get _totalMissed => _prayers.values.fold(0, (a, b) => a + b);

  void _resetAll() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Visszaállítás', style: GoogleFonts.playfairDisplay(color: GardenPalette.nearBlack)),
        content: Text('Biztosan törölni szeretnéd az összes elmaradt imát?', style: GoogleFonts.outfit(color: GardenPalette.nearBlack)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Mégse', style: GoogleFonts.outfit(color: GardenPalette.darkGrey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                for (final key in _prayers.keys) {
                  _prayers[key] = 0;
                }
              });
              _saveData();
              Navigator.pop(ctx);
            },
            child: Text('Törlés', style: GoogleFonts.outfit(color: GardenPalette.errorRed)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GardenPalette.white,
      appBar: AppBar(
        title: Text('Elmaradt Imák', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt, color: GardenPalette.errorRed),
            onPressed: _resetAll,
            tooltip: 'Visszaállítás',
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [GardenPalette.deepGreen, GardenPalette.leafyGreen],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                  child: const Icon(Icons.mosque_outlined, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Összes elmaradt ima', style: GoogleFonts.outfit(fontSize: 13, color: Colors.white.withAlpha(200))),
                    const SizedBox(height: 4),
                    Text('$_totalMissed', style: GoogleFonts.playfairDisplay(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Prayer list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _prayers.length,
              itemBuilder: (context, index) {
                final name = _prayers.keys.elementAt(index);
                final count = _prayers[name] ?? 0;
                final icon = _icons[name] ?? Icons.circle;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: GardenPalette.offWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: count > 0
                          ? GardenPalette.leafyGreen.withValues(alpha: 0.3)
                          : GardenPalette.lightGrey,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: GardenPalette.leafyGreen.withValues(alpha: 0.1),
                        ),
                        child: Icon(icon, color: GardenPalette.leafyGreen, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          name,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            color: GardenPalette.nearBlack,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      // Decrement
                      _circleButton(
                        icon: Icons.remove,
                        onTap: () => _decrement(name),
                        enabled: count > 0,
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 40,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: count > 0 ? GardenPalette.leafyGreen : GardenPalette.darkGrey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Increment
                      _circleButton(
                        icon: Icons.add,
                        onTap: () => _increment(name),
                        enabled: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Info text
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'A qada (elmaradt) imáidat itt követheted nyomon.\nImádkozz rendszeresen, és csökkentsd a számlálót!',
              style: GoogleFonts.outfit(fontSize: 12, color: GardenPalette.darkGrey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled
              ? GardenPalette.leafyGreen.withValues(alpha: 0.1)
              : GardenPalette.lightGrey,
          border: Border.all(
            color: enabled
                ? GardenPalette.leafyGreen.withValues(alpha: 0.4)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? GardenPalette.leafyGreen : GardenPalette.grey,
        ),
      ),
    );
  }
}
