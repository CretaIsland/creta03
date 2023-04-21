// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../design_system/component/snippet.dart';
import '../../model/frame_model.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_video_player.dart';

class CretaVideoWidget extends CretaAbsPlayerWidget {
  const CretaVideoWidget({super.key, required super.player});

  @override
  State<CretaVideoWidget> createState() => CretaVideoPlayerWidgetState();
}

class CretaVideoPlayerWidgetState extends State<CretaVideoWidget> {
  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    widget.player.afterBuild();
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final CretaVideoPlayer player = widget.player as CretaVideoPlayer;

    if (StudioVariables.isSilent) {
      player.setSound(0.0);
    } else {
      player.resumeSound();
      if (player.model != null) {
        player.mute();
      }
    }

    return FutureBuilder(
        future: player.waitInit(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (player.isInit() == false) {
              return Snippet.showWaitSign();
            }
            return const SizedBox.shrink(key: GlobalObjectKey('shrink'));
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }

          return IgnorePointer(
            child: getClipRect(
              player.getSize()!,
              player.acc.frameModel,
              VideoPlayer(player.wcontroller!, key: GlobalObjectKey('video-${player.model!.mid}')),
            ),
          );
        });
  }

  Widget getClipRect(Size outSize, FrameModel frameModel, Widget child) {
    return ClipRRect(
      //clipper: MyContentsClipper(),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(frameModel.radiusRightTop.value),
        topLeft: Radius.circular(frameModel.radiusLeftTop.value),
        bottomRight: Radius.circular(frameModel.radiusRightBottom.value),
        bottomLeft: Radius.circular(frameModel.radiusLeftBottom.value),
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
}