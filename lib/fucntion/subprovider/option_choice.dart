class OptionChoice {
  final String id;
  final String choice; // ภาษาเริ่มต้น (EN)
  final String choice_th;
  final String choice_cn;
  final String? choice_ja;
  final bool quantitySelectable;
  final double price;
  final String priceOption;
  final bool active;

  OptionChoice({
    required this.id,
    required this.choice,
    required this.choice_th,
    required this.choice_cn,
    this.choice_ja,
    required this.quantitySelectable,
    required this.price,
    required this.priceOption,
    required this.active,
  });

  factory OptionChoice.fromJson(Map<String, dynamic> json) {
    return OptionChoice(
      id: json['id'].toString(),
      choice: json['choice'] ?? '',
      choice_th: json['choice_th'] ?? '',
      choice_cn: json['choice_cn'] ?? '',
      choice_ja: json['choice_ja'],
      quantitySelectable: json['quantity_selectable'] ?? false,
      price: (json['price'] ?? 0).toDouble(),
      priceOption: json['price_option'] ?? '',
      active: json['active'] ?? false,
    );
  }
}
