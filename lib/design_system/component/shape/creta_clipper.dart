// ignore_for_file: prefer_const_constructors

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/model/app_enums.dart';
import 'creta_arrow_clipper.dart';
import 'creta_digonal_clipper.dart';
import 'creta_dir_clipper.dart';
import 'creta_outline_painter.dart';
import 'creta_oval_clipper.dart';
import 'creta_poligon_clipper.dart';
import 'creta_shadow_painter.dart';
import 'creta_slider_cut_clipper.dart';
import 'creta_star_clipper.dart';
import 'creta_wave_clippper_1.dart';
import 'shape_path.dart';

extension ShapeWidget<T extends Widget> on T {
  Widget asShape({
    required String mid,
    required ShapeType shapeType,
    required Offset offset,
    required double shadowBlur,
    required double shadowSpread,
    required double shadowOpacity,
    required Color shadowColor,
    // required double width,
    // required double height,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    required BorderCapType borderCap,
    int glowSize = 0,
    double strokeWidth = 0,
    Color strokeColor = Colors.transparent,
    required double applyScale,
  }) {
    // print('asShape()');
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = constraints.maxHeight;

      return OverflowBox(
        maxHeight: height + shadowSpread,
        maxWidth: width + shadowSpread,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _getShadowWidget(
              mid: mid,
              shapeType: shapeType,
              offset: offset,
              shadowBlur: shadowBlur,
              shadowSpread: shadowSpread,
              shadowOpacity: shadowOpacity,
              shadowColor: shadowColor,
              // width: width,
              // height: height,
              radiusLeftBottom: radiusLeftBottom,
              radiusLeftTop: radiusLeftTop,
              radiusRightBottom: radiusRightBottom,
              radiusRightTop: radiusRightTop,
              applyScale: applyScale,
            ),
            _getBaseWidget(
              mid: mid,
              shapeType: shapeType,
              width: width, // - shadowSpread,
              height: height, // - shadowSpread,
              radiusLeftBottom: radiusLeftBottom,
              radiusLeftTop: radiusLeftTop,
              radiusRightBottom: radiusRightBottom,
              radiusRightTop: radiusRightTop,
              applyScale: applyScale,
            ),
            strokeWidth > 0
                ? Container(
                    alignment: Alignment.center,
                    width: width, // - shadowSpread,
                    height: height, // - shadowSpread,
                    child: IgnorePointer(
                      child: _glowEffect(
                        glowSize: glowSize,
                        shapeType: shapeType,
                        strokeWidth: strokeWidth,
                        radiusLeftBottom: radiusLeftBottom,
                        radiusLeftTop: radiusLeftTop,
                        radiusRightBottom: radiusRightBottom,
                        radiusRightTop: radiusRightTop,
                        strokeColor: strokeColor,
                        child: _getOutlineWidget(
                          mid: mid,
                          shapeType: shapeType,
                          strokeWidth: strokeWidth,
                          strokeColor: strokeColor,
                          borderCap: borderCap,
                          width: width, // - shadowSpread,
                          height: height, // - shadowSpread,
                          radiusLeftBottom: radiusLeftBottom,
                          radiusLeftTop: radiusLeftTop,
                          radiusRightBottom: radiusRightBottom,
                          radiusRightTop: radiusRightTop,
                          applyScale: applyScale,
                        ),
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
        ),
      );
    });
  }

  Widget _glowEffect({
    required int glowSize,
    required ShapeType shapeType,
    required double strokeWidth,
    required double radiusLeftBottom,
    required double radiusLeftTop,
    required double radiusRightBottom,
    required double radiusRightTop,
    required Color strokeColor,
    required Widget child,
  }) {
    if (glowSize == 0) {
      return child;
    }
    // if (shapeType != ShapeType.none &&
    //     shapeType != ShapeType.rectangle &&
    //     shapeType != ShapeType.circle) {
    //   return child;
    // }
    // return AnimatedGradientBorder(
    //   // borderSize: strokeWidth,
    //   // glowSize: glowSize.toDouble(),
    //   borderSize: 2,
    //   glowSize: 10,
    //   stretchAlongAxis: true,
    //   gradientColors: [
    //     Colors.transparent,
    //     Colors.transparent,
    //     Colors.transparent,
    //     Colors.transparent,
    //     Colors.transparent,
    //     Colors.purple.shade50,
    //     strokeColor
    //   ],
    //   //borderRadius: BorderRadius.all(Radius.circular(999)),
    //   borderRadius: BorderRadius.only(
    //     topLeft: Radius.circular(radiusLeftTop),
    //     topRight: Radius.circular(radiusRightTop),
    //     bottomLeft: Radius.circular(radiusLeftBottom),
    //     bottomRight: Radius.circular(radiusRightBottom),
    //   ),      child: child,    );

    return AvatarGlow(
      glowRadiusFactor: glowSize / 100.0,
      glowShape: BoxShape.circle,
      glowColor: strokeColor,
      glowBorderRadius: (shapeType == ShapeType.rectangle)
          ? BorderRadius.only(
              topLeft: Radius.circular(radiusLeftTop),
              topRight: Radius.circular(radiusRightTop),
              bottomLeft: Radius.circular(radiusLeftBottom),
              bottomRight: Radius.circular(radiusRightBottom),
            )
          : null,
      child: child,
    );
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
    required double applyScale,
  }) {
    if (shapeType == ShapeType.none || shapeType == ShapeType.rectangle) {
      //print('width=$width, height=$height');
      return ClipRRect(
        //clipBehavior: Clip.hardEdge,
        borderRadius: _getBorderRadius(
          radiusLeftBottom: radiusLeftBottom,
          radiusLeftTop: radiusLeftTop,
          radiusRightBottom: radiusRightBottom,
          radiusRightTop: radiusRightTop,
        )!,
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

    if (shapeType == ShapeType.sideCut) {
      return ClipPath(
        clipper: CretaSideCutClipper(applyScale: applyScale),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.waveTopLeft) {
      return ClipPath(
        clipper: CretaWaveClipper1(flip: true, reverse: true, delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.waveTopRight) {
      return ClipPath(
        clipper: CretaWaveClipper1(flip: false, reverse: true, delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.waveBottomLeft) {
      return ClipPath(
        clipper: CretaWaveClipper1(flip: true, reverse: false, delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.waveBottomRight) {
      return ClipPath(
        clipper: CretaWaveClipper1(flip: false, reverse: false, delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.ovalTop) {
      return ClipPath(
        clipper: CreaOvalTopClipper(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.ovalBottom) {
      return ClipPath(
        clipper: CretaOvalBottomClipper(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.ovalLeft) {
      return ClipPath(
        clipper: CretaOvalLeftClipper(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.ovalRight) {
      return ClipPath(
        clipper: CretaOvalRightClipper(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }
    if (shapeType == ShapeType.star4) {
      return ClipPath(
        clipper: CretaStarClipper(4),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }
    if (shapeType == ShapeType.star8) {
      return ClipPath(
        clipper: CretaStarClipper(8),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.star16) {
      return ClipPath(
        clipper: CretaStarClipper(16),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.arrowUp) {
      return ClipPath(
        clipper: CretaArrowClipper(height * 0.33, width * 0.6, CretaEdge.TOP),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.arrowDown) {
      return ClipPath(
        clipper: CretaArrowClipper(height * 0.33, width * 0.6, CretaEdge.BOTTOM),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.arrowLeft) {
      return ClipPath(
        clipper: CretaArrowClipper(width * 0.33, height * 0.6, CretaEdge.LEFT),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.arrowRight) {
      return ClipPath(
        clipper: CretaArrowClipper(width * 0.33, height * 0.6, CretaEdge.RIGHT),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.dirUp) {
      return ClipPath(
        clipper: CretaDirClipper(height * 0.33, CretaEdge.TOP),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.dirDown) {
      return ClipPath(
        clipper: CretaDirClipper(height * 0.33, CretaEdge.BOTTOM),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.dirLeft) {
      return ClipPath(
        clipper: CretaDirClipper(width * 0.33, CretaEdge.LEFT),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.dirRight) {
      return ClipPath(
        clipper: CretaDirClipper(width * 0.33, CretaEdge.RIGHT),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.octagon) {
      return ClipPath(
        clipper: CretaOctagonalClipper(),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.hexagon) {
      return ClipPath(
        clipper: CretaHexagonalClipper(),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.digonalBottomLeft) {
      return ClipPath(
        clipper: CretaDiagonalBottomLeft(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.digonalBottomRight) {
      return ClipPath(
        clipper: CretaDiagonalBottomRight(delta: height / 100),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.pepple1) {
      return ClipPath(
        clipper: CretaPeppleClipper1(delta: height / 10),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.heart) {
      return ClipPath(
        clipper: CretaHeartClipper(),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.leaf) {
      return ClipPath(
        clipper: CretaLeafClipper(),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }

    if (shapeType == ShapeType.snowman) {
      return ClipPath(
        clipper: CretaSnowManClipper(),
        child: SizedBox(
          height: height,
          width: width,
          child: this,
        ),
      );
    }
    return ClipPath(
      key: ValueKey('base-$mid'),
      clipper: CretaClipper(
        mid: mid,
        shapeType: shapeType,
        applyScale: applyScale,
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
  final double applyScale;
  CretaClipper({required this.mid, required this.shapeType, required this.applyScale});

  @override
  Path getClip(Size size) {
    return ShapePath.getClip(shapeType, size, applyScale: applyScale);
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
  required double applyScale,
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
      applyScale: applyScale,
    ),
  );
}

CustomPaint _getShadowWidget({
  required String mid,
  required ShapeType shapeType,
  required Offset offset,
  required double shadowBlur,
  required double shadowSpread,
  required double shadowOpacity,
  required Color shadowColor,
  // required double width,
  // required double height,
  required double radiusLeftBottom,
  required double radiusLeftTop,
  required double radiusRightBottom,
  required double radiusRightTop,
  required double applyScale,
}) {
  if (shapeType == ShapeType.rectangle || shapeType == ShapeType.none) {
    return CustomPaint(
      key: ValueKey('shadow-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),

      painter: CretaShadowRRectPainter(
        pshapeType: shapeType,
        poffset: offset,
        pblurRadius: shadowBlur,
        pblurSpread: shadowSpread,
        popacity: shadowOpacity,
        pshadowColor: shadowColor,
        radiusLeftBottom: radiusLeftBottom,
        radiusLeftTop: radiusLeftTop,
        radiusRightBottom: radiusRightBottom,
        radiusRightTop: radiusRightTop,
      ),
    );
  }

  if (shapeType == ShapeType.circle) {
    logger.fine('offset=$offset');
    logger.fine('shadowBlur = $shadowBlur');
    logger.fine('shadowSpread = $shadowSpread');
    logger.fine('opacity = $shadowOpacity');

    return CustomPaint(
      key: ValueKey('shadow-$mid'),
      //size: Size(width, height),
      size: Size(double.infinity, double.infinity),

      painter: CretaShadowCirclePainter(
        pshapeType: shapeType,
        poffset: offset,
        pblurRadius: shadowBlur,
        pblurSpread: shadowSpread,
        popacity: shadowOpacity,
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
        pblurRadius: shadowBlur,
        pblurSpread: shadowSpread,
        popacity: shadowOpacity,
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
      pblurRadius: shadowBlur,
      pblurSpread: shadowSpread,
      popacity: shadowOpacity,
      pshadowColor: shadowColor,
      applyScale: applyScale,
    ),
  );
}





// class ShadowPainter extends CustomPainter {
//   final ShapeType shapeType;
//   final double xOffset;
//   final double yOffset;
//   final double shadowBlur;
//   final double shadowSpread;
//   final double opacity;
//   final Color shadowColor;

//   ShadowPainter({
//     required this.shapeType,
//     required this.xOffset,
//     required this.yOffset,
//     required this.shadowBlur,
//     required this.shadowSpread,
//     required this.opacity,
//     required this.shadowColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint shadowPaint = Paint()
//       ..color = opacity != 1 ? shadowColor.withOpacity(opacity) : shadowColor
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadowBlur);

//     final Offset offset = Offset(xOffset, yOffset);
//     final Rect rect = offset & size;

//     canvas.drawShadow(
//       ShapePath.getClip(shapeType, size),
//       shadowColor,
//       shadowSpread,
//       true,
//     );

//     canvas.saveLayer(rect, shadowPaint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => true;
// }
