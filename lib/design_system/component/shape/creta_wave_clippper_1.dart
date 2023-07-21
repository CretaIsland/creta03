import 'package:creta03/design_system/component/shape/shape_path.dart';
import 'package:flutter/material.dart';

/// Clip widget in wave shape shape
class CretaWaveClipper1 extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  final bool reverse;

  /// flip the wave direction horizontal axis
  final bool flip;
  final double delta; //skpark
  CretaWaveClipper1({this.reverse = false, this.flip = false, this.delta = 1.0});

  @override
  Path getClip(Size size) {
    return ShapePath.waveClipper1(size, delta, reverse, flip, Offset.zero);
    // if (!reverse && !flip) {
    //   Offset firstEndPoint = Offset(size.width * .5, size.height - 2 * delta);
    //   Offset firstControlPoint = Offset(size.width * .25, size.height - 3 * delta);
    //   Offset secondEndPoint = Offset(size.width, size.height - 3 * delta);
    //   Offset secondControlPoint = Offset(size.width * .75, size.height - 1 * delta);

    //   final path = Path()
    //     ..lineTo(0.0, size.height)
    //     ..quadraticBezierTo(
    //         firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
    //     ..quadraticBezierTo(
    //         secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
    //     ..lineTo(size.width, 0.0)
    //     ..close();
    //   return path;
    // }
    // if (!reverse && flip) {
    //   Offset firstEndPoint = Offset(size.width * .5, size.height - 2 * delta);
    //   Offset firstControlPoint = Offset(size.width * .25, size.height - 1 * delta);
    //   Offset secondEndPoint = Offset(size.width, size.height);
    //   Offset secondControlPoint = Offset(size.width * .75, size.height - 3 * delta);

    //   final path = Path()
    //     ..lineTo(0.0, size.height - 3 * delta)
    //     ..quadraticBezierTo(
    //         firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
    //     ..quadraticBezierTo(
    //         secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
    //     ..lineTo(size.width, 0.0)
    //     ..close();
    //   return path;
    // }
    // if (reverse && flip) {
    //   Offset firstEndPoint = Offset(size.width * .5, 2 * delta);
    //   Offset firstControlPoint = Offset(size.width * .25, 1 * delta);
    //   Offset secondEndPoint = Offset(size.width, 0);
    //   Offset secondControlPoint = Offset(size.width * .75, 3 * delta);

    //   final path = Path()
    //     ..lineTo(0, 3 * delta)
    //     ..quadraticBezierTo(
    //         firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
    //     ..quadraticBezierTo(
    //         secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
    //     ..lineTo(size.width, size.height)
    //     ..lineTo(0.0, size.height)
    //     ..close();
    //   return path;
    // }

    // Offset firstEndPoint = Offset(size.width * .5, 2 * delta);
    // Offset firstControlPoint = Offset(size.width * .25, 3 * delta);
    // Offset secondEndPoint = Offset(size.width, 3 * delta);
    // Offset secondControlPoint = Offset(size.width * .75, 1 * delta);

    // final path = Path()
    //   ..quadraticBezierTo(
    //       firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy)
    //   ..quadraticBezierTo(
    //       secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy)
    //   ..lineTo(size.width, size.height)
    //   ..lineTo(0.0, size.height)
    //   ..close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
