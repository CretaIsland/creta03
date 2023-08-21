// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:hycop/common/util/logger.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class DepotModel extends CretaModel {
  String creator = '';
  String creatorName = '';
  String contentsMid = '';
  ContentsType contentsType = ContentsType.none;

  late UndoAble<bool> isFavorite;

  @override
  List<Object?> get props => [
        ...super.props,
        creator,
        creatorName,
        contentsMid,
        isFavorite,
        contentsType,
      ];
  DepotModel(String pmid, String userEmail)
      : super(pmid: pmid, type: ExModelType.depot, parent: userEmail) {
    isFavorite = UndoAble<bool>(false, mid, 'isFavorite');

    setRealTimeKey(mid);
  }

  DepotModel.withName(String userEmail,
      {required this.creator,
      required this.creatorName,
      required this.contentsMid,
      required this.contentsType})
      : super(pmid: '', type: ExModelType.depot, parent: userEmail) {
    //print('new mid = $mid');

    isFavorite = UndoAble<bool>(false, mid, 'isFavorite');

    setRealTimeKey(mid);
  }
  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    DepotModel srcBook = src as DepotModel;
    creator = src.creator;
    creatorName = src.creatorName;
    contentsMid = src.contentsMid;
    contentsType = src.contentsType;

    isFavorite = UndoAble<bool>(srcBook.isFavorite.value, mid, 'isFavorite');

    logger.finest('DepotCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    DepotModel srcDepot = src as DepotModel;
    creator = src.creator;
    creatorName = src.creatorName;
    contentsMid = src.contentsMid;
    contentsType = src.contentsType;

    isFavorite.init(srcDepot.isFavorite.value);

    logger.finest('DepotCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    creator = map["creator"] ?? '';
    creatorName = map["creatorName"] ?? '';
    contentsMid = map["contentsMid"] ?? '';
    isFavorite.set(map["isFavorite"] ?? true, save: false, noUndo: true);
    // contentsType = map["contentsType"] ?? ContentsType.none;
    contentsType = ContentsType.fromInt(map["contentsType"] ?? 0);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "creator": creator,
        "creatorName": creatorName,
        "contentsMid": contentsMid,
        "isFavorite": isFavorite.value,
        "contentsType": contentsType.index,
      }.entries);
  }
}
