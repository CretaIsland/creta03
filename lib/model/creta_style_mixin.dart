// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';

import '../common/creta_utils.dart';
import 'app_enums.dart';

// ignore: must_be_immutable
mixin CretaStyleMixin {
  late UndoAble<double> width;
  late UndoAble<double> height;
  late UndoAble<Color> bgColor1;
  late UndoAble<Color> bgColor2;
  late UndoAble<double> opacity;
  late UndoAble<GradationType> gradationType;
  late UndoAble<TextureType> textureType;
  late UndoAble<int> transitionEffect;
  late UndoAble<bool> isFixedRatio;
  late UndoAble<EffectType> effect;
  late UndoAble<String> eventReceive;
  late UndoAble<bool> showWhenEventReceived;
  late UndoAble<DurationType> durationType;
  late UndoAble<int> duration;
  late UndoAble<bool> isShow;

  List<Object?> get propsMixin => [
        width,
        height,
        bgColor1,
        bgColor2,
        opacity,
        gradationType,
        textureType,
        isFixedRatio,
        effect,
        eventReceive,
        showWhenEventReceived,
        durationType,
        duration,
        isShow,
      ];

  void initMixin(String mid) {
    width = UndoAble<double>(0, mid, 'width');
    height = UndoAble<double>(0, mid, 'height');
    bgColor1 = UndoAble<Color>(Colors.white, mid, 'bgColor1');
    bgColor2 = UndoAble<Color>(Colors.blue, mid, 'bgColor2');
    opacity = UndoAble<double>(1, mid, 'opacity');
    gradationType = UndoAble<GradationType>(GradationType.none, mid, 'gradationType');
    textureType = UndoAble<TextureType>(TextureType.none, mid, 'textureType');
    transitionEffect = UndoAble<int>(0, mid, 'transitionEffect');
    isFixedRatio = UndoAble<bool>(false, mid, 'isFixedRatio');
    effect = UndoAble<EffectType>(EffectType.none, mid, 'effect');
    eventReceive = UndoAble<String>('', mid, 'eventReceive');
    showWhenEventReceived = UndoAble<bool>(false, mid, 'showWhenEventReceived');
    durationType = UndoAble<DurationType>(DurationType.none, mid, 'durationType');
    duration = UndoAble<int>(0, mid, 'duration');
    isShow = UndoAble<bool>(true, mid, 'isShow');
  }

  void makeSampleMixin(String mid) {
    width = UndoAble<double>(600, mid, 'width');
    height = UndoAble<double>(400, mid, 'height');

    bgColor1 = UndoAble<Color>(Colors.white, mid, 'bgColor1');
    bgColor2 = UndoAble<Color>(Colors.blue, mid, 'bgColor2');
    opacity = UndoAble<double>(1, mid, 'opacity');
    gradationType = UndoAble<GradationType>(GradationType.none, mid, 'gradationType');
    textureType = UndoAble<TextureType>(TextureType.none, mid, 'textureType');

    transitionEffect = UndoAble<int>(0, mid, 'transitionEffect');
    isFixedRatio = UndoAble<bool>(false, mid, 'isFixedRatio');
    effect = UndoAble<EffectType>(EffectType.none, mid, 'effect');
    eventReceive = UndoAble<String>('', mid, 'eventReceive');
    showWhenEventReceived = UndoAble<bool>(false, mid, 'showWhenEventReceived');
    durationType = UndoAble<DurationType>(DurationType.none, mid, 'durationType');
    duration = UndoAble<int>(0, mid, 'duration');
    isShow = UndoAble<bool>(true, mid, 'isShow');
  }

  void copyFromMixin(String mid, CretaStyleMixin src) {
    width = UndoAble<double>(src.width.value, mid, 'width');
    height = UndoAble<double>(src.height.value, mid, 'height');

    bgColor1 = UndoAble<Color>(src.bgColor1.value, mid, 'bgColor1');
    bgColor2 = UndoAble<Color>(src.bgColor2.value, mid, 'bgColor2');
    opacity = UndoAble<double>(src.opacity.value, mid, 'opacity');
    gradationType = UndoAble<GradationType>(src.gradationType.value, mid, 'gradationType');
    textureType = UndoAble<TextureType>(src.textureType.value, mid, 'textureType');
    transitionEffect = UndoAble<int>(src.transitionEffect.value, mid, 'transitionEffect');
    isFixedRatio = UndoAble<bool>(src.isFixedRatio.value, mid, 'isFixedRatio');
    effect = UndoAble<EffectType>(src.effect.value, mid, 'effect');
    eventReceive = UndoAble<String>(src.eventReceive.value, mid, 'eventReceive');
    showWhenEventReceived =
        UndoAble<bool>(src.showWhenEventReceived.value, mid, 'showWhenEventReceived');
    durationType = UndoAble<DurationType>(src.durationType.value, mid, 'durationType');
    duration = UndoAble<int>(src.duration.value, mid, 'duration');
    isShow = UndoAble<bool>(src.isShow.value, mid, 'isShow');
  }

  void updateFromMixin(CretaStyleMixin src) {
    width.init(src.width.value);
    height.init(src.height.value);
    bgColor1.init(src.bgColor1.value);
    bgColor2.init(src.bgColor2.value);
    opacity.init(src.opacity.value);
    gradationType.init(src.gradationType.value);
    textureType.init(src.textureType.value);
    transitionEffect.init(src.transitionEffect.value);
    isFixedRatio.init(src.isFixedRatio.value);
    effect.init(src.effect.value);
    eventReceive.init(src.eventReceive.value);
    showWhenEventReceived.init(src.showWhenEventReceived.value);
    durationType.init(src.durationType.value);
    duration.init(src.duration.value);
    isShow.init(src.isShow.value);
  }

  void fromMapMixin(Map<String, dynamic> map) {
    double w = map["width"] ?? 10;
    double h = map["height"] ?? 10;

    width.set(w == 0 ? 10 : w, save: false, noUndo: true);
    height.set(h == 0 ? 10 : h, save: false, noUndo: true);

    bgColor1.set(CretaUtils.string2Color(map["bgColor1"])!, save: false, noUndo: true);
    bgColor2.set(CretaUtils.string2Color(map["bgColor2"])!, save: false, noUndo: true);
    opacity.set(map["opacity"] ?? 1, save: false, noUndo: true);
    gradationType.set(GradationType.fromInt(map["gradationType"] ?? 0), save: false, noUndo: true);
    textureType.set(TextureType.fromInt(map["textureType"] ?? 0), save: false, noUndo: true);
    transitionEffect.set(map["transitionEffect"] ?? 0, save: false, noUndo: true);
    isFixedRatio.set(map["isFixedRatio"] ?? false, save: false, noUndo: true);
    effect.set(EffectType.fromInt(map["effect"] ?? 0), save: false, noUndo: true);
    eventReceive.set(map["eventReceive"] ?? '', save: false, noUndo: true);
    showWhenEventReceived.set(map["showWhenEventReceived"] ?? false, save: false, noUndo: true);
    durationType.set(DurationType.fromInt(map["durationType"] ?? 0), save: false, noUndo: true);
    duration.set(map["duration"] ?? 0, save: false, noUndo: true);
    isShow.set(map["isShow"] ?? true, save: false, noUndo: true);
  }

  Map<String, dynamic> toMapMixin() {
    return {
      "width": width.value,
      "height": height.value,
      "bgColor1": bgColor1.value.toString(),
      "bgColor2": bgColor2.value.toString(),
      "opacity": opacity.value,
      "gradationType": gradationType.value.index,
      "textureType": textureType.value.index,
      "transitionEffect": transitionEffect.value,
      "isFixedRatio": isFixedRatio.value,
      "effect": effect.value.index,
      "eventReceive": eventReceive.value,
      "showWhenEventReceived": showWhenEventReceived.value,
      "durationType": durationType.value.index,
      "duration": duration.value,
      "isShow": isShow.value,
    };
  }
}
