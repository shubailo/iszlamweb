class UserJourney {
  final int pagesRead;
  final int khutbasListened;
  final int consecutivePrayerDays;
  final int tasbihCount;

  const UserJourney({
    this.pagesRead = 0,
    this.khutbasListened = 0,
    this.consecutivePrayerDays = 0,
    this.tasbihCount = 0,
  });

  factory UserJourney.fromJson(Map<String, dynamic> json) {
    return UserJourney(
      pagesRead: json['pages_read'] ?? 0,
      khutbasListened: json['khutbas_listened'] ?? 0,
      consecutivePrayerDays: json['consecutive_prayer_days'] ?? 0,
      tasbihCount: json['tasbih_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pages_read': pagesRead,
      'khutbas_listened': khutbasListened,
      'consecutive_prayer_days': consecutivePrayerDays,
      'tasbih_count': tasbihCount,
    };
  }
}
