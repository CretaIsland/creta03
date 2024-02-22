import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class CretaRectButton extends StatefulWidget {
  final void Function() onPressed;
  final String title;
  const CretaRectButton({super.key, required this.onPressed, required this.title});

  @override
  State<CretaRectButton> createState() => _CretaRectButtonState();
}

class _CretaRectButtonState extends State<CretaRectButton> {
  bool _isHover = false;
  bool _isClick = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      child: GestureDetector(
        onLongPressDown: (detail) {
          setState(() {
            _isClick = true;
          });
          widget.onPressed();
        },
        onTapUp: (d) {
          setState(() {
            _isClick = false;
          });
        },
        child: Container(
          padding: const EdgeInsets.only(left: 12),
          width: 332,
          height: 40,
          color: _isClick ? CretaColor.text[300]! : CretaColor.text[200]!,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(widget.title,
                textAlign: TextAlign.left,
                style: _isHover
                    ? CretaFont.titleSmall.copyWith(color: Colors.black)
                    : CretaFont.titleSmall.copyWith(color: CretaColor.text[700]!)),
          ),
        ),
      ),
    );
  }
}
