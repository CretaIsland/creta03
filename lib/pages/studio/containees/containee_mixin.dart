// ignore_for_file: prefer_const_constructors

import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:parallax_rain/parallax_rain.dart';
import 'package:snowfall/snowfall/snowfall_widget.dart';
import 'package:starsview/config/MeteoriteConfig.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';

import '../../../design_system/effect/confetti.dart';
import '../../../model/app_enums.dart';
import '../../../model/creta_style_mixin.dart';

mixin ContaineeMixin {
  Animate getAnimation(Widget target, List<AnimationType> animations) {
    Animate ani = target.animate();
    for (var ele in animations) {
      if (ele == AnimationType.fadeIn) {
        logger.finest('fadeIn');
        ani = ani.fadeIn().then();
      }
      if (ele == AnimationType.flip) {
        logger.finest('flip');
        ani = ani.flip().then();
      }
      if (ele == AnimationType.shake) {
        logger.finest('shake');
        ani = ani.shake().then();
      }
      if (ele == AnimationType.shimmer) {
        logger.finest('shimmer');
        ani = ani.shimmer().then();
      }
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
