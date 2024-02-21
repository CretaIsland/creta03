// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable

import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/model/app_enums.dart';
import '../creta_abs_player.dart';

class CretaPdfPlayer extends CretaAbsPlayer {
  CretaPdfPlayer({
    required super.keyString,
    required super.model,
    required super.acc,
    super.onAfterEvent,
  });

  @override
  Future<void> play({bool byManual = false}) async {
    logger.fine('pdf play');
    model!.setPlayState(PlayState.start);
    if (byManual) {
      model!.setManualState(PlayState.start);
    }
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    model!.setPlayState(PlayState.pause);
  }

  @override
  void stop() {
    //logger.fine("pdf player stop,${model!.name}");
    //widget.wcontroller!.dispose();
    super.stop();
    model!.setPlayState(PlayState.stop);
  }

  // @override
  // Future<void> close() async {
  //   logger.fine('Image close');

  //   model!.setPlayState(PlayState.none);
  // }

  // @override
  // Future<void> afterBuild() async {
  //   acc.playerHandler?.setIsNextButtonBusy(false);
  //   acc.playerHandler?.setIsPrevButtonBusy(false);
  // }

  // @override
  // Future<void> afterBuild() async {
  //   WidgetsBinding.instance.addPostFrameCallback((_) async {
  //     onAfterEvent?.call(Duration.zero, Duration.zero);
  //   });
  // }
}
