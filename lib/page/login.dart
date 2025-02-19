import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../page/table_selection.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import '../fucntion/staffprovider.dart'; // นำเข้า Provider

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  // ฟังก์ชันนี้จะถูกเรียกเมื่อผู้ใช้กรอก PIN ครบ 4 หลัก
  void _onCompleted(String pin) async {
    if (pin.length == 4) {
      debugPrint("PIN entered: $pin");
      _handleLogin(pin);
    }
  }

  void _handleLogin(String pin) async {
    BuildContext context = this.context; // ใช้ context จาก StatefulWidget
    try {
      final url =
          'https://sounddev.triggersplus.com/dining/get_stuff_list/F236C2691F953686A95A8ACB7EEF782D/';
      debugPrint("Calling API: $url");
      final response = await http.get(Uri.parse(url));
      debugPrint("API Response status: ${response.statusCode}");
      debugPrint("API Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bool valid = false;

        if (data is Map && data['staff_list'] is List) {
          for (var staff in data['staff_list']) {
            debugPrint(
                "Comparing staff password: '${staff['password']}' with PIN: '$pin'");
            if (staff['password'].toString().trim() == pin.trim()) {
              valid = true;

              // ✅ เซ็ตค่า staff ลงใน Provider
              Provider.of<StaffProvider>(context, listen: false).setStaff(
                staff['id'].toString(),
                staff['name'].toString(),
              );

              debugPrint(
                  "✅ Staff Logged In: ID = ${staff['id']}, Name = ${staff['name']}");
              break;
            }
          }
        } else {
          debugPrint("❌ Error: API did not return expected format.");
        }

        if (valid) {
          debugPrint("✅ Login valid: PIN matches staff password");

          // ไปยังหน้า TableSelectionPage
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TableSelectionPage()),
          );
        } else {
          debugPrint("❌ Login failed: PIN does not match any staff password");
          _showErrorDialog(
              context, 'Login Failed', 'โปรดตรวจสอบ รหัสผ่าน (PIN) อีกครั้ง');
        }
      } else {
        debugPrint(
            "❌ Login failed: Server responded with status: ${response.statusCode}");
        _showErrorDialog(context, 'Login Failed',
            'Server responded with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Exception during login: $e");
      _showErrorDialog(context, 'Login Error', e.toString());
    }
  }

  // ฟังก์ชันแสดง Error Dialog
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'PHOENIX POS',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              // Logo
              Image.asset(
                'assets/img/logo_pink.png',
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'Logo not found!',
                    style: TextStyle(color: Colors.red),
                  );
                },
              ),
              const SizedBox(height: 30),
              // Login Label
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.red[400],
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // PIN Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Pinput(
                  length: 4,
                  controller: _pinController,
                  focusNode: FocusNode(),
                  obscureText: true, // ซ่อนตัวเลขที่กรอก
                  obscuringWidget: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  onCompleted: _onCompleted, // ✅ ใช้งานได้ถูกต้อง
                  mainAxisAlignment: MainAxisAlignment.center,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.red[400],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
