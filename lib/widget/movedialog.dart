// lib/page/move_dialog.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../fucntion/tableprovider.dart';

class MoveTableDialog extends StatefulWidget {
  const MoveTableDialog({Key? key}) : super(key: key);

  @override
  _MoveTableDialogState createState() => _MoveTableDialogState();
}

class _MoveTableDialogState extends State<MoveTableDialog> {
  String? targetZone;
  int? targetTableIndex;
  int guestsToMove = 0;

  @override
  Widget build(BuildContext context) {
    final tableProvider = Provider.of<TableProvider>(context);


    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      title: const Text(
        'Select Target Table',
        textAlign: TextAlign.left,
      ),
      content: SingleChildScrollView(
        child: Container(
          // ใช้ Container กำหนดความกว้าง responsive โดยอ้างอิงจากหน้าจอ
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.4,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ส่วนเลือกโต๊ะเป้าหมาย
              ...tableProvider.zones.entries.map((entry) {
                final zoneName = entry.key;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ชื่อโซน (ชิดซ้าย)
                      Text(
                        zoneName,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // รายการโต๊ะในโซน (ใช้ Wrap รองรับหลายโต๊ะ)
                      Wrap(
                        alignment: WrapAlignment.start,
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(entry.value.length, (index) {
                          final table = entry.value[index];
                          final bool isSelected = (targetZone == zoneName &&
                              targetTableIndex == index);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                targetZone = zoneName;
                                targetTableIndex = index;
                              });
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blueAccent
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Text(
                                'T${table.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              // เลือกจำนวนแขกที่จะย้าย (ชิดซ้าย)
            
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (targetZone != null && targetTableIndex != null) {
              Navigator.of(context).pop({
                'targetZone': targetZone!,
                'targetTableIndex': targetTableIndex!,
                'guestsToMove': guestsToMove,
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please select a target table')),
              );
            }
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
