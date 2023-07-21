import 'package:creta03/design_system/component/shape/shape_path.dart';
import 'package:flutter/material.dart';

/// [CretaDiagonalBottomLeft], can be used with [ClipPath] widget, and clips the widget diagonally

class CretaDiagonalBottomLeft extends CustomClipper<Path> {
  final double delta;
  CretaDiagonalBottomLeft({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.digonalBottomLeft(size, delta);
    // final path = Path()
    //   ..lineTo(0.0, size.height - 2.5 * delta)
    //   ..lineTo(size.width, size.height)
    //   ..lineTo(size.width, 0.0)
    //   ..close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// [CretaDiagonalBottomRight], can be used with [ClipPath] widget, and clips the widget diagonally
class CretaDiagonalBottomRight extends CustomClipper<Path> {
  final double delta;
  CretaDiagonalBottomRight({this.delta = 1.0});
  @override
  Path getClip(Size size) {
    return ShapePath.digonalBottomRight(size, delta);
    // final path = Path()
    //   ..lineTo(0.0, size.height)
    //   ..lineTo(size.width, size.height - 2.5 * delta)
    //   ..lineTo(size.width, 0.0)
    //   ..close();
    // return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

/// Diagonal clipper with rounded borders
class CretaPeppleClipper1 extends CustomClipper<Path> {
  final double delta;

  CretaPeppleClipper1({this.delta = 1.0});

  @override
  Path getClip(Size size) {
    final path = Path();
    double radius = 2.5 * delta;

    path.moveTo(size.width - radius, size.height / 2);
    path.quadraticBezierTo(
      size.width - radius - 1 * delta,
      size.height - 1 * delta,
      size.width / 2,
      size.height - radius,
    );
    path.quadraticBezierTo(
      1 * delta,
      size.height - 1 * delta,
      radius,
      size.height / 2,
    );
    path.quadraticBezierTo(
      1 * delta,
      1 * delta,
      size.width / 2,
      radius,
    );
    path.quadraticBezierTo(
      size.width - 1 * delta,
      1 * delta,
      size.width - radius,
      size.height / 2,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CretaHeartClipper extends CustomClipper<Path> {
  final double delta;

  CretaHeartClipper({this.delta = 1.0});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, size.height * 0.15);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.05,
      size.width * 0.95,
      size.height * 0.3,
      size.width / 2,
      size.height * 0.9,
    );
    path.cubicTo(
      size.width * 0.05,
      size.height * 0.3,
      size.width * 0.2,
      size.height * 0.05,
      size.width / 2,
      size.height * 0.15,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CretaSnowManClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, size.height * 0.1);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.2,
      size.height * 0.4,
      size.width / 2,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.1,
      size.width / 2,
      size.height * 0.1,
    );

    path.moveTo(size.width / 2, size.height * 0.9);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.9,
      size.width * 0.7,
      size.height * 0.6,
      size.width / 2,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * 0.3,
      size.height * 0.6,
      size.width * 0.2,
      size.height * 0.9,
      size.width / 2,
      size.height * 0.9,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CretaLeafClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height * 0.6,
      size.width * 0.7,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width * 0.5,
      0,
    );
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.3,
      size.width * 0.3,
      size.height * 0.4,
    );
    path.quadraticBezierTo(
      0,
      size.height * 0.6,
      size.width / 2,
      size.height,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CretaCloverClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, 0);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.2,
      size.width * 0.4,
      size.height * 0.4,
      size.width / 2,
      size.height / 2,
    );
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.2,
      size.width / 2,
      0,
    );

    path.moveTo(size.width / 2, 0);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.2,
      size.width * 0.6,
      size.height * 0.4,
      size.width / 2,
      size.height / 2,
    );
    path.cubicTo(
      size.width * 0.4,
      size.height * 0.4,
      size.width * 0.2,
      size.height * 0.2,
      size.width / 2,
      0,
    );

    path.moveTo(size.width / 2, size.height);
    path.cubicTo(
      size.width * 0.2,
      size.height * 0.8,
      size.width * 0.4,
      size.height * 0.6,
      size.width / 2,
      size.height / 2,
    );
    path.cubicTo(
      size.width * 0.6,
      size.height * 0.6,
      size.width * 0.8,
      size.height * 0.8,
      size.width / 2,
      size.height,
    );

    path.moveTo(size.width / 2, size.height);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.8,
      size.width * 0.6,
      size.height * 0.6,
      size.width / 2,
      size.height / 2,
    );
    path.cubicTo(
      size.width * 0.4,
      size.height * 0.6,
      size.width * 0.2,
      size.height * 0.8,
      size.width / 2,
      size.height,
    );

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
