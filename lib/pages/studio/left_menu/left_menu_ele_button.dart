import 'package:flutter/material.dart';
import 'package:creta_common/common/creta_color.dart';
// import '../studio_variables.dart';

class LeftMenuEleButton extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;
  final void Function()? onPressed;
  final void Function()? onDoubleTap;
  final bool hasBorder;

  const LeftMenuEleButton({
    super.key,
    required this.child,
    required this.width,
    required this.height,
    this.onPressed,
    this.onDoubleTap,
    this.hasBorder = true,
    // this.isMultiSelectedCallback,
  });

  @override
  State<LeftMenuEleButton> createState() => _LeftMenuEleButtonState();
}

class _LeftMenuEleButtonState extends State<LeftMenuEleButton> {
  bool _isHover = false;
  bool _isClicked = false;

  @override
  Widget build(BuildContext context) {
    return

        // BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        //   child:

        MouseRegion(
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
          widget.onPressed?.call();
        },
        onLongPressUp: () {
          setState(() {
            _isClicked = false;
          });
        },
        onDoubleTapDown: (d) {
          setState(() {
            _isClicked = true;
          });
          widget.onDoubleTap?.call();
        },
        child: Container(
          width: _isClicked ? widget.width + 3 : widget.width,
          height: _isClicked ? widget.height + 3 : widget.height,
          decoration: widget.hasBorder
              ? BoxDecoration(
                  border: Border.all(
                    color: _isHover ? CretaColor.primary : CretaColor.text[200]!,
                    width: _isHover ? 4 : 1,
                  ),
                )
              : null,
          color: widget.hasBorder
              ? null
              : _isHover
                  ? CretaColor.text[200]!
                  : Colors.transparent,
          child: Center(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class TimelineSample extends StatelessWidget {
  const TimelineSample({
    super.key,
    required this.child,
    required this.title,
  });

  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        children: [
          child,
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }
}
