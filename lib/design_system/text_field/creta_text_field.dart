// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, valid_regexps

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop.dart';

import '../../common/creta_utils.dart';
import '../component/snippet.dart';
import '../creta_color.dart';
import '../creta_font.dart';

abstract class LastClickable extends StatefulWidget {
  final void Function(String value) onEditComplete;
  const LastClickable({super.key, required this.onEditComplete});

  String getValue();
  void preprocess(String value);
  Rect? getBoxRect();
}

class LastClicked {
  static LastClickable? _textField;

  static void set(LastClickable t) {
    _textField = t;
  }

  static bool isClear() {
    return _textField == null;
  }

  static void clear() {
    _textField = null;
  }

  static void clickedOutSide(Offset current) {
    if (_textField == null) {
      return;
    }
    logger.finest('clickedOutSide');
    Rect? boxRect = _textField!.getBoxRect();
    if (boxRect == null) {
      return;
    }
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
  password,
}

class CretaTextField extends LastClickable {
  final double width;
  final double height;
  final String hintText;
  final String value;
  final int? maxLines;
  final double radius;
  Size? widgetSize;
  final GlobalKey<CretaTextFieldState> textFieldKey;
  final CretaTextFieldType textType;
  final bool selectAtInit;
  final int limit;
  final int? minNumber;
  final int? maxNumber;
  final TextEditingController? controller;
  final TextAlign align;
  final Border? defaultBorder;
  final Function(String)? onChanged;
  final bool enabled;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final TextAlignVertical alignVertical;
  final bool autoComplete;
  final bool autoHeight;

  CretaTextField({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = -1,
    this.height = -1,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.start,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.xshortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 40,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 3,
    this.selectAtInit = true,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.end,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.shortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 56,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 4,
    this.selectAtInit = true,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.end,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.colorText({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 82,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.color,
    this.limit = 7,
    this.selectAtInit = true,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.end,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.short({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 332,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.start,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.long({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 332,
    this.height = 158,
    this.maxLines,
    this.radius = 5,
    this.textType = CretaTextFieldType.longText,
    this.limit = 1023,
    this.selectAtInit = false,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.start,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  CretaTextField.small({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.controller,
    this.width = 160,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 255,
    this.selectAtInit = false,
    this.maxNumber,
    this.minNumber,
    this.align = TextAlign.start,
    this.enabled = true,
    this.defaultBorder,
    this.onChanged,
    this.textInputAction,
    this.keyboardType,
    this.alignVertical = TextAlignVertical.center,
    this.autoComplete = false,
    this.autoHeight = false,
  }) : super(key: textFieldKey);

  @override
  Rect? getBoxRect() {
    return textFieldKey.globalPaintBounds!;
  }

  @override
  String getValue() {
    return textFieldKey.currentState!._controller.text;
  }

  @override
  void preprocess(String value) {
    textFieldKey.currentState!.preprocess(value);
  }

  @override
  State<CretaTextField> createState() => CretaTextFieldState();
}

class CretaTextFieldState extends State<CretaTextField> {
  late TextEditingController _controller;
  FocusNode? _focusNode;
  String _searchValue = '';
  //bool _hover = false;
  bool _clicked = false;
  bool _hovered = false;

  Timer? _timer;
  int _lineCount = 1;

  void setLastClicked() {
    logger.finest('setLastClicked');
    LastClicked.set(widget);
  }

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.value;
    // _controller.addListener(() {
    //   if (_controller.text.isNotEmpty) {
    //     // 키보드 이벤트 처리
    //     _handleKeyboardEvent(_controller.text[_controller.text.length - 1]);
    //   }
    // });

    if (widget.autoHeight) {
      _lineCount = CretaUtils.countAs(widget.value, '\n');
      if (_lineCount > 10) _lineCount = 10;
      if (_lineCount < 1) _lineCount = 1;
    }
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
              if (widget.maxNumber == null || number < widget.maxNumber!) {
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
              if (widget.maxNumber == null || number > widget.minNumber!) {
                number--;
                setState(() {
                  _controller.text = '$number';
                });
              }
              return KeyEventResult.handled;
            }
          }
          // if (event.logicalKey == LogicalKeyboardKey.enter) {
          //   logger.info('enter key pressed');
          //   _controller.value = TextEditingValue(
          //       text: '${_controller.text}\n',
          //       selection: TextSelection.fromPosition(
          //         TextPosition(offset: _controller.text.length + 1),
          //       ));

          //   return KeyEventResult.handled;
          // }

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
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    widget.widgetSize = MediaQuery.of(context).size;
    return
        // MouseRegion(
        //   onExit: (val) {
        //     setState(() {
        //       _hover = false;
        //       //_clicked = false;
        //     });
        //   },
        //   onEnter: (val) {
        //     setState(() {
        //       _hover = true;
        //     });
        //   },
        //child:
        (widget.height > 0 && widget.width > 0)
            ? SizedBox(
                height: widget.autoHeight ? widget.height * (_lineCount + 1) + 10 : widget.height,
                width: widget.width,
                child: _cupertinoTextField(),
              )
            : _cupertinoTextField();
    //);
  }

  Widget _cupertinoTextField() {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _hovered = true;
        });
      },
      onExit: (event) {
        setState(() {
          _hovered = false;
        });
      },
      child: CupertinoTextField(
        obscureText: (widget.textType == CretaTextFieldType.password),
        cursorColor: CretaColor.primary,
        textInputAction: widget.textInputAction,
        enabled: widget.enabled,
        textAlign: widget.align,
        keyboardType: widget.keyboardType ??
            (widget.textType == CretaTextFieldType.number
                ? TextInputType.number
                : TextInputType.none),
        focusNode: _focusNode,
        textAlignVertical: widget.alignVertical,
        clearButtonMode: _clicked
            ? widget.selectAtInit == false
                ? OverlayVisibilityMode.editing
                : OverlayVisibilityMode.never
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
        minLines: widget.maxLines,
        //maxLines: 1,
        autofocus: false,
        //decoration: isNumeric() ? _numberDecoBox() : _basicDecoBox(),
        decoration: _basicDecoBox(),
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
        // onEditingComplete: () {
        //   _focusNode?.requestFocus();
        // },
        onSubmitted: ((value) {
          if (isNumeric()) {
            int num = int.parse(value);
            if (widget.maxNumber != null && num > widget.maxNumber!) {
              setState(() {
                _controller.text = '${widget.maxNumber!}';
              });
            }
            if (widget.minNumber != null && num < widget.minNumber!) {
              setState(() {
                _controller.text = '${widget.minNumber!}';
              });
            }
          }
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
          // Replace any Enter key presses with a line feed character
          if (widget.autoHeight) {
            int newLineNo = CretaUtils.countAs(value, '\n');
            if (_lineCount < 10 || (newLineNo < 10 && newLineNo > 1)) {
              if (newLineNo != 0 && newLineNo != _lineCount) {
                if (newLineNo > 10) {
                  _lineCount = 10;
                } else if (newLineNo < 1) {
                  _lineCount = 1;
                } else {
                  _lineCount = newLineNo;
                }
                logger.info('line count chaged');
                setState(() {});
              }
            }
          }
          if (widget.autoComplete) {
            _timer?.cancel();

            // start a new timer to call the function after 2 seconds of no text input
            _timer = Timer(Duration(seconds: 2), () {
              preprocess(value);
              logger.finest('onSubmitted $_searchValue');
              widget.onEditComplete(_searchValue);
              LastClicked.clear();
            });
          }
          setLastClicked();
          if (_clicked == false) {
            //setState(() {
            _clicked = true;
            //});
          }
          widget.onChanged?.call(value);
        },
        onTap: () {
          logger.finest('onTapped');
          setLastClicked();
          //setState(() {
          _clicked = true;
          //});
        },
        // onTapOutside: (event) {
        //   logger.info('onTappOutside');
        //   widget.onEditComplete(_searchValue);
        // },
      ),
    );
  }

  BoxDecoration _basicDecoBox() {
    return BoxDecoration(
      //color: _clicked ? Colors.white : CretaColor.text[100]!,
      color: Colors.white,
      // : _hover
      //     ? CretaColor.text[200]!
      //     : CretaColor.text[100]!,
      //border: _clicked ? Border.all(color: CretaColor.primary) : widget.defaultBorder,
      border: _clicked
          ? Border.all(color: CretaColor.primary)
          : _hovered
              ? Border.all(color: CretaColor.text[300]!)
              //? Border.all(color: Colors.red)
              : widget.defaultBorder ?? Border.all(color: CretaColor.text[200]!),
      borderRadius: BorderRadius.circular(widget.radius),
    );
  }

  // InputDecoration _inputBorderDeco () {
  //   return InputDecoration(
  //       fillColor: Colors.white,
  //       focusedBorder: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(widget.radius),
  //         borderSide: BorderSide(color: CretaColor.text[200]!),
  //       )

  //       //Border.all(color: CretaColor.primary) : widget.defaultBorder,
  //       // : _hover
  //       //     ? Border.all(color: CretaColor.text[200]!)
  //       //     : null,
  //       //borderRadius: BorderRadius.circular(widget.radius),
  //       );
  //}

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
