// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

import '../creta_color.dart';
import '../creta_font.dart';

enum FlutterButtonType {
  iconOnly,
  textOnly,
  iconText,
  textIcon,
  child,
}

class CretaTextButton extends StatefulWidget {
  String? text;
  IconData? iconData;
  Widget? child;
  final void Function() onPressed;
  final double width;
  final double height;
  late FlutterButtonType buttonType;

  CretaTextButton.iconText({
    Key? key,
    required this.iconData,
    required this.text,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = FlutterButtonType.iconText;
  }

  CretaTextButton.textIcon({
    Key? key,
    required this.iconData,
    required this.text,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = FlutterButtonType.textIcon;
  }

  CretaTextButton.text({
    Key? key,
    required this.text,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = FlutterButtonType.textOnly;
  }

  CretaTextButton.icon({
    Key? key,
    required this.iconData,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = FlutterButtonType.iconOnly;
  }

  CretaTextButton.child({
    Key? key,
    required this.child,
    this.width = 266,
    this.height = 72,
    required this.onPressed,
  }) : super(key: key) {
    buttonType = FlutterButtonType.child;
  }

  @override
  State<CretaTextButton> createState() => _CretaTextButtonState();
}

class _CretaTextButtonState extends State<CretaTextButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(0),
          //fixedSize: Size(18, 18),
          textStyle: CretaFont.titleLarge,
          shape: StadiumBorder(),
        ),
        child: chidrens(),
      ),
    );
  }

  Widget chidrens() {
    if (widget.buttonType == FlutterButtonType.iconOnly) {
      return Center(
          child: Icon(
        widget.iconData!,
        size: 20,
        color: CretaColor.text[100]!,
      ));
    }
    if (widget.buttonType == FlutterButtonType.textOnly) {
      return Center(child: Text(widget.text!));
    }
    if (widget.buttonType == FlutterButtonType.child) {
      return Center(child: widget.child!);
    }
    if (widget.buttonType == FlutterButtonType.iconText) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(widget.iconData!),
          SizedBox(
            width: 10,
          ),
          Text(widget.text!),
        ],
      );
    }
    if (widget.buttonType == FlutterButtonType.textIcon) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.text!),
          SizedBox(
            width: 10,
          ),
          Icon(widget.iconData!),
        ],
      );
    }
    return Container();
  }
}
