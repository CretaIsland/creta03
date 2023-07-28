import 'package:flutter/material.dart';
import '../left_menu_ele_button.dart';

class MusicPlayerBase extends StatefulWidget {
  final Widget playerWidget;
  final double width;
  final double height;
  final void Function()? onPressed;
  final double radius;

  const MusicPlayerBase(
      {super.key,
      required this.playerWidget,
      required this.width,
      required this.height,
      this.onPressed,
      this.radius = 4.0});

  @override
  State<MusicPlayerBase> createState() => _MusicPlayerBaseState();
}

class _MusicPlayerBaseState extends State<MusicPlayerBase> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        children: [widget.playerWidget, _playerFG()],
      ),
    );
  }

  Widget _playerFG() {
    return LeftMenuEleButton(
      height: widget.height,
      width: widget.width,
      onPressed: widget.onPressed,
      child: Container(),
    );
  }
}
