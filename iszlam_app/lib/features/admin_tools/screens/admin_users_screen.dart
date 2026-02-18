import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../../core/extensions/snackbar_helpers.dart';
import '../../../core/widgets/garden_error_view.dart';
import '../services/admin_repository.dart';
import '../models/admin_models.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: GardenPalette.offWhite,
      appBar: AppBar(
        title: Text(
          'Felhasználók kezelése',
          style: GoogleFonts.playfairDisplay(
            color: GardenPalette.nearBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: GardenPalette.nearBlack),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(usersProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: usersAsync.when(
        data: (users) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final AdminUser user = users[index];
            final isAdmin = user.isAdmin;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: GardenPalette.leafyGreen.withAlpha(30),
                  child: Text(
                    user.initial,
                    style: GoogleFonts.outfit(color: GardenPalette.leafyGreen, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  user.displayName,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  isAdmin ? 'Adminisztrátor' : 'Felhasználó',
                  style: GoogleFonts.outfit(
                    color: isAdmin ? GardenPalette.leafyGreen : GardenPalette.grey,
                    fontSize: 12,
                  ),
                ),
                trailing: Switch(
                  value: isAdmin,
                  activeThumbColor: GardenPalette.leafyGreen,
                  onChanged: (value) async {
                    await ref.read(adminRepositoryProvider).toggleAdminStatus(user.id, value);
                    ref.invalidate(usersProvider);
                    if (context.mounted) {
                      context.showSuccess('${user.displayName} mostantól ${value ? 'Admin' : 'Felhasználó'}');
                    }
                  },
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => GardenErrorView(message: 'Hiba: $e'),
      ),
    );
  }
}
