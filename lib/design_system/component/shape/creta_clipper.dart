// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../model/app_enums.dart';
import 'shape_path.dart';

extension ShapeWidget<T extends Widget> on T {
  Widget asShape({
    required String mid,
    required ShapeType shapeType,
    required double width,
    required double height,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _getBaseWidget(
          mid: mid,
          shapeType: shapeType,
          width: width,
          height: height,
        ),
        strokeWidth > 0
            ? _getOutlineWidget(
                shapeType: shapeType,
                strokeWidth: strokeWidth,
                strokeColor: strokeColor,
                width: width,
                height: height,
                radiusLeftBottom: radiusLeftBottom,
                radiusLeftTop: radiusLeftTop,
                radiusRightBottom: radiusRightBottom,
                radiusRightTop: radiusRightTop,
              )
            // ? CustomPaint(
            //     size: Size(width, height),
            //     painter: CretaOutLinePathPainter(
            //       shapeType: shapeType,
            //       strokeWidth: strokeWidth,
            //       strokeColor: strokeColor,
            //     ),
            //   )
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget _getBaseWidget(
      {required ShapeType shapeType,
      required String mid,
      required double width,
      required double height}) {
    if (shapeType == ShapeType.none || shapeType == ShapeType.rectangle) {
      return SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          'assets/creta_default.png',
          fit: BoxFit.cover,
        ),
      );
    }
    if (shapeType == ShapeType.circle) {
      return ClipRRect(
        //clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(width / 2)),
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            'assets/creta_default.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    if (shapeType == ShapeType.oval) {
      return ClipOval(
        //clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: width,
          height: height,
          child: Image.asset(
            'assets/creta_default.png',
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return ClipPath(
      key: ValueKey(mid),
      clipper: CretaClipper(
        mid: mid,
        shapeType: shapeType,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: Image.asset(
          'assets/creta_default.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class CretaClipper extends CustomClipper<Path> {
  final String mid;
  final ShapeType shapeType;
  CretaClipper({required this.mid, required this.shapeType});

  @override
  Path getClip(Size size) {
    return ShapePath.getClip(shapeType, size);
  }

  @override
  bool shouldReclip(CretaClipper oldClipper) {
    return oldClipper.shapeType != shapeType;
  }
}

CustomPaint _getOutlineWidget({
  required double strokeWidth,
  required Color strokeColor,
  required ShapeType shapeType,
  required double width,
  required double height,
  required double radiusLeftBottom,
  required double radiusLeftTop,
  required double radiusRightBottom,
  required double radiusRightTop,
}) {
  if (shapeType == ShapeType.circle ||
      shapeType == ShapeType.rectangle ||
      shapeType == ShapeType.none) {
    return CustomPaint(
      size: Size(width, height),
      painter: CretaOutLineRRectPainter(
        shapeType: shapeType,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        width: width,
        height: height,
        radiusLeftBottom: radiusLeftBottom,
        radiusLeftTop: radiusLeftTop,
        radiusRightBottom: radiusRightBottom,
        radiusRightTop: radiusRightTop,
      ),
    );
  }

  if (shapeType == ShapeType.oval) {
    return CustomPaint(
      size: Size(width, height),
      painter: CretaOutLineOvalPainter(
        shapeType: shapeType,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        rect: Offset(0, 0) & Size(width, height),
      ),
    );
  }

  return CustomPaint(
    size: Size(width, height),
    painter: CretaOutLinePathPainter(
      shapeType: shapeType,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
    ),
  );
}

class CretaOutLinePathPainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final ShapeType shapeType;

  CretaOutLinePathPainter({
    this.shapeType = ShapeType.none,
    this.strokeWidth = 0,
    this.strokeColor = Colors.transparent,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Path path = ShapePath.getClip(shapeType, Size(size.width, size.height));
    // Paint fillPaint = Paint()
    //   ..color = color
    //   ..style = PaintingStyle.fill;
    // canvas.drawPath(path, fillPaint);
    Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaOutLineOvalPainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final ShapeType shapeType;
  final Rect rect;

  CretaOutLineOvalPainter({
    this.shapeType = ShapeType.none,
    this.strokeWidth = 0,
    this.strokeColor = Colors.transparent,
    required this.rect,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //Path path = ShapePath.getClip(shapeType, Size(size.width, size.height));
    // Paint fillPaint = Paint()
    //   ..color = color
    //   ..style = PaintingStyle.fill;
    // canvas.drawPath(path, fillPaint);
    Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;
    canvas.drawOval(rect, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaOutLineRRectPainter extends CustomPainter {
  final double strokeWidth;
  final Color strokeColor;
  final ShapeType shapeType;
  final double width;
  final double height;
  final double radiusLeftBottom;
  final double radiusLeftTop;
  final double radiusRightBottom;
  final double radiusRightTop;

  CretaOutLineRRectPainter({
    this.shapeType = ShapeType.none,
    this.strokeWidth = 0,
    this.strokeColor = Colors.transparent,
    required this.width,
    required this.height,
    required this.radiusLeftBottom,
    required this.radiusLeftTop,
    required this.radiusRightBottom,
    required this.radiusRightTop,
  });

  @override
  void paint(Canvas canvas, Size size) {
    //Path path = ShapePath.getClip(shapeType, Size(size.width, size.height));
    // Paint fillPaint = Paint()
    //   ..color = color
    //   ..style = PaintingStyle.fill;
    // canvas.drawPath(path, fillPaint);
    Paint strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(_getRRect(), strokePaint);
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

class ShadowPainter extends CustomPainter {
  final double xOffset;
  final double yOffset;
  final double blurRadius;
  final Color shadowColor;

  ShadowPainter({
    required this.xOffset,
    required this.yOffset,
    required this.blurRadius,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint shadowPaint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    final Offset offset = Offset(xOffset, yOffset);
    final Rect rect = offset & size;

    canvas.drawShadow(
      Path()..addRect(rect),
      shadowColor,
      blurRadius,
      true,
    );

    canvas.saveLayer(rect, shadowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
