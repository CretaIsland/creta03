// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import '../common/creta_utils.dart';
//import '../pages/studio/studio_constant.dart';
//import '../pages/login_page.dart';
//import 'app_enums.dart';
import 'creta_model.dart';
import 'team_model.dart';
import 'user_property_model.dart';
//import 'creta_style_mixin.dart';

// ignore: camel_case_types
class ChannelModel extends CretaModel {
  String userId = '';
  String teamId = '';
  int followerCount = 0;
  String get name => userPropertyModel?.nickname ?? teamModel?.name ?? '';
  String get profileImg => userPropertyModel?.profileImg ?? teamModel?.profileImg ?? '';
  String get channelBannerImg => userPropertyModel?.channelBannerImg ?? teamModel?.channelBannerImg ?? '';
  UserPropertyModel? userPropertyModel;
  TeamModel? teamModel;

  @override
  List<Object?> get props => [
        ...super.props,
        userId,
        teamId,
        followerCount,
      ];
  ChannelModel(String pmid) : super(pmid: pmid, type: ExModelType.channel, parent: '');

  ChannelModel.withName({
    required this.userId,
    required this.teamId,
    this.followerCount = 0,
  }) : super(pmid: '', type: ExModelType.channel, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    ChannelModel srcChannel = src as ChannelModel;
    userId = srcChannel.userId;
    teamId = srcChannel.teamId;
    followerCount = srcChannel.followerCount;
    logger.finest('ChannelCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    ChannelModel srcChannel = src as ChannelModel;
    userId = srcChannel.userId;
    teamId = srcChannel.teamId;
    followerCount = srcChannel.followerCount;
    logger.finest('ChannelCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    userId = map["userId"] ?? '';
    teamId = map["teamId"] ?? '';
    followerCount = map["followerCount"] ?? 0;
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "userId": userId,
        "teamId": teamId,
        "followerCount": followerCount,
      }.entries);
  }

  void getModelFromMaps(Map<String, UserPropertyModel> userMap, Map<String, TeamModel> teamMap) {
    if (userId.isNotEmpty) {
      userPropertyModel = userMap[userId];
    }
    if (teamId.isNotEmpty) {
      teamModel = teamMap[teamId];
    }
  }
}
