// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable, valid_regexps

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import '../../common/creta_utils.dart';
import '../component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

abstract class LastClickable extends StatefulWidget {
  final void Function(String value) onEditComplete;
  const LastClickable({super.key, required this.onEditComplete});

  String getValue();
  void preprocess(String value);
  Rect? getBoxRect();
}

// class LastClicked {
//   static LastClickable? _textField;

//   static void set(LastClickable t) {
//     _textField = t;
//   }

//   static bool isClear() {
//     return _textField == null;
//   }

//   static void clear() {
//     _textField = null;
//   }

//   static void clickedOutSide(Offset current) {
//     if (_textField == null) {
//       return;
//     }
//     logger.fine('clickedOutSide');
//     Rect? boxRect = _textField!.getBoxRect();
//     if (boxRect == null) {
//       return;
//     }
//     if (!boxRect.contains(current)) {
//       String value = _textField!.getValue();
//       logger.finest('lastClicked was textField=$value');
//       _textField!.preprocess(value);
//       _textField!.onEditComplete(value);
//       clear();
//     }
//   }
// }

enum CretaTextFieldType {
  text,
  longText,
  number,
  double,
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
  final bool isSpecialKeyHandle;
  final int limit;
  final double? minNumber;
  final double? maxNumber;
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
  final void Function(PointerDownEvent)? onTapOutside;
  final Iterable<String>? autofillHints;
  final TextStyle? style;
  final bool autofocus;
  final bool readOnly;

  final Color? fixedOutlineColor;

  static FocusNode? mainFocusNode;

  CretaTextField({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = -1,
    this.height = -1,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 128,
    this.isSpecialKeyHandle = false,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.xshortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 40,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 3,
    this.isSpecialKeyHandle = true,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.double({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 40,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.double,
    this.limit = 3,
    this.isSpecialKeyHandle = true,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.shortNumber({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 56,
    this.height = 22,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.number,
    this.limit = 4,
    this.isSpecialKeyHandle = true,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.colorText({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 82,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 3,
    this.textType = CretaTextFieldType.color,
    this.limit = 7,
    this.isSpecialKeyHandle = true,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.short({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 332,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 128,
    this.isSpecialKeyHandle = false,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.long({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 332,
    this.height = 158,
    this.maxLines = 1,
    this.radius = 5,
    this.textType = CretaTextFieldType.longText,
    this.limit = 1023,
    this.isSpecialKeyHandle = false,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  CretaTextField.small({
    required this.textFieldKey,
    required this.value,
    required this.hintText,
    required super.onEditComplete,
    this.onTapOutside,
    this.controller,
    this.width = 160,
    this.height = 30,
    this.maxLines = 1,
    this.radius = 18,
    this.textType = CretaTextFieldType.text,
    this.limit = 128,
    this.isSpecialKeyHandle = false,
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
    this.autofillHints = const <String>[],
    this.style,
    this.autofocus = false,
    this.readOnly = false,
    this.fixedOutlineColor,
  }) : super(key: textFieldKey);

  @override
  Rect? getBoxRect() {
    //print('getBoxRect.....');
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

  // void setLastClicked() {
  //   logger.finest('setLastClicked');
  //   LastClicked.set(widget);
  // }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _controller.text = widget.value;

    // 커서를 제일 끝으로 이동
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    if (widget.autoHeight) {
      _lineCount = CretaCommonUtils.countAs(widget.value, '\n');

      //print('_lineCount= $_lineCount');

      if (_lineCount > 10) _lineCount = 10;
      if (_lineCount < 1) _lineCount = 1;
    }

    _focusNode = FocusNode(
      // onKey: (node, event) {
      //   if (node.hasFocus == false) {
      //     // 자기가 focus 가 없으면, 굳이 뭘 할 필요가 없기 때문에 이코드를 넣어준다.
      //     return KeyEventResult.ignored;
      //   }
      //   logger.info(
      //       '(${widget.isSpecialKeyHandle}):CretaTextField onKey : ${event.logicalKey.debugName}');
      //   // key 가 main 의 Raw RawKeyboardListener 에 도착하지 않도록 하기 위해 skipRemainingHandlers 를 쓴다.
      //   return KeyEventResult.skipRemainingHandlers;

      //   // // Delete key 가 main 의 Raw RawKeyboardListener 에 도착하지 않도록 하기 위해
      //   // switch (event.logicalKey) {
      //   //   case LogicalKeyboardKey.delete:
      //   //   case LogicalKeyboardKey.arrowRight:
      //   //   case LogicalKeyboardKey.arrowLeft:
      //   //   case LogicalKeyboardKey.pageDown:
      //   //   case LogicalKeyboardKey.pageUp:
      //   //   case LogicalKeyboardKey.insert:
      //   //   case LogicalKeyboardKey.controlLeft:
      //   //   case LogicalKeyboardKey.controlRight:
      //   //   case LogicalKeyboardKey.shiftLeft:
      //   //   case LogicalKeyboardKey.shiftRight:
      //   //     return KeyEventResult.skipRemainingHandlers;
      //   // }
      //   //return KeyEventResult.skipRemainingHandlers;
      //   //return KeyEventResult.ignored;
      // },
      onKeyEvent: (node, event) {
        if (node.hasFocus == false) {
          // 자기가 focus 가 없으면, 굳이 뭘 할 필요가 없기 때문에 이코드를 넣어준다.
          return KeyEventResult.ignored;
        }
        logger.info(
            '(${widget.isSpecialKeyHandle}):CretaTextField onKeyEvent : ${event.logicalKey.debugName}');

        if (widget.isSpecialKeyHandle == false) {
          // isSpecialKeyHandle 란  arrowUpKey 등 특수키를 처리하는  textField 말한다.
          return KeyEventResult.skipRemainingHandlers;
        }

        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          logger.finest('onKeyEvent(${event.logicalKey.debugName})');
          if (widget.textType == CretaTextFieldType.number) {
            int number = int.parse(_controller.text);
            if (widget.maxNumber == null || number < widget.maxNumber!.round()) {
              number++;
              setState(() {
                _controller.text = '$number';
              });
            }
          } else if (widget.textType == CretaTextFieldType.double) {
            double number = double.parse(_controller.text);
            if (widget.maxNumber == null || number < widget.maxNumber!) {
              number = number + 0.1;
              setState(() {
                _controller.text = '$number';
              });
            }
          }
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          logger.finest('onKeyEvent(${event.logicalKey.debugName})');
          if (widget.textType == CretaTextFieldType.number) {
            int number = int.parse(_controller.text);
            if (widget.maxNumber == null || number > widget.minNumber!.round()) {
              number--;
              setState(() {
                _controller.text = '$number';
              });
            }
          }
          if (widget.textType == CretaTextFieldType.double) {
            double number = double.parse(_controller.text);
            if (widget.maxNumber == null || number > widget.minNumber!) {
              number = number - 0.1;
              setState(() {
                _controller.text = '$number';
              });
            }
          }
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
    _focusNode!.addListener(_listener);
    super.initState();
  }

  void _listener() {
    // if (_focusNode!.hasFocus) {
    //   _controller.selection = TextSelection(baseOffset: 0, extentOffset: _controller.text.length);
    // } else {
    //   // 포커스가 없을 때 선택 해제
    //   _controller.selection = TextSelection.collapsed(offset: -1);
    // }
  }

  @override
  void dispose() {
    //_controller.clear();
    logger.info('textfield dispose');
    _focusNode?.removeListener(_listener);
    _focusNode?.unfocus();
    CretaTextField.mainFocusNode?.requestFocus(); // bookMain 이 포커스를 가져가도록 해줘야 한다.

    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    widget.widgetSize = MediaQuery.of(context).size;
    int lineCount = _lineCount;
    if (widget.maxLines != 0 && lineCount > widget.maxLines!) {
      lineCount = widget.maxLines!;
      if (lineCount > 1) {
        lineCount--;
      }
    }
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
                height: widget.autoHeight ? widget.height * (lineCount + 1) + 10 : widget.height,
                width: widget.width,
                child: _cupertinoTextField(),
              )
            : _cupertinoTextField();
    //);
  }

  List<TextInputFormatter>? _format(CretaTextFieldType textType) {
    switch (textType) {
      case CretaTextFieldType.text:
        return [
          LengthLimitingTextInputFormatter(widget.limit,
              maxLengthEnforcement: MaxLengthEnforcement.enforced),
        ];
      case CretaTextFieldType.number:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(widget.limit),
        ];
      case CretaTextFieldType.double:
        return [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]*')),
        ];
      case CretaTextFieldType.color:
        return [
          FilteringTextInputFormatter.allow(RegExp('^[0-9#A-Fa-f]{0,${widget.limit}}\$')),
        ];
      default:
        return null;
    }
  }

  Widget _cupertinoTextField() {
    int? lines;
    if (widget.maxLines != null) {
      lines = widget.maxLines;
    } else {
      if (widget.autoHeight) {
        lines = _lineCount;
      }
    }

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
        onTapOutside: (event) {
          if (_clicked) {
            logger.info('----------onTapOutSide');
            _onSubmitted(_controller.text);
            //setState(() {});
            _clicked = false;
          } else {
            widget.onTapOutside?.call(event);
          }
          _focusNode?.unfocus();
          CretaTextField.mainFocusNode?.requestFocus(); // bookMain 이 포커스를 가져가도록 해줘야 한다.
        },
        obscureText: (widget.textType == CretaTextFieldType.password) ? _obscured : false,
        cursorColor: CretaColor.primary,
        textInputAction: widget.textInputAction,
        enabled: widget.enabled,
        textAlign: widget.align,
        keyboardType: widget.keyboardType ??
            ((widget.textType == CretaTextFieldType.number ||
                    widget.textType == CretaTextFieldType.double)
                ? TextInputType.number
                : TextInputType.none),
        focusNode: _focusNode,
        textAlignVertical: widget.alignVertical,
        // 클리어 버튼을 사용하면, 한글이 깨지므로 사용할 수 없다.
        // clearButtonMode: _clicked
        //     ? widget.isSpecialKeyHandle == false
        //         ? OverlayVisibilityMode.editing
        //         : OverlayVisibilityMode.never
        //     : OverlayVisibilityMode.never,
        inputFormatters: _format(widget.textType),
        maxLength: widget.limit,
        maxLines: lines,
        minLines: lines,
        //maxLines: 1,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        //decoration: isNumeric() ? _numberDecoBox() : _basicDecoBox(),
        autofillHints: widget.autofillHints,
        decoration: _basicDecoBox(),
        padding: isNumeric()
            ? EdgeInsetsDirectional.only(start: 8, end: 0)
            : widget.textType == CretaTextFieldType.longText
                ? EdgeInsetsDirectional.only(start: 10, end: 10, top: 5, bottom: 5)
                : EdgeInsetsDirectional.only(start: 10, end: 10),
        controller: _controller,
        placeholder: _clicked ? null : widget.hintText,
        placeholderStyle: CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!),
        style: widget.style ?? CretaFont.bodySmall.copyWith(color: CretaColor.text[900]!),
        suffixMode: OverlayVisibilityMode.always,
        // onEditingComplete: () {
        //   _focusNode?.requestFocus();
        // },
        onSubmitted: ((value) {
          _onSubmitted(value);
        }),
        suffix: (widget.textType != CretaTextFieldType.password)
            ? SizedBox.shrink()
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                child: GestureDetector(
                  onTap: _toggleObscured,
                  child: Icon(
                    _obscured ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    size: 18,
                    //color: (_focusNode?.hasFocus ?? false) ? CretaColor.primary : CretaColor.text[200]!,
                    color: CretaColor.primary,
                  ),
                ),
              ),
        // onEditingComplete: () {
        //   _searchValue = _controller.text;
        //   logger.finest('onEditingComplete $_searchValue');
        //   widget.onEditComplete(_searchValue);
        // },
        onChanged: (value) {
          // Replace any Enter key presses with a line feed character
          if (widget.autoHeight) {
            int newLineNo = CretaCommonUtils.countAs(value, '\n');
            if (_lineCount < 10 || (newLineNo < 10 && newLineNo > 1)) {
              if (newLineNo != 0 && newLineNo != _lineCount) {
                if (newLineNo > 10) {
                  _lineCount = 10;
                } else if (newLineNo < 1) {
                  _lineCount = 1;
                } else {
                  _lineCount = newLineNo;
                }
                logger.fine('line count chaged');
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
              //LastClicked.clear();
            });
          }
          //setLastClicked();
          if (_clicked == false) {
            //setState(() {
            _clicked = true;
            //});
          }
          widget.onChanged?.call(value);
        },
        onTap: () {
          //setLastClicked();
          //setState(() {
          _clicked = true;
          //});
        },
      ),
    );
  }

  void _onSubmitted(String value) {
    if (isNumeric()) {
      double num = 0;
      if (value.isNotEmpty) {
        num = double.parse(value);
      } else {
        setState(() {
          _controller.text = '0';
        });
      }
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
    logger.info('onSubmitted $_searchValue');
    //_focusNode?.unfocus();
    widget.onEditComplete(_searchValue);
  }

  BoxDecoration _basicDecoBox() {
    BoxBorder border = (widget.fixedOutlineColor != null)
        ? Border.all(color: widget.fixedOutlineColor!)
        : _clicked
            ? Border.all(color: CretaColor.primary)
            : _hovered
                ? Border.all(color: CretaColor.text[300]!)
                // ? Border.all(color: Colors.red)
                : widget.defaultBorder ?? Border.all(color: CretaColor.text[200]!);
    return BoxDecoration(
      //color: _clicked ? Colors.white : CretaColor.text[100]!,
      color: Colors.white,
      // : _hover
      //     ? CretaColor.text[200]!
      //     : CretaColor.text[100]!,
      //border: _clicked ? Border.all(color: CretaColor.primary) : widget.defaultBorder,
      border: border,
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
        widget.textType == CretaTextFieldType.double ||
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

  bool _obscured = true;
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
