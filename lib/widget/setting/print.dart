import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PrinterSettingPage extends StatelessWidget {
  const PrinterSettingPage({Key? key}) : super(key: key);

  void _closePage(BuildContext context) {
    Navigator.pop(context);
  }

  void _onFindPrinter() {
    // TODO: Implement logic to find the printer
    debugPrint("Finding the printer...");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The background color or design as needed
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header row with page title & close button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.red[300],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Printer Settings",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _closePage(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main content
            Expanded(
              child: Container(
                color: Colors.red[50], // Light red background
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Connection info card
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // “Connection” section title + find button
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Connection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: _onFindPrinter,
                                  icon: const Icon(
                                    FontAwesomeIcons.search,
                                    size: 14,
                                  ),
                                  label: const Text(
                                    "Find the printer",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Printer info rows
                            _buildInfoRow("Type :", "Usb"),
                            _buildInfoRow("Identifier :", "2610223111300002"),
                            _buildInfoRow("Model :", ""),
                            _buildInfoRow("S/N :", ""),
                            _buildInfoRow("IP :", ""),
                            _buildInfoRow("Name :", ""),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Instruction / Additional content
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Please choose the printer connection",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    // Optional: more controls below
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
