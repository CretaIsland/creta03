// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

import '../../data_io/frame_manager.dart';
import '../../model/contents_model.dart';
import '../../model/frame_model.dart';
import '../../pages/studio/left_menu/word_pad/quill_appflowy.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../../pages/studio/studio_variables.dart';
import '../creta_abs_media_widget.dart';
import 'creta_doc_mixin.dart';
import 'creta_doc_player.dart';

class CretaDocWidget extends CretaAbsPlayerWidget {
  final FrameManager frameManager;
  const CretaDocWidget({super.key, required super.player, required this.frameManager});

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
            print('++++++++++++++++++++++++++++++++++++++++++${model.height.value}');
          }
          logger.fine('Text StreamBuilder<AbsExModel>');

          return playDoc(context, player, player.model!, player.acc.getRealSize(),
              widget.player.acc.frameModel, widget.frameManager);
        });
  }

  Widget playDoc(
    BuildContext context,
    CretaDocPlayer? player,
    ContentsModel model,
    Size realSize,
    FrameModel frameModel,
    FrameManager frameManager, {
    bool isPagePreview = false,
  }) {
    if (StudioVariables.isAutoPlay) {
      player?.play();
    } else {
      player?.pause();
    }

    String uri = model.getURI();
    String errMsg = '${model.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");
    player?.buttonIdle();

    GlobalKey? frameKey = frameManager.frameKeyMap[frameModel.mid];

    print('++++++++++++++++++++++playDoc+++++++++++$realSize');

    return SizedBox(
      // color: Colors.white,
      // padding: EdgeInsets.fromLTRB(realSize.width * 0.05, realSize.height * 0.05,
      //     realSize.width * 0.05, realSize.height * 0.05),
      // padding: EdgeInsets.fromLTRB(realSize.width * 0.01, realSize.height * 0.0075,
      //     realSize.width * 0.01, realSize.height * 0.0075),
      // alignment: AlignmentDirectional.center,
      width: realSize.width,
      height: realSize.height,
      // child: QuillHtmlEnhanced(
      //     document: model,
      //     size: Size(realSize.width, realSize.height),
      //     bgColor: frameModel.bgColor1.value.withOpacity(frameModel.opacity.value)),
      child: MaterialApp(
        localizationsDelegates: const [
          AppFlowyEditorLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        color: Colors.transparent,
        home: AppFlowyEditorWidget(
          key: GlobalObjectKey('AppFlowyEditorWidget${model.mid}'),
          model: model,
          frameModel: frameModel,
          frameKey: frameKey,
          size: realSize,
          onComplete: () {
            player!.acc.setToDB(model);
            setState(() {});
            //print('saved : ${model.remoteUrl}');
          },
        ),
      ),
    );
  }
}
