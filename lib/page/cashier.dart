import 'package:flutter/material.dart';
import '../widget/cashier/centerzone/centerpage.dart'; // Middle Section Widget
import '../widget/cashier/leftzone/leftpage.dart'; // Left Section Widget
import '../widget/cashier/rightzone/rightpage.dart'; // Right Section Widget

class Cashier extends StatelessWidget {
  const Cashier({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFB7B2),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left Section
            Expanded(
              flex: 2, // 20% of space
              child: const LeftPage(),
            ),

            // Center Section
            Expanded(
              flex: 6, // 60% of space
              child: CenterSection(
                mockData: mockData,
              ),
            ),

            // Right Section
            Expanded(
              flex: 3, // 20% of space
              child: const RightPage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(
      String name, String qty, String unitPrice, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(flex: 1, child: Text(name)),
        Expanded(flex: 1, child: Text(qty, textAlign: TextAlign.center)),
        Expanded(flex: 1, child: Text(unitPrice, textAlign: TextAlign.center)),
        Expanded(flex: 1, child: Text(price, textAlign: TextAlign.right)),
      ],
    );
  }

  static Widget _buildSummaryRow(String label, String value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> mockData = List.generate(12, (index) {
  return {
    "item": "Menu Item ${index + 1}",
    "qty": "x${(index % 3) + 1}",
    "unitPrice": "100.00",
    "discount": index % 2 == 0 ? "20.00" : "0.00",
    "price": "${(100.00 * ((index % 3) + 1)) - (index % 2 == 0 ? 20 : 0)}",
  };
});
