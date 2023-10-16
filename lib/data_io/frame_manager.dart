import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import '../design_system/component/tree/flutter_treeview.dart';
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
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../pages/studio/containees/frame/sticker/stickerview.dart';
import '../pages/studio/left_menu/left_menu_page.dart';
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

  // ignore: prefer_final_fields
  Map<String, GlobalKey<StickerState>> _frameKeyMap = {};
  Map<String, GlobalKey<StickerState>> get frameKeyMap => _frameKeyMap;
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

  @override
  void remove(CretaModel removedItem) {
    //print('remove frame ${removedItem.mid}');
    BookMainPage.removeOverlay(removedItem.mid);
    super.remove(removedItem);
  }

  void addOverlay() {
    orderMapIterator((e) {
      FrameModel model = e as FrameModel;
      if (model.isOverlay.value == true && model.parentMid.value == pageModel.mid) {
        BookMainPage.addOverlay(model);
      }
    });
  }

  void mergeOverlay() {
    for (var ele in BookMainPage.overlayList()) {
      // 모델리스트에 없으면 modelList 에 넣는다.
      if (getModel(ele.mid) == null) {
        modelList.add(ele);
      }
    }
    reOrdering();
    //print('page: ${pageModel.name.value}------------------------------------------------');
    // for (var ele in modelList) {
    //   if (ele.isRemoved.value == false) {
    //     FrameModel model = ele as FrameModel;
    //     print(
    //         'order=${model.order.value},${model.name.value},isShow=${model.isShow.value},isOverlay=${model.isOverlay.value}');
    //     print('   ${model.mid}');
    //   }
    // }
  }

  void eliminateOverlay() {
    List<FrameModel> removeTargetList = [];
    for (var ele in modelList) {
      FrameModel model = ele as FrameModel;
      //if (model.isOverlay.value == true && model.parentMid.value != pageModel.mid) {
      // 이미 오버레이는 해제된 상태이므로  overlay 를 검사하면 안된다.
      if (model.parentMid.value != pageModel.mid) {
        if (BookMainPage.findOverlay(model.mid) == null) {
          removeTargetList.add(model);
        }
      }
    }
    for (FrameModel ele in removeTargetList) {
      //print('remove overlay ${ele.name.value}');
      modelList.remove(ele);
    }
    reOrdering();
  }

  Future<FrameModel> createNextFrame(
      {bool doNotify = true,
      Size size = LayoutConst.defaultFrameSize,
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

    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();

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

  Future<FrameModel> copyFrame(FrameModel src,
      {String? parentMid, FrameManager? srcFrameManager, bool samePage = true}) async {
    //print('copyFrame**************--------------------------');

    FrameModel newModel = FrameModel('', bookModel.mid);
    newModel.copyFrom(src, newMid: newModel.mid, pMid: parentMid);

    newModel.posX.set(src.posX.value + 20, save: false, noUndo: true);
    newModel.posY.set(src.posY.value + 20, save: false, noUndo: true);
    newModel.order.set(safeLastOrder() + 1, save: false, noUndo: true);
    newModel.isRemoved.set(false, save: false, noUndo: true);

    if (srcFrameManager != null && samePage == false) {
      ContentsManager contentsManager = srcFrameManager.findContentsManager(src);
      await contentsManager.copyContents(newModel.mid, bookModel.mid, samePage: samePage);
    } else {
      ContentsManager? contentsManager = findContentsManager(src);
      await contentsManager.copyContents(newModel.mid, bookModel.mid);
    }
    await createToDB(newModel);
    insert(newModel, postion: getLength());
    selectedMid = newModel.mid;

    return newModel;
  }

  Future<void> copyFrames(String pageMid, String bookMid, {bool samePage = true}) async {
    double order = 1;
    for (var ele in modelList) {
      FrameModel org = ele as FrameModel;
      if (org.isRemoved.value == true) continue;
      FrameModel newModel = FrameModel('', bookMid);
      newModel.copyFrom(org, newMid: newModel.mid, pMid: pageMid);
      newModel.order.set(order++, save: false, noUndo: true);
      logger.info('create new FrameModel ${newModel.name},${newModel.mid}');

      ContentsManager contentsManager = findContentsManager(org);
      await contentsManager.copyContents(newModel.mid, bookMid, samePage: samePage);

      await createToDB(newModel);
    }
  }

  Future<int> getFrames() async {
    int frameCount = 0;
    startTransaction();
    try {
      frameCount = await _getFrames();
      if (frameCount == 0) {
        //await createNextFrame();
        //frameCount = 1;
      }
    } catch (e) {
      logger.finest('something wrong $e');
      //await createNextFrame();
      //frameCount = 1;
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
    retval.setFrameManager(this);
    //}
    return retval;
  }

  ContentsManager? findContentsManagerByMid(String frameModelMid) {
    logger.fine(
        'findContentsManagerByMid(${pageModel.width.value}, ${pageModel.height.value})*******');
    return contentsManagerMap[frameModelMid];
  }

  ContentsManager findContentsManager(FrameModel frameModel) {
    ContentsManager? retval;
    if (frameModel.isOverlay.value == true && pageModel.mid != frameModel.parentMid.value) {
      //  Overlay 이기 때문에,  ContentsManager 가 다른 frameManager 에 있는 것이므로
      // 해당 프레임을 찾아야 한다.
      FrameManager? anotherFrameManager =
          BookMainPage.pageManagerHolder!.findFrameManager(frameModel.parentMid.value);
      if (anotherFrameManager != null) {
        //print('anotherFrameManager is founded ${frameModel.parentMid.value}');
        retval = anotherFrameManager.findContentsManagerByMid(frameModel.mid);
        if (retval == null) {
          //print('anotherFrameManager.frameManager not founded ${frameModel.mid}, create here');
          // 여기서 ContentsManagerMap  에 등록된다.
          retval = anotherFrameManager.newContentsManager(frameModel);
          retval.clearAll();
        }
      } else {
        //print(
        //    'something wrong !!!! anotherFrameManager is not founded ${frameModel.parentMid.value}');
      }
    } else {
      retval = findContentsManagerByMid(frameModel.mid);
      if (retval == null) {
        // 여기서 ContentsManagerMap  에 등록된다.
        retval = newContentsManager(frameModel);
        retval.clearAll();
      }
    }

    return retval!;
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
      logger.info('frameManager.pause()********');
      await manager.pause();
    }
  }

  Future<void> resume() async {
    for (var manager in contentsManagerMap.values) {
      logger.info('frameManager.resume()********');
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
      //print('findOrInitContentsManager');
      ContentsManager contentsManager = findContentsManager(frameModel);
      // if (contentsManager == null) {
      //   logger.info('new ContentsManager created (${frameModel.mid})');
      //   contentsManager = newContentsManager(frameModel);
      //   contentsManager.clearAll();
      // } else {
      //   logger.info('old ContentsManager used (${frameModel.mid})');
      // }
      await contentsManager.initContentsManager(frameModel.mid);
    }
    // for (var mid in contentsManagerMap.keys.toList()) {
    //   ContentsManager contentsManager = contentsManagerMap[mid]!;
    //   await _initContentsManager(mid, contentsManager);
    // }
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
      ContentsManager contentsManager = findContentsManager(ele as FrameModel);
      await contentsManager.makeCopyAll(newOne.mid);
      counter++;
    }
    unlock();
    return counter;
  }

  FrameModel? findFrameByPos(Offset pos) {
    FrameModel? retval;
    reverseMapIterator((model) {
      FrameModel frame = model as FrameModel;
      GlobalKey? stickerKey = frameKeyMap['${pageModel.mid}/${frame.mid}'];
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
      if (frame.frameType != FrameType.none) {
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

  // bool isVisible(FrameModel model) {
  //   if (model.isRemoved.value == true) return false;
  //   if (model.isShow.value == false) return false;
  //   if (BookMainPage.filterManagerHolder!.isVisible(model) == false) return false;
  //   return true;
  // }

  void refreshFrame(String mid) {
    GlobalKey<StickerState>? frameKey = frameKeyMap['${pageModel.mid}/$mid'];
    if (frameKey == null) return;
    frameKey.currentState!.refresh();
  }
  //bool isMain() {}

  List<Node> toNodes(PageModel page) {
    //print('invoke frameMangaer.toNodes()');
    List<Node> accNodes = [];
    for (var ele in orderValues()) {
      FrameModel model = ele as FrameModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      List<Node> conNodes = [];
      ContentsManager contentsManager = findContentsManager(model);
      //if (contentsManager != null) {
      conNodes = contentsManager.toNodes(model);
      //}
      accNodes.add(Node<CretaModel>(
        key: '${page.mid}/${model.mid}',
        keyType: ContaineeEnum.Frame,
        label: model.name.value,
        data: model,
        expanded: model.expanded || isSelected(model.mid),
        children: conNodes,
        root: page.mid,
      ));
    }
    return accNodes;
  }

  bool clickedInsideSelectedFrame(Offset position) {
    if (DraggableStickers.frameSelectNotifier == null) return false;
    GlobalKey? key =
        frameKeyMap['${pageModel.mid}/${DraggableStickers.frameSelectNotifier!.selectedAssetId}'];
    if (key == null) {
      //print(' key is null , ${DraggableStickers.frameSelectNotifier!.selectedAssetId}');
      return false;
    }
    return CretaUtils.isMousePointerOnWidget(key, position);
  }

  ContentsModel? getFirstContents(String frameMid) {
    FrameModel? frameModel = getModel(frameMid) as FrameModel?;
    if (frameModel == null) {
      return null;
    }
    ContentsManager? contentsManager = getContentsManager(frameMid);
    if (contentsManager == null) {
      return null;
    }
    return contentsManager.getFirstModel();
  }

  @override
  double getMinOrder() {
    if (isEmpty()) return 1;
    double retval = 1;
    // int overlayCount = 0;
    // int normalCount = 0;
    lock();
    for (var ele in modelList) {
      FrameModel model = ele as FrameModel;
      if (model.isOverlay.value == true) {
        //overlayCount++;
        continue;
      }
      if (ele.order.value < retval) {
        retval = ele.order.value;
        //normalCount++;
      }
    }
    unlock();

    // if (normalCount == 0 && overlayCount > 0) {
    //   // 프레임가운데, orverlay 밖에 없는 경우다.
    //   return super.getMinOrder();
    // }

    return retval;
  }

  @override
  double getMaxOrder() {
    if (isEmpty()) return 1;
    double retval = 0;
    lock();
    for (var ele in modelList) {
      FrameModel model = ele as FrameModel;
      if (model.isOverlay.value == true) {
        continue;
      }
      if (ele.order.value > retval) {
        retval = ele.order.value;
      }
    }
    unlock();
    return retval;
  }

  @override
  double getBetweenOrder(int nth) {
    if (nth < 0) return getMinOrder();
    if (nth == 0) {
      double min = getMinOrder();
      if (min > 2) {
        return min - 1;
      }
      return min - StudioConst.orderVar;
    }
    int len = getAvailLength();
    if (len == 0) return 1;
    if (nth >= len) {
      logger.severe('1. this cant be happen $nth, $len');
      return getMaxOrder() + 1;
    }

    // nth 는 0보다는 크고, len 보다는 작은 수다.
    int count = 0;
    double firstValue = -1;
    double secondValue = -1;
    lock();
    for (MapEntry e in orderEntries()) {
      FrameModel model = e.value as FrameModel;
      if (model.isOverlay.value == true) {
        continue;
      }
      if (count == nth - 1) {
        firstValue = e.value.order.value;
      } else if (count == nth) {
        secondValue = e.value.order.value;
        unlock();
        return (firstValue + secondValue) / 2.0;
      }
      count++;
    }
    unlock();
    // 있을수 없다,. 에러다.
    logger.severe('3. this cant be happen $nth, $len');
    return getMaxOrder() + 1;
  }

  @override
  double lastOrder() {
    double retval = -1;
    for (MapEntry e in orderEntries()) {
      FrameModel model = e.value as FrameModel;
      if (model.isOverlay.value == true) {
        continue;
      }
      retval = model.order.value;
    }
    return retval;
  }

  double getMaxOrderWithOverlay() {
    double retval = 0;
    lock();
    for (var ele in modelList) {
      if (ele.order.value > retval) {
        retval = ele.order.value;
      }
    }
    unlock();
    return retval;
  }

  void exchangeOrder(String aMid, String bMid, String hint) {
    FrameModel? aModel = getModel(aMid) as FrameModel?;
    FrameModel? bModel = getModel(bMid) as FrameModel?;
    if (aModel == null) {
      logger.warning('$aMid does not exist in modelList');
      return;
    }
    if (bModel == null) {
      logger.warning('$bMid does not exist in modelList');
      return;
    }
    logger.info('Frame $hint :   ${aModel.order.value} <--> ${bModel.order.value}');

    double aOrder = aModel.order.value;
    double bOrder = bModel.order.value;

    mychangeStack.startTrans();
    aModel.order.set(bOrder);
    bModel.order.set(aOrder);
    mychangeStack.endTrans();
  }
}
