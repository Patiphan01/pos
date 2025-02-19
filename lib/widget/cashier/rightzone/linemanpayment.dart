import 'package:flutter/material.dart';

class LinemanPayment extends StatelessWidget {
  final double inputAmount; // จำนวนเงินที่กรอก
  final ValueChanged<double>
      onInputChanged; // Callback เมื่อจำนวนเงินเปลี่ยนแปลง
  final ValueChanged<String> onNoteChanged; // Callback เมื่อ Note เปลี่ยนแปลง
  final VoidCallback onCheckPressed; // Callback เมื่อกด Check
  final VoidCallback onFinishedPressed; // Callback เมื่อกด Finished Bill

  const LinemanPayment({
    Key? key,
    required this.inputAmount,
    required this.onInputChanged,
    required this.onNoteChanged,
    required this.onCheckPressed,
    required this.onFinishedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 435.0, // ความกว้าง container
      height: 430.0, // ความสูง container
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Void Amount Header
          _buildVoidAmountHeader(),

          // Numpad and Note Section
          Expanded(
            child: Row(
              children: [
                // Number Pad
                Expanded(
                  flex: 2,
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 1.5,
                    physics: const NeverScrollableScrollPhysics(),
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
                      ].map((value) => _buildButton(value,
                          width: 70, height: 50)), // ใช้ขนาดจาก VoidPayment
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Note Section
                Expanded(
                  flex: 1,
                  child: _buildNoteSection(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildActionButton(
                label: "Check",
                color: const Color(0xFFABE3FF),
                onPressed: onCheckPressed,
              ),
              _buildActionButton(
                label: "Finished Bill",
                color: const Color(0xFFBDFFAD),
                onPressed: onFinishedPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Void Amount Header
  Widget _buildVoidAmountHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lineman Credit and Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "lineman Credit",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              Text(
                inputAmount.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          // Change and Value
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Change",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                inputAmount.toStringAsFixed(1), // แสดงทศนิยม 1 ตำแหน่ง
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build each button in the Number Pad
  Widget _buildButton(String label,
      {required double width, required double height}) {
    final bool isSpecialButton = ["⌫"].contains(label);

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
            String currentAmount = inputAmount.toString();
            if (!currentAmount.contains('.')) {
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
              ? const Color(0xFFF8B5B5)
              : Colors.white, // ปุ่มพิเศษใช้สีแดง
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: EdgeInsets.zero,
          side: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
        child: label == "⌫"
            ? const Icon(Icons.backspace, color: Colors.black, size: 20)
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
      ),
    );
  }

  // Note Section
  Widget _buildNoteSection() {
    return TextField(
      maxLines: 5,
      decoration: InputDecoration(
        hintText: "Note",
        hintStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: onNoteChanged,
    );
  }

  // Function to build Action Buttons without Icon
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        height: 25, // ลดความสูงจาก 64 เป็น 40 เพื่อให้เข้ากับ UI ใหม่
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
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
