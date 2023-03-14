// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../common/creta_utils.dart';
import '../../../model/app_enums.dart';
import 'shape_path.dart';

class CretaOutLinePainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final ShapeType shapeType;
  final BorderCapType borderCap;

  late Paint shadowPaint;

  CretaOutLinePainter({
    this.shapeType = ShapeType.none,
    this.strokeWidth = 0,
    this.strokeColor = Colors.transparent,
    this.borderCap = BorderCapType.round,
  });

  Paint getPaint(Size size) {
    return Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = CretaUtils.borderJoin(borderCap)
      ..strokeCap = CretaUtils.borderCap(borderCap)
      ..strokeWidth = strokeWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaOutLinePathPainter extends CretaOutLinePainter {
  CretaOutLinePathPainter({
    ShapeType shapeType = ShapeType.none,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
    BorderCapType borderCap = BorderCapType.round,
  }) : super(
            shapeType: shapeType,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            borderCap: borderCap);

  @override
  void paint(Canvas canvas, Size size) {
    Path path = ShapePath.getClip(shapeType, Size(size.width, size.height));

    canvas.drawPath(path, getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaOutLineOvalPainter extends CretaOutLinePainter {
  final Rect rect;

  CretaOutLineOvalPainter({
    required this.rect,
    ShapeType shapeType = ShapeType.none,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
    BorderCapType borderCap = BorderCapType.round,
  }) : super(
            shapeType: shapeType,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            borderCap: borderCap);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(rect, getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaOutLineRRectPainter extends CretaOutLinePainter {
  final double width;
  final double height;
  final double radiusLeftBottom;
  final double radiusLeftTop;
  final double radiusRightBottom;
  final double radiusRightTop;

  CretaOutLineRRectPainter({
    required this.width,
    required this.height,
    required this.radiusLeftBottom,
    required this.radiusLeftTop,
    required this.radiusRightBottom,
    required this.radiusRightTop,
    ShapeType shapeType = ShapeType.none,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
    BorderCapType borderCap = BorderCapType.round,
  }) : super(
            shapeType: shapeType,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            borderCap: borderCap);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(_getRRect(), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  RRect _getRRect({double addRadius = 0}) {
    double lt = radiusLeftTop + addRadius;
    double rt = radiusRightTop + addRadius;
    double rb = radiusRightBottom + addRadius;
    double lb = radiusLeftBottom + addRadius;
    if (lt == rt && rt == rb && rb == lb) {
      if (lt == 0) {
        return RRect.fromRectAndRadius(
          Rect.fromLTWH(
            0,
            0,
            width,
            height,
          ),
          Radius.zero,
        );
      }
      return RRect.fromRectAndRadius(
        Rect.fromLTWH(
          0,
          0,
          width,
          height,
        ),
        Radius.circular(radiusLeftTop),
      );
    }
    return RRect.fromRectAndCorners(
      Rect.fromLTWH(
        0,
        0,
        width,
        height,
      ),
      bottomLeft: Radius.circular(radiusLeftBottom),
      bottomRight: Radius.circular(radiusRightBottom),
      topLeft: Radius.circular(radiusLeftTop),
      topRight: Radius.circular(radiusRightTop),
    );
  }
}

class CretaOutLineCirclePainter extends CretaOutLinePainter {
  final double width;
  final double height;

  CretaOutLineCirclePainter({
    required this.width,
    required this.height,
    ShapeType shapeType = ShapeType.none,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
    BorderCapType borderCap = BorderCapType.round,
  }) : super(
            shapeType: shapeType,
            strokeWidth: strokeWidth,
            strokeColor: strokeColor,
            borderCap: borderCap);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRRect(_getRRect(), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  RRect _getRRect() {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        width,
        height,
      ),
      Radius.circular(360),
    );
  }
}
