import 'package:flutter/material.dart';
import '../appbar.dart'; // Import appbaraot

class PrintQueuePage extends StatelessWidget {
  const PrintQueuePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ตัวอย่างข้อมูล
    final List<Map<String, String>> printQueueData = [
      {"table": "Table 1", "time": "07-Dec-2024 03:17PM", "number": "#03905"},
      {"table": "Table 2", "time": "07-Dec-2024 03:10PM", "number": "#03902"},
      {"table": "Table 3", "time": "06-Dec-2024 11:13PM", "number": "#03904"},
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: const appbaraot(), // เรียก appbaraot เป็น AppBar
      ),
      body: Container(
        color: const Color(0xFFFFDCDC), // สีพื้นหลังของหน้าจอ
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
// Table with integrated Divider and increased height
              Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row for Date and Manager
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "09-Dec-2024 10:00AM",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black, // สีข้อความเป็นดำ
                          ),
                        ),
                        Text(
                          "#002 Manager",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black, // สีข้อความเป็นดำ
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12), // เพิ่มระยะห่างเล็กน้อย
                    // Divider inside the table
                    const Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ],
                ),
              ),

              // List of Print Queue
              Expanded(
                child: ListView.builder(
                  itemCount: printQueueData.length,
                  itemBuilder: (context, index) {
                    final item = printQueueData[index];
                    return GestureDetector(
                      onTap: () {
                        // แสดง Popup เมื่อกดที่ Table
                        _showReceiptPopup(context, item);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item["table"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  item["number"] ?? "",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item["time"] ?? "",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                                const Text(
                                  "#002 Manager",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Color.fromARGB(255, 83, 83, 83),
                              thickness: 1,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function สำหรับแสดง Popup
  void _showReceiptPopup(BuildContext context, Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 300, // ลดความกว้างของ Popup
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const Text(
                        "PRINT",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Logo
                  Image.asset(
                    'assets/img/logo_pink.png',
                    height: 64, // เพิ่มขนาดโลโก้
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "PHOENIX POS ผู้ช่วยร้านอาหาร",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Receipt",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Table Information
                  Text(
                    "${item["table"]} ${item["number"]}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item["time"] ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 12),

                  // Dummy Item List
                  const Text(
                    "1 Iced Espresso            35.00",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Vat 7%                       2.29",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text(
                    "Total                        37.29",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1, color: Colors.grey),
                  const SizedBox(height: 12),

                  const Text(
                    "Thank you",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                  const Text(
                    "Powered by PHOENIX POS",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black, // สีข้อความเป็นสีดำ
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
