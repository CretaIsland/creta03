// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import '../common/creta_utils.dart';
//import '../pages/studio/studio_constant.dart';
//import 'app_enums.dart';
import 'creta_model.dart';
//import 'creta_style_mixin.dart';

// ignore: camel_case_types
class FavoritesModel extends CretaModel {
  String userId = '';
  String bookId = '';
  DateTime favoriteTime = DateTime.now();

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        bookId,
        favoriteTime,
      ];
  FavoritesModel(String pmid) : super(pmid: pmid, type: ExModelType.favorites, parent: '');

  FavoritesModel.withName({
    required this.userId,
    required this.bookId,
    required this.favoriteTime,
  }) : super(pmid: '', type: ExModelType.favorites, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    FavoritesModel srcFavorite = src as FavoritesModel;
    userId = srcFavorite.userId;
    bookId = srcFavorite.bookId;
    favoriteTime = srcFavorite.favoriteTime;
    logger.finest('WatchHistoryCopied($mid)');
  }

  DateTime _convert(dynamic val) {
    if (val is Timestamp) {
      Timestamp ts = val;
      return ts.toDate();
    }
    return DateTime.now();
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    userId = map["userId"] ?? '';
    bookId = map["bookId"] ?? '';
    favoriteTime = _convert(map["favoriteTime"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "userId": userId,
        "bookId": bookId,
        "favoriteTime": favoriteTime,
      }.entries);
  }
}
