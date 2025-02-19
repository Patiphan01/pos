import 'package:flutter/material.dart';

class CardPayment extends StatelessWidget {
  final double totalAmount; // ยอดรวมทั้งหมด
  final VoidCallback onCapturePressed; // Callback สำหรับปุ่มถ่ายรูป

  const CardPayment({
    Key? key,
    required this.totalAmount,
    required this.onCapturePressed,
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
          // Header: Amount

          // Camera Box with Gradient
          Expanded(
            child: Container(
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [
                    Colors.white,
                    Color(0xFF999999), // ไล่ระดับจากสีขาวไปเทา
                  ],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                shadows: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.camera_alt,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed:
                          onCapturePressed, // Callback เมื่อกดปุ่มถ่ายรูป
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
