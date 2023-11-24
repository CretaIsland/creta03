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
  bool isMute = false;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    //widget.player.afterBuild();
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final CretaVideoPlayer player = widget.player as CretaVideoPlayer;

    return FutureBuilder(
        future: player.waitInitVideo(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            if (player.isInit() == false) {
              return Snippet.showWaitSign();
            }
            return SizedBox.shrink(key: GlobalObjectKey('shrink-${player.keyString}'));
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }

          return IgnorePointer(
            child: getClipRect(
              player.getSize()!,
              player.acc.frameModel,
              //VideoPlayer(player.wcontroller!, key: GlobalObjectKey('widget-${player.keyString}')),
              VideoPlayer(player.wcontroller!),
            ),
          );
        });
  }

  Widget getClipRect(Size outSize, FrameModel frameModel, Widget child) {
    return ClipRRect(
      //clipper: MyContentsClipper(),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(frameModel.getRealradiusRightTop(StudioVariables.applyScale)),
        topLeft: Radius.circular(frameModel.getRealradiusLeftTop(StudioVariables.applyScale)),
        bottomRight:
            Radius.circular(frameModel.getRealradiusRightBottom(StudioVariables.applyScale)),
        bottomLeft: Radius.circular(frameModel.getRealradiusLeftBottom(StudioVariables.applyScale)),
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
