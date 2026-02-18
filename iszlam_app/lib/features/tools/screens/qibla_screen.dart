
import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
import '../../worship/widgets/worship_sidebar.dart';
import 'package:permission_handler/permission_handler.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _locationStreamController = StreamController<LocationStatus>.broadcast();
  bool _isSimulationMode = false;

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  @override
  void initState() {
    _checkLocationStatus();
    super.initState();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    super.dispose();
  }

  Future<void> _checkLocationStatus() async {
    final status = await Permission.location.status;
    if (status.isDenied) {
      await Permission.location.request();
    }
    
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled && locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }

  void _toggleSimulation() {
    setState(() {
      _isSimulationMode = !_isSimulationMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: GardenPalette.white,
      drawer: !isDesktop ? const WorshipSidebar() : null,
      appBar: AppBar(
        title: Text('Qibla Iránytű', style: GoogleFonts.playfairDisplay(color: GardenPalette.leafyGreen, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: !isDesktop ? Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: GardenPalette.nearBlack),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ) : null,
        iconTheme: const IconThemeData(color: GardenPalette.nearBlack),
        actions: [
          IconButton(
            icon: Icon(_isSimulationMode ? Icons.bug_report : Icons.bug_report_outlined, color: GardenPalette.leafyGreen),
            onPressed: _toggleSimulation,
            tooltip: "Szimuláció mód",
          )
        ],
      ),
      body: _isSimulationMode 
        ? _buildSimulationView()
        : StreamBuilder<LocationStatus>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen));
              }
              
              if (snapshot.data?.enabled == true) {
                switch (snapshot.data?.status) {
                  case LocationPermission.always:
                  case LocationPermission.whileInUse:
                    return const QiblahCompassWidget();
                  case LocationPermission.denied:
                  case LocationPermission.deniedForever:
                    return _buildPlaceholderView("Helymeghatározás megtagadva");
                  default:
                    return _buildPlaceholderView("Helymeghatározás szükséges");
                }
              } else {
                return _buildPlaceholderView("Kapcsold be a helymeghatározást");
              }
            },
          ),
    );
  }

  Widget _buildPlaceholderView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _CompassVisualization(angle: 0.0, isPlaceholder: true),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: GardenPalette.errorRed.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              message,
              style: GoogleFonts.outfit(
                color: GardenPalette.errorRed,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _checkLocationStatus,
            icon: const Icon(Icons.refresh, color: GardenPalette.leafyGreen),
            label: Text("Próbáld újra", style: GoogleFonts.outfit(color: GardenPalette.leafyGreen)),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SZIMULÁCIÓ MÓD", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 20),
          const _CompassVisualization(angle: 0.5), 
          const SizedBox(height: 20),
          Text("Az iránytű manuálisan mozog szimulációhoz.", style: GoogleFonts.outfit(color: GardenPalette.darkGrey)),
        ],
      ),
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: GardenPalette.leafyGreen));
        }

        if (snapshot.hasError) {
          return _buildErrorView("Hiba az iránytű betöltésekor");
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) return const SizedBox();

        var angle = ((qiblahDirection.qiblah) * (pi / 180) * -1);
        
        return _CompassVisualization(angle: angle);
      },
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: GardenPalette.errorRed),
          const SizedBox(height: 16),
          Text(message, style: GoogleFonts.outfit(color: GardenPalette.errorRed)),
        ],
      ),
    );
  }
}

class _CompassVisualization extends StatelessWidget {
  final double angle;
  final bool isPlaceholder;
  const _CompassVisualization({required this.angle, this.isPlaceholder = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: isPlaceholder ? 0.5 : 1.0,
        child: SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Transform.rotate(
                angle: angle,
                child: SvgPicture.asset(
                  'assets/qibla/circle.svg', 
                  colorFilter: const ColorFilter.mode(GardenPalette.nearBlack, BlendMode.srcIn),
                ),
              ),
              SvgPicture.asset(
                'assets/qibla/kaaba_qibla.svg',
                // Keep original colors for Kaaba if possible, or tint it to match theme
                colorFilter: const ColorFilter.mode(GardenPalette.leafyGreen, BlendMode.srcIn),
              ), 
              SvgPicture.asset(
                'assets/qibla/pointer.svg',
                colorFilter: const ColorFilter.mode(GardenPalette.amber, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
