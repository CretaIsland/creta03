// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../model/app_enums.dart';

class GradationIndicator extends StatefulWidget {
  final GradationType gradationType;
  final Color color1; //'assets/grid.png'
  final Color color2; //'assets/grid.png'
  final Function onTapPressed;
  final double width;
  final double height;
  const GradationIndicator({
    super.key,
    required this.gradationType,
    required this.color1,
    required this.color2,
    required this.onTapPressed,
    this.width = 24,
    this.height = 24,
  });

  @override
  State<GradationIndicator> createState() => _GradationIndicatorState();
}

class _GradationIndicatorState extends State<GradationIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        logger.finest('GradationIndicator clicked');
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(gradient: _gradient()),
      ),
    );
  }

  Gradient _gradient() {
    if (widget.gradationType == GradationType.cirle) {
      return RadialGradient(colors: [widget.color1, widget.color2]);
    }
    return LinearGradient(
        begin: _beginAlignment(), end: _endAlignment(), colors: [widget.color1, widget.color2]);
  }

  Alignment _beginAlignment() {
    switch (widget.gradationType) {
      case GradationType.top2bottom:
        return Alignment.topCenter;
      case GradationType.bottom2top:
        return Alignment.bottomCenter;
      case GradationType.left2right:
        return Alignment.centerLeft;
      case GradationType.right2left:
        return Alignment.centerRight;
      case GradationType.leftTop2rightBottom:
        return Alignment.topLeft;
      case GradationType.leftBottom2rightTop:
        return Alignment.bottomLeft;
      case GradationType.rightBottom2leftTop:
        return Alignment.bottomRight;
      case GradationType.rightTop2leftBottom:
        return Alignment.topRight;
      default:
        return Alignment.topLeft;
    }
  }

  Alignment _endAlignment() {
    switch (widget.gradationType) {
      case GradationType.top2bottom:
        return Alignment.bottomCenter;
      case GradationType.bottom2top:
        return Alignment.topCenter;
      case GradationType.left2right:
        return Alignment.centerRight;
      case GradationType.right2left:
        return Alignment.centerLeft;
      case GradationType.leftTop2rightBottom:
        return Alignment.bottomRight;
      case GradationType.leftBottom2rightTop:
        return Alignment.topRight;
      case GradationType.rightBottom2leftTop:
        return Alignment.topLeft;
      case GradationType.rightTop2leftBottom:
        return Alignment.bottomLeft;
      default:
        return Alignment.bottomRight;
    }
  }
}
