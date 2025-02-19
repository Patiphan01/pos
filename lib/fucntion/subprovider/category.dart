import '../tableprovider.dart';

class Category {
  final String name;
  final String imageUrl;

  Category({
    required this.name,
    required this.imageUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String determineCategoryName(Map<String, dynamic> json, String? language) {
      switch (language) {
        case 'CN':
          return json['name_cn'] ?? json['name'] ?? 'Uncategorized';
        case 'TH':
          return json['name_th'] ?? json['name'] ?? 'Uncategorized';
        case 'JA':
          return json['name_ja'] ?? json['name'] ?? 'Uncategorized';
        default:
          return json['name'] ?? 'Uncategorized';
      }
    }

    return Category(
      name: determineCategoryName(json, TableProvider.language),
      imageUrl: json['picture'] ?? '',
    );
  }

  @override
  String toString() => 'Category(name: $name, imageUrl: $imageUrl)';
}
