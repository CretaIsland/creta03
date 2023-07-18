import 'package:flutter/material.dart';
import '../left_menu_ele_button.dart';

class MusicPlayerBase extends StatefulWidget {
  final Text? nameText;
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
      this.nameText,
      this.onPressed,
      this.radius = 4.0});

  @override
  State<MusicPlayerBase> createState() => _MusicPlayerBaseState();
}

class _MusicPlayerBaseState extends State<MusicPlayerBase> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipPath(
          clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.radius))),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Stack(
              children: [widget.playerWidget, _playerFG()],
            ),
          ),
        ),
        widget.nameText!,
      ],
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

  // Widget _removeBtn() {
  //   return BTN.fill_blue_i_menu(
  //     tooltip: CretaStudioLang.linkFrameTooltip,
  //     tooltipFg: CretaColor.text,
  //     icon: Icons.close,
  //     decoType: CretaButtonDeco.opacity,
  //     iconColor: Colors.transparent,
  //     buttonColor: CretaButtonColor.primary,
  //     onPressed: () {},
  //   );
  // }
}
