// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:hycop/hycop/utils/hycop_utils.dart';

import 'app_enums.dart';
import 'creta_model.dart';
import 'frame_model.dart';

// ignore: must_be_immutable
class PageModel extends CretaModel {
  Offset origin = Offset.zero;

  late UndoAble<String> name;
  late UndoAble<String> description;
  late UndoAble<String> shortCut;
  late UndoAble<Color> bgColor;
  late UndoAble<bool> isUsed;
  late UndoAble<bool> isCircle;
  late UndoAble<PageTransition> pageTransition;

  List<FrameModel> frameList = []; // db get 전용

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        description,
        shortCut,
        bgColor,
        isUsed,
        isCircle,
      ];

  PageModel() : super(type: ExModelType.page, parent: '') {
    name = UndoAble<String>('', mid);
    shortCut = UndoAble<String>('', mid);
    bgColor = UndoAble<Color>(Colors.white, mid);
    isCircle = UndoAble<bool>(false, mid);
    isUsed = UndoAble<bool>(false, mid);
    description = UndoAble<String>("You could do it simple and plain", mid);
    pageTransition = UndoAble<PageTransition>(PageTransition.none, mid);
  }

  PageModel.makeSample(double pageNo, String pid) : super(type: ExModelType.page, parent: pid) {
    order = UndoAble<double>(pageNo, mid);
    name = UndoAble<String>(pageNo.toString(), mid);
    description = UndoAble<String>('', mid);
    isCircle = UndoAble<bool>(false, mid);
    isUsed = UndoAble<bool>(false, mid);
    shortCut = UndoAble<String>('', mid);
    bgColor = UndoAble<Color>(Colors.transparent, mid);
    pageTransition = UndoAble<PageTransition>(PageTransition.none, mid);
  }

  PageModel.withName(String nameStr) : super(type: ExModelType.page, parent: '') {
    name = UndoAble<String>(nameStr, mid);
    description = UndoAble<String>('', mid);
    isCircle = UndoAble<bool>(false, mid);
    isUsed = UndoAble<bool>(false, mid);
    shortCut = UndoAble<String>('', mid);
    bgColor = UndoAble<Color>(Colors.transparent, mid);
    pageTransition = UndoAble<PageTransition>(PageTransition.none, mid);
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    PageModel srcPage = src as PageModel;
    name = UndoAble<String>(srcPage.name.value, mid);
    description = UndoAble<String>(srcPage.description.value, mid);
    shortCut = UndoAble<String>(srcPage.shortCut.value, mid);
    bgColor = UndoAble<Color>(srcPage.bgColor.value, mid);
    isUsed = UndoAble<bool>(srcPage.isUsed.value, mid);
    isCircle = UndoAble<bool>(srcPage.isCircle.value, mid);
    pageTransition = UndoAble<PageTransition>(srcPage.pageTransition.value, mid);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    isUsed.set(map["isUsed"] ?? false, save: false, noUndo: true);
    isCircle.set(map["isCircle"] ?? false, save: false, noUndo: true);
    shortCut.set(map["shortCut"] ?? '', save: false, noUndo: true);
    description.set(map["description"] ?? '', save: false, noUndo: true);
    bgColor.set(HycopUtils.stringToColor(map["bgColor"]), save: false, noUndo: true);
    pageTransition.set(PageTransition.fromInt(map["pageTransition"] ?? 0),
        save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "description": description.value,
        "shortCut": shortCut.value,
        "bgColor": bgColor.value.toString(),
        "isUsed": isUsed.value,
        "isCircle": isCircle.value,
        "pageTransition": pageTransition.value.index,
      }.entries);
  }

  Future<bool> waitPageBuild() async {
    while (key.currentContext == null) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    logger.finest('page build complete !!!');
    return true;
  }
}
