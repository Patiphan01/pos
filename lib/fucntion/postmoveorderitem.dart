import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> postMoveOrderItems() async {
  final url = 'https://sounddev.triggersplus.com/order/move_order_items/31D8702BC5C23FAD8C355A7032D21A9E/';
  
  // Payload ที่ต้องการส่งตามรูปแบบที่กำหนด
  final Map<String, dynamic> payload = {
    "staff": {
      "id": "2",
      "name": "Manager"
    },
    "data": {
      "items": [
        {"id": "2282", "amount": 3},
        {"id": "2283", "amount": 1},
        {"id": "2284", "amount": 5},
        {"id": "2283", "amount": 1}
      ],
      "table": {
        "name": "4",
        "split": 0,
        "zone": "table"
      }
    }
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200) {
      print("POST successful: ${response.body}");
    } else {
      print("POST failed: ${response.statusCode} - ${response.body}");
    }
  } catch (e) {
    print("Error during POST: $e");
  }
}
