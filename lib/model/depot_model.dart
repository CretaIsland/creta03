// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../pages/studio/studio_constant.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class DepotModel extends CretaModel {
  String creator = '';
  String creatorName = '';
  String contentsMid = '';
  late UndoAble<bool> isFavorite;

  Size realSize = Size(LayoutConst.minPageSize, LayoutConst.minPageSize);

  @override
  List<Object?> get props => [
        ...super.props,
        creator,
        creatorName,
        contentsMid,
        isFavorite,
      ];
  DepotModel(String pmid) : super(pmid: pmid, type: ExModelType.depot, parent: '') {
    isFavorite = UndoAble<bool>(false, mid, 'isFavorite');

    parentMid.set(mid, noUndo: true, save: false);
    setRealTimeKey(mid);
  }

  DepotModel.withName(
    String nameStr, {
    required this.creator,
    required this.creatorName,
    required this.contentsMid,
  }) : super(pmid: '', type: ExModelType.book, parent: '') {
    //print('new mid = $mid');

    isFavorite = UndoAble<bool>(false, mid, 'isFavorite');
    parentMid.set(mid, noUndo: true, save: false);
    setRealTimeKey(mid);
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    DepotModel srcBook = src as DepotModel;
    creator = src.creator;
    creatorName = src.creatorName;
    contentsMid = src.contentsMid;

    isFavorite = UndoAble<bool>(srcBook.isFavorite.value, mid, 'isFavorite');

    logger.finest('BookCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    DepotModel srcBook = src as DepotModel;
    creator = src.creator;
    creatorName = src.creatorName;
    contentsMid = src.contentsMid;

    isFavorite.init(srcBook.isFavorite.value);
    logger.finest('BookCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    creator = map["creator"] ?? '';
    creatorName = map["creatorName"] ?? '';
    contentsMid = map["contentsMid"] ?? '';
    isFavorite.set(map["isFavorite"] ?? true, save: false, noUndo: true);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "creator": creator,
        "creatorName": creatorName,
        "contentsMid": contentsMid,
        "isFavorite": isFavorite.value,
      }.entries);
  }
}
