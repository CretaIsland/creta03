import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
import '../common/creta_utils.dart';
import '../model/app_enums.dart';
import '../model/book_model.dart';
import '../model/contents_model.dart';
import '../model/creta_model.dart';
import '../model/frame_model.dart';
import '../model/page_model.dart';
import '../pages/studio/book_preview_menu.dart';
import '../pages/studio/containees/frame/sticker/stickerview.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import 'contents_manager.dart';
import 'creta_manager.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends CretaManager {
  final PageModel pageModel;
  final BookModel bookModel;

  // GlobalKey? _frameMainKey;
  // void setFrameMainKey(GlobalKey key) {
  //   _frameMainKey = key;
  // }

  // Offset _pageOffset = Offset.zero;
  // Offset get pageOffset {
  //   if (_frameMainKey == null) return Offset.zero;
  //   if (_pageOffset != Offset.zero) return _pageOffset;
  //   final RenderBox? box = _frameMainKey!.currentContext?.findRenderObject() as RenderBox?;
  //   if (box != null) {
  //     logger.info('box.size=${box.size}');
  //     _pageOffset = box.localToGlobal(Offset.zero);
  //     logger.info('box.position=$_pageOffset');
  //     return _pageOffset;
  //   }
  //   return Offset.zero;
  // }
  // void setPageOffset(Offset offset) {
  //   _pageOffset = offset;
  // }

  //Map<String, ValueKey> frameKeyMap = {};
  Map<String, GlobalKey<StickerState>> frameKeyMap = {};
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

  final bool isPublishedMode;

  FrameManager(
      {required this.pageModel,
      required this.bookModel,
      String tableName = 'creta_frame',
      this.isPublishedMode = false})
      : super(tableName, pageModel.mid) {
    saveManagerHolder?.registerManager('frame', this, postfix: pageModel.mid);
  }

  @override
  AbsExModel newModel(String mid) => FrameModel(mid, bookModel.mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    //print('cloneModel ${src.mid}');
    FrameModel retval = newModel(src.mid) as FrameModel;
    src.copyTo(retval);
    return retval;
  }

  Future<FrameModel> createNextFrame(
      {bool doNotify = true,
      Size size = const Size(600, 400),
      Offset? pos,
      Color? bgColor1,
      FrameType? type,
      int? subType,
      ShapeType? shape}) async {
    logger.info('createNextFrame()');
    FrameModel defaultFrame = FrameModel.makeSample(safeLastOrder() + 1, pageModel.mid, bookModel);
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
    if (subType != null) {
      defaultFrame.subType = subType;
    }
    if (shape != null) {
      defaultFrame.shape.set(shape, save: false, noUndo: true);
    }
    await _createNextFrame(defaultFrame, doNotify);
    MyChange<FrameModel> c = MyChange<FrameModel>(
      defaultFrame,
      execute: () async {},
      redo: () async {
        await _redoCreateNextFrame(defaultFrame, doNotify);
      },
      undo: (FrameModel old) async {
        await _undoCreateNextFrame(old, doNotify);
      },
    );
    mychangeStack.add(c);

    return defaultFrame;
  }

  Future<FrameModel> _createNextFrame(FrameModel defaultFrame, bool doNotify) async {
    logger.info('createNextFrame()');

    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getLength(), doNotify: doNotify);
    selectedMid = defaultFrame.mid;
    return defaultFrame;
  }

  Future<FrameModel> _redoCreateNextFrame(FrameModel defaultFrame, bool doNotify) async {
    logger.info('_redoCreateNextFrame()');

    defaultFrame.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(defaultFrame);
    insert(defaultFrame, postion: getLength(), doNotify: true);
    selectedMid = defaultFrame.mid;
    return defaultFrame;
  }

  Future<FrameModel> _undoCreateNextFrame(FrameModel old, bool doNotify) async {
    logger.info('_undoCreateNextFrame()');
    old.isRemoved.set(true, noUndo: true, save: false);
    remove(old);
    if (selectedMid == old.mid) {
      selectedMid = prevSelectedMid;
    }
    await setToDB(old);
    return old;
  }

  Future<FrameModel> copyFrame(FrameModel src) async {
    //print('copyFrame**************--------------------------');

    FrameModel newModel = FrameModel('', bookModel.mid);
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
      tableName: isPublishedMode ? 'creta_contents_published' : 'creta_contents',
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
    //logger.info('resizeFrame()===============================');
    //logger.info(
    //   'resizeFrame($ratio, $invalidate) pageWidth=$pageWidth, pageHeight=$pageHeight, imageW=$contentsWidth, imageH=$contentsHeight, dx=$dx, dy=$dy --------------------');

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
  Future<void> removeChild(String parentMid) async {
    ContentsManager? contentsManager = getContentsManager(parentMid);
    await contentsManager?.removeAll();
    removeLink(parentMid); // 이 Frame 에 연결된 link 를 모두 지운다.
  }

  void removeLink(String mid) {
    logger.info('removeLink---------------FrameManager');
    for (var manager in contentsManagerMap.values) {
      manager.removeLink(mid);
    }
  }

  Future<void> findOrInitContentsManager() async {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FrameModel frameModel = ele as FrameModel;
      ContentsManager? contentsManager = findContentsManager(frameModel.mid);
      if (contentsManager == null) {
        //logger.info('new ContentsManager created (${frameModel.mid})');
        contentsManager = newContentsManager(frameModel);
        contentsManager.clearAll();
      } else {
        //logger.info('old ContentsManager used (${frameModel.mid})');
      }
    }
    for (var mid in contentsManagerMap.keys.toList()) {
      ContentsManager contentsManager = contentsManagerMap[mid]!;
      await _initContentsManager(mid, contentsManager);
    }
  }

  Future<void> _initContentsManager(String frameMid, ContentsManager contentsManager) async {
    if (contentsManager.onceDBGetComplete == false) {
      await contentsManager.getContents();
      contentsManager.addRealTimeListen(frameMid);
      contentsManager.reOrdering();
    }
    logger.info('$frameMid=initChildren(${contentsManager.getAvailLength()})');
  }

  @override
  Future<int> makeCopyAll(String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(ele, newParentMid);
      ContentsManager? contentsManager = findContentsManager(ele.mid);
      await contentsManager?.makeCopyAll(newOne.mid);
      counter++;
    }
    unlock();
    return counter;
  }

  FrameModel? findFrameByPos(Offset pos) {
    FrameModel? retval;
    reverseMapIterator((model) {
      FrameModel frame = model as FrameModel;
      GlobalKey? stickerKey = frameKeyMap[frame.mid];
      if (stickerKey == null) {
        return null;
      }
      bool founded = CretaUtils.isMousePointerOnWidget(stickerKey, pos);
      if (founded) {
        logger.info('pointer is on widget order ${frame.order.value}');
        retval = frame;
        return frame;
      }
    });
    return retval;
  }

  FrameModel? getMainFrame() {
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FrameModel model = ele as FrameModel;
      if (model.isMain.value == true) {
        return model;
      }
    }
    // 여기까지 왔다면 없는 것임.
    // 제일 앞에 있으면서,  숨겨져 있지 않는 frame 을 리턴한다.

    for (var ele in getReversed()) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FrameModel frame = ele as FrameModel;
      if (frame.isShow.value == false) {
        continue;
      }
      if (frame.frameType == FrameType.text) {
        continue;
      }
      return frame;
    } // 만약 여기서도, 해당 하는 것이 없으면 어쩔것인가 ?
    // 숨겨진거라도 리턴한다.

    for (var ele in getReversed()) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      FrameModel frame = ele as FrameModel;
      return frame;
    } // 만약 여기서도, 해당 하는 것이 없으면 어쩔것인가 ?

    return null;
  }

  void nextPageListener(FrameModel frameModel) {
    if (!StudioVariables.isAutoPlay || !StudioVariables.isPreview) {
      return;
    }
    FrameModel? main = getMainFrame();
    if (main == null) {
      return;
    }
    if (main.mid != frameModel.mid) {
      return;
    }
    BookPreviewMenu.previewMenuPressed = true;
    BookMainPage.pageManagerHolder?.gotoNext();
  }

  bool isVisible(FrameModel model) {
    if (model.isRemoved.value == true) return false;
    if (model.isShow.value == false) return false;
    if (BookMainPage.filterManagerHolder!.isVisible(model) == false) return false;
    return true;
  }

  void refreshFrame(String mid) {
    GlobalKey<StickerState>? frameKey = frameKeyMap[mid];
    if (frameKey == null) return;
    frameKey.currentState!.refresh();
  }
  //bool isMain() {}
}
