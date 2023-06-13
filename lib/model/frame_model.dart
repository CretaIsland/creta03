// ignore_for_file: must_be_immutable

// import 'package:hycop/common/util/util.dart';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../common/creta_utils.dart';
import '../lang/creta_studio_lang.dart';
import 'app_enums.dart';
import 'creta_model.dart';
import 'creta_style_mixin.dart';

// ignore: camel_case_types
class FrameModel extends CretaModel with CretaStyleMixin {
  late UndoAble<String> name;
  late UndoAble<String> bgUrl;
  late UndoAble<double> posX;
  late UndoAble<double> posY;
  late UndoAble<double> angle;
  late UndoAble<bool> isInsideRotate;
  late UndoAble<double> radius;
  late UndoAble<double> radiusLeftTop;
  late UndoAble<double> radiusRightTop;
  late UndoAble<double> radiusRightBottom;
  late UndoAble<double> radiusLeftBottom;
  late UndoAble<bool> isAutoFit;
  late UndoAble<bool> isMain;
  late UndoAble<Color> borderColor;
  late UndoAble<double> borderWidth;
  late UndoAble<int> borderType;
  late UndoAble<BorderCapType> borderCap;
  late UndoAble<Color> shadowColor;
  late UndoAble<double> shadowOpacity;
  late UndoAble<double> shadowSpread;
  late UndoAble<double> shadowBlur;
  late UndoAble<double> shadowDirection;
  late UndoAble<double> shadowOffset;
  late UndoAble<ShapeType> shape;
  //late UndoAble<bool> shadowIn;
  late UndoAble<String> eventSend;

  FrameType frameType = FrameType.none;

  double prevWidth = -1;
  double prevHeight = -1;
  double prevPosX = -1;
  double prevPosY = -1;

  void savePrevValue() {
    prevWidth = width.value;
    prevHeight = height.value;
    prevPosX = posX.value;
    prevPosY = posY.value;
  }

  void restorePrevValue() {
    mychangeStack.startTrans();
    if (prevWidth <= 0 || prevHeight <= 0 || prevPosX < 0 || prevPosY < 0) {
      width.set(width.value * 0.9, save: false);
      height.set(height.value * 0.9, save: false);
    } else {
      width.set(prevWidth, save: false);
      height.set(prevHeight, save: false);
      posX.set(prevPosX, save: false);
      posY.set(prevPosY, save: false);
    }
    save();
    mychangeStack.endTrans();
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        posX,
        posY,
        angle,
        isInsideRotate,
        frameType,
        radius,
        radiusLeftTop,
        radiusRightTop,
        radiusRightBottom,
        radiusLeftBottom,
        isAutoFit,
        isMain,
        borderColor,
        borderWidth,
        borderType,
        borderCap,
        shadowColor,
        shadowOpacity,
        shadowSpread,
        shadowBlur,
        shadowDirection,
        shadowOffset,
        shape,
        eventSend,
        //shadowIn,
        ...super.propsMixin,
      ];
  FrameModel(String pmid) : super(pmid: pmid, type: ExModelType.frame, parent: '') {
    name = UndoAble<String>('', mid, 'name');
    bgUrl = UndoAble<String>('', mid, 'bgUrl');
    posX = UndoAble<double>(0, mid, 'posX');
    posY = UndoAble<double>(0, mid, 'posY');
    angle = UndoAble<double>(0, mid, 'angle');
    isInsideRotate = UndoAble<bool>(false, mid, 'isInsideRotate');
    radius = UndoAble<double>(0, mid, 'radius');
    radiusLeftTop = UndoAble<double>(0, mid, 'radiusLeftTop');
    radiusRightTop = UndoAble<double>(0, mid, 'radiusRightTop');
    radiusRightBottom = UndoAble<double>(0, mid, 'radiusRightBottom');
    radiusLeftBottom = UndoAble<double>(0, mid, 'radiusLeftBottom');
    isAutoFit = UndoAble<bool>(false, mid, 'isAutoFit');
    isMain = UndoAble<bool>(false, mid, 'isMain');
    frameType = FrameType.none;
    borderColor = UndoAble<Color>(Colors.black, mid, 'borderColor');
    borderWidth = UndoAble<double>(0, mid, 'borderWidth');
    borderType = UndoAble<int>(0, mid, 'borderType');
    borderCap = UndoAble<BorderCapType>(BorderCapType.round, mid, 'borderCap');
    shadowColor = UndoAble<Color>(Colors.transparent, mid, 'shadowColor');
    shadowOpacity = UndoAble<double>(0.5, mid, 'shadowOpacity');
    shadowSpread = UndoAble<double>(0, mid, 'shadowSpread');
    shadowBlur = UndoAble<double>(0, mid, 'shadowBlur');
    shadowDirection = UndoAble<double>(0, mid, 'shadowDirection');
    shadowOffset = UndoAble<double>(0, mid, 'shadowOffset');
    shape = UndoAble<ShapeType>(ShapeType.none, mid, 'shape');
    eventSend = UndoAble<String>('', mid, 'eventSend');
    //shadowIn = UndoAble<bool>(false, mid);
    super.initMixin(mid);
  }

  FrameModel.makeSample(double porder, String pid, {FrameType pType = FrameType.none})
      : super(pmid: '', type: ExModelType.frame, parent: pid) {
    super.makeSampleMixin(mid);
    order = UndoAble<double>(porder, mid, 'order');
    name =
        UndoAble<String>('${CretaStudioLang.noNameframe} ${order.value.toString()}', mid, 'name');
    bgUrl = UndoAble<String>('', mid, 'bgUrl');
    posX = UndoAble<double>(100, mid, 'posX');
    posY = UndoAble<double>(100, mid, 'posY');
    angle = UndoAble<double>(0, mid, 'angle');
    isInsideRotate = UndoAble<bool>(false, mid, 'isInsideRotate');
    radius = UndoAble<double>(0, mid, 'radius');
    radiusLeftTop = UndoAble<double>(0, mid, 'radiusLeftTop');
    radiusRightTop = UndoAble<double>(0, mid, 'radiusRightTop');
    radiusRightBottom = UndoAble<double>(0, mid, 'radiusRightBottom');
    radiusLeftBottom = UndoAble<double>(0, mid, 'radiusLeftBottom');
    isAutoFit = UndoAble<bool>(false, mid, 'isAutoFit');
    isMain = UndoAble<bool>(false, mid, 'isMain');
    bgColor1 = UndoAble<Color>(Colors.white, mid, 'bgColor1');
    borderColor = UndoAble<Color>(Colors.black, mid, 'borderColor');
    borderWidth = UndoAble<double>(0, mid, 'borderWidth');
    borderType = UndoAble<int>(0, mid, 'borderType');
    borderCap = UndoAble<BorderCapType>(BorderCapType.none, mid, 'borderCap');
    shadowColor = UndoAble<Color>(Colors.transparent, mid, 'shadowColor');
    shadowOpacity = UndoAble<double>(0.5, mid, 'shadowOpacity');
    shadowSpread = UndoAble<double>(0, mid, 'shadowSpread');
    shadowBlur = UndoAble<double>(0, mid, 'shadowBlur');
    shadowDirection = UndoAble<double>(0, mid, 'shadowDirection');
    shadowOffset = UndoAble<double>(0, mid, 'shadowOffset');
    shape = UndoAble<ShapeType>(ShapeType.none, mid, 'shape');
    eventSend = UndoAble<String>('', mid, 'eventSend');

    //shadowIn = UndoAble<bool>(false, mid);

    frameType = pType;
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    FrameModel srcFrame = src as FrameModel;
    name = UndoAble<String>(srcFrame.name.value, mid, 'name');
    bgUrl = UndoAble<String>(srcFrame.bgUrl.value, mid, 'bgUrl');
    posX = UndoAble<double>(srcFrame.posX.value, mid, 'posX');
    posY = UndoAble<double>(srcFrame.posY.value, mid, 'posY');
    angle = UndoAble<double>(srcFrame.angle.value, mid, 'angle');
    isInsideRotate = UndoAble<bool>(srcFrame.isInsideRotate.value, mid, 'isInsideRotate');
    radius = UndoAble<double>(srcFrame.radius.value, mid, 'radius');
    radiusLeftTop = UndoAble<double>(srcFrame.radiusLeftTop.value, mid, 'radiusLeftTop');
    radiusRightTop = UndoAble<double>(srcFrame.radiusRightTop.value, mid, 'radiusRightTop');
    radiusRightBottom =
        UndoAble<double>(srcFrame.radiusRightBottom.value, mid, 'radiusRightBottom');
    radiusLeftBottom = UndoAble<double>(srcFrame.radiusLeftBottom.value, mid, 'radiusLeftBottom');
    isAutoFit = UndoAble<bool>(srcFrame.isAutoFit.value, mid, 'isAutoFit');
    isMain = UndoAble<bool>(srcFrame.isMain.value, mid, 'isMain');
    borderColor = UndoAble<Color>(srcFrame.borderColor.value, mid, 'borderColor');
    borderWidth = UndoAble<double>(srcFrame.borderWidth.value, mid, 'borderWidth');
    borderType = UndoAble<int>(srcFrame.borderType.value, mid, 'borderType');
    borderCap = UndoAble<BorderCapType>(srcFrame.borderCap.value, mid, 'borderCap');
    shadowColor = UndoAble<Color>(srcFrame.shadowColor.value, mid, 'shadowColor');
    shadowOpacity = UndoAble<double>(srcFrame.shadowOpacity.value, mid, 'shadowOpacity');
    shadowSpread = UndoAble<double>(srcFrame.shadowSpread.value, mid, 'shadowSpread');
    shadowBlur = UndoAble<double>(srcFrame.shadowBlur.value, mid, 'shadowBlur');
    shadowDirection = UndoAble<double>(srcFrame.shadowDirection.value, mid, 'shadowDirection');
    shadowOffset = UndoAble<double>(srcFrame.shadowOffset.value, mid, 'shadowOffset');
    shape = UndoAble<ShapeType>(srcFrame.shape.value, mid, 'shape');
    eventSend = UndoAble<String>(srcFrame.eventSend.value, mid, 'eventSend');
    //shadowIn = UndoAble<bool>(srcFrame.shadowIn.value, mid);

    frameType = srcFrame.frameType;
    super.copyFromMixin(mid, srcFrame);
    logger.finest('FrameCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    bgUrl.set(map["bgUrl"] ?? '', save: false, noUndo: true);

    double x = map["posX"] ?? 0;
    double y = map["posY"] ?? 0;

    posX.set(x < 0 ? 0 : x, save: false, noUndo: true);
    posY.set(y < 0 ? 0 : y, save: false, noUndo: true);

    angle.set((map["angle"] ?? 0), save: false, noUndo: true);
    isInsideRotate.set((map["isInsideRotate"] ?? false), save: false, noUndo: true);

    radius.set((map["radius"] ?? 0), save: false, noUndo: true);
    radiusLeftTop.set((map["radiusLeftTop"] ?? 0), save: false, noUndo: true);
    radiusRightTop.set((map["radiusRightTop"] ?? 0), save: false, noUndo: true);
    radiusRightBottom.set((map["radiusRightBottom"] ?? 0), save: false, noUndo: true);
    radiusLeftBottom.set((map["radiusLeftBottom"] ?? 0), save: false, noUndo: true);
    //isAutoFit.set((map["isAutoFit"] ?? false), save: false, noUndo: true);  // DB 에 쓰지 않는다.
    isMain.set((map["isMain"] ?? false), save: false, noUndo: true);

    borderColor.set(CretaUtils.string2Color(map["borderColor"])!, save: false, noUndo: true);
    borderWidth.set((map["borderWidth"] ?? 0), save: false, noUndo: true);
    borderType.set((map["borderType"] ?? 0), save: false, noUndo: true);
    borderCap.set(BorderCapType.fromInt(map["borderCap"] ?? 0), save: false, noUndo: true);
    shadowColor.set(CretaUtils.string2Color(map["shadowColor"])!, save: false, noUndo: true);
    shadowOpacity.set((map["shadowOpacity"] ?? 0), save: false, noUndo: true);
    shadowSpread.set((map["shadowSpread"] ?? 0), save: false, noUndo: true);
    shadowBlur.set((map["shadowBlur"] ?? 0), save: false, noUndo: true);
    shadowDirection.set((map["shadowDirection"] ?? 0), save: false, noUndo: true);
    shadowOffset.set((map["shadowOffset"] ?? 0), save: false, noUndo: true);
    shape.set(ShapeType.fromInt(map["shape"] ?? 0), save: false, noUndo: true);
    eventSend.set(map["eventSend"] ?? '', save: false, noUndo: true);

    //shadowIn.set((map["shadowIn"] ?? false), save: false, noUndo: true);

    frameType = FrameType.fromInt(map["frameType"] ?? 0);
    super.fromMapMixin(map);
    logger.finest('${posX.value}, ${posY.value}');
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "bgUrl": bgUrl.value,
        "posX": posX.value,
        "posY": posY.value,
        "angle": angle.value,
        "isInsideRotate": isInsideRotate.value,
        "radius": radius.value,
        "radiusLeftTop": radiusLeftTop.value,
        "radiusRightTop": radiusRightTop.value,
        "radiusRightBottom": radiusRightBottom.value,
        "radiusLeftBottom": radiusLeftBottom.value,
        //"isAutoFit": isAutoFit.value,   //DB 에서 읽지 않는다.
        "isMain": isMain.value,
        "borderColor": borderColor.value.toString(),
        "borderWidth": borderWidth.value,
        "borderType": borderType.value,
        "borderCap": borderCap.value.index,
        "shadowColor": shadowColor.value.toString(),
        "shadowOpacity": shadowOpacity.value,
        "shadowSpread": shadowSpread.value,
        "shadowBlur": shadowBlur.value,
        "shadowDirection": shadowDirection.value,
        "shadowOffset": shadowOffset.value,
        "shape": shape.value.index,
        "eventSend": eventSend.value,
        //"shadowIn": shadowIn.value,
        'frameType': frameType.index,
        ...super.toMapMixin(),
      }.entries);
  }

  bool isNoShadow() {
    if (0 == shadowBlur.value &&
        0 == shadowDirection.value &&
        0 == shadowOffset.value &&
        0 == shadowSpread.value) {
      return true;
    }

    return false;
  }

  double getRealradiusLeftTop(double scale) {
    double maxRadius = ((width.value < height.value) ? width.value / 2 : height.value / 2);
    double retval = radiusLeftTop.value * scale;
    if (radiusLeftTop.value > maxRadius) {
      retval = maxRadius * scale;
    }
    logger.fine('applied LeftTop : $retval');
    return retval;
  }

  double getRealradiusRightTop(double scale) {
    double maxRadius = ((width.value < height.value) ? width.value / 2 : height.value / 2);
    double retval = radiusRightTop.value * scale;
    if (radiusLeftTop.value > maxRadius) {
      retval = maxRadius * scale;
    }
    logger.fine('applied RightTop : $retval');
    return retval;
  }

  double getRealradiusLeftBottom(double scale) {
    double maxRadius = ((width.value < height.value) ? width.value / 2 : height.value / 2);
    double retval = radiusLeftBottom.value * scale;
    if (radiusLeftTop.value > maxRadius) {
      retval = maxRadius * scale;
    }
    logger.fine('applied LeftBottom : $retval');
    return retval;
  }

  double getRealradiusRightBottom(double scale) {
    double maxRadius = ((width.value < height.value) ? width.value / 2 : height.value / 2);
    double retval = radiusRightBottom.value * scale;
    if (radiusLeftTop.value > maxRadius) {
      retval = maxRadius * scale;
    }
    logger.fine('applied RightBottom : $retval');
    return retval;
  }

  bool shouldRotate() {
    return (angle.value > 0);
  }

  bool shouldOutsideRotate() {
    return (angle.value > 0 && isInsideRotate.value == false);
  }

  bool shouldInsideRotate() {
    return (angle.value > 0 && isInsideRotate.value == true);
  }
}
