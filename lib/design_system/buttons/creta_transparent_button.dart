import 'package:flutter/material.dart';

class CretaTrasparentButton extends StatefulWidget {
  final void Function() onPressed;
  final IconData icon1;
  final IconData icon2;
  final double iconSize;
  final bool doToggle;
  final bool toggleValue;
  final Color iconColor;
  final String? tooltip;

  const CretaTrasparentButton({
    super.key,
    required this.onPressed,
    required this.icon1,
    required this.icon2,
    required this.iconSize,
    this.doToggle = true,
    required this.toggleValue,
    this.iconColor = Colors.white,
    this.tooltip,
  });

  @override
  State<CretaTrasparentButton> createState() => _CretaTrasparentButtonState();
}

class _CretaTrasparentButtonState extends State<CretaTrasparentButton> {
  bool _isClick = false;
  bool _isHover = false;
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _toggleValue = widget.toggleValue;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.doToggle == false) {
      _toggleValue = widget.toggleValue;
    }

    Widget iconWidget = Icon(_toggleValue == true ? widget.icon1 : widget.icon2,
        color: _isHover ? widget.iconColor : widget.iconColor.withOpacity(0.75));

    return SizedBox(
      width: _isClick ? widget.iconSize : widget.iconSize * 1.2,
      height: _isClick ? widget.iconSize : widget.iconSize * 1.2,
      child: Center(
        child: GestureDetector(
          onLongPressDown: (details) {
            setState(() {
              _isClick = true;
            });
          },
          onTapUp: (details) {
            setState(() {
              _isClick = false;
              if (widget.doToggle) {
                _toggleValue = !_toggleValue;
              }
            });
            widget.onPressed.call();
          },
          child: MouseRegion(
            onExit: (val) {
              setState(() {
                _isHover = false;
              });
            },
            onEnter: (val) {
              setState(() {
                _isHover = true;
              });
            },
            child: Center(
              child: widget.tooltip != null
                  ? Tooltip(message: widget.tooltip, child: iconWidget)
                  : iconWidget,
            ),
          ),
        ),
      ),
    );
  }
}
