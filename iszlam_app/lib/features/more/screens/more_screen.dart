import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/garden_palette.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/auth_service.dart';
import '../../worship/widgets/worship_sidebar.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final isLoggedIn = user != null;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.obsidian,
      drawer: !isDesktop ? const WorshipSidebar() : null,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: GardenPalette.deepDepthGradient,
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isDesktop) ...[
                        IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                        const SizedBox(height: 12),
                      ],
                      Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: GardenPalette.vibrantEmeraldGradient,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              isLoggedIn ? Icons.person : Icons.person_outline,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isLoggedIn
                                      ? (user.email ?? 'Felhasználó')
                                      : 'Vendég',
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  isLoggedIn
                                      ? 'Közösségi tag'
                                      : 'Jelentkezz be a teljes élményért',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),



          // Account Section
          SliverToBoxAdapter(
            child: _buildSectionLabel('FIÓK'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (!isLoggedIn)
                    _MoreTile(
                      icon: Icons.login,
                      title: 'Bejelentkezés',
                      subtitle: 'Csatlakozz a közösséghez',
                      color: GardenPalette.emeraldTeal,
                      onTap: () => context.push('/login'),
                    ),
                  if (isLoggedIn)
                    _MoreTile(
                      icon: Icons.person,
                      title: 'Profil',
                      subtitle: 'Fiók beállítása',
                      color: GardenPalette.emeraldTeal,
                      onTap: () {
                        // TODO: Profile screen
                      },
                    ),
                  // Admin Tools
                  if (isLoggedIn)
                    ref.watch(isAdminProvider).when(
                          data: (isAdmin) => isAdmin
                              ? Column(
                                  children: [
                                    _MoreTile(
                                      icon: Icons.people,
                                      title: 'Felhasználók kezelése',
                                      subtitle: 'Adminisztrátori rangok kezelése',
                                      color: GardenPalette.gildedGold,
                                      onTap: () => context.push('/admin/users'),
                                    ),
                                    _MoreTile(
                                      icon: Icons.lightbulb_outline,
                                      title: 'Napi inspiráció',
                                      subtitle: 'Hadísz és Korán idézetek kezelése',
                                      color: GardenPalette.emeraldTeal,
                                      onTap: () => context.push('/admin/inspiration'),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink(),
                          loading: () => const SizedBox.shrink(),
                          error: (e, s) => const SizedBox.shrink(),
                        ),
                  _MoreTile(
                    icon: Icons.settings,
                    title: 'Beállítások',
                    subtitle: 'Értesítések, nyelv, téma',
                    color: GardenPalette.mutedSilver,
                    onTap: () {
                      // TODO: Settings screen
                    },
                  ),
                  _MoreTile(
                    icon: Icons.info_outline,
                    title: 'Rólunk',
                    subtitle: 'Iszlam.com · Verzió 1.0',
                    color: GardenPalette.mutedSilver,
                    onTap: () {
                      // TODO: About screen
                    },
                  ),
                  if (isLoggedIn)
                    _MoreTile(
                      icon: Icons.logout,
                      title: 'Kijelentkezés',
                      subtitle: '',
                      color: GardenPalette.warningRed,
                      onTap: () async {
                        await Supabase.instance.client.auth.signOut();
                      },
                    ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 120)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: GardenPalette.gildedGold.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _MoreTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: GardenPalette.midnightForest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: GardenPalette.emeraldTeal.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: GardenPalette.ivory,
                    ),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: GardenPalette.darkGrey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: GardenPalette.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
