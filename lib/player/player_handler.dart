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

  ContentsModel? getCurrentModel() {
    if (!_initComplete || _timer == null) {
      return null;
    }
    return _timer!.currentModel;
  }

  AbsPlayWidget createPlayer(ContentsModel model) {
    AbsPlayWidget? player = _playerMap[model.mid];
    if (player != null) {
      _currentPlayer = player;
      return player;
    }
    player = _createPlayer(model);
    _currentPlayer = player;
    _playerMap[model.mid] = player;
    player.init();
    logger.info('player newly created');
    return player;
  }

  AbsPlayWidget _createPlayer(ContentsModel model) {
    switch (model.contentsType) {
      case ContentsType.video:
        return VideoPlayerWidget(
          globalKey: GlobalObjectKey<VideoPlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      case ContentsType.image:
        return ImagePlayerWidget(
          globalKey: GlobalObjectKey<ImagePlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      case ContentsType.text:
        return TextPlayerWidget(
          globalKey: GlobalObjectKey<TextPlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager!,
          onAfterEvent: () {},
        );
      default:
        throw EmptyPlayWidget(
            key: GlobalObjectKey<EmptyPlayWidgetState>(model.mid),
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

  void toggleIsPause() {
    _timer?.togglePause();
  }

  bool isPause() {
    if (_timer == null) {
      return true;
    }
    return _timer!.isPauseTimer;
  }

  void next() => _timer?.next();
  void prev() => _timer?.prev();

  void pause() {
    _currentPlayer?.pause();
  }

  void play() {
    _currentPlayer?.play();
  }

  void globalPause() {
    _currentPlayer?.globalPause();
  }

  void globalResume() {
    _currentPlayer?.globalResume();
  }

  void setLoop(bool loop) {
    for (AbsPlayWidget player in _playerMap.values) {
      if (player.model!.contentsType == ContentsType.video) {
        VideoPlayerWidget video = player as VideoPlayerWidget;
        video.wcontroller?.setLooping(loop);
      }
    }
  }
}
