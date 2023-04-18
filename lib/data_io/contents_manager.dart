// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import '../lang/creta_lang.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/studio_variables.dart';
import '../player/player_handler.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';

class ContentsManager extends CretaManager {
  final PageModel pageModel;
  final FrameModel frameModel;

  bool hasContents() {
    return (getAvailLength() > 0);
  }

  bool iamBusy = false;
  final Duration snackBarDuration = const Duration(seconds: 1);

  FrameManager? frameManager; //onDropPage 에서 video Contents 가 Drop 된 경우만 값을 가지고 있게 된다.

  PlayerHandler? playerHandler;
  void setPlayerHandler(PlayerHandler p) {
    playerHandler = p;
  }

  ContentsManager({required this.pageModel, required this.frameModel}) : super('creta_contents') {
    saveManagerHolder?.registerManager('contents', this, postfix: frameModel.mid);
  }

  @override
  AbsExModel newModel(String mid) => ContentsModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    ContentsModel retval = newModel(src.mid) as ContentsModel;
    src.copyTo(retval);
    return retval;
  }

  ContentsModel? getCurrentModel() {
    if (playerHandler == null) {
      return null;
    }
    return playerHandler?.getCurrentModel();
  }

  Future<ContentsModel> createNextContents(ContentsModel model, {bool doNotify = true}) async {
    model.order.set(lastOrder() + 1, save: false, noUndo: true);
    await createToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);
    if (playerHandler != null) {
      if (playerHandler!.isInit()) {
        await playerHandler?.rewind();
        await playerHandler?.pause();
      }
      await playerHandler?.reOrdering(rewind: true);
    }
    return model;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> getContents() async {
    logger.fine('getContents-------------------------------------------');
    int contentsCount = 0;
    startTransaction();
    try {
      contentsCount = await _getContents();
    } catch (e) {
      logger.finest('something wrong $e');
    }
    //reOrdering();
    endTransaction();
    return contentsCount;
  }

  Future<int> _getContents({int limit = 99}) async {
    logger.finest('getContents');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: frameModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getContents ${modelList.length}');
    return modelList.length;
  }

  // void resizeFrame(double ratio, double imageWidth, double imageHeight,
  //     {bool invalidate = true, bool initPosition = true}) {
  //   //abs_palyer에서만 호출된다.
  //   // 원본에서 ratio = h / w 이다.
  //   //width 와 height 중 짧은 쪽을 기준으로 해서,
  //   // 반대편을 ratio 만큼 늘린다.
  //   if (ratio == 0) return;

  //   double w = frameModel.width.value;
  //   double h = frameModel.height.value;

  //   double pageHeight = pageModel.height.value;
  //   double pageWidth = pageModel.width.value;

  //   double dx = frameModel.posX.value;
  //   double dy = frameModel.posY.value;

  //   logger.fine(
  //       'resizeFrame($ratio, $invalidate) pageWidth=$pageWidth, pageHeight=$pageHeight, imageW=$imageWidth, imageH=$imageHeight, dx=$dx, dy=$dy --------------------');

  //   if (imageWidth <= pageWidth && imageHeight <= pageHeight) {
  //     w = imageWidth;
  //     h = imageHeight;
  //   } else {
  //     // 뭔가가 pageSize 보다 크다.  어느쪽이 더 큰지 본다.
  //     double wRatio = pageWidth / imageWidth;
  //     double hRatio = pageHeight / imageHeight;
  //     if (wRatio > hRatio) {
  //       w = pageWidth;
  //       h = w * ratio;
  //     } else {
  //       h = pageHeight;
  //       w = h / ratio;
  //     }
  //   }
  //   if (initPosition == true) {
  //     dx = (pageWidth - w) / 2;
  //     dy = (pageHeight - h) / 2;
  //     frameModel.posX.set(dx, save: false, noUndo: true);
  //     frameModel.posY.set(dy, save: false, noUndo: true);
  //   }
  //   frameModel.width.set(w, save: false, noUndo: true);
  //   frameModel.height.set(h, save: false, noUndo: true);
  //   logger.fine('resizeFrame($ratio, $invalidate) w=$w, h=$h, dx=$dx, dy=$dy --------------------');
  //   frameModel.save();

  //   if (invalidate) {
  //     notify();
  //   }
  // }

  Future<void> resizeFrame(double aspectRatio, Size size, bool invalidate) async {
    await frameManager?.resizeFrame(
      frameModel,
      aspectRatio,
      size.width,
      size.height,
      invalidate: invalidate,
    );
    // onDropPage 에서 동영상을 넣었을때, 딱 한번만 resizeFrame 하게 하기 위해,
    // frameManager 를 null 로 만들어준다.
    frameManager = null;
  }

  Size getRealSize() {
    double width = StudioVariables.applyScale * frameModel.width.value;
    double height = StudioVariables.applyScale * frameModel.height.value;
    return Size(width, height);
  }

  Future<void> removeSelected(BuildContext context) async {
    iamBusy = true;

    ContentsModel? model = getSelected() as ContentsModel?;
    if (model == null) {
      showSnackBar(context, CretaLang.contentsNotDeleted, duration: snackBarDuration);
      await Future.delayed(snackBarDuration);
      iamBusy = false;
      return;
    }

    if (playerHandler != null && playerHandler!.isInit()) {
      //await pause();

      model.isRemoved.set(true, save: false);
      await setToDB(model);
      remove(model);
      logger.info('remove contents ${model.name}, ${model.mid}');
      await playerHandler?.reOrdering();

      if (getAvailLength() == 0) {
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
      }

      // ignore: use_build_context_synchronously
      showSnackBar(context, model.name + CretaLang.contentsDeleted, duration: snackBarDuration);
      await Future.delayed(snackBarDuration);
      iamBusy = false;

      //MiniMenu.minuMenuKey
      BookMainPage.containeeNotifier!.notify();
      return;
    }
    showSnackBar(context, CretaLang.contentsNotDeleted, duration: snackBarDuration);
    await Future.delayed(snackBarDuration);
    iamBusy = false;
  }

  Future<void> pause() async {
    await playerHandler?.pause();
  }

  Future<void> globalPause() async {
    await playerHandler?.globalPause();
  }

  Future<void> globalResume() async {
    await playerHandler?.globalResume();
  }

  // void setLoop(bool loop) {
  //   playerHandler?.setLoop(loop);
  // }
}
