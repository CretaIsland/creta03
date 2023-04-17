// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../data_io/contents_manager.dart';
import '../../design_system/component/snippet.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
import '../../pages/studio/studio_variables.dart';
import '../abs_player.dart';

// ignore: must_be_immutable
class VideoPlayerWidget extends AbsPlayWidget {
  VideoPlayerWidget({
    required this.globalKey,
    required void Function() onAfterEvent,
    required ContentsModel model,
    required ContentsManager acc,
    bool autoStart = true,
  }) : super(
            key: globalKey,
            onAfterEvent: onAfterEvent,
            acc: acc,
            model: model,
            autoStart: autoStart) {
    logger.info("VideoPlayerWidget(isAutoPlay=$autoStart)");
  }

  final GlobalObjectKey<VideoPlayerWidgetState> globalKey;

  VideoPlayerController? wcontroller;
  VideoEventType prevEvent = VideoEventType.unknown;

  @override
  Future<void> init() async {
    String uri = getURI(model!);
    String errMsg = '${model!.name} uri is null';
    if (uri.isEmpty) {
      logger.severe(errMsg);
    }
    logger.info('initVideo(${model!.name},$uri)');

    wcontroller = VideoPlayerController.network(uri,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        logger.info('initialize complete(${model!.name}, ${acc.getAvailLength()})');
        //setState(() {});
        model!.videoPlayTime
            .set(wcontroller!.value.duration.inMilliseconds.toDouble(), noUndo: true, save: false);
        //wcontroller!.setLooping(acc.getAvailLength() == 1);
        wcontroller!.setLooping(false);

        wcontroller!.onAfterVideoEvent = (event) {
          if (event.duration != null) {
            logger.info(
                'video event ${event.eventType.toString()}, ${event.duration.toString()},(${model!.name})');
          } else {
            logger.warning('event duration is null');
          }
          if (event.eventType == VideoEventType.completed) {
            // bufferingEnd and completed 가 시간이 다 되서 종료한 것임.
            logger.info('video play completed(${model!.name})');
            model!.setPlayState(PlayState.end);
            onAfterEvent!.call();
          }
          prevEvent = event.eventType;
        };
        logger.info('initialize complete(${wcontroller!.value.duration.inMilliseconds})');

        //wcontroller!.play();
      });
  }

  @override
  bool isInit() {
    return wcontroller!.value.isInitialized;
  }

  @override
  void invalidate() {
    if (globalKey.currentState != null) {
      globalKey.currentState!.invalidate();
    }
  }

  @override
  Future<void> play({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.info('play  ${model!.name}');
    model!.setPlayState(PlayState.start);
    await wcontroller!.play();
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('pause');
    model!.setPlayState(PlayState.pause);
    await wcontroller!.pause();
  }

  @override
  Future<void> globalPause() async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('globalPause');
    model!.setPlayState(PlayState.globalPause);
    await wcontroller!.pause();
  }

  @override
  Future<void> globalResume() async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('globalResume');
    PlayState prevState = model!.playState;
    if (prevState == PlayState.globalPause) {
      model!.resumeState();
      if (model!.playState == PlayState.start) {
        await wcontroller!.play();
      }
    }
  }

  @override
  Future<void> resume({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('resume');
    PlayState prevState = model!.playState;
    model!.resumeState();
    if (prevState == PlayState.pause && model!.playState == PlayState.start) {
      await wcontroller!.play();
    }
  }

  @override
  Future<void> close() async {
    model?.setPlayState(PlayState.none);
    logger.info("videoController close()");
    await wcontroller?.dispose();
    wcontroller = null;
  }

  @override
  Future<void> mute() async {
    if (model!.mute.value) {
      await wcontroller!.setVolume(1.0);
    } else {
      await wcontroller!.setVolume(0.0);
    }
    model!.mute.set(!model!.mute.value);
  }

  @override
  Future<void> rewind() async {
    await wcontroller!.seekTo(Duration.zero);
  }

  @override
  Future<void> setSound(double val) async {
    await wcontroller!.setVolume(1.0);
    model!.volume.set(val);
  }

  @override
  // ignore: no_logic_in_create_state
  VideoPlayerWidgetState createState() {
    logger.fine('video createState (${model!.name}');
    return VideoPlayerWidgetState();
  }
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void invalidate() {
    setState(() {});
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      logger.info('afterBuild video');
      if (widget.wcontroller != null && widget.model != null) {
        widget.model!.aspectRatio
            .set(widget.wcontroller!.value.aspectRatio, noUndo: true, save: false);
      }
      widget.afterBuild();
    });
  }

  @override
  void initState() {
    //widget.init();
    super.initState();
    afterBuild();
  }

  @override
  void dispose() {
    logger.info("video widget dispose,${widget.model!.name}");
    //widget.wcontroller!.dispose();
    super.dispose();
    widget.model!.setPlayState(PlayState.disposed);
  }

  Future<bool> waitInit() async {
    logger.info('waitInit...');
    while (!widget.wcontroller!.value.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    logger.info('waitInit end');

    Size outSize = widget.getOuterSize(widget.wcontroller!.value.aspectRatio);
    await widget.acc.resizeFrame(widget.wcontroller!.value.aspectRatio, outSize, true);

    if (widget.autoStart) {
      logger.info('initState play--${widget.model!.name}---------------');
      await widget.play();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // if (StudioVariables.isAutoPlay) {
    //   widget.model!.setPlayState(PlayState.start);
    // } else {
    //   widget.model!.setPlayState(PlayState.pause);
    // }
    if (StudioVariables.isSilent) {
      widget.wcontroller?.setVolume(0.0);
    } else {
      widget.wcontroller?.setVolume(widget.model!.volume.value);
      if (widget.model != null) {
        widget.model!.mute.set(widget.model!.mute.value, save: false, noUndo: true);
      }
    }

    if (widget.wcontroller != null && widget.wcontroller!.value.isInitialized) {
      logger.info('VideoPlayerWidget build aspectRatio=${widget.wcontroller!.value.aspectRatio}');
      // aspectorRatio 는 실제 비디오의  넓이/높이 이다.
      Size outSize = widget.getOuterSize(widget.wcontroller!.value.aspectRatio);

      if (widget.autoStart) {
        widget.wcontroller!.play();
      }

      return IgnorePointer(
        child: widget.getClipRect(
            outSize, VideoPlayer(widget.wcontroller!, key: ValueKey(widget.model!.url))),
      );
    }

    return FutureBuilder(
        future: waitInit(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return Snippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }

          logger
              .info('VideoPlayerWidget build aspectRatio=${widget.wcontroller!.value.aspectRatio}');
          // aspectorRatio 는 실제 비디오의  넓이/높이 이다.
          Size outSize = widget.getOuterSize(widget.wcontroller!.value.aspectRatio);

          return IgnorePointer(
            child: widget.getClipRect(
                outSize, VideoPlayer(widget.wcontroller!, key: ValueKey(widget.model!.url))),
            //     child: SizedBox(
            //   width: outSize.width,
            //   height: outSize.height,
            //   child: VideoPlayer(
            //     widget.wcontroller!,
            //     key: ValueKey(widget.model!.url),
            //   ),
            // ),
          );
        });
  }
}

// my clipper example
class MyContentsClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    logger.fine('MyContentsClipper=$size');
    return RRect.fromLTRBR(50, 50, 200, 200, const Radius.circular(20));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) {
    return false;
  }
}
