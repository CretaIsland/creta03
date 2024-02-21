import 'dart:math';
import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import '../../../common/creta_utils.dart';
import 'package:creta_common/model/app_enums.dart';

class ShapePath {
  //static get math => null;

  static Path getClip(ShapeType shapeType, Size size,
      {Offset offset = Offset.zero, double delta = 1.0, double applyScale = 1.0}) {
    switch (shapeType) {
      case ShapeType.triangle:
        return ShapePath.triangle(size, offset: offset);
      case ShapeType.diamond:
        return ShapePath.diamond(size, offset: offset);
      case ShapeType.star:
        return ShapePath.star(size, offset: offset);
      case ShapeType.star4:
        return ShapePath.polyStar(size, 4, offset: offset);
      case ShapeType.star8:
        return ShapePath.polyStar(size, 8, offset: offset);
      case ShapeType.star16:
        return ShapePath.polyStar(size, 16, offset: offset);
      case ShapeType.sideCut:
        return ShapePath.sideCut(size, delta, offset: offset, applyScale: applyScale);
      case ShapeType.waveTopLeft:
        return ShapePath.waveTopLeft(size, size.height / 100, offset: offset);
      case ShapeType.waveTopRight:
        return ShapePath.waveTopRight(size, size.height / 100, offset: offset);
      case ShapeType.waveBottomLeft:
        return ShapePath.waveBottomLeft(size, size.height / 100, offset: offset);
      case ShapeType.waveBottomRight:
        return ShapePath.waveBottomRight(size, size.height / 100, offset: offset);
      case ShapeType.ovalTop:
        return ShapePath.ovalTop(size, size.height / 100, offset: offset);
      case ShapeType.ovalBottom:
        return ShapePath.ovalBottom(size, size.height / 100, offset: offset);
      case ShapeType.ovalLeft:
        return ShapePath.ovalLeft(size, size.height / 100, offset: offset);
      case ShapeType.ovalRight:
        return ShapePath.ovalRight(size, size.height / 100, offset: offset);
      case ShapeType.arrowUp:
        return ShapePath.arrowUp(size, offset: offset);
      case ShapeType.arrowDown:
        return ShapePath.arrowDown(size, offset: offset);
      case ShapeType.arrowLeft:
        return ShapePath.arrowLeft(size, offset: offset);
      case ShapeType.arrowRight:
        return ShapePath.arrowRight(size, offset: offset);
      case ShapeType.dirUp:
        return ShapePath.dirUp(size, offset: offset);
      case ShapeType.dirDown:
        return ShapePath.dirDown(size, offset: offset);
      case ShapeType.dirLeft:
        return ShapePath.dirLeft(size, offset: offset);
      case ShapeType.dirRight:
        return ShapePath.dirRight(size, offset: offset);
      case ShapeType.octagon:
        return ShapePath.octagon(size, offset: offset);
      case ShapeType.hexagon:
        return ShapePath.hexagon(size, offset: offset);
      case ShapeType.digonalBottomLeft:
        return ShapePath.digonalBottomLeft(size, size.height / 100, offset: offset);
      case ShapeType.digonalBottomRight:
        return ShapePath.digonalBottomRight(size, size.height / 100, offset: offset);
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

  static Path diamond(Size size, {Offset offset = Offset.zero}) {
    Path path = Path();
    double halfWidth = size.width / 2;
    double halfHeight = size.height / 2;
    // path.moveTo(halfWidth, 0);
    // path.lineTo(halfWidth + halfWidth / 2, halfHeight / 2);
    // path.lineTo(size.width, halfHeight);
    // path.lineTo(halfWidth + halfWidth / 2, halfHeight + halfHeight / 2);
    // path.lineTo(halfWidth, size.height);
    // path.lineTo(halfWidth / 2, halfHeight + halfHeight / 2);
    // path.lineTo(0, halfHeight);
    // path.lineTo(halfWidth / 2, halfHeight / 2);
    path.moveTo(offset.dx + halfWidth, offset.dy);
    path.lineTo(offset.dx + halfWidth + halfWidth / 2, offset.dy + halfHeight / 2);
    path.lineTo(offset.dx + size.width, offset.dy + halfHeight);
    path.lineTo(offset.dx + halfWidth + halfWidth / 2, offset.dy + halfHeight + halfHeight / 2);
    path.lineTo(offset.dx + halfWidth, offset.dy + size.height);
    path.lineTo(offset.dx + halfWidth / 2, offset.dy + halfHeight + halfHeight / 2);
    path.lineTo(offset.dx, offset.dy + halfHeight);
    path.lineTo(offset.dx + halfWidth / 2, offset.dy + halfHeight / 2);
    path.close();
    return path;
  }

  static Path triangle(Size size, {Offset offset = Offset.zero}) {
    return Path()
      // ..moveTo(0, size.height)
      // ..lineTo(size.width, size.height)
      // ..lineTo(size.width / 2, 0)
      // ..lineTo(0, size.height)
      ..moveTo(offset.dx, size.height + offset.dy)
      ..lineTo(offset.dx + size.width, size.height + offset.dy)
      ..lineTo(offset.dx + size.width / 2, offset.dy)
      ..lineTo(offset.dx, size.height + offset.dy)
      ..close();
  }

  static Path polyStar(Size size, int numberOfPoints, {Offset offset = Offset.zero}) {
    double width = size.width;
    double halfWidth = width / 2;
    double bigRadius = halfWidth;
    double radius = halfWidth / 2;
    double degreesPerStep = CretaCommonUtils.degreeToRadian(360 / numberOfPoints);
    double halfDegreesPerStep = degreesPerStep / 2;

    var path = Path();
    num max = 2 * pi;
    path.moveTo(width + offset.dx, halfWidth + offset.dy);

    for (double step = 0; step < max; step += degreesPerStep) {
      path.lineTo(
        halfWidth + bigRadius * cos(step) + offset.dx,
        halfWidth + bigRadius * sin(step) + offset.dy,
      );
      path.lineTo(
        halfWidth + radius * cos(step + halfDegreesPerStep) + offset.dx,
        halfWidth + radius * sin(step + halfDegreesPerStep) + offset.dy,
      );
    }

    path.close();
    return path;
  }

  static Path sideCut(Size size, double delta,
      {Offset offset = Offset.zero, double applyScale = 1.0}) {
    double xFactor = 18.0 * delta, yFactor = 15.0 * delta;
    double height = size.height;
    double startY = (height - height / 3) - yFactor;
    double xVal = size.width;
    double yVal = 0;
    final path = Path();

    if (offset != Offset.zero) {
      path.moveTo(offset.dx, offset.dy);
    }
    path.lineTo(xVal, yVal);

    yVal = startY + offset.dy;
    path.lineTo(xVal + offset.dx, yVal);

    double scale = 1.4 * applyScale;
    path.cubicTo(
      xVal + offset.dx,
      yVal,
      xVal + offset.dx,
      yVal + yFactor * scale,
      xVal - xFactor * scale + offset.dx,
      yVal + yFactor * scale,
    );
    xVal = xVal - xFactor * scale + offset.dx;
    yVal = yVal + yFactor * scale;

    double scale1 = 1 * applyScale;
    path.cubicTo(
      xVal,
      yVal,
      xVal - xFactor * scale1,
      yVal,
      xVal - scale1 * xFactor,
      yVal + yFactor * scale1,
    );
    xVal = xVal - scale1 * xFactor;
    yVal = yVal + scale1 * yFactor;
    double scale2 = 1.2 * applyScale;
    path.cubicTo(
      xVal,
      yVal,
      xVal,
      yVal + yFactor * scale2,
      xVal + xFactor * scale2,
      yVal + yFactor * scale2,
    );
    xVal = xVal + xFactor * scale2;
    yVal = yVal + yFactor * scale2;

    scale = 1.6 * applyScale;

    path.cubicTo(
      xVal,
      yVal,
      xVal + xFactor * scale,
      yVal,
      xVal + xFactor * scale,
      yVal + yFactor * scale,
    );
    xVal = xVal + xFactor * scale;
    yVal = yVal + yFactor * scale;

    path.lineTo(xVal, height + offset.dy);
    path.lineTo(offset.dx, height);
    path.close();
    return path;
  }

  static Path waveTopLeft(Size size, double delta, {Offset offset = Offset.zero}) {
    return waveClipper1(size, delta, true, true, offset);
  }

  static Path waveTopRight(Size size, double delta, {Offset offset = Offset.zero}) {
    return waveClipper1(size, delta, true, false, offset);
  }

  static Path waveBottomLeft(Size size, double delta, {Offset offset = Offset.zero}) {
    return waveClipper1(size, delta, false, true, offset);
  }

  static Path waveBottomRight(Size size, double delta, {Offset offset = Offset.zero}) {
    return waveClipper1(size, delta, false, false, offset);
  }

  static Path waveClipper1(Size size, double delta, bool reverse, bool flip, Offset offset) {
    if (!reverse && !flip) {
      Offset firstEndPoint = Offset(size.width * .5, size.height - 20 * delta) + offset;
      Offset firstControlPoint = Offset(size.width * .25, size.height - 30 * delta) + offset;
      Offset secondEndPoint = Offset(size.width, size.height - 30 * delta) + offset;
      Offset secondControlPoint = Offset(size.width * .75, size.height - 10 * delta) + offset;

      final path = Path()
        ..lineTo(0.0 + offset.dx, size.height + offset.dy)
        ..quadraticBezierTo(
            firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(
            secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width + offset.dx, 0.0 + offset.dy)
        ..close();
      return path;
    }
    if (!reverse && flip) {
      Offset firstEndPoint = Offset(size.width * .5, size.height - 20 * delta) + offset;
      Offset firstControlPoint = Offset(size.width * .25, size.height - 10 * delta) + offset;
      Offset secondEndPoint = Offset(size.width, size.height) + offset;
      Offset secondControlPoint = Offset(size.width * .75, size.height - 30 * delta) + offset;

      final path = Path()
        ..lineTo(0.0 + offset.dx, size.height - 30 * delta + offset.dy)
        ..quadraticBezierTo(
            firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(
            secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width + offset.dx, 0.0 + offset.dy)
        ..close();
      return path;
    }
    if (reverse && flip) {
      Offset firstEndPoint = Offset(size.width * .5, 20 * delta) + offset;
      Offset firstControlPoint = Offset(size.width * .25, 10 * delta) + offset;
      Offset secondEndPoint = Offset(size.width, 0) + offset;
      Offset secondControlPoint = Offset(size.width * .75, 30 * delta) + offset;

      final path = Path()
        ..moveTo(0 + offset.dx, 30 * delta + offset.dy)
        ..quadraticBezierTo(
            firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
        ..quadraticBezierTo(
            secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
        ..lineTo(size.width, size.height + offset.dy)
        ..lineTo(0.0 + offset.dx, size.height + offset.dy)
        ..close();
      return path;
    }

    Offset firstEndPoint = Offset(size.width * .5, 20 * delta) + offset;
    Offset firstControlPoint = Offset(size.width * .25, 30 * delta) + offset;
    Offset secondEndPoint = Offset(size.width, 30 * delta) + offset;
    Offset secondControlPoint = Offset(size.width * .75, 10 * delta) + offset;

    final path = Path()
      ..quadraticBezierTo(
          firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
      ..quadraticBezierTo(
          secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
      ..lineTo(size.width + offset.dx, size.height + offset.dy)
      ..lineTo(0.0 + offset.dx, size.height + offset.dy)
      ..close();
    return path;
  }

  static Path ovalTop(Size size, double delta, {Offset offset = Offset.zero}) {
    var path = Path();

    path.moveTo(0 + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, 30 * delta + offset.dy);
    path.quadraticBezierTo(
        size.width / 4 + offset.dx, 0 + offset.dy, size.width / 2 + offset.dx, 0 + offset.dy);
    path.quadraticBezierTo(size.width - size.width / 4 + offset.dx, 0 + offset.dy,
        size.width + offset.dx, 30 * delta + offset.dy);
    path.lineTo(size.width + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, size.height + offset.dy);
    return path;
  }

  static Path ovalBottom(Size size, double delta, {Offset offset = Offset.zero}) {
    var path = Path();
    path.lineTo(0 + offset.dx, 0 + offset.dy);
    path.lineTo(0 + offset.dx, size.height - 30 * delta + offset.dy);
    path.quadraticBezierTo(size.width / 4 + offset.dx, size.height + offset.dy,
        size.width / 2 + offset.dx, size.height + offset.dy);
    path.quadraticBezierTo(size.width - size.width / 4 + offset.dx, size.height + offset.dy,
        size.width + offset.dx, size.height - 30 * delta + offset.dy);
    path.lineTo(size.width + offset.dx, 0 + offset.dy);
    path.lineTo(0 + offset.dx, 0 + offset.dy);
    return path;
  }

  static Path ovalLeft(Size size, double delta, {Offset offset = Offset.zero}) {
    var path = Path();
    path.moveTo(size.width + offset.dx, 0 + offset.dy);
    path.lineTo(30 * delta + offset.dx, 0 + offset.dy);
    path.quadraticBezierTo(
        0 + offset.dx, size.height / 4 + offset.dy, 0 + offset.dx, size.height / 2 + offset.dy);
    path.quadraticBezierTo(0 + offset.dx, size.height - (size.height / 4) + offset.dy,
        30 * delta + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, 0 + offset.dy);
    return path;
  }

  static Path ovalRight(Size size, double delta, {Offset offset = Offset.zero}) {
    var path = Path();
    path.lineTo(0 + offset.dx, 0 + offset.dy);
    path.lineTo(size.width - 30 * delta + offset.dx, 0 + offset.dy);
    path.quadraticBezierTo(size.width + offset.dx, size.height / 4 + offset.dy,
        size.width + offset.dx, size.height / 2 + offset.dy);
    path.quadraticBezierTo(size.width + offset.dx, size.height - (size.height / 4) + offset.dy,
        size.width - 30 * delta + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, 0 + offset.dy);
    return path;
  }

  static Path arrowUp(Size size,
      {Offset offset = Offset.zero, double? triangleHeight, double? rectangleClipHeight}) {
    triangleHeight ??= size.height * 0.33;
    rectangleClipHeight ??= size.width * 0.6;
    var path = Path();
    path.moveTo(0.0 + offset.dx, triangleHeight + offset.dy);
    path.lineTo((size.width - rectangleClipHeight) / 2 + offset.dx, triangleHeight + offset.dy);
    path.lineTo((size.width - rectangleClipHeight) / 2 + offset.dx, size.height + offset.dy);
    path.lineTo((size.width + rectangleClipHeight) / 2 + offset.dx, size.height + offset.dy);
    path.lineTo((size.width + rectangleClipHeight) / 2 + offset.dx, triangleHeight + offset.dy);
    path.lineTo(size.width + offset.dx, triangleHeight + offset.dy);
    path.lineTo(size.width / 2 + offset.dx, 0 + offset.dy);
    path.close();

    // path.lineTo(rectangleClipHeight, triangleHeight);
    // path.lineTo(rectangleClipHeight, size.height);
    // path.lineTo(size.width - rectangleClipHeight, size.height);
    // path.lineTo(size.width - rectangleClipHeight, triangleHeight);
    // path.lineTo(size.width, triangleHeight);
    // path.lineTo(size.width / 2, 0.0);
    // path.close();
    return path;
  }

  static Path arrowRight(Size size,
      {Offset offset = Offset.zero, double? triangleHeight, double? rectangleClipHeight}) {
    triangleHeight ??= size.width * 0.33;
    rectangleClipHeight ??= size.height * 0.6;
    var path = Path();
    path.moveTo(size.width - triangleHeight + offset.dx, 0 + offset.dy);
    path.lineTo(size.width - triangleHeight + offset.dx,
        (size.height - rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(0 + offset.dx, (size.height - rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(0 + offset.dx, (size.height + rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(size.width - triangleHeight + offset.dx,
        (size.height + rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(size.width - triangleHeight + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, size.height / 2 + offset.dy);
    // path.moveTo(0.0, rectangleClipHeight);
    // path.lineTo(size.width - triangleHeight, rectangleClipHeight);
    // path.lineTo(size.width - triangleHeight, 0.0);
    // path.lineTo(size.width, size.height / 2);
    // path.lineTo(size.width - triangleHeight, size.height);
    // path.lineTo(size.width - triangleHeight, size.height - rectangleClipHeight);
    // path.lineTo(0.0, size.height - rectangleClipHeight);
    path.close();
    return path;
  }

  static Path arrowDown(Size size,
      {Offset offset = Offset.zero, double? triangleHeight, double? rectangleClipHeight}) {
    triangleHeight ??= size.height * 0.33;
    rectangleClipHeight ??= size.width * 0.6;
    var path = Path();
    path.moveTo(0.0 + offset.dx, size.height - triangleHeight + offset.dy);
    path.lineTo((size.width - rectangleClipHeight) / 2 + offset.dx,
        size.height - triangleHeight + offset.dy);
    path.lineTo((size.width - rectangleClipHeight) / 2 + offset.dx, 0 + offset.dy);
    path.lineTo((size.width + rectangleClipHeight) / 2 + offset.dx, 0 + offset.dy);
    path.lineTo((size.width + rectangleClipHeight) / 2 + offset.dx,
        size.height - triangleHeight + offset.dy);
    path.lineTo(size.width + offset.dx, size.height - triangleHeight + offset.dy);
    path.lineTo(size.width / 2 + offset.dx, size.height + offset.dy);
    path.close();
    return path;
  }

  static Path arrowLeft(Size size,
      {Offset offset = Offset.zero, double? triangleHeight, double? rectangleClipHeight}) {
    triangleHeight ??= size.width * 0.33;
    rectangleClipHeight ??= size.height * 0.6;
    var path = Path();
    path.moveTo(triangleHeight + offset.dx, 0 + offset.dy);
    path.lineTo(triangleHeight + offset.dx, (size.height - rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(size.width + offset.dx, (size.height - rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(size.width + offset.dx, (size.height + rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(triangleHeight + offset.dx, (size.height + rectangleClipHeight) / 2 + offset.dy);
    path.lineTo(triangleHeight + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, size.height / 2 + offset.dy);
    // path.moveTo(0.0, size.height / 2);
    // path.lineTo(triangleHeight, size.height);
    // path.lineTo(triangleHeight, size.height - rectangleClipHeight);
    // path.lineTo(size.width, size.height - rectangleClipHeight);
    // path.lineTo(size.width, rectangleClipHeight);
    // path.lineTo(triangleHeight, rectangleClipHeight);
    // path.lineTo(triangleHeight, 0.0);
    path.close();
    return path;
  }

  static Path dirUp(Size size, {Offset offset = Offset.zero, double? triangleHeight}) {
    triangleHeight ??= size.height * 0.33;

    var path = Path();
    path.moveTo(0.0 + offset.dx, triangleHeight + offset.dy);
    path.lineTo(0.0 + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, triangleHeight + offset.dy);
    path.lineTo(size.width / 2 + offset.dx, 0 + offset.dy);

    path.close();
    return path;
  }

  static Path dirRight(Size size, {Offset offset = Offset.zero, double? triangleHeight}) {
    triangleHeight ??= size.width * 0.33;
    var path = Path();
    path.moveTo(size.width - triangleHeight + offset.dx, 0 + offset.dy);
    path.lineTo(0 + offset.dx, 0 + offset.dy);
    path.lineTo(0 + offset.dx, size.height + offset.dy);
    path.lineTo(size.width - triangleHeight + offset.dx, size.height + offset.dy);
    path.lineTo(size.width + offset.dx, size.height / 2 + offset.dy);

    path.close();
    return path;
  }

  static Path dirDown(Size size, {Offset offset = Offset.zero, double? triangleHeight}) {
    triangleHeight ??= size.height * 0.33;
    var path = Path();
    path.moveTo(0.0 + offset.dx, size.height - triangleHeight + offset.dy);
    path.lineTo(0.0 + offset.dx, 0 + offset.dy);
    path.lineTo(size.width + offset.dx, 0 + offset.dy);
    path.lineTo(size.width + offset.dx, size.height - triangleHeight + offset.dy);
    path.lineTo(size.width / 2 + offset.dx, size.height + offset.dy);
    path.close();
    return path;
  }

  static Path dirLeft(Size size, {Offset offset = Offset.zero, double? triangleHeight}) {
    triangleHeight ??= size.width * 0.33;
    var path = Path();
    path.moveTo(triangleHeight + offset.dx, 0 + offset.dy);
    path.lineTo(size.width + offset.dx, 0 + offset.dy);
    path.lineTo(size.width + offset.dx, size.height + offset.dy);
    path.lineTo(triangleHeight + offset.dx, size.height + offset.dy);
    path.lineTo(0 + offset.dx, size.height / 2 + offset.dy);
    path.close();
    return path;
  }

  static Path octagon(Size size, {Offset offset = Offset.zero}) {
    var x1 = size.width / (2 + sqrt(2));
    var x2 = x1 + size.width / (1 + sqrt(2));
    var y1 = size.height / (2 + sqrt(2));
    var y2 = y1 + size.height / (1 + sqrt(2));

    final path = Path()
      ..moveTo(x1 + offset.dx, 0 + offset.dy)
      ..lineTo(x2 + offset.dx, 0 + offset.dy)
      ..lineTo(size.width + offset.dx, y1 + offset.dy)
      ..lineTo(size.width + offset.dx, y2 + offset.dy)
      ..lineTo(x2 + offset.dx, size.height + offset.dy)
      ..lineTo(x1 + offset.dx, size.height + offset.dy)
      ..lineTo(0 + offset.dx, y2 + offset.dy)
      ..lineTo(0 + offset.dx, y1 + offset.dy)
      ..close();
    return path;
  }

  static Path hexagon(Size size, {Offset offset = Offset.zero}) {
    var x1 = size.width / 2;
    //var x2 = x1 + size.width / (1 + sqrt(2));
    var y1 = size.height / (2 + sqrt(2));
    var y2 = y1 + size.height / (1 + sqrt(2));

    final path = Path()
      ..moveTo(x1 + offset.dx, 0 + offset.dy)
      ..lineTo(size.width + offset.dx, y1 + offset.dy)
      ..lineTo(size.width + offset.dx, y2 + offset.dy)
      ..lineTo(x1 + offset.dx, size.height + offset.dy)
      ..lineTo(0 + offset.dx, y2 + offset.dy)
      ..lineTo(0 + offset.dx, y1 + offset.dy)
      ..close();
    return path;
  }

  static Path digonalBottomLeft(Size size, double delta, {Offset offset = Offset.zero}) {
    final path = Path()
      ..lineTo(0.0 + offset.dx, size.height - 25 * delta + offset.dy)
      ..lineTo(size.width + offset.dx, size.height + offset.dy)
      ..lineTo(size.width + offset.dx, 0.0 + offset.dy)
      ..close();
    return path;
  }

  static Path digonalBottomRight(Size size, double delta, {Offset offset = Offset.zero}) {
    final path = Path()
      ..lineTo(0.0 + offset.dx, size.height + offset.dy)
      ..lineTo(size.width + offset.dx, size.height - 25 * delta + offset.dy)
      ..lineTo(size.width + offset.dx, 0.0 + offset.dy)
      ..close();
    return path;
  }
}
