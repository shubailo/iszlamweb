import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dua.dart';
import '../../admin_tools/services/admin_repository.dart';
import '../services/azkar_data_service.dart';

final duaCategoriesProvider = FutureProvider<List<DuaCategory>>((ref) async {
  try {
    final repo = ref.watch(adminRepositoryProvider);
    final data = await repo.getDuaCategories();
    if (data.isNotEmpty) {
      return data.map((e) => DuaCategory.fromSupabase(e)).toList();
    }
  } catch (e) {
    // Fallback handled below
  }

  // Fallback to legacy JSON
  final service = AzkarDataService();
  final legacyCats = await service.loadCategories();
  return legacyCats.map((c) => DuaCategory(
    id: c.id.toString(),
    nameHu: c.nameHu ?? c.name,
  )).toList();
});

final categoryDuasProvider = FutureProvider.family<List<Dua>, String>((ref, categoryId) async {
  try {
    final repo = ref.watch(adminRepositoryProvider);
    final data = await repo.getDuas(categoryId);
    if (data.isNotEmpty) {
      return data.map((e) => Dua.fromSupabase(e)).toList();
    }
  } catch (e) {
    // Fallback handled below
  }

  // Fallback: If categoryId is numeric, it might be legacy
  final legacyId = int.tryParse(categoryId);
  if (legacyId != null) {
    final service = AzkarDataService();
    final categories = await service.loadCategories();
    final category = categories.firstWhere((c) => c.id == legacyId);
    final supplicationsMap = await service.loadSupplications();
    
    return category.supplicationIds
        .where((id) => supplicationsMap.containsKey(id))
        .map((id) {
          final s = supplicationsMap[id]!;
          return Dua(
            id: s.id.toString(),
            categoryId: categoryId,
            titleHu: s.reference, // Reference as title if none
            arabicText: s.arabicText,
            vocalizedText: s.vocalizedText,
            reference: s.reference,
            repeatCount: s.repeatCount,
          );
        }).toList();
  }

  return [];
});
