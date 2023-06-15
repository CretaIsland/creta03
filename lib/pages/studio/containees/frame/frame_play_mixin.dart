// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:html' as html;
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';

// import '../../../../data_io/contents_manager.dart';

import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
// import '../../../../model/contents_model.dart';
// import '../../../../model/frame_model.dart';
// import '../../../../model/page_model.dart';
// import '../../book_main_page.dart';
// import '../../studio_snippet.dart';
// import '../containee_nofifier.dart';
// import 'sticker/draggable_stickers.dart';

mixin FramePlayMixin {
  FrameManager? frameManager;

  void initFrameManager() {
    frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  }

  Future<void> createNewFrameAndContents(List<ContentsModel> modelList, PageModel pageModel,
      {FrameModel? frameModel}) async {
    // 프레임을 생성한다.
    //if (mychangeStack.transState != TransState.start) {
    if (frameModel == null) {
      mychangeStack.startTrans();
    }
    frameModel ??= await frameManager!.createNextFrame(doNotify: false);
    // 코텐츠를 play 하고 DB 에 Crete 하고 업로드까지 한다.
    logger.info('frameCretated(${frameModel.mid}');
    await ContentsManager.createContents(frameManager, modelList, frameModel, pageModel);
    mychangeStack.endTrans();
  }
}
