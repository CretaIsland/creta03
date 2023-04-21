// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../model/app_enums.dart';
import '../creta_abs_player.dart';

// ignore: must_be_immutable
class CretaVideoPlayer extends CretaAbsPlayer {
  CretaVideoPlayer({
    required super.onAfterEvent,
    required super.model,
    required super.acc,
    super.autoStart = true,
  }) {
    logger.info("CretaVideoPlayer(isAutoPlay=$autoStart)");
  }

  VideoPlayerController? wcontroller;
  VideoEventType prevEvent = VideoEventType.unknown;
  Size? _outSize;
  Size? getSize() => _outSize;

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
        model!.videoPlayTime
            .set(wcontroller!.value.duration.inMilliseconds.toDouble(), noUndo: true, save: false);
        wcontroller!.setLooping(false);

        wcontroller!.onAfterVideoEvent = (event) {
          if (event.duration != null) {
            logger.info(
                'video event ${event.eventType.toString()}, ${event.duration.toString()},(${model!.name})');
          } else {
            logger.warning('event duration is null,(${model!.name})');
          }
          if (event.eventType == VideoEventType.completed) {
            // bufferingEnd and completed 가 시간이 다 되서 종료한 것임.
            logger.info('video play completed(${model!.name})');
            model!.setPlayState(PlayState.end);
            onAfterEvent?.call();
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
  void stop() {
    logger.info("video player stop,${model!.name}");
    //widget.wcontroller!.dispose();
    super.stop();
    model!.setPlayState(PlayState.stop);
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
    logger.info('pause ${model!.name}');
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
    PlayState prevState = model!.playState;
    if (prevState == PlayState.globalPause) {
      logger.info('globalResume');
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

  // @override
  // Future<void> close() async {
  //   model?.setPlayState(PlayState.none);
  //   logger.info("videoController close()");
  //   await wcontroller?.dispose();
  //   wcontroller = null;
  // }

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
  Future<void> resumeSound() async {
    await wcontroller!.setVolume(model!.volume.value);
  }

  @override
  Future<void> setSound(double val) async {
    await wcontroller!.setVolume(1.0);
    model!.volume.set(val);
  }

  @override
  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      logger.info('afterBuild video');
      if (wcontroller != null && model != null) {
        logger.info('video : ${model!.name}');
        model!.aspectRatio.set(wcontroller!.value.aspectRatio, noUndo: true, save: false);
      }
      super.afterBuild();
      logger.info('afterBuild video end');
    });
  }

  Future<bool> waitInit() async {
    logger.info('waitInit........ ${model!.name}');
    //int waitCount = 0;
    while (!wcontroller!.value.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    logger.info('waitInit end .........  ${model!.name}');
    await wcontroller!.setLooping(acc.getAvailLength() == 1);

    if (_outSize == null) {
      _outSize = getOuterSize(wcontroller!.value.aspectRatio);
      await acc.resizeFrame(wcontroller!.value.aspectRatio, _outSize!, true);
    }

    await _playVideo();
    return true;
  }

  Future<void> _playVideo() async {
    if (autoStart && model!.isState(PlayState.start) == false) {
      logger.info('video state = ${model!.playState}');
      await wcontroller!.play(); //awat를 못한다....이거 문제임...
    }
    buttonIdle();
  }
}