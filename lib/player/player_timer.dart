// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:hycop/common/util/logger.dart';
import 'package:synchronized/synchronized.dart';

import '../data_io/contents_manager.dart';
import '../model/app_enums.dart';
import '../model/contents_model.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/containees/containee_nofifier.dart';
import '../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../pages/studio/studio_variables.dart';
import 'player_handler.dart';

class PlayTimer {
  Timer? _timer;
  final int _timeGap = 100; //
  final Lock _lock = Lock();
  double _currentOrder = -1;
  double _currentPlaySec = 0.0;
  ContentsModel? _currentModel;
  ContentsModel? _prevModel;

  bool _isPauseTimer = false;
  bool _isPrevPauseTimer = false;

  void togglgePause() {
    _isPrevPauseTimer = _isPauseTimer;
    _isPauseTimer = !_isPauseTimer;
  }

  bool get isPauseTimer => _isPauseTimer;

  final ContentsManager contentsManager;
  final PlayerHandler playManager;

  PlayTimer(this.contentsManager, this.playManager);

  void initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: _timeGap), _timerExpired);
  }

  void disposeTimer() {
    _timer?.cancel();
  }

  ContentsModel? get currentModel => _currentModel;

  // Future<ContentsModel?> getCurrentModel() async {
  //   return await _lock.synchronized(() async {
  //     return _currentModel;
  //   });
  // }

  void _setCurrentModel() {
    contentsManager.reOrdering();
    _currentModel = contentsManager.getNthOrder(_currentOrder) as ContentsModel?;
    while (true) {
      if (_currentModel != null) {
        break;
      }
      _currentOrder = contentsManager.nextOrder(_currentOrder);
      if (_currentOrder < 0) {
        return; // 돌릴게 없다.
      }
      _currentModel = contentsManager.getNthOrder(_currentOrder) as ContentsModel?;
    }
    _prevModel ??= ContentsModel('');

    if (_currentModel!.mid != _prevModel!.mid) {
      _currentModel!.copyTo(_prevModel!);
      playManager.notify();
      notifyToProperty();
    }

    return;
  }

  Future<void> next() async {
    await _lock.synchronized(() async {
      _currentPlaySec = 0.0;
      _currentOrder = contentsManager.nextOrder(_currentOrder);
    });
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

  Future<void> prev() async {
    await _lock.synchronized(() async {
      _currentPlaySec = 0.0;
      _currentOrder = contentsManager.prevOrder(_currentOrder);
    });
  }

  Future<void> _timerExpired(Timer timer) async {
    await _lock.synchronized(
      () async {
        if (contentsManager.isEmpty()) return;

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
          _currentOrder = contentsManager.firstOrder();
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
              // await playManager.setProgressBar(
              //   playTime <= 0 ? 0 : _currentPlaySec / playTime,
              //   _currentModel!,
              // );
            }
            return;
          }

          logger.finest(
              'playTime expired $playTime, ${_currentModel!.name}, ${_currentModel!.order.value}');

          // 교체시간이 되었다.
          _currentPlaySec = 0.0;
          _currentOrder = contentsManager.nextOrder(_currentOrder);
          // await playManager.setProgressBar(
          //   playTime <= 0 ? 0 : _currentPlaySec / playTime,
          //   _currentModel!,
          // );
          return;
        }

        if (_currentModel!.isVideo()) {
          if (_currentModel!.playState == PlayState.end) {
            _currentModel!.setPlayState(PlayState.none);
            logger.fine('before next');
            _currentOrder = contentsManager.nextOrder(_currentOrder);
            // 비디오가 마무리 작업을 할 시간을 준다.
            Future.delayed(Duration(milliseconds: (_timeGap / 4).round()));
          }
          return;
        }
      },
    );
  }
}
