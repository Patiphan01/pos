// lib/page/table_management.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // สำหรับส่ง HTTP request
import '../fucntion/tableprovider.dart'; // Adjust path if necessary
import '../page/addmenu.dart';
import '../widget/appbar.dart';
import '../widget/movedialog.dart'; // Ensure correct path
import '../fucntion/staffprovider.dart';

class TableManagementPage extends StatefulWidget {
  const TableManagementPage({Key? key}) : super(key: key);

  @override
  State<TableManagementPage> createState() => _TableManagementPageState();
}

class _TableManagementPageState extends State<TableManagementPage> {
  bool _isLoading = true;
  String? _errorMessage;

  /// ถ้า _isSplitMode = true => สามารถ add/remove menu ได้ทีละชิ้น (เช่นการ Split bill)
  bool _isSplitMode = true;
  bool _showConfirmButton = true; // ควบคุมการแสดงปุ่ม Confirm Move

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // โหลดข้อมูลโต๊ะซ้าย (current) จาก API (ถ้ามี) และไม่โหลดโต๊ะขวา
  Future<void> _initialize() async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    await tableProvider.loadTableZones();
    // เรียก _loadInitialData หลังจาก build เสร็จแล้ว
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // โหลดเมนูเฉพาะโต๊ะซ้าย
  Future<void> _loadInitialData() async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    if (tableProvider.currentZone != null &&
        tableProvider.currentTableIndex != null) {
      try {
        await tableProvider.fetchTableOrdersForTable(
          tableProvider.currentZone!,
          tableProvider.currentTableIndex!,
        );
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _errorMessage = 'Failed to load table data.';
            });
          });
        }
      } finally {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              _isLoading = false;
            });
          });
        }
      }
    } else {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _errorMessage = 'No table selected.';
            _isLoading = false;
          });
        });
      }
    }
  }

  // กดปุ่ม "Move" เพื่อเลือกโต๊ะปลายทาง (ครั้งเดียว)
  Future<void> _pickTargetTable() async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const MoveTableDialog(),
    );
    if (result == null) return;

    final targetZone = result['targetZone'] as String;
    final targetTableIndex = result['targetTableIndex'] as int;
    final guestsToMove = result['guestsToMove'] as int;

    // กำหนดโต๊ะปลายทางใน provider
    tableProvider.selectTargetTable(targetZone, targetTableIndex);

    // ย้ายแขกไปโต๊ะปลายทาง (Offline) ถ้าผู้ใช้เลือก move
    if (guestsToMove > 0) {
      tableProvider.moveGuestsToTable(
        targetZone,
        targetTableIndex,
        guestsToMove,
      );
    }

    // ไม่จำเป็นต้องเรียก setState() เพราะ provider จะ notifyListeners เอง
  }

  // ย้าย "ทุกเมนู" จากโต๊ะซ้าย -> โต๊ะขวา (Offline)
  Future<void> _moveAllOrdersLeftToRight() async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final currentTable = tableProvider.getSelectedTable();
    final targetTable = tableProvider.targetTable;

    if (currentTable == null || targetTable == null) return;

    tableProvider.moveOrdersToTable(
      tableProvider.targetZone!,
      tableProvider.targetTableIndex!,
    );
    // ไม่ต้อง setState เพราะ provider แจ้งให้ rebuild อยู่แล้ว
  }

  // ย้ายเมนูทีละ 1 จากซ้าย -> ขวา (Offline)
  Future<void> _moveSingleOrderLeftToRight(int index) async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final currentTable = tableProvider.getSelectedTable();
    final targetTable = tableProvider.targetTable;

    if (currentTable == null || targetTable == null) return;

    final order = currentTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    const quantity = 1;

    tableProvider.moveSingleOrder(
      fromZone: tableProvider.currentZone!,
      fromTableIndex: tableProvider.currentTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: tableProvider.targetZone!,
      toTableIndex: tableProvider.targetTableIndex!,
    );

    // ไม่ต้อง setState
  }

  // ย้ายเมนู "ทั้งหมด" (ใน item นั้น) จากซ้าย -> ขวา (Offline)
  Future<void> _moveAllOrderLeftToRight(int index) async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final currentTable = tableProvider.getSelectedTable();
    final targetTable = tableProvider.targetTable;

    if (currentTable == null || targetTable == null) return;

    final order = currentTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    final quantity = order['quantity'];

    tableProvider.moveSingleOrder(
      fromZone: tableProvider.currentZone!,
      fromTableIndex: tableProvider.currentTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: tableProvider.targetZone!,
      toTableIndex: tableProvider.targetTableIndex!,
    );

    // ไม่ต้อง setState
  }

  // ย้ายเมนูทีละ 1 จากขวา -> ซ้าย (Offline)
  Future<void> _moveSingleOrderRightToLeft(int index) async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final targetTable = tableProvider.targetTable;
    final currentTable = tableProvider.getSelectedTable();

    if (targetTable == null || currentTable == null) return;

    final order = targetTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    const quantity = 1;

    tableProvider.moveSingleOrder(
      fromZone: tableProvider.targetZone!,
      fromTableIndex: tableProvider.targetTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: tableProvider.currentZone!,
      toTableIndex: tableProvider.currentTableIndex!,
    );

    // ไม่ต้อง setState
  }

  // ย้ายเมนู "ทั้งหมด" (ใน item นั้น) จากขวา -> ซ้าย (Offline)
  Future<void> _moveAllOrderRightToLeft(int index) async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final targetTable = tableProvider.targetTable;
    final currentTable = tableProvider.getSelectedTable();

    if (targetTable == null || currentTable == null) return;

    final order = targetTable.orders[index];
    final orderName = order['name'];
    final price = order['price'];
    final quantity = order['quantity'];

    tableProvider.moveSingleOrder(
      fromZone: tableProvider.targetZone!,
      fromTableIndex: tableProvider.targetTableIndex!,
      orderName: orderName,
      price: price,
      quantity: quantity,
      toZone: tableProvider.currentZone!,
      toTableIndex: tableProvider.currentTableIndex!,
    );

    // ไม่ต้อง setState
  }

  // Confirm Move: ส่ง POST request ไปยัง API ด้วย payload ที่อิงจากข้อมูลของ staff และ target table
  Future<void> _confirmMove() async {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    setState(() {
      _showConfirmButton = false; // ซ่อนปุ่ม Confirm Move ทันที
    });

    final targetTable = tableProvider.targetTable;
    final currentTable = tableProvider.getSelectedTable();

    if (targetTable != null) {
      // ✅ แสดงข้อมูลใน Console ก่อนย้ายโต๊ะ
      debugPrint("🚀 Confirm Move Clicked!");
      debugPrint("🟢 Moving orders from Table: ${currentTable?.name ?? 'N/A'}");
      debugPrint(
          "➡️ Moving to Table: ${targetTable.name}, Zone: ${tableProvider.targetZone ?? 'N/A'}");

      // ✅ สร้างรายการ items จาก orders ของ target table
      final List<Map<String, dynamic>> items = targetTable.orders.map((order) {
        return {
          "id": order.containsKey('item_id') && order['item_id'] != null
              ? order['item_id']
              : 'unknown',
          "amount": order.containsKey('quantity') && order['quantity'] != null
              ? order['quantity']
              : 0,
        };
      }).toList();

      final payload = {
        "staff": {
          "id": staffProvider.id ?? "",
          "name": staffProvider.name ?? ""
        },
        "data": {
          "items": items,
          "table": {
            "name": targetTable.name,
            "split": 0,
            "zone": tableProvider.targetZone ?? ""
          }
        }
      };

      debugPrint("🚀 Payload to be sent: $payload");

      // ตรวจสอบว่ามีข้อมูลหรือไม่
      if (items.isNotEmpty) {
        await postMoveOrderItems(payload);

        // ✅ ล้างรายการเมนูในโต๊ะเดิมหลังจากย้ายสำเร็จ
        if (currentTable != null) {
          currentTable.orders.clear();
          currentTable.state = 0;
          // หาก confirmMove() มีการ notifyListeners อยู่แล้ว ไม่ต้องเรียก notifyListeners() ซ้ำ
          // tableProvider.notifyListeners();
        }
      } else {
        debugPrint("❌ Payload ไม่ถูกส่ง เนื่องจากไม่มี items ในคำสั่งซื้อ");
      }
    } else {
      debugPrint("❌ ไม่พบ targetTable");
    }

    tableProvider.confirmMove();
    _loadInitialData(); // รีโหลดข้อมูลใหม่
  }

  // ฟังก์ชันส่ง POST request ไปยัง API สำหรับการย้ายเมนู
  Future<void> postMoveOrderItems(Map<String, dynamic> payload) async {
    final url =
        'https://sounddev.triggersplus.com/order/move_order_items/31D8702BC5C23FAD8C355A7032D21A9E/';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      if (response.statusCode == 200) {
        debugPrint("POST successful: ${response.body}");
      } else {
        debugPrint("POST failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      debugPrint("Error during POST: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);
    final currentTable = tableProvider.getSelectedTable();
    final targetTable = tableProvider.targetTable;

    return Scaffold(
      appBar: const appbaraot(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_errorMessage != null)
              ? Center(child: Text(_errorMessage!))
              : Column(
                  children: [
                    // Header Action Bar
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 16,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Table Management",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  _pickTargetTable();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  minimumSize: const Size(90, 40),
                                ),
                                child: Text(
                                  (targetTable == null)
                                      ? 'Move'
                                      : 'Change Table',
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _isSplitMode = !_isSplitMode;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  minimumSize: const Size(90, 40),
                                ),
                                child: const Text('Split'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AddMenuPage()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(90, 40),
                                ),
                                child: const Text('Order'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  if (tableProvider.currentZone != null &&
                                      tableProvider.currentTableIndex != null) {
                                    tableProvider.markTableAsReadyToPay(
                                      tableProvider.currentZone!,
                                      tableProvider.currentTableIndex!,
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  minimumSize: const Size(90, 40),
                                ),
                                child: const Text('Finished'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: Colors.grey),
                    // Main Content: Left + Right
                    Expanded(
                      child: Row(
                        children: [
                          // Left Table
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: const Border(
                                  right: BorderSide(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Table name + guest
                                  Row(
                                    children: [
                                      Text(
                                        "Table ${currentTable?.name ?? 'N/A'}",
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (currentTable != null)
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: (targetTable == null)
                                                  ? null
                                                  : _moveAllOrdersLeftToRight,
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.lightBlue,
                                                  minimumSize:
                                                      const Size(60, 40)),
                                              child: const Text('All'),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text("Guest: ",
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              onPressed: () {
                                                int newCount =
                                                    (currentTable.people ?? 0) -
                                                        1;
                                                if (newCount < 0) newCount = 0;
                                                tableProvider.updateTablePeople(
                                                  tableProvider.currentZone!,
                                                  tableProvider
                                                      .currentTableIndex!,
                                                  newCount,
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red),
                                            ),
                                            Text("${currentTable.people ?? 0}",
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            IconButton(
                                              onPressed: () {
                                                int newCount =
                                                    (currentTable.people ?? 0) +
                                                        1;
                                                tableProvider.updateTablePeople(
                                                  tableProvider.currentZone!,
                                                  tableProvider
                                                      .currentTableIndex!,
                                                  newCount,
                                                );
                                              },
                                              icon: const Icon(Icons.add_circle,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const Divider(),
                                  // List Orders in Left Table
                                  Expanded(
                                    child:
                                        (currentTable != null &&
                                                currentTable.orders.isNotEmpty)
                                            ? ListView.builder(
                                                itemCount:
                                                    currentTable.orders.length,
                                                itemBuilder: (context, index) {
                                                  final order = currentTable
                                                      .orders[index];
                                                  return Card(
                                                    elevation: 2,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          leading: (order['image_url'] !=
                                                                      null &&
                                                                  order['image_url']
                                                                      .isNotEmpty)
                                                              ? Image.network(
                                                                  order[
                                                                      'image_url'],
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : const Icon(Icons
                                                                  .fastfood),
                                                          title: Text(order[
                                                                  'name'] ??
                                                              'ไม่ระบุชื่อ'),
                                                          subtitle: Text(
                                                              '฿${order['price']} x${order['quantity']}'),
                                                          trailing: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .remove_circle),
                                                                color:
                                                                    Colors.red,
                                                                onPressed:
                                                                    _isSplitMode
                                                                        ? () {
                                                                            tableProvider.removeMenuItemFromTable(
                                                                              order['name'],
                                                                              order['price'],
                                                                              quantity: 1,
                                                                            );
                                                                            // ไม่ต้อง setState
                                                                          }
                                                                        : null,
                                                              ),
                                                              Text(
                                                                "x${order['quantity']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .add_circle),
                                                                color: Colors
                                                                    .green,
                                                                onPressed:
                                                                    _isSplitMode
                                                                        ? () {
                                                                            tableProvider.addMenuItemToTable(
                                                                              order['name'],
                                                                              order['price'],
                                                                              quantity: 1,
                                                                            );
                                                                            // ไม่ต้อง setState
                                                                          }
                                                                        : null,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                "\u0e3f${order['price']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        if (targetTable != null)
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  _moveSingleOrderLeftToRight(
                                                                      index);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        '>'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  _moveAllOrderLeftToRight(
                                                                      index);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        '>>'),
                                                              ),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: Text("No Orders")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Right Table (Target)
                          Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: const Border(
                                    left: BorderSide(
                                        color: Colors.grey, width: 1)),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Table name + guest (Right)
                                  Row(
                                    children: [
                                      (targetTable != null)
                                          ? Text(
                                              "Table ${targetTable.name}",
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : const Text(
                                              "No Target Table Selected",
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey),
                                            ),
                                      const Spacer(),
                                      if (targetTable != null)
                                        Row(
                                          children: [
                                            const Text("Guest: ",
                                                style: TextStyle(fontSize: 18)),
                                            IconButton(
                                              onPressed: () {
                                                if (tableProvider.targetZone ==
                                                        null ||
                                                    tableProvider
                                                            .targetTableIndex ==
                                                        null) return;
                                                int newCount =
                                                    (targetTable.people ?? 0) -
                                                        1;
                                                if (newCount < 0) newCount = 0;
                                                tableProvider.updateTablePeople(
                                                  tableProvider.targetZone!,
                                                  tableProvider
                                                      .targetTableIndex!,
                                                  newCount,
                                                );
                                              },
                                              icon: const Icon(
                                                  Icons.remove_circle,
                                                  color: Colors.red),
                                            ),
                                            Text("${targetTable.people ?? 0}",
                                                style: const TextStyle(
                                                    fontSize: 18)),
                                            IconButton(
                                              onPressed: () {
                                                if (tableProvider.targetZone ==
                                                        null ||
                                                    tableProvider
                                                            .targetTableIndex ==
                                                        null) return;
                                                int newCount =
                                                    (targetTable.people ?? 0) +
                                                        1;
                                                tableProvider.updateTablePeople(
                                                  tableProvider.targetZone!,
                                                  tableProvider
                                                      .targetTableIndex!,
                                                  newCount,
                                                );
                                              },
                                              icon: const Icon(Icons.add_circle,
                                                  color: Colors.green),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  const Divider(),
                                  // List Orders in Right Table
                                  Expanded(
                                    child:
                                        (targetTable != null &&
                                                targetTable.orders.isNotEmpty)
                                            ? ListView.builder(
                                                itemCount:
                                                    targetTable.orders.length,
                                                itemBuilder: (context, index) {
                                                  final order =
                                                      targetTable.orders[index];
                                                  return Card(
                                                    elevation: 2,
                                                    child: Column(
                                                      children: [
                                                        ListTile(
                                                          leading: (order['image_url'] !=
                                                                      null &&
                                                                  order['image_url']
                                                                      .isNotEmpty)
                                                              ? Image.network(
                                                                  order[
                                                                      'image_url'],
                                                                  width: 50,
                                                                  height: 50,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : const Icon(Icons
                                                                  .fastfood),
                                                          title: Text(order[
                                                                  'name'] ??
                                                              'ไม่ระบุชื่อ'),
                                                          subtitle: Text(
                                                              '฿${order['price']} x${order['quantity']}'),
                                                          trailing: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .remove_circle),
                                                                color:
                                                                    Colors.red,
                                                                onPressed:
                                                                    _isSplitMode
                                                                        ? () {
                                                                            tableProvider.removeMenuItemFromTable(
                                                                              order['name'],
                                                                              order['price'],
                                                                              quantity: 1,
                                                                            );
                                                                            // ไม่ต้อง setState
                                                                          }
                                                                        : null,
                                                              ),
                                                              Text(
                                                                "x${order['quantity']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              IconButton(
                                                                icon: const Icon(
                                                                    Icons
                                                                        .add_circle),
                                                                color: Colors
                                                                    .green,
                                                                onPressed:
                                                                    _isSplitMode
                                                                        ? () {
                                                                            tableProvider.addMenuItemToTable(
                                                                              order['name'],
                                                                              order['price'],
                                                                              quantity: 1,
                                                                            );
                                                                            // ไม่ต้อง setState
                                                                          }
                                                                        : null,
                                                              ),
                                                              const SizedBox(
                                                                  width: 8),
                                                              Text(
                                                                "\u0e3f${order['price']}",
                                                                style: const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                _moveSingleOrderRightToLeft(
                                                                    index);
                                                              },
                                                              child: const Text(
                                                                  '<'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                _moveAllOrderRightToLeft(
                                                                    index);
                                                              },
                                                              child: const Text(
                                                                  '<<'),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              )
                                            : const Center(
                                                child: Text("No Orders")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Confirm Move Button (ซ่อนเมื่อกดแล้ว)
                    if (targetTable != null && _showConfirmButton)
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: _confirmMove,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(150, 50),
                              ),
                              child: const Text(
                                'Confirm Move',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
    );
  }
}
