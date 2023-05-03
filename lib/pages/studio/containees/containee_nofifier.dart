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

  bool _isOpenSize = false;
  bool get isOpenSize => _isOpenSize;
  void setOpenSize(bool val) {
    _isOpenSize = val;
  }

  bool _isFrameClick = false;
  bool get isFrameClick => _isFrameClick;
  bool setFrameClick(bool val) {
    bool retval = _isFrameClick;
    _isFrameClick = val;
    return retval;
  }

  ContaineeNotifier();

  void set(ContaineeEnum val, {bool doNoti = true}) {
    _selectedClass = val;
    if (doNoti) {
      notify();
    }
  }

  void openSize({bool doNoti = true}) {
    _isOpenSize = true;
    if (doNoti) {
      notify();
    }
  }

  void clear() {
    _selectedClass = ContaineeEnum.None;
  }

  void notify() => notifyListeners();
}

class MiniMenuNotifier extends ChangeNotifier {
  bool _isShow = true;
  bool get isShow => _isShow;
  void set(bool val, {bool doNoti = true}) {
    _isShow = val;
    if (doNoti) {
      notify();
    }
  }

  void notify() => notifyListeners();
}

// class MiniMenuContentsNotifier extends ChangeNotifier {
//   bool isShow = true;
//   void notify() => notifyListeners();
// }
