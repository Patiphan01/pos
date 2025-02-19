import 'package:flutter/material.dart';

class Visapayment extends StatelessWidget {
  final double totalAmount; // ยอดรวมทั้งหมด
  final double inputAmount; // จำนวนเงินที่กรอก
  final ValueChanged<double>
      onInputChanged; // Callback เมื่อจำนวนเงินเปลี่ยนแปลง

  const Visapayment({
    Key? key,
    required this.totalAmount,
    required this.inputAmount,
    required this.onInputChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // คำนวณขนาดปุ่มตามความกว้างที่มีอยู่
        double totalSpacing = 10.0; // ระยะห่างรวม (5.0 * 2 สำหรับ 3 ช่อง)
        int crossAxisCount = 3; // จำนวนคอลัมน์
        double buttonWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;
        double buttonHeight = buttonWidth * 0.5; // อัตราส่วนความสูง

        return Container(
          // ไม่กำหนด width และ height แบบคงที่
          padding: const EdgeInsets.all(8.0), // ลด padding จาก 16 เป็น 8
          decoration: BoxDecoration(
            color: const Color(0xFFFFEAEA),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Amount and Ref Section
              _buildAmountAndRefSection(),

              // Number Pad
              Flexible(
                flex: 1, // ใช้ Flexible แทน Expanded
                child: GridView.count(
                  crossAxisCount: crossAxisCount, // จำนวนคอลัมน์
                  crossAxisSpacing: 5.0, // ระยะห่างแนวนอน
                  mainAxisSpacing: 5.0, // ระยะห่างแนวตั้ง
                  childAspectRatio:
                      buttonWidth / buttonHeight, // สัดส่วนของปุ่ม
                  physics: const NeverScrollableScrollPhysics(), // ปิด Scroll
                  children: [
                    ...[
                      "1",
                      "2",
                      "3",
                      "4",
                      "5",
                      "6",
                      "7",
                      "8",
                      "9",
                      ".",
                      "0",
                      "⌫",
                    ].map((value) => _buildButton(
                          value,
                          width: buttonWidth,
                          height: buttonHeight,
                        )),
                  ],
                ),
              ),

              const SizedBox(height: 4), // ลดระยะห่างจาก 8 เป็น 4

              // Action Buttons (Check & Finished Bill)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildActionButton(
                    "Check",
                    const Color(0xFFABE3FF),
                  ),
                  _buildActionButton(
                    "Finished Bill",
                    const Color(0xFFBDFFAD),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Amount and Ref Section
  Widget _buildAmountAndRefSection() {
    double change = inputAmount - totalAmount; // คำนวณเงินทอน
    return Container(
      padding: const EdgeInsets.all(6.0), // ลด padding จาก 16 เป็น 6
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 254, 254),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color.fromARGB(255, 112, 111, 111)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Amount',
                style: TextStyle(
                  fontSize: 14, // ลดขนาดจาก 16 เป็น 14
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Text(
                totalAmount.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 14, // ลดขนาดจาก 16 เป็น 14
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Reference Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ref.',
                style: TextStyle(
                  fontSize: 14, // ลดขนาดจาก 20 เป็น 14
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                'xxxx-xxxx-xxxx-1234',
                style: TextStyle(
                  fontSize: 14, // ลดขนาดจาก 20 เป็น 14
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Display Change
        ],
      ),
    );
  }

  // Function to build each button in the Number Pad
  Widget _buildButton(String label,
      {required double width, required double height}) {
    final bool isSpecialButton =
        ["⌫", "50", "100", "500", "1000"].contains(label);

    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          double newValue = inputAmount;
          if (label == "⌫") {
            if (newValue > 0) {
              newValue = (newValue / 10).floorToDouble();
            }
          } else if (label == ".") {
            // การจัดการกับจุดทศนิยม สามารถเพิ่มการจัดการเพิ่มเติมได้
            String currentAmount = inputAmount.toString();
            if (!currentAmount.contains('.')) {
              // เพิ่มจุดทศนิยมหนึ่งครั้ง
              // การทำแบบนี้อาจไม่เหมาะสมสำหรับการคำนวณจริง ๆ
              // ควรใช้ String manipulation ใน Stateful Widget เพื่อจัดการ inputAmount
              newValue = double.parse(currentAmount + '0.1');
            }
          } else {
            double? addedValue = double.tryParse(label);
            if (addedValue != null) {
              newValue = inputAmount * 10 + addedValue;
            }
          }
          onInputChanged(newValue);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSpecialButton
              ? const Color.fromARGB(255, 248, 181, 181)
              : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.zero,
          side: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        child: label == "⌫"
            ? Icon(Icons.backspace, color: Colors.black, size: height * 0.5)
            : Text(
                label,
                style: TextStyle(
                  fontSize: height * 0.3, // ลดขนาดฟอนต์ให้เล็กลง
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 63, 62, 62),
                ),
              ),
      ),
    );
  }

  // Function to build Action Buttons without Logo
  Widget _buildActionButton(String label, Color color) {
    return Expanded(
      child: Container(
        height: 25, // ลดความสูงจาก 64 เป็น 25 เพื่อให้เข้ากับ CashPayment
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: () {
            debugPrint("$label button pressed");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14, // ลดขนาดฟอนต์จาก 16 เป็น 14
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
