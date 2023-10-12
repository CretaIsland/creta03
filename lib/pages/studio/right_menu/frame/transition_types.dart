import 'dart:math';

import 'package:creta03/design_system/component/example_box_mixin.dart';
import 'package:flutter/material.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';

class TransitionTypes extends StatefulWidget {
  final double? width;
  final double? height;
  final FrameModel model;
  final NextContentTypes nextContentTypes;
  final String name;
  final FrameManager frameManager;
  const TransitionTypes({
    super.key,
    this.width,
    this.height,
    required this.frameManager,
    required this.model,
    required this.nextContentTypes,
    required this.name,
  });

  @override
  State<TransitionTypes> createState() => _TransitionTypesState();
}

class _TransitionTypesState extends State<TransitionTypes> with ExampleBoxStateMixin {
  late PageController _pageController;
  late int _currentPage;
  ContentsManager? _contentsManager;
  bool _emptyCarousel = true;
  int _length = 3;

  @override
  void initState() {
    super.initState();
    _contentsManager = widget.frameManager.getContentsManager(widget.model.mid);
    if (_contentsManager == null) {
      _currentPage = 0;
    } else {
      _currentPage = _contentsManager!.modelList.length ~/ 2;
      if (_contentsManager!.modelList.length >= 3) {
        _length = _contentsManager!.modelList.length;
        _emptyCarousel = false;
      }
    }
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.7);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return selectWidget();
  }

  Widget selectWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6.0),
      child: PageView.builder(
          itemCount: _length,
          physics: const ClampingScrollPhysics(),
          controller: _pageController,
          itemBuilder: (context, index) {
            return carouselView(index);
          }),
    );
  }

  Widget carouselView(int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0.0;
        if (_pageController.position.haveDimensions) {
          value = index.toDouble() - (_pageController.page ?? 0);
          value = (value * 0.048).clamp(-1, 1);
          // print("value $value index $index");
        }
        late double angle;
        switch (widget.nextContentTypes) {
          case NextContentTypes.normalCarousel:
            angle = 0.0;
            break;
          case NextContentTypes.tiltedCarousel:
            angle = pi * value;
            break;
          default:
            angle = 0.0;
            break;
        }
        return Transform.rotate(
          angle: angle,
          child: carouselCard(
              _emptyCarousel ? null : _contentsManager!.modelList[index] as ContentsModel),
        );
      },
    );
  }

  Widget carouselCard(ContentsModel? contentsModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: contentsModel == null
          ? Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    color: Colors.black26,
                  ),
                ],
              ),
              child: Center(
                  child: Text(
                widget.name,
                style: CretaFont.titleSmall,
                textAlign: TextAlign.center,
              )),
            )
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(_imageName(contentsModel)),
                  )),
            ),
    );
  }

  String _imageName(ContentsModel contentsModel) {
    if (contentsModel.isImage()) return contentsModel.getURI();
    if (contentsModel.thumbnail == null) return '';
    return contentsModel.thumbnail!;
  }
}
