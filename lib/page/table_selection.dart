import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fucntion/tableprovider.dart'; // แก้ไขเส้นทางให้ถูกต้อง

import '../widget/appbar.dart';
import 'package:numberpicker/numberpicker.dart';
import '../widget/Management.dart'; // <-- หน้า TableManagementPage

class TableSelectionPage extends StatefulWidget {
  const TableSelectionPage({Key? key}) : super(key: key);

  @override
  State<TableSelectionPage> createState() => _TableSelectionPageState();
}

class _TableSelectionPageState extends State<TableSelectionPage> {
  @override
  void initState() {
    super.initState();

    // โหลดข้อมูลโซนโต๊ะและสถานะ จากนั้นโหลดออร์เดอร์สำหรับแต่ละโต๊ะ
    Provider.of<TableProvider>(context, listen: false)
        .loadTableZones()
        .then((_) {
      // หลังจากโหลดโซนโต๊ะแล้ว ให้โหลดออร์เดอร์ของแต่ละโต๊ะ
      final tableProvider = Provider.of<TableProvider>(context, listen: false);
      List<Future> orderFutures = [];
      tableProvider.zones.forEach((zoneName, tables) {
        for (int index = 0; index < tables.length; index++) {
          orderFutures.add(
            tableProvider.fetchTableOrdersForTable(zoneName, index),
          );
        }
      });
      return Future.wait(orderFutures);
    }).then((_) {
      setState(() {}); // รีเฟรช UI หลังจากโหลดข้อมูลทั้งหมด
      debugPrint('Zones, statuses, and table orders loaded successfully.');
    }).catchError((error) {
      debugPrint('Error loading zones and orders: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final double itemSize = (MediaQuery.of(context).size.width - 82 - 32) / 12;
    final tableProvider = Provider.of<TableProvider>(context);

    return Scaffold(
      appBar: const appbaraot(),
      backgroundColor: Colors.white,
      body: tableProvider.zones.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 16),
                    // สร้างโซนตามที่โหลดมา โดยแต่ละโซนมีระยะห่างกัน 16
                    ...tableProvider.zones.keys.map((zoneName) {
                      final tableCount =
                          tableProvider.zones[zoneName]?.length ?? 0;
                      // คำนวณความสูงของ Container ตามจำนวนโต๊ะในโซน
                      final double containerHeight =
                          ((tableCount / 10).ceil() * 80) + 80;
                      return Column(
                        children: [
                          _buildZoneSection(
                            context,
                            zoneName,
                            itemSize,
                            containerHeight,
                          ),
                          const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildZoneSection(
    BuildContext context,
    String zoneName,
    double itemSize,
    double containerHeight,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      height: containerHeight,
      decoration: BoxDecoration(
        color: const Color(0xFFFFDBDB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header สำหรับ Zone
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  zoneName,
                  style: const TextStyle(
                    color: Color(0xFF505050),
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
          // ส่วนภายในของ Zone
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: _buildZone(context, zoneName, itemSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZone(
    BuildContext context,
    String zoneName,
    double itemSize,
  ) {
    final tableProvider = Provider.of<TableProvider>(context);

    debugPrint('Building Zone: $zoneName');
    debugPrint(
      'Total Tables in $zoneName: ${tableProvider.zones[zoneName]!.length}',
    );

    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 20,
      runSpacing: 10,
      children: List.generate(
        tableProvider.zones[zoneName]!.length,
        (index) {
          final table = tableProvider.zones[zoneName]![index];

          debugPrint(
            'Zone: $zoneName, Table ID: ${table.id}, State: ${table.state}',
          );

          return GestureDetector(
            onTap: () async {
              // แจ้ง Provider ว่าเลือกโต๊ะไหน
              tableProvider.selectTable(zoneName, index);

              if (table.state == 1) {
                // ถ้า state == 1 => เปิดหน้า TableManagementPage
                final result = await Navigator.push<Map<String, dynamic>>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TableManagementPage(),
                  ),
                );

                if (result != null) {
                  if (result['state'] == 1) {
                    tableProvider.updateTableState(zoneName, index, 1);
                  } else if (result['state'] == 2) {
                    tableProvider.updateTableState(zoneName, index, 2);
                  } else if (result['orders'] is List<Map<String, dynamic>>) {
                    tableProvider.setTableData(
                      zoneName,
                      index,
                      table.people ?? 0,
                      result['orders'] as List<Map<String, dynamic>>,
                    );
                  }
                }
              } else if (table.state == 0) {
                // ถ้าโต๊ะว่าง ให้เลือกจำนวนคน
                final guestCount = await _showGuestCountDialog(context);
                if (guestCount != null) {
                  tableProvider.setTableData(
                    zoneName,
                    index,
                    guestCount,
                    table.orders,
                  );
                  tableProvider.updateTableState(zoneName, index, 1);
                }
              } else if (table.state == 2) {
                // ถ้าโต๊ะอยู่ในสถานะ Ready to Pay เปลี่ยนกลับเป็นว่าง (ตาม Logic ที่ต้องการ)
                tableProvider.updateTableState(zoneName, index, 0);
              }
            },
            onLongPress: () {
              tableProvider.markTableAsReadyToPay(zoneName, index);
            },
            child: Container(
              width: 70,
              height: 70,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _getColorByState(table.state),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                '${table.name}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: table.state == 2
                      ? const Color.fromARGB(255, 14, 14, 14)
                      : const Color.fromARGB(255, 14, 14, 14),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // กำหนดสีตาม state ของโต๊ะ
  Color _getColorByState(int state) {
    switch (state) {
      case 1:
        return const Color(0xFFFFD058); // เหลือง: มีคน
      case 2:
        return const Color(0xFF86E8EF); // ฟ้า: Ready to pay
      default:
        return const Color(0xFFFFFFFF); // ขาว: ว่าง
    }
  }

  // Dialog ให้ผู้ใช้เลือกจำนวนคน
  Future<int?> _showGuestCountDialog(BuildContext context) async {
    int selectedGuestCount = 1;

    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Number of Customers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  NumberPicker(
                    value: selectedGuestCount,
                    minValue: 1,
                    maxValue: 99,
                    axis: Axis.horizontal,
                    onChanged: (value) {
                      setState(() {
                        selectedGuestCount = value;
                      });
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(selectedGuestCount),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
