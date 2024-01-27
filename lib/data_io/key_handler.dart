import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

abstract class CretaState<T extends StatefulWidget> extends State<T> {
  void invalidate() {
    setState(() {});
  }

  bool doSomething(dynamic param) {
    return true;
  }
}

class KeyHandler {
  final Map<String, GlobalObjectKey<CretaState<StatefulWidget>>> _widgetMap = {};

  GlobalObjectKey<CretaState<StatefulWidget>> registerKey(String keyString) {
    GlobalObjectKey<CretaState<StatefulWidget>>? retval = _widgetMap[keyString];
    if (retval != null) {
      return retval;
    }
    retval = GlobalObjectKey<CretaState<StatefulWidget>>(keyString);
    _widgetMap[keyString] = retval;
    return retval;
  }

  GlobalObjectKey<CretaState<StatefulWidget>>? findKey(String keyString) {
    //String keyString = keyMangler(model);
    return _widgetMap[keyString];
  }

  GlobalObjectKey<CretaState<StatefulWidget>>? getFirstKey() {
    //String keyString = keyMangler(model);
    return _widgetMap.values.first;
  }

  CretaState<StatefulWidget>? getStateObject(String keyString) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = findKey(keyString);
    if (key != null) {
      return key.currentState;
    }
    logger.severe('key not found $keyString');
    return null;
  }

  Rect? getArea(String keyString) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = findKey(keyString);
    if (key != null) {
      RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.warning('box not is founeded');
        return null;
      }
      Offset position = box.localToGlobal(Offset.zero);
      return position & box.size;
    }
    return null;
  }

  Rect? getFirstArea() {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = getFirstKey();
    if (key != null) {
      RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null) {
        logger.warning('box not is founeded');
        return null;
      }
      Offset position = box.localToGlobal(Offset.zero);
      return position & box.size;
    }
    return null;
  }

  RenderBox? getRenderBox(String keyString) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = getFirstKey();
    if (key == null) {
      return null;
    }
    return key.currentContext?.findRenderObject() as RenderBox?;
  }

  bool isMousePointerOnWidget(String keyString, Offset pointerPosition) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = findKey(keyString);
    if (key == null) {
      return false;
    }
    final RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    final Offset widgetOffset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    return pointerPosition.dx >= widgetOffset.dx &&
        pointerPosition.dx < widgetOffset.dx + size.width &&
        pointerPosition.dy >= widgetOffset.dy &&
        pointerPosition.dy < widgetOffset.dy + size.height;
  }

  bool invalidate(String keyString) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = findKey(keyString);
    if (key != null) {
      if (key.currentState != null) {
        key.currentState!.invalidate();
        return true;
      }
    } else {
      logger.severe('missing keyString $keyString');
    }
    logger.severe('invalidate failed $keyString');
    return false;
  }

   bool doSomething(String keyString, dynamic params) {
    GlobalObjectKey<CretaState<StatefulWidget>>? key = findKey(keyString);
    if (key != null) {
      if (key.currentState != null) {
        key.currentState!.doSomething(params);
        return true;
      }
    } else {
      logger.severe('missing keyString $keyString');
    }
    logger.severe('invalidate failed $keyString');
    return false;
  }
}
