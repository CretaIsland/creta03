// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

enum ContaineeEnum {
  None,
  Book,
  Page,
  Frame,
  Contents,
  Link,
  End;

  static int validCheck(int val) => (val > End.index || val < None.index) ? None.index : val;
  static ContaineeEnum fromInt(int? val) => ContaineeEnum.values[validCheck(val ?? None.index)];
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

  bool isBook() {
    return _selectedClass == ContaineeEnum.Book;
  }

  bool isPage() {
    return _selectedClass == ContaineeEnum.Page;
  }

  bool isFrame() {
    return _selectedClass == ContaineeEnum.Frame;
  }

  bool isNone() {
    return _selectedClass == ContaineeEnum.None;
  }

  void set(ContaineeEnum val, {bool doNoti = true}) {
    _selectedClass = val;
    //print('ContaineeNotifier.set($val)------------------------');
    // if (_selectedClass == ContaineeEnum.Frame) {
    //   MiniMenu.showFrame = true;
    // } else if (_selectedClass == ContaineeEnum.Contents) {
    //   MiniMenu.showFrame = false;
    // }
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

  void show() {
    _isShow = true;
  }

  void unshow() {
    _isShow = false;
  }

  void notify() => notifyListeners();
}

// class MiniMenuContentsNotifier extends ChangeNotifier {
//   bool isShow = true;
//   void notify() => notifyListeners();
// }
