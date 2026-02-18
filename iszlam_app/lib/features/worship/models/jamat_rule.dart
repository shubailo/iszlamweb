enum JamatType {
  /// A fixed time (e.g., "13:30")
  fixed,
  
  /// A fixed offset from the Adhan time (e.g., "+10 minutes")
  offset,
  
  /// A dynamic rule (e.g. "Maghrib is at sunset + 5, but if after 19:00 make it 19:15") - simplified for now
  dynamic, 
}

class JamatRule {
  final JamatType type;
  
  /// Used if type == JamatType.fixed. Format: "HH:mm" (24h)
  final String? fixedTime;
  
  /// Used if type == JamatType.offset. Minutes to add to Adhan time.
  final int? offsetMinutes;

  const JamatRule({
    required this.type,
    this.fixedTime,
    this.offsetMinutes,
  });

  factory JamatRule.fixed(String time) => 
      JamatRule(type: JamatType.fixed, fixedTime: time);
      
  factory JamatRule.offset(int minutes) => 
      JamatRule(type: JamatType.offset, offsetMinutes: minutes);

  factory JamatRule.fromJson(Map<String, dynamic> json) {
    return JamatRule(
      type: JamatType.values.firstWhere((e) => e.toString() == 'JamatType.${json['type']}'),
      fixedTime: json['fixed_time'],
      offsetMinutes: json['offset_minutes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'fixed_time': fixedTime,
      'offset_minutes': offsetMinutes,
    };
  }
}
