// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_common/model/creta_model.dart';
import 'book_model.dart';
import 'creta_style_mixin.dart';
import 'frame_model.dart';

// ignore: must_be_immutable
class PageModel extends CretaModel with CretaStyleMixin {
  Offset origin = Offset.zero;

  late UndoAble<String> name;
  late UndoAble<String> description;
  late UndoAble<String> shortCut;
  late UndoAble<bool> isCircle;
  late UndoAble<String> thumbnailUrl;

  List<FrameModel> frameList = []; // db get 전용
  bool isTempVisible = false;
  final BookModel bookModel;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        description,
        thumbnailUrl,
        shortCut,
        isCircle,
        ...super.propsMixin,
      ];

  PageModel(String pmid, this.bookModel)
      : super(pmid: pmid, type: ExModelType.page, parent: '', realTimeKey: bookModel.mid) {
    name = UndoAble<String>('', mid, 'name');
    shortCut = UndoAble<String>('', mid, 'shortCut');
    isCircle = UndoAble<bool>(false, mid, 'isCircle');

    description = UndoAble<String>("You could do it simple and plain", mid, 'description');
    thumbnailUrl = UndoAble<String>('', mid, 'thumbnailUrl');
    super.initMixin(mid);
  }

  PageModel.makeSample(this.bookModel, double porder, String pid, int pageIndex)
      : super(pmid: '', type: ExModelType.page, parent: pid, realTimeKey: bookModel.mid) {
    final Random random = Random();
    int randomNumber = random.nextInt(10);
    String url = 'https://picsum.photos/200/?random=$randomNumber';
    logger.finest('url=$url');
    order = UndoAble<double>(porder, mid, 'order');
    name = UndoAble<String>('${CretaStudioLang.noNamepage} $pageIndex', mid, 'name');
    description = UndoAble<String>('You could do it simple and plain', mid, 'description');
    thumbnailUrl = UndoAble<String>(url, mid, 'thumbnailUrl');
    isCircle = UndoAble<bool>(false, mid, 'isCircle');

    shortCut = UndoAble<String>('', mid, 'shortCut');
    super.makeSampleMixin(
      mid,
      defaultHeight: bookModel.height.value,
      defaultWidth: bookModel.width.value,
    );

    logger.finest('mid=$mid');
    isRemoved.printMid();
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    PageModel srcPage = src as PageModel;
    name = UndoAble<String>(srcPage.name.value, mid, 'name');
    description = UndoAble<String>(srcPage.description.value, mid, 'description');
    thumbnailUrl = UndoAble<String>(srcPage.thumbnailUrl.value, mid, 'thumbnailUrl');
    shortCut = UndoAble<String>(srcPage.shortCut.value, mid, 'shortCut');

    isCircle = UndoAble<bool>(srcPage.isCircle.value, mid, 'isCircle');

    super.copyFromMixin(mid, src);
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    PageModel srcPage = src as PageModel;
    name.init(srcPage.name.value);
    description.init(srcPage.description.value);
    thumbnailUrl.init(srcPage.thumbnailUrl.value);
    shortCut.init(srcPage.shortCut.value);
    isCircle.init(srcPage.isCircle.value);
    super.updateFromMixin(src);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name.setDD(map["name"] ?? '', save: false, noUndo: true);

    isCircle.setDD(map["isCircle"] ?? false, save: false, noUndo: true);
    shortCut.setDD(map["shortCut"] ?? '', save: false, noUndo: true);
    description.setDD(map["description"] ?? '', save: false, noUndo: true);
    thumbnailUrl.setDD(map["thumbnailUrl"] ?? '', save: false, noUndo: true);
    super.fromMapMixin(map);

    setRealTimeKey(parentMid.value);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name.value,
        "description": description.value,
        "thumbnailUrl": thumbnailUrl.value,
        "shortCut": shortCut.value,
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

  bool hasTransitionEffect() {
    return (transitionEffect.value > 0 || transitionEffect2.value > 0);
  }

  bool isFade() {
    PageTransitionType type = PageTransitionType.fromInt(transitionEffect.value);
    return (type == PageTransitionType.fade);
  }

  bool isSliding() {
    PageTransitionType type = PageTransitionType.fromInt(transitionEffect.value);
    return (type == PageTransitionType.slidingX || type == PageTransitionType.slidingY);
  }

  bool isScale() {
    PageTransitionType type = PageTransitionType.fromInt(transitionEffect.value);
    return (type == PageTransitionType.scale);
  }
}
