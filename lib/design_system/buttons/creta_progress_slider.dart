// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:another_xlider/another_xlider.dart';
//import 'package:hycop/common/util/logger.dart';

//import 'package:creta_common/common/creta_color.dart';

class CretaProgressSlider extends StatefulWidget {
  final double? height;
  final double barThickness;
  final double min;
  final double max;
  final double value;
  final void Function(double value) onChanged;
  final void Function(double value)? onChangeStart;
  final void Function(double value)? onChangeEnd;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;

  const CretaProgressSlider({
    super.key,
    this.height,
    required this.barThickness,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
  });

  @override
  State<CretaProgressSlider> createState() => _CretaProgressSliderState();
}

class _CretaProgressSliderState extends State<CretaProgressSlider> {
  late double _value;
  bool mouseHover = false;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (val) {
        setState(() {
          mouseHover = true;
        });
      },
      onExit: (val) {
        setState(() {
          mouseHover = false;
        });
      },
      child: SizedBox(
        height: widget.height,
        //margin: EdgeInsets.fromLTRB(thumbRadius, 0, thumbRadius, 0),
        //padding: EdgeInsets.fromLTRB(0, _vertPaddingSize, 0, _vertPaddingSize),
        // decoration: BoxDecoration(
        //   // crop
        //   //borderRadius: BorderRadius.only(topLeft: Radius.circular(thumbRadius), bottomLeft: Radius.circular(thumbRadius)),
        //   color: Colors.transparent,
        // ),
        // clipBehavior: Clip.antiAlias,
        child: SliderTheme(
          data: SliderThemeData(
            //overlayShape: SliderComponentShape.noOverlay,
            trackHeight: widget.barThickness,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 0, //thumbRadius,
              //disabledThumbRadius: thumbRadius*2,
              elevation: 0,
              pressedElevation: 0,
            ),
            thumbColor: Colors.transparent, //mouseHover ? widget.thumbColor : Colors.transparent,
            activeTrackColor: widget.activeTrackColor,
            inactiveTrackColor: widget.inactiveTrackColor,
            overlayColor: Colors.transparent,
            disabledThumbColor:
                _value == widget.min ? widget.inactiveTrackColor : Colors.transparent,
            // overlappingShapeStrokeColor: Colors.transparent,
            // valueIndicatorColor: Colors.transparent,
            trackShape: CustomTrackShape(
              mouseHover: mouseHover,
              isMinValue: (_value == widget.min),
            ),
          ),
          child: Slider(
            //thumbColor: sliderMouseOver ? null : Colors.transparent,
            min: widget.min,
            max: widget.max,
            value: _value,
            onChanged: (value) {
              _value = value;
              widget.onChanged.call(value);
            },
            onChangeStart: widget.onChangeStart,
            onChangeEnd: widget.onChangeEnd,
          ),
        ),
      ),
    );
  }
}

// class CustomTrackShape extends RoundedRectSliderTrackShape {
//   @override
//   Rect getPreferredRect({
//     required RenderBox parentBox,
//     Offset offset = Offset.zero,
//     required SliderThemeData sliderTheme,
//     bool isEnabled = false,
//     bool isDiscrete = false,
//   }) {
//     final trackHeight = sliderTheme.trackHeight;
//     final trackLeft = offset.dx;
//     final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
//     final trackWidth = parentBox.size.width;
//     return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
//   }
// }

/// CustomTrackShape is copied from RoundedRectSliderTrackShape
///
class CustomTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  /// Create a slider track that draws two rectangles with rounded outer edges.
  final bool mouseHover;
  final bool isMinValue;
  const CustomTrackShape({
    required this.mouseHover,
    required this.isMinValue,
  });

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 2,
  }) {
    // assert(context != null);
    // assert(offset != null);
    // assert(parentBox != null);
    // assert(sliderTheme != null);
    assert(sliderTheme.disabledActiveTrackColor != null);
    assert(sliderTheme.disabledInactiveTrackColor != null);
    assert(sliderTheme.activeTrackColor != null);
    assert(sliderTheme.inactiveTrackColor != null);
    assert(sliderTheme.thumbShape != null);
    // assert(enableAnimation != null);
    // assert(textDirection != null);
    // assert(thumbCenter != null);
    // If the slider [SliderThemeData.trackHeight] is less than or equal to 0,
    // then it makes no difference whether the track is painted or not,
    // therefore the painting can be a no-op.
    if (sliderTheme.trackHeight == null || sliderTheme.trackHeight! <= 0) {
      return;
    }

    // Assign the track segment paints, which are leading: active and
    // trailing: inactive.
    final ColorTween activeTrackColorTween =
        ColorTween(begin: sliderTheme.disabledActiveTrackColor, end: sliderTheme.activeTrackColor);
    final ColorTween inactiveTrackColorTween = ColorTween(
        begin: sliderTheme.disabledInactiveTrackColor, end: sliderTheme.inactiveTrackColor);
    final Paint activePaint = Paint()..color = activeTrackColorTween.evaluate(enableAnimation)!;
    final Paint inactivePaint = Paint()..color = inactiveTrackColorTween.evaluate(enableAnimation)!;
    final Paint leftTrackPaint;
    final Paint rightTrackPaint;
    switch (textDirection) {
      case TextDirection.ltr:
        leftTrackPaint = activePaint;
        rightTrackPaint = inactivePaint;
        break;
      case TextDirection.rtl:
        leftTrackPaint = inactivePaint;
        rightTrackPaint = activePaint;
        break;
    }

    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    double dy = trackRect.height > (thumbCenter.dx - trackRect.left)
        ? (trackRect.height - (thumbCenter.dx - trackRect.left)) / 2
        : 0;
    final Radius trackRadius = Radius.circular(trackRect.height / 2);
    final Radius activeTrackRadius =
        Radius.circular((trackRect.height + additionalActiveTrackHeight) / 2);

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.rtl)
            ? trackRect.top - (additionalActiveTrackHeight / 2)
            : trackRect.top,
        trackRect.right,
        (textDirection == TextDirection.rtl)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2)
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
        bottomLeft: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
        topRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
        bottomRight: (textDirection == TextDirection.rtl) ? activeTrackRadius : trackRadius,
      ),
      rightTrackPaint,
    );

    context.canvas.drawRRect(
      RRect.fromLTRBAndCorners(
        trackRect.left,
        (textDirection == TextDirection.ltr)
            ? trackRect.top - (additionalActiveTrackHeight / 2) + dy
            : trackRect.top,
        thumbCenter.dx,
        (textDirection == TextDirection.ltr)
            ? trackRect.bottom + (additionalActiveTrackHeight / 2) - dy
            : trackRect.bottom,
        topLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
        bottomLeft: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
        topRight: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
        bottomRight: (textDirection == TextDirection.ltr) ? activeTrackRadius : trackRadius,
      ),
      leftTrackPaint,
    );

    final bool showSecondaryTrack = (secondaryOffset != null) &&
        ((textDirection == TextDirection.ltr)
            ? (secondaryOffset.dx > thumbCenter.dx)
            : (secondaryOffset.dx < thumbCenter.dx));

    if (showSecondaryTrack) {
      final ColorTween secondaryTrackColorTween = ColorTween(
          begin: sliderTheme.disabledSecondaryActiveTrackColor,
          end: sliderTheme.secondaryActiveTrackColor);
      final Paint secondaryTrackPaint = Paint()
        ..color = secondaryTrackColorTween.evaluate(enableAnimation)!;
      if (textDirection == TextDirection.ltr) {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            thumbCenter.dx,
            trackRect.top,
            secondaryOffset.dx,
            trackRect.bottom,
            topRight: trackRadius,
            bottomRight: trackRadius,
          ),
          secondaryTrackPaint,
        );
      } else {
        context.canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            secondaryOffset.dx,
            trackRect.top,
            thumbCenter.dx,
            trackRect.bottom,
            topLeft: trackRadius,
            bottomLeft: trackRadius,
          ),
          secondaryTrackPaint,
        );
      }
    }
  }
}
