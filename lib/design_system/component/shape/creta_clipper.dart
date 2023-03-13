// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../model/app_enums.dart';
import 'creta_outline_painter.dart';
import 'creta_shadow_painter.dart';
import 'shape_path.dart';

extension ShapeWidget<T extends Widget> on T {
  Widget asShape({
    required String mid,
    required ShapeType shapeType,
    required Offset offset,
    required double blurRadius,
    required double blurSpread,
    required double opacity,
    required Color shadowColor,
    required double width,
    required double height,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    required BorderCapType borderCap,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
  }) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _getShadowWidget(
          shapeType: shapeType,
          offset: offset,
          blurRadius: blurRadius,
          blurSpread: blurSpread,
          opacity: opacity,
          shadowColor: shadowColor,
          width: width,
          height: height,
          radiusLeftBottom: radiusLeftBottom,
          radiusLeftTop: radiusLeftTop,
          radiusRightBottom: radiusRightBottom,
          radiusRightTop: radiusRightTop,
        ),
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
                borderCap: borderCap,
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
  required BorderCapType borderCap,
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
        borderCap: borderCap,
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
        borderCap: borderCap,
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
      borderCap: borderCap,
    ),
  );
}

CustomPaint _getShadowWidget({
  required ShapeType shapeType,
  required Offset offset,
  required double blurRadius,
  required double blurSpread,
  required double opacity,
  required Color shadowColor,
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
      painter: CretaShadowRRectPainter(
        pshapeType: shapeType,
        poffset: offset,
        pblurRadius: blurRadius,
        pblurSpread: blurSpread,
        popacity: opacity,
        pshadowColor: shadowColor,
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
      painter: CretaShadowOvalPainter(
        pshapeType: shapeType,
        poffset: offset,
        pblurRadius: blurRadius,
        pblurSpread: blurSpread,
        popacity: opacity,
        pshadowColor: shadowColor,
      ),
    );
  }

  return CustomPaint(
    size: Size(width, height),
    painter: CretaShadowPathPainter(
      pshapeType: shapeType,
      poffset: offset,
      pblurRadius: blurRadius,
      pblurSpread: blurSpread,
      popacity: opacity,
      pshadowColor: shadowColor,
    ),
  );
}





// class ShadowPainter extends CustomPainter {
//   final ShapeType shapeType;
//   final double xOffset;
//   final double yOffset;
//   final double blurRadius;
//   final double blurSpread;
//   final double opacity;
//   final Color shadowColor;

//   ShadowPainter({
//     required this.shapeType,
//     required this.xOffset,
//     required this.yOffset,
//     required this.blurRadius,
//     required this.blurSpread,
//     required this.opacity,
//     required this.shadowColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint shadowPaint = Paint()
//       ..color = opacity != 1 ? shadowColor.withOpacity(opacity) : shadowColor
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

//     final Offset offset = Offset(xOffset, yOffset);
//     final Rect rect = offset & size;

//     canvas.drawShadow(
//       ShapePath.getClip(shapeType, size),
//       shadowColor,
//       blurSpread,
//       true,
//     );

//     canvas.saveLayer(rect, shadowPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
