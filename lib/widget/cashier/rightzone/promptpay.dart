import 'package:flutter/material.dart';

class PromptPayPayment extends StatelessWidget {
  final String qrImagePath; // Path ของรูป QR Code
  final VoidCallback onFinishedPressed; // Callback เมื่อกดปุ่ม Finished Bill

  const PromptPayPayment({
    Key? key,
    required this.qrImagePath,
    required this.onFinishedPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 435.0,
      height: 430.0,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // QR Code Image Display
          Expanded(
            child: Center(
              child: Container(
                width: 268.0, // ความกว้างของรูป QR Code
                height: 268.0, // ความสูงของรูป QR Code
                decoration: BoxDecoration(
                  color: Colors.white, // สีพื้นหลังของรูป
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/img/qr_code.png',
                    fit: BoxFit.cover, // ให้รูปพอดีกับช่องที่กำหนด
                  ),
                ),
              ),
            ),
          ),
          // Finished Bill Button
          Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFBDFFAD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ElevatedButton.icon(
              onPressed: onFinishedPressed,
              icon: Image.asset(
                "assets/img/finished bill.png",
                width: 15,
                height: 15,
              ),
              label: const Text(
                "Finished Bill",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
