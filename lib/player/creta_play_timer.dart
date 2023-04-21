// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:synchronized/synchronized.dart';

import '../data_io/contents_manager.dart';
import '../model/app_enums.dart';
import '../model/contents_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../pages/studio/studio_variables.dart';
import 'creta_abs_player.dart';
import 'creta_abs_media_widget.dart';
import 'image/creta_image_player.dart';
import 'image/creta_image_widget.dart';
import 'video/creta_video_player.dart';
import 'video/creta_video_widget.dart';

class CretaPlayTimer extends ChangeNotifier {
  final ContentsManager contentsManager;

  CretaPlayTimer(this.contentsManager);
  Timer? _timer;
  final int _timeGap = 100; //
  final Lock _lock = Lock();
  double _currentOrder = -1;
  double _currentPlaySec = 0.0;

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

  // from Handler
  bool _initComplete = false;
  CretaAbsPlayer? _currentPlayer;
  final Map<String, CretaAbsPlayer> _playerMap = {};

  Future<void> togglePause() async {
    _isPrevPauseTimer = _isPauseTimer;
    _isPauseTimer = !_isPauseTimer;

    if (_currentModel != null && _currentModel!.contentsType == ContentsType.video) {
      if (_isPauseTimer) {
        await pause();
      } else {
        await play();
      }
    }
  }

  void start() {
    _timer = Timer.periodic(Duration(milliseconds: _timeGap), _timerExpired);
    _initComplete = true;
  }

  void stop() {
    _timer?.cancel();
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

  Future<void> reOrdering({bool isRewind = false}) async {
    await _lock.synchronized(() {
      contentsManager.reOrdering();
      if (isRewind) {
        _currentPlaySec = 0.0;
        _currentOrder = contentsManager.lastOrder();
      }
    });
  }

  ContentsModel? getCurrentModel() {
    if (!_initComplete || _timer == null) {
      return null;
    }
    return _currentModel;
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
    _prevModel ??= ContentsModel('');

    if (_currentModel!.mid != _prevModel!.mid) {
      logger.info('CurrentModel changed from ${_prevModel!.name}');
      _currentModel!.copyTo(_prevModel!);
      notify();
      notifyToProperty();
      logger.info('CurrentModel changed to ${_currentModel!.name}');
    }

    return;
  }

  Future<void> prev() async {
    setIsPrevButtonBusy(true);
    logger.info('prev button pressed');
    await _lock.synchronized(() async {
      if (isInit()) {
        if (contentsManager.getAvailLength() > 1) {
          await pause();
          await rewind();
        }
        _currentOrder = contentsManager.prevOrder(_currentOrder);
      }
    });
  }

  Future<void> next() async {
    setIsNextButtonBusy(true);
    await _lock.synchronized(() async {
      if (isInit()) {
        if (contentsManager.getAvailLength() > 1) {
          await pause();
          await rewind();
          logger.info('${_currentModel!.name} is paused');
        }
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
    _currentOrder = contentsManager.nextOrder(_currentOrder);
  }

  void notifyToProperty() {
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Contents) {
      ContentsModel? content = contentsManager.getCurrentModel();
      if (content != null) {
        if (content.parentMid.value == DraggableStickers.selectedAssetId) {
          logger.info('notifyToProperty');
          contentsManager.setSelectedMid(content.mid, doNotify: false);
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: true);
        }
      }
    }
  }

  CretaAbsPlayer createPlayer(ContentsModel model) {
    final String key = "player_${model.mid}";
    CretaAbsPlayer? player = _playerMap[key];
    if (player != null) {
      _currentPlayer = player;
      return player;
    }
    player = _createPlayer(key, model);
    _currentPlayer = player;
    _playerMap[key] = player;
    player.init();
    logger.info('player is newly created');
    return player;
  }

  CretaAbsPlayer _createPlayer(String key, ContentsModel model) {
    switch (model.contentsType) {
      case ContentsType.video:
        return CretaVideoPlayer(
          model: model,
          acc: contentsManager,
          onAfterEvent: () {},
        );
      case ContentsType.image:
        return CretaImagePlayer(
          model: model,
          acc: contentsManager,
          onAfterEvent: () {},
        );
      default:
        return CretaEmptyPlayer(
          acc: contentsManager,
          onAfterEvent: () {},
          autoStart: false,
        );
    }
  }

  CretaAbsPlayerWidget createWidget(ContentsModel model) {
    CretaAbsPlayer player = createPlayer(model);
    final String key = "player_${model.mid}";

    switch (model.contentsType) {
      case ContentsType.video:
        return CretaVideoWidget(
          key: GlobalObjectKey(key),
          player: player,
        );
      case ContentsType.image:
        return CretaImagerWidget(
          key: GlobalObjectKey(key),
          player: player,
        );
      default:
        return CretaEmptyPlayerWidget(
          key: GlobalObjectKey(key),
          player: player,
        );
    }
  }

  Future<void> _timerExpired(Timer timer) async {
    await _lock.synchronized(
      () async {
        if (contentsManager.isEmpty()) return;
        if (contentsManager.iamBusy) return;
        if (BookMainPage.pageManagerHolder!.isSelected(contentsManager.pageModel.mid) == false) {
          // 현재 보여지고 있는 페이지가 아니라면 타이머는 쉰다.
          return;
        }

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
          logger.info('currentOrder=$_currentOrder');
          if (_currentOrder < 0) {
            return; // 돌릴게 없다.
          }
        }
        _setCurrentModel();
        if (_currentModel == null) {
          return;
        }

        if (_currentModel!.isImage() || _currentModel!.isText()) {
          double playTime = _currentModel!.playTime.value;
          if (0 > playTime) {
            // playTime 이 영구히로 잡혀있다.
            return;
          }

          if (_currentPlaySec < playTime) {
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

          logger.finest(
              'playTime expired $playTime, ${_currentModel!.name}, ${_currentModel!.order.value}');

          // 교체시간이 되었다.
          _next();
          // await playHandler.setProgressBar(
          //   playTime <= 0 ? 0 : _currentPlaySec / playTime,
          //   _currentModel!,
          // );
          return;
        }

        if (_currentModel!.isVideo()) {
          if (StudioVariables.isAutoPlay) {
            await globalResume();
          } else {
            await globalPause();
          }

          if (_currentModel!.playState == PlayState.end) {
            _currentModel!.setPlayState(PlayState.none);
            logger.info('before next, currentOrder=$_currentOrder');
            // 비디오가 마무리 작업을 할 시간을 준다.
            // await Future.delayed(Duration(milliseconds: (_timeGap / 4).round()));
            _next();

            logger.info('after next, currentOrder=$_currentOrder');
          }
          return;
        }
      },
    );
  }
}
