import 'package:creta03/design_system/component/shape/shape_path.dart';
import 'package:flutter/widgets.dart';

/// Clip widget in star shape
class CretaStarClipper extends CustomClipper<Path> {
  CretaStarClipper(this.numberOfPoints, {this.offset = Offset.zero});

  /// The number of points of the star
  final int numberOfPoints;
  final Offset offset;

  @override
  Path getClip(Size size) {
    return ShapePath.polyStar(size, numberOfPoints);
  }

  //num _degToRad(num deg) => deg * (math.pi / 180.0);

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    CretaStarClipper oldie = oldClipper as CretaStarClipper;
    return numberOfPoints != oldie.numberOfPoints;
  }
}
