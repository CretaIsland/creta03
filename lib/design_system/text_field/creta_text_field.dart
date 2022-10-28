// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, valid_regexps

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _textField!.preprocess(value);
      _textField!.onEditComplete(value);
      clear();
    }
  }
}

enum CretaTextFieldType {
  text,
  longText,
  number,
  color,
}

class CretaTextField extends StatefulWidget {
  final double width;
  final double height;
  final void Function(String value) onEditComplete;
  final String hintText;
  final String value;
  final int maxLines;
  final double radius;
  Size? widgetSize;
  final GlobalKey<CretaTextFieldState> textFieldKey;
  final CretaTextFieldType textType;
  final bool selectAtInit;
  final int limit;
  final int minNumber;
  final int maxNumber;

  CretaTextField({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = -1,
    this.height = -1,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.xshortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 40,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 3,
    this.selectAtInit = true,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.shortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 56,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 4,
    this.selectAtInit = true,
    this.maxNumber = 9999,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.colorText({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 82,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.color,
    this.limit = 7,
    this.selectAtInit = true,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.short({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.long({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 332,
    this.height = 158,
    this.maxLines = 10,
    this.radius = 5,
    this.textType = CretaTextFieldType.longText,
    this.limit = 1023,
    this.selectAtInit = false,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  CretaTextField.small({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required this.onEditComplete,
    this.width = 160,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber = 100,
    this.minNumber = 0,
  }) : super(key: textFieldKey);

  String getValue() {
    return textFieldKey.currentState!._controller.text;
  }

  void preprocess(String value) {
    textFieldKey.currentState!.preprocess(value);
  }

  @override
  State<CretaTextField> createState() => CretaTextFieldState();
}

class CretaTextFieldState extends State<CretaTextField> {
  final TextEditingController _controller = TextEditingController();
  FocusNode? _focusNode;
  String _searchValue = '';
  bool _hover = false;
  bool _clicked = false;

  @override
  void initState() {
    _controller.text = widget.value;
    if (widget.selectAtInit) {
      _focusNode = FocusNode(
        // onKey: (node, event) {
        //   logger.finest('onKey(${event.physicalKey})');
        //   return KeyEventResult.ignored;
        // },
        onKeyEvent: (node, event) {
          if (widget.textType == CretaTextFieldType.number) {
            if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
              logger.finest('onKeyEvent(${event.logicalKey.debugName})');
              int number = int.parse(_controller.text);
              if (number < widget.maxNumber) {
                number++;
                setState(() {
                  _controller.text = '$number';
                });
              }
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
              logger.finest('onKeyEvent(${event.logicalKey.debugName})');
              int number = int.parse(_controller.text);
              if (number > widget.minNumber) {
                number--;
                setState(() {
                  _controller.text = '$number';
                });
              }
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
      );
      _focusNode!.addListener(() {
        if (_focusNode!.hasFocus) {
          _controller.selection =
              TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
        } else {
          logger.finest('focus out');
        }
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    //_controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.widgetSize = MediaQuery.of(context).size;
    return MouseRegion(
      onExit: (val) {
        setState(() {
          _hover = false;
          //_clicked = false;
        });
      },
      onEnter: (val) {
        setState(() {
          _hover = true;
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
      keyboardType:
          widget.textType == CretaTextFieldType.number ? TextInputType.number : TextInputType.none,
      focusNode: _focusNode,
      textAlignVertical: TextAlignVertical.center,
      clearButtonMode: widget.selectAtInit == false
          ? OverlayVisibilityMode.editing
          : OverlayVisibilityMode.never,
      inputFormatters: widget.textType == CretaTextFieldType.number
          ? [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(widget.limit),
              //FilteringTextInputFormatter.allow(RegExp('^[0-9]\$')),
            ]
          : widget.textType == CretaTextFieldType.color
              ? [
                  //LengthLimitingTextInputFormatter(widget.limit),
                  FilteringTextInputFormatter.allow(RegExp('^[0-9#A-Fa-f]{0,${widget.limit}}\$')),
                ]
              : null,
      maxLines: widget.maxLines,
      enabled: true,
      autofocus: true,
      decoration: isNumeric() ? _numberDecoBox() : _basicDecoBox(),
      padding: isNumeric()
          ? EdgeInsetsDirectional.only(start: 8, end: 0)
          : widget.textType == CretaTextFieldType.longText
              ? EdgeInsetsDirectional.only(start: 18, end: 18, top: 5, bottom: 5)
              : EdgeInsetsDirectional.only(start: 18, end: 18),
      controller: _controller,
      placeholder: _clicked ? null : widget.hintText,
      placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
      style: CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
      suffixMode: OverlayVisibilityMode.always,
      onSubmitted: ((value) {
        preprocess(value);
        logger.finest('onSubmitted $_searchValue');
        widget.onEditComplete(_searchValue);
        LastClicked.clear();
      }),
      // onEditingComplete: () {
      //   _searchValue = _controller.text;
      //   logger.finest('onEditingComplete $_searchValue');
      //   widget.onEditComplete(_searchValue);
      // },
      onChanged: (value) {
        logger.finest('onChanged');
        LastClicked.set(widget);
        if (_clicked == false) {
          setState(() {
            _clicked = true;
          });
        }
      },
      onTap: () {
        logger.finest('onTapped');
        LastClicked.set(widget);
        setState(() {
          _clicked = true;
        });
      },
    );
  }

  BoxDecoration _basicDecoBox() {
    return BoxDecoration(
      color: _clicked
          ? Colors.white
          : _hover
              ? CretaColor.text[200]!
              : CretaColor.text[100]!,
      border: _clicked ? Border.all(color: CretaColor.primary) : null,
      borderRadius: BorderRadius.circular(widget.radius),
    );
  }

  BoxDecoration _numberDecoBox() {
    return BoxDecoration(
      color: Colors.white,
      border: _clicked
          ? Border.all(color: CretaColor.primary)
          : _hover
              ? Border.all(color: CretaColor.text[200]!)
              : null,
      borderRadius: BorderRadius.circular(widget.radius),
    );
  }

  bool isNumeric() {
    return (widget.textType == CretaTextFieldType.number ||
        widget.textType == CretaTextFieldType.color);
  }

  void preprocess(String value) {
    _searchValue = value;
    if (widget.textType == CretaTextFieldType.color) {
      if (_searchValue.isNotEmpty && _searchValue.length < 7) {
        if (_searchValue[0] != '#') {
          _searchValue = '#$_searchValue';
          setState(() {
            _controller.text = _searchValue;
          });
        }
      }
    }
    if (_clicked == true) {
      setState(() {
        _clicked = false;
      });
    }
  }

  // void keyEventHandler(RawKeyEvent event) {
  //   final key = event.logicalKey;
  //   logger.finest('key pressed $key');
  //   if (event is RawKeyDownEvent) {
  //     if (event.isKeyPressed(LogicalKeyboardKey.arrowUp)) {
  //       int number = int.parse(_controller.text);
  //       logger.finest('arrow up');
  //       number++;
  //       setState(() {
  //         _controller.text = '$number';
  //       });
  //     } else if (event.isKeyPressed(LogicalKeyboardKey.arrowDown)) {
  //       int number = int.parse(_controller.text);
  //       logger.finest('arrow down');
  //       number--;
  //       setState(() {
  //         _controller.text = '$number';
  //       });
  //     }
  //   }
  // }
}
