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

  List<Object?> get propsMixin => [
        width,
        height,
        bgColor1,
        bgColor2,
        opacity,
        gradationType,
        textureType,
        isFixedRatio,
      ];

  void initMixin(String mid) {
    width = UndoAble<double>(0, mid);
    height = UndoAble<double>(0, mid);

    bgColor1 = UndoAble<Color>(Colors.transparent, mid);
    bgColor2 = UndoAble<Color>(Colors.white, mid);
    opacity = UndoAble<double>(1, mid);
    gradationType = UndoAble<GradationType>(GradationType.none, mid);
    textureType = UndoAble<TextureType>(TextureType.none, mid);
    transitionEffect = UndoAble<int>(0, mid);
    isFixedRatio = UndoAble<bool>(false, mid);
  }

  void makeSampleMixin(String mid) {
    width = UndoAble<double>(200, mid);
    height = UndoAble<double>(200, mid);

    bgColor1 = UndoAble<Color>(Colors.transparent, mid);
    bgColor2 = UndoAble<Color>(Colors.white, mid);
    opacity = UndoAble<double>(1, mid);
    gradationType = UndoAble<GradationType>(GradationType.none, mid);
    textureType = UndoAble<TextureType>(TextureType.none, mid);

    transitionEffect = UndoAble<int>(0, mid);
    isFixedRatio = UndoAble<bool>(false, mid);
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
  }

  void fromMapMixin(Map<String, dynamic> map) {
    width.set(map["width"] ?? 0, save: false, noUndo: true);
    height.set(map["height"] ?? 0, save: false, noUndo: true);

    bgColor1.set(CretaUtils.string2Color(map["bgColor1"])!, save: false, noUndo: true);
    bgColor2.set(CretaUtils.string2Color(map["bgColor2"])!, save: false, noUndo: true);
    opacity.set(map["opacity"] ?? 1, save: false, noUndo: true);
    gradationType.set(GradationType.fromInt(map["gradationType"] ?? 0), save: false, noUndo: true);
    textureType.set(TextureType.fromInt(map["textureType"] ?? 0), save: false, noUndo: true);
    transitionEffect.set(map["transitionEffect"] ?? 0, save: false, noUndo: true);
    isFixedRatio.set(map["isFixedRatio"] ?? false, save: false, noUndo: true);
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
    };
  }
}
