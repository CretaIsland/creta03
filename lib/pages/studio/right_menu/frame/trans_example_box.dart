import 'dart:math';

import 'package:creta03/design_system/component/example_box_mixin.dart';
import 'package:flutter/material.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/frame_model.dart';

class TransExampleBox extends StatefulWidget {
  final FrameModel model;
  final NextContentTypes nextContentTypes;
  final String name;
  final FrameManager frameManager;
  final bool selectedTyped;
  final Function onTypeSelected;
  const TransExampleBox({
    super.key,
    required this.frameManager,
    required this.model,
    required this.nextContentTypes,
    required this.name,
    required this.selectedTyped,
    required this.onTypeSelected,
  });

  @override
  State<TransExampleBox> createState() => _TransExampleBoxState();
}

class _TransExampleBoxState extends State<TransExampleBox> with ExampleBoxStateMixin {
  late PageController _pageController;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.frameManager.modelList.length ~/ 2;
    _pageController = PageController(initialPage: _currentPage, viewportFraction: 0.5);
    super.initState();
  }

  void onSelected() {
    setState(() {
      // widget.model.nextContentTypes.set(NextContentTypes.none);
      widget.model.nextContentTypes.set(widget.nextContentTypes);
    });
    widget.onTypeSelected.call();
  }

  void onUnSelected() {
    setState(() {
      widget.model.nextContentTypes.set(NextContentTypes.none);
    });
    widget.onTypeSelected.call();
  }

  void rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildMixin(
      context,
      setState: rebuild,
      onSelected: onSelected,
      onUnselected: onUnSelected,
      selectWidget: selectWidget,
    );
  }

  Widget selectWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4.0),
      width: 148.0,
      child: PageView.builder(
          itemCount: widget.frameManager.modelList.length,
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
          value = (value * 0.038).clamp(-1, 1);
          // print("value $value index $index");
        }
        double angle = 0.0;
        switch (widget.nextContentTypes) {
          case NextContentTypes.normalCarousel:
            angle = 0.0;
            break;
          case NextContentTypes.tiltedCarousel:
            angle = pi * value;
          default:
            angle = 0.0;
        }
        return Transform.rotate(
          angle: angle,
          child: carouselCard(widget.frameManager.modelList[index] as FrameModel),
        );
      },
    );
  }

  Widget carouselCard(FrameModel frameModel) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(offset: Offset(0, 4), blurRadius: 4, color: Colors.black26),
          ],
        ),
        child: Center(
          child: Text(
            widget.name,
            style: CretaFont.titleSmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
