// // ignore_for_file: prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';

import '../../../model/app_enums.dart';
import 'creta_clipper.dart';

class DiamondContainer extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final Widget? child;

  const DiamondContainer({
    Key? key,
    required this.width,
    required this.height,
    required this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CretaClipper(mid: ShapeType.diamond.name, shapeType: ShapeType.diamond),
      child: Container(
        width: width,
        height: height,
        color: color,
        child: child,
      ),
    );
  }
}