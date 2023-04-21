import 'package:flutter/material.dart';

import '../buttons/creta_button_wrapper.dart';

class CretaIconToggleButton extends StatefulWidget {
  final bool toggleValue;
  final IconData icon1;
  final IconData icon2;
  final Function onPressed;
  final String? tooltip;

  const CretaIconToggleButton(
      {super.key,
      required this.toggleValue,
      required this.icon1,
      required this.icon2,
      required this.onPressed,
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
