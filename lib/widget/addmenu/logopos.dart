import 'package:flutter/material.dart';

class LogoPosPage extends StatelessWidget {
  const LogoPosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Container(
          width: 332,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFFFF6E6E),
            borderRadius: BorderRadius.circular(10), // ขอบมนทุกด้าน
          ),
          child: const Center(
            child: Text(
              'LOGO POS',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 1.0, // ปรับให้ข้อความมีระยะห่างแนวตั้งพอดี
              ),
            ),
          ),
        ),
      ),
    );
  }
}
