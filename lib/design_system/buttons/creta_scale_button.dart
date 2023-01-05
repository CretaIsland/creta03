//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../pages/studio/studio_variables.dart';
import '../../lang/creta_studio_lang.dart';
import '../creta_color.dart';
import '../creta_font.dart';

class CretaScaleButton extends StatefulWidget {
  final double width;
  final double height;
  Color? shadowColor;
  final IconData icon1;
  final IconData icon2;
  final void Function() onPressedMinus;
  final void Function() onPressedPlus;
  final void Function() onPressedAutoScale;
  final double defaultScale;
  TextStyle? textStyle;
  final double iconSize;
  Color? clickColor;
  Color? hoverColor;
  Color? fgColor;
  Color? bgColor;
  final bool hasShadow;

  CretaScaleButton({
    super.key,
    this.width = 134,
    this.height = 36,
    this.shadowColor,
    this.icon1 = Icons.remove_outlined,
    this.icon2 = Icons.add_outlined,
    required this.onPressedMinus,
    required this.onPressedPlus,
    required this.onPressedAutoScale,
    required this.defaultScale,
    this.textStyle,
    this.iconSize = 20,
    this.clickColor,
    this.hoverColor,
    this.bgColor = Colors.white,
    this.fgColor = CretaColor.text,
    this.hasShadow = true,
  }) {
    clickColor ??= CretaColor.text[200]!;
    hoverColor ??= CretaColor.text[100]!;
    shadowColor ??= CretaColor.text[200]!;
    textStyle ??= CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!);
  }

  @override
  State<CretaScaleButton> createState() => _CretaScaleButtonState();
}

class _CretaScaleButtonState extends State<CretaScaleButton> {
  bool _isClicked1 = false;
  bool _isHover1 = false;
  bool _isClicked2 = false;
  bool _isHover2 = false;

  String _scaleText = '';

  @override
  Widget build(BuildContext context) {
    if (StudioVariables.autoScale == true) {
      _scaleText = CretaStudioLang.autoScale;
    } else if (_scaleText.isEmpty || _scaleText == CretaStudioLang.autoScale) {
      _scaleText = "${(widget.defaultScale * 100).round()}%";
      StudioVariables.scale = widget.defaultScale;
    }
    logger.fine('scaleText=$_scaleText');
    return Container(
        decoration: _getDeco(),
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button1(widget.icon1, widget.onPressedMinus),
            TextButton(
              onPressed: () {
                setState(() {
                  StudioVariables.autoScale = !StudioVariables.autoScale;
                  logger.finest('middle button pressed ${StudioVariables.autoScale}');
                });
                widget.onPressedAutoScale.call();
              },
              child: Text(
                _scaleText,
                style: widget.textStyle,
              ),
            ),
            _button2(widget.icon2, widget.onPressedPlus)
          ],
        ));
  }

  Widget _button1(IconData iconData, void Function() onPressed) {
    return Container(
      width: _isClicked1 ? widget.iconSize : widget.iconSize * 1.2,
      height: _isClicked1 ? widget.iconSize : widget.iconSize * 1.2,
      decoration: BoxDecoration(
          color: _isClicked1
              ? widget.clickColor
              : _isHover1
                  ? widget.hoverColor
                  : widget.bgColor,
          shape: BoxShape.circle),
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClicked1 = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isClicked1 = false;
            if (StudioVariables.scale > 0) {
              StudioVariables.scale -= 0.05;
              StudioVariables.autoScale = false;
              _scaleText = "${(StudioVariables.scale * 100).round()}%";
            }
          });
          onPressed.call();
        },
        child: MouseRegion(
          onExit: (val) {
            setState(() {
              _isHover1 = false;
              _isClicked1 = false;
            });
          },
          onEnter: (val) {
            setState(() {
              _isHover1 = true;
            });
          },
          child: Icon(
            iconData,
            size: widget.iconSize,
            color: widget.fgColor,
          ),
        ),
      ),
    );
  }

  Widget _button2(IconData iconData, void Function() onPressed) {
    return Container(
      width: _isClicked2 ? widget.iconSize : widget.iconSize * 1.2,
      height: _isClicked2 ? widget.iconSize : widget.iconSize * 1.2,
      decoration: BoxDecoration(
          color: _isClicked2
              ? widget.clickColor
              : _isHover2
                  ? widget.hoverColor
                  : widget.bgColor,
          shape: BoxShape.circle),
      child: GestureDetector(
        onLongPressDown: (details) {
          setState(() {
            _isClicked2 = true;
          });
        },
        onTapUp: (details) {
          setState(() {
            _isClicked2 = false;

            StudioVariables.scale += 0.05;
            StudioVariables.autoScale = false;
            _scaleText = "${(StudioVariables.scale * 100).round()}%";
          });
          onPressed.call();
        },
        child: MouseRegion(
          onExit: (val) {
            setState(() {
              _isHover2 = false;
              _isClicked2 = false;
            });
          },
          onEnter: (val) {
            setState(() {
              _isHover2 = true;
            });
          },
          child: Icon(
            iconData,
            size: widget.iconSize,
            color: widget.fgColor,
          ),
        ),
      ),
    );
  }

  Decoration? _getDeco() {
    return BoxDecoration(
      border: widget.hasShadow ? null : _getBorder(),
      boxShadow: widget.hasShadow ? _getShadow() : null,
      color: widget.bgColor!,
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  Border? _getBorder() {
    return Border.all(
      width: 2,
      color: widget.shadowColor!,
    );
  }

  List<BoxShadow>? _getShadow() {
    double spreadRadius = 1;
    return [
      //LTRB
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(-2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(-2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor!,
        offset: Offset(2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}
