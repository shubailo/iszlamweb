import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/azkar_category.dart';
import '../models/azkar_item.dart';
import '../services/azkar_data_service.dart';

final azkarDataServiceProvider = Provider<AzkarDataService>((ref) {
  return AzkarDataService();
});

final azkarCategoriesProvider = FutureProvider<List<AzkarCategory>>((ref) async {
  final service = ref.watch(azkarDataServiceProvider);
  return service.loadCategories();
});

final azkarSupplicationsMapProvider = FutureProvider<Map<int, AzkarItem>>((ref) async {
  final service = ref.watch(azkarDataServiceProvider);
  return service.loadSupplications();
});

final categorySupplicationsProvider = FutureProvider.family<List<AzkarItem>, List<int>>((ref, ids) async {
  final map = await ref.watch(azkarSupplicationsMapProvider.future);
  final List<AzkarItem> items = [];
  for (var id in ids) {
    if (map.containsKey(id)) {
      items.add(map[id]!);
    }
  }
  return items;
});
