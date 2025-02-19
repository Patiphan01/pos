// lib/pages/add_menu_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fucntion/tableprovider.dart'; // แก้ไขเส้นทางให้ถูกต้อง
import '../widget/appbar.dart';
import '../widget/addmenu/categoriesmenu.dart';
import '../widget/addmenu/subcategories.dart';
import '../widget/addmenu/searchbox.dart';
import '../widget/addmenu/menu_grid_section.dart'; // ตรวจสอบให้แน่ใจว่าไฟล์นี้มีการประกาศ MenuGrid widget ที่มี parameter: selectedZone และ selectedTableIndex
import '../widget/addmenu/ordersummary.dart';
import '../widget/addmenu/logopos.dart';

class AddMenuPage extends StatefulWidget {
  const AddMenuPage({Key? key}) : super(key: key);

  @override
  _AddMenuPageState createState() => _AddMenuPageState();
}

class _AddMenuPageState extends State<AddMenuPage> {
  @override
  void initState() {
    super.initState();
    // ใช้ Future.microtask เพื่อเรียกใช้ Provider หลัง initState เสร็จแล้ว
    Future.microtask(() {
      final tableProvider = Provider.of<TableProvider>(context, listen: false);
      // โหลด Categories, Table Zones และ Group Option List เมื่อเข้าสู่หน้า AddMenu
      tableProvider.loadCategoriesAndMenuItems(id: '801AA5A07EFC4F57A7F35C4AA9199584');
      tableProvider.loadTableZones();
      tableProvider.loadGroupOptionList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(
      builder: (context, tableProvider, child) {
        // ตรวจสอบว่าได้เลือกโซนและโต๊ะหรือไม่
        final selectedZone = tableProvider.currentZone;
        final selectedTableIndex = tableProvider.currentTableIndex;

        debugPrint(
            'AddMenuPage - Selected Zone: $selectedZone, Selected Table Index: $selectedTableIndex');

        if (selectedZone == null || selectedTableIndex == null) {
          // หากไม่มีการเลือกโซนหรือโต๊ะ ให้แสดงข้อความแจ้งเตือน
          return Scaffold(
            appBar: appbaraot(),
            body: const Center(
              child: Text(
                "No table selected. Please go back and select a table.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: appbaraot(),
          backgroundColor: Colors.white,
          body: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CategoriesMenu(),
                      const SubCategory(),
                      const SizedBox(height: 10),
                      const SearchBox(),
                      const SizedBox(height: 10),
                      Expanded(
                        // ส่ง selectedZone และ selectedTableIndex ให้กับ MenuGrid widget
                        child: MenuGrid(
                          selectedZone: selectedZone,
                          selectedTableIndex: selectedTableIndex,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // พื้นที่แสดง Logo และ OrderSummary
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    children: [
                      // Logo ส่วนบน
                      const SizedBox(
                        height: 70,
                        child: LogoPosPage(),
                      ),
                      // Order Summary ส่วนล่าง
                      Expanded(
                        child: SizedBox(
                          width: 332,
                          child: OrderSummary(
                            zone: selectedZone,
                            tableNumber: selectedTableIndex + 1, // เปลี่ยนจาก index เป็นหมายเลขโต๊ะ
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
