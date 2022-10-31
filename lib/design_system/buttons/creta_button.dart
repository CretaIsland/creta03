// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'package:creta03/design_system/creta_color.dart';
import 'package:flutter/material.dart';

enum CretaButtonType {
  iconOnly,
  textOnly,
  iconText,
  textIcon,
  imageText,
  child,
}

enum CretaButtonDeco {
  fill,
  line,
  opacity,
  shadow,
}

enum CretaButtonColor {
  blue,
  sky,
  gray,
  gray100,
  gray200,
  white,
  white300,
  purple,
  black,
  red,
  transparent,
}

class CretaButton extends StatefulWidget {
  final CretaButtonType buttonType;
  final CretaButtonColor buttonColor;
  final CretaButtonDeco decoType;
  final Widget? text;
  final Icon? icon;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final Widget? child;
  final bool isSelectedWidget;

  final String? textString;
  final TextStyle? textStyle;

  final IconData? iconData;
  final double? iconSize;

  final Widget? image;

  Color? bgColor;
  Color? hoverColor;
  Color? clickColor;
  Color? selectColor;

  Color? fgColor;
  Color? fgHoverColor;
  Color? fgClickColor;

  CretaButton({
    required this.buttonType,
    required this.onPressed,
    this.buttonColor = CretaButtonColor.blue,
    this.decoType = CretaButtonDeco.fill,
    this.text,
    this.textString,
    this.textStyle,
    this.icon,
    this.iconData,
    this.iconSize,
    this.image,
    this.child,
    this.width,
    this.height,
    this.isSelectedWidget = false,
    Key? key,
  }) : super(key: key) {
    _setColor();
  }

  @override
  State<CretaButton> createState() => _CretaButtonState();

  void _setColor() {
    if (buttonColor == CretaButtonColor.white) {
      bgColor = Colors.white;
      hoverColor = CretaColor.text[100]!;
      clickColor = CretaColor.text[200]!;
      selectColor = CretaColor.text[700]!;
    } else if (buttonColor == CretaButtonColor.white300) {
      bgColor = Colors.white;
      hoverColor = CretaColor.text[300]!;
      clickColor = CretaColor.text[400]!;
    } else if (buttonColor == CretaButtonColor.gray100) {
      bgColor = CretaColor.text[100]!;
      hoverColor = CretaColor.text[200]!;
      clickColor = CretaColor.text[300]!;
    } else if (buttonColor == CretaButtonColor.gray200) {
      bgColor = CretaColor.text[200]!;
      hoverColor = CretaColor.text[300]!;
      clickColor = CretaColor.text[400]!;
    } else if (buttonColor == CretaButtonColor.gray) {
      bgColor = CretaColor.text[900]!.withOpacity(0.25);
      hoverColor = CretaColor.text[900]!.withOpacity(0.40);
      clickColor = CretaColor.text[900]!.withOpacity(0.60);
    } else if (buttonColor == CretaButtonColor.sky) {
      bgColor = Colors.white;
      hoverColor = CretaColor.primary[200]!;
      clickColor = CretaColor.primary[300]!;
      selectColor = CretaColor.primary[400]!;
    } else if (buttonColor == CretaButtonColor.purple) {
      bgColor = CretaColor.secondary;
      hoverColor = CretaColor.secondary[500]!;
      clickColor = CretaColor.secondary[600]!;
    } else if (buttonColor == CretaButtonColor.black) {
      bgColor = CretaColor.text[700]!;
      hoverColor = CretaColor.text[600]!;
      clickColor = CretaColor.text[500]!;
    } else if (buttonColor == CretaButtonColor.red) {
      bgColor = CretaColor.red;
      hoverColor = CretaColor.red[600]!;
      clickColor = CretaColor.red[700]!;
    } else if (buttonColor == CretaButtonColor.transparent) {
      bgColor = Colors.transparent;
      hoverColor = Colors.transparent;
      clickColor = Colors.transparent;
      fgColor = CretaColor.primary;
      fgHoverColor = CretaColor.primary[500];
      fgClickColor = CretaColor.primary[600];
    } else {
      bgColor = CretaColor.primary[400]!;
      hoverColor = CretaColor.primary[500]!;
      clickColor = CretaColor.primary[600]!;
    }
  }
}

class _CretaButtonState extends State<CretaButton> {
  bool hover = false;
  bool clicked = false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    print('build $hover $clicked $selected');
    return GestureDetector(
      onLongPressDown: (details) {
        setState(() {
          clicked = true;
          if (widget.isSelectedWidget) {
            selected = !selected;
          }
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
            print('hover is false');
            hover = false;
            clicked = false;
          });
        },
        onEnter: (val) {
          setState(() {
            print('hover is true');
            hover = true;
          });
        },
        // child: Transform.scale(
        //   scale: getScale(),
        //   child: Container(
        //     decoration: getDeco(),
        //     width: widget.width ?? getWidth(),
        //     height: widget.height ?? getHeight(),
        //     child: Center(
        //       child: getChild(),
        //     ),
        //   ),
        // )
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transformAlignment: AlignmentDirectional.center,
          transform: Matrix4.identity()..scale(_getScale()),
          decoration: _getDeco(),
          width: widget.width ?? _getWidth(),
          height: widget.height ?? _getHeight(),
          //child: Center(
          child: _getChild(),
          //),
        ),
      ),
    );
  }

  double _getScale() {
    return clicked ? 0.9 : 1.0;
  }

  Border? _getBorder() {
    if (selected) {
      if (widget.decoType == CretaButtonDeco.fill) {
        return Border.all(width: 1, color: CretaColor.primary[300]!);
      }
    }
    if (widget.decoType == CretaButtonDeco.line) {
      if (widget.buttonColor == CretaButtonColor.sky) {
        return Border.all(width: 1, color: CretaColor.primary[500]!);
      }
      if (widget.buttonColor == CretaButtonColor.white) {
        return Border.all(width: 1, color: CretaColor.text[700]!);
      }
      if (widget.buttonColor == CretaButtonColor.purple) {
        return Border.all(width: 1, color: CretaColor.secondary);
      }
      if (widget.buttonColor == CretaButtonColor.red) {
        return Border.all(width: 1, color: CretaColor.red);
      }
      if (widget.buttonColor == CretaButtonColor.transparent) {
        return Border.all(width: 1, color: CretaColor.primary[500]!);
      }
    }
    return null;
  }

  Decoration? _getDeco() {
    return BoxDecoration(
      border: _getBorder(),
      color: _getColor(),
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
  }

  Color _getColor() {
    if (selected) {
      if (widget.selectColor != null && widget.decoType == CretaButtonDeco.line) {
        return widget.selectColor!;
      }
    }
    return hover ? (clicked ? widget.clickColor! : widget.hoverColor!) : widget.bgColor!;
  }

  Widget _getText() {
    if (widget.textString != null && widget.textStyle != null) {
      //if (selected && widget.isSelectedWidget && widget.buttonColor == CretaButtonColor.white) {
      if (selected && widget.isSelectedWidget) {
        if (widget.buttonType == CretaButtonType.textOnly) {
          return Center(
            child: Text(widget.textString!, style: widget.textStyle!.copyWith(color: Colors.white)),
          );
        }
        return Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
          child: Text(widget.textString!, style: widget.textStyle!.copyWith(color: Colors.white)),
        );
      }
      if (widget.buttonType == CretaButtonType.textOnly) {
        return Center(
          child: Text(widget.textString!, style: widget.textStyle!),
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(6, 0, 0, 3),
        child: Text(widget.textString!,
            style: widget.buttonColor == CretaButtonColor.transparent
                ? widget.textStyle!.copyWith(
                    color: _getFgColor(),
                  )
                : widget.textStyle!),
      );
    }
    return widget.text!;
  }

  Icon _getIcon() {
    if (widget.iconData != null && widget.iconSize != null) {
      if (widget.buttonColor == CretaButtonColor.transparent) {
        return Icon(
          widget.iconData!,
          color: _getFgColor(),
          size: widget.iconSize,
        );
      }
    }
    return widget.icon!;
  }

  Color _getFgColor() {
    return hover ? (clicked ? widget.fgClickColor! : widget.fgHoverColor!) : widget.fgColor!;
  }

  Widget _getChild() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return _getIcon();
    }
    if (widget.buttonType == CretaButtonType.textOnly) {
      return _getText();
    }
    if (widget.buttonType == CretaButtonType.iconText) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          hover ? _getIcon() : Container(),
          AnimatedPadding(
            curve: Curves.easeOutQuad,
            padding: EdgeInsetsDirectional.only(start: hover ? widget.width! / 14 : 0),
            duration: Duration(milliseconds: 800),
            child: _getText(),
          ),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.textIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedPadding(
            curve: Curves.easeOutQuad,
            padding: EdgeInsetsDirectional.only(end: hover ? widget.width! / 14 : 0),
            duration: Duration(milliseconds: 800),
            child: _getText(),
          ),
          hover ? _getIcon() : Container(),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.imageText && widget.image != null) {
      return Row(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.image!,
          _getText(),
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.child) {
      return widget.child!;
    }

    return Container();
  }

  double? _getWidth() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }

  double? _getHeight() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }
}
