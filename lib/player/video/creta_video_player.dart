// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';

import '../../model/app_enums.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_player.dart';

// ignore: must_be_immutable
class CretaVideoPlayer extends CretaAbsPlayer {
  CretaVideoPlayer({
    required super.keyString,
    required super.onAfterEvent,
    required super.model,
    required super.acc,
  }) {
    //logger.fine("CretaVideoPlayer(isAutoPlay=${StudioVariables.isAutoPlay})");
  }

  VideoPlayerController? wcontroller;
  VideoEventType prevEvent = VideoEventType.unknown;
  Size? _outSize;
  Size? getSize() => _outSize;
  //bool _isMute = false;
  bool _isInitAlreadyDone = false;
  bool get isInitAlreadyDone => _isInitAlreadyDone;

  @override
  Future<void> init() async {
    String uri = model!.getURI();
    String errMsg = '${model!.name} uri is null';
    if (uri.isEmpty) {
      logger.severe(errMsg);
    }
    logger.fine('initVideo(${model!.name},$uri)');

    //wcontroller = VideoPlayerController.network(uri,
    wcontroller = VideoPlayerController.networkUrl(Uri.parse(uri),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then((_) {
        logger.fine('initialize complete(${model!.name}, ${acc.getAvailLength()})');
        if (StudioVariables.isMute == false && model!.mute.value == false) {
          wcontroller!.setVolume(model!.volume.value);
        } else {
          wcontroller!.setVolume(0.0);
        }
        model!.aspectRatio.set(wcontroller!.value.aspectRatio, noUndo: true, save: false);
        model!.videoPlayTime
            .set(wcontroller!.value.duration.inMilliseconds.toDouble(), noUndo: true, save: false);
        wcontroller!.setLooping(false);
        wcontroller!.onAfterVideoEvent = (event, position, duration) {
          if (event.eventType == VideoEventType.completed) {
            // bufferingEnd and completed 가 시간이 다 되서 종료한 것임.
            logger
                .info('video play completed(${model!.name},postion=$position, duration=$duration)');
            model!.setPlayState(PlayState.end);
            onAfterEvent?.call(position, duration);
          }
          prevEvent = event.eventType;
        };
        logger.fine('initialize complete(${wcontroller!.value.duration.inMilliseconds})');

        //wcontroller!.play();
      });
  }

  @override
  bool isInit() {
    return wcontroller!.value.isInitialized;
  }

  @override
  void stop() {
    logger.fine("video player stop,${model!.name}");
    //widget.wcontroller!.dispose();
    super.stop();
    model!.setPlayState(PlayState.stop);
  }

  @override
  Future<void> play({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('play  ${model!.name}');
    model!.setPlayState(PlayState.start);
    await wcontroller!.play();
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('pause ${model!.name}');
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
      logger.fine('globalResume');
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
  //   logger.fine("videoController close()");
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
    await wcontroller!.setVolume(val);
    model!.volume.set(val);
  }

  @override
  Future<void> setLooping(bool val) async {
    await wcontroller?.setLooping(val);
  }

  // @override
  // Future<void> afterBuild() async {
  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
  //     logger.fine('afterBuild video');
  //     // if (wcontroller != null && model != null) {
  //     //   logger.fine('video : ${model!.name}');
  //     //   model!.aspectRatio.set(wcontroller!.value.aspectRatio, noUndo: true, save: false);
  //     // }
  //     // super.afterBuild();
  //     logger.fine('afterBuild video end');
  //   });
  // }

  Future<bool> waitInit() async {
    if (_isInitAlreadyDone) {
      if (wcontroller!.value.isInitialized == false) {
        logger.severe('!!!!!!!! Already initialize but, initialize is false !!!!!!!!');
        await wcontroller!.dispose();
        logger.severe('!!!!!!!! init again start !!!!!!!!');
        await init();
        logger.severe('!!!!!!!! init again end !!!!!!!!');
      } else {
        await playVideo();
        return true;
      }
    }
    logger.fine('waitInit........ ${model!.name}');
    //int waitCount = 0;
    while (!wcontroller!.value.isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _isInitAlreadyDone = true;
    logger.fine('waitInit end .........  ${model!.name}');
    //await wcontroller!.setLooping(acc.getShowLength() == 1 && model!.isShow.value == true);
    if (_outSize == null) {
      _outSize = getOuterSize(wcontroller!.value.aspectRatio);
      await acc.resizeFrame(wcontroller!.value.aspectRatio, _outSize!, true);
    }
    await playVideo();
    return true;
  }

  Future<void> playVideo() async {
    if (StudioVariables.isAutoPlay &&
        model!.isState(PlayState.start) == false &&
        acc.playTimer!.isCurrentModel(model!.mid) &&
        model!.isPauseTimer == false) {
      logger.fine('video state = ${model!.playState}');
      await play(); //awat를 못한다....이거 문제임...
    }
    buttonIdle();
  }
}
