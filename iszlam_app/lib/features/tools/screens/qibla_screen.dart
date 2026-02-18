
import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/garden_palette.dart';
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
    return Scaffold(
      backgroundColor: GardenPalette.ivory,
      appBar: AppBar(
        title: Text('Qibla Iránytű', style: GoogleFonts.playfairDisplay(color: GardenPalette.midnightForest)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: GardenPalette.midnightForest),
        actions: [
          IconButton(
            icon: Icon(_isSimulationMode ? Icons.bug_report : Icons.bug_report_outlined),
            onPressed: _toggleSimulation,
            tooltip: "Toggle Simulation Mode",
          )
        ],
      ),
      body: _isSimulationMode 
        ? _buildSimulationView()
        : StreamBuilder<LocationStatus>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: GardenPalette.midnightForest));
              }
              
              if (snapshot.data?.enabled == true) {
                switch (snapshot.data?.status) {
                  case LocationPermission.always:
                  case LocationPermission.whileInUse:
                    return const QiblahCompassWidget();
                  case LocationPermission.denied:
                    return Center(child: Text("Location permission denied", style: GoogleFonts.outfit(color: GardenPalette.warningRed)));
                  case LocationPermission.deniedForever:
                    return Center(child: Text("Location permission denied forever", style: GoogleFonts.outfit(color: GardenPalette.warningRed)));
                  default:
                    return const SizedBox();
                }
              } else {
                return Center(child: Text("Please enable Location service", style: GoogleFonts.outfit(color: GardenPalette.warningRed)));
              }
            },
          ),
    );
  }

  Widget _buildSimulationView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("SIMULATION MODE", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.orange)),
          const SizedBox(height: 20),
          const _CompassVisualization(angle: 0.5), 
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
          return const Center(child: CircularProgressIndicator(color: GardenPalette.midnightForest));
        }

        if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}", style: GoogleFonts.outfit(color: Colors.red)));
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) return const SizedBox();

        var angle = ((qiblahDirection.qiblah) * (pi / 180) * -1);
        
        return _CompassVisualization(angle: angle);
      },
    );
  }
}

class _CompassVisualization extends StatelessWidget {
  final double angle;
  const _CompassVisualization({required this.angle});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                colorFilter: const ColorFilter.mode(GardenPalette.midnightForest, BlendMode.srcIn),
              ),
            ),
            SvgPicture.asset(
              'assets/qibla/kaaba_qibla.svg',
              // Note: kaaba_qibla.svg might need coloring or be multi-colored. 
              // Leaving as-is for now based on Mi-raj implementation.
            ), 
            SvgPicture.asset(
              'assets/qibla/pointer.svg',
              colorFilter: const ColorFilter.mode(GardenPalette.gildedGold, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    );
  }
}
