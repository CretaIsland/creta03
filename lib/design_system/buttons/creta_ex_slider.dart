import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../component/creta_proprty_slider.dart';
import '../creta_color.dart';
import '../creta_font.dart';
import '../text_field/creta_text_field.dart';
import 'creta_slider.dart';

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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: widget.height,
          width: widget.sliderWidth,
          child: CretaSlider(
            key: GlobalKey(),
            min: widget.min,
            max: widget.max,
            value: _makeValue(_value, widget.valueType),
            onDragComplete: (val) {
              setState(() {
                logger.finest('CretaSlider value=$val');
                _value = _reverseValue(val, widget.valueType);
              });
              widget.onChanngeComplete?.call(_value);
            },
            onDragging: (val) {
              _value = _reverseValue(val, widget.valueType);
              widget.onChannged.call(_value);
              //setState(() {});
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CretaTextField.xshortNumber(
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
              }),
            ),
            widget.postfix != null
                ? Text(widget.postfix!, style: CretaFont.bodySmall)
                : const Padding(padding: EdgeInsets.only(right: 12))
          ],
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
