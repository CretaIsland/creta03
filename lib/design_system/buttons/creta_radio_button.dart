// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class CretaRadioButton extends StatefulWidget {
  final Map<String, dynamic> valueMap; // title and value map
  final void Function(String name, dynamic value) onSelected;
  final dynamic defaultTitle;
  final double spacebetween;
  final Axis direction;
  final EdgeInsets padding;

  const CretaRadioButton({
    super.key,
    required this.onSelected,
    required this.valueMap,
    required this.defaultTitle,
    this.spacebetween = 30,
    this.direction = Axis.vertical,
    this.padding = const EdgeInsets.all(20.0),
  });

  @override
  State<CretaRadioButton> createState() => _CretaRadioButtonState();
}

class _CretaRadioButtonState extends State<CretaRadioButton> {
  TextEditingController controller = TextEditingController();
  //bool hover = false;
  late dynamic selectedTitle;
  @override
  void initState() {
    super.initState();
    selectedTitle = widget.defaultTitle;
  }

  @override
  void didUpdateWidget(CretaRadioButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.defaultTitle != widget.defaultTitle) {
      selectedTitle = widget.defaultTitle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // MouseRegion(
        //   onExit: (val) {
        //     setState(() {
        //       hover = false;
        //     });
        //   },
        //   onEnter: (val) {
        //     setState(() {
        //       hover = true;
        //     });
        //   },
        //   child:
        Container(
            padding: widget.padding,
            width: MediaQuery.of(context).size.width,
            //height: 250,
            child: RadioGroup<dynamic>.builder(
              // itemPadding: 5.0,
              // iconPadding: 15.0,
              items: widget.valueMap.keys.toList(),
              textStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[700]!),
              // spacebetween: widget.spacebetween,
              onChanged: (title) {
                setState(() {
                  logger.finest("Button title $title");
                  selectedTitle = title;
                  widget.onSelected(selectedTitle, widget.valueMap[selectedTitle]!);
                });
              },
              itemBuilder: (item) {
                return RadioButtonBuilder(item, textPosition: RadioButtonTextPosition.right);
              },
              //customShape: ShapeBorder(),
              groupValue: selectedTitle,
              activeColor: CretaColor.primary,
              direction: widget.direction,
            )
            //),
            );
  }
}
