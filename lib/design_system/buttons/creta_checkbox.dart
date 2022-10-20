// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
//import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import '../creta_color.dart';
import '../creta_font.dart';

class CretaCheckbox extends StatefulWidget {
  final Map<dynamic, String> valueMap; // value and title map
  final void Function(dynamic value) onSelected;
  final dynamic defaultValue;
  final double density;

  const CretaCheckbox({
    super.key,
    required this.onSelected,
    required this.valueMap,
    required this.defaultValue,
    this.density = -2,
  });

  @override
  State<CretaCheckbox> createState() => _CretaCheckboxState();
}

class _CretaCheckboxState extends State<CretaCheckbox> {
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
      // child: SmartSelect<int>.multiple(

      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.valueMap.keys.map((value) {
          return ListTile(
            dense: true,
            minVerticalPadding: widget.density,
            visualDensity: VisualDensity(vertical: widget.density, horizontal: widget.density),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: RoundCheckBox(
              animationDuration: Duration(milliseconds: 200),
              size: 20,
              isChecked: value == selectedValue,
              checkedWidget: Icon(
                Icons.check_circle_outline_outlined,
                size: 20,
                color: CretaColor.primary,
              ),
              uncheckedWidget: Icon(
                Icons.circle_outlined,
                size: 20,
              ),
              border: null,
              borderColor: Colors.transparent,
              checkedColor: Colors.transparent,
              onTap: (v) {
                setState(() {
                  if (v!) {
                    selectedValue = value;
                    widget.onSelected(selectedValue);
                  }
                });
              },
            ),
            title: Text(
              widget.valueMap[value]!,
              style: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]!),
            ),
          );
        }).toList(),
      ),
    );
  }
}
