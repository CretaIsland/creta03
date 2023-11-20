import 'package:creta03/design_system/component/custom_image.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/creta_color.dart';

class GiphySelectedWidget extends StatefulWidget {
  final String gifUrl;
  final double width;
  final double height;
  final void Function(String)? onPressed;

  const GiphySelectedWidget({
    super.key,
    required this.gifUrl,
    required this.width,
    required this.height,
    this.onPressed,
  });

  @override
  State<GiphySelectedWidget> createState() => _GiphySelectedWidgetState();
}

class _GiphySelectedWidgetState extends State<GiphySelectedWidget> {
  bool _isHover = false;
  bool _isClicked = false;
  String? selectedGif;

  @override
  void initState() {
    selectedGif = widget.gifUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onPressed == null ? _noActionCase() : _hasActionCase();
  }

  Widget _main() {
    return CustomImage(
      width: widget.width,
      height: widget.height,
      image: selectedGif!,
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
          widget.onPressed?.call(selectedGif!);
        },
        child: Container(
          width: _isClicked ? widget.width + 4 : widget.width,
          height: _isClicked ? widget.height + 4 : widget.height,
          decoration: BoxDecoration(
            border: Border.all(
              color: _isHover ? CretaColor.primary : CretaColor.text[400]!,
              width: _isHover ? 4 : 1,
            ),
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
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      width: widget.width,
      height: widget.height,
      child: Center(child: _main()),
    );
  }
}
