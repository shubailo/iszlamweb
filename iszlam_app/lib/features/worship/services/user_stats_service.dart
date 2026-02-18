import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_journey.dart';

final userStatsServiceProvider = Provider((ref) => UserStatsService());

final userJourneyProvider = FutureProvider<UserJourney>((ref) async {
  final service = ref.watch(userStatsServiceProvider);
  return service.getJourneyDetails();
});

class UserStatsService {
  /// Fetches the user's spiritual journey details.
  /// Currently returns mock data as a placeholder for Supabase integration.
  Future<UserJourney> getJourneyDetails() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return const UserJourney(
      pagesRead: 124,
      khutbasListened: 12,
      consecutivePrayerDays: 7,
      tasbihCount: 1250,
    );
  }

  /// Increments pages read in a session.
  Future<void> logPageRead() async {
    // STUB: To be implemented with Supabase
  }

  /// Logs a khutba session.
  Future<void> logKhutbaListened() async {
    // STUB: To be implemented with Supabase
  }
}
