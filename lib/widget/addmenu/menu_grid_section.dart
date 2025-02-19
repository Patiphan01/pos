// lib/widgets/menu_grid.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../fucntion/tableprovider.dart';
import '../../fucntion/subprovider/option_question.dart';

import '../../fucntion/subprovider/menu_item.dart';
import '../../fucntion/subprovider/option_choice.dart';


class MenuGrid extends StatelessWidget {
  final String selectedZone;
  final int selectedTableIndex;

  const MenuGrid({
    Key? key,
    required this.selectedZone,
    required this.selectedTableIndex,
  }) : super(key: key);

  // Helper method: ดึงข้อความของคำถามตามภาษาที่เลือก
  // หากฟิลด์ของภาษาที่เลือกว่าง จะ fallback ไปใช้ภาษาอังกฤษ (EN)
  String getLocalizedQuestion(OptionQuestion question) {
    final lang = TableProvider.language ?? "EN";
    if (lang == 'TH') {
      return question.question_th.isNotEmpty ? question.question_th : question.question;
    } else if (lang == 'CN') {
      return question.question_cn.isNotEmpty ? question.question_cn : question.question;
    } else if (lang == 'JA') {
      return (question.question_ja != null && question.question_ja!.isNotEmpty)
          ? question.question_ja!
          : question.question;
    } else {
      return question.question;
    }
  }

  // Helper method: ดึงข้อความของตัวเลือกตามภาษาที่เลือก
  // หากฟิลด์ของภาษาที่เลือกว่าง จะ fallback ไปใช้ภาษาอังกฤษ (EN)
  String getLocalizedChoice(OptionChoice choice) {
    final lang = TableProvider.language ?? "EN";
    if (lang == 'TH') {
      return choice.choice_th.isNotEmpty ? choice.choice_th : choice.choice;
    } else if (lang == 'CN') {
      return choice.choice_cn.isNotEmpty ? choice.choice_cn : choice.choice;
    } else if (lang == 'JA') {
      return (choice.choice_ja != null && choice.choice_ja!.isNotEmpty)
          ? choice.choice_ja!
          : choice.choice;
    } else {
      return choice.choice;
    }
  }

  /// ฟังก์ชันแสดง modal สำหรับให้ผู้ใช้เลือก option
  void _showOptionModal(BuildContext context, MenuItem menuItem) {
    final tableProvider = Provider.of<TableProvider>(context, listen: false);
    // ดึง option questions จาก group option list โดยใช้ item_group_options เป็น key
    final List<OptionQuestion>? questions =
        tableProvider.getOptionQuestionsById(menuItem.itemGroupOptions);

    
    Map<int, dynamic> selections = {};
    if (questions != null) {
      for (int i = 0; i < questions.length; i++) {
        OptionQuestion question = questions[i];
        if (question.mode == 'SIN') {
       
          if (question.items.isNotEmpty &&
              question.defaultChoice < question.items.length) {
            selections[i] = question.items[question.defaultChoice].id;
          } else {
            selections[i] = null;
          }
        } else if (question.mode == 'MUL') {
          selections[i] = <String>{};
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('เลือก Option สำหรับ ${menuItem.name}'),
            content: questions != null && questions.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(questions.length, (index) {
                        OptionQuestion question = questions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // แสดงข้อความคำถามตามภาษาที่เลือก โดย fallback ไปใช้ EN หากฟิลด์ว่าง
                              Text(
                                getLocalizedQuestion(question),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (question.mode == 'SIN')
                                Column(
                                  children: question.items.map((choice) {
                                    return RadioListTile<String>(
                                      title: Text(getLocalizedChoice(choice)),
                                      value: choice.id,
                                      groupValue: selections[index],
                                      onChanged: (value) {
                                        setState(() {
                                          selections[index] = value;
                                        });
                                      },
                                    );
                                  }).toList(),
                                )
                              else if (question.mode == 'MUL')
                                Column(
                                  children: question.items.map((choice) {
                                    bool checked =
                                        (selections[index] as Set<String>)
                                            .contains(choice.id);
                                    return CheckboxListTile(
                                      title: Text(getLocalizedChoice(choice)),
                                      value: checked,
                                      onChanged: (value) {
                                        setState(() {
                                          if (value == true) {
                                            (selections[index] as Set<String>)
                                                .add(choice.id);
                                          } else {
                                            (selections[index] as Set<String>)
                                                .remove(choice.id);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                )
                              else
                                const Text('Mode ไม่รองรับ'),
                            ],
                          ),
                        );
                      }),
                    ),
                  )
                : Text(
                    'ไม่พบข้อมูล Option สำหรับ item_group_options: ${menuItem.itemGroupOptions}',
                  ),
            actions: [
              TextButton(
                onPressed: () {
                  // แปลง selections เป็น Map ที่มี question text (ตามภาษาที่เลือก) เป็น key
                  Map<String, dynamic> selectedOptions = {};
                  if (questions != null) {
                    for (int i = 0; i < questions.length; i++) {
                      OptionQuestion question = questions[i];
                      if (question.mode == 'SIN') {
                        String? selectedId = selections[i];
                        OptionChoice? choice;
                        try {
                          choice =
                              question.items.firstWhere((c) => c.id == selectedId);
                        } catch (e) {
                          choice = null;
                        }
                        selectedOptions[getLocalizedQuestion(question)] =
                            choice != null ? getLocalizedChoice(choice) : null;
                      } else if (question.mode == 'MUL') {
                        Set<String> selectedIds = selections[i];
                        List<String> selectedChoices = [];
                        for (String cid in selectedIds) {
                          OptionChoice? choice;
                          try {
                            choice =
                                question.items.firstWhere((c) => c.id == cid);
                          } catch (e) {
                            choice = null;
                          }
                          if (choice != null) {
                            selectedChoices.add(getLocalizedChoice(choice));
                          }
                        }
                        selectedOptions[getLocalizedQuestion(question)] = selectedChoices;
                      }
                    }
                  }
                  debugPrint('Selected Options: $selectedOptions');
                  // ส่งข้อมูลที่เลือกไปเพิ่มในตาราง (รวม options)
                  tableProvider.selectTable(selectedZone, selectedTableIndex);
                  tableProvider.addMenuItemToTable(
                    menuItem.name,
                    menuItem.price,
                    imageUrl: menuItem.imageUrl,
                    options: selectedOptions,
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('ตกลง'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('ปิด'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TableProvider>(
      builder: (context, tableProvider, child) {
        final menuItems = tableProvider.menuItemsBySelectedSubcategory;

        if (menuItems.isEmpty) {
          debugPrint('Menu items are empty');
          return const Center(child: CircularProgressIndicator());
        }

        debugPrint('Displaying ${menuItems.length} menu items');
        for (var menuItem in menuItems) {
          debugPrint(
              'Menu Item: ${menuItem.name}, Price: ${menuItem.price}, ImageURL: ${menuItem.imageUrl}');
        }

        return Container(
          width: 790,
          height: 600,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFDBDB),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: RawScrollbar(
            thumbColor: Colors.red,
            trackColor: Colors.white,
            trackBorderColor: const Color.fromARGB(255, 219, 0, 0),
            radius: const Radius.circular(10),
            thickness: 8,
            thumbVisibility: true,
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final MenuItem item = menuItems[index];

                debugPrint(
                    'Building Menu Item: ${item.name}, Price: ${item.price}, ImageURL: ${item.imageUrl}');

                return GestureDetector(
                  onTap: () {
                    if (item.itemGroupOptions != null &&
                        item.itemGroupOptions!.isNotEmpty) {
                      _showOptionModal(context, item);
                    } else {
                      if (selectedZone.isNotEmpty) {
                        tableProvider.selectTable(selectedZone, selectedTableIndex);
                        tableProvider.addMenuItemToTable(
                          item.name,
                          item.price,
                          quantity: 1,
                          imageUrl: item.imageUrl,
                        );
                      }
                    }
                  },
                  child: _menuItem(
                    item.name,
                    '${item.price.toStringAsFixed(2)}.-',
                    item.imageUrl,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _menuItem(String name, String price, String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF6E6E),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ส่วนของรูปภาพหรือไอคอน
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFF6E6E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        imageUrl,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 30,
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.fastfood,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
