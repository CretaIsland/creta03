// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../../studio_variables.dart';

class TopMenuNotifier extends ChangeNotifier {
  ClickToCreateEnum _clickToCreateMode = ClickToCreateEnum.normal;
  ClickToCreateEnum get clickToCreateMode => _clickToCreateMode;
  bool _requestFocus = false;
  bool get requestFocus => _requestFocus;
  void releaseFocus() {
    _requestFocus = false;
  }

  void set(ClickToCreateEnum value, {bool doNotify = false}) {
    //print('start----------------------------');
    _clickToCreateMode = value;

    if (isTextCreate()) {
      _requestFocus = true;
    } else {
      _requestFocus = false;
    }

    if (doNotify) {
      notify();
    }
  }

  bool isTextCreate() {
    return _clickToCreateMode == ClickToCreateEnum.textCreate;
  }

  bool isFrameCreate() {
    return _clickToCreateMode == ClickToCreateEnum.frameCreate;
  }

  bool isNormalCreate() {
    return _clickToCreateMode == ClickToCreateEnum.normal;
  }

  void clear() {
    _clickToCreateMode = ClickToCreateEnum.normal;
    notify();
  }

  void notify() => notifyListeners();
}
