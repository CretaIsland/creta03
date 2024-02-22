import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../buttons/creta_checkbox.dart';
import '../buttons/creta_ex_slider.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

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
    return propertyLine(
      name: widget.name,
      widget: CretaExSlider(
        min: widget.min,
        max: widget.max,
        value: _value,
        valueType: widget.valueType,
        onChannged: widget.onChannged,
        onChanngeComplete: widget.onChanngeComplete,
        postfix: widget.postfix,
      ),
    );
    // return _propertyLine2(
    //   name: widget.name,
    //   widget1: SizedBox(
    //     height: 22,
    //     width: 168,
    //     child: CretaSlider(
    //       key: GlobalKey(),
    //       min: widget.min,
    //       max: widget.max,
    //       value: _makeValue(_value, widget.valueType),
    //       onDragComplete: (val) {
    //         setState(() {
    //           logger.finest('CretaSlider value=$val');
    //           _value = _reverseValue(val, widget.valueType);
    //         });
    //         widget.onChanngeComplete?.call(_value);
    //       },
    //       onDragging: (val) {
    //         // DateTime now = DateTime.now();
    //         // if (_lastUpdateTime.difference(now).inMilliseconds.abs() >= 100) {
    //         //   print('2222222222222222222222222222222222222222222222222');
    //         //   _value = _reverseValue(val, widget.valueType);
    //         //   widget.onChannged.call(_value);
    //         //   _onChangedInvoked = true;
    //         //   _lastUpdateTime = now;
    //         // } else {
    //         //   _onChangedInvoked = false;
    //         // }
    //       },
    //     ),
    //   ),
    //   widget2: Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       CretaTextField.xshortNumber(
    //         defaultBorder: Border.all(color: CretaColor.text[100]!),
    //         width: 40,
    //         limit: 3,
    //         textFieldKey: GlobalKey(),
    //         value: _makeValueString(_value, widget.valueType),
    //         hintText: '',
    //         onEditComplete: ((value) {
    //           setState(() {
    //             _value = _reverseValue(int.parse(value).toDouble(), widget.valueType);
    //             widget.onChannged(_value);
    //           });
    //         }),
    //       ),
    //       if (widget.postfix != null) Text(widget.postfix!, style: CretaFont.bodySmall),
    //       // const Padding(padding: EdgeInsets.only(right: 12))
    //     ],
    //   ),
    // );
  }

  // ignore: unused_element
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

  // ignore: unused_element
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

  // ignore: unused_element
  Widget _propertyLine2({
    required String name,
    required Widget widget1,
    required Widget widget2,
    double topPadding = 20.0,
    double nameWidth = 84,
    double widget1Width = 168,
    double widget2Width = 53,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: nameWidth, child: Text(name, style: titleStyle)),
          //const SizedBox(width: 20),
          SizedBox(width: widget1Width, child: widget1),
          SizedBox(width: widget2Width, child: widget2),
        ],
      ),
    );
  }

  Widget propertyLine({
    required String name,
    required Widget widget,
    double topPadding = 20.0,
    bool hasCheckBox = false,
    bool isSelected = false,
    void Function(String, bool, Map<String, bool>)? onCheck,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          hasCheckBox
              ? CretaCheckbox(
                  valueMap: {
                    name: isSelected,
                  },
                  onSelected: onCheck ?? (name, isChecked, valueMap) {},
                )
              : Text(name, style: titleStyle),
          widget,
        ],
      ),
    );
  }
}
