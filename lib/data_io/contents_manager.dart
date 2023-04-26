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
import '../player/creta_abs_player.dart';
import '../player/creta_play_timer.dart';
import '../player/video/creta_video_player.dart';
import 'creta_manager.dart';
import 'frame_manager.dart';

class ContentsManager extends CretaManager {
  final PageModel pageModel;
  final FrameModel frameModel;

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

  final Map<String, CretaAbsPlayer> _playerMap = {};
  CretaAbsPlayer? getPlayer(String key) => _playerMap[key];
  void setPlayer(String key, CretaAbsPlayer player) => _playerMap[key] = player;

  final Duration _snackBarDuration = const Duration(seconds: 3);
  bool iamBusy = false;
  FrameManager? frameManager; //onDropPage 에서 video Contents 가 Drop 된 경우만 값을 가지고 있게 된다.

  CretaPlayTimer? playTimer;
  void setPlayerHandler(CretaPlayTimer p) {
    playTimer = p;
  }

  String keyMangler(String contentsMid) {
    return 'contents-${pageModel.mid}-${frameModel.mid}-$contentsMid';
  }

  bool hasContents() {
    return (getAvailLength() > 0);
  }

  ContentsModel? getCurrentModel() {
    if (playTimer == null) {
      return null;
    }
    return playTimer?.getCurrentModel();
  }

  Future<ContentsModel> createNextContents(ContentsModel model, {bool doNotify = true}) async {
    model.order.set(lastOrder() + 1, save: false, noUndo: true);
    await createToDB(model);
    insert(model, postion: getLength(), doNotify: doNotify);
    if (playTimer != null) {
      if (playTimer!.isInit()) {
        await playTimer?.rewind();
        await playTimer?.pause();
      }
      await playTimer?.reOrdering(isRewind: true);
    }
    return model;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.contents);

  Future<int> getContents() async {
    logger.info('getContents-------------------------------------------');
    int contentsCount = 0;
    startTransaction();
    try {
      contentsCount = await _getContents();
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
      showSnackBar(context, CretaLang.contentsNotDeleted, duration: _snackBarDuration);
      await Future.delayed(_snackBarDuration);
      iamBusy = false;
      return;
    }

    if (playTimer != null && playTimer!.isInit()) {
      await _removeContents(context, model);
      iamBusy = false;
      return;
    }
    showSnackBar(context, CretaLang.contentsNotDeleted, duration: _snackBarDuration);
    await Future.delayed(_snackBarDuration);
    iamBusy = false;
    return;
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

    model.isRemoved.set(true, save: false);
    await setToDB(model);
    remove(model);
    logger.info('remove contents ${model.name}, ${model.mid}');
    await playTimer?.reOrdering();

    if (getAvailLength() == 0) {
      BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
    }

    // ignore: use_build_context_synchronously
    showSnackBar(context, model.name + CretaLang.contentsDeleted, duration: _snackBarDuration);
    await Future.delayed(_snackBarDuration);

    //MiniMenu.minuMenuKey
    BookMainPage.containeeNotifier!.notify();
    return;
  }

  Future<void> setSoundOff() async {
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null) {
          logger.info('contents.setSoundOff()********');
          await video.wcontroller!.setVolume(0.0);
        }
      }
    }
  }

  Future<void> resumeSound() async {
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null && player.model!.mute.value == false) {
          logger.info('contents.resumeSound()********');
          await video.wcontroller!.setVolume(video.model!.volume.value);
        }
      }
    }
  }

  Future<void> pause() async {
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null &&
            video.isInit() &&
            playTimer != null &&
            playTimer!.isCurrentModel(player.model!.mid)) {
          logger.info('contents.pause');
          await video.wcontroller!.pause();
        }
      }
    }
  }

  Future<void> resume() async {
    for (var player in _playerMap.values) {
      if (player.model != null && player.model!.isVideo()) {
        CretaVideoPlayer video = player as CretaVideoPlayer;
        if (video.wcontroller != null &&
            video.isInit() &&
            playTimer != null &&
            playTimer!.isCurrentModel(player.model!.mid)) {
          logger.info('contents.resume');
          await video.wcontroller!.play();
        }
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

  List<CretaModel> valueList() {
    return valueEntries().toList().reversed.toList();
  }

  List<double> keyList() {
    return keyEntries().toList().reversed.toList();
  }

  int isShowLength() {
    int counter = 0;
    orderMapIterator((val) {
      ContentsModel model = val as ContentsModel;
      if (model.isShow.value && model.isRemoved.value == false) {
        counter++;
      }
    });
    return counter;
  }

  @override
  double lastOrder() {
    if (isNotEmpty()) {
      double lastOrder = keyEntries().last;
      ContentsModel? model = getNthOrder(lastOrder) as ContentsModel?;
      if (model != null && model.isShow.value == true) {
        return lastOrder;
      }
      return nextOrder(lastOrder);
    }
    return -1;
  }

  @override
  double nextOrder(double currentOrder) {
    int counter = 0;
    int len = getAvailLength();
    double input = currentOrder;
    while (counter < len) {
      double order = _nextOrder(input);
      if (order < 0) {
        return order;
      }
      ContentsModel? model = getNthOrder(order) as ContentsModel?;
      if (model != null && model.isShow.value == true) {
        return order;
      }
      counter++;
      input = order;
    }
    return -1;
  }

  double _nextOrder(double currentOrder) {
    bool matched = false;

    Iterable<double> keys = keyEntries().toList().reversed;

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

    Iterable<double> keys = keyEntries().toList().reversed;

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

  @override
  double prevOrder(double currentOrder) {
    int counter = 0;
    int len = getAvailLength();
    double input = currentOrder;
    while (counter < len) {
      double order = _prevOrder(input);
      if (order < 0) {
        return order;
      }
      ContentsModel? model = getNthOrder(order) as ContentsModel?;
      if (model != null && model.isShow.value == true) {
        return order;
      }
      counter++;
      input = order;
    }
    return -1;
  }

  double _prevOrder(double currentOrder) {
    bool matched = false;
    late Iterable<double> keys = keyEntries();
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
    late Iterable<double> keys = keyEntries();

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

  // void setLoop(bool loop) {
  //   playTimer?.setLoop(loop);
  // }

  void pushReverseOrder(String aMovedMid, String aPushedMid, String hint) {
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
    logger.info('Frame $hint :   ${aMoved.order.value} <--> ${aPushed.order.value}');

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
    aMoved.order.set(aPushedOrder);
    aPushed.order.set(aNewOrder);
    mychangeStack.endTrans();
  }
}
