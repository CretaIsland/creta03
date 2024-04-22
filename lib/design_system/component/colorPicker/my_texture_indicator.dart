import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:glass/glass.dart';
import '../creta_texture_widget.dart';

import '../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class MyTextureIndicator extends StatefulWidget {
  final bool isSelected;
  final bool isBigOne;
  final double width;
  final double height;
  final double radius;
  final double opacity;
  final Color color;
  final TextureType textureType;
  final void Function(TextureType) onTextureChanged;

  const MyTextureIndicator(
      {super.key,
      this.isBigOne = false,
      this.isSelected = false,
      this.width = 24,
      this.height = 24,
      this.radius = 4,
      this.opacity = 1,
      this.color = Colors.transparent,
      required this.textureType,
      required this.onTextureChanged});

  @override
  State<MyTextureIndicator> createState() => _MyTextureIndicatorState();
}

class _MyTextureIndicatorState extends State<MyTextureIndicator> {
  ui.Image? _gridImage;

  @override
  Widget build(BuildContext context) {
    if (widget.isBigOne) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.textureType == TextureType.end ? _imageFileCase() : _drawingCase(),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              CretaStudioLang['textureTypeList']![widget.textureType.index],
              style: CretaFont.buttonSmall,
            ),
          ),
        ],
      );
    }
    return widget.textureType == TextureType.end ? _imageFileCase() : _drawingCase();
  }

  Widget _drawingCase() {
    if (widget.textureType == TextureType.glass) {
      return basicBox(useColor: false).asGlass(tintColor: Colors.blue);
    }
    return basicBox();
  }

  Widget basicBox({bool useColor = true}) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          color: useColor == true
              ? widget.opacity == 1
                  ? widget.color
                  : widget.color.withOpacity(widget.opacity)
              : null,
          borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
          border: Border.all(
            width: widget.isSelected ? 4 : 1,
            color: widget.isSelected ? CretaColor.primary : CretaColor.text[200]!,
          )),
      child: InkWell(
        onTap: () {
          logger.finest('textureType picker');
          widget.onTextureChanged.call(widget.textureType);
        },
      ),
    );
  }

  Widget _imageFileCase() {
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
                  logger.finest('textureType picker');
                  widget.onTextureChanged.call(widget.textureType);
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
