import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mosque.dart';

final mosqueListProvider = FutureProvider<List<Mosque>>((ref) async {
  final supabase = Supabase.instance.client;
  
  final List<dynamic> response = await supabase
      .from('mosques')
      .select()
      .order('name');
  
  return response.map((json) => Mosque.fromJson(json)).toList();
});

final mosqueByIdProvider = FutureProvider.family<Mosque?, String>((ref, id) async {
  final mosques = await ref.watch(mosqueListProvider.future);
  try {
    return mosques.firstWhere((m) => m.id == id);
  } catch (_) {
    return null;
  }
});

final selectedMosqueIdProvider = NotifierProvider<SelectedMosqueIdNotifier, String?>(SelectedMosqueIdNotifier.new);

class SelectedMosqueIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void update(String? newState) => state = newState;
}

