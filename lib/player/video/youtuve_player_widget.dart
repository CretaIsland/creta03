// Copyright 2020 Sarbagya Dhaubanjar. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../../data_io/contents_manager.dart';
import '../../design_system/component/snippet.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
import '../abs_player.dart';

// ignore: must_be_immutable
class YoutubePlayerWidget extends AbsPlayWidget {
  final GlobalObjectKey<YoutubePlayerWidgetState> globalKey;
  final List<String> playList;
  // 'QMhVtPmPAW8',
  // 'uBY1AoiF5Vo',
  // 'puUxEKMub2g',
  // 'UUUWIGx3hDE',
  // 'Fm5iP0S1z9w',
  // 'CM4CkVFmTds',
  // 'uR8Mrt1IpXg',
  // 'ZeerrnuLi5E',
  //  'Jh4QFaPmdss'
  //];

  String videoId = 'Jh4QFaPmdss';

  YoutubePlayerWidget({
    Key? key,
    required this.globalKey,
    required this.playList,
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
    logger.fine("YoutubePlayerWidget(url=${model.url})");
    if (model.remoteUrl != null) {
      logger.fine("YoutubePlayerWidget(remoteUrl=${model.remoteUrl!})");
    }
    videoId = model.remoteUrl ?? model.url;
    //playList.add(videoId);
  }

  late YoutubePlayerController wcontroller;
  bool isReady = false;

  @override
  Future<void> init() async {
    bool isReadOnly = StudioVariables.isReadOnly;

    logger.fine('initYoutube(${model!.name},$videoId), ${playList.toString()}');
    wcontroller = YoutubePlayerController(
      params: YoutubePlayerParams(
        loop: true,
        mute: autoStart && (isReadOnly == false),
        showControls: true,
        showFullscreenButton: false,
        strictRelatedVideos: false,
      ),
    );

    if (autoStart) {
      wcontroller.loadVideoById(videoId: videoId);
      wcontroller.loadPlaylist(list: playList);
    } else {
      wcontroller.cueVideoById(videoId: videoId);
      wcontroller.cuePlaylist(list: playList);
    }

    //getThumbnail();
    isReady = true;
    if (autoStart) {
      model!.setPlayState(PlayState.start);
      model!.mute.set(true, save: false);
    } else {
      model!.setPlayState(PlayState.init);
      model!.mute.set(false, save: false);
    }
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
    logger.fine('play  ${model!.name}');
    model!.setPlayState(PlayState.start);
    wcontroller.playVideo();
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    // while (model!.state == PlayState.disposed) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }
    logger.fine('pause');
    model!.setPlayState(PlayState.pause);
    wcontroller.pauseVideo();
  }

  @override
  Future<void> close() async {
    model!.setPlayState(PlayState.none);
    logger.fine("videoController close()");
    wcontroller.close();
  }

  @override
  Future<void> mute() async {
    if (model!.mute.value) {
      wcontroller.mute();
    } else {
      wcontroller.unMute();
    }
    model!.mute.set(!model!.mute.value);
  }

  @override
  Future<void> setSound(double val) async {
    wcontroller.setVolume(val.round());
    model!.volume.set(val);
  }

  void getThumbnail() {
    if (model!.thumbnail == null || model!.thumbnail!.isEmpty) {
      model!.thumbnail = YoutubePlayerController.getThumbnail(
        //videoId: widget.wcontroller.params.playlist.first,
        videoId: videoId,
        quality: ThumbnailQuality.medium,
      );

      logger.fine("youtube thumbnail= ${model!.thumbnail!}");
    }
  }

  @override
  Future<void> next() async {
    logger.fine('YoutubePlayerWidget.next()');
    wcontroller.nextVideo();
  }

  @override
  Future<void> prev() async {
    logger.fine('YoutubePlayerWidget.prev()');
    wcontroller.previousVideo();
  }

  @override
  YoutubePlayerWidgetState createState() => YoutubePlayerWidgetState();
}

class YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  YoutubePlayer? player;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  void invalidate() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('afterBuild Yout!ubePlayerController');
      player!.controller!.listen((event) {
        if (event.playerState == PlayerState.ended) {
          print('listen, ${event.playerState}');
          widget.model!.setPlayState(PlayState.end);
          widget.onAfterEvent!.call();
        }
      });
      // setState(() {
      // });
      // if (player!.controller != null) {
      //   player!.controller!.nextVideo();

      // } else {
      //   print('controller is null');
      // }
    });
  }

  @override
  void didUpdateWidget(covariant YoutubePlayerWidget oldWidget) {
    print('didUpdateWidget called');
    super.didUpdateWidget(oldWidget);
  }

  Future<bool> waitInit() async {
    //bool isReady = widget.wcontroller.value.isReady;
    while (!widget.isReady) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if (widget.autoStart) {
      logger.fine('initState play--${widget.model!.name}---------------');
      await widget.play();
    }
    logger.fine('waitInit()');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    print('build called');
    player = YoutubePlayer(
      controller: widget.wcontroller,
    );
    print('player initialized aspectRatio=${player!.aspectRatio}');
    //widget.getThumbnail();

    Size outSize = widget.getOuterSize(player!.aspectRatio);
    if (StudioVariables.isSilent) {
      widget.wcontroller.setVolume(0);
      widget.model!.mute.set(true, save: false, noUndo: true);
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
          return YoutubePlayerControllerProvider(
              // Passing controller to widgets below.
              controller: widget.wcontroller,
              child: Scaffold(
                body: show(outSize),
              ));
        });
  }

  Widget show(Size outSize) {
    return Stack(children: [
      widget.getClipRect(
        outSize,
        player!,
        //getThumbnail(),
      ),
      YoutubeValueBuilder(
          buildWhen: (o, n) => (o.metaData != n.metaData),
          builder: (context, value) {
            //widget.onInitialPlay.call(value.metaData);
            return Container(); // 화면에는 아무 표시도 하지 않는다.
          })
      //)
    ]);
  }

  // Widget show(Size outSize) {
  //   return widget.getClipRect(
  //     outSize,
  //     player!,
  //   );
  // }

  Widget getThumbnail() {
    return Material(
      child: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.model!.thumbnail!
                // YoutubePlayerController.getThumbnail(
                //   //videoId: widget.wcontroller.params.playlist.first,
                //   videoId: widget.videoId,
                //   quality: ThumbnailQuality.medium,
                // ),
                ),
            fit: BoxFit.fitWidth,
          ),
        ),
        // child: const Center(
        //   child: CircularProgressIndicator(),
        // ),
      ),
    );
  }

  @override
  void dispose() {
    logger.fine('Youtube dispose');
    //widget.wcontroller.close();
    widget.model!.setPlayState(PlayState.disposed);
    super.dispose();
  }
}
