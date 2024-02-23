// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_snippet.dart';
// import 'snippet.dart';

class ImageDetail {
  late bool isLoaded = false;
  late bool isError = false;
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

  void changeErrorState(bool isError) {
    _imageDetail.isError = isError;
    notifyListeners();
  }

  void changeCumulativeBytesLoaded(int cumulativeBytesLoaded) {
    _imageDetail.cumulativeBytesLoaded = cumulativeBytesLoaded;
    notifyListeners();
  }
}

class CustomImage extends StatefulWidget {
  CustomImage({
    super.key,
    required this.width,
    required this.height,
    required this.image,
    this.hasMouseOverEffect = false,
    this.duration = 700,
    this.hasAni = true,
    this.boxFit = BoxFit.fill,
    this.imageOnError,
    this.useDefaultErrorImage = false,
  });
  final double width;
  final double height;
  final String image;
  final int duration;
  final bool hasMouseOverEffect;
  final bool hasAni;
  final BoxFit boxFit;
  final Widget? imageOnError;
  final bool useDefaultErrorImage;

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

  late Widget? imageOnError;

  @override
  void initState() {
    if (widget.hasAni) {
      _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration),
      );

      _animation = SizeTween(
              begin: Size(widget.width * 2.5, widget.height * 2.5),
              end: Size(widget.width, widget.height))
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    }
    _imageDetail = ImageDetail();

    _imageValueNotifier = ImageValueNotifier(_imageDetail);

    try {
      _imageStream = NetworkImage(widget.image).resolve(const ImageConfiguration());
    } catch (err) {
      logger.warning('NetworkImage(${widget.image}) resolve error = $err');
    }

    _imageStream.addListener(ImageStreamListener(
      (info, value) {
        _imageInfo = info;
        _imageValueNotifier.changeLoadingState(true);
        if (widget.hasAni) {
          _controller.forward();
        }
      },
      onChunk: (event) {
        _imageDetail.expectedTotalBytes = event.expectedTotalBytes!;
        _imageValueNotifier.changeCumulativeBytesLoaded(event.cumulativeBytesLoaded);
      },
      onError: (exception, stackTrace) {
        _imageValueNotifier.changeErrorState(true);
      },
    ));

    if (widget.useDefaultErrorImage || widget.imageOnError == null) {
      imageOnError = _error();
    } else {
      imageOnError = widget.imageOnError;
    }
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    if (widget.hasAni) {
      _controller.stop();
    }
    super.dispose();
    //_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(child: _valueListner());
  }

  Widget _valueListner() {
    return ValueListenableBuilder(
      valueListenable: _imageValueNotifier,
      builder: ((context, value, child) {
        return (value.isError && imageOnError != null)
            ? Center(child: imageOnError)
            : !value.isLoaded
                ? Center(child: CretaSnippet.showWaitSign())
                : Center(child: _show());
      }),
    );
  }

  Widget _error() {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: const Image(
        image: AssetImage('assets/Artboard12.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _show() {
    if (widget.hasAni) {
      return AnimatedBuilder(
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
      );
    }
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: RawImage(
        fit: widget.boxFit,
        image: _imageInfo.image,
      ),
    );
  }
}
