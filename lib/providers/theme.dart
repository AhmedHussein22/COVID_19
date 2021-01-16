import 'package:flutter/material.dart';

class DarkMode extends ChangeNotifier {
  bool isdark = false;
  dodarkmode(val) {
    isdark = val;
    notifyListeners();
  }
}
