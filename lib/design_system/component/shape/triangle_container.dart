// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:creta_common/model/app_enums.dart';
import 'creta_clipper.dart';

class TriangleContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget? child;
  final double applyScale;

  TriangleContainer({
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
      clipper: CretaClipper(
          mid: ShapeType.triangle.name, shapeType: ShapeType.triangle, applyScale: applyScale),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: child,
      ),
    );
  }

//   @override
//   Widget build(BuildContext context) {
//     return ClipPath(
//       clipper: CretaClipper(ctype: ShapeType.triangle, width: width),
//       child: Stack(
//         children: [
//           CustomPaint(
//             size: Size(width, width),
//             painter: TrianglePainter(
//               color: color,
//               borderColor: borderColor,
//               borderWidth: borderWidth,
//             ),
//           ),
//           if (child != null)
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: child,
//               ),
//             ),
//         ],
//       ),
//     );
//   }
}

// class TrianglePainter extends CustomPainter {
//   final Color color;
//   final double borderWidth;
//   final Color borderColor;

//   TrianglePainter({
//     required this.color,
//     required this.borderColor,
//     this.borderWidth = 2,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     final Path path = ShapePath.triangle(size);
//     final Paint strokePaint = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = borderWidth;

//     canvas.drawPath(path, paint);
//     canvas.drawPath(path, strokePaint);
//   }

//   @override
//   bool shouldRepaint(TrianglePainter oldDelegate) {
//     return oldDelegate.color != color ||
//         oldDelegate.borderWidth != borderWidth ||
//         oldDelegate.borderColor != borderColor;
//   }
// }
