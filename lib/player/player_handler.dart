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
        logger.info('setModel');
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

PlayerHandler? playerManagerHolder;

class PlayerHandler extends ChangeNotifier {
  final ContentsManager contentsManager;
  late PlayTimer _timer;
  //AbsPlayWidget? _player;

  PlayerHandler(this.contentsManager) {
    _timer = PlayTimer(contentsManager, this);
    _timer.initTimer();
  }

  void notify() {
    notifyListeners();
  }

  void clear() {
    _timer.disposeTimer();
  }

  ContentsModel? getCurrentModel() {
    return _timer.currentModel;
  }

  AbsPlayWidget createPlayer(ContentsModel model) {
    switch (model.contentsType) {
      case ContentsType.video:
        return VideoPlayerWidget(
          globalKey: GlobalObjectKey<VideoPlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager,
          onAfterEvent: () {},
        );
      case ContentsType.image:
        return ImagePlayerWidget(
          globalKey: GlobalObjectKey<ImagePlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager,
          onAfterEvent: () {},
        );
      case ContentsType.text:
        return TextPlayerWidget(
          globalKey: GlobalObjectKey<TextPlayerWidgetState>(model.mid),
          model: model,
          acc: contentsManager,
          onAfterEvent: () {},
        );
      default:
        throw EmptyPlayWidget(
            key: GlobalObjectKey<EmptyPlayWidgetState>(model.mid),
            onAfterEvent: () {},
            acc: contentsManager);
    }
  }

  Future<void> setProgressBar(double value, ContentsModel currentModel) async {
    ContentsModel? selectedModel = await selectedModelHolder!.getModel();
    if (selectedModel != null && progressHolder != null && currentModel.mid == selectedModel.mid) {
      progressHolder!.setProgress(value, currentModel.mid);
    }
  }
}
