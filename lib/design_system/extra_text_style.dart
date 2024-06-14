import 'package:flutter/material.dart';

import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/common/creta_const.dart';
import '../pages/studio/studio_variables.dart';

class ExtraTextStyle {
  bool? isBold;
  bool? isUnderline;
  bool? isStrike;
  bool? isItalic;
  TextAlign? align;
  int? valign;
  Color? outLineColor;
  double? outLineWidth;

  void set(ContentsModel model) {
    isBold = model.isBold.value;
    isUnderline = model.isUnderline.value;
    isStrike = model.isStrike.value;
    isItalic = model.isItalic.value;
    align = model.align.value;
    valign = model.valign.value;
    outLineColor = model.outLineColor.value;
    outLineWidth = model.outLineWidth.value;
  }

  void setExtraTextStyle(ContentsModel model) {
    if (isBold != null) {
      model.isBold.set(isBold!, save: false);
    }
    if (isUnderline != null) {
      model.isUnderline.set(isUnderline!, save: false);
    }
    if (isStrike != null) {
      model.isStrike.set(isStrike!, save: false);
    }
    if (isItalic != null) {
      model.isItalic.set(isItalic!, save: false);
    }
    if (align != null) {
      model.align.set(align!, save: false);
    }
    if (valign != null) {
      model.valign.set(valign!, save: false);
    }
    if (outLineColor != null) {
      model.outLineColor.set(outLineColor!, save: false);
    }
    if (outLineWidth != null) {
      model.outLineWidth.set(outLineWidth!, save: false);
    }
    model.save();
  }

  //  서식 복사용 클립보드
  static TextStyle? _styleInClipBoard;
  static ExtraTextStyle? _extraStyleInClipBoard;
  static TextStyle? get sytleInClipBoard => _styleInClipBoard;
  static void setStyleInClipBoard(ContentsModel model, BuildContext? context) {
    _styleInClipBoard = model.makeTextStyle(context, applyScale: StudioVariables.applyScale);
    _extraStyleInClipBoard ??= ExtraTextStyle();
    _extraStyleInClipBoard?.set(model);
  }

  static void pasteStyle(ContentsModel model) {
    if (_styleInClipBoard != null) {
      model.setTextStyle(_styleInClipBoard!,
          StudioVariables.applyScale /* doNotChangeFontSize: model.isAutoFrameOrSide()*/
          );
    }
    _extraStyleInClipBoard?.setExtraTextStyle(model);
  }

  // 제일 마지막에 수정된 서식
  static TextStyle? _lastTextStyle;
  static ExtraTextStyle? _lastExtraTextStyle;
  static (TextStyle, ExtraTextStyle?) getLastTextStyle(BuildContext context) {
    ExtraTextStyle._lastTextStyle ??= DefaultTextStyle.of(context)
        .style
        .copyWith(fontSize: CretaConst.defaultFontSize * StudioVariables.applyScale);

    if (_lastTextStyle!.fontSize == null) {
      _lastTextStyle = _lastTextStyle!
          .copyWith(fontSize: CretaConst.defaultFontSize * StudioVariables.applyScale);
    }
    return (_lastTextStyle!, _lastExtraTextStyle);
  }

  static void setLastTextStyle(TextStyle style, ContentsModel? model) {
    //print('setLastTextStyle(${style.fontFamily})');
    _lastTextStyle = style;
    if (model != null) {
      _lastExtraTextStyle ??= ExtraTextStyle();
      _lastExtraTextStyle?.set(model);
    }
  } // 마지막에 사용자가 선택한 폰트체를 기억하고 있다
}
