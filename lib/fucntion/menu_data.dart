// lib/models/menu_item.dart
class MenuItem {
  final String item_id; // เพิ่ม field id
  final String name;
  final double price;

  MenuItem({
    required this.item_id,
    required this.name,
    required this.price,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      item_id: json['item_id']?.toString() ??
          '', // รับค่า id จาก JSON (แปลงเป็น string)
      name: json['name'] ?? 'No Name',
      price: (json['price'] ?? json['final_price'] ?? 0).toDouble(),
    );
  }

  @override
  String toString() => 'MenuItem(id: $item_id, name: $name, price: $price)';
}
