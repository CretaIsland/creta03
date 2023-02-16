import 'package:flutter/material.dart';

import '../../model/app_enums.dart';

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

  static fullShadow({double offset = 4, Color color = Colors.grey, double opacity = 0.2}) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(offset, offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(-offset, -offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(offset, -offset),
      ),
      BoxShadow(
        color: color.withOpacity(opacity),
        spreadRadius: offset / 2,
        blurRadius: offset / 2,
        offset: Offset(-offset, offset),
      )
    ];
  }

  static Widget rotateWidget({required Widget child, int turns = 2}) {
    return RotatedBox(quarterTurns: turns, child: child);
  }

  static Gradient? gradient(GradationType currentType, Color color1, Color color2) {
    if (currentType == GradationType.none) {
      return null;
    }
    if (currentType == GradationType.in2out) {
      return RadialGradient(colors: [color1, color2]);
    }
    if (currentType == GradationType.out2in) {
      return RadialGradient(colors: [color2, color1]);
    }
    return LinearGradient(
        begin: beginAlignment(currentType),
        end: endAlignment(currentType),
        colors: [color1, color2]);
  }

  static Alignment beginAlignment(GradationType currentType) {
    switch (currentType) {
      case GradationType.top2bottom:
        return Alignment.topCenter;
      case GradationType.bottom2top:
        return Alignment.bottomCenter;
      case GradationType.left2right:
        return Alignment.centerLeft;
      case GradationType.right2left:
        return Alignment.centerRight;
      case GradationType.leftTop2rightBottom:
        return Alignment.topLeft;
      case GradationType.leftBottom2rightTop:
        return Alignment.bottomLeft;
      case GradationType.rightBottom2leftTop:
        return Alignment.bottomRight;
      case GradationType.rightTop2leftBottom:
        return Alignment.topRight;
      default:
        return Alignment.topLeft;
    }
  }

  static Alignment endAlignment(GradationType currentType) {
    switch (currentType) {
      case GradationType.top2bottom:
        return Alignment.bottomCenter;
      case GradationType.bottom2top:
        return Alignment.topCenter;
      case GradationType.left2right:
        return Alignment.centerRight;
      case GradationType.right2left:
        return Alignment.centerLeft;
      case GradationType.leftTop2rightBottom:
        return Alignment.bottomRight;
      case GradationType.leftBottom2rightTop:
        return Alignment.topRight;
      case GradationType.rightBottom2leftTop:
        return Alignment.topLeft;
      case GradationType.rightTop2leftBottom:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomRight;
    }
  }
}
