// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../model/contents_model.dart';
import '../../pages/studio/left_menu/music/left_menu_music.dart';
import '../../pages/studio/studio_variables.dart';
import 'creta_music_player.dart';

Map<String, GlobalObjectKey<LeftMenuMusicState>> musicKeyMap = {};

mixin CretaMusicMixin {
  Widget playMusic(
    BuildContext context,
    CretaMusicPlayer? player,
    ContentsModel model,
    Size realSize, {
    bool isPagePreview = false,
  }) {
    if (StudioVariables.isAutoPlay) {
      player?.play();
    } else {
      player?.pause();
    }

    String uri = model.getURI();
    String errMsg = '${model.name} uri is null';
    if (uri.isEmpty) {
      logger.fine(errMsg);
    }
    logger.fine("uri=<$uri>");
    player?.buttonIdle();

    //print('++++++++++++++++++++++playMusic+++++++++++');
    GlobalObjectKey<LeftMenuMusicState> musicKey =
        GlobalObjectKey<LeftMenuMusicState>('Music${model.parentMid.value}');
    musicKeyMap[model.parentMid.value] = musicKey;
    return SizedBox(
      width: realSize.width,
      height: realSize.height,
      child: LeftMenuMusic(
          key: musicKey, contentsManager: player!.acc, size: Size(realSize.width, realSize.height)),
    );
  }
}
