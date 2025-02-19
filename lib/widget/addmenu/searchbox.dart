import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  const SearchBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10), // ระยะห่างจาก Sidebar
      // ใช้ constraints แทนการกำหนด width ตายตัว
      constraints: const BoxConstraints(maxWidth: 785),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200, width: 1),
      ),
      child: Row(
        children: [
          // พื้นหลังสีแดงอ่อนพร้อมไอคอน
          Container(
            width: 40,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            // ใช้ Center ห่อ Icon เพื่อให้อยู่กึ่งกลางช่อง
            child: const Center(
              child: Icon(
                Icons.search,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          // ช่องใส่ข้อความค้นหา
          Expanded(
            child: TextField(
              // จัดให้อยู่ซ้ายในแนวนอน
              textAlign: TextAlign.left,
              // จัดให้อยู่กึ่งกลางในแนวตั้ง
              textAlignVertical: TextAlignVertical.center,
              
              decoration: InputDecoration(
                // เพิ่ม padding ด้านข้างเพื่อไม่ให้ชิดขอบจนเกินไป
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 15,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
