import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../model/app_enums.dart';

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
}
