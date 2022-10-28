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

enum CretaButtonColor {
  blue,
  sky,
  gray,
  gray100,
  gray200,
  white,
  white300,
}

class CretaButton extends StatefulWidget {
  final CretaButtonType buttonType;
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
      bgColor = Colors.white;
      hoverColor = CretaColor.text[100]!;
      clickColor = CretaColor.text[200]!;
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
      onLongPressDown: (details) {
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

  double getScale() {
    return clicked ? 0.9 : 1.0;
  }

  Decoration? getDeco() {
    return BoxDecoration(
      border: selected ? Border.all(width: 1, color: CretaColor.primary[300]!) : null,
      color: hover ? (clicked ? widget.clickColor! : widget.hoverColor!) : widget.bgColor!,
      borderRadius: BorderRadius.all(Radius.circular(36)),
    );
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
          hover ? widget.icon! : Container(),
          AnimatedPadding(
            curve: Curves.easeOutQuad,
            padding: EdgeInsetsDirectional.only(start: hover ? widget.width! / 14 : 0),
            duration: Duration(milliseconds: 800),
            child: widget.text!,
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
            child: widget.text!,
          ),
          hover ? widget.icon! : Container(),
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
