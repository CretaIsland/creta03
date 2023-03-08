// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

import '../../../common/creta_utils.dart';
import '../../creta_color.dart';

class ShadowIndicator extends StatefulWidget {
  final double spread;
  final double blur;
  final double direction;
  final double distance;
  final bool shadowIn;
  final void Function(
    double spread,
    double blur, //'assets/grid.png'
    double direction, //'assets/grid.png'
    double distance,
    bool shadowIn,
  ) onTapPressed;
  final double width;
  final double height;
  final bool isSelected;
  const ShadowIndicator({
    super.key,
    required this.spread,
    required this.blur,
    required this.direction,
    required this.onTapPressed,
    required this.shadowIn,
    this.isSelected = false,
    this.width = 54,
    this.height = 54,
    this.distance = 4,
  });

  @override
  State<ShadowIndicator> createState() => _ShadowIndicatorState();
}

class _ShadowIndicatorState extends State<ShadowIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onTapPressed(
            widget.spread,
            widget.blur,
            widget.direction,
            widget.distance,
            widget.shadowIn,
          );
        },
        child: Container(
          width: widget.width + 8,
          height: widget.height + 8,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: widget.isSelected ? CretaColor.primary : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(widget.distance)),
          ),
          child: Center(
            child: Container(
              width: widget.width,
              height: widget.height,
              color: CretaColor.text[200]!,
              child: Center(
                child: widget.shadowIn ? _inShadow() : _outShadow(),
              ),
            ),
          ),
        ));
  }

  Widget _outShadow() {
    return Container(
      width: widget.width - 22,
      height: widget.height - 22,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            offset: CretaUtils.getShadowOffset(widget.direction, widget.distance),
            blurRadius: widget.blur,
            spreadRadius: widget.spread,
            //blurStyle: widget.shadowIn ? BlurStyle.inner : BlurStyle.normal,
          ),
        ],
      ),
    );
  }

  Widget _inShadow() {
    return InnerShadow(
      shadows: [
        Shadow(
          blurRadius: widget.blur > 0 ? widget.blur : widget.spread,
          color: Colors.black.withOpacity(0.5),
          offset: CretaUtils.getShadowOffset((180 + widget.direction) % 360, widget.distance),
        ),
      ],
      child: Container(
        width: widget.width - 22,
        height: widget.height - 22,
        color: Colors.white,
      ),
    );
  }
}
