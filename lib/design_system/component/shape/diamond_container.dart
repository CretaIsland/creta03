// // ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

import 'package:creta_common/model/app_enums.dart';
import 'creta_clipper.dart';

class DiamondContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget? child;
  final double applyScale;

  const DiamondContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    required this.applyScale,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CretaClipper(
          mid: ShapeType.diamond.name, shapeType: ShapeType.diamond, applyScale: applyScale),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: child,
      ),
    );
  }
}
