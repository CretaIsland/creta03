//import 'dart:ui';

import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_studio_io/data_io/base_frame_manager.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_treeview/flutter_treeview.dart';
import '../design_system/component/tree/flutter_treeview.dart';
//import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/database/abs_database.dart';
//import '../common/creta_utils.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../design_system/extra_text_style.dart';
import '../lang/creta_studio_lang.dart';
import '../pages/studio/book_preview_menu.dart';
import '../pages/studio/containees/containee_nofifier.dart';
//import '../pages/studio/containees/frame/sticker/stickerview.dart';
import '../pages/studio/containees/frame/sticker/mini_menu.dart';
import '../pages/studio/left_menu/left_menu_page.dart';
import '../pages/studio/left_menu/music/music_player_frame.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_getx_controller.dart';
import '../pages/studio/studio_variables.dart';
import '../player/creta_play_timer.dart';
import 'book_manager.dart';
import 'contents_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'key_handler.dart';

//FrameManager? frameManagerHolder;

class FrameManager extends BaseFrameManager {
  //final PageModel pageModel;
  //final BookModel bookModel;

  static Map<FrameModel, FrameModel> oldNewMap = {}; // linkCopy 시에 필요하다.
  static FrameModel? findNew(String oldMid) {
    for (var ele in oldNewMap.entries) {
      if (ele.key.mid == oldMid) {
        return ele.value;
      }
    }
    return null;
  }

  static Widget backgroundMusic(FrameModel frameModel) {
    FrameManager? frameManager =
        BookMainPage.pageManagerHolder!.frameManagerMap[frameModel.parentMid.value];
    if (frameManager == null) {
      return const SizedBox.shrink();
    }
    ContentsManager contentsManager = frameManager.findOrCreateContentsManager(frameModel);
    ContentsModel? model = contentsManager.getFirstModel();
    if (model != null) {
      if (contentsManager.playTimer != null) {
        //print('bg music played !!!!');
        return Opacity(
          opacity: 0.5,
          child: contentsManager.playTimer!.createWidget(model),
        );
      }
      //print('bg music created and played !!!!');
      CretaPlayTimer playTimer = CretaPlayTimer(contentsManager, frameManager);
      contentsManager.setPlayerHandler(playTimer);
      return Opacity(
        opacity: 0.5,
        child: contentsManager.playTimer!.createWidget(model),
      );
    }
    return const SizedBox.shrink();
  }

  static void stopBackgroundMusic(FrameModel frameModel) {
    for (var musicKey in BookMainPage.musicKeyMap.values) {
      GlobalObjectKey<MusicPlayerFrameState> player = musicKey;
      player.currentState!.stopMusic();
    }

    // FrameManager? frameManager =
    //     BookMainPage.pageManagerHolder!.frameManagerMap[frameModel.parentMid.value];
    // if (frameManager == null) {
    //   return;
    // }
    // ContentsManager contentsManager = frameManager.findContentsManager(frameModel);
    // ContentsModel? model = contentsManager.getFirstModel();
    // if (model == null) {
    //   return;
    // }
    // if (contentsManager.playTimer == null) {
    //   return;
    // }
    // print('background music stop');
    // contentsManager.playTimer?.stop();
    // return;
  }

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
  //     logger.fine('box.size=${box.size}');
  //     _pageOffset = box.localToGlobal(Offset.zero);
  //     logger.fine('box.position=$_pageOffset');
  //     return _pageOffset;
  //   }
  //   return Offset.zero;
  // }
  // void setPageOffset(Offset offset) {
  //   _pageOffset = offset;
  // }

  //Map<String, ValueKey> stickerKeyMap = {};

// ignore: prefer_final_fields
  // Map<String, GlobalKey<FrameThumbnailState>> _frameThumbnailKeyMap = {};
  // GlobalKey<FrameThumbnailState> frameThumbnailKeyGen(String pageMid, String frameMid) {
  //   String keyStr = frameThumbnailKeyMangler(pageMid, frameMid);
  //   GlobalKey<FrameThumbnailState>? frameThumbnailKey = _frameThumbnailKeyMap[keyStr];
  //   if (frameThumbnailKey != null) {
  //     return frameThumbnailKey;
  //   }
  //   GlobalObjectKey<FrameThumbnailState> key = GlobalObjectKey<FrameThumbnailState>(keyStr);
  //   _frameThumbnailKeyMap[keyStr] = key;
  //   return key;
  // }

  // GlobalKey<FrameThumbnailState>? findFrameThumbnailKey(String pageMid, String frameMid) {
  //   String keyStr = frameThumbnailKeyMangler(pageMid, frameMid);
  //   return _frameThumbnailKeyMap[keyStr];
  // }

  //
  //
  //
  //

  // final Map<String, GlobalKey<StickerState>> _stickerKeyMap = {};

  // String frameKeyMangler(String pageMid, String frameMid) {
  //   return 'FrameEach$pageMid/$frameMid';
  // }

  // GlobalKey<StickerState> stickerKeyGen(String pageMid, String frameMid) {
  //   String keyStr = stickerKeyMangler(pageMid, frameMid);
  //   GlobalKey<StickerState>? stickerKey = _stickerKeyMap[keyStr];
  //   if (stickerKey != null) {
  //     return stickerKey;
  //   }
  //   GlobalObjectKey<StickerState> key = GlobalObjectKey<StickerState>(keyStr);
  //   _stickerKeyMap[keyStr] = key;
  //   return key;
  // }

  // GlobalKey<StickerState>? findStickerKey(String pageMid, String frameMid) {
  //   String keyStr = stickerKeyMangler(pageMid, frameMid);
  //   return _stickerKeyMap[keyStr];
  // }

  bool refreshFrame(String mid, {bool deep = false}) {
    invalidateFrameEach(pageModel.mid, mid);
    if (deep) {
      invalidateContentsMain(pageModel.mid, mid);
      invalidateDragableResiable(pageModel.mid, mid);
      invalidateInstantEditor(pageModel.mid, mid);
    }
    invalidateFrameThumbnail(pageModel.mid, mid);
    invalidateSticker(pageModel.mid, mid);
    return true;
  }
  //
  //
  //

  KeyHandler frameThumbnailKeyHandler = KeyHandler();

  String frameThumbnailKeyMangler(String pageMid, String frameMid) {
    return 'FrameThumbnail$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerFrameThumbnailKey(
      String pageMid, String frameMid) {
    return frameThumbnailKeyHandler.registerKey(frameThumbnailKeyMangler(pageMid, frameMid));
  }

  bool invalidateFrameThumbnail(String pageMid, String frameMid) {
    return frameThumbnailKeyHandler.invalidate(frameThumbnailKeyMangler(pageMid, frameMid));
  }
//
  //
  //

  KeyHandler stickerKeyHandler = KeyHandler();
  String stickerKeyMangler(String pageMid, String frameMid) {
    return 'Sticker$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerStickerKey(String pageMid, String frameMid) {
    return stickerKeyHandler.registerKey(stickerKeyMangler(pageMid, frameMid));
  }

  bool invalidateSticker(String pageMid, String frameMid) {
    return stickerKeyHandler.invalidate(stickerKeyMangler(pageMid, frameMid));
  }

  //
  //
  //

  KeyHandler instantEditorKeyHandler = KeyHandler();
  String instantEditorKeyMangler(String pageMid, String frameMid) {
    return 'InstantEditor$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerInstantEditorrKey(
      String pageMid, String frameMid) {
    return instantEditorKeyHandler.registerKey(instantEditorKeyMangler(pageMid, frameMid));
  }

  bool invalidateInstantEditor(String pageMid, String frameMid) {
    return instantEditorKeyHandler.invalidate(instantEditorKeyMangler(pageMid, frameMid));
  }

  //
  //
  //

  KeyHandler dragableResiableKeyHandler = KeyHandler();
  String dragableResiableKeyMangler(String pageMid, String frameMid) {
    return 'DragableResiable$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerDragableResiableKey(
      String pageMid, String frameMid) {
    //print('registerDragableResiableKey=${dragableResiableKeyMangler(pageMid, frameMid)}');
    return dragableResiableKeyHandler.registerKey(dragableResiableKeyMangler(pageMid, frameMid));
  }

  bool invalidateDragableResiable(String pageMid, String frameMid) {
    //print('invalidateDragableResiable=${dragableResiableKeyMangler(pageMid, frameMid)}');
    return dragableResiableKeyHandler.invalidate(dragableResiableKeyMangler(pageMid, frameMid));
  }

  //
  //
  //
  KeyHandler frameEachKeyHandler = KeyHandler();
  String frameEachKeyMangler(String pageMid, String frameMid) {
    return 'FrameEach$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerFrameEachKey(
      String pageMid, String frameMid) {
    return frameEachKeyHandler.registerKey(frameEachKeyMangler(pageMid, frameMid));
  }

  bool invalidateFrameEach(String pageMid, String frameMid) {
    return frameEachKeyHandler.invalidate(frameEachKeyMangler(pageMid, frameMid));
  }
  //
  //
  //

  KeyHandler contentMainKeyHandler = KeyHandler();
  String contentMainKeyHandlerKeyMangler(String pageMid, String frameMid) {
    return 'ContentsMain$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerContentMainKeyHandlerKey(
      String pageMid, String frameMid) {
    return contentMainKeyHandler.registerKey(contentMainKeyHandlerKeyMangler(pageMid, frameMid));
  }

  bool invalidateContentsMain(String pageMid, String frameMid) {
    return contentMainKeyHandler.invalidate(contentMainKeyHandlerKeyMangler(pageMid, frameMid));
  }

  //
  //
  //

  Map<String, ContentsManager> contentsManagerMap = {};

  int updateContents(ContentsModel model) {
    int retval = 0;
    for (ContentsManager contentsManager in contentsManagerMap.values) {
      if (contentsManager.updateModel(model)) {
        //print('${model.name} matched !!!');
        retval++;
      }
    }
    return retval;
  }

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

  //final bool isPublishedMode;

  FrameManager(
      {required super.pageModel,
      required super.bookModel,
      String tableName = 'creta_frame',
      super.isPublishedMode = false})
      : super(tableName: tableName) {
    //saveManagerHolder?.registerManager('frame', this, postfix: pageModel.mid);
    //print('FrameManager created');
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
        logger.info('overlay ${ele.name.value} merged');
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
      modelList.remove(ele);
    }
    reOrdering();
  }

  bool hasMainFrame() {
    for (var ele in modelList) {
      FrameModel model = ele as FrameModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      if (model.isMain.value == true) {
        return true;
      }
    }
    return false;
  }

  String getMainFrameCandidator() {
    String retval = '';
    if (hasMainFrame() == false) {
      for (var ele in orderValues()) {
        if (parentMid != null && ele.parentMid.value != parentMid!) {
          continue; // overlay 는 빠져야 한다.
        }
        if (BookMainPage.musicKeyMap[ele.mid] != null) {
          continue; // 백그라운드 뮤직도 빠져야 한다.
        }
        ContentsManager? contentsManager = getContentsManager(ele.mid);
        if (contentsManager != null && contentsManager.getAvailLength() > 0) {
          retval = ele.mid;
        }
      }
    }
    return retval;
  }

  Future<FrameModel> createNextFrame(
      {bool doNotify = true,
      Size? size,
      Offset? pos,
      Color? bgColor1,
      FrameType? type,
      int? subType,
      ShapeType? shape}) async {
    size ??= CretaVars.instance.defaultSize();
    pos ??= Offset.zero;

    logger.fine('createNextFrame()');
    FrameModel defaultFrame = FrameModel.makeSample(safeLastOrder() + 1, pageModel.mid, bookModel);
    defaultFrame.width.set(size.width.roundToDouble(), save: false, noUndo: true);
    defaultFrame.height.set(size.height.roundToDouble(), save: false, noUndo: true);
    defaultFrame.posX.set(pos.dx, save: false, noUndo: true);
    defaultFrame.posY.set(pos.dy, save: false, noUndo: true);
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

    if (!hasMainFrame()) {
      // skpark 2023.11.24
      // 만약,  mainFrame 이 없으면, 새로 만들어진 Frame 이 자동으로 메인프레임이 된다.
      defaultFrame.isMain.set(true, save: false, noUndo: true);
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
    logger.fine('createNextFrame()');
    defaultFrame.isRemoved.set(false, save: false, noUndo: true);
    await createToDB(defaultFrame);
    insert(defaultFrame, postion: getLength(), doNotify: doNotify);
    //selectedMid = defaultFrame.mid;
    reOrdering();
    setSelectedMid(defaultFrame.mid);
    return defaultFrame;
  }

  Future<FrameModel> _redoCreateNextFrame(FrameModel defaultFrame, bool doNotify) async {
    logger.fine('_redoCreateNextFrame()');

    defaultFrame.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(defaultFrame);
    insert(defaultFrame, postion: getLength(), doNotify: doNotify);
    //selectedMid = defaultFrame.mid;
    setSelectedMid(defaultFrame.mid);
    return defaultFrame;
  }

  Future<FrameModel> _undoCreateNextFrame(FrameModel old, bool doNotify) async {
    logger.fine('_undoCreateNextFrame()');
    old.isRemoved.set(true, noUndo: true, save: false);
    if (selectedMid == old.mid) {
      selectedMid = prevSelectedMid;
    }
    remove(old);
    await setToDB(old);
    notify();
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
    //newModel.isRemoved.set(false, save: false, noUndo: true);

    if (srcFrameManager != null && samePage == false) {
      ContentsManager contentsManager = srcFrameManager.findOrCreateContentsManager(src);
      await contentsManager.copyContents(newModel.mid, bookModel.mid, samePage: samePage);
    } else {
      ContentsManager? contentsManager = findOrCreateContentsManager(src);
      await contentsManager.copyContents(newModel.mid, bookModel.mid);
    }

    await _createNextFrame(newModel, true);
    MyChange<FrameModel> c = MyChange<FrameModel>(
      newModel,
      execute: () async {},
      redo: () async {
        await _redoCreateNextFrame(newModel, true);
      },
      undo: (FrameModel old) async {
        await _undoCreateNextFrame(old, true);
      },
    );
    mychangeStack.add(c);
    // await createToDB(newModel);
    // insert(newModel, postion: getLength());
    // selectedMid = newModel.mid;

    return newModel;
  }

  Future<void> copyFrames(String pageMid, String bookMid, {bool samePage = true}) async {
    double order = 1;
    for (var ele in modelList) {
      FrameModel org = ele as FrameModel;
      if (org.isRemoved.value == true) continue;
      FrameModel newModel = FrameModel('', bookMid);
      //print('copy Frames');
      newModel.copyFrom(org, newMid: newModel.mid, pMid: pageMid);
      newModel.order.set(order++, save: false, noUndo: true);
      //print('create new FrameModel ${newModel.name},${newModel.mid}, $pageMid');

      ContentsManager contentsManager = findOrCreateContentsManager(org);
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

  Future<int> _getFrames({int limit = 99, String? parentMid}) async {
    parentMid ??= pageModel.mid;
    //print('getFrames($parentMid)');

    Map<String, QueryValue> query = {};
    query['parentMid'] = QueryValue(value: parentMid);
    query['isRemoved'] = QueryValue(value: false);
    Map<String, OrderDirection> orderBy = {};
    orderBy['order'] = OrderDirection.ascending;
    await queryFromDB(query, orderBy: orderBy, limit: limit);
    //print('getFrames ${modelList.length}');
    return modelList.length;
  }

  ContentsManager newContentsManager(FrameModel frameModel) {
    // ContentsManager? retval = contentsManagerMap[frameModel.mid];
    // if (retval == null) {
    ContentsManager retval = ContentsManager(
      pageModel: pageModel,
      frameModel: frameModel,
      tableName: isPublishedMode ? 'creta_contents_published' : 'creta_contents',
      isPublishedMode: isPublishedMode,
    );

    //print('newContentsManager(${pageModel.mid}, ${frameModel.mid})*******');

    contentsManagerMap[frameModel.mid] = retval;
    //print(
    //    'newContentsManager(${pageModel.mid}, ${frameModel.mid})*******${contentsManagerMap.length}');
    retval.setFrameManager(this);
    //}
    return retval;
  }

  ContentsManager? findContentsManagerByMid(String frameModelMid) {
    //print(
    //    'findContentsManagerByMid(${pageModel.mid}, $frameModelMid*******${contentsManagerMap.length}');

    return contentsManagerMap[frameModelMid];
  }

  ContentsManager findOrCreateContentsManager(FrameModel frameModel) {
    //print('findOrCreateContentsManager');
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
        //print('contentsManager not found !!! new ContentsManager created');
        retval = newContentsManager(frameModel);
        retval.clearAll();
      }
    }

    return retval!;
  }

  ContentsManager? findContentsManager(FrameModel frameModel) {
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
          return retval;
        }
      } else {
        logger.severe(
            'something wrong !!!! anotherFrameManager is not founded ${frameModel.parentMid.value}');
        return retval;
      }
    }

    return findContentsManagerByMid(frameModel.mid);
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
      {bool invalidate = true,
      bool initPosition = true,
      bool undo = false,
      bool isFixedRatio = false}) async {
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
    //logger.fine('resizeFrame()===============================');
    //logger.fine(
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

    frameModel.width.set(pageWidth > contentsWidth ? contentsWidth.roundToDouble() : pageWidth,
        save: false, noUndo: !undo, dontRealTime: true);
    frameModel.height.set(pageHeight > contentsHeight ? contentsHeight.roundToDouble() : pageHeight,
        save: false, noUndo: !undo, dontRealTime: true);

    if (isFixedRatio == true) {
      frameModel.isFixedRatio.set(true, save: false, noUndo: !undo, dontRealTime: true);
    }

    logger.fine(
        'resizeFrame($ratio, $invalidate) w=$contentsWidth, h=$contentsHeight, dx=$dx, dy=$dy --------------------');
    await setToDB(frameModel, dontRealTime: true);

    if (invalidate) {
      notify();
    }
  }

  Future<void> resizeFrame2(FrameModel frameModel, {bool invalidate = true}) async {
    ContentsModel? contentsModel = getCurrentModel(frameModel.mid);
    if (contentsModel == null) {
      return;
    }
    logger.fine('resizeFrame2 ${contentsModel.name}');
    await resizeFrame(frameModel, contentsModel.aspectRatio.value, contentsModel.width.value,
        contentsModel.height.value,
        invalidate: invalidate, initPosition: false, undo: true);
  }

  Future<void> setSoundOff() async {
    for (var manager in contentsManagerMap.values) {
      logger.fine('frameManager.setSoundOff()********');
      await manager.setSoundOff();
    }
  }

  Future<void> resumeSound() async {
    for (var manager in contentsManagerMap.values) {
      logger.fine('frameManager.resumeSound()********');
      await manager.resumeSound();
    }
  }

  Future<void> pause() async {
    for (var manager in contentsManagerMap.values) {
      logger.fine('frameManager.pause()********');
      await manager.pause();
    }
  }

  Future<void> resume() async {
    for (var manager in contentsManagerMap.values) {
      logger.fine('frameManager.resume()********');
      await manager.resume();
    }
  }

  @override
  Future<void> removeChild(String parentMid) async {
    ContentsManager? contentsManager = getContentsManager(parentMid);
    await contentsManager?.removeAll();
    //removeLink(parentMid); // 이 Frame 에 연결된 link 를 모두 지운다. // removeAll 에서 하고 있다.
  }

  void removeLink(String mid) {
    logger.fine('removeLink---------------FrameManager');
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
      ContentsManager contentsManager = findOrCreateContentsManager(frameModel);
      // if (contentsManager == null) {
      //   logger.fine('new ContentsManager created (${frameModel.mid})');
      //   contentsManager = newContentsManager(frameModel);
      //   contentsManager.clearAll();
      // } else {
      //   logger.fine('old ContentsManager used (${frameModel.mid})');
      // }
      await contentsManager.initContentsManager(frameModel.mid);
    }
    // for (var mid in contentsManagerMap.keys.toList()) {
    //   ContentsManager contentsManager = contentsManagerMap[mid]!;
    //   await _initContentsManager(mid, contentsManager);
    // }
  }

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    oldNewMap.clear();
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      if (ele is FrameModel) {
        if (ele.isOverlay.value == true && ele.parentMid.value != pageModel.mid) {
          // parentMid(page)가 다른 page에서 overlay-frame은 복사하지 않는다
          continue;
        }
      }
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      oldNewMap[ele as FrameModel] = newOne as FrameModel;
      if (ele.mid == bookModel.backgroundMusicFrame.value) {
        // 백그라운드 뮤직을 복사히기 위해, 임시로 넣어둔다.
        BookManager.newbBackgroundMusicFrame = newOne.mid;
      }
    }
    for (var entry in oldNewMap.entries) {
      ContentsManager contentsManager = findOrCreateContentsManager(entry.key);
      await contentsManager.copyBook(newBookMid, entry.value.mid);
      counter++;
    }
    oldNewMap.clear();
    unlock();
    return counter;
  }

  FrameModel? findFrameByPos(Offset pos) {
    FrameModel? retval;
    reverseMapIterator((model) {
      FrameModel frame = model as FrameModel;
      // GlobalKey? stickerKey = _stickerKeyMap['${pageModel.mid}/${frame.mid}'];
      // if (stickerKey == null) {
      //   return null;
      // }
      // bool founded = CretaCommonUtils.isMousePointerOnWidget(stickerKey, pos);
      String keyString = stickerKeyMangler(pageModel.mid, frame.mid);
      bool founded = stickerKeyHandler.isMousePointerOnWidget(keyString, pos);
      if (founded) {
        logger.fine('pointer is on widget order ${frame.order.value}');
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
    // isAutoPlay = false 이면 자동으로 넘어가지 않는다.
    if (StudioVariables.isAutoPlay == false) {
      return;
    }
    // 프리뷰 모드에서만 자동으로 넘어간다.
    if (StudioVariables.isPreview == false) {
      return;
    }
    // stopPagin 이면 다음 페이지로 넘어가지 않는다.
    if (StudioVariables.stopPaging == true) {
      return;
    }

    // ignore: unused_local_variable
    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book != null && book.isAutoPlay.value == false) {
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
    //BookMainPage.pageManagerHolder?.printSelectedMid(4);
    BookMainPage.pageManagerHolder?.gotoNext();
  }

  // bool isVisible(FrameModel model) {
  //   if (model.isRemoved.value == true) return false;
  //   if (model.isShow.value == false) return false;
  //   if (BookMainPage.filterManagerHolder!.isVisible(model) == false) return false;
  //   return true;
  // }

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
      ContentsManager contentsManager = findOrCreateContentsManager(model);
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
    if (CretaManager.frameSelectNotifier == null) return false;
    if (CretaManager.frameSelectNotifier!.selectedAssetId == null) return false;
    // GlobalKey? key =
    //     findStickerKey(pageModel.mid, CretaManager.frameSelectNotifier!.selectedAssetId!);
    // if (key == null) {
    //   //print(' key is null , ${CretaManager.frameSelectNotifier!.selectedAssetId}');
    //   return false;
    // }
    //return CretaCommonUtils.isMousePointerOnWidget(key, position);
    String keyString =
        stickerKeyMangler(pageModel.mid, CretaManager.frameSelectNotifier!.selectedAssetId!);
    return stickerKeyHandler.isMousePointerOnWidget(keyString, position);
  }

  ContentsModel? getFirstContents(String frameMid) {
    FrameModel? frameModel = getModel(frameMid) as FrameModel?;
    if (frameModel == null) {
      return null;
    }
    ContentsManager? contentsManager = getContentsManager(frameMid);
    if (contentsManager == null) {
      logger.severe('get contents manager failed($frameMid)');
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
      return min - CretaConst.orderVar;
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
    logger.fine('Frame $hint :   ${aModel.order.value} <--> ${bModel.order.value}');

    double aOrder = aModel.order.value;
    double bOrder = bModel.order.value;

    mychangeStack.startTrans();
    aModel.order.set(bOrder);
    bModel.order.set(aOrder);
    mychangeStack.endTrans();
  }

  String toJson() {
    if (getAvailLength() == 0) {
      return ',\n\t\t"frames" : []\n';
    }
    int frameCount = 0;
    String jsonStr = '';
    jsonStr += ',\n\t\t"frames" : [\n';
    orderMapIterator((val) {
      FrameModel frame = val as FrameModel;
      String frameStr = frame.toJson(tab: '\t\t');
      if (frameCount > 0) {
        jsonStr += ',\n';
      }
      ContentsManager? contentsManager = findOrCreateContentsManager(frame);
      frameStr += contentsManager.toJson();
      jsonStr += '\t\t{\n$frameStr\n\t\t}';
      frameCount++;
      return null;
    });
    jsonStr += '\n\t\t]\n';
    return jsonStr;
  }

  Future<bool> removeSelected(BuildContext context) async {
    FrameModel? model = getSelected() as FrameModel?;
    if (model == null) {
      showSnackBar(context, CretaLang['frameNotSelected']!, duration: StudioConst.snackBarDuration);
      await Future.delayed(StudioConst.snackBarDuration);
      return false;
    }

    mychangeStack.startTrans();
    model.isRemoved.set(true);
    await removeChild(model.mid);
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Page, doNoti: true);
    BookMainPage.pageManagerHolder!.notify();
    mychangeStack.endTrans();
    return true;
  }

  Future<bool> makeClone(
    BookModel newBook, {
    bool cloneToPublishedBook = false,
  }) async {
    for (var frame in modelList) {
      String parentPageMid = BookManager.clonePageIdMap[frame.parentMid.value] ?? '';
      logger.info('find: (${frame.parentMid.value}) => ($parentPageMid)');
      AbsExModel newModel = await makeCopy(newBook.mid, frame, parentPageMid);
      if (newBook.backgroundMusicFrame.value == frame.mid) {
        newBook.backgroundMusicFrame.set(newModel.mid, save: false);
      }
      logger.info('clone is created ($collectionId.${newModel.mid}) from (source:${frame.mid})');
      BookManager.cloneFrameIdMap[frame.mid] = newModel.mid;
      logger.info('frame: (${frame.mid}) => (${newModel.mid})');
    }
    final BookModel dummyBook = BookModel('');
    final PageModel dummyPage = PageModel('', dummyBook);
    final FrameModel dummyFrame = FrameModel('', '');
    final ContentsManager copyContentsManagerHolder = cloneToPublishedBook
        ? ContentsManager(
            pageModel: dummyPage, frameModel: dummyFrame, tableName: 'creta_contents_published')
        : ContentsManager(pageModel: dummyPage, frameModel: dummyFrame);
    //contentsManagerMap.forEach((key, value) { }); ==> forEach는 await 처리가 불가능
    for (MapEntry entry in contentsManagerMap.entries) {
      copyContentsManagerHolder.modelList = [...entry.value.modelList];
      copyContentsManagerHolder.linkManagerMap = Map.from(entry.value.linkManagerMap);
      await copyContentsManagerHolder.makeClone(newBook,
          cloneToPublishedBook: cloneToPublishedBook);
    }
    return true;
  }

  void changeOrderByIsShow(FrameModel model) {
    if (model.isShow.value == false) {
      double minOrder = getMinOrder();
      if (minOrder == model.order.value) {
        return;
      }
      if (minOrder > 2) {
        minOrder = minOrder - 1;
      } else {
        minOrder = minOrder / 2;
      }
      //print('$minOrder #########################################');
      model.prevOrder = model.order.value;
      //order.set(prevOrder < 0 ? frameManager.getMinOrder() : prevOrder, save: false, noUndo: true);
      model.order.set(minOrder, save: false, noUndo: true);
      return;
    }
    model.prevOrder = model.order.value;
    model.order.set(getMaxOrder() + 1, save: false, noUndo: true);
  }

  Future<void> updateParent(String templateMid, PageModel page, String bookMid) async {
    //print('updateParent($templateMid)');
    await _getFrames(parentMid: templateMid);
    //print('modelList.length(${modelList.length})');

    for (var ele in modelList) {
      //print('frame = ${ele.mid}');
      FrameModel model = ele as FrameModel;
      FrameModel newModel = FrameModel('', bookMid);
      newModel.copyFrom(model, newMid: newModel.mid, pMid: page.mid);
      await createToDB(newModel);

      ContentsManager contentsManager = ContentsManager(pageModel: page, frameModel: model);
      await contentsManager.updateParent(newModel, page, bookMid);
    }
  }

  void afterCreateFrame(FrameModel model, {FrameEventController? sendEvent}) {
    setSelectedMid(model.mid, doNotify: true);
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
    CretaManager.frameSelectNotifier?.set(model.mid);

    sendEvent?.sendEvent(model);
    BookMainPage.pageManagerHolder!.invalidateThumbnail(pageModel.mid);
    //Future.delayed(const Duration(milliseconds: 200), () {
    //print('miniMenu show');
    BookMainPage.miniMenuNotifier?.set(true, doNoti: true);
  }

  Future<void> createTextAndFrame(BuildContext context,
      {Offset pos = Offset.zero, Size? size}) async {
    //print('0------------------------------------------');

    late TextStyle style;
    ExtraTextStyle? extraStyle;
    // ignore: use_build_context_synchronously
    (style, extraStyle) = ExtraTextStyle.getLastTextStyle(context);

    if (size == null) {
      double height = (style.fontSize! / StudioVariables.applyScale) +
          (StudioConst.defaultTextPadding * 2); // 모델상의 크기다. 실제 크기가 아니다.
      double width = height * 7;
      size = Size(width, height);
    }
    //Offset pos = CretaCommonUtils.positionInPage(details /*.localPosition*/, null);
    // 커서의 크기가 있어서, 조금 빼주어야 텍스트 박스가 커서 위치에 맞게 나온다.
    double posOffset = LayoutConst.topMenuCursorSize / StudioVariables.applyScale;
    pos = Offset((pos.dx - posOffset > 0 ? pos.dx - posOffset : 0),
        (pos.dy - posOffset > 0 ? pos.dy - posOffset : 0));

    mychangeStack.startTrans();
    //print('1------pos($pos), size($size)------------------------------------');
    FrameModel frameModel = await createNextFrame(
      pos: pos,
      size: size,
      bgColor1: Colors.transparent,
      type: FrameType.text,
    );
    //print('2------------------------------------------');

    afterCreateFrame(frameModel);
    //print('3------------------------------------------');

    ContentsModel model = ContentsModel.text(
        frameModel.mid, frameModel.realTimeKey, CretaStudioLang['defaultText'] ?? 'Text',
        remoteUrlVal: 'Sample Text',
        applyScale: StudioVariables.applyScale,
        style: style,
        playTimeVal: -1,
        autoSizeTypeVal: AutoSizeType.noAutoSize);
    extraStyle?.setExtraTextStyle(model);
    //print('4------------------------------------------');

    // print(
    //     'before createContents : frameModel.mid=${frameModel.mid}, ContentsModel.mid=${model.mid}, fontSize=${style.fontSize}');

    ContentsManager.createContents(this, [model], frameModel, pageModel);
    mychangeStack.endTrans();

    MiniMenu.setShowFrame(false); //  프레임이 아닌 콘텐츠가 선택되도록 하기 위해.
  }
}
