// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../lang/creta_studio_lang.dart';
import 'creta_model.dart';
import 'creta_style_mixin.dart';
import 'frame_model.dart';

// ignore: must_be_immutable
class PageModel extends CretaModel with CretaStyleMixin {
  Offset origin = Offset.zero;

  late UndoAble<String> name;
  late UndoAble<String> description;
  late UndoAble<String> shortCut;
  late UndoAble<bool> isShow;
  late UndoAble<bool> isCircle;
  late UndoAble<String> thumbnailUrl;

  List<FrameModel> frameList = []; // db get 전용

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        description,
        thumbnailUrl,
        shortCut,
        isShow,
        isCircle,
        ...super.propsMixin,
      ];

  PageModel(String pmid) : super(pmid: pmid, type: ExModelType.page, parent: '') {
    name = UndoAble<String>('', mid);
    shortCut = UndoAble<String>('', mid);
    isCircle = UndoAble<bool>(false, mid);
    isShow = UndoAble<bool>(true, mid);
    description = UndoAble<String>("You could do it simple and plain", mid);
    thumbnailUrl = UndoAble<String>('', mid);
    super.initMixin(mid);
  }

  PageModel.makeSample(double porder, String pid)
      : super(pmid: '', type: ExModelType.page, parent: pid) {
    final Random random = Random();
    int randomNumber = random.nextInt(10);
    String url = 'https://picsum.photos/200/?random=$randomNumber';
    logger.finest('url=$url');
    order = UndoAble<double>(porder, mid);
    name = UndoAble<String>('${CretaStudioLang.noNamepage} ${order.value.toString()}', mid);
    description = UndoAble<String>('You could do it simple and plain', mid);
    thumbnailUrl = UndoAble<String>(url, mid);
    isCircle = UndoAble<bool>(false, mid);
    isShow = UndoAble<bool>(true, mid);
    shortCut = UndoAble<String>('', mid);

    super.makeSampleMixin(mid);

    logger.finest('mid=$mid');
    isRemoved.printMid();
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    PageModel srcPage = src as PageModel;
    name = UndoAble<String>(srcPage.name.value, mid);
    description = UndoAble<String>(srcPage.description.value, mid);
    thumbnailUrl = UndoAble<String>(srcPage.thumbnailUrl.value, mid);
    shortCut = UndoAble<String>(srcPage.shortCut.value, mid);
    isShow = UndoAble<bool>(srcPage.isShow.value, mid);
    isCircle = UndoAble<bool>(srcPage.isCircle.value, mid);
    super.copyFromMixin(mid, src);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.set(map["name"] ?? '', save: false, noUndo: true);
    isShow.set(map["isShow"] ?? true, save: false, noUndo: true);
    isCircle.set(map["isCircle"] ?? false, save: false, noUndo: true);
    shortCut.set(map["shortCut"] ?? '', save: false, noUndo: true);
    description.set(map["description"] ?? '', save: false, noUndo: true);
    thumbnailUrl.set(map["thumbnailUrl"] ?? '', save: false, noUndo: true);
    super.fromMapMixin(map);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "description": description.value,
        "thumbnailUrl": thumbnailUrl.value,
        "shortCut": shortCut.value,
        "isShow": isShow.value,
        "isCircle": isCircle.value,
        ...super.toMapMixin(),
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
