// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';

class CretaTabButton extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;
  final List<String> buttonLables;
  final List<String> buttonValues;
  final String? defaultString;

  const CretaTabButton({
    super.key,
    required this.onEditComplete,
    this.width = 95,
    this.height = 24,
    required this.buttonLables,
    required this.buttonValues,
    this.defaultString,
  });

  @override
  State<CretaTabButton> createState() => _CretaTabButtonState();
}

class _CretaTabButtonState extends State<CretaTabButton> {
  TextEditingController controller = TextEditingController();
  String searchValue = '';
  bool hover = false;
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
      child: CustomRadioButton(
        defaultSelected: widget.defaultString,
        height: widget.height,
        width: widget.width,
        //autoWidth: true,
        buttonTextStyle: ButtonTextStyle(
          selectedColor: CretaColor.primary,
          unSelectedColor: CretaColor.text[700]!,
          //textStyle: CretaFont.buttonMedium.copyWith(fontWeight: FontWeight.bold),
          textStyle: CretaFont.buttonMedium,
        ),
        selectedBorderColor: Colors.transparent,
        unSelectedBorderColor: Colors.transparent,
        elevation: 0,
        enableButtonWrap: true,
        enableShape: true,
        shapeRadius: 60,
        absoluteZeroSpacing: false,
        unSelectedColor: CretaColor.text[100]!,
        selectedColor: Colors.white,
        buttonLables: widget.buttonLables,
        buttonValues: widget.buttonValues,
        radioButtonValue: (value) {
          logger.finest(value);
          widget.onEditComplete(value);
        },
      ),
    );
  }
}
