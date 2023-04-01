// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../design_system/component/snippet.dart';

// ignore: must_be_immutable
class SimpleVideoPlayer extends StatefulWidget {
  SimpleVideoPlayer({
    required this.globalKey,
    required this.url,
    required this.realSize,
    required this.aspectRatio,
    required this.onAfterEvent,
    this.autoStart = false,
    this.radiusTopRight = 8,
    this.radiusTopLeft = 8,
    this.radiusBottomRight = 0,
    this.radiusBottomLeft = 0,
  }) : super(key: globalKey);

  final String url;
  final bool autoStart;
  final void Function() onAfterEvent;
  final Size realSize;
  final double aspectRatio;
  final GlobalKey<SimpleVideoPlayerState> globalKey;
  final double radiusTopRight;
  final double radiusTopLeft;
  final double radiusBottomRight;
  final double radiusBottomLeft;

  VideoPlayerController? wcontroller;
  VideoEventType prevEvent = VideoEventType.unknown;
  bool isInitialize = false;

  Future<void> init() async {
    wcontroller = VideoPlayerController.network(url,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        wcontroller!.setLooping(false);
        wcontroller!.setVolume(0.0);
        isInitialize = true;
        wcontroller!.onAfterVideoEvent = (event) {
          if (event.eventType == VideoEventType.completed) {
            // bufferingEnd and completed 가 시간이 다 되서 종료한 것임.
            onAfterEvent.call();
          }
          prevEvent = event.eventType;
        };
        //wcontroller!.play();
      });
  }

  void invalidate() {
    if (globalKey.currentState != null) {
      globalKey.currentState!.invalidate();
    }
  }

  Future<void> play() async {
    await wcontroller!.play();
  }

  Future<void> pause() async {
    await wcontroller!.pause();
  }

  Future<void> close() async {
    await wcontroller!.dispose();
  }

  Future<void> mute() async {
    await wcontroller!.setVolume(0.0);
  }

  Future<void> setSound(double val) async {
    await wcontroller!.setVolume(1.0);
  }

  Size getOuterSize(double srcRatio) {
    double outerWidth = realSize.width;
    double outerHeight = realSize.height;

    if (srcRatio >= 1.0) {
      outerWidth = srcRatio * outerWidth;
      outerHeight = outerWidth * (1.0 / srcRatio);
    } else {
      outerHeight = (1.0 / srcRatio) * outerHeight;
      outerWidth = srcRatio * outerHeight;
    }
    return Size(outerWidth, outerHeight);
  }

  @override
  // ignore: no_logic_in_create_state
  SimpleVideoPlayerState createState() {
    return SimpleVideoPlayerState();
  }
}

class SimpleVideoPlayerState extends State<SimpleVideoPlayer> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void invalidate() {
    setState(() {});
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  @override
  void initState() {
    super.initState();
    afterBuild();
  }

  @override
  void dispose() {
    widget.wcontroller!.dispose();
    super.dispose();
  }

  Future<bool> waitInit() async {
    //await widget.init();
    //bool isReady = widget.wcontroller!.value.isInitialized;
    while (!widget.isInitialize) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (widget.autoStart) {
      logger.fine('initState play');
      await widget.play();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('SimpleVideoPlayerState');
    // aspectorRatio 는 실제 비디오의  넓이/높이 이다.
    return FutureBuilder(
        future: waitInit(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return Snippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.defaultImage;
          }
          Size outSize = widget.getOuterSize(widget.aspectRatio);
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(widget.radiusTopRight),
              topLeft: Radius.circular(widget.radiusTopLeft),
              bottomRight: Radius.circular(widget.radiusBottomRight),
              bottomLeft: Radius.circular(widget.radiusBottomLeft),
            ),
            child: SizedBox.expand(
                child: FittedBox(
              alignment: Alignment.center,
              fit: BoxFit.cover,
              child: SizedBox(
                width: outSize.width,
                height: outSize.height,
                child: VideoPlayer(widget.wcontroller!, key: ValueKey(widget.url)),
              ),
            )),
          );
        });
  }
}
