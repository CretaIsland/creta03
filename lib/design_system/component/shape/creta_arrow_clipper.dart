// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'shape_path.dart';

enum CretaEdge { TOP, RIGHT, BOTTOM, LEFT }

/// [CretaArrowClipper] that can be used with [ClipPath] to clip widget in Arrow shape

class CretaArrowClipper extends CustomClipper<Path> {
  CretaArrowClipper(this.triangleHeight, this.rectangleClipHeight, this.edge);

  /// The height of the triangle part of arrow in the [edge] direction
  final double triangleHeight;

  /// The height of the rectangle part of arrow that is clipped
  final double rectangleClipHeight;

  /// The edge the arrow points
  final CretaEdge edge;

  @override
  Path getClip(Size size) {
    switch (edge) {
      case CretaEdge.TOP:
        return ShapePath.arrowUp(
          size,
          triangleHeight: triangleHeight,
          rectangleClipHeight: rectangleClipHeight,
        );
      case CretaEdge.RIGHT:
        return ShapePath.arrowRight(
          size,
          triangleHeight: triangleHeight,
          rectangleClipHeight: rectangleClipHeight,
        );
      case CretaEdge.BOTTOM:
        return ShapePath.arrowDown(
          size,
          triangleHeight: triangleHeight,
          rectangleClipHeight: rectangleClipHeight,
        );
      case CretaEdge.LEFT:
        return ShapePath.arrowLeft(
          size,
          triangleHeight: triangleHeight,
          rectangleClipHeight: rectangleClipHeight,
        );
      default:
        return ShapePath.arrowRight(
          size,
          triangleHeight: triangleHeight,
          rectangleClipHeight: rectangleClipHeight,
        );
    }
  }

  // Path _getTopPath(Size size) {
  //   var path = Path();
  //   path.moveTo(0.0, triangleHeight);
  //   path.lineTo(rectangleClipHeight, triangleHeight);
  //   path.lineTo(rectangleClipHeight, size.height);
  //   path.lineTo(size.width - rectangleClipHeight, size.height);
  //   path.lineTo(size.width - rectangleClipHeight, triangleHeight);
  //   path.lineTo(size.width, triangleHeight);
  //   path.lineTo(size.width / 2, 0.0);
  //   path.close();
  //   return path;
  // }

  // Path _getRightPath(Size size) {
  //   var path = Path();
  //   path.moveTo(0.0, rectangleClipHeight);
  //   path.lineTo(size.width - triangleHeight, rectangleClipHeight);
  //   path.lineTo(size.width - triangleHeight, 0.0);
  //   path.lineTo(size.width, size.height / 2);
  //   path.lineTo(size.width - triangleHeight, size.height);
  //   path.lineTo(size.width - triangleHeight, size.height - rectangleClipHeight);
  //   path.lineTo(0.0, size.height - rectangleClipHeight);
  //   path.close();
  //   return path;
  // }

  // Path _getBottomPath(Size size) {
  //   var path = Path();
  //   path.moveTo(rectangleClipHeight, 0.0);
  //   path.lineTo(rectangleClipHeight, size.height - triangleHeight);
  //   path.lineTo(0.0, size.height - triangleHeight);
  //   path.lineTo(size.width / 2, size.height);
  //   path.lineTo(size.width, size.height - triangleHeight);
  //   path.lineTo(size.width - rectangleClipHeight, size.height - triangleHeight);
  //   path.lineTo(size.width - rectangleClipHeight, 0.0);
  //   path.close();
  //   return path;
  // }

  // Path _getLeftPath(Size size) {
  //   var path = Path();
  //   path.moveTo(0.0, size.height / 2);
  //   path.lineTo(triangleHeight, size.height);
  //   path.lineTo(triangleHeight, size.height - rectangleClipHeight);
  //   path.lineTo(size.width, size.height - rectangleClipHeight);
  //   path.lineTo(size.width, rectangleClipHeight);
  //   path.lineTo(triangleHeight, rectangleClipHeight);
  //   path.lineTo(triangleHeight, 0.0);
  //   path.close();
  //   return path;
  // }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    CretaArrowClipper oldie = oldClipper as CretaArrowClipper;
    return triangleHeight != oldie.triangleHeight ||
        rectangleClipHeight != oldie.rectangleClipHeight ||
        edge != oldie.edge;
  }
}
