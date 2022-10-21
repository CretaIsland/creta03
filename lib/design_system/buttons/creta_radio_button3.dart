// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hycop/common/util/logger.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class CretaRadioButton3 extends StatefulWidget {
  final Map<dynamic, String> valueMap; // value and title map
  final void Function(dynamic value) onSelected;
  final dynamic defaultValue;
  final double density;

  const CretaRadioButton3({
    super.key,
    required this.onSelected,
    required this.valueMap,
    required this.defaultValue,
    this.density = -4,
  });

  @override
  State<CretaRadioButton3> createState() => _CretaRadioButton3State();
}

class _CretaRadioButton3State extends State<CretaRadioButton3> {
  TextEditingController controller = TextEditingController();
  bool hover = false;
  late dynamic selectedValue;
  @override
  void initState() {
    super.initState();
    selectedValue = "Jennie";
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
        child: RadioGroup<String>.builder(
          items: widget.valueMap.values.toList(),
          textStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]!),
          onChanged: (value) {
            logger.finest("Button value $value");
            selectedValue = value;
            widget.onSelected(selectedValue);
          },
          itemBuilder: (item) => RadioButtonBuilder(
            item,
          ),
          //customShape: ShapeBorder(),
          groupValue: selectedValue,
          activeColor: CretaColor.primary,
        ),
      ),
    );
  }
}
