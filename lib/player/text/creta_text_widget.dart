// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../../data_io/key_handler.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../creta_abs_media_widget.dart';
import 'creta_text_mixin.dart';
import 'creta_text_player.dart';

class CretaTextWidget extends CretaAbsPlayerWidget {
  const CretaTextWidget({super.key, required super.player});

  @override
  CretaTextPlayerWidgetState createState() => CretaTextPlayerWidgetState();
}

class CretaTextPlayerWidgetState extends CretaState<CretaTextWidget> with CretaTextMixin {
  ContentsEventController? _receiveEvent;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    //widget.player.afterBuild();
    final ContentsEventController receiveEvent = Get.find(tag: 'text-property-to-textplayer');
    _receiveEvent = receiveEvent;
    //applyScale = StudioVariables.applyScale;
    // final FrameEventController regiSendEvent = Get.find(tag: 'frame-property-to-main ..unused');
    // sendEvent = regiSendEvent;
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    //print('CretaTextPlayerWidgetState build');
    applyScale = StudioVariables.applyScale;
    final CretaTextPlayer player = widget.player as CretaTextPlayer;

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

    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data! is ContentsModel) {
            ContentsModel model = snapshot.data! as ContentsModel;
            player.acc.updateModel(model);
            logger.fine('model updated ${model.name}, ${model.font.value}');
          }
          logger.fine('Text StreamBuilder<AbsExModel>');
          return playText(context, player, player.getModel(), player.acc.getRealSize());

          // if (StudioVariables.isAutoPlay) {
          //   //player.model!.setPlayState(PlayState.start);
          //   player.play();
          // } else {
          //   //player.model!.setPlayState(PlayState.pause);
          //   player.pause();
          // }
          // //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

          // // double topLeft = player.acc.frameModel.radiusLeftTop.value;
          // // double topRight = player.acc.frameModel.radiusRightTop.value;
          // // double bottomLeft = player.acc.frameModel.radiusLeftBottom.value;
          // // double bottomRight = player.acc.frameModel.radiusRightBottom.value;

          // String uri = player.getURI(player.model!);
          // String errMsg = '${player.model!.name} uri is null';
          // if (uri.isEmpty) {
          //   logger.fine(errMsg);
          // }
          // logger.fine("uri=<$uri>");
          // player.buttonIdle();

          // Size realSize = player.acc.getRealSize();
          // double fontSize = player.model!.fontSize.value * StudioVariables.applyScale;

          // if (player.model!.isAutoSize.value == true &&
          //     (player.model!.aniType.value != TextAniType.rotate ||
          //         player.model!.aniType.value != TextAniType.bounce ||
          //         player.model!.aniType.value != TextAniType.fade ||
          //         player.model!.aniType.value != TextAniType.shimmer ||
          //         player.model!.aniType.value != TextAniType.typewriter ||
          //         player.model!.aniType.value != TextAniType.wavy ||
          //         player.model!.aniType.value != TextAniType.fidget)) {
          //   fontSize = CretaConst.maxFontSize * StudioVariables.applyScale;
          // }

          // FontWeight? fontWeight = StudioConst.fontWeight2Type[player.model!.fontWeight.value];

          // TextStyle style = DefaultTextStyle.of(context).style.copyWith(
          //     fontFamily: player.model!.font.value,
          //     color: player.model!.fontColor.value.withOpacity(player.model!.opacity.value),
          //     fontSize: fontSize,
          //     decoration: (player.model!.isUnderline.value && player.model!.isStrike.value)
          //         ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
          //         : player.model!.isUnderline.value
          //             ? TextDecoration.underline
          //             : player.model!.isStrike.value
          //                 ? TextDecoration.lineThrough
          //                 : TextDecoration.none,
          //     //fontWeight: player.model!.isBold.value ? FontWeight.bold : FontWeight.normal,
          //     fontWeight: fontWeight,
          //     fontStyle: player.model!.isItalic.value ? FontStyle.italic : FontStyle.normal);

          // if (player.model!.isBold.value) {
          //   style = style.copyWith(fontWeight: FontWeight.bold);
          // }

          // if (player.model!.isAutoSize.value == false) {
          //   style.copyWith(
          //     fontSize: fontSize,
          //   );
          // }

          // return Container(
          //   color: Colors.transparent,
          //   padding: EdgeInsets.fromLTRB(realSize.width * 0.05, realSize.height * 0.05,
          //       realSize.width * 0.05, realSize.height * 0.05),
          //   alignment: AlignmentDirectional.center,
          //   width: realSize.width,
          //   height: realSize.height,
          //   child: playText(player.model, uri, style, fontSize, realSize),
          // );
        });
  }
}
