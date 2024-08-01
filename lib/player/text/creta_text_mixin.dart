// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:neonpen/neonpen.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';
import 'package:uuid/uuid.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_const.dart';

import '../../common/creta_utils.dart';
import '../../design_system/component/autoSizeText/creta_auto_size_text.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../pages/studio/book_main_page.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_getx_controller.dart';
import '../../pages/studio/studio_variables.dart';
//import 'creta_scrolled_text.dart';
import 'creta_text_player.dart';
import 'creta_text_switcher.dart';
import 'custom_scroll_controller.dart';

mixin CretaTextMixin {
  double applyScale = 1;
  FrameEventController? sendEvent;
  int _currentIndex = 0;

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
    (style, uri, fontSize) = model.makeInfo(context, applyScale, isThumbnail, realSize: realSize);

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
    //   fontSize = CretaConst.maxFontSize * applyScale;
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

    // print(
    //     '-----applyScale=$applyScale, padding=$padding, realSize=$realSize, isThumbnail=$isThumbnail');

    //print('playText ${model.autoSizeType.value}');

    if (model.isAutoFrameOrSide() && isThumbnail == false) {
      // 자동 프레임사이즈를 결정해 주어야 한다.
      //print('AutoSizeType.autoFrameSize before ${realSize.height}');
      //late double frameWidth;
      //print('old frame size ${realSize.height}');
      late double frameWidth;
      late double frameHeight;
      (frameWidth, frameHeight) = CretaUtils.getTextBoxSize(
        uri,
        model.autoSizeType.value,
        realSize.width,
        realSize.height,
        style,
        model.align.value,
        padding,
        model.outLineWidth.value,
      );
      //print('new frame size $frameHeight');
      //realSize = Size(frameWidth, frameHeight);
      if (model.isAutoFrameSize()) {
        if (realSize.width.round() != frameWidth.round()) {
          realSize = Size(frameWidth, frameHeight);
          //print('frame size changed ${realSize.height.round()} --> ${frameHeight.round()}');
        }
      } else {
        if (realSize.height.round() != frameHeight.round()) {
          realSize = Size(realSize.width, frameHeight);
          //print('frame size changed ${realSize.height.round()} --> ${frameHeight.round()}');
        }
      }
    }
    // print(
    //     'AutoSizeType.autoFrameSize after isThumbnail=$isThumbnail, ${realSize.width},${realSize.height} ');

    return Container(
      color: Colors.transparent,
      // padding: model.isAutoFontSize()
      //     ? EdgeInsets.symmetric(
      //         vertical: padding, horizontal: padding + (CretaConst.stepGranularity))
      //     : EdgeInsets.all(padding),

      padding: EdgeInsets.all(padding),
      alignment:
          CretaTextPlayer.toAlign(model.align.value, intToTextAlignVertical(model.valign.value)),
      width: realSize.width,
      height: realSize.height,

      child: (player != null &&
              (player.acc.frameModel.isEditMode == true) &&
              isThumbnail == false) // 에디트 모드에서는 글자를 표시하지 않는다.
          ? const SizedBox.shrink()
          // : SizedBox(
          //     width: double.infinity,
          //     height: double.infinity,
          //     //color: Colors.amber,
          //     child: _playText(model, uri, style, fontSize, realSize, isThumbnail)),
          : _playText(model, uri, style, fontSize, realSize, isThumbnail),
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

    if (model.aniType.value != TextAniType.none &&
        isThumbnail == false &&
        StudioVariables.isAutoPlay == true) {
      return _animationText(
        model,
        text,
        shadowStyle ?? style,
        // _outLineAndShadowText(
        //   model,
        //   text,
        //   shadowStyle ?? style,
        //   isThumbnail,
        // ),
        realSize,
        fontSize,
        isThumbnail,
      );
    }
    if (model.aniType.value.isTransition()) {
      List<String> lines = text.split('\n');
      if (_currentIndex >= lines.length) _currentIndex = 0;
      return _outLineAndShadowText(model, lines[_currentIndex], shadowStyle ?? style, isThumbnail);
    }
    return _outLineAndShadowText(model, text, shadowStyle ?? style, isThumbnail);
  }

  // TextStyle _getOutLineStyle(ContentsModel? model, TextStyle style) {
  //   return style.copyWith(
  //     foreground: Paint()
  //       ..style = PaintingStyle.stroke
  //       ..strokeWidth = model!.outLineWidth.value * applyScale
  //       ..color = model.outLineColor.value,
  //   );
  // }

  Widget _outLineAndShadowText(ContentsModel? model, String text, TextStyle style, bool isThumbnail,
      {Key? key, bool sendEvent = true}) {
    //print('_outLineAndShadowText');

    Widget realText = model!.isAutoFontSize()
        ? CretaAutoSizeText(
            key: key,
            text,
            mid: model.mid,
            fontSizeChanged: (value) {
              if (isThumbnail == false && sendEvent == true) {
                logger.info('fontSize changed !!! , isThumbnail=$isThumbnail');
                //print('fontSize changed !!!');
                model.updateByAutoSize(value, applyScale);
                CretaAutoSizeText.fontSizeNotifier?.stop(); // rightMenu 에 전달
                //BookMainPage.containeeNotifier!.notify(); // rightMenu 에 전달
              }
            },
            textAlign: model.align.value,
            style: style,
            stepGranularity: CretaConst.stepGranularity,
            minFontSize: CretaConst.minFontSize,
            //textScaleFactor: (model.scaleFactor.value / 100) * applyScale
          )
        : Text(
            key: key,
            text,
            textAlign: model.align.value,
            style: style,
            //textScaleFactor: (model.scaleFactor.value / 100) * applyScale
          );

    // 새도우의 경우.
    // 아직 구현안함.

    // transition 은 아웃라인이 안된다...
    if (model.outLineWidth.value > 0 && model.aniType.value.isTransition() == false) {
      // 아웃라인의 경우.
      TextStyle outlineStyle = model.addOutLineStyle(style, applyScale: applyScale);

      Widget shadow = model.isAutoFontSize()
          ? CretaAutoSizeText(
              text,
              mid: model.mid,
              textAlign: model.align.value,
              style: outlineStyle,
              stepGranularity: CretaConst.stepGranularity,
              minFontSize: CretaConst.minFontSize,
            )
          : Text(
              text,
              textAlign: model.align.value,
              style: outlineStyle,
            );

      return Stack(
        alignment: AlignmentDirectional.center,
        children: [
          shadow,
          realText,
        ],
      );
    }

    // 아웃라인도 아니고, 애니매이션도 아닌 경우.
    return realText;
  }

  Widget _animationText(
    ContentsModel? model,
    String text,
    TextStyle style,
    //Widget? textWidget,
    Size realSize,
    double fontSize,
    bool isThumbnail,
  ) {
    int textSize = CretaCommonUtils.getStringSize(text);
    // duration 이 50 이면 실제로는 5초 정도에  문자열을 다 흘려보내다.
    // 따라서 문자열의 길이에  anyDuration / 10  정도의 값을 곱해본다.
    String key = const Uuid().v4();
    if (model!.aniType.value != TextAniType.tickerSide &&
        model.aniType.value != TextAniType.tickerUpDown &&
        model.aniType.value.isTransition() == false) {
      if (model.outLineWidth.value > 0) {
        style = style.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = model.outLineWidth.value * applyScale
            ..color = model.outLineColor.value,
        );
      }
      // 2023.10.09  아래코드는 더이상 필요가 없다.
      // if (model.aniType.value != TextAniType.shimmer && model.aniType.value != TextAniType.neon) {
      //   style = style.copyWith(fontSize: _getAutoFontSize(model, textSize, realSize, fontSize));
      // }
    }

    switch (model.aniType.value) {
      case TextAniType.fadeTransition:
      //case TextAniType.sizeTransition:
      case TextAniType.rotateTransition:
      case TextAniType.slideTransition:
      case TextAniType.scaleTransition:
      case TextAniType.randomTransition:
        {
          String input = text;
          int linesLen = text.split('\n').length;
          if (linesLen < 1) {
            input = 'Sample Text\nSample Text';
          } else if (linesLen < 2) {
            input = '$text\n$text';
          }
          List<String> lines = input.split('\n');
          linesLen = lines.length;
          double duration = (model.anyDuration.value / (linesLen + 1));
          int stopDuration = duration.ceil();
          int switchDuration = (duration / 4).ceil();

          return CretaTextSwitcher(
              text: input,
              stopDuration: Duration(seconds: stopDuration),
              switchDuration: Duration(seconds: switchDuration),
              aniType: model.aniType.value,
              builder: (index, eachLine) {
                _currentIndex = index;
                return _outLineAndShadowText(
                  key: ValueKey<int>(index),
                  model,
                  eachLine,
                  style,
                  isThumbnail,
                  sendEvent: (model.aniType.value == TextAniType.randomTransition),
                );
              });
        }
      // case TextAniType.randomTransition:
      //   {
      //     String input = text;
      //     int linesLen = text.split('\n').length;
      //     if (linesLen < 1) {
      //       input = 'Sample Text\nSample Text';
      //     } else if (linesLen < 2) {
      //       input = '$text\n$text';
      //     }
      //     List<String> lines = input.split('\n');
      //     linesLen = lines.length;
      //     double duration = (model.anyDuration.value / (linesLen + 1));
      //     int stopDuration = duration.ceil();
      //     int switchDuration = (duration / 4).ceil();

      //     return CretaTextSwitcher(
      //         text: text,
      //         stopDuration: Duration(seconds: stopDuration),
      //         switchDuration: Duration(seconds: switchDuration),
      //         aniType: model.aniType.value,
      //         builder: (index, eachLine) {
      //           _currentIndex = index;
      //           return _outLineAndShadowText(
      //             key: ValueKey<int>(index),
      //             model,
      //             eachLine,
      //             style,
      //             isThumbnail,
      //           );
      //         });
      //   }
      case TextAniType.tickerSide:
        {
          int duration = textSize * ((101 - model.anyDuration.value) / 10).ceil();
          return ScrollLoopAutoScroll(
              key: ValueKey(key),
              // ignore: sort_child_properties_last
              child: _outLineAndShadowText(
                model,
                text.replaceAll('\n', ' '),
                style,
                isThumbnail,
                sendEvent: false,
              ),
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
          //int duration = (textSize * 0.5).ceil() * ((101 - model.anyDuration.value) / 10).ceil();
          return CustomScrollController(
              text: text,
              realSize: realSize,
              duration: model.anyDuration.value.ceil(),
              stopSeconds: 2,
              textStyle: style,
              builder: (index, text) {
                return _outLineAndShadowText(
                  model,
                  text,
                  style,
                  isThumbnail,
                  sendEvent: false,
                );
              });
          //return CretaScrolledText(
          //   key: ValueKey(key),
          //   // ignore: sort_child_properties_last
          //   child: _outLineAndShadowText(
          //     model,
          //     text,
          //     style,
          //     isThumbnail,
          //   ),
          //   style: style,
          //   text: text,
          //   realSize: realSize,
          //   stopSeconds: 2,
          //   scrollDirection: Axis.vertical, //required
          //   delay: const Duration(seconds: 1),
          //   duration: Duration(
          //       seconds: (model.anyDuration.value.ceil() / (text.split('\n').length + 1)).ceil()),
          //   gap: 25,
          //   reverseScroll: false,
          //   duplicateChild: 25,
          //   enableScrollInput: true,
          //   delayAfterScrollInput: const Duration(seconds: 1),
          // );
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
              child: model.isAutoFontSize()
                  ? CretaAutoSizeText(
                      text,
                      mid: model.mid,
                      fontSizeChanged: (value) {
                        if (isThumbnail == false) {
                          model.updateByAutoSize(value, applyScale);
                          BookMainPage.containeeNotifier!.notify(); // rightMenu 에 전달
                        }
                      },
                      textAlign: model.align.value,
                      style: style,
                      stepGranularity: CretaConst.stepGranularity,
                      minFontSize: CretaConst.minFontSize,
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
            text: model.isAutoFontSize()
                ? CretaAutoSizeText(
                    text,
                    mid: model.mid,
                    fontSizeChanged: (value) {
                      if (isThumbnail == false) {
                        model.updateByAutoSize(value, applyScale);
                        BookMainPage.containeeNotifier!.notify(); // rightMenu 에 전달
                      }
                    },
                    textAlign: model.align.value,
                    style: style,
                    stepGranularity: CretaConst.stepGranularity,
                    minFontSize: CretaConst.minFontSize,
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
        return model.isAutoFontSize()
            ? CretaAutoSizeText(
                text,
                mid: model.mid,
                fontSizeChanged: (value) {
                  if (isThumbnail == false) {
                    model.updateByAutoSize(value, applyScale);
                    BookMainPage.containeeNotifier!.notify(); // rightMenu 에 전달
                  }
                },
                textAlign: model.align.value,
                style: style,
                stepGranularity: CretaConst.stepGranularity,
                minFontSize: CretaConst.minFontSize,
              )
            : Text(
                text,
                textAlign: model.align.value,
                style: style,
              );
    }
  }
  // 2023.10.09  아래 코드는 더이상 사용되지 않는다.
  // double _getAutoFontSize(ContentsModel? model, int textSize, Size realSize, double fontSize) {
  //   //double fontSize = model!.fontSize.value;

  //   if (model!.isAutoFontSize()) {
  //     return fontSize;
  //   }
  //   // 텍스트 길이
  //   double entireWidth = fontSize * textSize; // 한줄로 했을때, 필요한 width
  //   int lineCount =
  //       (entireWidth / (0.9 * realSize.width)).ceil(); //  현재 폰트사이즈에서 현재 width 상황에서 필요한 라인수
  //   double idealWidth = fontSize * (textSize.toDouble() / lineCount.toDouble()); //
  //   double idealHeight = (lineCount + 1) * fontSize;

  //   // 이상적인 사이즈가 현재 사이즈보다 크다면, 폰트가 줄어들어야 하고,
  //   // 현재 사이즈보다 작다면,  폰트가 커져야 한다.
  //   double fontRatio = sqrt(realSize.width * realSize.height) / sqrt(idealWidth * idealHeight);

  //   fontSize *= fontRatio;
  //   double minFontSize = CretaConst.minFontSize / applyScale;
  //   if (fontSize < minFontSize) fontSize = minFontSize;
  //   return fontSize;
  //   //logHolder.log("font = ${model!.font.value}, fontRatio=$fontRatio, fontSize=$fontSize",
  //   //    level: 6);
  // }
}
