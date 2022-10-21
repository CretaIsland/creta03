// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
//import 'package:elegant_radio_button_group/elegant_radio_button_group.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

import '../creta_color.dart';
//import '../creta_color.dart';
//import '../creta_font.dart';

class CretaRadioButton2 extends StatefulWidget {
  final Map<dynamic, String> valueMap; // value and title map
  final void Function(dynamic value) onSelected;
  final dynamic defaultValue;
  final double density;

  const CretaRadioButton2({
    super.key,
    required this.onSelected,
    required this.valueMap,
    required this.defaultValue,
    this.density = -4,
  });

  @override
  State<CretaRadioButton2> createState() => _CretaRadioButton2State();
}

class _CretaRadioButton2State extends State<CretaRadioButton2> {
  TextEditingController controller = TextEditingController();
  bool hover = false;
  late dynamic selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = widget.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
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
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        height: 250,
        child: CustomRadioButton(
          buttonLables: widget.valueMap.values.toList(),
          buttonValues: widget.valueMap.keys.toList(),
          radioButtonValue: (value, index) {
            logger.finest("Button value $value");
            logger.finest("Integer value $index");
            widget.onSelected(index);
          },
          //customShape: ShapeBorder(),
          elevation: 0,
          enableShape: true,
          buttonSpace: 5,
          buttonColor: CretaColor.text[200]!,
          selectedColor: CretaColor.primary,
        ),
      ),
    );
  }
}
