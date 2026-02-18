import 'jamat_rule.dart';

class MosqueTiming {
  final JamatRule fajr;
  final JamatRule dhuhr;
  final JamatRule asr;
  final JamatRule maghrib;
  final JamatRule isha;
  
  /// List of Jummah times found on Fridays e.g. ["13:00", "14:00"]
  final List<String> jummahTimes;

  const MosqueTiming({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.jummahTimes,
  });

  factory MosqueTiming.fromJson(Map<String, dynamic> json) {
    return MosqueTiming(
      fajr: JamatRule.fromJson(json['fajr']),
      dhuhr: JamatRule.fromJson(json['dhuhr']),
      asr: JamatRule.fromJson(json['asr']),
      maghrib: JamatRule.fromJson(json['maghrib']),
      isha: JamatRule.fromJson(json['isha']),
      jummahTimes: List<String>.from(json['jummah_times'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr.toJson(),
      'dhuhr': dhuhr.toJson(),
      'asr': asr.toJson(),
      'maghrib': maghrib.toJson(),
      'isha': isha.toJson(),
      'jummah_times': jummahTimes,
    };
  }
}
