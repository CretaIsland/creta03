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
      ];

  void initMixin(String mid) {
    width = UndoAble<double>(0, mid);
    height = UndoAble<double>(0, mid);

    bgColor1 = UndoAble<Color>(Colors.white, mid);
    bgColor2 = UndoAble<Color>(Colors.blue, mid);
    opacity = UndoAble<double>(1, mid);
    gradationType = UndoAble<GradationType>(GradationType.none, mid);
    textureType = UndoAble<TextureType>(TextureType.none, mid);
    transitionEffect = UndoAble<int>(0, mid);
    isFixedRatio = UndoAble<bool>(false, mid);
    effect = UndoAble<EffectType>(EffectType.none, mid);
    eventReceive = UndoAble<String>('', mid);
    showWhenEventReceived = UndoAble<bool>(false, mid);
    durationType = UndoAble<DurationType>(DurationType.none, mid);
    duration = UndoAble<int>(0, mid);
  }

  void makeSampleMixin(String mid) {
    width = UndoAble<double>(600, mid);
    height = UndoAble<double>(400, mid);

    bgColor1 = UndoAble<Color>(Colors.white, mid);
    bgColor2 = UndoAble<Color>(Colors.blue, mid);
    opacity = UndoAble<double>(1, mid);
    gradationType = UndoAble<GradationType>(GradationType.none, mid);
    textureType = UndoAble<TextureType>(TextureType.none, mid);

    transitionEffect = UndoAble<int>(0, mid);
    isFixedRatio = UndoAble<bool>(false, mid);
    effect = UndoAble<EffectType>(EffectType.none, mid);
    eventReceive = UndoAble<String>('', mid);
    showWhenEventReceived = UndoAble<bool>(false, mid);
    durationType = UndoAble<DurationType>(DurationType.none, mid);
    duration = UndoAble<int>(0, mid);
  }

  void copyFromMixin(String mid, CretaStyleMixin src) {
    width = UndoAble<double>(src.width.value, mid);
    height = UndoAble<double>(src.height.value, mid);

    bgColor1 = UndoAble<Color>(src.bgColor1.value, mid);
    bgColor2 = UndoAble<Color>(src.bgColor2.value, mid);
    opacity = UndoAble<double>(src.opacity.value, mid);
    gradationType = UndoAble<GradationType>(src.gradationType.value, mid);
    textureType = UndoAble<TextureType>(src.textureType.value, mid);
    transitionEffect = UndoAble<int>(src.transitionEffect.value, mid);
    isFixedRatio = UndoAble<bool>(src.isFixedRatio.value, mid);
    effect = UndoAble<EffectType>(src.effect.value, mid);
    eventReceive = UndoAble<String>(src.eventReceive.value, mid);
    showWhenEventReceived = UndoAble<bool>(src.showWhenEventReceived.value, mid);
    durationType = UndoAble<DurationType>(src.durationType.value, mid);
    duration = UndoAble<int>(src.duration.value, mid);
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
    };
  }
}
