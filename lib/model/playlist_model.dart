// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

//import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import '../pages/studio/studio_constant.dart';
//import 'app_enums.dart';
import 'package:creta_common/model/creta_model.dart';

//import 'creta_style_mixin.dart';

// ignore: camel_case_types
class PlaylistModel extends CretaModel {
  String name = '';
  //String userId = '';
  String channelId = '';
  bool isPublic = true;
  //DateTime lastUpdateTime = DateTime.now(); // 추후에 updateTime 으로 대체
  List<String> bookIdList = [];

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        //userId,
        channelId,
        isPublic,
        //lastUpdateTime,
        bookIdList,
      ];
  PlaylistModel(String pmid) : super(pmid: pmid, type: ExModelType.playlist, parent: '');

  PlaylistModel.withName({
    required this.name,
    //required this.userId,
    required this.channelId,
    required this.isPublic,
    //required this.lastUpdateTime,
    List<String>? bookIdList,
  }) : super(pmid: '', type: ExModelType.playlist, parent: '') {
    if (bookIdList != null) this.bookIdList = [...bookIdList];
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    PlaylistModel srcPlaylist = src as PlaylistModel;
    name = srcPlaylist.name;
    //userId = srcPlaylist.userId;
    channelId = srcPlaylist.channelId;
    isPublic = srcPlaylist.isPublic;
    //lastUpdateTime = srcPlaylist.lastUpdateTime;
    bookIdList = [...srcPlaylist.bookIdList];
    logger.finest('PlaylistCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map["name"] ?? '';
    //userId = map["userId"] ?? '';
    channelId = map["channelId"] ?? '';
    isPublic = map["isPublic"] ?? false;
    //lastUpdateTime = convertValue(map["lastUpdateTime"]); // Timestamp(in Firebase) => DateTime(in Flutter)
    bookIdList = CretaCommonUtils.jsonStringToList((map["bookIdList"] ?? ''));
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name,
        //"userId": userId,
        "channelId": channelId,
        "isPublic": isPublic,
        //"lastUpdateTime": lastUpdateTime,
        "bookIdList": CretaCommonUtils.listToString(bookIdList),
      }.entries);
  }
}
