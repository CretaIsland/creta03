//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';

// ignore_for_file: prefer_const_constructors, prefer_final_fields, must_be_immutable

import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_color.dart';

class CretaDoubleButton extends StatefulWidget {
  final double width;
  final double height;
  final Color shadowColor;
  final IconData icon1;
  final IconData icon2;
  final Function onPressed1;
  final Function onPressed2;
  final Text text;
  final double iconSize;
  final Color clickColor;
  final Color hoverColor;
  Color? fgColor;
  Color? bgColor;

  CretaDoubleButton({
    super.key,
    required this.width,
    required this.height,
    required this.shadowColor,
    required this.icon1,
    required this.icon2,
    required this.onPressed1,
    required this.onPressed2,
    required this.text,
    required this.iconSize,
    required this.clickColor,
    required this.hoverColor,
    this.bgColor = Colors.white,
    this.fgColor = CretaColor.text,
  });

  @override
  State<CretaDoubleButton> createState() => _CretaDoubleButtonState();
}

class _CretaDoubleButtonState extends State<CretaDoubleButton> {
  bool _isClicked1 = false;
  bool _isHover1 = false;
  bool _isClicked2 = false;
  bool _isHover2 = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _getDeco(),
        width: widget.width,
        height: widget.height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _button1(widget.icon1, widget.onPressed1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: widget.text,
            ),
            _button2(widget.icon2, widget.onPressed2)
          ],
        ));
  }

  Widget _button1(IconData iconData, Function onPressed) {
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

  Widget _button2(IconData iconData, Function onPressed) {
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
      //border: _getBorder(),
      boxShadow: _getShadow(),
      color: widget.bgColor!,
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  List<BoxShadow>? _getShadow() {
    double spreadRadius = 1;
    return [
      //LTRB
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor,
        offset: Offset(-2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor,
        offset: Offset(2, -2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor,
        offset: Offset(-2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
      BoxShadow(
        //color: Colors.grey.shade500,
        color: widget.shadowColor,
        offset: Offset(2, 2),
        blurRadius: 8,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}
