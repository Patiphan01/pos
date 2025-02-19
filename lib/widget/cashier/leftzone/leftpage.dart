import 'package:flutter/material.dart';
import 'memberpop.dart';

class LeftPage extends StatefulWidget {
  const LeftPage({Key? key}) : super(key: key);

  @override
  State<LeftPage> createState() => _LeftPageState();
}

class _LeftPageState extends State<LeftPage> {
  bool checkboxFood = false;
  bool checkboxDrink = false;
  bool checkboxSalad = false;
  bool checkboxDessert = false;
  bool checkboxCoffee = false;

  String selectedMember = 'Select Member'; // Initial value for the button

  final List<Map<String, String>> mockMembers = [
    {'name': 'John Doe', 'phone': '0800600235'},
    {'name': 'Jane Smith', 'phone': '0800624835'},
    {'name': 'Michael Brown', 'phone': '0848500235'},
    {'name': 'Emily Davis', 'phone': '0960600235'},
  ];

  void _showMemberPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MemberPopup(
          mockMembers: mockMembers,
          onSelectMember: (selectedMember) {
            setState(() {
              this.selectedMember = selectedMember;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: 316,
              height: 52,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '#00001',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      'Zone A A1',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis, // ป้องกันข้อความล้น
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // Discount Section

            Container(
              width: 316,
              height: 251, // ปรับความสูงของ box ให้เล็กลง
              padding: const EdgeInsets.all(12.0), // ลด padding ให้สมส่วน
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discount',
                    style: TextStyle(
                      fontSize: 14, // ลดขนาดตัวอักษร
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // เพิ่มระยะห่างเล็กน้อย
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300, // เพิ่มเส้นขอบสีเทาอ่อน
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: SizedBox(
                      height: 140, // ปรับขนาด listview ให้เหมาะสม
                      child: ListView(
                        padding: const EdgeInsets.all(8.0),
                        children: [
                          _buildCheckboxTile(
                            '30% discount on Food',
                            checkboxFood,
                            (value) {
                              setState(() {
                                checkboxFood = value!;
                              });
                            },
                          ),
                          _buildCheckboxTile(
                            '20% discount on Drink',
                            checkboxDrink,
                            (value) {
                              setState(() {
                                checkboxDrink = value!;
                              });
                            },
                          ),
                          _buildCheckboxTile(
                            'Buy 2 get free Salad',
                            checkboxSalad,
                            (value) {
                              setState(() {
                                checkboxSalad = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gift Code Section
                  SizedBox(
                    width: double.infinity, // ปรับขนาดให้เต็มพื้นที่ที่มี
                    height: 40, // ความสูงคงที่
                    child: Row(
                      children: [
                        // Icon
                        SizedBox(
                          width: 16,
                          height: 16,
                          child: Image.asset(
                            'assets/img/Vector2.png',
                            color: const Color(0xFFFF6F6F),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Expanded ให้ TextField
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Gift Code',
                              hintStyle: const TextStyle(fontSize: 12),
                              suffixIcon: const Icon(Icons.search,
                                  size: 18), // Icon เล็กลง
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 12.0), // ลด padding
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            // Member + Void Section
            Column(
              children: [
                // Member Section
                Container(
                  width: 315,
                  height: 155,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.person, color: Colors.red, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Member',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: 238,
                        height: 56,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: _showMemberPopup,
                          icon: Image.asset(
                            'assets/img/member.png', // Path to your asset
                            width: 33, // Adjust width as needed
                            height: 20, // Adjust height as needed
                          ),
                          label: Text(
                            selectedMember,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 10,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 8), // เพิ่มระยะห่างระหว่าง Member กับ Void

                // Void Section
                Container(
                  width: 200,
                  height: 55,
                  decoration: ShapeDecoration(
                    color: Colors.white, // พื้นหลังสีขาวสำหรับ Container หลัก
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 200,
                      height: 55,
                      decoration: ShapeDecoration(
                        color:
                            const Color(0xFFFFD2C3), // สีพื้นหลังของปุ่ม Void
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // มุมโค้ง 10
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle Void Action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // ทำให้ปุ่มพื้นหลังใส
                          shadowColor: Colors.transparent, // ลบเงาของปุ่ม
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10), // มุมโค้งให้ตรงกับ Container
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ไอคอน Void (ใช้ภาพจาก assets)
                            Container(
                              width: 30, // กำหนดขนาดไอคอน
                              height: 41,

                              child: Padding(
                                padding: const EdgeInsets.all(
                                    0.0), // ระยะขอบภาพด้านใน
                                child: Image.asset(
                                  'assets/img/void.png', // พาธของไฟล์ไอคอน
                                  fit:
                                      BoxFit.contain, // จัดให้ภาพพอดีกับพื้นที่
                                ),
                              ),
                            ),
                            const SizedBox(
                                width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ

                            // ข้อความ Void
                            const Text(
                              'Void',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

Widget _buildCheckboxTile(
    String title, bool value, ValueChanged<bool?> onChanged) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(vertical: 4.0), // เพิ่ม Padding ระหว่างช่อง
    child: Container(
      height: 40, // กำหนดความสูงคงที่
      width: double.infinity, // ใช้ความกว้างเต็มพื้นที่ที่มี
      decoration: BoxDecoration(
        color: value
            ? const Color(0xFFFFEAEA) // พื้นหลังสีแดงอ่อนเมื่อถูกเลือก
            : Colors.white, // พื้นหลังสีขาวเมื่อยังไม่เลือก
        border: Border.all(
          color: const Color(0xFF8C8C8C), // กรอบสีเทา
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5), // มุมโค้ง 5
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor:
                const Color(0xFFFF6F6F), // สีแดงเมื่อ Checkbox ถูกเลือก
            visualDensity: const VisualDensity(
                horizontal: -4, vertical: -4), // ลดขนาด Checkbox ไม่ให้ใหญ่ขึ้น
          ),
          Expanded(
            // ใช้ Expanded ป้องกันข้อความล้น
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
