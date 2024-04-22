import 'package:flutter/material.dart';

import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/common/creta_color.dart';
import '../text_field/creta_text_field.dart';

class TimeInputWidget extends StatefulWidget {
  final void Function(Duration duration) onValueChnaged;
  final int initValue;
  final TextStyle textStyle;
  final double textWidth;

  const TimeInputWidget({
    super.key,
    required this.onValueChnaged,
    required this.initValue,
    required this.textStyle,
    this.textWidth = 45,
  });

  @override
  TimeInputWidgetState createState() => TimeInputWidgetState();
}

class TimeInputWidgetState extends State<TimeInputWidget> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;

  @override
  void initState() {
    int seconds = widget.initValue;

    _hours = seconds ~/ 3600;
    _minutes = (seconds % 3600) ~/ 60;
    _seconds = seconds % 60;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTimeInputField(CretaLang['hours']!, _hours, (value) {
          setState(() {
            _hours = int.parse(value);
          });
          widget.onValueChnaged.call(duration);
        }),
        _buildTimeInputField(CretaLang['minutes']!, _minutes, (value) {
          setState(() {
            _minutes = int.parse(value);
          });
          widget.onValueChnaged.call(duration);
        }),
        _buildTimeInputField(CretaLang['seconds']!, _seconds, (value) {
          setState(() {
            _seconds = int.parse(value);
          });
          widget.onValueChnaged.call(duration);
        }),
      ],
    );
  }

  Widget _buildTimeInputField(String label, int value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            label,
            style: widget.textStyle,
          ),
          CretaTextField.xshortNumber(
            defaultBorder: Border.all(color: CretaColor.text[100]!),
            width: widget.textWidth,
            limit: 5,
            textFieldKey: GlobalKey(),
            value: value.toString(),
            hintText: '',
            onEditComplete: onChanged,
            minNumber: 0,
          ),
        ],
      ),
    );
  }

  Duration get duration {
    return Duration(
      hours: _hours,
      minutes: _minutes,
      seconds: _seconds,
    );
  }
}
