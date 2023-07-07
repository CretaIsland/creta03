// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../../model/contents_model.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../creta_abs_media_widget.dart';
import 'creta_doc_mixin.dart';
import 'creta_doc_player.dart';

class CretaDocWidget extends CretaAbsPlayerWidget {
  const CretaDocWidget({super.key, required super.player});

  @override
  CretaDocPlayerWidgetState createState() => CretaDocPlayerWidgetState();
}

class CretaDocPlayerWidgetState extends State<CretaDocWidget> with CretaDocMixin {
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
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.stop();
  }

  @override
  Widget build(BuildContext context) {
    final CretaDocPlayer player = widget.player as CretaDocPlayer;
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data! is ContentsModel) {
            ContentsModel model = snapshot.data! as ContentsModel;
            player.acc.updateModel(model);
            logger.info('model updated ${model.name}, ${model.font.value}');
          }
          logger.fine('Text StreamBuilder<AbsExModel>');

          return playDoc(context, player, player.model!, player.acc.getRealSize(), widget.player.acc.frameModel);
        });
  }
}
