// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:another_xlider/another_xlider.dart';
import 'package:hycop/common/util/logger.dart';

import '../creta_color.dart';

class CretaSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final void Function(double value) onDragComplete;

  const CretaSlider({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.onDragComplete,
  });

  @override
  State<CretaSlider> createState() => _CretaSliderState();
}

class _CretaSliderState extends State<CretaSlider> {
  bool hover = false;
  bool clicked = false;
  double _value = 0;

  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //return CupertinoSlider(
    // return Slider(
    //     inactiveColor: CretaColor.primary[100],
    //     min: widget.min,
    //     max: widget.max,
    //     value: _value,
    //     thumbColor: CretaColor.primary,
    //     onChanged: (value) {
    //       setState(() {
    //         _value = value;
    //         widget.onDragComplete(value);
    //       });
    //     });
    return MouseRegion(
      onExit: (val) {
        setState(() {
          hover = false;
        });
      },
      onEnter: (val) {
        setState(() {
          hover = true;
        });
      },
      child: FlutterSlider(
        //foregroundDecoration:
        //BoxDecoration(color: clicked ? CretaColor.primary[500] : CretaColor.primary),
        onDragStarted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            clicked = true;
          });
        },
        onDragCompleted: (handlerIndex, lowerValue, upperValue) {
          setState(() {
            _value = lowerValue;
            clicked = false;
            logger.finest("result=$handlerIndex,$lowerValue, $upperValue");
          });
          widget.onDragComplete(lowerValue);
        },
        values: [_value],
        max: widget.max,
        min: widget.min,
        handlerAnimation: FlutterSliderHandlerAnimation(
            curve: Curves.elasticOut,
            reverseCurve: Curves.bounceIn,
            duration: Duration(milliseconds: 500),
            scale: 1.2),
        handler: FlutterSliderHandler(
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.all(Radius.circular(hover ? 20 : 12)),
            shape: BoxShape.circle,
            color: hover
                ? clicked
                    ? CretaColor.primary[500]
                    : CretaColor.primary
                : Colors.white,
            border: Border.all(color: CretaColor.primary, width: 1.0),
          ),
          child: Container(),
        ),
        handlerHeight: hover ? 15 : 12,
        handlerWidth: hover ? 15 : 12,
      ),
    );
  }
}
