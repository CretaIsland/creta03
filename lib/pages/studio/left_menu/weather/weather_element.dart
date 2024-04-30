import 'package:creta03/pages/studio/left_menu/weather/wether_variables.dart';
import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class WeatherElement extends StatefulWidget {
  final WeatherInfoType infoType;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final bool hasTitle;
  final TextStyle? titleTextStyle;
  final BorderRadiusGeometry? radius;
  final void Function(WeatherInfoType)? onPressed;

  const WeatherElement({
    super.key,
    required this.infoType,
    required this.width,
    required this.height,
    this.textStyle,
    this.border,
    this.hasTitle = false,
    this.titleTextStyle,
    this.radius,
    this.onPressed,
  });

  @override
  State<WeatherElement> createState() => _WeatherElementState();
}

class _WeatherElementState extends State<WeatherElement> {
  TextStyle? _textStyle;
  TextStyle? _titleTextStyle;
  bool _isHover = false;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
    _textStyle = widget.textStyle;
    _textStyle ??= CretaFont.bodyMedium;
    _titleTextStyle = widget.titleTextStyle;
    _titleTextStyle ??= CretaFont.bodySmall;
  }

  @override
  Widget build(BuildContext context) {
    return widget.onPressed == null ? _noActionCase() : _hasActionCase();
  }

  Widget _main() {
    return widget.hasTitle
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0,),
                child:
                    Text(WeatherVariables.getTitleText(widget.infoType), style: _titleTextStyle!),
              ),
              Text(WeatherVariables.getInfoText(widget.infoType), style: _textStyle!),
            ],
          )
        : Text(WeatherVariables.getInfoText(widget.infoType), style: _textStyle!);
  }

  Widget _hasActionCase() {
    return MouseRegion(
      onExit: (value) {
        setState(() {
          _isHover = false;
          _isClicked = false;
        });
      },
      onEnter: (value) {
        setState(() {
          _isHover = true;
        });
      },
      child: GestureDetector(
        onLongPressDown: (d) {
          setState(() {
            _isClicked = true;
          });
          widget.onPressed?.call(widget.infoType);
        },
        child: Container(
          //width: _isClicked ? widget.width + 2 : widget.width,
          height: _isClicked ? widget.height + 2 : widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHover ? CretaColor.primary : CretaColor.text[400]!,
              width: _isHover ? 2 : 1,
            ),
            borderRadius: widget.radius,
            color: Colors.transparent,
          ),
          child: Center(
            child: _main(),
          ),
        ),
      ),
    );
  }

  Widget _noActionCase() {
    return Container(
      decoration: BoxDecoration(
        border: widget.border,
        borderRadius: widget.radius,
        color: Colors.transparent,
      ),
      //width: widget.width,
      height: widget.height,
      child: Center(child: _main()),
    );
  }
}
