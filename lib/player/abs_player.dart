// ignore_for_file: prefer_final_fields
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:blobs/blobs.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:video_player/video_player.dart';

import '../data_io/contents_manager.dart';
import '../model/app_enums.dart';
import '../model/contents_model.dart';

// Image 의 progress bar 전진을 위한 도구
ProgressNotifier? progressHolder;

class ProgressNotifier extends ChangeNotifier {
  double progress = 0.0;
  String mid = '';
  void setProgress(double val, String pmid) {
    progress = val;
    mid = pmid;
    notifyListeners();
  }
}

// ignore: must_be_immutable
abstract class AbsPlayWidget extends StatefulWidget {
  ContentsModel? model;
  ContentsManager acc;
  bool autoStart;
  //BasicOverayWidget? videoProgress;

  AbsPlayWidget({
    Key? key,
    required this.onAfterEvent,
    required this.acc,
    required this.autoStart,
    this.model,
    //this.videoProgress,
  }) : super(key: key);

  void Function()? onAfterEvent;

  Future<void> init() async {}
  Future<void> play({bool byManual = false}) async {}
  Future<void> pause({bool byManual = false}) async {}
  Future<void> mute() async {}
  Future<void> setSound(double val) async {}
  Future<void> close() async {}
  Future<void> next() async {}
  Future<void> prev() async {}

  void invalidate() async {}
  bool isInit() {
    return true;
  }

  PlayState getPlayState() {
    return model!.playState;
  }

  ContentsModel getModel() {
    return model!;
  }

  Future<void> afterBuild() async {
    if (model == null) return;
    //model!.setPlayState(PlayState.init);
    if (model!.isDynamicSize.value) {
      model!.isDynamicSize.set(false, noUndo: true, save: false);
      acc.resizeFrame(model!.aspectRatio.value);
    }
    // if (selectedModelHolder != null && pageManagerHolder != null) {
    //   if (await selectedModelHolder!.isSelectedModel(model!)) {
    //     pageManagerHolder!.setAsContents();
    //   }
    // }
    // if (accManagerHolder != null) {
    //   accManagerHolder!.resizeMenu(model!.contentsType);
    // }
  }

  Size getOuterSize(double srcRatio) {
    Size realSize = acc.getRealSize();
    // aspectorRatio 는 실제 비디오의  넓이/높이 이다.
    //double videoRatio = wcontroller!.value.aspectRatio;

    double outerWidth = realSize.width;
    double outerHeight = realSize.height;

    if (!acc.frameModel.isAutoFit.value) {
      if (srcRatio >= 1.0) {
        outerWidth = srcRatio * outerWidth;
        outerHeight = outerWidth * (1.0 / srcRatio);
      } else {
        outerHeight = (1.0 / srcRatio) * outerHeight;
        outerWidth = srcRatio * outerHeight;
      }
    }
    return Size(outerWidth, outerHeight);
  }

  Widget getClipRect(Size outSize, Widget child) {
    return ClipRRect(
      //clipper: MyContentsClipper(),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(acc.frameModel.radiusRightTop.value),
        topLeft: Radius.circular(acc.frameModel.radiusLeftTop.value),
        bottomRight: Radius.circular(acc.frameModel.radiusRightBottom.value),
        bottomLeft: Radius.circular(acc.frameModel.radiusLeftBottom.value),
      ),
      child: SizedBox.expand(
          child: FittedBox(
        alignment: Alignment.center,
        fit: BoxFit.cover,
        child: SizedBox(
          //width: realSize.width,
          //height: realSize.height,
          width: outSize.width,
          height: outSize.height,
          child: child,
        ),
      )),
    );
  }

  Widget getBlob(Size outSize, Widget child) {
    return Blob.animatedRandom(
        size: sqrt(acc.getRealSize().width * acc.getRealSize().height),
        duration: const Duration(microseconds: 100),
        edgesCount: 5,
        minGrowth: 4,
        styles: BlobStyles(color: Colors.green, fillType: BlobFillType.stroke, strokeWidth: 2),
        child: child);
  }

  String getURI(ContentsModel model) {
    if (model.remoteUrl != null && model.remoteUrl!.isNotEmpty) {
      return model.remoteUrl!;
    }
    if (model.url.isNotEmpty) {
      return model.url;
    }
    return '';
  }
}

class BasicOverayWidget extends StatelessWidget {
  final VideoPlayerController controller;
  final double width;
  final double height;

  const BasicOverayWidget(
      {Key? key, required this.controller, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: VideoProgressIndicator(controller, allowScrubbing: true));
  }
}

// ignore: must_be_immutable
class EmptyPlayWidget extends AbsPlayWidget {
  EmptyPlayWidget(
      {required GlobalObjectKey<EmptyPlayWidgetState> key,
      required void Function() onAfterEvent,
      required ContentsManager acc})
      : super(
            key: key,
            onAfterEvent: onAfterEvent,
            acc: acc,
            autoStart: true /*bookManagerHolder!.isAutoPlay()*/) {
    globalKey = key;
  }

  GlobalObjectKey<EmptyPlayWidgetState>? globalKey;

  @override
  Future<void> play({bool byManual = false}) async {
    model!.setPlayState(PlayState.start);
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
    model!.setPlayState(PlayState.none);
  }

  @override
  void invalidate() {
    if (globalKey != null && globalKey!.currentState != null) {
      globalKey!.currentState!.invalidate();
    }
  }

  @override
  bool isInit() {
    return true;
  }

  @override
  PlayState getPlayState() {
    if (model == null) {
      logger.info("getPlayState model is null");
      return PlayState.none;
    }
    return model!.prevState;
  }

  @override
  ContentsModel getModel() {
    return model!;
  }

  @override
  EmptyPlayWidgetState createState() => EmptyPlayWidgetState();
}

class EmptyPlayWidgetState extends State<EmptyPlayWidget> {
  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
