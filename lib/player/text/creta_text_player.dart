// ignore: implementation_imports
// ignore_for_file: prefer_final_fields, depend_on_referenced_packages, must_be_immutable
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:uuid/uuid.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:shimmer/shimmer.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:hycop/common/util/logger.dart';

import '../../common/creta_utils.dart';
import '../../model/app_enums.dart';
import '../../pages/studio/studio_constant.dart';
import '../creta_abs_player.dart';
import 'tts.dart';

class CretaTextPlayer extends CretaAbsPlayer {
  CretaTextPlayer({
    required super.keyString,
    required super.model,
    required super.acc,
    super.onAfterEvent,
  });

  MyTTS? tts;

  @override
  Future<void> mute() async {
    model!.mute.set(!model!.mute.value);
  }

  @override
  Future<void> play({bool byManual = false}) async {
    logger.fine('text play');
    model!.setPlayState(PlayState.start);
    if (byManual) {
      model!.setManualState(PlayState.start);
    }
    if (model!.isTTS.value == true && model!.mute.value == false) {
      tts ??= MyTTS();
      tts!.setLang(StudioConst.code2TTSMap[model!.lang.value] ?? StudioConst.ttsCodes[0]);
      tts!.speak(model!.remoteUrl!);
    }
  }

  @override
  Future<void> pause({bool byManual = false}) async {
    model!.setPlayState(PlayState.pause);
    if (model!.isTTS.value == true && tts != null) {
      tts!.stop();
    }
  }

  @override
  void stop() {
    logger.info("text player stop,${model!.name}");
    //widget.wcontroller!.dispose();
    super.stop();
    model!.setPlayState(PlayState.stop);
    if (model!.isTTS.value == true && tts != null) {
      tts!.stop();
    }
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

  // Future<double> getImageInfo(String url) async {
  //   var response = await http.get(Uri.parse(url));
  //   final bytes = response.bodyBytes;
  //   final Codec codec = await instantiateImageCodec(bytes);
  //   final FrameInfo frame = await codec.getNextFrame();
  //   final uiImage = frame.image; // a ui.Image object, not to be confused with the Image widget

  //   return uiImage.width / uiImage.height;
  // }

  @override
  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      onAfterEvent?.call(Duration.zero, Duration.zero);
    });
  }

  Widget playText(String text, TextStyle style, double fontSize, Size realSize) {
    //logHolder.log('playText ${model!.outLineWidth.value} ${model!.aniType.value}',level: 6);

    TextStyle? shadowStyle;
    if (model!.shadowBlur.value > 0) {
      //logHolder.log('model!.shadowBlur.value=${model!.shadowBlur.value}', level: 6);
      shadowStyle = style.copyWith(shadows: [
        Shadow(
            color: model!.shadowColor.value.withOpacity(model!.shadowIntensity.value),
            offset: Offset(model!.shadowBlur.value * 0.75, model!.shadowBlur.value * 0.75),
            blurRadius: model!.shadowBlur.value),
      ]);
    }

    if (model!.aniType.value != TextAniType.none) {
      return animationText(
          text, shadowStyle ?? style, outLineAndShadowText(text, shadowStyle ?? style), realSize);
    }
    return outLineAndShadowText(text, shadowStyle ?? style);
  }

  TextStyle getOutLineStyle(TextStyle style) {
    return style.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = model!.outLineWidth.value
        ..color = model!.outLineColor.value,
    );
  }

  Widget outLineAndShadowText(String text, TextStyle style) {
    // 새도우의 경우.

    // 아웃라인의 경우.
    if (model!.outLineWidth.value > 0) {
      TextStyle outlineStyle = getOutLineStyle(style);

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          model!.isAutoSize.value
              ? AutoSizeText(text, textAlign: model!.align.value, style: outlineStyle)
              : Text(text, textAlign: model!.align.value, style: outlineStyle),
          model!.isAutoSize.value
              ? AutoSizeText(text, textAlign: model!.align.value, style: style)
              : Text(text, textAlign: model!.align.value, style: style),
        ],
      );
    }

    // 아웃라인도 아니고, 애니매이션도 아닌 경우.
    return model!.isAutoSize.value
        ? AutoSizeText(text, textAlign: model!.align.value, style: style)
        : Text(text, textAlign: model!.align.value, style: style);
  }

  Widget animationText(String text, TextStyle style, Widget? textWidget, Size realSize) {
    int textSize = CretaUtils.getStringSize(text);
    // duration 이 50 이면 실제로는 5초 정도에  문자열을 다 흘려보내다.
    // 따라서 문자열의 길이에  anyDuration / 10  정도의 값을 곱해본다.

    String key = const Uuid().v4();
    if (model!.aniType.value != TextAniType.tickerSide &&
        model!.aniType.value != TextAniType.tickerUpDown) {
      if (model!.outLineWidth.value > 0) {
        style = style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = model!.outLineWidth.value
            ..color = model!.outLineColor.value,
        );
      }
      if (model!.aniType.value != TextAniType.shimmer) {
        style = style.copyWith(fontSize: getAutoFontSize(textSize, realSize));
      }
    }

    switch (model!.aniType.value) {
      case TextAniType.tickerSide:
        {
          int duration = textSize * ((101 - model!.anyDuration.value) / 10).ceil();
          return ScrollLoopAutoScroll(
              key: ValueKey(key),
              // ignore: sort_child_properties_last
              child: outLineAndShadowText(text.replaceAll('\n', ' '), style),
              scrollDirection: Axis.horizontal,
              delay: const Duration(seconds: 1),
              duration: Duration(seconds: duration),
              gap: 25,
              reverseScroll: false,
              duplicateChild: 25,
              enableScrollInput: true,
              delayAfterScrollInput: const Duration(seconds: 1));
        }
      case TextAniType.tickerUpDown:
        {
          int duration = (textSize * 0.5).ceil() * ((101 - model!.anyDuration.value) / 10).ceil();
          return ScrollLoopAutoScroll(
              key: ValueKey(key),
              // ignore: sort_child_properties_last
              child: outLineAndShadowText(text, style),
              scrollDirection: Axis.vertical, //required
              delay: const Duration(seconds: 1),
              duration: Duration(seconds: duration),
              gap: 25,
              reverseScroll: false,
              duplicateChild: 25,
              enableScrollInput: true,
              delayAfterScrollInput: const Duration(seconds: 1));
        }
      case TextAniType.rotate:
        {
          int duration = 600 - model!.anyDuration.value.round();

          return TextAnimator(
            text,
            key: ValueKey(key),
            atRestEffect: WidgetRestingEffects.rotate(),
            incomingEffect: WidgetTransitionEffects(
                blur: const Offset(2, 2), duration: Duration(milliseconds: duration)),
            outgoingEffect: WidgetTransitionEffects(
                blur: const Offset(2, 2), duration: Duration(milliseconds: duration)),
            style: style,
            textAlign: model!.align.value,
          );
        }
      case TextAniType.bounce:
        {
          int duration = 2000 - (model!.anyDuration.value * 10).round();
          return TextAnimator(
            text,
            key: ValueKey(key),
            incomingEffect: WidgetTransitionEffects.incomingScaleDown(
                duration: Duration(milliseconds: duration)),
            atRestEffect: WidgetRestingEffects.bounce(),
            //outgoingEffect: WidgetTransitionEffects.outgoingScaleUp(),
            // onIncomingAnimationComplete: (key) async {
            //   logHolder.log("TextAniType.bounce onIncomingAnimationComplete()", level: 6);
            //   await Future.delayed(Duration(milliseconds: duration * 8));
            //   setState(() {});
            // },
            style: style,
            textAlign: model!.align.value,
          );
        }
      case TextAniType.fidget:
        {
          //int duration = 2000 - (model!.anyDuration.value * 10).round();
          return TextAnimator(
            text,
            key: ValueKey(key),
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(),
            atRestEffect: WidgetRestingEffects.fidget(),
            //outgoingEffect: WidgetTransitionEffects.outgoingSlideOutToBottom(),
            // onIncomingAnimationComplete: (key) async {
            //   logHolder.log("TextAniType.bounce onIncomingAnimationComplete()", level: 6);
            //   await Future.delayed(Duration(milliseconds: duration * 8));
            //   setState(() {});
            // },
            style: style,
            textAlign: model!.align.value,
          );
        }
      case TextAniType.fade:
        {
          //int duration = 2000 - (model!.anyDuration.value * 10).round();
          return TextAnimator(
            text,
            key: ValueKey(key),
            incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(),
            atRestEffect: WidgetRestingEffects.pulse(),
            style: style,
            textAlign: model!.align.value,
          );
        }
      case TextAniType.shimmer:
        {
          int duration = 11000 - (model!.anyDuration.value * 100).round();
          return Shimmer.fromColors(
              key: ValueKey(key),
              period: Duration(milliseconds: duration),
              baseColor: model!.fontColor.value,
              highlightColor: model!.outLineColor.value,
              child: model!.isAutoSize.value
                  ? AutoSizeText(text, textAlign: model!.align.value, style: style)
                  : Text(text, textAlign: model!.align.value, style: style));
        }
      case TextAniType.typewriter:
        {
          int duration = 505 - model!.anyDuration.value.round() * 5;

          return AnimatedTextKit(
            key: ValueKey(key),
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText(text,
                  textAlign: model!.align.value,
                  textStyle: style,
                  speed: Duration(milliseconds: duration)),
            ],
          );
        }
      case TextAniType.wavy:
        {
          int duration = 505 - model!.anyDuration.value.round() * 5;

          return AnimatedTextKit(
            key: ValueKey(key),
            repeatForever: true,
            animatedTexts: [
              WavyAnimatedText(text,
                  textAlign: model!.align.value,
                  textStyle: style,
                  speed: Duration(milliseconds: duration)),
            ],
          );
        }
      default:
        return model!.isAutoSize.value
            ? AutoSizeText(
                text,
                textAlign: model!.align.value,
                style: style,
              )
            : Text(
                text,
                textAlign: model!.align.value,
                style: style,
              );
    }
  }

  double getAutoFontSize(int textSize, Size realSize) {
    double fontSize = model!.fontSize.value;

    if (model!.isAutoSize.value == false) {
      return fontSize;
    }
    // 텍스트 길이
    double entireWidth = fontSize * textSize; // 한줄로 했을때, 필요한 width
    int lineCount =
        (entireWidth / (0.9 * realSize.width)).ceil(); //  현재 폰트사이즈에서 현재 width 상황에서 필요한 라인수
    double idealWidth = fontSize * (textSize.toDouble() / lineCount.toDouble()); //
    double idealHeight = (lineCount + 1) * fontSize;

    // 이상적인 사이즈가 현재 사이즈보다 크다면, 폰트가 줄어들어야 하고,
    // 현재 사이즈보다 작다면,  폰트가 커져야 한다.
    double fontRatio = sqrt(realSize.width * realSize.height) / sqrt(idealWidth * idealHeight);
    return fontSize * fontRatio;
    //logHolder.log("font = ${model!.font.value}, fontRatio=$fontRatio, fontSize=$fontSize",
    //    level: 6);
  }
}
