import 'package:flutter/material.dart';

class StaffProvider extends ChangeNotifier {
  String? _id;
  String? _name;

  String? get id => _id;
  String? get name => _name;

  void setStaff(String id, String name) {
    _id = id;
    _name = name;
    notifyListeners(); // แจ้ง UI ให้รีเฟรชข้อมูล
  }

  void clearStaff() {
    _id = null;
    _name = null;
    notifyListeners();
  }
}
