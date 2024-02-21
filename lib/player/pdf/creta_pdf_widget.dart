// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/model/app_enums.dart';
import '../../data_io/key_handler.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_pdf_player.dart';
import 'pinch.dart';

class CretaPdfWidget extends CretaAbsPlayerWidget {
  const CretaPdfWidget({super.key, required super.player});

  @override
  CretaPdfPlayerWidgetState createState() => CretaPdfPlayerWidgetState();
}

class CretaPdfPlayerWidgetState extends CretaState<CretaPdfWidget> {
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
    final CretaPdfPlayer player = widget.player as CretaPdfPlayer;

    if (StudioVariables.isAutoPlay) {
      player.model!.setPlayState(PlayState.start);
    } else {
      player.model!.setPlayState(PlayState.pause);
    }
    //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

    double topLeft = player.acc.frameModel.getRealradiusLeftTop(StudioVariables.applyScale);
    double topRight = player.acc.frameModel.getRealradiusRightTop(StudioVariables.applyScale);
    double bottomLeft = player.acc.frameModel.getRealradiusLeftBottom(StudioVariables.applyScale);
    double bottomRight = player.acc.frameModel.getRealradiusRightBottom(StudioVariables.applyScale);

    String uri = player.model!.getURI();
    String errMsg = '${player.model!.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");
    player.buttonIdle();

    return Container(
      decoration: BoxDecoration(
        //shape: BoxShape.circle,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topLeft),
          topRight: Radius.circular(topRight),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
      ),
      child: PinchPage(key: GlobalObjectKey('pdf-$uri'), url: uri),
    );
  }
}
