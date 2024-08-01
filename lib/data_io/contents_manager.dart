// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:creta_studio_io/data_io/base_contents_manager.dart';
import 'package:flutter/material.dart';
import '../design_system/component/tree/flutter_treeview.dart' as tree;
import 'package:get/get.dart';
import 'package:hycop/hycop.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/left_menu/depot/depot_display.dart';
import '../pages/studio/left_menu/left_menu_page.dart';
import '../pages/studio/left_menu/music/music_player_frame.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_getx_controller.dart';
import '../pages/studio/studio_snippet.dart';
import '../pages/studio/studio_variables.dart';
import '../player/creta_abs_player.dart';
import '../player/creta_play_timer.dart';
import '../player/video/creta_video_player.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
//import 'depot_manager.dart';
import 'depot_manager.dart';
import 'book_manager.dart';
import 'frame_manager.dart';
import 'key_handler.dart';
import 'link_manager.dart';

class ContentsManager extends BaseContentsManager {
  // final PageModel pageModel;
  // final FrameModel frameModel;
  // final bool isPublishedMode;

  // for text widget only start

  KeyHandler textKeyHandler = KeyHandler();
  KeyHandler imageKeyHandler = KeyHandler();
  KeyHandler videoKeyHandler = KeyHandler();
  KeyHandler docKeyHandler = KeyHandler();
  KeyHandler musicKeyHandler = KeyHandler();
  KeyHandler pdfKeyHandler = KeyHandler();
  KeyHandler defaultKeyHandler = KeyHandler();

  GlobalObjectKey<CretaState<StatefulWidget>> registerPlayerWidgetKey(
      String keyString, ContentsType cType) {
    switch (cType) {
      case ContentsType.video:
        return videoKeyHandler.registerKey(keyString);
      case ContentsType.image:
        return imageKeyHandler.registerKey(keyString);
      case ContentsType.text:
        return textKeyHandler.registerKey(keyString);
      case ContentsType.document:
        return docKeyHandler.registerKey(keyString);
      case ContentsType.music:
        return musicKeyHandler.registerKey(keyString);
      case ContentsType.pdf:
        return pdfKeyHandler.registerKey(keyString);

      default:
        return defaultKeyHandler.registerKey(keyString);
    }
  }

  bool invalidatePlayerWidget(ContentsModel model) {
    switch (model.contentsType) {
      case ContentsType.video:
        return videoKeyHandler.invalidate(keyMangler(model));
      case ContentsType.image:
        return imageKeyHandler.invalidate(keyMangler(model));
      case ContentsType.text:
        return textKeyHandler.invalidate(keyMangler(model));
      case ContentsType.document:
        return docKeyHandler.invalidate(keyMangler(model));
      case ContentsType.music:
        return musicKeyHandler.invalidate(keyMangler(model));
      case ContentsType.pdf:
        return pdfKeyHandler.invalidate(keyMangler(model));
      default:
        return defaultKeyHandler.invalidate(keyMangler(model));
    }
  }

  KeyHandler contentsThumbKeyHandler = KeyHandler();
  String contentsThumbKeyMangler(String pageMid, String frameMid) {
    return 'ContentsThumbnail$pageMid/$frameMid';
  }

  GlobalObjectKey<CretaState<StatefulWidget>> registerContentsThumbKey(
      String pageMid, String frameMid) {
    return contentsThumbKeyHandler.registerKey(contentsThumbKeyMangler(pageMid, frameMid));
  }

  bool invalidateContentsThumb(String pageMid, String frameMid) {
    return contentsThumbKeyHandler.invalidate(contentsThumbKeyMangler(pageMid, frameMid));
  }

  // bool invalidateText(ContentsModel model) {
  //   GlobalObjectKey<State<StatefulWidget>>? key = findKeyText(model);
  //   if (key != null) {
  //     key.currentState!.invalidate();
  //     return true;
  //   }
  //   logger.severe('TextPlayerWidget key not found ${model.mid}');
  //   return false;
  // }
  // for text widget only end

  ContentsEventController? sendEvent;

  static ContentsManager? _dummyManager;
  static ContentsManager? get dummyManager {
    if (_dummyManager != null) return _dummyManager;

    BookModel? book = BookMainPage.bookManagerHolder!.onlyOne() as BookModel?;
    if (book != null) {
      _dummyManager =
          ContentsManager(pageModel: PageModel('', book), frameModel: FrameModel('', book.mid));
    }
    return _dummyManager;
  }

  ContentsManager({
    required super.pageModel,
    required super.frameModel,
    String tableName = 'creta_contents',
    super.isPublishedMode = false,
  }) : super(tableName: tableName) {
    //saveManagerHolder?.registerManager('contents', this, postfix: frameModel.mid);
    final ContentsEventController sendEventVar = Get.find(tag: 'contents-property-to-main');
    sendEvent = sendEventVar;
  }

  @override
  AbsExModel newModel(String mid) => ContentsModel(mid, frameModel.realTimeKey);

  @override
  CretaModel cloneModel(CretaModel src) {
    ContentsModel retval = newModel(src.mid) as ContentsModel;
    src.copyTo(retval);
    return retval;
  }

  @override
  Future<int> copyBook(String newBookMid, String? newParentMid) async {
    // 이미, publish 되어 있다면, 해당 mid 를 가져와야 한다.
    lock();
    int counter = 0;
    for (var ele in modelList) {
      if (ele.isRemoved.value == true) {
        continue;
      }
      AbsExModel newOne = await makeCopy(newBookMid, ele, newParentMid);
      LinkManager? linkManager = findLinkManager(ele.mid, createIfNotExist: false);
      await linkManager?.copyBook(newBookMid, newOne.mid);
      counter++;
    }
    unlock();
    return counter;
  }

  bool _onceDBGetComplete = false;
  bool get onceDBGetComplete => _onceDBGetComplete;
  final Map<String, CretaAbsPlayer> _playerMap = {};
  CretaAbsPlayer? getPlayer(String key) => _playerMap[key];
  void setPlayer(String key, CretaAbsPlayer player) => _playerMap[key] = player;
  Map<String, LinkManager> linkManagerMap = {};

  bool iamBusy = false;
  FrameManager? _frameManager;
  void setFrameManager(FrameManager? manager) => _frameManager = manager;
  bool _isVideoResize = false;
  void setIsVideoResize(bool value) => _isVideoResize = value;

  CretaPlayTimer? playTimer;
  void setPlayerHandler(CretaPlayTimer p) {
    playTimer = p;
  }

  String keyMangler(ContentsModel contents) {
    return 'contents-${pageModel.mid}-${frameModel.mid}-${contents.mid}';
  }

  bool hasContents() {
    return (getAvailLength() > 0);
  }

  Future<void> initContentsManager(String frameMid) async {
    if (onceDBGetComplete == false) {
      await getContents();
      addRealTimeListen(frameMid);
      reOrdering();
    }
    logger.fine('$frameMid=initChildren(${getAvailLength()})');
  }

  ContentsModel? getCurrentModel() {
    if (playTimer == null) {
      return null;
    }
    return playTimer?.getCurrentModel();
  }

  void clearCurrentModel() {
    selectedMid = '';
    playTimer?.clearCurrentModel();
  }

  Future<ContentsModel> createNextContents(ContentsModel model, {bool doNotify = true}) async {
    model.order.set(getMaxModelOrder() + 1, save: false, noUndo: true);
    await _createNextContents(model, doNotify);

    MyChange<ContentsModel> c = MyChange<ContentsModel>(
      model,
      execute: () async {
        //await _createNextContents(model, doNotify);
      },
      redo: () async {
        await _redoCreateNextContents(model, doNotify);
      },
      undo: (ContentsModel old) async {
        await _undoCreateNextContents(old, doNotify);
      },
    );
    mychangeStack.add(c);

    return model;
  }

  Future<ContentsModel> _createNextContents(ContentsModel model, bool doNotify) async {
    await createToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);

    if (playTimer != null) {
      if (playTimer!.isInit()) {
        //logger.fine('prev exist =============================================');
        await playTimer?.rewind();
        await playTimer?.pause();
      }
      await playTimer?.reOrdering(isRewind: true);
    } else {
      reOrdering();
    }
    logger.fine('_createNextContents complete ${model.name},${model.order.value},${model.url}');
    return model;
  }

  Future<ContentsModel> _redoCreateNextContents(ContentsModel model, bool doNotify) async {
    model.isRemoved.set(false, noUndo: true, save: false);
    await setToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);

    if (playTimer != null) {
      if (playTimer!.isInit()) {
        //logger.fine('prev exist =============================================');
        await playTimer?.rewind();
        await playTimer?.pause();
      }
      await playTimer?.reOrdering(isRewind: true);
    } else {
      reOrdering();
    }
    logger.fine('_redoCreateNextContents complete ${model.name},${model.order.value},${model.url}');
    return model;
  }

  Future<ContentsModel> _undoCreateNextContents(ContentsModel model, bool doNotify) async {
    model.isRemoved.set(true, noUndo: true, save: false);
    remove(model);
    if (doNotify) {
      notify();
    }

    if (playTimer != null) {
      if (playTimer!.isInit()) {
        //logger.fine('prev exist =============================================');
        await playTimer?.rewind();
        await playTimer?.pause();
      }
      await playTimer?.reOrdering(isRewind: true);
    } else {
      reOrdering();
    }
    logger.fine('_undoCreateNextContents complete ${model.name},${model.order.value},${model.url}');
    await setToDB(model);
    return model;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> getContents() async {
    int contentsCount = 0;
    startTransaction();
    try {
      contentsCount = await _getContents();
      await _getAllLinks();
      _onceDBGetComplete = true;
    } catch (e) {
      logger.finest('something wrong $e');
    }
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

  (String, String, BoxFit, bool, double, double) getThumbnail() {
    for (var value in valueList()) {
      ContentsModel model = value as ContentsModel;
      if (isVisible(model) == false) {
        continue;
      }
      if (model.isRemoved.value == true) {
        continue;
      }
      if (model.thumbnailUrl == null || model.thumbnailUrl!.isEmpty) {
        if (model.isImage()) {
          if (model.remoteUrl != null && model.remoteUrl!.isNotEmpty) {
            return (
              model.name,
              model.remoteUrl!,
              model.fit.value.toBoxFit(),
              model.isFlip.value,
              model.angle.value,
              model.opacity.value,
            );
          }
          if (model.url.isNotEmpty) {
            return (
              model.name,
              model.url,
              model.fit.value.toBoxFit(),
              model.isFlip.value,
              model.angle.value,
              model.opacity.value,
            );
          }
        }
        continue;
      }
      return (
        model.name,
        model.thumbnailUrl!,
        model.fit.value.toBoxFit(),
        model.isFlip.value,
        model.angle.value,
        model.opacity.value,
      );
    }
    return ('', '', BoxFit.cover, false, 0.0, 1.0);

    // List<String?> list = valueList().map((value) {
    //   ContentsModel model = value as ContentsModel;
    //   if (isVisible(model) == false) {
    //     return null;
    //   }
    //   print('${model.name}, ${model.thumbnailUrl}');
    //   if (model.thumbnailUrl == null || model.thumbnailUrl!.isEmpty) {
    //     if (model.isImage()) {
    //       if (model.remoteUrl != null && model.remoteUrl!.isNotEmpty) {
    //         return model.remoteUrl!;
    //       }
    //       if (model.url.isNotEmpty) {
    //         return model.url;
    //       }
    //     }
    //     return null;
    //   }
    //   return model.thumbnailUrl!;
    // }).toList();
    // for (String? ele in list) {
    //   if (ele != null) {
    //     return ele;
    //   }
    // }

    // for (var ele in modelList) {
    //   ContentsModel model = ele as ContentsModel;
    //   if (model.isRemoved.value == true) {
    //     continue;
    //   }
    //   if (model.thumbnailUrl == null || model.thumbnailUrl!.isEmpty) {
    //     continue;
    //   }
    //   return model.thumbnailUrl;
    // }

    // return null;
  }

  ContentsModel? getFirstModel() {
    for (var ele in modelList) {
      ContentsModel model = ele as ContentsModel;
      if (isVisible(model) == false) {
        continue;
      }
      return model;
    }
    // 여기까지 오면 없다는 뜻이다.  isShow 라도 리턴해본다.
    logger.warning('getFirstModel failed no model founded');
    for (var ele in modelList) {
      ContentsModel model = ele as ContentsModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      return model;
    }
    return null;
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
    if (_isVideoResize) {
      await _frameManager?.resizeFrame(
        frameModel,
        aspectRatio,
        size.width,
        size.height,
        invalidate: invalidate,
        isFixedRatio: true,
      );
    }
    // onDropPage 에서 동영상을 넣었을때, 딱 한번만 resizeFrame 하게 하기 위해,
    // _isVideoResize 를 false 로 만들어준다.
    _isVideoResize = false;
  }

  Size getRealSize({double? applyScale}) {
    applyScale ??= StudioVariables.applyScale;
    double width = applyScale * (frameModel.width.value); // - frameModel.shadowSpread.value);
    double height = applyScale * (frameModel.height.value); // - frameModel.shadowSpread.value);
    return Size(width, height);
  }

  Future<bool> removeSelected(BuildContext context) async {
    iamBusy = true;
    ContentsModel? model = getSelected() as ContentsModel?;
    if (model == null) {
      showSnackBar(context, CretaLang['contentsNotSeleted']!,
          duration: StudioConst.snackBarDuration);
      await Future.delayed(StudioConst.snackBarDuration);
      iamBusy = false;
      return false;
    }

    if (playTimer != null && playTimer!.isInit()) {
      await _removeContents(context, model);
      iamBusy = false;
      return true;
    }
    showSnackBar(context, CretaLang['contentsNotDeleted']!, duration: StudioConst.snackBarDuration);
    await Future.delayed(StudioConst.snackBarDuration);
    iamBusy = false;
    return false;
  }

  Future<bool> removeContents(BuildContext context, ContentsModel model) async {
    if (iamBusy) return false;
    iamBusy = true;
    await _removeContents(context, model);
    iamBusy = false;
    return true;
  }

  Future<void> _removeContents(BuildContext context, ContentsModel model) async {
    //await pause();
    //print('_removeContents(${model.name})');
    model.isRemoved.set(
      true,
      save: true,
      doComplete: (val) {
        remove(model);
        playTimer?.reOrdering();
      },
      undoComplete: (val) {
        insert(model);
        playTimer?.reOrdering();
      },
    );
    //await setToDB(model);
    //remove(model);
    //print('remove contents ${model.name}, ${model.mid}');
    await playTimer?.reOrdering();

    if (getAvailLength() == 0) {
      //print('getVisibleLength is 0');
      BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
      BookMainPage.containeeNotifier!.notify();
      _frameManager?.notify();
    } else {
      BookMainPage.containeeNotifier!.notify();
      LeftMenuPage.treeInvalidate();
      _frameManager?.notify();
      //print('getVisibleLength is not 0');
    }
    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();
    removeChild(model.mid);

    return;
  }

  @override
  Future<void> removeChild(String parentMid) async {
    LinkManager? retval = linkManagerMap[parentMid];
    if (retval != null) {
      retval.removeAll();
    }
  }

  @override
  Future<void> removeAll() async {
    playTimer?.stop();
    if (BookMainPage.backGroundMusic != null) {
      FrameManager.stopBackgroundMusic(BookMainPage.backGroundMusic!);
    }
    super.removeAll();
  }

  void removeLink(String frameOrPageMid) {
    logger.fine('removeLink---------------ContentsManager   ${linkManagerMap.length}');
    for (var linkManager in linkManagerMap.values) {
      linkManager.removeLink(frameOrPageMid);
    }
  }

  Future<void> setSoundOff({String mid = ''}) async {
    String frameId = frameModel.mid;
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null) {
          if (mid.isEmpty) {
            logger.fine('contents.setSoundOff()********');
            await video.wcontroller!.setVolume(0.0);
          } else {
            if (mid == player.model!.mid) {
              logger.fine('contents.setSoundOff($mid)********');
              await video.wcontroller!.setVolume(0.0);
            }
          }
        }
      }
      if (player.model != null && player.model!.isMusic()) {
        logger.info('setMusicSoundOff ${player.model!.name}');
        GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
        if (musicKey != null) {
          musicKey.currentState?.mutedMusic(player.model!);
        } else {
          logger.severe('musicKey is null');
        }
      }
    }
  }

  Future<void> resumeSound({String mid = ''}) async {
    String frameId = frameModel.mid;
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null && player.model!.mute.value == false) {
          if (mid.isEmpty) {
            logger.fine('contents.setSoundOff()********');
            await video.wcontroller!.setVolume(video.model!.volume.value);
          } else {
            if (mid == player.model!.mid) {
              logger.fine('contents.setSoundOff($mid)********');
              await video.wcontroller!.setVolume(video.model!.volume.value);
            }
          }
        }
      }
      if (player.model != null && player.model!.isMusic()) {
        logger.info('resumeMusicSound ${player.model!.name}');
        GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
        if (musicKey != null) {
          musicKey.currentState?.resumedMusic(player.model!);
        } else {
          logger.severe('musicKey is null');
        }
      }
    }
  }

  Future<void> pause() async {
    String frameId = frameModel.mid;
    for (var player in _playerMap.values) {
      if (player.model == null) {
        continue;
      }
      if (player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null &&
            video.isInit() &&
            playTimer != null &&
            playTimer!.isCurrentModel(player.model!.mid)) {
          await video.wcontroller!.pause();
          logger.fine('contents.pause end');
        }
      }
      if (player.model!.isImage() || player.model!.aniType.value != TextAniType.none) {
        //notify();  notify 는 전체에 이벤트가 가므로 지정된 놈만 이벤트가 가기 위해, invalidate 로 바꿈
        invalidatePlayerWidget(player.model!);
      }
      if (player.model!.isMusic()) {
        logger.info('--------------pauseMusic ${player.model!.name}');
        GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
        if (musicKey != null) {
          musicKey.currentState?.pausedMusic(player.model!);
        } else {
          logger.severe('musicKey is null');
        }
      }
    }
  }

  Future<void> resume() async {
    String frameId = frameModel.mid;
    for (var player in _playerMap.values) {
      if (player.model == null) {
        continue;
      }
      if (player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null &&
            video.isInit() &&
            playTimer != null &&
            playTimer!.isCurrentModel(player.model!.mid)) {
          logger.fine('contents.resume');
          await video.wcontroller!.play();
        }
      }
      if (player.model!.isImage() || player.model!.aniType.value != TextAniType.none) {
        notify();
      }
      if (player.model!.isMusic()) {
        GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
        if (musicKey != null) {
          musicKey.currentState?.playedMusic(player.model!);
        } else {
          logger.severe('musicKey is null');
        }
      }
      if (player.model!.isText()) {
        invalidatePlayerWidget(player.model!);
      }
    }
  }

  Future<void> goto(double order) async {
    pause();
    await playTimer?.setCurrentOrder(order);
  }

  Future<void> gotoNext() async {
    await playTimer?.next();
  }

  Future<void> gotoPrev() async {
    await playTimer?.prev();
  }

  List<CretaModel> valueList() {
    return orderValues().toList().reversed.toList();
  }

  List<double> keyList() {
    return orderKeys().toList().reversed.toList();
  }

  bool isVisible(ContentsModel model) {
    if (model.isRemoved.value == true) return false;
    if (model.isShow.value == false) return false;
    if (BookMainPage.filterManagerHolder!.isVisible(model) == false) return false;
    return true;
  }

  int getShowLength() {
    int counter = 0;
    orderMapIterator((val) {
      ContentsModel model = val as ContentsModel;
      if (isVisible(model) == true) {
        counter++;
      }
    });
    return counter;
  }

  @override
  double lastOrder() {
    if (isNotEmpty()) {
      double lastOrder = orderKeys().last;
      ContentsModel? model = getNthOrder(lastOrder) as ContentsModel?;
      if (isVisible(model!) == true) {
        return lastOrder;
      }
      return nextOrder(lastOrder);
    }
    return -1;
  }

  double getMaxModelOrder() {
    double retval = 0;
    for (var model in modelList) {
      if (model.order.value > retval) {
        retval = model.order.value;
      }
    }
    return retval;
  }

  double nextOrder(double currentOrder, {bool alwaysOneExist = false}) {
    int counter = 0;
    int len = getAvailLength();
    double input = currentOrder;
    //logger.fine('nextOrder currentOrder=$input, $len');
    while (counter < len) {
      double order = _nextOrder(input);
      if (order < 0) {
        logger.warning('no avail order 1');
        return order;
      }
      ContentsModel? model = getNthOrder(order) as ContentsModel?;
      if (isVisible(model!) == true) {
        //logger.fine('return Order=$order');
        return order;
      }
      counter++;
      input = order;
    }
    //logger.warning('no avail order $currentOrder');
    // if (getShowLength() == 0 && alwaysOneExist) {
    //   return currentOrder;
    // }
    return -1;
  }

  double _nextOrder(double currentOrder) {
    bool matched = false;

    Iterable<double> keys = orderKeys().toList().reversed;

    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      // 끝까지 온것이다.  처음으로 돌아간다.
      return keys.first;
    }
    return -1;
  }

  double nextOrderNoLoop(double currentOrder) {
    bool matched = false;

    Iterable<double> keys = orderKeys().toList().reversed;

    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    return -1;
  }

  double prevOrder(double currentOrder) {
    int counter = 0;
    int len = getAvailLength();
    double input = currentOrder;
    //logger.fine('prevOrder currentOrder=$input, $len');
    while (counter < len) {
      double order = _prevOrder(input);
      if (order < 0) {
        //logger.warning('no avail order 1');
        return order;
      }
      ContentsModel? model = getNthOrder(order) as ContentsModel?;
      if (isVisible(model!) == true) {
        //logger.fine('return Order=$order');
        return order;
      }
      counter++;
      input = order;
    }
    //logger.warning('no avail order 2');
    return -1;
  }

  double _prevOrder(double currentOrder) {
    bool matched = false;
    late Iterable<double> keys = orderKeys();
    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }
    if (matched == true) {
      return keys.first;
    }
    return -1;
  }

  double prevOrderNoLoop(double currentOrder) {
    bool matched = false;
    late Iterable<double> keys = orderKeys();

    for (double ele in keys) {
      if (matched == true) {
        return ele;
      }
      if (ele == currentOrder) {
        matched = true;
        continue;
      }
    }

    return -1;
  }

  // Future<void> pause() async {
  //   await playTimer?.pause();
  // }

  // Future<void> globalPause() async {
  //   await playTimer?.globalPause();
  // }

  // Future<void> globalResume() async {
  //   await playTimer?.globalResume();
  // }

  void setLooping(bool loop) {
    playTimer?.setLooping(loop);
  }

  void setLoopingAll(bool loop) {
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null) {
          video.wcontroller?.setLooping(loop);
        }
      }
    }
  }

  void pushReverseOrder(
    String aMovedMid,
    String aPushedMid,
    String hint, {
    required Function? onComplete,
  }) {
    CretaModel? aMoved = getModel(aMovedMid) as CretaModel?;
    CretaModel? aPushed = getModel(aPushedMid) as CretaModel?;
    if (aMoved == null) {
      logger.warning('$aMovedMid does not exist in modelList');
      return;
    }
    if (aPushed == null) {
      logger.warning('$aPushedMid does not exist in modelList');
      return;
    }
    logger.fine('Frame $hint :   ${aMoved.order.value} <--> ${aPushed.order.value}');

    double aMovedOrder = aMoved.order.value;
    double aPushedOrder = aPushed.order.value;

    // 콘텐츠의 경우 역순이라는 점에 유의하라.

    late double aNewOrder;
    if (aMovedOrder > aPushedOrder) {
      // 내려온 것이다.
      // moved 가 pushed 자리로 들어간 것이므로,
      // moved 가  pushed 의 order 를 자치하고,
      // pushed 는 무조건 moved 보다 위로 올라가게 된다.
      // 이때,pushed 는 원래 원래 pushed 이전 것의 중간값을 가지고,
      // 이전것이 없을 경우,movedOrder 값을 진다.
      double prevValue = prevOrderNoLoop(aPushedOrder);
      if (prevValue == aMovedOrder || prevValue < 0) {
        aNewOrder = aMovedOrder;
      } else {
        // 이전 order 가 있다.
        aNewOrder = (prevValue + aPushedOrder) / 2.0;
      }
    } else {
      // 올라간 것이다.
      // moved 가 pushed 자리로 들어간 것이므로,
      // moved 가  pushed 의 order 를 자치하고,
      // pushed 는 무조건 moved 보다 밀려나게 된다.
      // 이때,pushed 는 원래 pushed 다음 것의 중간값을 가지고,
      // 다음것이 없을 경우, pushed 는 원래 자기 값의 절반으로 줄어든다.

      double nextValue = nextOrderNoLoop(aPushedOrder);
      if (nextValue == aMovedOrder || nextValue < 0) {
        aNewOrder = aMovedOrder;
      } else {
        // 다음 order 가 있다.
        aNewOrder = (nextValue + aPushedOrder) / 2.0;
      }
    }
    mychangeStack.startTrans();
    aMoved.order.set(
      aPushedOrder,
      doComplete: (val) {
        onComplete?.call();
      },
      undoComplete: (val) {
        onComplete?.call();
      },
    );
    aPushed.order.set(
      aNewOrder,
      doComplete: (val) {
        onComplete?.call();
      },
      undoComplete: (val) {
        onComplete?.call();
      },
    );
    mychangeStack.endTrans();
    onComplete?.call();
  }

  static Future<ContentsManager?> createContents(
    FrameManager? frameManager,
    List<ContentsModel> contentsModelList,
    FrameModel frameModel,
    PageModel pageModel, {
    bool isResizeFrame = true,
    void Function(ContentsModel)? onUploadComplete,
  }) async {
    // 콘텐츠 매니저를 생성한다.
    ContentsManager contentsManager = frameManager!.findOrCreateContentsManager(frameModel);
    //contentsManager ??= frameManager.newContentsManager(frameModel);

    //int counter = contentsModelList.length;

    for (var contentsModel in contentsModelList) {
      contentsModel.parentMid.set(frameModel.mid, save: false, noUndo: true);

      if (contentsModel.contentsType == ContentsType.image) {
        await _imageProcess(frameManager, contentsManager, contentsModel, frameModel, pageModel,
            isResizeFrame: isResizeFrame);
      } else if (contentsModel.contentsType == ContentsType.video) {
        contentsManager.setIsVideoResize(isResizeFrame);
        await _videoProcess(contentsManager, contentsModel, isResizeFrame: isResizeFrame);
      } else if (contentsModel.contentsType == ContentsType.pdf) {
        frameModel.frameType = FrameType.text;
        await _uploadProcess(contentsManager, contentsModel, isResizeFrame: isResizeFrame);
      } else if (contentsModel.contentsType == ContentsType.music) {
        Size musicFrameSize = StudioConst.musicPlayerSize[0];

        contentsModel.width.set(musicFrameSize.width, save: false, noUndo: true);
        contentsModel.height.set(musicFrameSize.height, save: false, noUndo: true);
        contentsModel.aspectRatio
            .set(musicFrameSize.height / musicFrameSize.width, save: false, noUndo: true);

        if (isResizeFrame) {
          frameManager.resizeFrame(
            frameModel,
            contentsModel.aspectRatio.value,
            contentsModel.width.value,
            contentsModel.height.value,
            invalidate: true,
          );
        }
        frameModel.frameType = FrameType.music;

        await _uploadProcess(
          contentsManager,
          contentsModel,
          isResizeFrame: true,
          // onUploadComplete: onUploadComplete,
          onUploadComplete: (currentModel) {
            if (currentModel.isMusic()) {
              logger.info(
                  'Dropping song named ${currentModel.name} with remoteUrl ${currentModel.remoteUrl}');

              String mid = contentsManager.frameModel.mid;
              GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[mid];
              if (musicKey != null) {
                musicKey.currentState?.addMusic(currentModel);
              } else {
                logger.info('musicKey is INVALID');
              }
            }
          },
        );
      }
      // 콘텐츠 객체를 DB에 Creta 한다.
      //print('createNextContents (contents=${contentsModel.mid})');
      await contentsManager.createNextContents(contentsModel, doNotify: false);
    }
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: true);
    CretaManager.frameSelectNotifier!.set(frameModel.mid, doNotify: false);
    frameManager.setSelectedMid(frameModel.mid);
    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();
    //frameManager!.notify();
    // 플레이를 해야하는데, 플레이는 timer 가 model list 에 모델이 있을 경우 계속 돌리고 있게 된다.

    return contentsManager;
  }

  static Future<void> _imageProcess(FrameManager? frameManager, ContentsManager contentsManager,
      ContentsModel contentsModel, FrameModel frameModel, PageModel pageModel,
      {required bool isResizeFrame}) async {
    if (contentsModel.file == null) return;

    final reader = html.FileReader();
    reader.readAsArrayBuffer(contentsModel.file!);
    await reader.onLoad.first;
    Uint8List blob = reader.result as Uint8List;
    ui.Image image = await decodeImageFromList(blob);
    // } else if (contentsModel.remoteUrl != null) {
    //   image = await CretaCommonUtils.loadImageFromUrl(contentsModel.remoteUrl!);
    // } else {
    //   logger.severe('contents.file and remoteUrl both null');
    //   return;

    // 그림의 가로 세로 규격을 알아낸다.
    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();

    double pageHeight = pageModel.height.value;
    double pageWidth = pageModel.width.value;

    // width 가 더 크다
    if (imageWidth > pageWidth) {
      // 근데, width 가 page 를 넘어간다.
      imageHeight = imageHeight * (pageWidth / imageWidth);
      imageWidth = pageWidth;
    }
    //이렇게 했는데도, imageHeight 가 page 를 넘어간다.
    if (imageHeight > pageHeight) {
      imageWidth = imageWidth * (pageHeight / imageHeight);
      imageHeight = pageHeight;
    }

    contentsModel.width.set(imageWidth, save: false, noUndo: true);
    contentsModel.height.set(imageHeight, save: false, noUndo: true);
    contentsModel.aspectRatio
        .set(contentsModel.height.value / contentsModel.width.value, save: false, noUndo: true);

    logger.fine('contentsSize, ${contentsModel.width.value} x ${contentsModel.height.value}');

    if (isResizeFrame) {
// 그림의 규격에 따라 프레임 사이즈를 수정해 준다
      frameManager?.resizeFrame(
        frameModel,
        contentsModel.aspectRatio.value,
        contentsModel.width.value,
        contentsModel.height.value,
        invalidate: true,
        isFixedRatio: true,
      );
    }

    // 업로드는  async 로 진행한다.
    if (contentsModel.remoteUrl == null || contentsModel.remoteUrl!.isEmpty) {
      // upload 되어 있지 않으므로 업로드한다.
      StudioSnippet.uploadFile(contentsModel, contentsManager, blob);
    }

    return;
  }

  static Future<void> _videoProcess(ContentsManager contentsManager, ContentsModel contentsModel,
      {required bool isResizeFrame}) async {
    //dropdown 하는 순간에 이미 플레이되고 있는 video 가 있다면, 정지시켜야 한다.
    //contentsManager.pause();

    if (contentsModel.file != null) {
      //bool uploadComplete = false;
      html.FileReader fileReader = html.FileReader();
      fileReader.onLoadEnd.listen((event) async {
        logger.fine('upload waiting ...............${contentsModel.name}');
        StudioSnippet.uploadFile(
          contentsModel,
          contentsManager,
          fileReader.result as Uint8List,
        );
        fileReader = html.FileReader(); // file reader 초기화
        //uploadComplete = true;
        logger.fine('upload complete');
      });

      // while (uploadComplete) {
      //   await Future.delayed(const Duration(milliseconds: 100));
      // }

      fileReader.onError.listen((err) {
        logger.severe('message: ${err.toString()}');
      });

      fileReader.readAsArrayBuffer(contentsModel.file!);
      return;
    }
    // 이미 remoteUrl 에 값이 있는 경우는 아무것도 하지않아도 된다.
  }

  static Future<void> _uploadProcess(ContentsManager contentsManager, ContentsModel contentsModel,
      {required bool isResizeFrame, void Function(ContentsModel)? onUploadComplete}) async {
    //dropdown 하는 순간에 이미 플레이되고 있는 video 가 있다면, 정지시켜야 한다.
    //contentsManager.pause();

    if (contentsModel.file == null) {
      return;
    }

    //bool uploadComplete = false;
    html.FileReader fileReader = html.FileReader();
    fileReader.onLoadEnd.listen((event) async {
      logger.fine('upload waiting ...............${contentsModel.name}');
      StudioSnippet.uploadFile(
        contentsModel,
        contentsManager,
        fileReader.result as Uint8List,
      ).then((value) {
        onUploadComplete?.call(contentsModel);
        return null;
      });
      //
      fileReader = html.FileReader(); // file reader 초기화
      //uploadComplete = true;
      logger.fine('upload complete ${contentsModel.remoteUrl!}');
    });

    // while (uploadComplete) {
    //   await Future.delayed(const Duration(milliseconds: 100));
    // }

    fileReader.onError.listen((err) {
      logger.severe('message: ${err.toString()}');
    });

    fileReader.readAsArrayBuffer(contentsModel.file!);
    return;
  }

  Future<int> _getAllLinks() async {
    int counter = 0;
    //startTransaction();
    reOrdering();
    logger.fine('_getAllLinks---------------${getAvailLength()}----------------------------');
    // orderMapIterator(
    //   (model) {
    //     LinkManager linkManager = newLinkManager(model.mid);
    //     linkManager.getLink(contentsId: model.mid);
    //     counter++;
    //   },
    // );
    for (var model in modelList) {
      LinkManager linkManager = newLinkManager(model.mid);
      await linkManager.getLink(contentsId: model.mid);
      counter++;
    }
    //endTransaction();
    return counter;
  }

  LinkManager newLinkManager(String contentsId) {
    logger.fine('newLinkManager()*******$contentsId');

    LinkManager? retval = linkManagerMap[contentsId];
    if (retval == null) {
      retval = LinkManager(
        contentsId,
        frameModel.realTimeKey,
        pageModel,
        frameModel,
        tableName: isPublishedMode ? 'creta_link_published' : 'creta_link',
        isPublishedMode: isPublishedMode,
      );
      linkManagerMap[contentsId] = retval;
    }
    return retval;
  }

  LinkManager? findLinkManager(String contentsId, {bool createIfNotExist = true}) {
    LinkManager? retval = linkManagerMap[contentsId];
    logger.fine('findLinkManager()*******');
    if (retval == null && createIfNotExist == true) {
      retval = LinkManager(
        contentsId,
        frameModel.realTimeKey,
        pageModel,
        frameModel,
        tableName: isPublishedMode ? 'creta_link_published' : 'creta_link',
        isPublishedMode: isPublishedMode,
      );
      linkManagerMap[contentsId] = retval;
      return linkManagerMap[contentsId];
    }
    return retval;
  }

  Future<void> copyContents(String frameMid, String bookMid, {bool samePage = true}) async {
    double order = 1;

    Set<String> existingMids = {};

    for (var ele in modelList) {
      ContentsModel org = ele as ContentsModel;
      if (org.isRemoved.value == true) continue;
      ContentsModel newModel = ContentsModel('', bookMid);
      if (existingMids.contains(org.mid)) {
        logger.severe('${newModel.mid} already exists');
        continue;
      }

      newModel.copyFrom(org, newMid: newModel.mid, pMid: frameMid);
      newModel.order.set(order++, save: false, noUndo: true);
      //print('create new Contents ${newModel.name},${newModel.mid} ${org.mid} ');
      if (samePage) {
        // 링크는 same page 에서만 copy 된다.
        LinkManager? linkManager = linkManagerMap[org.mid];
        await linkManager?.copyLinks(newModel.mid, bookMid);
      }
      await createToDB(newModel);
      existingMids.add(org.mid);
    }
  }

  List<tree.Node> toNodes(FrameModel frame) {
    //print('invoke contentsManager.toNodes()');
    List<tree.Node> conNodes = [];
    for (var ele in valueList()) {
      ContentsModel model = ele as ContentsModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      //print('model.name=${model.name}');

      String name = model.name;
      if (model.isText()) {
        String uri = model.getURI();
        if (uri.isNotEmpty) {
          if (uri.length < 33) {
            name = uri;
          } else {
            name = uri.substring(0, 30);
            name += '...';
          }
        }
      }

      List<tree.Node> linkNodes = [];
      LinkManager? linkManager = findLinkManager(model.mid, createIfNotExist: false);
      if (linkManager != null) {
        linkNodes = linkManager.toNodes();
      }
      conNodes.add(tree.Node<CretaModel>(
          key: '${pageModel.mid}/${frame.mid}/${model.mid}',
          keyType: ContaineeEnum.Contents,
          label: name,
          expanded: model.expanded || isSelected(model.mid),
          children: linkNodes,
          data: model,
          root: pageModel.mid));
    }
    return conNodes;
  }

  void unshowMusic(ContentsModel model) {
    if (model.isMusic() == false) {
      return;
    }
    String frameId = frameModel.mid;
    GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
    if (musicKey == null) {
      logger.severe('musicKey is null');
      return;
    }
    musicKey.currentState?.removeMusic(model);
  }

  void showMusic(ContentsModel model, int index) {
    if (model.isMusic() == false) {
      return;
    }
    String frameId = frameModel.mid;
    GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
    if (musicKey == null) {
      logger.severe('musicKey is null');
      return;
    }
    musicKey.currentState?.unhiddenMusic(model, index);
  }

  void selectMusic(ContentsModel model, int index) {
    if (model.isMusic() == false) {
      return;
    }
    String frameId = frameModel.mid;
    GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
    if (musicKey == null) {
      logger.severe('musicKey is null');
      return;
    }
    musicKey.currentState?.selectedSong(model, index);
  }

  void removeMusic(ContentsModel model) {
    if (model.isMusic() == false) {
      return;
    }
    String frameId = frameModel.mid;
    GlobalObjectKey<MusicPlayerFrameState>? musicKey = BookMainPage.musicKeyMap[frameId];
    if (musicKey == null) {
      logger.severe('musicKey is null');
      return;
    }
    musicKey.currentState?.removeMusic(model);
  }

  void afterShowUnshow(ContentsModel model, int index, void Function()? invalidate) {
    int len = getShowLength();
    ContentsModel? current = getCurrentModel();
    if (model.isShow.value == false) {
      unshowMusic(model);
      if (current != null && current.mid == model.mid) {
        // 현재 방송중인 것을 unshow 하려고 한다.
        if (len > 0) {
          gotoNext();
          invalidate?.call();
          return;
        }
      }
    } else {
      showMusic(model, index);
      // show 했는데, current 가 null 이다.
      if (current == null && isEmptySelected()) {
        if (len > 0) {
          setSelectedMid(model.mid);
          gotoNext();
          invalidate?.call();
          return;
        }
      }
    }
  }

  Future<void> putInDepot(ContentsModel? selectedModel, String? teamId) async {
    if (selectedModel == null) {
      ContentsManager.insertDepot(modelList, true, teamId);
    } else {
      ContentsManager.insertDepot([selectedModel], true, teamId);
    }
  }

  static Future<void> insertDepot(
      /*ContentsModel? selectedModel,*/
      List<AbsExModel>? targetList,
      bool notify,
      String? teamId) async {
    DepotManager? depotManager = DepotDisplay.getMyTeamManager(teamId);
    if (depotManager == null) {
      return;
    }

    if (targetList == null) {
      return;
    }
    if (ContentsManager.dummyManager == null) {
      return;
    }
    mychangeStack.startTrans();

    int count = 0;
    for (var ele in targetList) {
      ContentsModel model = ele as ContentsModel;
      if (model.isRemoved.value == true) {
        continue;
      }
      if (model.thumbnailUrl == null || model.thumbnailUrl!.isEmpty) {
        continue;
      }
      if (model.contentsType != ContentsType.image && model.contentsType != ContentsType.video) {
        continue;
      }
      // 여기서 CotentsModel 을  copy 해야한다.
      // ContentsModel newModel = ContentsModel('', model.realTimeKey);
      // newModel.copyFrom(model, newMid: newModel.mid, pMid: teamId);
      // await ContentsManager.dummyManager!.createToDB(newModel);
      ContentsModel newModel = ContentsModel('', model.realTimeKey);
      newModel.copyFrom(model, newMid: newModel.mid, pMid: teamId);
      MyChange<ContentsModel> c = MyChange<ContentsModel>(
        newModel,
        execute: () async {
          newModel.isRemoved.set(false, noUndo: true, save: false);
          await ContentsManager.dummyManager!.createToDB(newModel);
          return newModel;
        },
        redo: () async {
          newModel.isRemoved.set(false, noUndo: true, save: false);
          await ContentsManager.dummyManager!.setToDB(newModel);
          return newModel;
        },
        undo: (ContentsModel old) async {
          old.isRemoved.set(true, noUndo: true, save: false);
          ContentsManager.dummyManager!.remove(old);
          await ContentsManager.dummyManager!.setToDB(old);
          return old;
        },
      );
      mychangeStack.add(c);

      if (await depotManager.createNextDepot(newModel.mid, newModel.contentsType, teamId) != null) {
        MyChange<ContentsModel> c = MyChange<ContentsModel>(
          newModel,
          execute: () async {
            depotManager.filteredContents.insert(0, newModel);
            count++;
            return newModel;
          },
          redo: () async {
            depotManager.filteredContents.insert(0, newModel);
            count++;
            return newModel;
          },
          undo: (ContentsModel old) async {
            depotManager.filteredContents.remove(old);
            depotManager.notify();
            count--;
            return old;
          },
        );
        mychangeStack.add(c);
      }
    }
    if (notify && count > 0) {
      DummyModel dummyModel = DummyModel();
      MyChange<DummyModel> c = MyChange<DummyModel>(
        dummyModel,
        execute: () async {
          depotManager.notify();
          return dummyModel;
        },
        redo: () async {
          depotManager.notify();
          return dummyModel;
        },
        undo: (DummyModel old) async {
          // undo transaction 은 역순이므로, 여기서 notify 해봐야 소용없다.
          return old;
        },
      );
      mychangeStack.add(c);
    }
    mychangeStack.endTrans();

    // if (selectedModel != null) {
    //   if (await depotManager.createNextDepot(
    //           selectedModel.mid, selectedModel.contentsType, teamId) !=
    //       null) {
    //     depotManager.filteredContents.insert(0, selectedModel);
    //     if (notify) {
    //       depotManager.notify();
    //     }
    //   }
    // }
  }

  String toJson() {
    //print('xxxxxxxxxxxxxxxxxx toJson XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX');
    printIt();
    if (getAvailLength() == 0) {
      return ',\n\t\t\t"contents" : []\n';
    }
    int contentCount = 0;
    String jsonStr = '';
    jsonStr += ',\n\t\t\t"contents" : [\n';
    orderMapIterator((val) {
      ContentsModel content = val as ContentsModel;

      String uri = content.getURI();
      if (uri.isNotEmpty && uri.contains("http")) {
        BookManager.contentsUrlMap[content] = uri;
      }

      String contentStr = content.toJson(tab: '\t\t\t');
      if (contentCount > 0) {
        jsonStr += ',\n';
      }
      LinkManager? linkManager = findLinkManager(content.mid);
      if (linkManager != null) {
        contentStr += linkManager.toJson();
      }
      jsonStr += '\t\t\t{\n$contentStr\n\t\t\t}';
      contentCount++;
      return null;
    });
    jsonStr += '\n\t\t\t]\n';
    //print('skpark=$jsonStr');
    return jsonStr;
  }

  Future<bool> makeClone(
    BookModel newBook, {
    bool cloneToPublishedBook = false,
  }) async {
    for (var contents in modelList) {
      String parentFrameMid = BookManager.cloneFrameIdMap[contents.parentMid.value] ?? '';
      logger.severe('find: (${contents.parentMid.value}) => ($parentFrameMid)');
      AbsExModel newModel = await makeCopy(newBook.mid, contents, parentFrameMid);
      logger
          .severe('clone is created ($collectionId.${newModel.mid}) from (source:${contents.mid})');
      BookManager.cloneContentsIdMap[contents.mid] = newModel.mid;
    }
    // make Link
    final LinkManager copyLinkManagerHolder = cloneToPublishedBook
        ? LinkManager('', '', pageModel, frameModel, tableName: 'creta_link_published')
        : LinkManager('', '', pageModel, frameModel);
    //contentsManagerMap.forEach((key, value) { }); ==> forEach는 await 처리가 불가능
    for (MapEntry entry in linkManagerMap.entries) {
      copyLinkManagerHolder.modelList = [...entry.value.modelList];
      await copyLinkManagerHolder.makeClone(newBook, cloneToPublishedBook: cloneToPublishedBook);
    }
    return true;
  }

  Future<void> updateParent(FrameModel frame, PageModel page, String bookMid) async {
    //print('updateParent(${frame.mid})');
    await _getContents();
    for (var ele in modelList) {
      //print('contents = ${ele.mid}');
      ContentsModel model = ele as ContentsModel;
      ContentsModel newModel = ContentsModel('', bookMid);
      newModel.copyFrom(model, newMid: newModel.mid, pMid: frame.mid);
      await createToDB(newModel);
    }
  }

  void printIt() {
    //print('contentsManager.printIt()========================================');
    for (var ele in modelList) {
      ContentsModel model = ele as ContentsModel;
      logger.info(
          '*** contents = ${model.mid}, ${model.parentMid.value}, ${model.remoteUrl}, ${model.isRemoved.value}, ${model.updateTime}');
    }
  }
}
