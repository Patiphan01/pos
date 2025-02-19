// lib/function/tableprovider.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';
import 'package:flutter/scheduler.dart';
import 'subprovider/option_question.dart';
import 'subprovider/category.dart';
import 'subprovider/menu_item.dart';
import 'subprovider/table_data.dart';

class TableProvider extends ChangeNotifier {
  // Override notifyListeners() เพื่อเลื่อนการแจ้งเตือนถ้าอยู่ในช่วง build
  @override
  void notifyListeners() {
    if (WidgetsBinding.instance.schedulerPhase == SchedulerPhase.idle) {
      super.notifyListeners();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        super.notifyListeners();
      });
    }
  }

  static String? language;
  final Map<String, List<TableData>> _zones = {};
  final Map<String, int> _zoneNameToId = {};

  // ------------------------------------------------------------------------
  // เก็บโซนและโต๊ะปัจจุบัน (ที่กำลังทำงานอยู่)
  // ------------------------------------------------------------------------
  String? currentZone;
  int? currentTableIndex;

  // ------------------------------------------------------------------------
  // ข้อมูล Category / MenuItem / Subcategory
  // ------------------------------------------------------------------------
  List<Category> _categories = [];
  Map<String, List<MenuItem>> _menuItemsByCategory = {};
  Map<String, List<String>> _subcategoriesByCategory = {};
  String? _selectedSubcategory;
  String? _selectedCategory;
  List<MenuItem> _menuItems = [];
  Map<String, List<MenuItem>> _menuItemsBySubcategory = {};

  // ------------------------------------------------------------------------
  // ตัวแปร/ฟังก์ชันเกี่ยวกับ Option (group option list)
  // ------------------------------------------------------------------------
  Map<String, List<OptionQuestion>> groupOptionList = {};

  // ------------------------------------------------------------------------
  // Getter
  // ------------------------------------------------------------------------
  List<TableData> get tables => _zones.values.expand((t) => t).toList();
  Map<String, List<TableData>> get zones => _zones;
  int? getZoneId(String zoneName) => _zoneNameToId[zoneName];

  String? getZoneName(int zoneId) {
    final entry = _zoneNameToId.entries.firstWhere(
      (entry) => entry.value == zoneId,
      orElse: () => const MapEntry('', 0),
    );
    return entry.key.isEmpty ? null : entry.key;
  }

  List<Category> get categories => _categories;
  List<String> get subcategories =>
      _subcategoriesByCategory[_selectedCategory] ?? [];
  String? get selectedSubcategory => _selectedSubcategory;
  List<MenuItem> get menuItemsBySelectedSubcategory =>
      _menuItemsBySubcategory[_selectedSubcategory] ?? [];
  List<MenuItem> get menuItemsBySelectedCategory =>
      _menuItemsByCategory[_selectedCategory] ?? [];
  List<MenuItem> get menuItems => _menuItems;
  String? get selectedCategory => _selectedCategory;

  // สำหรับการย้ายโต๊ะ
  String? get targetZone => _targetZone;
  int? get targetTableIndex => _targetTableIndex;
  String? _targetZone;
  int? _targetTableIndex;

  // ------------------------------------------------------------------------
  // กำหนดภาษา -> โหลดเมนู/ option list ใหม่ตามภาษา
  // ------------------------------------------------------------------------
  void setLanguage(String selectedLanguage) {
    language = selectedLanguage;
    loadCategoriesAndMenuItems(id: '801AA5A07EFC4F57A7F35C4AA9199584');
    loadGroupOptionList();
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // โหลด GroupOptionList (Option Question/Choice)
  // ------------------------------------------------------------------------
  Future<void> loadGroupOptionList() async {
    try {
      final String apiUrl =
          'https://sounddev.triggersplus.com/dining/get_menu/801AA5A07EFC4F57A7F35C4AA9199584/1/';
      final response = await http.get(Uri.parse(apiUrl));
      debugPrint('Loading group option list from $apiUrl');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Group Option List Response: $data');
        final groupData = data['group_option_list'];
        groupOptionList.clear();
        if (groupData is Map) {
          groupData.forEach((key, value) {
            if (value is List) {
              groupOptionList[key.toString()] =
                  value.map((item) => OptionQuestion.fromJson(item)).toList();
            }
          });
        }
        notifyListeners();
      } else {
        debugPrint(
            'Failed to load group option list. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading group option list: $e');
    }
  }

  // ดึง OptionQuestion ตาม ID (หรือ Key) ของ group option
  List<OptionQuestion>? getOptionQuestionsById(dynamic id) {
    if (id == null || id.toString().isEmpty) return null;
    return groupOptionList[id.toString()];
  }

  // ------------------------------------------------------------------------
  // โหลด Categories / MenuItems จาก API
  // ------------------------------------------------------------------------
  Future<void> loadCategoriesAndMenuItems({required String id}) async {
    final String apiUrl =
        'https://sounddev.triggersplus.com/dining/get_menu/$id/1/';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      debugPrint('Loading categories and menu items from $apiUrl');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Categories and Menu Items Response: $data');
        if (data['data'] != null &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          _categories.clear();
          _menuItemsByCategory.clear();
          _subcategoriesByCategory.clear();
          _menuItemsBySubcategory.clear();

          // ฟังก์ชันภายใน: ตัดสินใจเลือกชื่อ Subcategory ตามภาษาที่เลือก
          String determineSubcategoryName(Map<String, dynamic> json) {
            switch (TableProvider.language) {
              case 'CN':
                return json['name_cn'] ??
                    json['name'] ??
                    'Uncategorized Subcategory';
              case 'TH':
                return json['name_th'] ??
                    json['name'] ??
                    'Uncategorized Subcategory';
              case 'JA':
                return json['name_ja'] ??
                    json['name'] ??
                    'Uncategorized Subcategory';
              default:
                return json['name'] ?? 'Uncategorized Subcategory';
            }
          }

          // วนเพื่อโหลด categories / subcategories / menu items
          for (var categoryJson in data['data']) {
            final category = Category.fromJson(categoryJson);
            _categories.add(category);

            List<MenuItem> menuItems = [];
            List<String> subcategories = [];

            if (categoryJson['items'] != null) {
              for (var subCategory in categoryJson['items']) {
                final subcategoryName = determineSubcategoryName(subCategory);
                subcategories.add(subcategoryName);

                if (subCategory['items'] != null) {
                  final groupMenuItems = (subCategory['items'] as List)
                      .map((item) => MenuItem.fromJson(item))
                      .toList();
                  menuItems.addAll(groupMenuItems);
                  _menuItemsBySubcategory[subcategoryName] = groupMenuItems;
                }
              }
            }
            // เก็บ subcategories ของ category นี้
            _subcategoriesByCategory[category.name] = subcategories;
            _menuItemsByCategory[category.name] = menuItems;
          }

          // ตั้งค่า category/subcategory เริ่มต้น
          if (_categories.isNotEmpty) {
            _selectedCategory = _categories[0].name;
            _selectedSubcategory =
                (_subcategoriesByCategory[_selectedCategory]?.isNotEmpty ??
                        false)
                    ? _subcategoriesByCategory[_selectedCategory]![0]
                    : null;
            _menuItems = _menuItemsBySubcategory[_selectedSubcategory] ?? [];
          }
          notifyListeners();
        } else {
          debugPrint('No data found in API response');
        }
      } else {
        debugPrint(
            'Failed to load data from API. Status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading categories and menu items from API: $e');
    }
  }

  // ------------------------------------------------------------------------
  // เลือก Category / Subcategory
  // ------------------------------------------------------------------------
  void selectCategory(String categoryName) {
    if (_categories.any((category) => category.name == categoryName)) {
      _selectedCategory = categoryName;
      _selectedSubcategory =
          (_subcategoriesByCategory[_selectedCategory]?.isNotEmpty ?? false)
              ? _subcategoriesByCategory[_selectedCategory]![0]
              : null;
      _menuItems = _menuItemsBySubcategory[_selectedSubcategory] ?? [];
      notifyListeners();
    }
  }

  void selectSubcategory(String subcategory) {
    if (_subcategoriesByCategory[_selectedCategory]?.contains(subcategory) ??
        false) {
      _selectedSubcategory = subcategory;
      _menuItems = _menuItemsBySubcategory[_selectedSubcategory] ?? [];
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------------
  // โหลดข้อมูลโซน / โต๊ะ จาก API
  // ------------------------------------------------------------------------
  Future<void> loadTableZones() async {
    try {
      // --------------------------------------------------
      // เรียก get_restaurant_mode เพื่อดึง zone/table ทั้งหมด
      // --------------------------------------------------
      final String restaurantModeUrl =
          'https://sounddev.triggersplus.com/dining/get_restaurant_mode/F236C2691F953686A95A8ACB7EEF782D/';
      debugPrint('Loading restaurant mode from $restaurantModeUrl');
      final responseRestaurantMode =
          await http.get(Uri.parse(restaurantModeUrl));
      debugPrint(
          'Restaurant Mode Response Status: ${responseRestaurantMode.statusCode}');
      if (responseRestaurantMode.statusCode == 200) {
        final restaurantData = json.decode(responseRestaurantMode.body);
        debugPrint('Restaurant Mode Response: $restaurantData');
        if (restaurantData is List) {
          for (var zone in restaurantData) {
            final String zoneName = zone['zone'] ?? 'Default';
            final int zoneId = int.tryParse(zone['id']?.toString() ?? '0') ?? 0;
            final List<dynamic> items = zone['items'] ?? [];

            List<TableData> zoneTables = [];
            for (var item in items) {
              final int tableId =
                  int.tryParse(item['id']?.toString() ?? '') ?? 0;
              final String tableName = item['name'] ?? '';
              zoneTables.add(TableData(
                id: tableId,
                name: tableName,
                state: 0,
                orders: [],
                people: null,
              ));
              debugPrint(
                  'Added table: Zone=$zoneName, TableName=$tableName, TableID=$tableId');
            }

            _zones[zoneName] = zoneTables;
            _zoneNameToId[zoneName] = zoneId;
          }
          debugPrint(
              'Loaded restaurant zones and tables from get_restaurant_mode');
        }
      } else {
        debugPrint(
            'Failed to load restaurant mode. Status code: ${responseRestaurantMode.statusCode}');
        return;
      }

      // --------------------------------------------------
      // เรียก open_table_list เพื่ออัปเดตสถานะโต๊ะ/ orderId
      // --------------------------------------------------
      final String openTableUrl =
          'https://sounddev.triggersplus.com/order/open_table_list/F236C2691F953686A95A8ACB7EEF782D/123/?output=json';
      debugPrint('Loading open table list from $openTableUrl');
      final responseOpenTable = await http.get(Uri.parse(openTableUrl));
      debugPrint(
          'Open Table List Response Status: ${responseOpenTable.statusCode}');
      if (responseOpenTable.statusCode == 200) {
        final openTableData = json.decode(responseOpenTable.body);
        debugPrint('Open Table List Response: $openTableData');
        final List<dynamic> datas = openTableData['datas'] ?? [];
        for (var tableJson in datas) {
          final String zoneName = tableJson['table_zone'] ?? 'Default';
          final String tableName = tableJson['table_name']?.toString() ?? '';
          final List<dynamic> statusList = tableJson['status'] ?? [];
          final String? billingId = tableJson['billing_id'];
          final String? id = tableJson['id']; // Get 'id' field if available

          // เลือก orderId ใช้ billing_id เป็นหลัก ถ้าไม่มีก็ใช้ id
          String? orderId;
          if (billingId != null && billingId.startsWith('#')) {
            orderId = billingId.substring(1);
          } else if (id != null && id.isNotEmpty) {
            orderId = id;
          }

          debugPrint(
              'Processing table: Zone=$zoneName, TableName=$tableName, OrderID=$orderId');

          if (_zones.containsKey(zoneName)) {
            final List<TableData> tablesInZone = _zones[zoneName]!;
            final TableData? table =
                tablesInZone.firstWhereOrNull((t) => t.name == tableName);
            if (table != null) {
              table.state = statusList.contains('PAY')
                  ? 2
                  : statusList.contains('ORD')
                      ? 1
                      : 0;
              if (orderId != null && orderId.isNotEmpty) {
                table.orderId = orderId;
                debugPrint('Set orderId for table ${table.name}: $orderId');
              } else {
                debugPrint('No orderId found for table: ${table.name}');
              }
              table.people = tableJson['guest_amount'] ?? table.people;
              debugPrint(
                  'Set guest amount for table ${table.name}: ${table.people}');
            } else {
              debugPrint(
                  'Table not found: Zone=$zoneName, TableName=$tableName');
            }
          } else {
            debugPrint('Zone not found: $zoneName');
          }

          // Final debug print to confirm orderId and tableName
          if (_zones.containsKey(zoneName)) {
            final List<TableData> tablesInZone = _zones[zoneName]!;
            final TableData? table =
                tablesInZone.firstWhereOrNull((t) => t.name == tableName);
            if (table != null) {
              debugPrint(
                  'Final orderId for Table $tableName: ${table.orderId}');
            }
          }
        }
        debugPrint('Updated table statuses from open_table_list');
      } else {
        debugPrint(
            'Failed to load table statuses. Status code: ${responseOpenTable.statusCode}');
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading table zones and statuses: $e');
    }
  }

  // ------------------------------------------------------------------------
  // ดึง TableData ตาม zone, tableIndex
  // ------------------------------------------------------------------------
  TableData? getTableData(String zone, int tableIndex) {
    if (_zones.containsKey(zone) &&
        tableIndex >= 0 &&
        tableIndex < _zones[zone]!.length) {
      return _zones[zone]![tableIndex];
    }
    return null;
  }

  // ------------------------------------------------------------------------
  // เลือกโต๊ะปัจจุบัน
  // ------------------------------------------------------------------------
  void selectTable(String zone, int tableIndex) {
    if (_zones.containsKey(zone) &&
        tableIndex >= 0 &&
        tableIndex < _zones[zone]!.length) {
      currentZone = zone;
      currentTableIndex = tableIndex;
      debugPrint(
          'Selected table: Zone=$zone, Index=$tableIndex, TableName=${_zones[zone]![tableIndex].name}');
      notifyListeners();

      // เรียก fetchTableOrdersForTable เพื่อโหลดออร์เดอร์ (ถ้าต้องการดึงจาก API)
      // fetchTableOrdersForTable(zone, tableIndex);
    }
  }

  // ------------------------------------------------------------------------
  // ดึง TableData โต๊ะที่เลือกปัจจุบัน
  // ------------------------------------------------------------------------
  TableData? getSelectedTable() {
    if (currentZone != null &&
        currentTableIndex != null &&
        _zones.containsKey(currentZone!) &&
        currentTableIndex! >= 0 &&
        currentTableIndex! < _zones[currentZone!]!.length) {
      return _zones[currentZone!]![currentTableIndex!];
    }
    return null;
  }

  // ------------------------------------------------------------------------
  // เลือก Target Table (สำหรับ move menu)
  // ------------------------------------------------------------------------
  void selectTargetTable(String zone, int tableIndex) {
    if (_zones.containsKey(zone) &&
        tableIndex >= 0 &&
        tableIndex < _zones[zone]!.length) {
      _targetZone = zone;
      _targetTableIndex = tableIndex;
      debugPrint(
          'Selected target table: Zone=$zone, Index=$tableIndex, TableName=${_zones[zone]![tableIndex].name}');
      notifyListeners();

      // ถ้าต้องการโหลดออร์เดอร์ของ target ก็ทำได้
      fetchTableOrdersForTable(zone, tableIndex);
    }
  }

  TableData? get targetTable {
    if (_targetZone != null &&
        _targetTableIndex != null &&
        _zones.containsKey(_targetZone!)) {
      if (_targetTableIndex! >= 0 &&
          _targetTableIndex! < _zones[_targetZone!]!.length) {
        return _zones[_targetZone!]![_targetTableIndex!];
      }
    }
    return null;
  }

  // ------------------------------------------------------------------------
  // ยืนยันการย้าย
  // ------------------------------------------------------------------------
  void confirmMove() {
    debugPrint('Confirmed move of orders.');
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // เพิ่มออร์เดอร์ในโต๊ะที่เลือก (ไม่มีการส่ง zone/tableIndex ตรง ๆ)
  // เพราะจะดึงจาก currentZone, currentTableIndex
  // ------------------------------------------------------------------------
  void addMenuItemToTable(
    String name,
    double price, {
    int quantity = 1,
    String? imageUrl,
    Map<String, dynamic>? options,
  }) {
    final table = getSelectedTable();
    if (table == null) {
      debugPrint('No table selected. Cannot add menu item.');
      return;
    }
    final existingIndex =
        table.orders.indexWhere((order) => order['name'] == name);
    if (existingIndex != -1) {
      table.orders[existingIndex]['quantity'] += quantity;
      if (options != null) {
        table.orders[existingIndex]['options'] = options;
      }
      if (table.state == 2) {
        table.orders[existingIndex]['new'] = true;
      }
      debugPrint(
          'Increased quantity of $name in table ${table.name} to ${table.orders[existingIndex]['quantity']}');
    } else {
      table.orders.add({
        'name': name,
        'price': price,
        'quantity': quantity,
        'image_url': imageUrl ?? '',
        'new': (table.state == 2),
        if (options != null) 'options': options,
      });
      debugPrint(
          'Added new menu item to table ${table.name}: $name, Quantity: $quantity');
    }
    table.state = table.orders.isEmpty ? 0 : 1;
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // ลบออร์เดอร์ (ไม่มีการส่ง zone/tableIndex ตรง ๆ)
  // ------------------------------------------------------------------------
  void removeMenuItemFromTable(String name, double price, {int quantity = 1}) {
    final table = getSelectedTable();
    if (table == null) {
      debugPrint('No table selected. Cannot remove menu item.');
      return;
    }
    final index = table.orders.indexWhere((order) => order['name'] == name);
    if (index != -1) {
      if (table.orders[index]['quantity'] > quantity) {
        table.orders[index]['quantity'] -= quantity;
        debugPrint(
            'Decreased quantity of $name by $quantity in table ${table.name}. New quantity: ${table.orders[index]['quantity']}');
      } else {
        table.orders.removeAt(index);
        debugPrint('Removed menu item $name from table ${table.name}');
      }
      table.state = table.orders.isEmpty ? 0 : 1;
      notifyListeners();
    } else {
      debugPrint('Order not found: Name=$name');
    }
  }

  // ------------------------------------------------------------------------
  // ดึงเฉพาะ New Orders
  // ------------------------------------------------------------------------
  List<Map<String, dynamic>> getNewOrders(String zone, int tableIndex) {
    final table = getTableData(zone, tableIndex);
    return table == null
        ? []
        : table.orders.where((order) => order['new'] == true).toList();
  }

  // ------------------------------------------------------------------------
  // ตั้งค่า Orders ให้กับโต๊ะ (แบบ override ทั้งก้อน)
  // ------------------------------------------------------------------------
  void setTableData(
    String zone,
    int index,
    int people,
    List<Map<String, dynamic>> orders,
  ) {
    if (_zones.containsKey(zone) &&
        index >= 0 &&
        index < _zones[zone]!.length) {
      final table = _zones[zone]![index];
      table.people = people;
      table.orders = List.from(orders);
      table.state = table.orders.isEmpty ? 0 : 1;
      debugPrint(
          'Set table data for ${table.name}: People=$people, Orders=${table.orders.length}');
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------------
  // อัปเดตจำนวนคน
  // ------------------------------------------------------------------------
  void updateTablePeople(String zone, int index, int? people) {
    if (_zones.containsKey(zone) &&
        index >= 0 &&
        index < _zones[zone]!.length) {
      _zones[zone]![index].updatePeople(people);
      debugPrint(
          'Updated people count for table ${_zones[zone]![index].name} to $people');
      notifyListeners();
    }
  }

  // ------------------------------------------------------------------------
  // รีเซ็ตทุกโต๊ะ
  // ------------------------------------------------------------------------
  void resetAll() {
    currentZone = null;
    currentTableIndex = null;
    _targetZone = null;
    _targetTableIndex = null;
    for (var zone in _zones.values) {
      for (var table in zone) {
        table.reset();
      }
    }
    debugPrint('All tables have been reset.');
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // ย้ายแขกบางส่วน
  // ------------------------------------------------------------------------
  void moveGuestsToTable(
      String targetZone, int targetTableIndex, int movedGuests) {
    final sourceTable = getSelectedTable();
    if (sourceTable == null ||
        sourceTable.people == null ||
        sourceTable.people! < movedGuests) {
      return;
    }
    if (!_zones.containsKey(targetZone) ||
        targetTableIndex < 0 ||
        targetTableIndex >= _zones[targetZone]!.length) {
      return;
    }
    final targetTable = _zones[targetZone]![targetTableIndex];
    sourceTable.people = sourceTable.people! - movedGuests;
    targetTable.people = (targetTable.people ?? 0) + movedGuests;
    debugPrint(
        'Moved $movedGuests guests from ${sourceTable.name} to ${targetTable.name}');
    if (sourceTable.people == 0) {
      sourceTable.people = null;
      sourceTable.state = sourceTable.orders.isEmpty ? 0 : 1;
      debugPrint('Source table ${sourceTable.name} now has no guests.');
    }
    targetTable.state = 1;
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // ย้ายออร์เดอร์ทั้งหมดจากโต๊ะปัจจุบัน ไปโต๊ะเป้าหมาย
  // ------------------------------------------------------------------------
  void moveOrdersToTable(String targetZone, int targetTableIndex) {
    final sourceTable = getSelectedTable();
    if (sourceTable == null) return;
    if (!_zones.containsKey(targetZone) ||
        targetTableIndex < 0 ||
        targetTableIndex >= _zones[targetZone]!.length) return;

    final targetTable = _zones[targetZone]![targetTableIndex];
    debugPrint('Moving orders from ${sourceTable.name} to ${targetTable.name}');

    for (var order in List<Map<String, dynamic>>.from(sourceTable.orders)) {
      final idx = targetTable.orders
          .indexWhere((item) => item['name'] == order['name']);
      if (idx != -1) {
        targetTable.orders[idx]['quantity'] += order['quantity'];
        targetTable.orders[idx]['new'] = true;
        debugPrint(
            'Updated order ${order['name']} in ${targetTable.name} with new quantity ${targetTable.orders[idx]['quantity']}');
      } else {
        targetTable.orders.add(Map.from(order)..['new'] = true);
        debugPrint('Added new order ${order['name']} to ${targetTable.name}');
      }
    }
    sourceTable.orders.clear();
    sourceTable.state = 0;
    targetTable.state = 1;
    debugPrint(
        'Completed moving orders from ${sourceTable.name} to ${targetTable.name}');
    notifyListeners();
  }

  // ------------------------------------------------------------------------
  // Table state handling
  // ------------------------------------------------------------------------
  void markTableAsReadyToPay(String zone, int tableIndex) {
    if (_zones.containsKey(zone) &&
        tableIndex >= 0 &&
        tableIndex < _zones[zone]!.length) {
      _zones[zone]![tableIndex].state = 2;
      debugPrint(
          'Table ${_zones[zone]![tableIndex].name} marked as Ready to Pay');
      notifyListeners();
    }
  }

  void convertNewToCurrentOrder(String zone, int tableIndex) {
    if (_zones.containsKey(zone) &&
        tableIndex >= 0 &&
        tableIndex < _zones[zone]!.length) {
      final table = _zones[zone]![tableIndex];
      for (var newOrder in List<Map<String, dynamic>>.from(table.orders)
          .where((order) => order['new'] == true)) {
        final idx = table.orders.indexWhere((order) =>
            order['name'] == newOrder['name'] && order['new'] != true);
        if (idx != -1) {
          table.orders[idx]['quantity'] += newOrder['quantity'];
          debugPrint(
              'Updated existing order ${newOrder['name']} in table ${table.name} with new quantity ${table.orders[idx]['quantity']}');
        } else {
          table.orders.add({
            'name': newOrder['name'],
            'price': newOrder['price'],
            'quantity': newOrder['quantity'],
            'image_url': newOrder['image_url'] ?? '',
            'new': false,
          });
          debugPrint(
              'Added new order ${newOrder['name']} to table ${table.name}');
        }
      }
      table.orders.removeWhere((order) => order['new'] == true);
      table.state = 1;
      debugPrint(
          'Converted new orders to current orders for table ${table.name}');
      notifyListeners();
    }
  }

  void moveSingleOrder({
    required String fromZone,
    required int fromTableIndex,
    required String orderName,
    required double price,
    required int quantity,
    required String toZone,
    required int toTableIndex,
  }) {
    final fromTable = getTableData(fromZone, fromTableIndex);
    final toTable = getTableData(toZone, toTableIndex);
    if (fromTable == null || toTable == null) {
      debugPrint('Source or Destination table is null.');
      return;
    }
    final idx =
        fromTable.orders.indexWhere((order) => order['name'] == orderName);
    if (idx == -1) {
      debugPrint(
          'Order $orderName not found in source table ${fromTable.name}');
      return;
    }
    final order = fromTable.orders[idx];
    if (order['quantity'] > quantity) {
      fromTable.orders[idx]['quantity'] -= quantity;
      debugPrint(
          'Decreased quantity of $orderName in ${fromTable.name} by $quantity. New quantity: ${fromTable.orders[idx]['quantity']}');
    } else {
      fromTable.orders.removeAt(idx);
      debugPrint(
          'Removed order $orderName from source table ${fromTable.name}');
    }
    final tIdx =
        toTable.orders.indexWhere((order) => order['name'] == orderName);
    if (tIdx != -1) {
      toTable.orders[tIdx]['quantity'] += quantity;
      toTable.orders[tIdx]['new'] = true;
      debugPrint(
          'Updated order $orderName in destination table ${toTable.name} with new quantity ${toTable.orders[tIdx]['quantity']}');
    } else {
      toTable.orders.add({
        'item_id': order['item_id'] ?? '',
        'name': orderName,
        'price': price,
        'quantity': quantity,
        'image_url': order['image_url'] ?? '',
        'new': toTable.state == 2,
      });
      debugPrint(
          'Added new order $orderName to destination table ${toTable.name}');
    }
    fromTable.state = fromTable.orders.isEmpty ? 0 : 1;
    toTable.state = toTable.orders.isEmpty ? 0 : 1;
    debugPrint(
        'Moved $quantity of $orderName from ${fromTable.name} to ${toTable.name}');
    notifyListeners();
  }

  void toggleTableState(String zone, int tableIndex) {
    final table = getTableData(zone, tableIndex);
    if (table == null) {
      debugPrint('Table not found: Zone=$zone, Index=$tableIndex');
      return;
    }
    table.state = table.state == 2 ? 0 : 2;
    debugPrint('Toggled state of table ${table.name} to ${table.state}');
    notifyListeners();
  }

  void updateTableState(String zone, int index, int state) {
    if (_zones.containsKey(zone) &&
        index >= 0 &&
        index < _zones[zone]!.length) {
      _zones[zone]![index].state = state;
      debugPrint(
          'Updated state of table ${_zones[zone]![index].name} to $state');
      notifyListeners();
    }
  }

  String? getCurrentZone() => currentZone;
  int? getCurrentTableIndex() => currentTableIndex;

  // ------------------------------------------------------------------------
  // โหลดรายการออร์เดอร์ของโต๊ะจาก API (หากต้องการ)
  // ------------------------------------------------------------------------
  Future<void> fetchTableOrdersForTable(String zone, int tableIndex) async {
    final table = getTableData(zone, tableIndex);
    if (table == null) {
      debugPrint('Table not found for zone: $zone, index: $tableIndex');
      return;
    }

    debugPrint(
        'Fetching orders for Table ${table.name} at zone: $zone, index: $tableIndex');

    final apiUrl =
        'https://sounddev.triggersplus.com/order/open_table_order_list/F236C2691F953686A95A8ACB7EEF782D/-/$zone/${table.name}/-/0006897641/?output=json';

    debugPrint('Fetching orders from API: $apiUrl');

    try {
      final response = await http.get(Uri.parse(apiUrl));
      debugPrint('API Response Status: ${response.statusCode}');

      if (response.statusCode != 200) {
        debugPrint(
            'Failed to fetch orders. Status code: ${response.statusCode}');
        return;
      }

      final data = json.decode(response.body);
      debugPrint('Fetched Orders Response: $data');

      if (data == null || data.isEmpty || data['datas'] == null) {
        debugPrint('No data found in API response for Table ${table.name}.');
        table.orders = [];
        table.state = 0;
        notifyListeners();
        return;
      }

      // --- ดึง billing_id และ guest_amount ---
      if (data['datas'] is List && (data['datas'] as List).isNotEmpty) {
        final tableData = data['datas'][0];
        final String? billingId = tableData['billing_id'];
        final dynamic guestAmount = tableData['guest_amount'];
        if (billingId != null && billingId.toString().isNotEmpty) {
          table.orderId = billingId.toString().startsWith('#')
              ? billingId.toString().substring(1)
              : billingId.toString();
          debugPrint('Set orderId for table ${table.name}: ${table.orderId}');
        }
        table.people = guestAmount ?? table.people;
        debugPrint('Set guest amount for table ${table.name}: ${table.people}');
      }

      final List<Map<String, dynamic>> newOrders = _parseOrders(data['datas']);
      if (newOrders.isEmpty) {
        debugPrint('No orders found for Table ${table.name}.');
        table.orders = [];
        table.state = 0;
      } else {
        debugPrint('Processed Orders for Table ${table.name}: $newOrders');
        table.orders = newOrders;
        table.state = 1;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching orders for Table ${table.name}: $e');
    }
  }

  // แปลงข้อมูลจาก API ให้เป็น List<Map<String, dynamic>> ของออร์เดอร์
  List<Map<String, dynamic>> _parseOrders(List<dynamic>? datas) {
    if (datas == null || datas.isEmpty) {
      return [];
    }

    final List<Map<String, dynamic>> orders = [];

    for (var tableData in datas) {
      final items = tableData['items'];
      if (items != null && items is List) {
        for (var orderGroup in items) {
          final orderItems = orderGroup['items'];
          if (orderItems != null && orderItems is List) {
            for (var item in orderItems) {
              orders.add({
                'item_id': item['id']?.toString() ?? '',
                'name': item['name'] ?? item['name_order'] ?? 'Unnamed',
                'price': item['final_price'] is num
                    ? (item['final_price'] as num).toDouble()
                    : 0.0,
                'quantity': item['amount'] ?? 1,
                'image_url': item['image_url'] ?? '',
                'new': false,
              });
            }
          }
        }
      }
    }
    return orders;
  }
}
