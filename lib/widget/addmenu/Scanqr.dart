import 'package:flutter/material.dart';

class MockScanQRCodePage extends StatelessWidget {
  const MockScanQRCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // กล่องจำลองพื้นที่สำหรับ QR Scanner
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Scanning...',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // ตัวอย่างการส่งค่ากลับ
                Navigator.pop(context, "MockQRCode12345");
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Simulate Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
