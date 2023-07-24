import 'package:flutter/material.dart';

import 'shape_path.dart';

/// Clipper to Cut widget at the side

class CretaSideCutClipper extends CustomClipper<Path> {
  final double delta;
  final double applyScale;

  CretaSideCutClipper({this.delta = 1.0, this.applyScale = 1.0});

  /// Play with scals to get more clear versions
  @override
  Path getClip(Size size) {
    return ShapePath.sideCut(size, delta, applyScale: applyScale);
    // double xFactor = 18.0 * delta, yFactor = 15.0 * delta;
    // double height = size.height;
    // double startY = (height - height / 3) - yFactor;
    // double xVal = size.width;
    // double yVal = 0;
    // final path = Path();

    // path.lineTo(xVal, yVal);

    // yVal = startY;
    // path.lineTo(xVal, yVal);

    // double scale = 1.4;
    // path.cubicTo(
    //     xVal, yVal, xVal, yVal + yFactor * scale, xVal - xFactor * scale, yVal + yFactor * scale);
    // xVal = xVal - xFactor * scale;
    // yVal = yVal + yFactor * scale;

    // double scale1 = 1;
    // path.cubicTo(xVal, yVal, xVal - xFactor * scale1, yVal, xVal - scale1 * xFactor,
    //     yVal + yFactor * scale1);
    // xVal = xVal - scale1 * xFactor;
    // yVal = yVal + scale1 * yFactor;
    // double scale2 = 1.2;
    // path.cubicTo(xVal, yVal, xVal, yVal + yFactor * scale2, xVal + xFactor * scale2,
    //     yVal + yFactor * scale2);
    // xVal = xVal + xFactor * scale2;
    // yVal = yVal + yFactor * scale2;

    // scale = 1.6;

    // path.cubicTo(
    //     xVal, yVal, xVal + xFactor * scale, yVal, xVal + xFactor * scale, yVal + yFactor * scale);
    // xVal = xVal + xFactor * scale;
    // yVal = yVal + yFactor * scale;

    // path.lineTo(xVal, height);
    // path.lineTo(0, height);
    // path.close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
