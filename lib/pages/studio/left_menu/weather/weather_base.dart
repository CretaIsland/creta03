import 'package:flutter/material.dart';

import '../left_menu_ele_button.dart';

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
  // final bool _isHover = false;
  // final bool _isClicked = false;

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
    return LeftMenuEleButton(
      height: widget.height,
      width: widget.width,
      onPressed: widget.onPressed,
      child: widget.nameText!,
    );
    // return BackdropFilter(
    //   filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
    //   child: MouseRegion(
    //     onExit: (value) {
    //       setState(() {
    //         _isHover = false;
    //         _isClicked = false;
    //       });
    //     },
    //     onEnter: (value) {
    //       setState(() {
    //         _isHover = true;
    //       });
    //     },
    //     child: GestureDetector(
    //       onLongPressDown: (d) {
    //         setState(() {
    //           _isClicked = true;
    //         });
    //         widget.onPressed?.call();
    //       },
    //       child: Container(
    //         width: _isClicked ? widget.width + 3 : widget.width,
    //         height: _isClicked ? widget.height + 3 : widget.height,
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: _isHover ? CretaColor.primary : CretaColor.text[200]!,
    //             width: _isHover ? 4 : 1,
    //           ),
    //         ),
    //         child: Center(
    //           child: widget.nameText,
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
