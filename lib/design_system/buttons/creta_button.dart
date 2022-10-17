// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/creta_color.dart';
import 'package:flutter/material.dart';

enum CretaButtonType {
  iconOnly,
  textOnly,
  iconText,
}

enum CretaButtonStyle {
  basic,
  simple,
  hoverAnimate,
  clickAnimate,
}

class CretaButton extends StatefulWidget {
  final CretaButtonType buttonType;
  final CretaButtonStyle buttonStyle;
  final Widget? text;
  final IconData? iconData;
  final void Function() onPressed;

  CretaButton({
    required this.buttonType,
    required this.buttonStyle,
    required this.onPressed,
    this.text,
    this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  State<CretaButton> createState() => _CretaButtonState();
}

class _CretaButtonState extends State<CretaButton> {
  bool hover = false;
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        setState(() {
          clicked = true;
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
            hover = false;
            clicked = false;
          });
        },
        onEnter: (val) {
          setState(() {
            hover = true;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..scale(getScale()),
          decoration: getDeco(),
          width: getWidth(),
          height: getHeight(),
          child: Center(
            child: getChild(),
          ),
        ),
      ),
    );
  }

  List<Color> gradientColors() {
    if (hover) {
      if (clicked) {
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
      return [CretaColor.primary[500]!, CretaColor.primary[500]!];
    }
    return [CretaColor.primary[400]!, CretaColor.primary[400]!];
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
      return BoxDecoration(
        color: hover
            ? (clicked ? CretaColor.primary[600]! : CretaColor.primary[500]!)
            : CretaColor.primary[400]!,
        borderRadius: BorderRadius.all(widget.buttonType == CretaButtonType.iconOnly
            ? Radius.circular(36)
            : Radius.circular(38)),
      );
    }
    if (isAnimate()) {
      return BoxDecoration(
        //gradient: RadialGradient(colors: gradientColors()),
        gradient: LinearGradient(
            colors: gradientColors(), begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.all(widget.buttonType == CretaButtonType.iconOnly
            ? Radius.circular(36)
            : Radius.circular(38)),
        boxShadow: clicked
            ? [
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: CretaColor.primary[600]!,
                  offset: Offset(2, 2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: CretaColor.primary[600]!,
                  offset: Offset(-2, 2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: CretaColor.primary[600]!,
                  offset: Offset(2, -2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  //color: Colors.grey.shade500,
                  color: CretaColor.primary[600]!,
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
      return Icon(
        widget.iconData!,
        size: 20,
        color: CretaColor.text[100]!,
      );
    }
    if (widget.buttonType == CretaButtonType.textOnly) {
      return widget.text!;
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
