// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../creta_font.dart';

class CretaTabButton extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;

  const CretaTabButton({
    super.key,
    required this.onEditComplete,
    this.width = 332,
    this.height = 30,
  });

  @override
  State<CretaTabButton> createState() => _CretaTabButtonState();
}

class _CretaTabButtonState extends State<CretaTabButton> {
  TextEditingController controller = TextEditingController();
  String searchValue = '';
  bool hover = false;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onExit: (val) {
        setState(() {
          hover = false;
          clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          hover = true;
        });
      },
      child: CustomRadioButton(
        height: widget.height,
        width: widget.width,
        elevation: 0,
        absoluteZeroSpacing: true,
        unSelectedColor: Theme.of(context).canvasColor,
        buttonLables: [
          'Student',
          'Parent',
          'Teacher',
        ],
        buttonValues: [
          "STUDENT",
          "PARENT",
          "TEACHER",
        ],
        buttonTextStyle: ButtonTextStyle(
            selectedColor: Colors.white,
            unSelectedColor: Colors.black,
            textStyle: CretaFont.buttonMedium),
        radioButtonValue: (value) {
          logger.finest(value);
          widget.onEditComplete(value);
        },
        selectedColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
