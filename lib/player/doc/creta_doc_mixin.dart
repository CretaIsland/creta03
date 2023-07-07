// ignore_for_file: depend_on_referenced_packages
import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:creta03/model/frame_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../model/contents_model.dart';
// import '../../pages/studio/left_menu/word_pad/quill_html_enhanced.daxt';
import '../../pages/studio/left_menu/word_pad/quill_appflowy.dart';
import '../../pages/studio/studio_variables.dart';
import 'creta_doc_player.dart';

mixin CretaDocMixin {
  Widget playDoc(BuildContext context, CretaDocPlayer? player, ContentsModel model, Size realSize,
      FrameModel frameModel,
      {bool isPagePreview = false}) {
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
        home: AppFlowyEditorWidget(
          document: model,
          size: Size(realSize.width, realSize.height),
        ),
      ),
    );
  }
}
