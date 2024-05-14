// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class CretaElevatedButton extends StatefulWidget {
  final Function onPressed;
  final String? caption;
  final TextStyle? captionStyle;
  final Icon? icon;

  final Color bgColor;
  final Color bgSelectedColor;
  final Color bgHoverColor;
  final Color bgHoverSelectedColor;

  final Color fgSelectedColor;
  final Color fgColor;

  final Color borderSelectedColor;
  final Color borderColor;

  final double height;
  final double? width;
  final double radius;

  final bool isVertical;

  CretaElevatedButton({
    super.key,
    required this.onPressed,
    this.caption,
    this.captionStyle,
    this.icon,
    this.bgColor = Colors.white,
    this.bgSelectedColor = Colors.grey,
    this.bgHoverColor = Colors.blueGrey,
    this.bgHoverSelectedColor = Colors.lightBlue,
    this.fgColor = Colors.black,
    this.fgSelectedColor = Colors.white,
    this.borderColor = Colors.lightBlue,
    this.borderSelectedColor = Colors.blue,
    this.height = 24,
    this.width,
    this.radius = 36,
    this.isVertical = false,
  });

  @override
  State<CretaElevatedButton> createState() => _CretaElevatedButtonState();
}

class _CretaElevatedButtonState extends State<CretaElevatedButton> {
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(0.0),
        shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (selected) {
              if (states.contains(WidgetState.hovered)) {
                return widget.bgHoverSelectedColor;
              }
              return widget.bgSelectedColor;
            }
            if (states.contains(WidgetState.hovered)) {
              return widget.bgHoverColor;
            }
            return widget.bgColor;
          },
        ),
        backgroundColor:
            WidgetStateProperty.all<Color>(selected ? widget.bgSelectedColor : widget.bgColor),
        // foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        //   (Set<WidgetState> states) {
        //     //if (states.contains(WidgetState.hovered)) return widget.fgColor;
        //     return (selected ? widget.fgSelectedColor : widget.fgColor);
        //   },
        // ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: BorderSide(color: selected ? widget.borderSelectedColor : widget.borderColor))),
      ),
      onPressed: () {
        setState(() {
          selected = !selected;
        });
        widget.onPressed();
      },
      child: SizedBox(
          width: widget.width,
          //color: Colors.amber,
          height: widget.height,
          child: widget.isVertical
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon != null ? widget.icon! : Container(),
                    widget.caption != null && widget.captionStyle != null
                        ? Text(
                            widget.caption!,
                            style: widget.captionStyle!.copyWith(
                                color: (selected ? widget.fgSelectedColor : widget.fgColor)),
                          )
                        : Container(),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.icon != null ? widget.icon! : Container(),
                    widget.caption != null && widget.captionStyle != null
                        ? Text(
                            widget.caption!,
                            style: widget.captionStyle!.copyWith(
                                color: (selected ? widget.fgSelectedColor : widget.fgColor)),
                          )
                        : Container(),
                  ],
                )),
    );
  }
}
