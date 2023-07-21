// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'creta_arrow_clipper.dart';
import 'shape_path.dart';

/// [CretaDirClipper] that can be used with [ClipPath] to clip widget in Dir shape

class CretaDirClipper extends CustomClipper<Path> {
  CretaDirClipper(this.triangleHeight, this.edge);

  /// The height of the triangle part of dir in the [edge] direction
  final double triangleHeight;

  /// The edge the dir points
  final CretaEdge edge;

  @override
  Path getClip(Size size) {
    switch (edge) {
      case CretaEdge.TOP:
        return ShapePath.dirUp(
          size,
          triangleHeight: triangleHeight,
        );
      case CretaEdge.RIGHT:
        return ShapePath.dirRight(
          size,
          triangleHeight: triangleHeight,
        );
      case CretaEdge.BOTTOM:
        return ShapePath.dirDown(
          size,
          triangleHeight: triangleHeight,
        );
      case CretaEdge.LEFT:
        return ShapePath.dirLeft(
          size,
          triangleHeight: triangleHeight,
        );
      default:
        return ShapePath.dirRight(
          size,
          triangleHeight: triangleHeight,
        );
    }
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    CretaDirClipper oldie = oldClipper as CretaDirClipper;
    return triangleHeight != oldie.triangleHeight || edge != oldie.edge;
  }
}
