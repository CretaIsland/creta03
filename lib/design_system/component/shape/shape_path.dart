import 'dart:math';
import 'package:flutter/material.dart';

import '../../../model/app_enums.dart';

class ShapePath {
  static Path getClip(ShapeType shapeType, Size size, {Offset offset = Offset.zero}) {
    switch (shapeType) {
      case ShapeType.triangle:
        return ShapePath.triangle(size);
      case ShapeType.diamond:
        return ShapePath.diamond(size);
      case ShapeType.star:
        return ShapePath.star(size, offset: offset);
      default:
        return Path();
    }
  }

  static Path star(Size size, {Offset offset = Offset.zero}) {
    Path path = Path();
    double halfWidth = size.width / 2;
    double bigRadius = halfWidth;
    double smallRadius = bigRadius * sin(pi / 10) / sin(7 * pi / 10);
    double outerRadius = bigRadius * cos(pi / 10);
    double innerRadius = smallRadius * sin(3 * pi / 10) / sin(7 * pi / 10);

    Offset center = Offset(halfWidth, halfWidth) + offset;

    for (int i = 0; i < 5; i++) {
      double angle = 2 * pi / 5 * i - pi / 2;
      Offset outer = Offset(
        center.dx + outerRadius * cos(angle),
        center.dy + outerRadius * sin(angle),
      );
      Offset inner = Offset(
        center.dx + innerRadius * cos(angle + pi / 5),
        center.dy + innerRadius * sin(angle + pi / 5),
      );
      if (i == 0) {
        path.moveTo(outer.dx, outer.dy);
      } else {
        path.lineTo(outer.dx, outer.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    return path;
  }

  static Path diamond(Size size) {
    Path path = Path();
    double halfWidth = size.width / 2;
    double halfHeight = size.height / 2;
    path.moveTo(halfWidth, 0);
    path.lineTo(halfWidth + halfWidth / 2, halfHeight / 2);
    path.lineTo(size.width, halfHeight);
    path.lineTo(halfWidth + halfWidth / 2, halfHeight + halfHeight / 2);
    path.lineTo(halfWidth, size.height);
    path.lineTo(halfWidth / 2, halfHeight + halfHeight / 2);
    path.lineTo(0, halfHeight);
    path.lineTo(halfWidth / 2, halfHeight / 2);
    path.close();
    return path;
  }

  static Path triangle(Size size) {
    return Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..close();
  }
}
