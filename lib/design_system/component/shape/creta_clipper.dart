// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
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
    // required double width,
    // required double height,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    required BorderCapType borderCap,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
  }) {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;
      return Stack(
        alignment: Alignment.center,
        children: [
          _getShadowWidget(
            mid: mid,
            shapeType: shapeType,
            offset: offset,
            blurRadius: blurRadius,
            blurSpread: blurSpread,
            opacity: opacity,
            shadowColor: shadowColor,
            // width: width,
            // height: height,
            radiusLeftBottom: radiusLeftBottom,
            radiusLeftTop: radiusLeftTop,
            radiusRightBottom: radiusRightBottom,
            radiusRightTop: radiusRightTop,
          ),
          _getBaseWidget(
            mid: mid,
            shapeType: shapeType,
            width: width - blurSpread,
            height: height - blurSpread,
            radiusLeftBottom: radiusLeftBottom,
            radiusLeftTop: radiusLeftTop,
            radiusRightBottom: radiusRightBottom,
            radiusRightTop: radiusRightTop,
          ),
          strokeWidth > 0
              ? Container(
                  alignment: Alignment.center,
                  width: width - blurSpread,
                  height: height - blurSpread,
                  child: IgnorePointer(
                    child: _getOutlineWidget(
                      mid: mid,
                      shapeType: shapeType,
                      strokeWidth: strokeWidth,
                      strokeColor: strokeColor,
                      borderCap: borderCap,
                      width: width - blurSpread,
                      height: height - blurSpread,
                      radiusLeftBottom: radiusLeftBottom,
                      radiusLeftTop: radiusLeftTop,
                      radiusRightBottom: radiusRightBottom,
                      radiusRightTop: radiusRightTop,
                    ),
                  ),
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
    });
  }

  Widget _getBaseWidget({
    required ShapeType shapeType,
    required String mid,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    required double width,
    required double height,
  }) {
    if (shapeType == ShapeType.none || shapeType == ShapeType.rectangle) {
      return ClipRRect(
        //clipBehavior: Clip.hardEdge,
        borderRadius: _getBorderRadius(
          radiusLeftBottom: radiusLeftBottom,
          radiusLeftTop: radiusLeftTop,
          radiusRightBottom: radiusRightBottom,
          radiusRightTop: radiusRightTop,
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: this,
        ),
        //child: this,
      );
    }
    if (shapeType == ShapeType.circle) {
      return ClipRRect(
        //clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(360)),
        child: SizedBox(
          width: width,
          height: height,
          child: this,
        ),
        //child: this,
      );
    }
    if (shapeType == ShapeType.oval) {
      return ClipOval(
        //clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: width,
          height: height,
          child: this,
        ),
        //child: this,
      );
    }

    return ClipPath(
      key: ValueKey('base-$mid'),
      clipper: CretaClipper(
        mid: mid,
        shapeType: shapeType,
      ),
      //child: this,
      child: SizedBox(
        width: width,
        height: width,
        child: this,
      ),
    );
  }

  BorderRadius? _getBorderRadius(
      {required double radiusLeftTop,
      required double radiusRightTop,
      required double radiusRightBottom,
      required double radiusLeftBottom,
      double addRadius = 0}) {
    double lt = radiusLeftTop + addRadius;
    double rt = radiusRightTop + addRadius;
    double rb = radiusRightBottom + addRadius;
    double lb = radiusLeftBottom + addRadius;
    if (lt == rt && rt == rb && rb == lb) {
      if (lt == 0) {
        return BorderRadius.zero;
      }
      return BorderRadius.all(Radius.circular(lt));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(lt),
      topRight: Radius.circular(rt),
      bottomLeft: Radius.circular(lb),
      bottomRight: Radius.circular(rb),
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
    //return oldClipper.shapeType != shapeType;
    return true;
  }
}

Widget _getOutlineWidget({
  required String mid,
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
  if (shapeType == ShapeType.rectangle || shapeType == ShapeType.none) {
    //return LayoutBuilder(builder: (context, constraints) {
    return CustomPaint(
      //size: Size(width, height),
      key: ValueKey('outline-$mid'),
      size: Size(double.infinity, double.infinity),
      painter: CretaOutLineRRectPainter(
        shapeType: shapeType,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        borderCap: borderCap,
        width: width,
        height: height,
        // width: constraints.maxWidth,
        // height: constraints.maxHeight,
        radiusLeftBottom: radiusLeftBottom,
        radiusLeftTop: radiusLeftTop,
        radiusRightBottom: radiusRightBottom,
        radiusRightTop: radiusRightTop,
      ),
    );
    //});
  }

  if (shapeType == ShapeType.circle) {
    //return LayoutBuilder(builder: (context, constraints) {
    return CustomPaint(
      //size: Size(width, height),
      key: ValueKey('outline-$mid'),
      size: Size(double.infinity, double.infinity),
      painter: CretaOutLineCirclePainter(
        shapeType: shapeType,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        borderCap: borderCap,
        width: width - strokeWidth / 2,
        height: height - strokeWidth / 2,
        // width: constraints.maxWidth - strokeWidth / 2 - 30,
        // height: constraints.maxHeight - strokeWidth / 2 - 30,
      ),
    );
    //});
  }

  if (shapeType == ShapeType.oval) {
    //return LayoutBuilder(builder: (context, constraints) {
    //logger.fine('RealSize=${constraints.maxWidth}, ${constraints.maxHeight}');
    return CustomPaint(
      key: ValueKey('outline-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),
      painter: CretaOutLineOvalPainter(
        shapeType: shapeType,
        strokeColor: strokeColor,
        strokeWidth: strokeWidth,
        borderCap: borderCap,
        // width: constraints.maxWidth,
        // height: constraints.maxHeight,
        width: width,
        height: height,
        //rect: Offset(0, 0) & Size(width, height),
        // rect: Offset(strokeWidth / 2, strokeWidth / 2) &
        //     Size(constraints.maxWidth - strokeWidth / 2, constraints.maxHeight - strokeWidth / 2),
      ),
    );
    //});
  }

  return CustomPaint(
    key: ValueKey('outline-$mid'),
    size: Size(width, height),
    //size: Size(double.infinity, double.infinity),
    painter: CretaOutLinePathPainter(
      shapeType: shapeType,
      strokeWidth: strokeWidth,
      strokeColor: strokeColor,
      borderCap: borderCap,
    ),
  );
}

CustomPaint _getShadowWidget({
  required String mid,
  required ShapeType shapeType,
  required Offset offset,
  required double blurRadius,
  required double blurSpread,
  required double opacity,
  required Color shadowColor,
  // required double width,
  // required double height,
  required double radiusLeftBottom,
  required double radiusLeftTop,
  required double radiusRightBottom,
  required double radiusRightTop,
}) {
  if (shapeType == ShapeType.rectangle || shapeType == ShapeType.none) {
    return CustomPaint(
      key: ValueKey('shadow-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),

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

  if (shapeType == ShapeType.circle) {
    logger.info('offset=$offset');
    logger.info('blurRadius = $blurRadius');
    logger.info('blurSpread = $blurSpread');
    logger.info('opacity = $opacity');

    return CustomPaint(
      key: ValueKey('shadow-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),

      painter: CretaShadowCirclePainter(
        pshapeType: shapeType,
        poffset: offset,
        pblurRadius: blurRadius,
        pblurSpread: blurSpread,
        popacity: opacity,
        pshadowColor: shadowColor,
      ),
    );
  }

  if (shapeType == ShapeType.oval) {
    return CustomPaint(
      key: ValueKey('shadow-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),

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
    key: ValueKey('shadow-$mid'),
    //size: Size(width, height),
    size: Size(double.infinity, double.infinity),
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
