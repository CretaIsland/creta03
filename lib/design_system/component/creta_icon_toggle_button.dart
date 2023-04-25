// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

import '../buttons/creta_button_wrapper.dart';
import '../creta_color.dart';

enum ToggleButtonStyle {
  floating_l,
  fill_gray_i_s,
}

class CretaIconToggleButton extends StatefulWidget {
  final bool toggleValue;
  final IconData icon1;
  final IconData icon2;
  final Function onPressed;
  final String? tooltip;
  final ToggleButtonStyle buttonStyle;
  final double buttonSize;

  const CretaIconToggleButton(
      {super.key,
      required this.toggleValue,
      required this.icon1,
      required this.icon2,
      required this.onPressed,
      this.buttonSize = 28,
      this.buttonStyle = ToggleButtonStyle.floating_l,
      this.tooltip});

  @override
  State<CretaIconToggleButton> createState() => _CretaIconToggleButtonState();
}

class _CretaIconToggleButtonState extends State<CretaIconToggleButton> {
  late bool _toggleValue;

  @override
  void initState() {
    super.initState();
    _toggleValue = widget.toggleValue;
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.buttonStyle) {
      case ToggleButtonStyle.fill_gray_i_s:
        return BTN.fill_gray_i_s(
          buttonSize: widget.buttonSize,
          tooltip: widget.tooltip,
          tooltipBg: CretaColor.text[700]!,
          icon: _toggleValue ? widget.icon1 : widget.icon2,
          onPressed: () {
            setState(() {
              _toggleValue = !_toggleValue;
            });
            widget.onPressed.call();
          },
        );
      default:
        return BTN.floating_l(
          icon: _toggleValue ? widget.icon1 : widget.icon2,
          onPressed: () {
            setState(() {
              _toggleValue = !_toggleValue;
            });
            widget.onPressed.call();
          },
          hasShadow: false,
          tooltip: widget.tooltip,
        );
    }
  }
}
