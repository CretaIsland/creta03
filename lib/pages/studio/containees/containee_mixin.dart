import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../model/app_enums.dart';
import '../../../model/creta_style_mixin.dart';

mixin ContaineeMixin {
  Animate getAnimation(Widget target, List<AnimationType> animations) {
    Animate ani = target.animate();
    for (var ele in animations) {
      if (ele == AnimationType.fadeIn) {
        logger.fine('fadeIn');
        ani = ani.fadeIn().then();
      }
      if (ele == AnimationType.flip) {
        logger.fine('flip');
        ani = ani.flip().then();
      }
      if (ele == AnimationType.shake) {
        logger.fine('shake');
        ani = ani.shake().then();
      }
      if (ele == AnimationType.shimmer) {
        logger.fine('shimmer');
        ani = ani.shimmer().then();
      }
    }
    return ani;
  }

  TextureType getTextureType(CretaStyleMixin bookModel, CretaStyleMixin mddel) {
    if (mddel.bgColor1.value == Colors.transparent) {
      if (mddel.textureType.value == TextureType.none) {
        return bookModel.textureType.value;
      }
    }
    return mddel.textureType.value;
  }
}
