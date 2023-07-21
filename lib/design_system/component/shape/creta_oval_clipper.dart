import 'package:flutter/material.dart';

import 'shape_path.dart';

/// Clip widget in oval shape at top side
class CreaOvalTopClipper extends CustomClipper<Path> {
  final double delta;
  CreaOvalTopClipper({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.ovalTop(size, delta);
    // var path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(0, 3 * delta);
    // path.quadraticBezierTo(size.width / 4, 0, size.width / 2, 0);
    // path.quadraticBezierTo(size.width - size.width / 4, 0, size.width, 3 * delta);
    // path.lineTo(size.width, size.height);
    // path.lineTo(0, size.height);
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Oval bottom clipper to clip widget in oval shape at the bottom side
class CretaOvalBottomClipper extends CustomClipper<Path> {
  final double delta;
  CretaOvalBottomClipper({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.ovalBottom(size, delta);
    // var path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(0, size.height - 30 * delta);
    // path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height);
    // path.quadraticBezierTo(
    //     size.width - size.width / 4, size.height, size.width, size.height - 30 * delta);
    // path.lineTo(size.width, 0);
    // path.lineTo(0, 0);
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Clip widget in oval shape at left side
class CretaOvalLeftClipper extends CustomClipper<Path> {
  final double delta;
  CretaOvalLeftClipper({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.ovalLeft(size, delta);
    // var path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(3 * delta, 0);
    // path.quadraticBezierTo(0, size.height / 4, 0, size.height / 2);
    // path.quadraticBezierTo(0, size.height - (size.height / 4), 3 * delta, size.height);
    // path.lineTo(size.width, size.height);
    // path.lineTo(size.width, 0);
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Oval bottom clipper to clip widget in oval shape at the bottom side
class CretaOvalRightClipper extends CustomClipper<Path> {
  final double delta;
  CretaOvalRightClipper({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.ovalRight(size, delta);
    // var path = Path();
    // path.lineTo(0, 0);
    // path.lineTo(size.width - 30 * delta, 0);
    // path.quadraticBezierTo(size.width, size.height / 4, size.width, size.height / 2);
    // path.quadraticBezierTo(
    //     size.width, size.height - (size.height / 4), size.width - 30 * delta, size.height);
    // path.lineTo(0, size.height);
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
