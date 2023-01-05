import 'package:flutter/material.dart';

enum ShadowDirection {
  rightBottum,
  leftTop,
  rightTop,
  leftBottom,
}

class StudioSnippet {
  static List<BoxShadow> basicShadow(
      {ShadowDirection direction = ShadowDirection.rightBottum,
      double offset = 4,
      Color color = Colors.grey,
      double opacity = 0.2}) {
    Offset value = Offset.zero;

    switch (direction) {
      case ShadowDirection.rightBottum:
        value = Offset(offset, offset);
        break;
      case ShadowDirection.leftTop:
        value = Offset(-offset, -offset);
        break;
      case ShadowDirection.rightTop:
        value = Offset(-offset, offset);
        break;
      case ShadowDirection.leftBottom:
        value = Offset(offset, -offset);
        break;
    }

    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: value,
      )
    ];
  }
}
