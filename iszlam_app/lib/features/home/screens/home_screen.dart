import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/localization/hungarian_strings.dart';
import '../../../core/theme/garden_palette.dart';
import '../widgets/daily_wisdom_hero.dart';
import '../widgets/bento_grid.dart';
import '../widgets/trending_section.dart';
import '../../auth/services/auth_service.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _heroOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {

    final offset = _scrollController.offset;
    final newOpacity = (1.0 - (offset / 400)).clamp(0.0, 1.0);
    
    if (newOpacity != _heroOpacity) {
      setState(() {
        _heroOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStreamProvider);

    return Scaffold(
      backgroundColor: GardenPalette.nearBlack,
      body: Stack(
        children: [
          // 1. Dynamic Hero Background Layer
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 700, 
            child: Opacity(
              opacity: _heroOpacity,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      GardenPalette.white,
                      Color(0xFF063A2E),
                      GardenPalette.nearBlack,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // 2. Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // 1. Hero Section
                const DailyWisdomHero()
                  .animate()
                  .fadeIn(duration: 800.ms)
                  .slideY(begin: 0.1, end: 0, curve: Curves.easeOutCubic),
                
                
                // 2. Main Content Wrapper
                Container(
                  width: double.infinity,
                  color: GardenPalette.nearBlack,
                  child: Column(
                    children: [
                       const SizedBox(height: 48),
                       
                       authState.when(
                         data: (_) => const BentoGrid(),
                         loading: () => const SizedBox(
                           height: 200,
                           child: Center(child: CircularProgressIndicator(color: GardenPalette.white)),
                         ),
                         error: (e, s) => const Center(child: Text(H.errorGeneric)),
                       )
                       .animate()
                       .fadeIn(delay: 200.ms, duration: 800.ms)
                       .slideY(begin: 0.05, end: 0),
                       
                       const SizedBox(height: 80),

                       // Trending / Publications Section
                       const TrendingSection(),
                       
                       const SizedBox(height: 120),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
