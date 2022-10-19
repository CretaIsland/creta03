// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print

import 'package:creta03/design_system/creta_color.dart';
import 'package:flutter/material.dart';

enum CretaButtonType {
  iconOnly,
  textOnly,
  iconText,
  textIcon,
  child,
  childSelected,
}

enum CretaButtonStyle {
  basic,
  simple,
  hoverAnimate,
  clickAnimate,
}

enum CretaButtonColor {
  blue,
  sky,
  gray,
  white,
}

class CretaButton extends StatefulWidget {
  final CretaButtonType buttonType;
  final CretaButtonStyle buttonStyle;
  final CretaButtonColor buttonColor;
  final Widget? text;
  final Icon? icon;
  final void Function() onPressed;
  final double? width;
  final double? height;
  final Widget? child;
  Color? bgColor;
  Color? hoverColor;
  Color? clickColor;

  CretaButton({
    required this.buttonType,
    required this.buttonStyle,
    required this.onPressed,
    this.buttonColor = CretaButtonColor.blue,
    this.text,
    this.icon,
    this.child,
    this.width,
    this.height,
    Key? key,
  }) : super(key: key) {
    if (buttonColor == CretaButtonColor.white) {
      bgColor = Colors.transparent;
      hoverColor = CretaColor.text[200]!;
      clickColor = CretaColor.text[700]!;
    } else if (buttonColor == CretaButtonColor.gray) {
      bgColor = CretaColor.text[400]!;
      hoverColor = CretaColor.text[600]!;
      clickColor = CretaColor.text[800]!;
    } else if (buttonColor == CretaButtonColor.sky) {
      bgColor = Colors.transparent;
      hoverColor = CretaColor.primary[200]!;
      clickColor = CretaColor.primary[300]!;
    } else {
      bgColor = CretaColor.primary[400]!;
      hoverColor = CretaColor.primary[500]!;
      clickColor = CretaColor.primary[600]!;
    }
  }

  @override
  State<CretaButton> createState() => _CretaButtonState();
}

class _CretaButtonState extends State<CretaButton> {
  bool hover = false;
  bool clicked = false;
  bool selected = false;
  @override
  Widget build(BuildContext context) {
    print('build $hover $clicked $selected');
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          clicked = true;
          if (widget.buttonType == CretaButtonType.childSelected) {
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(getScale()),
          decoration: getDeco(),
          width: widget.width ?? getWidth(),
          height: widget.height ?? getHeight(),
          child: Center(
            child: getChild(),
          ),
        ),
      ),
    );
  }

  Gradient? gradient() {
    if (!hover &&
        (widget.buttonType == CretaButtonType.childSelected ||
            widget.bgColor == Colors.transparent)) {
      // transparen 일때 이상현상이 나기 때문에...
      print("not hover or it's childSelected");
      return null;
    }
    return LinearGradient(
        colors: gradientColors(), begin: Alignment.topLeft, end: Alignment.bottomRight);
  }

  List<Color> gradientColors() {
    if (hover) {
      if (clicked) {
        if (widget.buttonColor == CretaButtonColor.white) {
          return [
            CretaColor.text[100]!,
            CretaColor.text[100]!,
            CretaColor.text[200]!,
            CretaColor.text[200]!,
            CretaColor.text[300]!,
            CretaColor.text[300]!,
            CretaColor.text[500]!,
          ];
        }
        if (widget.buttonColor == CretaButtonColor.gray) {
          return [
            CretaColor.text[300]!,
            CretaColor.text[300]!,
            CretaColor.text[400]!,
            CretaColor.text[400]!,
            CretaColor.text[500]!,
            CretaColor.text[500]!,
            CretaColor.text[600]!,
          ];
        }
        if (widget.buttonColor == CretaButtonColor.sky) {
          return [
            CretaColor.primary[100]!,
            CretaColor.primary[100]!,
            CretaColor.primary[200]!,
            CretaColor.primary[200]!,
            CretaColor.primary[300]!,
            CretaColor.primary[300]!,
            CretaColor.primary[400]!,
          ];
        }
        return [
          CretaColor.primary[300]!,
          CretaColor.primary[300]!,
          CretaColor.primary[400]!,
          CretaColor.primary[400]!,
          CretaColor.primary[500]!,
          CretaColor.primary[500]!,
          CretaColor.primary[600]!,
        ];
      }
      print('hover gradient color is widget.hoverColor');
      return [widget.hoverColor!, widget.hoverColor!];
    }

    return [widget.bgColor!, widget.bgColor!];
  }

  bool isAnimate() {
    if (widget.buttonStyle == CretaButtonStyle.hoverAnimate) return true;
    if (widget.buttonStyle == CretaButtonStyle.clickAnimate) return true;
    return false;
  }

  double getScale() {
    if (clicked && widget.buttonStyle == CretaButtonStyle.clickAnimate) {
      return 1.05;
    }
    if (hover && widget.buttonStyle == CretaButtonStyle.hoverAnimate) {
      return 1.05;
    }
    return 1.0;
  }

  Decoration? getDeco() {
    if (widget.buttonStyle == CretaButtonStyle.simple) {
      if (widget.buttonType == CretaButtonType.childSelected) {
        print('simple and childSelected');
        return BoxDecoration(
          border:
              (clicked || selected) ? Border.all(width: 1, color: CretaColor.primary[300]!) : null,
          gradient: gradient(),
          //color: hover ? CretaColor.primary[200]! : Colors.transparent,
          // color: hover
          //     ? (clicked
          //         ? selected
          //             ? Colors.transparent
          //             : CretaColor.primary[200]!
          //         : CretaColor.primary[200]!)
          //     : Colors.transparent,
          borderRadius: BorderRadius.all(widget.buttonType == CretaButtonType.iconOnly
              ? Radius.circular(36)
              : Radius.circular(38)),
        );
      }
      print(hover ? (clicked ? 'clicked' : 'hoverd') : 'nothing');
      return BoxDecoration(
        //color: hover ? (clicked ? widget.clickColor! : widget.hoverColor!) : widget.bgColor!,
        gradient: gradient(),
        borderRadius: BorderRadius.all(widget.buttonType == CretaButtonType.iconOnly
            ? Radius.circular(36)
            : Radius.circular(38)),
      );
    }
    if (isAnimate()) {
      return BoxDecoration(
        border: selected ? Border.all(width: 1, color: CretaColor.primary[300]!) : null,
        //gradient: RadialGradient(colors: gradientColors()),
        //color: hover ? (clicked ? widget.clickColor! : widget.hoverColor!) : widget.bgColor!,
        gradient: gradient(),
        borderRadius: BorderRadius.all(widget.buttonType == CretaButtonType.iconOnly
            ? Radius.circular(36)
            : Radius.circular(38)),
        boxShadow: clicked
            ? [
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: widget.clickColor!,
                  offset: Offset(2, 2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: widget.clickColor!,
                  offset: Offset(-2, 2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: widget.clickColor!,
                  offset: Offset(2, -2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: widget.clickColor!,
                  offset: Offset(-2, -2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      );
    }
    return null;
  }

  Widget getChild() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return widget.icon!;
    }
    if (widget.buttonType == CretaButtonType.textOnly) {
      return widget.text!;
    }
    if (widget.buttonType == CretaButtonType.iconText) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.icon!,
          widget.text!,
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.textIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.text!,
          widget.icon!,
        ],
      );
    }
    if (widget.buttonType == CretaButtonType.child) {
      return widget.child!;
    }
    if (widget.buttonType == CretaButtonType.childSelected) {
      return widget.child!;
    }
    return Container();
  }

  double? getWidth() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }

  double? getHeight() {
    if (widget.buttonType == CretaButtonType.iconOnly) {
      return 36;
    }
    return null;
  }
}
