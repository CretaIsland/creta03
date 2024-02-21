// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../data_io/key_handler.dart';
import '../../design_system/component/snippet.dart';
import '../../model/contents_model.dart';
import '../../model/frame_model.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_video_player.dart';

class CretaVideoWidget extends CretaAbsPlayerWidget {
  const CretaVideoWidget({super.key, required super.player});

  @override
  State<CretaVideoWidget> createState() => CretaVideoPlayerWidgetState();
}

class CretaVideoPlayerWidgetState extends CretaState<CretaVideoWidget> {
  bool isMute = false;
  Future<bool>? _isInitialized;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    //widget.player.afterBuild();
    final CretaVideoPlayer player = widget.player as CretaVideoPlayer;
    _isInitialized = player.waitInitVideo();
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    //print('build');
    final CretaVideoPlayer player = widget.player as CretaVideoPlayer;
    if (player.isInitAlreadyDone) {
      //print('====================================================${player.keyString}');
      return IgnorePointer(
        child: getClipRect(
          player.getSize()!,
          player.acc.frameModel,
          //VideoPlayer(player.wcontroller!, key: GlobalObjectKey('widget-${player.keyString}')),
          player.model,
          // Container(
          //   color: Colors.amberAccent,
          // )

          VideoPlayer(key: GlobalObjectKey('VideoPlayer${player.keyString}'), player.wcontroller!),
          //VideoPlayer(key: GlobalKey(), player.wcontroller!),
        ),
      );
    }
    //print('000000000000000000000000000000000000000000000000000${player.keyString}');
    return FutureBuilder(
        //future: player.waitInitVideo(),
        future: _isInitialized,
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
              player.model,
              VideoPlayer(
                  key: GlobalObjectKey('VideoPlayer${player.keyString}'), player.wcontroller!),
            ),
          );
        });
  }

  Widget getClipRect(Size outSize, FrameModel frameModel, ContentsModel? model, Widget child) {
    Widget angleImage = model != null && model.angle.value > 0
        ? Transform.rotate(
            angle: CretaCommonUtils.degreeToRadian(model.angle.value),
            child: child,
          )
        : child;

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
        fit: model != null ? model.fit.value.toBoxFit() : BoxFit.cover,
        child: SizedBox(
          //width: realSize.width,
          //height: realSize.height,
          width: outSize.width,
          height: outSize.height,
          child: model != null && model.isFlip.value
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: angleImage,
                )
              : angleImage,
        ),
      )),
    );
  }
}
