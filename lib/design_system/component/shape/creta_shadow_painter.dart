// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:creta_common/model/app_enums.dart';
import 'shape_path.dart';

class CretaShadowPainter extends CustomPainter {
  final ShapeType shapeType;
  final Offset offset;
  final double blurRadius;
  final double blurSpread;
  final double opacity;
  final Color shadowColor;
  final double applyScale;

  late Paint shadowPaint;

  CretaShadowPainter({
    required this.shapeType,
    required this.offset,
    required this.blurRadius,
    required this.blurSpread,
    required this.opacity,
    required this.shadowColor,
    this.applyScale = 1.0,
  });

  Paint getPaint(Size size) {
    // print('-------------------------------------');
    // print('offset = $offset');
    // print('blurRadius = $blurRadius');
    // print('blurSpread = $blurSpread');
    // print('opacity = $opacity');
    // print('-------------------------------------');

    return Paint()
      ..color = opacity >= 0 && opacity < 1 ? shadowColor.withOpacity(opacity) : shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius)
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CretaShadowPathPainter extends CretaShadowPainter {
  CretaShadowPathPainter({
    required ShapeType pshapeType,
    required Offset poffset,
    required double pblurRadius,
    required double pblurSpread,
    required double popacity,
    required Color pshadowColor,
    required double applyScale,
  }) : super(
          shapeType: pshapeType,
          offset: poffset,
          blurRadius: pblurRadius,
          blurSpread: pblurSpread,
          opacity: popacity,
          shadowColor: pshadowColor,
          applyScale: applyScale,
        );

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    canvas.drawPath(getPath(size), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Path getPath(Size size) {
    return ShapePath.getClip(
        shapeType, Size(size.width, /* + blurSpread,*/ size.height /* + blurSpread */),
        offset: offset, applyScale: applyScale);
  }
}

class CretaShadowOvalPainter extends CretaShadowPainter {
  CretaShadowOvalPainter({
    required ShapeType pshapeType,
    required Offset poffset,
    required double pblurRadius,
    required double pblurSpread,
    required double popacity,
    required Color pshadowColor,
  }) : super(
          shapeType: pshapeType,
          offset: poffset,
          blurRadius: pblurRadius,
          blurSpread: pblurSpread,
          opacity: popacity,
          shadowColor: pshadowColor,
        );

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    canvas.drawOval(getRect(size), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  Rect getRect(Size size) {
    return (offset & Size(size.width + blurSpread, size.height + blurSpread));
  }
}

class CretaShadowRRectPainter extends CretaShadowPainter {
  final double radiusLeftBottom;
  final double radiusLeftTop;
  final double radiusRightBottom;
  final double radiusRightTop;

  CretaShadowRRectPainter({
    required ShapeType pshapeType,
    required Offset poffset,
    required double pblurRadius,
    required double pblurSpread,
    required double popacity,
    required Color pshadowColor,
    required this.radiusLeftBottom,
    required this.radiusLeftTop,
    required this.radiusRightBottom,
    required this.radiusRightTop,
  }) : super(
          shapeType: pshapeType,
          offset: poffset,
          blurRadius: pblurRadius,
          blurSpread: pblurSpread,
          opacity: popacity,
          shadowColor: pshadowColor,
        );

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    canvas.drawRRect(_getRRect(size), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  RRect _getRRect(Size size, {double addRadius = 0}) {
    double lt = radiusLeftTop + addRadius;
    double rt = radiusRightTop + addRadius;
    double rb = radiusRightBottom + addRadius;
    double lb = radiusLeftBottom + addRadius;
    if (lt == rt && rt == rb && rb == lb) {
      if (lt == 0) {
        return RRect.fromRectAndRadius(
          Rect.fromLTWH(
            offset.dx,
            offset.dy,
            size.width, // + blurSpread,
            size.height, // + blurSpread,
          ),
          Radius.zero,
        );
      }
      return RRect.fromRectAndRadius(
        Rect.fromLTWH(
          offset.dx,
          offset.dy,
          size.width, // + blurSpread,
          size.height, // + blurSpread,
        ),
        Radius.circular(radiusLeftTop),
      );
    }
    return RRect.fromRectAndCorners(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        size.width, //+ blurSpread,
        size.height, // + blurSpread,
      ),
      bottomLeft: Radius.circular(lb),
      bottomRight: Radius.circular(rb),
      topLeft: Radius.circular(lt),
      topRight: Radius.circular(rt),
    );
  }
}

class CretaShadowCirclePainter extends CretaShadowPainter {
  CretaShadowCirclePainter({
    required ShapeType pshapeType,
    required Offset poffset,
    required double pblurRadius,
    required double pblurSpread,
    required double popacity,
    required Color pshadowColor,
  }) : super(
          shapeType: pshapeType,
          offset: poffset,
          blurRadius: pblurRadius,
          blurSpread: pblurSpread,
          opacity: popacity,
          shadowColor: pshadowColor,
        );

  @override
  void paint(Canvas canvas, Size size) {
    super.paint(canvas, size);
    canvas.drawRRect(_getRRect(size), getPaint(size));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  RRect _getRRect(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(
        offset.dx,
        offset.dy,
        // size.width + blurSpread,
        // size.height + blurSpread,
        size.width,
        size.height,
      ),
      Radius.circular(360),
    );
  }
}
