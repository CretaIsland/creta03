// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class FontSizeChangingNotifier extends ChangeNotifier {
  bool _isChanging = false;
  bool get isChanging => _isChanging;

  void start({bool doNotify = false}) {
    //print('start----------------------------');
    _isChanging = true;
    if (doNotify) {
      notify();
    }
  }

  void stop() {
    //print('stop----------------------------');
    _isChanging = false;
    notify();
  }

  void notify() => notifyListeners();
}
