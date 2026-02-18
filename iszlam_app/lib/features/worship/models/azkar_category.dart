class AzkarCategory {
  final int id;
  final String name; // Arabic name from JSON
  final String? nameHu; // Hungarian name (to be populated)
  final bool isFavorite;
  final List<int> supplicationIds;

  AzkarCategory({
    required this.id,
    required this.name,
    this.nameHu,
    required this.isFavorite,
    required this.supplicationIds,
  });

  factory AzkarCategory.fromJson(Map<String, dynamic> json) {
    // Parse supplications list from structure like [{"id": 1}, {"id": 2}]
    final supplicationsList = json['supplications'] as List<dynamic>? ?? [];
    final supplicationIds = supplicationsList
        .map((e) => e['id'] as int)
        .toList();

    return AzkarCategory(
      id: json['id'] as int,
      name: json['name'] as String,
      isFavorite: json['favorite'] as bool? ?? false,
      supplicationIds: supplicationIds,
    );
  }
}
