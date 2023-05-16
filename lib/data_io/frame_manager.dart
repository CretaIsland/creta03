import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../model/app_enums.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/studio_constant.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  PageModel pageModel;
  BookModel bookModel;
  //Map<String, ValueKey> frameKeyMap = {};
  Map<String, GlobalKey> frameKeyMap = {};
  Map<String, ContentsManager> contentsManagerMap = {};

  bool _initFrameComplete = false;
  bool get initFrameComplete => _initFrameComplete;

  void setContentsManager(String frameId, ContentsManager c) {
    contentsManagerMap[frameId] = c;
  }

  ContentsManager? getContentsManager(String frameId) => contentsManagerMap[frameId];

  // PlayerHandler? _playerHandler;
  // void setPlayerHandler(PlayerHandler p) {
  //   _playerHandler = p;
  // }

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

  Future<FrameModel> createNextFrame(
      {bool doNotify = true,
      Size size = const Size(600, 400),
      Offset? pos,
      Color? bgColor1,
      FrameType? type}) async {
    logger.info('createNextFrame()');
    FrameModel defaultFrame = FrameModel.makeSample(safeLastOrder() + 1, pageModel.mid);
    defaultFrame.width.set(size.width, save: false, noUndo: true);
    defaultFrame.height.set(size.height, save: false, noUndo: true);
    if (pos != null) {
      defaultFrame.posX.set(pos.dx, save: false, noUndo: true);
      defaultFrame.posY.set(pos.dy, save: false, noUndo: true);
    }
    if (bgColor1 != null) {
      defaultFrame.bgColor1.set(bgColor1, save: false, noUndo: true);
    }
    if (type != null) {
      defaultFrame.frameType = type;
    }
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getLength(), doNotify: doNotify);
    selectedMid = defaultFrame.mid;
    return defaultFrame;
  }

  Future<FrameModel> copyFrame(FrameModel src) async {
    FrameModel newModel = FrameModel('');
    newModel.copyFrom(src, newMid: newModel.mid);

    newModel.posX.set(src.posX.value + 20, save: false, noUndo: true);
    newModel.posY.set(src.posY.value + 20, save: false, noUndo: true);
    newModel.order.set(safeLastOrder() + 1, save: false, noUndo: true);

    logger.fine('create new frame ${newModel.mid}');

    await createToDB(newModel);
    insert(newModel, postion: getLength());
    selectedMid = newModel.mid;
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
    endTransaction();
    _initFrameComplete = true;
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

    // ContentsManager? retval = contentsManagerMap[frameModel.mid];
    // if (retval == null) {
    ContentsManager retval = ContentsManager(
      pageModel: pageModel,
      frameModel: frameModel,
    );
    contentsManagerMap[frameModel.mid] = retval;
    //}
    return retval;
  }

  ContentsManager? findContentsManager(String frameModelMid) {
    logger.fine('findContentsManager(${pageModel.width.value}, ${pageModel.height.value})*******');
    return contentsManagerMap[frameModelMid];
  }

  ContentsModel? getCurrentModel(String frameMid) {
    ContentsManager? retval = contentsManagerMap[frameMid];
    if (retval != null) {
      return retval.getCurrentModel();
    }
    return null;
  }

  Future<void> resizeFrame(
      FrameModel frameModel, double ratio, double contentsWidth, double contentsHeight,
      {bool invalidate = true, bool initPosition = true, bool undo = false}) async {
    // 원본에서 ratio = h / w 이다.
    //width 와 height 중 짧은 쪽을 기준으로 해서,
    // 반대편을 ratio 만큼 늘린다.
    if (ratio == 0) return;

    // double w = frameModel.width.value;
    // double h = frameModel.height.value;

    double pageHeight = pageModel.height.value;
    double pageWidth = pageModel.width.value;

    double dx = frameModel.posX.value;
    double dy = frameModel.posY.value;
    logger.info('resizeFrame()===============================');
    logger.info(
        'resizeFrame($ratio, $invalidate) pageWidth=$pageWidth, pageHeight=$pageHeight, imageW=$contentsWidth, imageH=$contentsHeight, dx=$dx, dy=$dy --------------------');

    // if (contentsWidth <= pageWidth && contentsHeight <= pageHeight) {
    //   w = contentsWidth;
    //   h = contentsHeight;
    // } else {
    //   // 뭔가가 pageSize 보다 크다.  어느쪽이 더 큰지 본다.
    //   double wRatio = pageWidth / contentsWidth;
    //   double hRatio = pageHeight / contentsHeight;
    //   if (wRatio > hRatio) {
    //     w = pageWidth;
    //     h = w * ratio;
    //   } else {
    //     h = pageHeight;
    //     w = h / ratio;
    //   }
    // }

    if (initPosition) {
      dx = (pageWidth - contentsWidth) / 2;
      dy = (pageHeight - contentsHeight) / 2;
      frameModel.posX.set(dx, save: false, noUndo: !undo);
      frameModel.posY.set(dy, save: false, noUndo: !undo);
    }
    double offset = LayoutConst.stikerOffset / 2;
    if (contentsWidth + dx + offset >= pageWidth) {
      frameModel.posX.set(0, save: false, noUndo: !undo);
    }
    if (contentsHeight + dy + offset >= pageHeight) {
      frameModel.posY.set(0, save: false, noUndo: !undo);
    }

    frameModel.width.set(contentsWidth, save: false, noUndo: !undo);
    frameModel.height.set(contentsHeight, save: false, noUndo: !undo);

    logger.info(
        'resizeFrame($ratio, $invalidate) w=$contentsWidth, h=$contentsHeight, dx=$dx, dy=$dy --------------------');
    await setToDB(frameModel);

    if (invalidate) {
      notify();
    }
  }

  Future<void> resizeFrame2(FrameModel frameModel, {bool invalidate = true}) async {
    ContentsModel? contentsModel = getCurrentModel(frameModel.mid);
    if (contentsModel == null) {
      return;
    }
    logger.info('resizeFrame2 ${contentsModel.name}');
    await resizeFrame(frameModel, contentsModel.aspectRatio.value, contentsModel.width.value,
        contentsModel.height.value,
        invalidate: invalidate, initPosition: false, undo: true);
  }

  Future<void> setSoundOff() async {
    for (var manager in contentsManagerMap.values) {
      logger.info('frameManager.setSoundOff()********');
      await manager.setSoundOff();
    }
  }

  Future<void> resumeSound() async {
    for (var manager in contentsManagerMap.values) {
      logger.info('frameManager.resumeSound()********');
      await manager.resumeSound();
    }
  }

  Future<void> pause() async {
    for (var manager in contentsManagerMap.values) {
      logger.info('frameManager.setSoundOff()********');
      await manager.pause();
    }
  }

  Future<void> resume() async {
    for (var manager in contentsManagerMap.values) {
      logger.info('frameManager.resumeSound()********');
      await manager.resume();
    }
  }

  @override
  void removeChild(String parentMid) {
    ContentsManager? contentsManager = getContentsManager(parentMid);
    contentsManager?.removeAll();
  }

  Future<void> findOrInitContentsManager() async {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FrameModel frameModel = ele as FrameModel;
      ContentsManager? contentsManager = findContentsManager(frameModel.mid);
      if (contentsManager == null) {
        logger.info('new ContentsManager created (${frameModel.mid})');
        contentsManager = newContentsManager(frameModel);
        contentsManager.clearAll();
      } else {
        logger.info('old ContentsManager used (${frameModel.mid})');
      }
    }
    for (var contentsManager in contentsManagerMap.values.toList()) {
      await _initContentsManager(contentsManager);
    }
  }

  Future<void> _initContentsManager(ContentsManager contentsManager) async {
    if (contentsManager.onceDBGetComplete == false) {
      await contentsManager.getContents();
      contentsManager.addRealTimeListen();
      contentsManager.reOrdering();
    }
    logger.info('initChildren(${contentsManager.getAvailLength()})');
  }
}
