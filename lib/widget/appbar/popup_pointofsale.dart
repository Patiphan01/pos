import 'package:flutter/material.dart';

class PointOfSalePopup extends StatefulWidget {
  const PointOfSalePopup({super.key});

  @override
  State<PointOfSalePopup> createState() => _PointOfSalePopupState();
}

class _PointOfSalePopupState extends State<PointOfSalePopup> {
  String _enteredPin = ""; // เก็บ PIN ที่กรอก
  final int _pinLength = 4; // ความยาวของ PIN

  @override
  Widget build(BuildContext context) {
    // คำนวณขนาดความสูงที่เหมาะสม
    double screenHeight = MediaQuery.of(context).size.height;
    double maxHeight =
        screenHeight * 0.9; // กำหนดความสูงสูงสุดไม่เกิน 70% ของหน้าจอ

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      backgroundColor: const Color(0xFFFFDCDC), // พื้นหลังของ Popup
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300, // กำหนดความกว้างสูงสุด
          maxHeight: maxHeight, // กำหนดความสูงสูงสุดไม่เกิน 70% ของหน้าจอ
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0), // ลด padding จาก 16 เป็น 12
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Enter PIN",
                  style: TextStyle(
                    fontSize: 18, // สามารถปรับกลับเป็น 18 หากต้องการ
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12), // ลดขนาดจาก 16 เป็น 12
                // ช่องกรอก PIN
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pinLength,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 4), // ลด margin จาก 6 เป็น 4
                      width: 32, // ลดขนาดจาก 40 เป็น 32
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white, // พื้นหลังสีขาว
                        borderRadius:
                            BorderRadius.circular(6), // ลด radius จาก 8 เป็น 6
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2, // ลด blurRadius จาก 4 เป็น 2
                            offset:
                                Offset(0, 1), // ลด offset จาก (0,2) เป็น (0,1)
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          _enteredPin.length > index ? "*" : "",
                          style: const TextStyle(
                            fontSize: 14, // ลด fontSize จาก 18 เป็น 14
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12), // ลดขนาดจาก 16 เป็น 12
                // แป้นตัวเลขแบบ numpad
                Column(
                  children: [
                    // แถวที่ 1: 1, 2, 3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton("1"),
                        _buildNumberButton("2"),
                        _buildNumberButton("3"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // แถวที่ 2: 4, 5, 6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton("4"),
                        _buildNumberButton("5"),
                        _buildNumberButton("6"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // แถวที่ 3: 7, 8, 9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNumberButton("7"),
                        _buildNumberButton("8"),
                        _buildNumberButton("9"),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // แถวที่ 4: ช่องว่าง, 0, Delete
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(
                            width: 57), // ช่องว่างข้างซ้าย (เท่ากับขนาดปุ่ม)
                        _buildNumberButton("0"),
                        _buildDeleteButton(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12), // ลดขนาดจาก 16 เป็น 12
                // ปุ่ม Cancel
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // ลด radius จาก 30 เป็น 20
                    ),
                    side: const BorderSide(
                      color: Colors.grey, // สีของกรอบ
                    ),
                    backgroundColor: Colors.grey, // สีพื้นหลังของปุ่ม
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8), // ลด padding จาก (20,10) เป็น (16,8)
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white, // สีของตัวอักษร
                      fontSize: 14, // ลด fontSize จาก 16 เป็น 14
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ปุ่มตัวเลข
  Widget _buildNumberButton(String number) {
    return InkWell(
      onTap: () {
        if (_enteredPin.length < _pinLength) {
          setState(() {
            _enteredPin += number;
          });
          if (_enteredPin.length == _pinLength) {
            _validatePin();
          }
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 55, // ลดขนาดจาก 40 เป็น 32
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white, // พื้นหลังสีขาว
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2, // ลด blurRadius จาก 4 เป็น 2
              offset: Offset(0, 1), // ลด offset จาก (0,2) เป็น (0,1)
            ),
          ],
        ),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 14, // ลด fontSize จาก 18 เป็น 14
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // ปุ่ม Delete
  Widget _buildDeleteButton() {
    return InkWell(
      onTap: () {
        if (_enteredPin.isNotEmpty) {
          setState(() {
            _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
          });
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 55, // ลดขนาดจาก 40 เป็น 32
        height: 55, // ลดขนาดจาก 40 เป็น 32
        decoration: BoxDecoration(
          color: Colors.white, // พื้นหลังสีขาว
          shape: BoxShape.circle, // วงกลมเพื่อให้เท่ากับปุ่มตัวเลข
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2, // ลด blurRadius จาก 4 เป็น 2
              offset: Offset(0, 1), // ลด offset จาก (0,2) เป็น (0,1)
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.backspace,
              color: Colors.black, size: 16), // ลดขนาดไอคอนจาก default เป็น 16
        ),
      ),
    );
  }

  // ตรวจสอบ PIN
  void _validatePin() {
    if (_enteredPin == "1234") {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("PIN Verified!")),
      );
    } else {
      setState(() {
        _enteredPin = "";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid PIN")),
      );
    }
  }
}
