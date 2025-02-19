// lib/widget/addmenu/subcategories.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fucntion/tableprovider.dart';

class SubCategory extends StatelessWidget {
  const SubCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(
      builder: (context, provider, child) {
        final subcategories = provider.subcategories;
        final selectedSubcategory = provider.selectedSubcategory;

        if (subcategories.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          width: 787, // กำหนดความกว้างคงที่ให้เหมือน CategoriesMenu
          height: 39, // กำหนดความสูงให้เหมาะสมเหมือนเดิม
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDBDB),
            border: const Border(
              top: BorderSide(
                width: 1,
                color: Color(0xFFFF6E6E), // สีของเส้นขอบด้านบน
              ),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), // ขอบล่างซ้ายโค้งมน
              bottomRight: Radius.circular(20), // ขอบล่างขวาโค้งมน
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // เลื่อนแนวนอน
            child: Row(
              mainAxisSize: MainAxisSize.min, // ใช้พื้นที่เท่าที่จำเป็น
              children: List.generate(
                subcategories.length,
                (index) {
                  final subcategory = subcategories[index];
                  final isSelected = subcategory == selectedSubcategory;

                  return GestureDetector(
                    onTap: () {
                      provider.selectSubcategory(subcategory);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 20), // ระยะห่างระหว่างตัวเลือก
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ), // เพิ่ม padding เพื่อให้มีพื้นที่คลิกมากขึ้น
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF6E6E) // สีแดงเมื่อเลือก
                              : Colors.transparent, // ไม่มีกรอบเมื่อไม่ได้เลือก
                          width: 2,
                        ),
                      ),
                      child: Text(
                        subcategory,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFFFF6E6E) // สีแดงเมื่อเลือก
                              : const Color(0xFF505050), // สีเทาเมื่อไม่ได้เลือก
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
