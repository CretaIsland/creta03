import 'package:flutter/material.dart';

import '../buttons/creta_slider.dart';
import '../creta_color.dart';
import '../creta_font.dart';
import '../text_field/creta_text_field.dart';

enum SliderValueType {
  normal,
  percent,
  reverse,
}

class CretaPropertySlider extends StatefulWidget {
  final String name;
  final SliderValueType valueType;
  final double value;
  final double min;
  final double max;
  final void Function(double) onChannged;
  final String? postfix;
  final void Function(double)? onChanngeComplete;

  const CretaPropertySlider({
    super.key,
    required this.name,
    required this.valueType,
    required this.value,
    required this.min,
    required this.max,
    required this.onChannged,
    this.onChanngeComplete,
    this.postfix,
  });

  @override
  State<CretaPropertySlider> createState() => _CretaPropertySliderState();
}

class _CretaPropertySliderState extends State<CretaPropertySlider> {
  TextStyle titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
  double _value = 0;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return _propertyLine2(
      name: widget.name,
      widget1: SizedBox(
        height: 22,
        width: 168,
        child: CretaSlider(
          key: GlobalKey(),
          min: widget.min,
          max: widget.max,
          value: _value,
          onDragComplete: (val) {
            widget.onChanngeComplete?.call(val);
            setState(() {
              _value = val;
            });
          },
          onDragging: (val) {
            _value = val;
            widget.onChannged.call(val);
          },
        ),
      ),
      widget2: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CretaTextField.xshortNumber(
            defaultBorder: Border.all(color: CretaColor.text[100]!),
            width: 40,
            limit: 3,
            textFieldKey: GlobalKey(),
            value: _makeValueString(_value, widget.valueType),
            hintText: '',
            onEditComplete: ((value) {
              double val = int.parse(value).toDouble();
              widget.onChannged(val);
            }),
          ),
          widget.postfix != null
              ? Text(widget.postfix!, style: CretaFont.bodySmall)
              : const Padding(padding: EdgeInsets.only(right: 12))
        ],
      ),
    );
  }

  String _makeValueString(double value, SliderValueType aType) {
    switch (aType) {
      case SliderValueType.percent:
        return '${(value * 100).round()}';
      case SliderValueType.reverse:
        return '${((1 - value) * 100).round()}';
      default:
        return '${value.round()}';
    }
  }

  Widget _propertyLine2({
    required String name,
    required Widget widget1,
    required Widget widget2,
    double topPadding = 20.0,
    double nameWidth = 84,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: nameWidth, child: Text(name, style: titleStyle)),
          widget1,
          widget2,
        ],
      ),
    );
  }
}
