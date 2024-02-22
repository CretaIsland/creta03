// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import 'package:creta_studio_model/model/contents_model.dart';
import '../../data_io/key_handler.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../creta_abs_media_widget.dart';
import 'creta_music_mixin.dart';
import 'creta_music_player.dart';

class CretaMusicWidget extends CretaAbsPlayerWidget {
  const CretaMusicWidget({super.key, required super.player});

  @override
  CretaMusicPlayerWidgetState createState() => CretaMusicPlayerWidgetState();
}

class CretaMusicPlayerWidgetState extends CretaState<CretaMusicWidget> with CretaMusicMixin {
  ContentsEventController? _receiveEvent;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    // print('++++++++++++++++++++++++++++++++++++++++++ creta_music_widget');
    super.initState();
    //widget.player.afterBuild();
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
    final CretaMusicPlayer player = widget.player as CretaMusicPlayer;
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data! is ContentsModel) {
            ContentsModel model = snapshot.data! as ContentsModel;
            player.acc.updateModel(model);
            logger.fine('model updated ${model.name}, ${model.font.value}');
          }
          logger.fine('Music StreamBuilder<AbsExModel>');

          return playMusic(
            context,
            player,
            player.model!,
            player.acc.getRealSize(),
          );
        });
  }
}
