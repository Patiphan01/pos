import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../page/table_selection.dart'; // หน้า TableSelectionPage
import '../page/addmenu.dart'; // หน้า AddMenuPage
import '../page/bill.dart'; // หน้า BillPage
import '../page/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'appbar/popup_pointofsale.dart';
import 'appbar/settingappbar.dart';
import 'appbar/print_Q.dart';
import '../fucntion/tableprovider.dart';
import '../page/test.dart';

class appbaraot extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const appbaraot({Key? key})
      : preferredSize = const Size.fromHeight(100), // ระบุความสูงที่ต้องการ
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeftSection(context),
          _buildCenterButtons(context),
          _buildRightSection(context),
        ],
      ),
    );
  }

  // Left Section with Manager Button Popup and Language Dropdown
  Widget _buildLeftSection(BuildContext context) {
    // ดึงภาษาปัจจุบันโดยตรงจาก TableProvider (static)
    final currentLanguage = TableProvider.language ?? "EN";
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => _showManagerPopup(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: const [
                    Icon(Icons.person, color: Colors.red, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Manager",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.circle, color: Colors.green, size: 10),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () => _showNewsPopup(context), // แสดง Popup "News"
              child: const FaIcon(
                FontAwesomeIcons.bullhorn,
                size: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => const PointOfSalePopup(),
                );
              },
              child: const Icon(
                Icons.point_of_sale,
                color: Colors.grey,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            // แสดง Dropdown สำหรับภาษาที่เลือก
            _buildLanguageDropdown(context, currentLanguage),
          ],
        ),
      ],
    );
  }

  // Dropdown Widget สำหรับเลือกภาษา
  Widget _buildLanguageDropdown(BuildContext context, String currentLanguage) {
    return DropdownButton<String>(
      value: currentLanguage,
      underline: const SizedBox(), // ไม่แสดงเส้นใต้
      dropdownColor: const Color.fromARGB(255, 255, 167, 161),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
      onChanged: (String? newLanguage) {
        if (newLanguage != null) {
          Provider.of<TableProvider>(context, listen: false)
              .setLanguage(newLanguage);
        }
      },
      items: <String>['EN', 'TH', 'CN', 'JA'].map<DropdownMenuItem<String>>(
        (String language) {
          return DropdownMenuItem<String>(
            value: language,
            child: Text(
              language,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        },
      ).toList(),
    );
  }

  void _showNewsPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "News",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: const [
                      ListTile(
                        title: Text("Test Announcement 1"),
                        subtitle: Text("Halo How R U ? jaja"),
                      ),
                      ListTile(
                        title: Text("Test Announcement 2"),
                        subtitle: Text("Halo How R U ? jaja"),
                      ),
                      ListTile(
                        title: Text("Test Announcement 3"),
                        subtitle: Text("Halo How R U ? jaja"),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showManagerPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Manager",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(), // LoginPage
                    ),
                    (route) => false,
                  );
                },
                child: Row(
                  children: const [
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Icon(Icons.logout, color: Colors.red, size: 18),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Center Buttons Section
  Widget _buildCenterButtons(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        "iconPath": 'assets/img/icontable.png',
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TableSelectionPage(),
            ),
          );
        },
      },
      {
        "iconPath": 'assets/img/iconmenu.png',
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddMenuPage(),
            ),
          );
        },
      },
      {
        "iconPath": 'assets/img/iconbill.png',
        "onTap": () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BillPage(),
            ),
          );
        },
      },
    ];

    return Row(
      children: items.map((item) {
        return GestureDetector(
          onTap: item["onTap"] as VoidCallback,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  item["iconPath"] as String,
                  width: 40,
                  height: 30,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Right Section
  Widget _buildRightSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(height: 3),
        // Logo Section
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'assets/img/logo_pink.png',
              height: 30,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Logo not found!',
                  style: TextStyle(color: Color.fromARGB(255, 110, 110, 110)),
                );
              },
            ),
            const SizedBox(width: 3),
            const Text(
              "PHOENIX POS",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 15,
              ),
            ),
          ],
        ),
        // Print Queue Section
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PrintQueuePage(),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Print Queue",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 184, 12, 0),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text(
                          "50",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Settings Icon
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.grey, size: 20),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
