// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ContaineeEnum {
  None,
  Book,
  Page,
  Frame,
  Contents,
}

class ContaineeNotifier extends ChangeNotifier {
  ContaineeEnum _selectedClass = ContaineeEnum.None;
  ContaineeEnum get selectedClass => _selectedClass;

  ContaineeNotifier();

  void set(ContaineeEnum val, {bool doNoti = true}) {
    _selectedClass = val;
    if (doNoti) {
      notify();
    }
  }

  void clear() {
    _selectedClass = ContaineeEnum.None;
  }

  void notify() => notifyListeners();
}
