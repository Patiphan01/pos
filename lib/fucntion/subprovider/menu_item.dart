import '../tableprovider.dart';

class MenuItem {
  final String id; // เพิ่ม field id เพื่อเก็บ id ของเมนู
  final String name;
  final double price;
  final String imageUrl;
  final String? itemGroupOptions; // field สำหรับ group option id

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.itemGroupOptions,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    String determineName(Map<String, dynamic> json, String? language) {
      switch (language) {
        case 'CN':
          return json['name_cn'] ?? 'No Name';
        case 'TH':
          return json['name_th'] ?? 'No Name';
        case 'JA':
          return json['name_ja'] ?? 'No Name';
        default:
          return json['name'] ?? 'No Name';
      }
    }

    return MenuItem(
      id: json['id']?.toString() ?? '', // ดึง id จาก JSON (แปลงเป็น string)
      name: determineName(json, TableProvider.language),
      price: (json['price'] ?? json['final_price'] ?? 0).toDouble(),
      imageUrl: json['picture'] ?? '',
      itemGroupOptions: json['item_group_options'],
    );
  }

  @override
  String toString() =>
      'MenuItem(id: $id, name: $name, price: $price, imageUrl: $imageUrl, itemGroupOptions: $itemGroupOptions)';
}
