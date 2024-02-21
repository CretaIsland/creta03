// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';

import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/model/app_enums.dart';


// ignore: must_be_immutable
mixin CretaStyleMixin {
  late UndoAble<double> width;
  late UndoAble<double> height;
  late UndoAble<Color> bgColor1;
  late UndoAble<Color> bgColor2;
  late UndoAble<double> opacity;
  late UndoAble<GradationType> gradationType;
  late UndoAble<TextureType> textureType;
  late UndoAble<int> transitionEffect; // 페이지가 시작할때
  late UndoAble<int> transitionEffect2; // 페이지가 끝날때
  late UndoAble<bool> isFixedRatio;
  late UndoAble<EffectType> effect;
  late UndoAble<String> eventReceive;
  late UndoAble<bool> showWhenEventReceived;
  late UndoAble<DurationType> durationType;
  late UndoAble<int> duration;
  late UndoAble<bool> isShow;

  bool dragOnMove = false; // 보관함에서, 프레임으로 drag 해서, 마우스 포인터가 frame 내부에 도착했을때,

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
    transitionEffect2 = UndoAble<int>(0, mid, 'transitionEffect2');
    isFixedRatio = UndoAble<bool>(false, mid, 'isFixedRatio');
    effect = UndoAble<EffectType>(EffectType.none, mid, 'effect');
    eventReceive = UndoAble<String>('', mid, 'eventReceive');
    showWhenEventReceived = UndoAble<bool>(false, mid, 'showWhenEventReceived');
    durationType = UndoAble<DurationType>(DurationType.none, mid, 'durationType');
    duration = UndoAble<int>(0, mid, 'duration');
    isShow = UndoAble<bool>(true, mid, 'isShow');
  }

  void makeSampleMixin(String mid, {double defaultWidth = 400, double defaultHeight = 600}) {
    width = UndoAble<double>(defaultWidth, mid, 'width');
    height = UndoAble<double>(defaultHeight, mid, 'height');

    bgColor1 = UndoAble<Color>(Colors.white, mid, 'bgColor1');
    bgColor2 = UndoAble<Color>(Colors.blue, mid, 'bgColor2');
    opacity = UndoAble<double>(1, mid, 'opacity');
    gradationType = UndoAble<GradationType>(GradationType.none, mid, 'gradationType');
    textureType = UndoAble<TextureType>(TextureType.none, mid, 'textureType');

    transitionEffect = UndoAble<int>(0, mid, 'transitionEffect');
    transitionEffect2 = UndoAble<int>(0, mid, 'transitionEffect2');
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

    //print('src.bgColor1 = ${src.bgColor1.value}');
    //print('bgColor1 = ${bgColor1.value}');

    opacity = UndoAble<double>(src.opacity.value, mid, 'opacity');
    gradationType = UndoAble<GradationType>(src.gradationType.value, mid, 'gradationType');
    textureType = UndoAble<TextureType>(src.textureType.value, mid, 'textureType');
    transitionEffect = UndoAble<int>(src.transitionEffect.value, mid, 'transitionEffect');
    transitionEffect2 = UndoAble<int>(src.transitionEffect2.value, mid, 'transitionEffect2');
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
    transitionEffect2.init(src.transitionEffect2.value);
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

    width.setDD(w == 0 ? 10 : w, save: false, noUndo: true);
    height.setDD(h == 0 ? 10 : h, save: false, noUndo: true);

    bgColor1.setDD(CretaCommonUtils.string2Color(map["bgColor1"])!, save: false, noUndo: true);
    bgColor2.setDD(CretaCommonUtils.string2Color(map["bgColor2"])!, save: false, noUndo: true);
    opacity.setDD(map["opacity"] ?? 1, save: false, noUndo: true);
    gradationType.setDD(GradationType.fromInt(map["gradationType"] ?? 0),
        save: false, noUndo: true);
    textureType.setDD(TextureType.fromInt(map["textureType"] ?? 0), save: false, noUndo: true);
    transitionEffect.setDD(map["transitionEffect"] ?? 0, save: false, noUndo: true);
    transitionEffect2.setDD(map["transitionEffect2"] ?? 0, save: false, noUndo: true);
    isFixedRatio.setDD(map["isFixedRatio"] ?? false, save: false, noUndo: true);
    effect.setDD(EffectType.fromInt(map["effect"] ?? 0), save: false, noUndo: true);
    eventReceive.setDD(map["eventReceive"] ?? '', save: false, noUndo: true);
    showWhenEventReceived.setDD(map["showWhenEventReceived"] ?? false, save: false, noUndo: true);
    durationType.setDD(DurationType.fromInt(map["durationType"] ?? 0), save: false, noUndo: true);
    duration.setDD(map["duration"] ?? 0, save: false, noUndo: true);
    isShow.setDD(map["isShow"] ?? true, save: false, noUndo: true);
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
      "transitionEffect2": transitionEffect2.value,
      "isFixedRatio": isFixedRatio.value,
      "effect": effect.value.index,
      "eventReceive": eventReceive.value,
      "showWhenEventReceived": showWhenEventReceived.value,
      "durationType": durationType.value.index,
      "duration": duration.value,
      "isShow": isShow.value,
    };
  }

  Duration getPageDuration() {
    if (duration.value < 1 || duration.value > 5) {
      return Duration(seconds: 2);
    }
    return Duration(seconds: duration.value);
  }
}
