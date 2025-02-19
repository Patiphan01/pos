import 'package:flutter/material.dart';
import '../widget/appbar.dart';
import '../widget/bill/closeshift.dart';
import 'cashier.dart'; // Import หน้าของ Cashier

class BillPage extends StatefulWidget {
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  // Mock data for bills
  final List<Map<String, dynamic>> _bills = List.generate(10, (index) {
    return {
      'zone': 'Zone A A${index + 1}',
      'date': '20 December 2022',
      'time': '11:54 a.m.',
      'amount': '500',
      'status': 0, // 0: grey, 1: yellow, 2: blue
    };
  });

  // Function to handle card tap and change status
  void _onCardTap(int index) {
    setState(() {
      if (_bills[index]['status'] == 2) {
        // หากเป็นสีฟ้าแล้วกดอีกครั้ง จะไปที่หน้า Cashier
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Cashier(),
          ),
        );
      } else {
        // เปลี่ยนสถานะของการ์ด
        _bills[index]['status'] = (_bills[index]['status'] + 1) % 3;
      }
    });
  }

  // Function to show "Close Shift" popup
  void _showCloseShiftPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CloseShiftPopup();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const appbaraot(),
      backgroundColor: const Color(0xFFFFDCDC),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Open Draw and Close Shift Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle Open Draw action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6E6E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  child: const Text(
                    'Open Draw',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _showCloseShiftPopup, // เรียก Popup
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6E6E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                  ),
                  child: const Text(
                    'Close Shift',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of Bills
            Expanded(
              child: ListView.builder(
                itemCount: _bills.length,
                itemBuilder: (context, index) {
                  final bill = _bills[index];
                  Color cardColor;
                  switch (bill['status']) {
                    case 1:
                      cardColor = const Color(0xFFFFD058);
                      break;
                    case 2:
                      cardColor = const Color(0xFF86E9EF);
                      break;
                    default:
                      cardColor = const Color(0xFFBFBFBF);
                  }
                  return GestureDetector(
                    onTap: () => _onCardTap(index),
                    child: Container(
                      width: double.infinity,
                      height: 104,
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        children: [
                          // Zone - ชิดซ้ายสุด
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                bill['zone'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          // Date and Time - อยู่ตรงกลาง
                          Expanded(
                            flex: 2,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${bill['date']}\n${bill['time']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                          // Amount - ชิดขวาสุด
                          Expanded(
                            flex: 1,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                bill['amount'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
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
    );
  }
}
