import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../design_system/creta_color.dart';

class WeatherBase extends StatefulWidget {
  final Text? nameText;
  final Widget weatherWidget;
  final double width;
  final double height;
  final void Function()? onPressed;
  final double radius;

  const WeatherBase(
      {super.key,
      required this.weatherWidget,
      required this.width,
      required this.height,
      this.nameText,
      this.onPressed,
      this.radius = 4.0});

  @override
  State<WeatherBase> createState() => _WeatherBaseState();
}

class _WeatherBaseState extends State<WeatherBase> {
  bool _isHover = false;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius))),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: widget.nameText != null
            ? Stack(
                children: [widget.weatherWidget, _weatherFG()],
              )
            : widget.weatherWidget,
      ),
    );
  }

  Widget _weatherFG() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
      child: MouseRegion(
        onExit: (value) {
          setState(() {
            _isHover = false;
          });
        },
        onEnter: (value) {
          setState(() {
            _isHover = true;
          });
        },
        child: GestureDetector(
          onTapDown: (d) {
            print('onTapDown======================');
          },
          onTapUp: (d) {
            print('onTapUp======================');
          },
          onTap: () {
            print('onTap======================');
          },
          onLongPressDown: (d) {
            print('##################################');
            widget.onPressed?.call();
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: _isHover ? CretaColor.primary : CretaColor.text[200]!,
                width: _isHover ? 4 : 1,
              ),
            ),
            child: Center(
              child: widget.nameText,
            ),
          ),
        ),
      ),
    );
  }
}
