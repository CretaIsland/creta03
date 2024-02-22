// ignore_for_file: depend_on_referenced_packages
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../pages/studio/book_main_page.dart';
import '../../pages/studio/left_menu/music/music_player_frame.dart';
import 'package:creta_common/common/creta_const.dart';

import '../../pages/studio/studio_variables.dart';
import 'creta_music_player.dart';

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
    GlobalObjectKey<MusicPlayerFrameState>? musicKey =
        BookMainPage.musicKeyMap[model.parentMid.value];
    if (musicKey == null) {
      musicKey = GlobalObjectKey<MusicPlayerFrameState>('Music${model.parentMid.value}');
      BookMainPage.musicKeyMap[model.parentMid.value] = musicKey;
    }
    // debugPrint('musicKeyMap $musicKeyMap-----------------');
    return SizedBox(
      width: realSize.width,
      height: realSize.height,
      child: MusicPlayerFrame(
        key: musicKey,
        contentsManager: player!.acc,
        size: Size(realSize.width, realSize.height),
      ),
    );
  }

  Widget showBGM(double applyScale) {
    return Opacity(
      opacity: 0.2,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            //child: const Icon(Icons.music_note_outlined, size: 40),
          ),
          Transform.rotate(
              angle: -math.pi / 6,
              child: TextAnimator(
                'B.G.M.',
                incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(),
                atRestEffect: WidgetRestingEffects.fidget(),
                style: CretaFont.titleELarge.copyWith(
                    color: CretaColor.secondary, fontSize: CretaConst.defaultFontSize * applyScale),
                textAlign: TextAlign.center,
              )),
        ],
      ),
    );
  }
}
