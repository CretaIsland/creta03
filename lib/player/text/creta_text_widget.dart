// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_text_player.dart';

class CretaTextWidget extends CretaAbsPlayerWidget {
  const CretaTextWidget({super.key, required super.player});

  @override
  CretaTextPlayerWidgetState createState() => CretaTextPlayerWidgetState();
}

class CretaTextPlayerWidgetState extends State<CretaTextWidget> {
  ContentsEventController? _receiveEvent;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    widget.player.afterBuild();
    final ContentsEventController receiveEvent = Get.find(tag: 'text-property-to-textplayer');
    _receiveEvent = receiveEvent;
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
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
          if (snapshot.data != null) {
            ContentsModel model = snapshot.data! as ContentsModel;
            player.acc.updateModel(model);
            logger.info('model updated ${model.name}, ${model.font.value}');
          }
          logger.info('Text StreamBuilder<AbsExModel>');

          if (StudioVariables.isAutoPlay) {
            player.model!.setPlayState(PlayState.start);
          } else {
            player.model!.setPlayState(PlayState.pause);
          }
          //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

          double topLeft = player.acc.frameModel.radiusLeftTop.value;
          double topRight = player.acc.frameModel.radiusRightTop.value;
          double bottomLeft = player.acc.frameModel.radiusLeftBottom.value;
          double bottomRight = player.acc.frameModel.radiusRightBottom.value;

          String uri = player.getURI(player.model!);
          String errMsg = '${player.model!.name} uri is null';
          if (uri.isEmpty) {
            logger.fine(errMsg);
          }
          logger.fine("uri=<$uri>");
          player.buttonIdle();

          Size realSize = player.acc.getRealSize();
          double fontSize = player.model!.fontSize.value * StudioVariables.applyScale;

          if (player.model!.isAutoSize.value == true &&
              (player.model!.aniType.value != TextAniType.rotate ||
                  player.model!.aniType.value != TextAniType.bounce ||
                  player.model!.aniType.value != TextAniType.fade ||
                  player.model!.aniType.value != TextAniType.shimmer ||
                  player.model!.aniType.value != TextAniType.typewriter ||
                  player.model!.aniType.value != TextAniType.wavy ||
                  player.model!.aniType.value != TextAniType.fidget)) {
            fontSize = StudioConst.maxFontSize * StudioVariables.applyScale;
          }

          FontWeight? fontWeight = StudioConst.fontWeight2Type[player.model!.fontWeight.value];

          TextStyle style = DefaultTextStyle.of(context).style.copyWith(
              fontFamily: player.model!.font.value,
              color: player.model!.fontColor.value.withOpacity(player.model!.opacity.value),
              fontSize: fontSize,
              decoration: TextLineType.getTextDecoration(player.model!.line.value),
              //fontWeight: player.model!.isBold.value ? FontWeight.bold : FontWeight.normal,
              fontWeight: fontWeight,
              fontStyle: player.model!.isItalic.value ? FontStyle.italic : FontStyle.normal);

          if (player.model!.isBold.value) {
            style = style.copyWith(fontWeight: FontWeight.bold);
          }

          if (player.model!.isAutoSize.value == false) {
            style.copyWith(
              fontSize: fontSize,
            );
          }

          return Container(
            decoration: BoxDecoration(
              //shape: BoxShape.circle,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(topLeft),
                topRight: Radius.circular(topRight),
                bottomLeft: Radius.circular(bottomLeft),
                bottomRight: Radius.circular(bottomRight),
              ),
              //image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(widget.model!.url))),
              color: Colors.transparent,
            ),
            padding: EdgeInsets.fromLTRB(realSize.width * 0.05, realSize.height * 0.05,
                realSize.width * 0.05, realSize.height * 0.05),
            alignment: AlignmentDirectional.center,
            width: realSize.width,
            height: realSize.height,
            child: player.playText(uri, style, fontSize, realSize),
          );
        });
  }
}
