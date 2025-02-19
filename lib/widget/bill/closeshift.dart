import 'package:flutter/material.dart';

// Widget สำหรับแถวใน Popup
class PopupRow extends StatelessWidget {
  final String label;
  final String value;

  const PopupRow({required this.label, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF505050),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF505050),
            ),
          ),
        ],
      ),
    );
  }
}

// Popup Widget สำหรับ "Close Shift"
class CloseShiftPopup extends StatelessWidget {
  const CloseShiftPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // คำนวณความสูงที่เหมาะสมจากหน้าจอ
    final double maxHeight = MediaQuery.of(context).size.height * 0.8;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight, // กำหนดความสูงสูงสุด
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6E6E),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Shift1',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // รายการข้อมูลใน Popup (ทำให้เลื่อนได้)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      PopupRow(label: 'Finished Orders', value: '7'),
                      PopupRow(label: 'Unfinished Orders', value: '2'),
                      Divider(),
                      PopupRow(label: 'Cash', value: '1,500'),
                      PopupRow(label: 'Credit Card', value: '1,000'),
                      PopupRow(label: 'Prompt Pay', value: '1,000'),
                      PopupRow(label: 'Transfer', value: '0'),
                      Divider(),
                      PopupRow(label: 'Subtotal', value: '3,500'),
                      PopupRow(label: 'Discount', value: '0'),
                      PopupRow(label: 'Service Charge', value: '0'),
                      PopupRow(label: 'VAT %', value: '0'),
                      PopupRow(label: 'Misc', value: '0'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // ปุ่ม Confirm และ Cancel
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Confirm
                        Navigator.of(context).pop(); // ปิด Popup
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6E6E), // สีแดง
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Radius.circular(12.0), // มุมล่างซ้ายโค้ง
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // เพิ่มความสูงปุ่ม
                      ),
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2), // ระยะห่างระหว่างปุ่ม
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle Cancel
                        Navigator.of(context).pop(); // ปิด Popup
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBFBFBF), // สีเทา
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomRight:
                                Radius.circular(12.0), // มุมล่างขวาโค้ง
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0), // เพิ่มความสูงปุ่ม
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
