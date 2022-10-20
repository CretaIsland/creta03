// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:elegant_radio_button_group/elegant_radio_button_group.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class CretaRadioButton extends StatefulWidget {
  final Map<dynamic, String> valueMap; // value and title map
  final void Function(dynamic value) onSelected;
  final dynamic defaultValue;
  final double density;

  const CretaRadioButton({
    super.key,
    required this.onSelected,
    required this.valueMap,
    required this.defaultValue,
    this.density = -4,
  });

  @override
  State<CretaRadioButton> createState() => _CretaRadioButtonState();
}

class _CretaRadioButtonState extends State<CretaRadioButton> {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.valueMap.keys.map((value) {
          return ListTile(
            dense: true,
            minVerticalPadding: widget.density,
            visualDensity: VisualDensity(vertical: widget.density, horizontal: widget.density),
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            leading: ElegantRadioButton<int>(
              fillColor: MaterialStateProperty.all(CretaColor.primary),
              value: value,
              visualDensity: VisualDensity(vertical: widget.density, horizontal: widget.density),
              groupValue: selectedValue,
              hoverColor: CretaColor.primary[100]!,
              splashRadius: 12.0,
              onChanged: (v) {
                setState(() {
                  selectedValue = v!;
                  widget.onSelected(selectedValue);
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
