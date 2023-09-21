// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:neonpen/neonpen.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../../common/creta_utils.dart';
import '../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import '../../model/app_enums.dart';
import '../../model/contents_model.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_variables.dart';
import 'creta_text_player.dart';

mixin CretaTextMixin {
  double applyScale = 1;

  Widget playText(
    BuildContext context,
    CretaTextPlayer? player,
    ContentsModel model,
    Size realSize, {
    bool isThumbnail = false,
  }) {
    if (StudioVariables.isAutoPlay) {
      //model!.setPlayState(PlayState.start);
      player?.play();
    } else {
      //model!.setPlayState(PlayState.pause);
      player?.pause();
    }
    //Size outSize = widget.getOuterSize(widget.model!.aspectRatio.value);

    // double topLeft = player.acc.frameModel.radiusLeftTop.value;
    // double topRight = player.acc.frameModel.radiusRightTop.value;
    // double bottomLeft = player.acc.frameModel.radiusLeftBottom.value;
    // double bottomRight = player.acc.frameModel.radiusRightBottom.value;
    player?.buttonIdle();

    late TextStyle style;
    late String uri;
    late double fontSize;
    (style, uri, fontSize) = CretaTextPlayer.makeStyle(context, model, applyScale, isThumbnail);

    // String uri = model.getURI();
    // String errMsg = '${model.name} uri is null';
    // if (uri.isEmpty) {
    //   logger.fine(errMsg);
    // }
    // logger.fine("uri=<$uri>");

    // double fontSize = model.fontSize.value * applyScale;

    // if (model.autoSizeType.value == true &&
    //     (model.aniType.value != TextAniType.rotate ||
    //         model.aniType.value != TextAniType.bounce ||
    //         model.aniType.value != TextAniType.fade ||
    //         model.aniType.value != TextAniType.shimmer ||
    //         model.aniType.value != TextAniType.typewriter ||
    //         model.aniType.value != TextAniType.wavy ||
    //         model.aniType.value != TextAniType.fidget)) {
    //   fontSize = StudioConst.maxFontSize * applyScale;
    // }
    // //fontSize = fontSize.roundToDouble();
    // if (fontSize == 0) fontSize = 1;

    // FontWeight? fontWeight = StudioConst.fontWeight2Type[model.fontWeight.value];

    // TextStyle style = DefaultTextStyle.of(context).style.copyWith(
    //     height: (model.lineHeight.value / 10) * applyScale, // 행간
    //     letterSpacing: model.letterSpacing.value * applyScale, // 자간,
    //     fontFamily: model.font.value,
    //     color: model.fontColor.value.withOpacity(model.opacity.value),
    //     fontSize: fontSize,
    //     decoration: (model.isUnderline.value && model.isStrike.value)
    //         ? TextDecoration.combine([TextDecoration.underline, TextDecoration.lineThrough])
    //         : model.isUnderline.value
    //             ? TextDecoration.underline
    //             : model.isStrike.value
    //                 ? TextDecoration.lineThrough
    //                 : TextDecoration.none,
    //     //fontWeight: model!.isBold.value ? FontWeight.bold : FontWeight.normal,
    //     fontWeight: fontWeight,
    //     fontStyle: model.isItalic.value ? FontStyle.italic : FontStyle.normal);

    // if (model.isBold.value) {
    //   style = style.copyWith(fontWeight: FontWeight.bold);
    // }

    // if (model.autoSizeType.value == false) {
    //   style.copyWith(
    //     fontSize: fontSize,
    //   );
    // }

    double padding = StudioConst.defaultTextPadding * applyScale;
    if (model.autoSizeType.value == AutoSizeType.autoFrameSize && isThumbnail == false) {
      // 자동 프레임사이즈를 결정해 주어야 한다.
      //print('AutoSizeType.autoFrameSize before ${realSize.height}');
      int lineCount = 0;
      double lineHeight = 1.0;
      (lineHeight, lineCount) =
          CretaUtils.getLineHeightAndCount(uri, realSize.width, style, model.align.value);
      realSize = Size(
          realSize.width,
          CretaUtils.resizeTextHeight(
            lineHeight,
            lineCount,
            padding,
          ));
    }
    //print('AutoSizeType.autoFrameSize after isThumbnail=$isThumbnail, ${realSize.height}');

    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.all(padding),
      alignment:
          CretaTextPlayer.toAlign(model.align.value, intToTextAlignVertical(model.valign.value)),
      width: realSize.width,
      height: realSize.height,
      child: (player != null &&
              player.acc.frameModel.isEditMode == true &&
              isThumbnail == false) // 에디트 모드에서는 글자를 표시하지 않는다.
          ? const SizedBox.shrink()
          : _playText(model, uri, style, fontSize, realSize, isThumbnail),
      //child: _playText(model, uri, style, fontSize, realSize, isThumbnail),
    );
  }

  Widget _playText(ContentsModel? model, String text, TextStyle style, double fontSize,
      Size realSize, bool isThumbnail) {
    //logHolder.log('playText ${model!.outLineWidth.value} ${model!.aniType.value}',level: 6);

    TextStyle? shadowStyle;
    if (model!.shadowBlur.value > 0) {
      double blur = model.shadowBlur.value * applyScale;
      //logHolder.log('model!.shadowBlur.value=${model!.shadowBlur.value}', level: 6);
      shadowStyle = style.copyWith(shadows: [
        Shadow(
            color: model.shadowColor.value.withOpacity(model.shadowIntensity.value),
            offset: Offset(blur * 0.75, blur * 0.75),
            blurRadius: blur),
      ]);
    }

    if (model.aniType.value != TextAniType.none && isThumbnail == false) {
      return _animationText(model, text, shadowStyle ?? style,
          _outLineAndShadowText(model, text, shadowStyle ?? style), realSize, fontSize);
    }
    return _outLineAndShadowText(model, text, shadowStyle ?? style);
  }

  // TextStyle _getOutLineStyle(ContentsModel? model, TextStyle style) {
  //   return style.copyWith(
  //     foreground: Paint()
  //       ..style = PaintingStyle.stroke
  //       ..strokeWidth = model!.outLineWidth.value * applyScale
  //       ..color = model.outLineColor.value,
  //   );
  // }

  Widget _outLineAndShadowText(ContentsModel? model, String text, TextStyle style) {
    // 새도우의 경우.

    // 아웃라인의 경우.
    if (model!.outLineWidth.value > 0) {
      TextStyle outlineStyle = model.addOutLineStyle(style, applyScale: applyScale);

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          model.autoSizeType.value == AutoSizeType.autoFontSize
              ? CretaAutoSizeText(
                  text,
                  mid: model.mid,
                  fontSizeChanged: (value) {
                    model.updateByAutoSize(value, applyScale);
                    //BookMainPage.containeeNotifier!.notify();
                  },
                  textAlign: model.align.value,
                  style: outlineStyle,
                )
              : Text(
                  text,
                  textAlign: model.align.value,
                  style: outlineStyle,
                ),
          model.autoSizeType.value == AutoSizeType.autoFontSize
              ? CretaAutoSizeText(
                  text,
                  mid: model.mid,
                  fontSizeChanged: (value) {
                    model.updateByAutoSize(value, applyScale);
                    //BookMainPage.containeeNotifier!.notify();
                  },
                  textAlign: model.align.value,
                  style: style,
                  //textScaleFactor: (model.scaleFactor.value / 100) * applyScale
                )
              : Text(
                  text,
                  textAlign: model.align.value,
                  style: style,
                  //textScaleFactor: (model.scaleFactor.value / 100) * applyScale
                ),
        ],
      );
    }

    // 아웃라인도 아니고, 애니매이션도 아닌 경우.
    return model.autoSizeType.value == AutoSizeType.autoFontSize
        ? CretaAutoSizeText(
            text,
            mid: model.mid,
            fontSizeChanged: (value) {
              model.updateByAutoSize(value, applyScale);
              //BookMainPage.containeeNotifier!.notify();
            },
            textAlign: model.align.value,
            style: style,
            //textScaleFactor: (model.scaleFactor.value / 100)
          )
        : Text(
            text,
            textAlign: model.align.value,
            style: style,
            //textScaleFactor: (model.scaleFactor.value / 100)
          );
  }

  Widget _animationText(ContentsModel? model, String text, TextStyle style, Widget? textWidget,
      Size realSize, double fontSize) {
    int textSize = CretaUtils.getStringSize(text);
    // duration 이 50 이면 실제로는 5초 정도에  문자열을 다 흘려보내다.
    // 따라서 문자열의 길이에  anyDuration / 10  정도의 값을 곱해본다.

    String key = const Uuid().v4();
    if (model!.aniType.value != TextAniType.tickerSide &&
        model.aniType.value != TextAniType.tickerUpDown) {
      if (model.outLineWidth.value > 0) {
        style = style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = model.outLineWidth.value * applyScale
            ..color = model.outLineColor.value,
        );
      }
      if (model.aniType.value != TextAniType.shimmer && model.aniType.value != TextAniType.neon) {
        style = style.copyWith(fontSize: _getAutoFontSize(model, textSize, realSize, fontSize));
      }
    }

    switch (model.aniType.value) {
      case TextAniType.tickerSide:
        {
          int duration = textSize * ((101 - model.anyDuration.value) / 10).ceil();
          return ScrollLoopAutoScroll(
              key: ValueKey(key),
              // ignore: sort_child_properties_last
              child: _outLineAndShadowText(model, text.replaceAll('\n', ' '), style),
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
          int duration = (textSize * 0.5).ceil() * ((101 - model.anyDuration.value) / 10).ceil();
          return ScrollLoopAutoScroll(
              key: ValueKey(key),
              // ignore: sort_child_properties_last
              child: _outLineAndShadowText(model, text, style),
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
          int duration = 600 - model.anyDuration.value.round();

          return TextAnimator(
            text,
            key: ValueKey(key),
            atRestEffect: WidgetRestingEffects.rotate(),
            incomingEffect: WidgetTransitionEffects(
                blur: const Offset(2, 2), duration: Duration(milliseconds: duration)),
            outgoingEffect: WidgetTransitionEffects(
                blur: const Offset(2, 2), duration: Duration(milliseconds: duration)),
            style: style,
            textAlign: model.align.value,
          );
        }
      case TextAniType.bounce:
        {
          int duration = 2000 - (model.anyDuration.value * 10).round();
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
            textAlign: model.align.value,
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
            textAlign: model.align.value,
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
            textAlign: model.align.value,
          );
        }
      case TextAniType.shimmer:
        {
          int duration = 11000 - (model.anyDuration.value * 100).round();
          return Shimmer.fromColors(
              key: ValueKey(key),
              period: Duration(milliseconds: duration),
              baseColor: model.fontColor.value,
              highlightColor: model.outLineColor.value,
              child: model.autoSizeType.value == AutoSizeType.autoFontSize
                  ? CretaAutoSizeText(
                      text,
                      mid: model.mid,
                      fontSizeChanged: (value) {
                        model.updateByAutoSize(value, applyScale);
                        //BookMainPage.containeeNotifier!.notify();
                      },
                      textAlign: model.align.value,
                      style: style,
                    )
                  : Text(
                      text,
                      textAlign: model.align.value,
                      style: style,
                    ));
        }
      case TextAniType.typewriter:
        {
          int duration = 505 - model.anyDuration.value.round() * 5;

          return AnimatedTextKit(
            key: ValueKey(key),
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText(text,
                  textAlign: model.align.value,
                  textStyle: style,
                  speed: Duration(milliseconds: duration)),
            ],
          );
        }
      case TextAniType.wavy:
        {
          int duration = 505 - model.anyDuration.value.round() * 5;

          return AnimatedTextKit(
            key: ValueKey(key),
            repeatForever: true,
            animatedTexts: [
              WavyAnimatedText(text,
                  textAlign: model.align.value,
                  textStyle: style,
                  speed: Duration(milliseconds: duration)),
            ],
          );
        }
      case TextAniType.neon:
        {
          return Neonpen(
            text: model.autoSizeType.value == AutoSizeType.autoFontSize
                ? CretaAutoSizeText(
                    text,
                    mid: model.mid,
                    fontSizeChanged: (value) {
                      model.updateByAutoSize(value, applyScale);
                      //BookMainPage.containeeNotifier!.notify();
                    },
                    textAlign: model.align.value,
                    style: style,
                  )
                : Text(text, textAlign: model.align.value, style: style),
            color: model.outLineColor.value == Colors.transparent
                ? Colors.red
                : model.outLineColor.value,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            opacity: 0.8,
            emphasisWidth: 20,
            emphasisOpacity: 0.5,
            emphasisAngleDegree: 3,
            enableLineZiggle: true,
            lineZiggleLevel: 3,
            isDoubleLayer: false,
          );
        }
      default:
        return model.autoSizeType.value == AutoSizeType.autoFontSize
            ? CretaAutoSizeText(
                text,
                mid: model.mid,
                fontSizeChanged: (value) {
                  model.updateByAutoSize(value, applyScale);
                  //BookMainPage.containeeNotifier!.notify();
                },
                textAlign: model.align.value,
                style: style,
              )
            : Text(
                text,
                textAlign: model.align.value,
                style: style,
              );
    }
  }

  double _getAutoFontSize(ContentsModel? model, int textSize, Size realSize, double fontSize) {
    //double fontSize = model!.fontSize.value;

    if (model!.autoSizeType.value == AutoSizeType.autoFontSize) {
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
