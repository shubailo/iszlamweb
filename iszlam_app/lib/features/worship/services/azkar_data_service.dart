import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/azkar_category.dart';
import '../models/azkar_item.dart';

class AzkarDataService {
  Future<List<AzkarCategory>> loadCategories() async {
    // Load Arabic Source
    final String jsonString =
        await rootBundle.loadString('assets/data/azkar/Category.json');
    final List<dynamic> jsonList = json.decode(jsonString);

    // Load Hungarian Translations (Map<String, dynamic> -> Map<int, String>)
    Map<int, String> translations = {};
    try {
      final String transString =
          await rootBundle.loadString('assets/data/azkar/category_hu.json');
      final Map<String, dynamic> transJson = json.decode(transString);
      transJson.forEach((key, value) {
        translations[int.parse(key)] = value.toString();
      });
    } catch (e) {
      // print('Translation load error: $e');
    }

    return jsonList.map((json) {
      final category = AzkarCategory.fromJson(json);
      // Inject translation if available
      if (translations.containsKey(category.id)) {
        return AzkarCategory(
          id: category.id,
          name: category.name, // Arabic
          nameHu: translations[category.id], // Hungarian
          isFavorite: category.isFavorite,
          supplicationIds: category.supplicationIds,
        );
      }
      return category;
    }).toList();
  }

  Future<Map<int, AzkarItem>> loadSupplications() async {
    final String jsonString =
        await rootBundle.loadString('assets/data/azkar/Supplication.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    
    // Create map for O(1) lookup: ID -> Item
    final Map<int, AzkarItem> items = {};
    for (var json in jsonList) {
      final item = AzkarItem.fromJson(json);
      items[item.id] = item;
    }
    return items;
  }
}
