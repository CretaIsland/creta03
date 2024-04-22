// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:creta_common/model/app_enums.dart';
import '../../../pages/studio/studio_snippet.dart';
import 'package:creta_common/common/creta_color.dart';

class GradationIndicator extends StatefulWidget {
  final GradationType gradationType;
  final Color color1; //'assets/grid.png'
  final Color color2; //'assets/grid.png'
  final void Function(GradationType value, Color color1, Color color2) onTapPressed;
  final double width;
  final double height;
  final bool isSelected;
  final double radius;
  const GradationIndicator({
    super.key,
    required this.gradationType,
    required this.color1,
    required this.color2,
    required this.onTapPressed,
    this.isSelected = false,
    this.width = 24,
    this.height = 24,
    this.radius = 4,
  });

  @override
  State<GradationIndicator> createState() => _GradationIndicatorState();
}

class _GradationIndicatorState extends State<GradationIndicator> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          widget.onTapPressed(widget.gradationType, widget.color1, widget.color2);
        },
        child: Container(
          width: widget.width + 8,
          height: widget.height + 8,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: widget.isSelected
                  ? CretaColor.primary
                  : widget.color2 == Colors.white && widget.color1 == Colors.white
                      ? CretaColor.text[200]!
                      : Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          ),
          child: Center(
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: widget.gradationType == GradationType.none
                  ? BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                      color: Colors.white,
                      border: _getBorder(),
                    )
                  : BoxDecoration(
                      gradient: StudioSnippet.gradient(
                          widget.gradationType, widget.color1, widget.color2),
                      borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                      color: widget.gradationType == GradationType.none ? widget.color1 : null,
                    ),
              // child: widget.gradationType == GradationType.none
              //     ? Center(
              //         child: Text(CretaStudioLang['nothing']!,
              //             textAlign: TextAlign.center, style: CretaFont.titleSmall),
              //       )
              //     : null,
            ),
          ),
        ));
  }

  BoxBorder _getBorder() {
    return Border.all(
      color: CretaColor.text[400]!,
      width: 2,
      style: BorderStyle.solid,
    );
  }
}
