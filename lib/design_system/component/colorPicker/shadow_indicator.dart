// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class ShadowIndicator extends StatefulWidget {
  final Color color;
  final double spread;
  final double blur;
  final double direction;
  final double distance;
  final double opacity;
  final void Function(
    double spread,
    double blur, //'assets/grid.png'
    double direction, //'assets/grid.png'
    double distance,
    double opacity,
  ) onTapPressed;
  final double width;
  final double height;
  final bool isSelected;
  final String? hintText;
  final bool isSample;
  final bool showShadow;

  const ShadowIndicator({
    super.key,
    required this.color,
    required this.spread,
    required this.blur,
    required this.distance,
    required this.direction,
    required this.opacity,
    required this.onTapPressed,
    this.isSelected = false,
    this.width = 46,
    this.height = 46,
    this.hintText,
    this.isSample = false,
    this.showShadow = true,
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
            widget.opacity,
          );
        },
        child: widget.isSample
            ? _outShadow(widget.width, widget.height)
            : Container(
                width: widget.width + 8,
                height: widget.height + 8,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: widget.isSelected ? CretaColor.primary : Colors.white,
                    width: 2,
                  ),
                  //borderRadius: BorderRadius.all(Radius.circular(widget.distance)),
                ),
                child: Center(
                  child: Container(
                    width: widget.width,
                    height: widget.height,
                    color: CretaColor.text[200]!,
                    child: Center(
                      child: _outShadow(widget.width - 14, widget.height - 14),
                    ),
                  ),
                ),
              ));
  }

  Widget _outShadow(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (widget.showShadow)
            BoxShadow(
              color: widget.opacity == 1 ? widget.color : widget.color.withOpacity(widget.opacity),
              offset: CretaCommonUtils.getShadowOffset(widget.direction, widget.distance / 3),
              blurRadius: widget.blur,
              spreadRadius: widget.spread / 10,
              //blurStyle: widget.shadowIn ? BlurStyle.inner : BlurStyle.normal,
            ),
        ],
      ),
      child: widget.hintText != null
          ? Center(
              child:
                  Text(widget.hintText!, textAlign: TextAlign.center, style: CretaFont.titleTiny))
          : SizedBox.shrink(),
    );
  }

  // Widget _inShadow(double width, double height) {
  //   return InnerShadow(
  //     shadows: [
  //       Shadow(
  //         blurRadius: widget.blur > 0 ? widget.blur : widget.spread,
  //         color: widget.opacity == 1 ? widget.color : widget.color.withOpacity(widget.opacity),
  //         offset: CretaCommonUtils.getShadowOffset((180 + widget.direction) % 360, widget.distance),
  //       ),
  //     ],
  //     child: Container(
  //       width: width,
  //       height: height,
  //       color: Colors.white,
  //       child: widget.hintText != null
  //           ? Center(
  //               child: Text(widget.hintText!,
  //                   textAlign: TextAlign.center, style: CretaFont.bodyESmall))
  //           : SizedBox.shrink(),
  //     ),
  //   );
  // }
}
