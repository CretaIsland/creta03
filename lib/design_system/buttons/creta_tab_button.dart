// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import 'package:creta_common/common/creta_font.dart';

class CretaTabButton extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;
  final List<String> buttonLables;
  final List<IconData>? buttonIcons;
  final List<String> buttonValues;
  final String? defaultString;
  final Color selectedBorderColor;
  final Color unSelectedBorderColor;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color selectedTextColor;
  final Color unSelectedTextColor;
  final bool absoluteZeroSpacing;
  final TextStyle? textStyle;
  final bool autoWidth;

  CretaTabButton({
    super.key,
    required this.onEditComplete,
    this.width = 332,
    this.height = 30,
    this.autoWidth = false,
    required this.buttonLables,
    this.buttonIcons,
    required this.buttonValues,
    this.defaultString,
    required this.selectedColor,
    required this.unSelectedColor,
    required this.selectedTextColor,
    required this.unSelectedTextColor,
    this.selectedBorderColor = Colors.transparent,
    this.unSelectedBorderColor = Colors.transparent,
    this.absoluteZeroSpacing = false,
    this.textStyle,
  });

  @override
  State<CretaTabButton> createState() => _CretaTabButtonState();
}

class _CretaTabButtonState extends State<CretaTabButton> {
  TextEditingController controller = TextEditingController();
  String searchValue = '';
  @override
  Widget build(BuildContext context) {
    return CustomRadioButton(
      wrapAlignment: WrapAlignment.start,
      defaultSelected: widget.defaultString,
      height: widget.height,
      width: widget.width,
      autoWidth: widget.autoWidth,
      buttonTextStyle: ButtonTextStyle(
        selectedColor: widget.selectedTextColor,
        unSelectedColor: widget.unSelectedTextColor,
        //textStyle: CretaFont.buttonMedium.copyWith(fontWeight: FontWeight.bold),
        textStyle: widget.textStyle ?? CretaFont.buttonMedium,
      ),
      selectedBorderColor: widget.selectedBorderColor,
      unSelectedBorderColor: widget.unSelectedBorderColor,
      elevation: 0,
      enableButtonWrap: true,
      enableShape: true,
      shapeRadius: 60,
      absoluteZeroSpacing: widget.absoluteZeroSpacing,
      unSelectedColor: widget.unSelectedColor,
      selectedColor: widget.selectedColor,
      buttonLables: widget.buttonLables,
      buttonIcons: widget.buttonIcons,
      buttonValues: widget.buttonValues,
      radioButtonValue: (value) {
        logger.finest(value);
        widget.onEditComplete(value);
      },
    );
  }
}
