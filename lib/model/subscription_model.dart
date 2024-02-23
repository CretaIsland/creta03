// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

//import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
//import '../common/creta_utils.dart';
//import '../pages/studio/studio_constant.dart';
//import 'app_enums.dart';
import 'package:creta_common/model/creta_model.dart';
import 'channel_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta_user_model/model/team_model.dart';
//import 'creta_style_mixin.dart';

// ignore: camel_case_types
class SubscriptionModel extends CretaModel {
  String channelId = '';
  String subscriptionChannelId = '';

  // use runtime-only
  ChannelModel? subscriptionChannel;

  @override
  List<Object?> get props => [
        ...super.props,
        channelId,
        subscriptionChannelId,
      ];
  SubscriptionModel(String pmid) : super(pmid: pmid, type: ExModelType.subscription, parent: '');

  SubscriptionModel.withName({
    required this.channelId,
    required this.subscriptionChannelId,
  }) : super(pmid: '', type: ExModelType.subscription, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    SubscriptionModel srcSubscription = src as SubscriptionModel;
    channelId = srcSubscription.channelId;
    subscriptionChannelId = srcSubscription.subscriptionChannelId;
    subscriptionChannel = srcSubscription.subscriptionChannel;
    logger.finest('WatchHistoryCopied($mid)');
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    SubscriptionModel srcSubscription = src as SubscriptionModel;
    channelId = srcSubscription.channelId;
    subscriptionChannelId = srcSubscription.subscriptionChannelId;
    subscriptionChannel = srcSubscription.subscriptionChannel;
    logger.finest('WatchHistoryCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    channelId = map["channelId"] ?? '';
    subscriptionChannelId = map["subscriptionChannelId"] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "channelId": channelId,
        "subscriptionChannelId": subscriptionChannelId,
      }.entries);
  }

  void getModelFromMaps(Map<String, ChannelModel> channelMap,
      Map<String, UserPropertyModel> userMap, Map<String, TeamModel> teamMap) {
    subscriptionChannel = channelMap[subscriptionChannelId];
    subscriptionChannel?.getModelFromMaps(userMap, teamMap);
  }

  // bool findChannelObjectFromMap(Map<String, ChannelModel> channelMap) {
  //   subscriptionChannel = channelMap[subscriptionChannelId];
  //   return (subscriptionChannel != null);
  // }
}
