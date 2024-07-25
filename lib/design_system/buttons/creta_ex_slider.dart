import 'package:flutter/cupertino.dart';
import 'package:expandable_slider/expandable_slider.dart';
import 'package:hycop/common/util/logger.dart';

//import '../component/creta_cupertino_slider.dart';
import '../component/creta_proprty_slider.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../text_field/creta_text_field.dart';

class CretaExSlider extends StatefulWidget {
  //final String name;
  final SliderValueType valueType;
  final double value;
  final double min;
  final double max;
  final void Function(double) onChannged;
  final String? postfix;
  final void Function(double)? onChanngeComplete;

  final double height;
  final double sliderWidth;
  final double textWidth;
  final int textlimit;
  final CretaTextFieldType textType;
  final bool isActive;

  const CretaExSlider({
    super.key,
    //required this.name,
    required this.valueType,
    required this.value,
    required this.min,
    required this.max,
    required this.onChannged,
    this.onChanngeComplete,
    this.postfix,
    this.height = 22,
    this.sliderWidth = 168,
    this.textWidth = 40,
    this.textlimit = 3,
    this.textType = CretaTextFieldType.number,
    this.isActive = true,
  });

  @override
  State<CretaExSlider> createState() => _CretaExSliderState();
}

class _CretaExSliderState extends State<CretaExSlider> {
  //TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  double _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(CretaExSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
      //setState(() {});
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Widget slider = ExpandableSlider.adaptive(
      expandsOnLongPress: false,
      expandsOnScale: false,
      expandsOnDoubleTap: true,
      value: _makeValue(_value, widget.valueType),
      onChangeEnd: (val) {
        // setState(() {
        //   logger.finest('CretaSlider value=$val');
        //   _value = _reverseValue(val, widget.valueType);
        // });
        widget.onChanngeComplete?.call(_value);
      },
      onChanged: (val) {
        _value = _reverseValue(val, widget.valueType);
        setState(() {});
        widget.onChannged.call(_value);
      },
      min: widget.min,
      max: widget.max,
      estimatedValueStep: 1,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: widget.height,
          width: widget.sliderWidth,
          child: (widget.isActive == true)
              ? slider
              : Stack(
                  children: [
                    slider,
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                          height: widget.height,
                          width: widget.sliderWidth,
                          color: CretaColor.text[100]!.withOpacity(0.2)),
                    ),
                  ],
                ),

          //  CretaCupertinoSlider(
          //   //CretaSlider(
          //   key: GlobalKey(),
          //   min: widget.min,
          //   max: widget.max,
          //   thumbColor: CretaColor.primary,
          //   value: _makeValue(_value, widget.valueType),
          //   //onDragComplete: (val) {
          //   onChangeEnd: (val) {
          //     setState(() {
          //       logger.finest('CretaSlider value=$val');
          //       _value = _reverseValue(val, widget.valueType);
          //     });
          //     widget.onChanngeComplete?.call(_value);
          //   },
          //   //onDragging: (val) {
          //   onChanged: (val) {
          //     _value = _reverseValue(val, widget.valueType);
          //     if (widget.delay > 0 && CretaCommonUtils.hasTimePassed(_lastTime!, widget.delay)) {
          //       widget.onChannged.call(_value);
          //       _lastTime = DateTime.now();
          //     } else {
          //       widget.onChannged.call(_value);
          //     }
          //     setState(() {});
          //   },
          // ),
        ),
        RepaintBoundary(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              widget.textType == CretaTextFieldType.number
                  ? CretaTextField.xshortNumber(
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: widget.textWidth,
                      limit: widget.textlimit,
                      textFieldKey: GlobalKey(),
                      value: _makeValueString(_value, widget.valueType),
                      hintText: '',
                      onEditComplete: ((value) {
                        setState(() {
                          _value = _reverseValue(int.parse(value).toDouble(), widget.valueType);
                          widget.onChannged(_value);
                        });
                        widget.onChanngeComplete?.call(_value);
                      }),
                    )
                  : CretaTextField.double(
                      defaultBorder: Border.all(color: CretaColor.text[100]!),
                      width: widget.textWidth,
                      limit: widget.textlimit,
                      textFieldKey: GlobalKey(),
                      value: '$_value',
                      hintText: '',
                      onEditComplete: ((value) {
                        setState(() {
                          _value = double.parse(value);
                          widget.onChannged(_value);
                        });
                        widget.onChanngeComplete?.call(_value);
                      }),
                    ),
              widget.postfix != null
                  ? Text(widget.postfix!, style: CretaFont.bodySmall)
                  : const Padding(padding: EdgeInsets.only(right: 12))
            ],
          ),
        ),
      ],
    );
  }

  String _makeValueString(double value, SliderValueType aType) {
    logger.finest('_makeValueString($value)');
    switch (aType) {
      case SliderValueType.percent:
        return '${(value * 100).round()}';
      case SliderValueType.reverse:
        return '${((1 - value) * 100).round()}';
      default:
        return '${value.round()}';
    }
  }

  // ignore: unused_element
  double _makeValue(double value, SliderValueType aType) {
    logger.finest('_makeValue($value)');
    switch (aType) {
      case SliderValueType.percent:
        return (value * 100);
      case SliderValueType.reverse:
        return (1 - value) * 100;
      default:
        return value;
    }
  }

  double _reverseValue(double value, SliderValueType aType) {
    logger.finest('_reverseValue($value)');
    switch (aType) {
      case SliderValueType.percent:
        return (value / 100);
      case SliderValueType.reverse:
        return (1 - value / 100);
      default:
        return value;
    }
  }
}
