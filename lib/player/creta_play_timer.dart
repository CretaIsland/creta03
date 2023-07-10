// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:creta03/player/pdf/creta_pdf_player.dart';
import 'package:creta03/player/pdf/creta_pdf_widget.dart';
import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:synchronized/synchronized.dart';

import '../data_io/contents_manager.dart';
import '../data_io/frame_manager.dart';
import '../data_io/link_manager.dart';
import '../model/app_enums.dart';
import '../model/contents_model.dart';
import '../model/frame_model.dart';
import '../model/link_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../pages/studio/studio_variables.dart';
import 'creta_abs_player.dart';
import 'creta_abs_media_widget.dart';
import 'doc/creta_doc_player.dart';
import 'doc/creta_doc_widget.dart';
import 'image/creta_image_player.dart';
import 'image/creta_image_widget.dart';
import 'music/creta_music_player.dart';
import 'music/creta_music_widget.dart';
import 'text/creta_text_player.dart';
import 'text/creta_text_widget.dart';
import 'video/creta_video_player.dart';
import 'video/creta_video_widget.dart';

class CretaPlayTimer extends ChangeNotifier {
  final ContentsManager contentsManager;
  final FrameManager frameManager;

  CretaPlayTimer(this.contentsManager, this.frameManager) {
    //final BoolEventController lineDrawSendEvent = Get.find(tag: 'draw-link');
    //_lineDrawSendEvent = lineDrawSendEvent;
  }
  Timer? _timer;
  final int _timeGap = 500; //
  final Lock _lock = Lock();
  double _currentOrder = -1;
  double _currentPlaySec = 0.0;
  Duration _completeWaitTime = Duration.zero;

  ContentsModel? _currentModel;
  ContentsModel? get currentModel => _currentModel;

  ContentsModel? _prevModel;

  bool _isPauseTimer = false;
  bool _isPrevPauseTimer = false;
  bool get isPauseTimer => _isPauseTimer;

  bool _isNextButtonBusy = false;
  bool _isPrevButtonBusy = false;
  bool get isNextButtonBusy => _isNextButtonBusy;
  bool get isPrevButtonBusy => _isPrevButtonBusy;
  void setIsNextButtonBusy(bool val) => _isNextButtonBusy = val;
  void setIsPrevButtonBusy(bool val) => _isPrevButtonBusy = val;

  bool _forceToChange = false;

  // from Handler
  bool _initComplete = false;
  CretaAbsPlayer? _currentPlayer;

  //BoolEventController? _lineDrawSendEvent;

  Future<void> togglePause() async {
    _isPrevPauseTimer = _isPauseTimer;
    _isPauseTimer = !_isPauseTimer;

    if (_currentModel != null) {
      if (_currentModel!.isVideo()) {
        _currentModel!.setIsPauseTimer(_isPauseTimer);
        if (_isPauseTimer) {
          await pause();
        } else {
          await play();
        }
      }
      if (_currentModel!.isImage()) {
        contentsManager.notify();
      }
    }
  }

  Future<void> releasePause() async {
    _isPauseTimer = false;
    _isPrevPauseTimer = false;
    if (_currentModel != null && _currentModel!.contentsType == ContentsType.video) {
      _currentModel!.setIsPauseTimer(_isPauseTimer);
      // if (_isPauseTimer) {
      //   await pause();
      // } else {
      //   await play();
      // }
    }
  }

  void start() {
    if (_timer == null) {
      //logger.info("==========================timer start================");
      _timer = Timer.periodic(Duration(milliseconds: _timeGap), _timerExpired);
      _initComplete = true;
    }
  }

  void stop() {
    //logger.info("==========================timer stop================");
    _timer?.cancel();
    _initComplete = false;
    _timer = null;
  }

  // Future<void> toggleIsPause() async {
  //   await togglePause();
  // }

  bool isPause() {
    if (_timer == null) {
      return true;
    }
    return isPauseTimer;
  }

  Future<void> pause() async {
    await _currentPlayer?.pause();
  }

  // Future<void> close() async {
  //   await _currentPlayer?.close();
  // }

  Future<void> play() async {
    await _currentPlayer?.play();
  }

  Future<void> rewind() async {
    reset();
    await _currentPlayer?.rewind();
  }

  Future<void> globalPause() async {
    await _currentPlayer?.globalPause();
  }

  Future<void> globalResume() async {
    await _currentPlayer?.globalResume();
  }

  bool isInit() {
    if (_currentPlayer == null) {
      return false;
    }
    return _currentPlayer!.isInit();
  }

  int getAvailLength() {
    return contentsManager.getAvailLength();
  }

  void notify() {
    notifyListeners();
  }

  Future<void> reset() async {
    await _lock.synchronized(() {
      _currentPlaySec = 0.0;
    });
  }

  void setLooping(bool val) {
    _currentPlayer?.setLooping(val);
  }

  Future<void> reOrdering({bool isRewind = false}) async {
    await _lock.synchronized(() {
      contentsManager.reOrdering();
      if (isRewind) {
        _currentPlaySec = 0.0;
        _currentOrder = contentsManager.lastOrder();
      }
    });
  }

  bool isCurrentModel(String mid) {
    if (!_initComplete || _timer == null || _currentModel == null) {
      return false;
    }
    return _currentModel!.mid == mid;
  }

  ContentsModel? getCurrentModel() {
    if (!_initComplete || _timer == null) {
      return null;
    }
    return _currentModel;
  }

  void clearCurrentModel() {
    _currentOrder = -1;
    _currentModel = null;
  }

  Future<void> setCurrentOrder(double order) async {
    await _lock.synchronized(() async {
      _currentOrder = order;
    });
  }

  void _setCurrentModel() {
    _currentModel = contentsManager.getNthOrder(_currentOrder) as ContentsModel?;
    while (true) {
      if (_currentModel != null) {
        break;
      }
      _next();
      if (_currentOrder < 0) {
        return; // 돌릴게 없다.
      }
      _currentModel = contentsManager.getNthOrder(_currentOrder) as ContentsModel?;
    }
    _prevModel ??= ContentsModel('', '');

    if (_currentModel != null &&
        (_currentModel!.mid != _prevModel!.mid || _forceToChange == true)) {
      logger.fine('CurrentModel changed from ${_prevModel!.name}');
      _forceToChange = false;
      notify();
      if (_currentModel!.mid != _prevModel!.mid) {
        notifyToProperty();

        // prev 모델의 frame를 inVisible 하게 만들어야 한다.
        LinkManager? linkManager = contentsManager.findLinkManager(_prevModel!.mid);
        if (linkManager != null) {
          linkManager.listIterator((value) {
            LinkModel link = value as LinkModel;
            FrameModel? frame = frameManager.getModel(link.connectedMid) as FrameModel?;
            if (frame != null) {
              frame.isShow.set(false);
              frameManager.notify();
            }
            return null;
          });
        }
      }
      _currentModel!.copyTo(_prevModel!);
      logger.fine('CurrentModel changed to ${_currentModel!.name}');
    }

    return;
  }

  Future<void> prev() async {
    setIsPrevButtonBusy(true);
    logger.info('prev button pressed');
    await _lock.synchronized(() async {
      if (isInit()) {
        //if (contentsManager.getAvailLength() > 1) {
        await pause();
        await rewind();
        //}
        double oldOrder = _currentOrder;
        _currentOrder = contentsManager.prevOrder(oldOrder);
        if (oldOrder == _currentOrder) {
          _forceToChange = true;
        }
      }
    });
  }

  Future<void> next() async {
    setIsNextButtonBusy(true);
    await _lock.synchronized(() async {
      if (isInit()) {
        //if (contentsManager.getAvailLength() > 1) {
        await pause();
        await rewind();
        //logger.info('${_currentModel!.name} is paused');
        //}
        _next();
      }
    });
  }

  void _next() {
    _currentPlaySec = 0.0;
    // if (contentsManager.getAvailLength() == 1) {
    //   if (_currentModel != null) {
    //     logger.info('only one movie file');
    //     _currentModel!.forceToChange = true;
    //   }
    // }
    double oldOrder = _currentOrder;
    _currentOrder = contentsManager.nextOrder(oldOrder, alwaysOneExist: true);
    if (oldOrder == _currentOrder) {
      _forceToChange = true;
    }
    if (oldOrder <= _currentOrder) {
      // 이경우 한바퀴 돌았다는 뜻이다.
      frameManager.nextPageListener(contentsManager.frameModel);
    }
  }

  void notifyToProperty() {
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Contents) {
      ContentsModel? content = contentsManager.getCurrentModel();
      if (content != null &&
          DraggableStickers.frameSelectNotifier != null &&
          DraggableStickers.frameSelectNotifier!.selectedAssetId != null) {
        if (content.parentMid.value == DraggableStickers.frameSelectNotifier!.selectedAssetId) {
          logger.finest('notifyToProperty');
          contentsManager.setSelectedMid(content.mid, doNotify: false);
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: true);
        }
      }
    }
    //print('6666666666666666666666666');
    //_lineDrawSendEvent?.sendEvent(false);
  }

  CretaAbsPlayer createPlayer(ContentsModel model) {
    final String key = contentsManager.keyMangler(model.mid);
    CretaAbsPlayer? player = contentsManager.getPlayer(key);
    if (player != null) {
      _currentPlayer = player;
      return player;
    }
    logger.info('***************************player newly created ***********');
    player = _createPlayer(key, model);
    _currentPlayer = player;
    contentsManager.setPlayer(key, player);
    player.init();
    logger.info('player is newly created');
    return player;
  }

  CretaAbsPlayer _createPlayer(String key, ContentsModel model) {
    switch (model.contentsType) {
      case ContentsType.video:
        return CretaVideoPlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (postion, duration) {
            _completeWaitTime = duration - postion;
          },
        );
      case ContentsType.image:
        return CretaImagePlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (position, duration) {},
        );
      case ContentsType.text:
        return CretaTextPlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (position, duration) {},
        );
      case ContentsType.document:
        return CretaDocPlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (position, duration) {},
        );
      case ContentsType.music:
        return CretaMusicPlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (position, duration) {},
        );
      case ContentsType.pdf:
        return CretaPdfPlayer(
          keyString: key,
          model: model,
          acc: contentsManager,
          onAfterEvent: (position, duration) {},
        );
      default:
        return CretaEmptyPlayer(
          keyString: key,
          acc: contentsManager,
          onAfterEvent: (postion, duration) {},
        );
    }
  }

  CretaAbsPlayerWidget createWidget(ContentsModel model) {
    CretaAbsPlayer player = createPlayer(model);
    //print('createWidget${model.name}, ${model.contentsType})------------');
    switch (model.contentsType) {
      case ContentsType.video:
        return CretaVideoWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
      case ContentsType.image:
        return CretaImagerWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
      case ContentsType.text:
        return CretaTextWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
      case ContentsType.document:
        //print('-------------createWidget${model.name}, ${model.contentsType})------------');
        return CretaDocWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
          frameManager: frameManager,
        );
      case ContentsType.music:
        // print('-------------createMusicWidget${model.name}, ${model.contentsType})------------');
        return CretaMusicWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
      case ContentsType.pdf:
        return CretaPdfWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
      default:
        return CretaEmptyPlayerWidget(
          key: GlobalObjectKey(player.keyString),
          player: player,
        );
    }
  }

  Future<void> _timerExpired(Timer timer) async {
    await _lock.synchronized(
      () async {
        if (contentsManager.isEmpty()) {
          return;
        }
        if (contentsManager.iamBusy) {
          logger.info('i am busy');
          return;
        }
        // if (BookMainPage.pageManagerHolder!.isSelected(contentsManager.pageModel.mid) == false) {
        //   // 현재 보여지고 있는 페이지가 아니라면 타이머는 쉰다.
        //   // logger.info(
        //   //     '${contentsManager.pageModel.mid} is not ${BookMainPage.pageManagerHolder!.getSelectedMid()}');
        //   return;
        // }

        if (_isPauseTimer == true) {
          _currentModel?.setPlayState(PlayState.pause);
          return;
        }
        if (_isPauseTimer != _isPrevPauseTimer) {
          _isPrevPauseTimer = _isPauseTimer;
          if (_currentModel != null && _currentModel!.isState(PlayState.pause)) {
            _currentModel?.resumeState();
          }
        }

        // 아무것도 돌고 있지 않다면,
        if (_currentOrder < 0) {
          _currentOrder = contentsManager.lastOrder(); //가장 마지막이 가장 먼저 돌아야 하므로.
          //logger.info('currentOrder=$_currentOrder');
          if (_currentOrder < 0) {
            return; // 돌릴게 없다.
          }
        }
        _setCurrentModel();
        if (_currentModel == null) {
          logger.warning('_curentModel is null');
          return;
        }

        if (_currentModel != null && _currentModel!.isImage() || _currentModel!.isText()) {
          double playTime = _currentModel!.playTime.value;
          if (0 > playTime) {
            // playTime 이 영구히로 잡혀있다.
            return;
          }

          if (_currentModel != null && _currentPlaySec < playTime) {
            if ((StudioVariables.isAutoPlay && _currentModel!.playState != PlayState.pause) ||
                _currentModel!.manualState == PlayState.start) {
              _currentPlaySec += _timeGap;
              // await playHandler.setProgressBar(
              //   playTime <= 0 ? 0 : _currentPlaySec / playTime,
              //   _currentModel!,
              // );
            }
            return;
          }

          // 교체시간이 되었다.
          _next();
          // await playHandler.setProgressBar(
          //   playTime <= 0 ? 0 : _currentPlaySec / playTime,
          //   _currentModel!,
          // );
          return;
        }

        if (_currentModel != null && _currentModel!.isVideo()) {
          // if (StudioVariables.isAutoPlay) {
          //   await globalResume();
          // } else {
          //   await globalPause();
          // }
          if (_currentModel != null && _currentModel!.playState == PlayState.end) {
            _currentModel!.setPlayState(PlayState.none);
            logger.info('before next, currentOrder=$_currentOrder');
            // 비디오가 마무리 작업을 할 시간을 준다.
            if (_completeWaitTime != Duration.zero) {
              await Future.delayed(_completeWaitTime);
              _completeWaitTime = Duration.zero;
            }
            _next();

            logger.info('after next, currentOrder=$_currentOrder');
          }
          return;
        }
      },
    );
  }
}
