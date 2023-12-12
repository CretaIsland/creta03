import 'package:creta03/design_system/component/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';

import '../../../../design_system/creta_color.dart';
import '../../../../model/contents_model.dart';

class GiphySelectedWidget extends StatefulWidget {
  final String gifUrl;
  final double width;
  final double height;
  final void Function(String)? onPressed;
  final DropzoneViewController? controller;

  const GiphySelectedWidget({
    super.key,
    required this.gifUrl,
    required this.width,
    required this.height,
    this.controller,
    this.onPressed,
  });

  @override
  State<GiphySelectedWidget> createState() => _GiphySelectedWidgetState();
}

class _GiphySelectedWidgetState extends State<GiphySelectedWidget> {
  bool _isHover = false;
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget gifBox = Container(
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
        child: CustomImage(
          width: widget.width,
          height: widget.height,
          image: widget.gifUrl,
        ),
      ),
    );

    if (widget.onPressed == null) {
      return gifBox;
    }

    Widget emptyBox = Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isClicked ? CretaColor.primary : Colors.transparent,
          width: _isClicked ? 3 : 1,
        ),
      ),
    );

    ContentsModel? contentsModel = ContentsModel.withFrame(parent: '', bookMid: '');
    return InkWell(
      onHover: (isHover) {
        setState(() {
          _isHover = isHover;
          if (isHover == true) {
            _isClicked = isHover;
          }
        });
      },
      onTapDown: (details) {
        // print('widget.gifUrl ${widget.gifUrl}');
        setState(() {
          _isClicked = true;
        });
      },
      onDoubleTap: () {
        _isClicked = true;
        widget.onPressed?.call(widget.gifUrl);
      },
      onSecondaryTapDown: (details) {},
      child: Draggable(
        data: contentsModel,
        onDragStarted: () {
          print('widget.gifUrl ${widget.gifUrl}');
        },
        onDragCompleted: () {},
        feedback: emptyBox,
        childWhenDragging: emptyBox,
        child: gifBox,
      ),
      //),
    );
  }
}
