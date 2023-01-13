// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

enum FlutterButtonType {
  iconOnly,
  textOnly,
  iconText,
  textIcon,
  child,
}

class CretaTextButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final double width;
  final double height;
  final Color fgColor;
  final Color hoverColor;
  final Color clickColor;
  final TextStyle textStyle;
  IconData? iconData;
  double? iconSize;

  CretaTextButton({
    Key? key,
    required this.text,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
    required this.fgColor,
    required this.hoverColor,
    required this.clickColor,
    required this.textStyle,
    this.iconData,
    this.iconSize,
  }) : super(key: key);

  @override
  State<CretaTextButton> createState() => _CretaTextButtonState();
}

class _CretaTextButtonState extends State<CretaTextButton> {
  bool _isClicked = false;
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: TextButton(
        onPressed: () {
          setState(() {
            _isClicked = true;
          });
          widget.onPressed.call();
        },
        onHover: (value) {
          setState(() {
            _isHover = value;
            if (value == false) {
              _isClicked = false;
            }
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget.iconData != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Icon(widget.iconData!, color: _getColor(), size: widget.iconSize!),
                  )
                : Container(),
            Text(
              widget.text,
              style: widget.textStyle.copyWith(color: _getColor()),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor() {
    return _isClicked
        ? widget.clickColor
        : _isHover
            ? widget.hoverColor
            : widget.fgColor;
  }
}
