import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/asmaul_husna.dart';
import '../../admin_tools/services/admin_repository.dart';

final asmaulHusnaProvider = FutureProvider<List<AsmaulHusna>>((ref) async {
  try {
    final repo = ref.watch(adminRepositoryProvider);
    final supabaseData = await repo.getAsmaulHusna();

    if (supabaseData.isNotEmpty) {
      return supabaseData.map((e) => AsmaulHusna.fromSupabase(e)).toList();
    }
  } catch (e) {
    // Fallback to JSON on error or if empty
  }

  // Fallback: Load from local JSON
  final jsonStr = await rootBundle.loadString('assets/data/99_names.json');
  final List<dynamic> jsonList = json.decode(jsonStr);
  return jsonList.map((e) => AsmaulHusna.fromJson(e)).toList();
});
