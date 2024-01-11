import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

class KeyHandler {
  final Map<String, GlobalObjectKey<State<StatefulWidget>>> _widgetMap = {};

  GlobalObjectKey<State<StatefulWidget>> keyGen(String keyString) {
    GlobalObjectKey<State<StatefulWidget>>? retval = _widgetMap[keyString];
    if (retval != null) {
      return retval;
    }
    retval = GlobalObjectKey<State<StatefulWidget>>(keyString);
    _widgetMap[keyString] = retval;
    return retval;
  }

  GlobalObjectKey<State<StatefulWidget>>? findKey(String keyString) {
    //String keyString = keyMangler(model);
    return _widgetMap[keyString];
  }

  State<StatefulWidget>? getStateObject(String keyString) {
    GlobalObjectKey<State<StatefulWidget>>? key = findKey(keyString);
    if (key != null) {
      return key.currentState;
    }
    logger.severe('key not found $keyString');
    return null;
  }
}
