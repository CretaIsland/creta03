// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

// ignore: must_be_immutable
class CretaTapBarButton extends StatefulWidget {
  final bool selected;
  final Function onPressed;
  final String caption;
  final double width;
  final double height;
  IconData? iconData;
  double? iconSize;
  Color? bgColor;
  Color? bgClickColor;
  Color? bgHoverColor;
  Color? fgColor;
  Color? fgClickColor;
  Color? fgHoverColor;
  final bool isIconText;
  double? leftPadding;

  CretaTapBarButton({
    super.key,
    required this.selected,
    required this.onPressed,
    required this.caption,
    this.width = 246,
    this.height = 56,
    this.bgColor,
    this.bgClickColor,
    this.bgHoverColor,
    this.fgColor,
    this.fgClickColor,
    this.fgHoverColor,
    this.iconData,
    this.iconSize,
    this.isIconText = false,
    this.leftPadding = 0,
  }) {
    bgColor ??= CretaColor.text[100]!;
    bgClickColor ??= Colors.white;
    bgHoverColor ??= const Color.fromARGB(255, 0xF9, 0xF9, 0xF9);
    fgColor ??= CretaColor.text[700]!;
    fgClickColor ??= CretaColor.primary;
    fgHoverColor ??= CretaColor.primary;
  }

  @override
  State<CretaTapBarButton> createState() => _CretaTapBarButtonState();
}

class _CretaTapBarButtonState extends State<CretaTapBarButton> {
  bool hover = false;
  bool clicked = false;
  bool selected = false;

  @override
  void initState() {
    //selected = widget.selected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selected = widget.selected;
    return GestureDetector(
      onLongPressDown: (details) {
        setState(() {
          clicked = true;
          //selected = true;
        });
      },
      onTapUp: (details) {
        setState(() {
          clicked = false;
        });
        widget.onPressed.call();
      },
      child: MouseRegion(
        onExit: (val) {
          setState(() {
            //print('hover is false');
            hover = false;
            clicked = false;
          });
        },
        onEnter: (val) {
          setState(() {
            //print('hover is true');
            hover = true;
          });
        },
        child: SizedBox(
          child: AnimatedContainer(
            padding: EdgeInsets.only(right: widget.leftPadding!),
            duration: const Duration(milliseconds: 200),
            transformAlignment: AlignmentDirectional.center,
            transform: Matrix4.identity()..scale(_getScale()),
            decoration: _getDeco(),
            width: widget.width,
            height: widget.height,
            //child: Center(
            child: _getChild(),
            //),
          ),
        ),
      ),
    );
  }

  double _getScale() {
    return clicked ? ((widget.height > 40.0) ? 0.8 : 0.6) : 1.0;
  }

  Decoration? _getDeco() {
    return BoxDecoration(
      color: _getBgColor(),
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  Color _getBgColor() {
    if (selected || clicked) {
      return widget.bgClickColor!;
    }
    return hover ? widget.bgHoverColor! : widget.bgColor!;
  }

  Color _getfgColor() {
    if (selected || clicked) {
      return widget.fgClickColor!;
    }
    return hover ? widget.fgHoverColor! : widget.fgColor!;
  }

  Widget _getChild() {
    if ((widget.iconData != null)) {
      if (widget.isIconText == true) {
        // return Row(
        //   children: [
        //     Container(
        //       padding: EdgeInsets.only(left: widget.width / 8),
        //       alignment: AlignmentDirectional.centerStart,
        //       child: Icon(widget.iconData!, color: CretaColor.primary),
        //     ),
        //     Container(
        //       padding: EdgeInsets.only(left: widget.width / 8),
        //       alignment: AlignmentDirectional.centerStart,
        //       child: Text(
        //         widget.caption,
        //         style: CretaFont.titleLarge.copyWith(color: _getfgColor()),
        //       ),
        //     ),
        //   ],
        // );
        //print('widget.caption: ${widget.caption}');
        return Container(
          padding: EdgeInsets.only(left: widget.width / 8),
          alignment: AlignmentDirectional.centerStart,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(widget.iconData!, color: _getfgColor(), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.caption,
                  style: CretaFont.titleLarge.copyWith(
                    color: _getfgColor(),
                    fontWeight: CretaFont.medium,
                    height: 0.9,
                    fontSize: 16,
                  ),
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: EdgeInsets.only(left: widget.width / 8),
        alignment: AlignmentDirectional.centerStart,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.iconData!, color: CretaColor.primary),
          ],
        ),
      );
    }
    return Container(
      padding: EdgeInsets.only(left: widget.width / 8),
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        widget.caption,
        style: CretaFont.titleLarge.copyWith(color: _getfgColor()),
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
      ),
    );
  }
}
