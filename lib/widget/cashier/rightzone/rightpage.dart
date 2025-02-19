import 'package:flutter/material.dart';
import 'cashpayment.dart';
import 'CDcardpayment.dart';
import 'visapayment.dart';
import 'MScardpayment.dart';
import 'cardpayment.dart';
import 'promptpay.dart';
import 'voidpayment.dart';
import 'linemanpayment.dart';
import 'grabpayment.dart';
import 'foodpandapayment.dart';

class RightPage extends StatefulWidget {
  const RightPage({Key? key}) : super(key: key);

  @override
  State<RightPage> createState() => _RightPageState();
}

class _RightPageState extends State<RightPage> {
  String selectedMethod = "Cash"; // ค่าเริ่มต้นสำหรับ Payment Method ที่เลือก
  final double totalAmount = 748.90; // ยอดรวม
  double inputAmount = 0.0; // จำนวนเงินที่กรอก

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0), // ปรับ padding ให้เหมาะสม
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),

          _buildPaymentMethodsContainer(),

          // แสดง Widget ตาม Payment Method ที่เลือก
          Expanded(child: _getSelectedPaymentWidget()),
        ],
      ),
    );
  }

  // แยก Header เป็นฟังก์ชัน
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/img/payment.png',
              width: 30, // ลดขนาดจาก 40 เป็น 30
              height: 30, // ลดขนาดจาก 40 เป็น 30
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8), // ลดระยะห่างจาก 15 เป็น 10
            const Text(
              'Payment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        IconButton(
          icon: Image.asset(
            'assets/img/Xexit.png',
            width: 40,
            height: 30,
            fit: BoxFit.contain,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  // ฟังก์ชันที่ Return Widget ตาม Payment Method ที่เลือก
  Widget _getSelectedPaymentWidget() {
    final paymentWidgets = {
      "Cash": CashPayment(
        totalAmount: totalAmount,
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
      ),
      "Credit Card": CreditCardPayment(
        totalAmount: totalAmount,
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
      ),
      "VISA": Visapayment(
        totalAmount: totalAmount,
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
      ),
      "MasterCard": MasterCardPayment(
        totalAmount: totalAmount,
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
      ),
      "Card": CardPayment(
        totalAmount: totalAmount,
        onCapturePressed: () {
          debugPrint("Capture button pressed!");
        },
      ),
      "Prompt Pay": PromptPayPayment(
        qrImagePath: "assets/img/promptpay_qr.png",
        onFinishedPressed: () {
          debugPrint("Finished Bill Pressed!");
        },
      ),
      "Void": VoidPayment(
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
        onNoteChanged: _handleNoteChanged,
        onCheckPressed: () => debugPrint("Check button pressed!"),
        onFinishedPressed: () => debugPrint("Finished Bill button pressed!"),
      ),
      "Lineman": LinemanPayment(
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
        onNoteChanged: _handleNoteChanged,
        onCheckPressed: () => debugPrint("Check button pressed!"),
        onFinishedPressed: () => debugPrint("Finished Bill button pressed!"),
      ),
      "Grab Credit": GrabPayment(
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
        onNoteChanged: _handleNoteChanged,
        onCheckPressed: () => debugPrint("Check button pressed!"),
        onFinishedPressed: () => debugPrint("Finished Bill button pressed!"),
      ),
      "Foodpanda": FoodpandaPayment(
        inputAmount: inputAmount,
        onInputChanged: _updateInputAmount,
        onNoteChanged: _handleNoteChanged,
        onCheckPressed: () => debugPrint("Check button pressed!"),
        onFinishedPressed: () => debugPrint("Finished Bill button pressed!"),
      ),
    };

    return paymentWidgets[selectedMethod] ?? const SizedBox();
  }

  // ฟังก์ชันอัปเดตจำนวนเงิน
  void _updateInputAmount(double newAmount) {
    setState(() {
      inputAmount = newAmount;
    });
  }

  // ฟังก์ชันจัดการ Note
  void _handleNoteChanged(String note) {
    debugPrint("Note: $note");
  }

  // Container สำหรับปุ่ม Payment Methods
  Widget _buildPaymentMethodsContainer() {
    final paymentMethods = [
      {"name": "Cash", "icon": "assets/img/cash.png"},
      {"name": "Card", "icon": "assets/img/cash.png"},
      {"name": "Credit Card", "icon": "assets/img/CDcard.png"},
      {"name": "MasterCard", "icon": "assets/img/MScard.png"},
      {"name": "VISA", "icon": "assets/img/visa.png"},
      {"name": "Prompt Pay", "icon": "assets/img/promtpay.png"},
      {"name": "Void", "icon": "assets/img/cash.png"},
      {"name": "Lineman", "icon": "assets/img/lineman.png"},
      {"name": "Grab Credit", "icon": "assets/img/cash.png"},
      {"name": "Foodpanda", "icon": "assets/img/foodpanda.png"},
      // ลบรายการที่ซ้ำกัน
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GridView.builder(
        shrinkWrap: true, // ให้ GridView ใช้พื้นที่เท่าที่จำเป็น
        physics:
            const NeverScrollableScrollPhysics(), // ปิด Scroll ของ GridView
        padding: EdgeInsets.zero,
        itemCount: paymentMethods.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // กำหนดจำนวนคอลัมน์
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 5, // ปรับสัดส่วนของ Grid Item
        ),
        itemBuilder: (context, index) {
          return _buildPaymentMethodButton(
            paymentMethods[index]["name"]!,
            paymentMethods[index]["icon"]!,
          );
        },
      ),
    );
  }

  Widget _buildPaymentMethodButton(String label, String imagePath) {
    final bool isSelected = label == selectedMethod;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color:
                isSelected ? const Color(0xFFFF6D6D) : const Color(0xFFE0E0E0),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 30, // ลดขนาดจาก 40 เป็น 30
              width: 30, // ลดขนาดจาก 40 เป็น 30
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10), // ลดระยะห่างจาก 15 เป็น 10
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16, // ลดขนาดฟอนต์จาก 20 เป็น 16
                  fontWeight: FontWeight.normal,
                  color: Colors.black, // สีเสมอเพื่อความอ่านง่าย
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
