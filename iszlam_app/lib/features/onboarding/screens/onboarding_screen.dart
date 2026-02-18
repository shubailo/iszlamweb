import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/garden_palette.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = const [
    _OnboardingPage(
      icon: Icons.mosque_outlined,
      title: 'Békességet!',
      subtitle: 'Asz-Szalámu Alejkum',
      description: 'Üdvözlünk az Iszlam.com alkalmazásban.\nFedezd fel az iszlám szépségét!',
    ),
    _OnboardingPage(
      icon: Icons.access_time_outlined,
      title: 'Imaidők',
      subtitle: 'Pontos imaidők a helyzeted alapján',
      description: 'Engedélyezd a helymeghatározást,\nhogy pontos imaidőket kapj\na tartózkodási helyedre.',
    ),
    _OnboardingPage(
      icon: Icons.auto_stories_outlined,
      title: 'Korán & Könyvtár',
      subtitle: 'Olvasd a Koránt és az iszlám irodalmat',
      description: 'Teljes Korán arab szöveggel,\nkönyvtár PDF könyvekkel,\nés napi bölcsességek.',
    ),
    _OnboardingPage(
      icon: Icons.explore_outlined,
      title: 'Készen Állsz!',
      subtitle: 'Fedezd fel az összes funkciót',
      description: 'Qibla iránytű, Tasbih számláló,\nAzkar, közösségi tartalmak\nés még sok más vár rád!',
    ),
  ];

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (mounted) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: GardenPalette.deepDepthGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextButton(
                    onPressed: _complete,
                    child: Text('Kihagyás', style: GoogleFonts.outfit(color: GardenPalette.white.withValues(alpha: 0.7))),
                  ),
                ),
              ),
              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => _buildPage(_pages[i]),
                ),
              ),
              // Page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (i) =>
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: i == _currentPage ? 28 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: i == _currentPage
                          ? GardenPalette.gold
                          : GardenPalette.white.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Next / Start button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == _pages.length - 1) {
                        _complete();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GardenPalette.gold,
                      foregroundColor: GardenPalette.deepGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: Text(
                      _currentPage == _pages.length - 1 ? 'Kezdjük!' : 'Tovább',
                      style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon in decorative circle
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  GardenPalette.white.withValues(alpha: 0.1),
                  GardenPalette.gold.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: GardenPalette.gold.withValues(alpha: 0.3)),
            ),
            child: Icon(page.icon, size: 56, color: GardenPalette.gold),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: GardenPalette.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            page.subtitle,
            style: GoogleFonts.outfit(
              fontSize: 16,
              color: GardenPalette.gold,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            page.description,
            style: GoogleFonts.outfit(
              fontSize: 15,
              color: GardenPalette.white.withValues(alpha: 0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String subtitle;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}
