class TableData {
  final int id;
  final String name;
  int state; // สถานะของโต๊ะ
  int? people;
  List<Map<String, dynamic>> orders;
  String? orderId; // เพิ่มฟิลด์ orderId เพื่อเก็บข้อมูล Order ID

  TableData({
    required this.id,
    required this.state,
    required this.name,
    this.people,
    this.orderId,
    List<Map<String, dynamic>>? orders,
  }) : orders = orders ?? [];

  void updatePeople(int? newPeople) {
    people = newPeople;
    state = (people == null || people == 0) ? 0 : 1;
  }

  void reset() {
    state = 0;
    people = null;
    orders.clear();
  }
}
