// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop.dart';

import '../component/snippet.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class LastClicked {
  static CretaTextField? _textField;

  static void set(CretaTextField t) {
    _textField = t;
  }

  static void clear() {
    _textField = null;
  }

  static void clickedOutSide(Offset current) {
    if (_textField == null) {
      return;
    }
    Rect? boxRect = _textField!.textFieldKey.globalPaintBounds!;
    if (!boxRect.contains(current)) {
      String value = _textField!.getValue();
      logger.finest('lastClicked was textField=$value');
      _textField!.onEditComplete(value);
      clear();
    }
  }
}

class CretaTextField extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;
  final String hintText;
  final int maxLines;
  final double radius;
  Size? widgetSize;
  final GlobalKey<CretaTextFieldState> textFieldKey;

  CretaTextField({
    required this.textFieldKey,
    required this.hintText,
    required this.onEditComplete,
    this.width = -1,
    this.height = -1,
    this.maxLines = 1,
    this.radius = 18,
  }) : super(key: textFieldKey);

  CretaTextField.short({
    required this.textFieldKey,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
  }) : super(key: textFieldKey);

  CretaTextField.long({
    required this.textFieldKey,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 158,
    this.maxLines = 10,
    this.radius = 5,
  }) : super(key: textFieldKey);

  CretaTextField.small({
    required this.textFieldKey,
    required this.hintText,
    required this.onEditComplete,
    this.width = 160,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
  }) : super(key: textFieldKey);

  String getValue() {
    return textFieldKey.currentState!.controller.text;
  }

  @override
  State<CretaTextField> createState() => CretaTextFieldState();
}

class CretaTextFieldState extends State<CretaTextField> {
  TextEditingController controller = TextEditingController();
  String searchValue = '';
  bool hover = false;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    widget.widgetSize = MediaQuery.of(context).size;
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
      child: (widget.height > 0 && widget.width > 0)
          ? SizedBox(
              height: widget.height,
              width: widget.width,
              child: _cupertinoTextField(),
            )
          : _cupertinoTextField(),
    );
  }

  Widget _cupertinoTextField() {
    return CupertinoTextField(
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
        LastClicked.clear();
      }),
      // onEditingComplete: () {
      //   searchValue = controller.text;
      //   logger.finest(context, 'onEditingComplete $searchValue');
      //   widget.onEditComplete(searchValue);
      // },
      // onChanged: (value) {
      //   logger.finest(context, 'onChanged');
      // },
      onTap: () {
        logger.finest('onTapped');
        LastClicked.set(widget);
        setState(() {
          clicked = true;
        });
      },
    );
  }
}
