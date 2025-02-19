import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fucntion/tableprovider.dart'; // Import TableProvider
import '../appbar.dart';
// นำเข้า PointOfSalePopup จากหน้าที่ทำไว้แล้ว
import '../appbar/popup_pointofsale.dart';

class MoveMenuPage extends StatefulWidget {
  const MoveMenuPage({Key? key}) : super(key: key);

  @override
  State<MoveMenuPage> createState() => _MoveMenuPageState();
}

class _MoveMenuPageState extends State<MoveMenuPage> {
  String? selectedZone; // โซนเป้าหมาย
  int? selectedTableIndex; // โต๊ะเป้าหมายที่เลือก
  int guestsToMove = 0; // จำนวนคนที่จะย้าย

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);
    final currentTable = tableProvider.getSelectedTable();

    return Scaffold(
      appBar: appbaraot(),
      body: currentTable == null
          ? const Center(
              child: Text("Please select a table first."),
            )
          : Row(
              children: [
                // ซ้าย: โต๊ะปัจจุบัน
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: const Color(0xFFF5F5F5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Table',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Guests: ${currentTable.people ?? 0}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            itemCount: currentTable.orders.length,
                            itemBuilder: (context, index) {
                              final order = currentTable.orders[index];
                              return Card(
                                elevation: 2,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(order['name']),
                                      subtitle: Text(
                                        '฿${order['price']} x${order['quantity']}',
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // กดลบออเดอร์: ให้เรียกใช้ PointOfSalePopup จากหน้าที่ทำไว้แล้ว
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle),
                                            color: Colors.red,
                                            onPressed: () async {
                                              bool auth = await showDialog<bool>(
                                                context: context,
                                                builder: (context) =>
                                                    const PointOfSalePopup(),
                                              ) ?? false;
                                              if (!auth) return;
                                              // ลบออเดอร์ทีละชิ้นหรือทั้งหมดตามจำนวน
                                              if (order['quantity'] > 1) {
                                                tableProvider.removeMenuItemFromTable(
                                                  order['name'],
                                                  order['price'],
                                                  quantity: 1,
                                                );
                                              } else {
                                                tableProvider.removeMenuItemFromTable(
                                                  order['name'],
                                                  order['price'],
                                                  quantity: order['quantity'],
                                                );
                                              }
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle),
                                            color: Colors.green,
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
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () =>
                                              _moveSingleItem(index, tableProvider),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blueAccent,
                                          ),
                                          child: const Text('>'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              _moveAllFromMenu(index, tableProvider),
                                          style: TextButton.styleFrom(
                                            foregroundColor: Colors.blueAccent,
                                          ),
                                          child: const Text('>>'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const VerticalDivider(width: 1),

                // ขวา: โต๊ะเป้าหมาย
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Target Table',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildTableSelector(tableProvider),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              "Guests to move:",
                              style: TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (guestsToMove > 0) guestsToMove--;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle),
                                  color: Colors.red,
                                ),
                                Text(
                                  '$guestsToMove',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if ((currentTable.people ?? 0) > guestsToMove)
                                        guestsToMove++;
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle),
                                  color: Colors.green,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // แถวปุ่มด้านล่าง (4 ปุ่ม) โดยแต่ละปุ่มมีขนาดเท่ากัน
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // ปุ่ม Split (สีเขียว)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Split function not implemented')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                  child: const Text('Split'),
                                ),
                              ),
                            ),
                            // ปุ่ม Order (สีเหลือง)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Order function not implemented')),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: const Text('Order'),
                                ),
                              ),
                            ),
                            // ปุ่ม Finish (สีฟ้า)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (selectedZone != null &&
                                        selectedTableIndex != null) {
                                      _finishMove(tableProvider);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Please select a target table'),
                                      ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  child: const Text('Finish'),
                                ),
                              ),
                            ),
                            // ปุ่ม Move All (สีแดง)
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (selectedZone != null &&
                                        selectedTableIndex != null) {
                                      _moveAll(tableProvider);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text('Please select a target table'),
                                      ));
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                  child: const Text('Move All'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTableSelector(TableProvider tableProvider) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: tableProvider.zones.entries.map((entry) {
          final zoneName = entry.key;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    zoneName,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(entry.value.length, (index) {
                    final table = entry.value[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedZone = zoneName;
                          selectedTableIndex = index;
                          // เมื่อเลือกโต๊ะใหม่ รีเซ็ต guestsToMove
                          guestsToMove = 0;
                        });
                      },
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (selectedZone == zoneName &&
                                  selectedTableIndex == index)
                              ? Colors.blueAccent
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          'T${table.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _moveSingleItem(int index, TableProvider tableProvider) {
    final currentTable = tableProvider.getSelectedTable();
    if (currentTable == null) return;

    final order = currentTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    final quantity = 1;

    if (selectedZone == null || selectedTableIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a target table')),
      );
      return;
    }

    // ย้ายออเดอร์ทีละชิ้น
    tableProvider.moveSingleOrder(
      fromZone: tableProvider.currentZone!,
      fromTableIndex: tableProvider.currentTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: selectedZone!,
      toTableIndex: selectedTableIndex!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Moved one item successfully')),
    );
  }

  void _moveAllFromMenu(int index, TableProvider tableProvider) {
    final currentTable = tableProvider.getSelectedTable();
    if (currentTable == null) return;

    final order = currentTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    final quantity = order['quantity'];

    if (selectedZone == null || selectedTableIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a target table')),
      );
      return;
    }

    // ย้ายออเดอร์ทั้งหมดของรายการนั้น
    tableProvider.moveSingleOrder(
      fromZone: tableProvider.currentZone!,
      fromTableIndex: tableProvider.currentTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: selectedZone!,
      toTableIndex: selectedTableIndex!,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Moved all items successfully')),
    );
  }

  void _moveAll(TableProvider tableProvider) {
    final currentTable = tableProvider.getSelectedTable();
    if (currentTable == null || selectedZone == null || selectedTableIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid target table')),
      );
      return;
    }

    // กำหนดจำนวนคนที่จะย้าย: ถ้ามีค่า guestsToMove > 0 ให้ใช้ค่านั้น หากไม่มีก็ให้ย้ายทั้งหมดของโต๊ะต้นทาง
    final int movedGuests = guestsToMove > 0 ? guestsToMove : (currentTable.people ?? 0);
    if (movedGuests <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No guests to move')),
      );
      return;
    }

    // ย้ายจำนวนแขก: ฟังก์ชันนี้จะลดจำนวนฝั่งซ้ายและเพิ่มจำนวนฝั่งขวาตามที่ได้กำหนดไว้
    tableProvider.moveGuestsToTable(selectedZone!, selectedTableIndex!, movedGuests);

    // ย้ายออเดอร์ทั้งหมดไปยังโต๊ะเป้าหมาย
    tableProvider.moveOrdersToTable(selectedZone!, selectedTableIndex!);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Moved all guests and orders to the target table.')),
    );
  }

  void _finishMove(TableProvider tableProvider) {
    if (guestsToMove > 0 && selectedZone != null && selectedTableIndex != null) {
      tableProvider.moveGuestsToTable(
          selectedZone!, selectedTableIndex!, guestsToMove);
    }

    Navigator.pop(context); // กลับไปหน้า Table Selection
  }
}
