import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';

class CretaAniIcon extends StatefulWidget {
  final IconData startIcon;
  final IconData endIcon;
  final double size;
  final Color? startIconColor;
  final Color? endIconColor;
  final Duration duration;
  final void Function() onPressed;
  final bool clockwise;

  const CretaAniIcon({
    super.key,
    required this.startIcon,
    required this.endIcon,
    required this.onPressed,
    this.size = 16,
    this.startIconColor = Colors.deepPurple,
    this.endIconColor = Colors.deepOrange,
    this.duration = const Duration(milliseconds: 500),
    this.clockwise = false,
  });

  @override
  State<CretaAniIcon> createState() => _CretaAniIconState();
}

class _CretaAniIconState extends State<CretaAniIcon> {
  late AnimateIconController _controller;

  @override
  void initState() {
    _controller = AnimateIconController();
       super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimateIcons(
      startIcon: widget.startIcon,
      endIcon: widget.endIcon,
      size: widget.size,
      controller: _controller,
      onStartIconPress: () {
        widget.onPressed();
        return true;
      },
      onEndIconPress: () {
        widget.onPressed();
        return true;
      },
      duration: widget.duration,
      startIconColor: widget.startIconColor,
      endIconColor: widget.endIconColor,
      clockwise: widget.clockwise,
    );
  }
}
