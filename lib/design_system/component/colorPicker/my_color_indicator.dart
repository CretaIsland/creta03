import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_color.dart';
import 'my_color_picker.dart';

class MyColorIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final double opacity;
  final Color color;
  final void Function(Color) onColorChanged;
  final Function? onClicked;
  final Gradient? gradient;

  const MyColorIndicator(
      {super.key,
      this.width = 24,
      this.height = 24,
      this.radius = 4,
      this.opacity = 1,
      this.gradient,
      this.onClicked,
      required this.color,
      required this.onColorChanged});

  @override
  State<MyColorIndicator> createState() => _MyColorIndicatorState();
}

class _MyColorIndicatorState extends State<MyColorIndicator> {
  ui.Image? _gridImage;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.color == Colors.transparent) {
      return _transparentCase();
    }
    return _normalCase();
  }

  Widget _normalCase() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: (widget.opacity >= 1 || widget.opacity < 0)
              ? widget.color
              : widget.color.withOpacity(widget.opacity),
          gradient: widget.gradient,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          border: Border.all(
            width: 2,
            color: CretaColor.text[200]!,
          )),
      child: InkWell(
        onTap: () {
          logger.finest('color picker invoke');
          widget.onClicked?.call();
          MyColorPicker.colorPickerDialog(
            context: context,
            dialogPickerColor: widget.color,
            onColorChanged: widget.onColorChanged,
            onExit: () {
              Navigator.of(
                MyColorPicker.colorPickerKey.currentState!.context,
                rootNavigator: true,
              ).pop();
            },
          );
        },
      ),
    );
  }

  Widget _transparentCase() {
    return FutureBuilder<ui.Image>(
        future: getGridImage(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();

          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                // border: Border.all(
                //   width: 2,
                //   color: CretaColor.text[200]!,
                // )
              ),
              child: InkWell(
                onTap: () {
                  logger.finest('color picker invoke');
                  MyColorPicker.colorPickerDialog(
                    context: context,
                    dialogPickerColor: widget.color,
                    onColorChanged: widget.onColorChanged,
                    onExit: () {
                      Navigator.of(
                        MyColorPicker.colorPickerKey.currentState!.context,
                        rootNavigator: true,
                      ).pop();
                    },
                  );
                },
                child: RawImage(
                  image: _gridImage!,
                  width: widget.width,
                  height: widget.height,
                ),
              ),
            );
          }
          return Container();
        });
  }

  Future<ui.Image> getGridImage() {
    if (_gridImage != null) return Future.value(_gridImage);
    final completer = Completer<ui.Image>();
    const AssetImage('assets/grid.png')
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      _gridImage = info.image;
      completer.complete(_gridImage);
    }));
    return completer.future;
  }
}
