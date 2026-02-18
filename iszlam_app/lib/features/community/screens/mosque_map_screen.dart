import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/mosque_provider.dart';
import '../models/mosque.dart';
import '../../../core/theme/garden_palette.dart';

class MosqueMapScreen extends ConsumerWidget {
  const MosqueMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mosquesAsync = ref.watch(mosqueListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mecsetkereső', style: GoogleFonts.playfairDisplay()),
        backgroundColor: Colors.white,
        foregroundColor: GardenPalette.nearBlack,
        elevation: 0,
      ),
      body: mosquesAsync.when(
        data: (mosques) {
          final markers = mosques
              .where((m) => m.latitude != null && m.longitude != null)
              .map((m) => Marker(
                    point: LatLng(m.latitude!, m.longitude!),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () => _showMosqueDetails(context, m),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(20),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.mosque, color: GardenPalette.leafyGreen, size: 24),
                      ),
                    ),
                  ))
              .toList();

          return FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(47.4979, 19.0402), // Budapest center
              initialZoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'hu.iszlamweb.app',
              ),
              MarkerLayer(markers: markers),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Hiba: $e')),
      ),
    );
  }

  void _showMosqueDetails(BuildContext context, Mosque mosque) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mosque.name,
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: GardenPalette.nearBlack,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${mosque.city}, ${mosque.address}',
              style: GoogleFonts.outfit(
                fontSize: 16,
                color: GardenPalette.charcoal,
              ),
            ),
            const SizedBox(height: 16),
            if (mosque.description != null)
              Text(
                mosque.description!,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  height: 1.5,
                  color: GardenPalette.charcoal.withAlpha(200),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GardenPalette.leafyGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('RENDBEN'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
