import 'package:flutter/material.dart';
import '../appbar.dart'; // ดึง appbaraot เข้ามา
import '../../widget/setting/print.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    // context ใช้สำหรับอ้างถึงตำแหน่งของ Widget นี้ใน Widget Tree
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100), // กำหนดความสูงของ AppBar
        child: const appbaraot(), // เรียกใช้งาน appbaraot ที่สร้างไว้
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSettingOption(
              context,
              icon: Icons.info_outline,
              text: "About App",
              onTap: () {
                // ใช้ context ได้ที่นี่
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("About App Clicked")),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildSettingOption(
              context,
              icon: Icons.print,
              text: "Printer Setting",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PrinterSettingPage()),
                );
              },
            ),
            const SizedBox(height: 10),
            _buildSettingOption(
              context,
              icon: Icons.sync,
              text: "RC Start Sync",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("RC Start Sync Clicked")),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color:
              const Color.fromARGB(255, 206, 248, 158), // พื้นหลังสีเขียวอ่อน
          borderRadius: BorderRadius.circular(10), // ขอบโค้งมน
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
