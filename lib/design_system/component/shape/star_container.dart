// // ignore_for_file: prefer_const_constructors_in_immutables
// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

import 'package:creta_common/model/app_enums.dart';
import 'creta_clipper.dart';

class StarContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget? child;
  final double applyScale;

  StarContainer({
    super.key,
    required this.width,
    required this.height,
    required this.color,
    required this.applyScale,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper:
          CretaClipper(mid: ShapeType.star.name, shapeType: ShapeType.star, applyScale: applyScale),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: child,
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Stack(
  //     children: [
  //       // CustomPaint(
  //       //   size: Size(size, size),
  //       //   painter: StarPainter(color: color),
  //       // ),
  //       if (child != null)
  //         Positioned.fill(
  //           child: ClipPath(
  //             clipper: CretaClipper(
  //                 ctype: ShapeType.star, width: width, borderWidth: borderWidth),
  //             child: child,
  //           ),
  //         ),
  //       if (borderWidth > 0)
  //         CustomPaint(
  //           size: Size(width, width),
  //           painter: StarPainter(
  //             color: Colors.transparent,
  //             strokeWidth: borderWidth,
  //             strokeColor: borderColor,
  //           ),
  //         ),
  //     ],
  //   );
  // }
}

// class StarPainter extends CustomPainter {
//   final double strokeWidth;
//   final Color strokeColor;
//   final double size;
//   final Color color;

//   StarPainter({
//     this.strokeWidth = 0,
//     this.strokeColor = Colors.transparent,
//     this.size = 50,
//     this.color = Colors.blue,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     Path path = ShapePath.star(size, strokeWidth);

//     Paint fillPaint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;
//     canvas.drawPath(path, fillPaint);

//     if (strokeWidth > 0) {
//       Paint strokePaint = Paint()
//         ..color = strokeColor
//         ..style = PaintingStyle.stroke
//         ..strokeWidth = strokeWidth;
//       canvas.drawPath(path, strokePaint);
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
