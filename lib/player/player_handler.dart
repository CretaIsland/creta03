// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:creta03/player/abs_player.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:synchronized/synchronized.dart';

import '../data_io/contents_manager.dart';
import '../model/app_enums.dart';
import '../model/contents_model.dart';
import 'image/image_player_widget.dart';
import 'player_timer.dart';
import 'text/text_player_widget.dart';
import 'video/video_player_widget.dart';

class CurrentData {
  ContentsType type = ContentsType.none;
  PlayState state = PlayState.none;
  bool mute = false;
}

SelectedModel? selectedModelHolder;

class SelectedModel extends ChangeNotifier {
  ContentsModel? _model;
  final Lock _lock = Lock();

  Future<ContentsModel?> getModel() async {
    return await _lock.synchronized<ContentsModel?>(() async {
      return _model;
    });
  }

  Future<bool> setModel(ContentsModel m, {bool invalidate = true}) async {
    return await _lock.synchronized(() async {
      if (_model == null || _model!.isChanged(m)) {
        logger.fine('setModel');
        _model = m;
        if (invalidate) {
          notifyListeners();
          return true;
        }
      }
      return false;
    });
  }

  Future<bool> isSelectedModel(ContentsModel m) async {
    return await _lock.synchronized<bool>(() async {
      return _model!.mid == m.mid;
    });
  }
}

class PlayerHandler extends ChangeNotifier {
  ContentsManager? contentsManager;
  PlayTimer? _timer;
  bool _initComplete = false;
  AbsPlayWidget? _currentPlayer;

  final Map<String, AbsPlayWidget> _playerMap = {};

  //AbsPlayWidget? _player;

  void setIsNextButtonBusy(bool val) => _timer?.setIsNextButtonBusy(val);
  void setIsPrevButtonBusy(bool val) => _timer?.setIsPrevButtonBusy(val);

  void start(ContentsManager manager) {
    contentsManager = manager;
    _timer = PlayTimer(contentsManager!, this);
    _timer!.initTimer();
    _initComplete = true;
  }

  void notify() {
    notifyListeners();
  }

  void clear() {
    _timer?.disposeTimer();
  }

  Future<void> reOrdering({bool rewind = false}) async {
    await _timer?.reOrdering(rewind);
  }

  ContentsModel? getCurrentModel() {
    if (!_initComplete || _timer == null) {
      return null;
    }
    return _timer!.currentModel;
  }

  // String _keyMangler(String mid, bool flag) {
  //   return mid + (flag ? '_x' : '_y');
  // }

  AbsPlayWidget createPlayer(ContentsModel model) {
    //String key = _keyMangler(model.mid, model.changeToggle);
    String key = model.mid;
    AbsPlayWidget? player = _playerMap[key];
    if (player != null) {
      _currentPlayer = player;
      return player;
    }
    player = _createPlayer(model);
    _currentPlayer = player;
    _playerMap[key] = player;
    player.init();
    logger.info('player newly created');
    return player;
  }

  AbsPlayWidget _createPlayer(ContentsModel model) {
    //String key = _keyMangler(model.mid, model.changeToggle);
    String key = model.mid;
    switch (model.contentsType) {
      case ContentsType.video:
        return VideoPlayerWidget(
          globalKey: GlobalObjectKey<VideoPlayerWidgetState>(key),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      case ContentsType.image:
        return ImagePlayerWidget(
          globalKey: GlobalObjectKey<ImagePlayerWidgetState>(key),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      case ContentsType.text:
        return TextPlayerWidget(
          globalKey: GlobalObjectKey<TextPlayerWidgetState>(key),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      default:
        throw EmptyPlayWidget(
            key: GlobalObjectKey<EmptyPlayWidgetState>(key),
            onAfterEvent: () {},
            acc: contentsManager!);
    }
  }

  Future<void> setProgressBar(double value, ContentsModel currentModel) async {
    ContentsModel? selectedModel = await selectedModelHolder!.getModel();
    if (selectedModel != null && progressHolder != null && currentModel.mid == selectedModel.mid) {
      progressHolder!.setProgress(value, currentModel.mid);
    }
  }

  Future<void> toggleIsPause() async {
    await _timer?.togglePause();
  }

  bool isPause() {
    if (_timer == null) {
      return true;
    }
    return _timer!.isPauseTimer;
  }

  Future<void> next() async => await _timer?.next();
  Future<void> prev() async => await _timer?.prev();

  bool isNextButtonBusy() {
    if (_timer != null) {
      return _timer!.isNextButtonBusy;
    }
    return false;
  }

  bool isPrevButtonBusy() {
    if (_timer != null) {
      return _timer!.isPrevButtonBusy;
    }
    return false;
  }

  Future<void> pause() async {
    await _currentPlayer?.pause();
  }

  Future<void> close() async {
    await _currentPlayer?.close();
  }

  Future<void> play() async {
    await _currentPlayer?.play();
  }

  Future<void> rewind() async {
    _timer?.reset();
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
    if (contentsManager != null) {
      return contentsManager!.getAvailLength();
    }
    return 0;
  }

  // void setLoop(bool loop) {
  //   for (AbsPlayWidget player in _playerMap.values) {
  //     if (player.model!.contentsType == ContentsType.video) {
  //       VideoPlayerWidget video = player as VideoPlayerWidget;
  //       video.wcontroller?.setLooping(loop);
  //     }
  //   }
  // }
}
