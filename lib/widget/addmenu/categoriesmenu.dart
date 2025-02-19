// lib/widget/addmenu/categoriesmenu.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fucntion/tableprovider.dart';

class CategoriesMenu extends StatefulWidget {
  const CategoriesMenu({Key? key}) : super(key: key);

  @override
  State<CategoriesMenu> createState() => _CategoriesMenuState();
}

class _CategoriesMenuState extends State<CategoriesMenu> {
  int hoverIndex = -1; // ใช้เก็บ index สำหรับ hover

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(
      builder: (context, tableProvider, child) {
        final categories = tableProvider.categories;
        final selectedCategory = tableProvider.selectedCategory;

        return Container(
          width: 787, // กำหนดความกว้างคงที่
          height: 100, // กำหนดความสูงคงที่
          margin: const EdgeInsets.only(left: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDBDB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, // เพิ่มการเลื่อนแนวนอน
            child: Row(
              children: List.generate(categories.length, (index) {
                final category = categories[index];
                final isSelected = category.name == selectedCategory;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10), // ระยะห่างเท่ากันระหว่างหมวดหมู่
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MouseRegion(
                        onEnter: (_) {
                          setState(() {
                            hoverIndex = index;
                          });
                        },
                        onExit: (_) {
                          setState(() {
                            hoverIndex = -1;
                          });
                        },
                        child: GestureDetector(
                          onTap: () {
                            tableProvider.selectCategory(category.name);
                          },
                          child: Container(
                            width: 50, // ลดขนาดวงกลม
                            height: 50, // ลดขนาดวงกลม
                            decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: OvalBorder(
                                side: BorderSide(
                                  width: 3, // ลดความกว้างของเส้นขอบ
                                  color: isSelected
                                      ? const Color(0xFFFF6E6E) // สีแดงถ้าเลือก
                                      : (hoverIndex == index
                                          ? const Color(0xFFFFA726) // สีส้มถ้า hover
                                          : Colors.transparent), // ไม่มีกรอบ
                                ),
                              ),
                            ),
                            // เพิ่มรูปภาพหรือเนื้อหาอื่นๆ ภายในวงกลมได้ที่นี่
                            child: Center(
                              child: category.imageUrl.isNotEmpty
                                  ? ClipOval(
                                      child: Image.network(
                                        category.imageUrl,
                                        width:
                                            46, // ให้มีขนาดเล็กลงเล็กน้อยเพื่อไม่ให้เกินขอบ
                                        height: 46,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    )
                                  : Text(
                                      category.name.isNotEmpty
                                          ? category.name[0]
                                          : '', // แสดงตัวแรกของหมวดหมู่ถ้าไม่มีรูปภาพ
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFFFF6E6E)
                                            : const Color(0xFF505050),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                          height: 7), // ระยะห่างระหว่างวงกลมและ label
                      Text(
                        category.name,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFFFF6E6E) // สีแดงถ้าเลือก
                              : const Color(0xFF505050), // สีเทาปกติ
                          fontSize: 14, // ลดขนาดตัวอักษรลงเล็กน้อย
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}
