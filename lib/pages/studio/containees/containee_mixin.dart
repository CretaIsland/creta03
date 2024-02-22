// ignore_for_file: prefer_const_constructors

import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:snowfall/snowfall/snowfall_widget.dart';
import 'package:starsview/config/MeteoriteConfig.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';

import '../../../design_system/effect/confetti.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/creta_style_mixin.dart';
import '../studio_variables.dart';

mixin ContaineeMixin {
  Animate getAnimation(
    Widget target,
    List<AnimationType> animations,
    String mid, {
    Duration? duration,
    Duration? delay,
    int repeat = 0,
    bool reverse = false,
  }) {
    duration ??= 2000.ms;
    delay ??= 50.ms;

    Animate ani = target.animate(
      key: GlobalKey(),
      onPlay: (controller) {
        if (repeat == 0) {
          controller.repeat(reverse: reverse);
        } else {
          controller.loop(count: repeat);
        }
      }, //repeat
    );
    for (var ele in animations) {
      if (ele == AnimationType.fadeIn) {
        ani = ani.fadeIn(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.flip) {
        ani = ani.flip(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.shake) {
        ani = ani.shake(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.blurXY) {
        ani = ani.blurXY(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.rotate) {
        ani = ani.rotate(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.slideX) {
        ani = ani.slideX(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.slideY) {
        ani = ani.slideY(duration: duration, delay: delay); //.then();
      }
      if (ele == AnimationType.scaleXY) {
        if (LinkParams.connectedClass == 'page' || mid != LinkParams.connectedMid) {
          ani = ani.scaleXY(duration: duration, delay: delay); //.then();
        }
      }
      //  else if (LinkParams.connectedClass == 'page') {
      //   ani = ani
      //       .scaleXY(duration: const Duration(milliseconds: 750), curve: Curves.easeInOut)
      //       .move(
      //           duration: const Duration(milliseconds: 1500),
      //           curve: Curves.easeInOut,
      //           begin: LinkParams.linkPostion! + LinkParams.orgPostion!); // -
      //   // Offset(frameWidth / 2, frameHeight / 2) -
      //   // Offset(posX, posY))
      // }
    }
    return ani;
  }

  Widget effectWidget(CretaStyleMixin model) {
    switch (model.effect.value) {
      case EffectType.conffeti:
        return ConfettiEffect();
      case EffectType.snow:
        return SnowfallWidget(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      case EffectType.rain:
        return ParallaxRain(
          dropColors: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.brown,
            Colors.blueGrey
          ],
          dropHeight: 10,
          dropFallSpeed: 3,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        );

      case EffectType.bubble:
        return Positioned.fill(
          child: FloatingBubbles.alwaysRepeating(
            noOfBubbles: 50,
            colorsOfBubbles: const [
              Colors.white,
              Colors.red,
            ],
            sizeFactor: 0.2,
            opacity: 70,
            speed: BubbleSpeed.slow,
            paintingStyle: PaintingStyle.fill,
            shape: BubbleShape.circle, //This is the default
          ),
          // FloatingBubbles(
          //   noOfBubbles: 25,
          //   colorsOfBubbles: [
          //     Colors.green.withAlpha(30),
          //     Colors.red,
          //   ],
          //   sizeFactor: 0.16,
          //   duration: 120, // 120 seconds.
          //   opacity: 70,
          //   paintingStyle: PaintingStyle.stroke,
          //   strokeWidth: 8,
          //   shape: BubbleShape
          //       .circle, // circle is the default. No need to explicitly mention if its a circle.
          //   speed: BubbleSpeed.normal, // normal is the default
          // ),
        );
      case EffectType.star:
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Colors.red,
                    Colors.blue,
                  ],
                ),
              ),
            ),
            StarsView(
              fps: 60,
              starsConfig: StarsConfig(
                maxStarSize: 6,
                colors: [
                  Colors.white,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.lightBlue,
                  Colors.lightGreen
                ],
              ),
              meteoriteConfig: MeteoriteConfig(
                maxMeteoriteSize: 10,
                colors: [
                  Colors.white,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.lightBlue,
                  Colors.lightGreen
                ],
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }
}
