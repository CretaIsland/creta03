// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../creta_color.dart';
import '../creta_font.dart';

class CretaTextField extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;
  final String hintText;
  final int maxLines;
  final double radius;

  const CretaTextField({
    super.key,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
  });

  const CretaTextField.long({
    super.key,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 158,
    this.maxLines = 10,
    this.radius = 5,
  });

  const CretaTextField.small({
    super.key,
    required this.hintText,
    required this.onEditComplete,
    this.width = 160,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
  });

  @override
  State<CretaTextField> createState() => _CretaTextFieldState();
}

class _CretaTextFieldState extends State<CretaTextField> {
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
          if (widget.maxLines > 1) {
            searchValue = controller.text;
            widget.onEditComplete(searchValue);
          }
        });
      },
      onEnter: (val) {
        setState(() {
          hover = true;
        });
      },
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CupertinoTextField(
          maxLines: widget.maxLines,
          enabled: true,
          autofocus: true,
          decoration: BoxDecoration(
            color: clicked
                ? Colors.white
                : hover
                    ? CretaColor.text[200]!
                    : CretaColor.text[100]!,
            border: clicked ? Border.all(color: CretaColor.primary) : null,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          padding: const EdgeInsetsDirectional.only(start: 18, end: 18, top: 5, bottom: 5),
          controller: controller,
          placeholder: clicked ? null : widget.hintText,
          placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
          style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
          suffixMode: OverlayVisibilityMode.always,
          onSubmitted: ((value) {
            searchValue = value;
            logger.finest(context, 'onSubmitted $searchValue');
            widget.onEditComplete(searchValue);
          }),
          // onChanged: (value) {
          //   searchValue = value;
          //   logger.finest(context, 'onChanged $searchValue');
          // },
          onTap: () {
            setState(() {
              clicked = true;
            });
          },
        ),
      ),
    );
  }
}
