// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../data_io/contents_manager.dart';
import '../../design_system/creta_color.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
import '../../pages/studio/studio_variables.dart';
import '../abs_player.dart';

class ImagePlayerProgress extends StatefulWidget {
  final double width;
  final double height;
  final GlobalKey<ImagePlayerProgressState> controllerKey;

  const ImagePlayerProgress(
      {required this.controllerKey, required this.width, required this.height})
      : super(key: controllerKey);

  @override
  State<ImagePlayerProgress> createState() => ImagePlayerProgressState();
}

class ImagePlayerProgressState extends State<ImagePlayerProgress> {
  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProgressNotifier>(builder: (context, notifier, child) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: LinearProgressIndicator(
          value: notifier.progress,
          valueColor: const AlwaysStoppedAnimation<Color>(CretaColor.playedColor),
          backgroundColor:
              notifier.progress == 0 ? CretaColor.pgBackgroundColor : Colors.transparent,
        ),
      );
    });
  }
}

class ImagePlayerWidget extends AbsPlayWidget {
  ImagePlayerWidget({
    required this.globalKey,
    required ContentsModel model,
    required ContentsManager acc,
    void Function()? onAfterEvent,
    bool autoStart = true,
  }) : super(
            key: globalKey,
            onAfterEvent: onAfterEvent,
            acc: acc,
            model: model,
            autoStart: autoStart);

  final GlobalObjectKey<ImagePlayerWidgetState> globalKey;

  @override
  Future<void> play({bool byManual = false}) async {
    logger.fine('image play');
    model!.setPlayState(PlayState.start);
    if (byManual) {
      model!.setManualState(PlayState.start);
    }
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    model!.setPlayState(PlayState.pause);
  }

  @override
  Future<void> mute() async {}

  @override
  Future<void> setSound(double val) async {}

  @override
  Future<void> close() async {
    logger.fine('Image close');

    model!.setPlayState(PlayState.none);
  }

  @override
  void invalidate() {
    if (globalKey.currentState != null) {
      globalKey.currentState!.invalidate();
    }
  }

  @override
  bool isInit() {
    return true;
  }

  @override
  ContentsModel getModel() {
    return model!;
  }

  @override
  Future<void> afterBuild() async {
    acc.playerHandler?.setIsNextButtonBusy(false);
    acc.playerHandler?.setIsPrevButtonBusy(false);
  }

  @override
  ImagePlayerWidgetState createState() => ImagePlayerWidgetState();
}

class ImagePlayerWidgetState extends State<ImagePlayerWidget> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void invalidate() {
    setState(() {});
  }

//Future<Image> _getImageInfo(String url) async {

  Future<double> getImageInfo(String url) async {
    var response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final Codec codec = await instantiateImageCodec(bytes);
    final FrameInfo frame = await codec.getNextFrame();
    final uiImage = frame.image; // a ui.Image object, not to be confused with the Image widget

    return uiImage.width / uiImage.height;
    // Image _image;
    // _image = Image.memory(bytes);
    // return _image;
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      widget.afterBuild();
    });
  }

  @override
  void initState() {
    super.initState();
    afterBuild();
  }

  @override
  Widget build(BuildContext context) {
    if (StudioVariables.isAutoPlay) {
      widget.model!.setPlayState(PlayState.start);
    } else {
      widget.model!.setPlayState(PlayState.pause);
    }
    //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

    double topLeft = widget.acc.frameModel.radiusLeftTop.value;
    double topRight = widget.acc.frameModel.radiusRightTop.value;
    double bottomLeft = widget.acc.frameModel.radiusLeftBottom.value;
    double bottomRight = widget.acc.frameModel.radiusRightBottom.value;

    String uri = widget.getURI(widget.model!);
    String errMsg = '${widget.model!.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");

    // return ClipRRect(
    //   borderRadius: BorderRadius.only(
    //     topRight: Radius.circular(topRight),
    //     topLeft: Radius.circular(topLeft),
    //     bottomRight: Radius.circular(bottomRight),
    //     bottomLeft: Radius.circular(bottomLeft),
    //   ),
    //   child: SizedBox.expand(
    //     child: FittedBox(
    //       alignment: Alignment.center,
    //       fit: BoxFit.cover,
    //       child: SizedBox(
    //         width: outSize.width,
    //         height: outSize.height,
    //         child: uri.isEmpty
    //             ? noImage(errMsg)
    //             : Image.network(
    //                 uri,
    //                 fit: BoxFit.cover,
    //                 errorBuilder: (context, error, stackTrace) {
    //                   errMsg = '${widget.model!.name} ${error.toString()}';
    //                   logger.fine(errMsg);
    //                   return noImage(errMsg);
    //                 },
    //               ),
    //       ),
    //     ),
    //   ),
    // );

    return Container(
      decoration: BoxDecoration(
          //shape: BoxShape.circle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeft),
            topRight: Radius.circular(topRight),
            bottomLeft: Radius.circular(bottomLeft),
            bottomRight: Radius.circular(bottomRight),
          ),
          //image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(widget.model!.url))),
          image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(uri))),
    );
  }
}
