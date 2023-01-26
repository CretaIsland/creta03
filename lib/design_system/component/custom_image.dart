// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../creta_color.dart';

class ImageDetail {
  late bool isLoaded = false;
  late int cumulativeBytesLoaded = 0;
  late int expectedTotalBytes = 1;
}

class ImageValueNotifier extends ValueNotifier<ImageDetail> {
  late ImageDetail _imageDetail;

  ImageValueNotifier(ImageDetail imageDetail) : super(imageDetail) {
    _imageDetail = imageDetail;
  }

  void changeLoadingState(bool isLoaded) {
    _imageDetail.isLoaded = isLoaded;
    notifyListeners();
  }

  void changeCumulativeBytesLoaded(int cumulativeBytesLoaded) {
    _imageDetail.cumulativeBytesLoaded = cumulativeBytesLoaded;
    notifyListeners();
  }
}

class CustomImage extends StatefulWidget {
  final double width;
  final double height;
  final String image;
  final int duration;
  final bool hasMouseOverEffect;
  CustomImage(
      {super.key,
      required this.width,
      required this.height,
      required this.image,
      this.hasMouseOverEffect = false,
      this.duration = 700});

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> with SingleTickerProviderStateMixin {
  late ImageStream _imageStream;
  late ImageInfo _imageInfo;

  late ImageDetail _imageDetail;
  late ImageValueNotifier _imageValueNotifier;

  late AnimationController _controller;
  late Animation<Size?> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );

    _animation = SizeTween(
            begin: Size(widget.width * 2.5, widget.height * 2.5),
            end: Size(widget.width, widget.height))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _imageDetail = ImageDetail();
    _imageValueNotifier = ImageValueNotifier(_imageDetail);

    _imageStream = NetworkImage(widget.image).resolve(const ImageConfiguration());
    _imageStream.addListener(ImageStreamListener(
      (info, value) {
        _imageInfo = info;
        _imageValueNotifier.changeLoadingState(true);
        _controller.forward();
      },
      onChunk: (event) {
        _imageDetail.expectedTotalBytes = event.expectedTotalBytes!;
        _imageValueNotifier.changeCumulativeBytesLoaded(event.cumulativeBytesLoaded);
      },
    ));
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _controller.stop();
    super.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _valueListner();
  }

  Widget _valueListner() {
    return ValueListenableBuilder(
      valueListenable: _imageValueNotifier,
      builder: ((context, value, child) {
        return !value.isLoaded
            ? Center(
                child: LoadingAnimationWidget.fourRotatingDots(
                  color: CretaColor.primary,
                  size: 40.0,
                ),
              )
            : Center(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return OverflowBox(
                      minHeight: widget.height,
                      maxHeight: widget.height * 2.5,
                      minWidth: widget.width,
                      maxWidth: widget.width * 2.5,
                      child: SizedBox(
                        height: _animation.value!.height,
                        width: _animation.value!.width,
                        child: child,
                      ),
                    );
                  },
                  child: RawImage(
                    fit: BoxFit.fill,
                    image: _imageInfo.image,
                  ),
                ),
              );
      }),
    );
  }
}
