// ignore_for_file: prefer_const_constructors

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

enum CretaDropDownType { normal, small, large }

class CretaDropDown extends StatefulWidget {
  final List<String> items;
  final String defaultValue;
  final void Function(String value) onSelected;
  final double width;
  final double height;
  final CretaDropDownType dropDownType;

  const CretaDropDown({
    super.key,
    required this.items,
    required this.defaultValue,
    required this.onSelected,
    this.width = 93,
    this.height = 30,
    this.dropDownType = CretaDropDownType.normal,
  });

  const CretaDropDown.small({
    super.key,
    required this.items,
    required this.defaultValue,
    required this.onSelected,
    this.width = 74,
    this.height = 28,
    this.dropDownType = CretaDropDownType.small,
  });

  const CretaDropDown.large({
    super.key,
    required this.items,
    required this.defaultValue,
    required this.onSelected,
    this.width = 117,
    this.height = 32,
    this.dropDownType = CretaDropDownType.large,
  });

  @override
  State<CretaDropDown> createState() => _CretaDropDownState();
}

class _CretaDropDownState extends State<CretaDropDown> {
  bool hover = false;
  bool clicked = false;
  String? selectedItem;

  @override
  void initState() {
    selectedItem = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          logger.finest('hover is false');
          hover = false;
          //clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          logger.finest('hover is true');
          hover = true;
        });
      },
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            clicked = true;
          });
        },
        //width: widget.width,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton2(
              onMenuStateChange: (val) {
                setState(() {
                  if (val == false) {
                    clicked = false;
                  }
                });
              },
              alignment: AlignmentDirectional.center,
              value: selectedItem,
              isExpanded: true,
              items: widget.items.map((item) {
                return DropdownMenuItem<String>(
                  alignment: AlignmentDirectional.center,
                  value: item,
                  child: Text(
                    item,
                    style: widget.dropDownType == CretaDropDownType.normal
                        ? CretaFont.bodySmall
                            .copyWith(overflow: TextOverflow.ellipsis, color: CretaColor.text[700]!)
                        : CretaFont.bodyESmall.copyWith(
                            overflow: TextOverflow.ellipsis, color: CretaColor.text[700]!),
                  ),
                );
              }).toList(),
              // decoration: InputDecoration(
              //   enabledBorder: OutlineInputBorder(
              //     borderRadius: BorderRadius.circular(8),
              //     borderSide: const BorderSide(
              //       width: 1,
              //       color: CretaColor.primary,
              //     ),
              //   ),
              // ),

              onChanged: (value) {
                setState(() {
                  clicked = false;
                  selectedItem = value;
                  widget.onSelected(selectedItem!);
                });
              },
              icon: Icon(
                Icons.arrow_drop_down_outlined,
              ),
              iconSize: 12,
              iconEnabledColor: CretaColor.text[700]!,
              buttonHeight: widget.height,
              buttonWidth: widget.width,
              buttonPadding: const EdgeInsets.only(left: 10, right: 10),
              buttonDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: clicked
                    ? Border.all(width: 1, color: CretaColor.primary)
                    : hover
                        ? Border.all(width: 1, color: CretaColor.text[200]!)
                        : null,
                color: Colors.white,
              ),
              buttonElevation: 0,
              itemHeight: widget.height,
              itemPadding: const EdgeInsets.only(left: 10, right: 10),
              dropdownWidth: widget.width,
              dropdownMaxHeight: widget.height * (widget.items.length + 2),
              dropdownPadding: null,
              dropdownElevation: 0,
              dropdownDecoration: BoxDecoration(
                border: Border.all(width: 1, color: CretaColor.text[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              offset: Offset(0, -8),
            ),
          ),
        ),
      ),
    );
  }
}
