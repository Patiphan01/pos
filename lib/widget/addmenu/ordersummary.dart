// lib/widgets/order_summary.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fucntion/tableprovider.dart';
import 'movemenu.dart';
import 'Scanqr.dart';

class OrderSummary extends StatelessWidget {
  final String zone; // โซนที่เลือก
  final int tableNumber; // หมายเลขโต๊ะที่เลือก

  const OrderSummary({
    Key? key,
    required this.zone,
    required this.tableNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);

    // แจ้งให้ TableProvider รู้ว่าเรากำลังจะจัดการโต๊ะไหน
    tableProvider.selectTable(zone, tableNumber - 1);

    final currentTable = tableProvider.getTableData(zone, tableNumber - 1);
    if (currentTable == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please select a table first."),
        ),
      );
    }

    // คำนวณวันที่ปัจจุบัน
    String currentDate = _formatDate(DateTime.now());
    // คำนวณยอดรวม
    double subtotal = currentTable.orders.fold(
      0.0,
      (sum, item) => sum + (item['price'] * item['quantity']),
    );
    double serviceCharge = subtotal * 0.1; // 10% Service Charge
    double vat = subtotal * 0.07; // 7% VAT
    double grandTotal = subtotal + serviceCharge + vat;

    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDBDB),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------------------------------------------------------
            // Header
            // ------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your Order',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '#Table $tableNumber',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      zone,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentDate,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ------------------------------------------------------------
            // Move / Scan buttons
            // ------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _styledButton(
                  context: context,
                  label: 'Move',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MoveMenuPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                _styledButton(
                  context: context,
                  label: 'Scan',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MockScanQRCodePage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 5),

            // ------------------------------------------------------------
            // Current Order + Clear All
            // ------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Order',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                  onTap: () {
                    tableProvider.setTableData(
                      zone,
                      tableNumber - 1,
                      currentTable.people ?? 0,
                      [],
                    );
                    if (currentTable.orders.isEmpty) {
                      tableProvider.updateTableState(zone, tableNumber - 1, 0);
                    } else {
                      tableProvider.updateTableState(zone, tableNumber - 1, 1);
                    }
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: Color(0xFFFF6E6E),
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),

            // ------------------------------------------------------------
            // รายการออร์เดอร์ (ListView)
            // ------------------------------------------------------------
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(),
                child: ListView.separated(
                  primary: false,
                  itemCount: currentTable.orders.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    return _buildOrderItem(
                      context: context,
                      index: index,
                    );
                  },
                ),
              ),
            ),

            // ------------------------------------------------------------
            // สรุปราคา
            // ------------------------------------------------------------
            const Divider(),
            _totalRow('Subtotal', '${subtotal.toStringAsFixed(2)}.-'),
            _totalRow(
                'Service Charge', '${serviceCharge.toStringAsFixed(2)}.-'),
            _totalRow('VAT', '${vat.toStringAsFixed(2)}.-'),
            const Divider(),
            _totalRow(
              'Grand Total',
              '${grandTotal.toStringAsFixed(2)}.-',
              bold: true,
            ),

            // ------------------------------------------------------------
            // ปุ่ม Order / Check Bill
            // ------------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (currentTable.orders.isEmpty) {
                      tableProvider.updateTableState(zone, tableNumber - 1, 0);
                    } else {
                      tableProvider.updateTableState(zone, tableNumber - 1, 1);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6AB04C),
                    minimumSize: const Size(140, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Order',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    tableProvider.updateTableState(zone, tableNumber - 1, 2);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF86E8EF),
                    minimumSize: const Size(140, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Check Bill',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// ไม่มี currentTableData -> แก้เป็น getSelectedTable()
  Widget _buildOrderItem({
    required BuildContext context,
    required int index,
  }) {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final currentTable = tableProvider.getSelectedTable(); // เรียกตรงนี้
    if (currentTable == null) return const SizedBox.shrink();

    final order = currentTable.orders[index];
    final bool isNew = order['new'] ?? false;
    final dynamic options = order['options'];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isNew ? Colors.yellow.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // ------------------------------------------------------------
          // ชื่อเมนู + Options
          // ------------------------------------------------------------
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                // ถ้ามี options ให้แสดง
                if (options != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'เพิ่ม: ' +
                          options.entries
                              .map((e) =>
                                  '${e.key}: ${e.value is List ? (e.value as List).join(", ") : e.value.toString()}')
                              .join(' | '),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                if (isNew)
                  const Text(
                    'NEW',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),

          // ------------------------------------------------------------
          // ปุ่ม + / - จำนวน
          // ------------------------------------------------------------
          Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      tableProvider.removeMenuItemFromTable(
                        order['name'],
                        order['price'],
                        quantity: 1,
                      );
                    },
                  ),
                  Text(
                    order['quantity'].toString(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      tableProvider.addMenuItemToTable(
                        order['name'],
                        order['price'],
                        quantity: 1,
                      );
                    },
                  ),
                ],
              ),
              Text(
                '${(order['price'] * order['quantity']).toStringAsFixed(2)}.-',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // แสดงผลยอดรวม
  // ------------------------------------------------------------
  Widget _totalRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: bold ? 12 : 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? Colors.black : Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 12 : 14,
              fontWeight: bold ? FontWeight.normal : FontWeight.normal,
              color: bold ? Colors.black : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ปุ่ม Move / Scan ด้านบน
  // ------------------------------------------------------------
  Widget _styledButton({
    required BuildContext context,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: const Size(52, 21),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Container(
        width: 52,
        height: 21,
        decoration: ShapeDecoration(
          color: const Color(0xFFFF6E6E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 1,
              offset: Offset(1, 1),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // ฟอร์แมตวันที่
  // ------------------------------------------------------------
  String _formatDate(DateTime dateTime) {
    return '${dateTime.day} ${_monthName(dateTime.month)} ${dateTime.year}';
  }

  String _monthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
