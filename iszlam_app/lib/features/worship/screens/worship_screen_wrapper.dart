import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/garden_palette.dart';
import '../providers/worship_view_provider.dart';
import '../widgets/worship_sidebar.dart';
import '../../tools/screens/asmaul_husna_screen.dart';
import '../../tools/screens/tasbih_screen.dart';
import 'sanctuary_screen.dart';
import 'azkar_categories_screen.dart';
import '../../quran/screens/quran_screen.dart';
import '../../tools/screens/qibla_screen.dart';

/// Wrapper that provides the Reddit-style layout for the Worship tab.
/// Desktop: Sidebar + Content side by side.
/// Mobile: Content only (tools accessible via Sanctuary quick-links or Drawer).
class WorshipScreenWrapper extends ConsumerWidget {
  const WorshipScreenWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final selectedView = ref.watch(worshipViewProvider);

    if (isDesktop) {
      return Scaffold(
        backgroundColor: GardenPalette.white,
        body: Row(
          children: [
            const WorshipSidebar(),
            Container(width: 1, color: GardenPalette.lightGrey),
            Expanded(child: _buildContent(selectedView, context, ref)),
          ],
        ),
      );
    }

    // Mobile: just show the SanctuaryScreen (tools navigate via push)
    return const SanctuaryScreen();
  }

  Widget _buildContent(WorshipView view, BuildContext context, WidgetRef ref) {
    switch (view) {
      case WorshipView.sanctuary:
        return const SanctuaryScreen();
      case WorshipView.quran:
        return const QuranScreen();
      case WorshipView.duas:
        return const AzkarCategoriesScreen();
      case WorshipView.qibla:
        return const QiblaScreen();
      case WorshipView.tasbih:
        return const TasbihScreen();
      case WorshipView.names99:
        return const AsmaulHusnaScreen();
    }
  }
}


