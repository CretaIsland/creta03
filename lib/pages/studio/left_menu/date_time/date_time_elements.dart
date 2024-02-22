import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'date_time_type.dart';

class DateTimeElements extends StatefulWidget {
  final DateTimeFormat infoType;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final TextStyle? titleTextStyle;
  final BorderRadiusGeometry? radius;
  final void Function(DateTimeFormat)? onPressed;

  const DateTimeElements({
    super.key,
    required this.infoType,
    required this.width,
    required this.height,
    this.textStyle,
    this.border,
    this.titleTextStyle,
    this.radius,
    this.onPressed,
  });

  @override
  State<DateTimeElements> createState() => _DateTimeElementsState();
}

class _DateTimeElementsState extends State<DateTimeElements> {
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
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: DateTimeType(
        dateTimeFormat: widget.infoType,
        frameManager: null,
        frameMid: null,
        child: null,
      ),
    );
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
          width: _isClicked ? widget.width + 2 : widget.width,
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
      width: widget.width,
      height: widget.height,
      child: Center(child: _main()),
    );
  }
}
