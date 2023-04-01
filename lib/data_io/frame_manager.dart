import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../player/player_handler.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  PageModel pageModel;
  BookModel bookModel;
  //Map<String, ValueKey> frameKeyMap = {};
  Map<String, GlobalKey> frameKeyMap = {};

  ContentsManager? contentsManager;
  void setContentsManager(ContentsManager c) {
    contentsManager = c;
  }

  PlayerHandler? playerHandler;
  void setPlayerHandler(PlayerHandler p) {
    playerHandler = p;
  }

  FrameManager({required this.pageModel, required this.bookModel}) : super('creta_frame') {
    saveManagerHolder?.registerManager('frame', this, postfix: pageModel.mid);
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  Future<FrameModel> createNextFrame({bool doNotify = true}) async {
    FrameModel defaultFrame = FrameModel.makeSample(lastOrder() + 1, pageModel.mid);
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getAvailLength(), doNotify: doNotify);
    selectedMid = defaultFrame.mid;
    //reOrdering();
    return defaultFrame;
  }

  Future<FrameModel> copyFrame(FrameModel src) async {
    FrameModel newModel = FrameModel('');
    newModel.copyFrom(src, newMid: newModel.mid);

    newModel.posX.set(src.posX.value + 20, save: false, noUndo: true);
    newModel.posY.set(src.posY.value + 20, save: false, noUndo: true);
    newModel.order.set(lastOrder() + 1, save: false, noUndo: true);

    logger.fine('create new frame ${newModel.mid}');

    await createToDB(newModel);
    insert(newModel, postion: getAvailLength());
    selectedMid = newModel.mid;
    //reOrdering();
    return newModel;
  }

  Future<int> getFrames() async {
    int frameCount = 0;
    startTransaction();
    try {
      frameCount = await _getFrames();
      if (frameCount == 0) {
        await createNextFrame();
        frameCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      await createNextFrame();
      frameCount = 1;
    }
    //reOrdering();
    endTransaction();
    return frameCount;
  }

  Future<int> _getFrames({int limit = 99}) async {
    logger.finest('getFrames');
    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: pageModel.mid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    logger.finest('getFrames ${modelList.length}');
    return modelList.length;
  }

  ContentsManager newContentsManager(FrameModel frameModel) {
    logger.fine('newContentsManager(${pageModel.width.value}, ${pageModel.height.value})*******');

    contentsManager ??= ContentsManager(
      pageModel: pageModel,
      frameModel: frameModel,
    );
    return contentsManager!;
  }

  ContentsModel? getCurrentModel() {
    if (playerHandler == null) {
      return null;
    }
    return playerHandler?.getCurrentModel();
  }

  Future<void> resizeFrame(
      FrameModel frameModel, double ratio, double contentsWidth, double contentsHeight,
      {bool invalidate = true, bool initPosition = true}) async {
    // 원본에서 ratio = h / w 이다.
    //width 와 height 중 짧은 쪽을 기준으로 해서,
    // 반대편을 ratio 만큼 늘린다.
    if (ratio == 0) return;

    double w = frameModel.width.value;
    double h = frameModel.height.value;

    double pageHeight = pageModel.height.value;
    double pageWidth = pageModel.width.value;

    double dx = frameModel.posX.value;
    double dy = frameModel.posY.value;

    logger.info(
        'resizeFrame($ratio, $invalidate) pageWidth=$pageWidth, pageHeight=$pageHeight, imageW=$contentsWidth, imageH=$contentsHeight, dx=$dx, dy=$dy --------------------');

    if (contentsWidth <= pageWidth && contentsHeight <= pageHeight) {
      w = contentsWidth;
      h = contentsHeight;
    } else {
      // 뭔가가 pageSize 보다 크다.  어느쪽이 더 큰지 본다.
      double wRatio = pageWidth / contentsWidth;
      double hRatio = pageHeight / contentsHeight;
      if (wRatio > hRatio) {
        w = pageWidth;
        h = w * ratio;
      } else {
        h = pageHeight;
        w = h / ratio;
      }
    }

    if (initPosition) {
      dx = (pageWidth - w) / 2;
      dy = (pageHeight - h) / 2;
      frameModel.posX.set(dx, save: false, noUndo: true);
      frameModel.posY.set(dy, save: false, noUndo: true);
    }

    frameModel.width.set(w, save: false, noUndo: true);
    frameModel.height.set(h, save: false, noUndo: true);
    logger.info('resizeFrame($ratio, $invalidate) w=$w, h=$h, dx=$dx, dy=$dy --------------------');
    await setToDB(frameModel);

    if (invalidate) {
      notify();
    }
  }

  Future<void> resizeFrame2(FrameModel frameModel, {bool invalidate = true}) async {
    logger.info('resizeFrame');
    ContentsModel? contentsModel = getCurrentModel();
    if (contentsModel == null) {
      return;
    }
    await resizeFrame(frameModel, contentsModel.aspectRatio.value, contentsModel.width.value,
        contentsModel.height.value,
        invalidate: invalidate, initPosition: false);
  }
}
