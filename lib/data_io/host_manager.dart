//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../model/host_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class HostManager extends CretaManager {
  late Stream<QuerySnapshot> _stream;

  HostManager() : super('creta_host', null) {
    saveManagerHolder?.registerManager('host', this);
  }

  @override
  AbsExModel newModel(String mid) => HostModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    HostModel retval = newModel(src.mid) as HostModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.host);

  int getIndexFromModelList(String mid) {
    for (int i = 0; i < modelList.length; i++) {
      if (modelList[i].mid == mid) return i;
    }
    return -1;
  }

  HostModel? getModelByHostId(String hostId) {
    return modelList.where((element) {
      return hostId == (element as HostModel).hostId;
    }).first as HostModel?;
  }

  @override
  Future<List<AbsExModel>> myDataOnly(String userId, {int? limit}) async {
    logger.finest('myDataOnly');
    Map<String, QueryValue> query = {};
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);
    //print('myDataOnly start');
    final retval = await queryFromDB(query, limit: limit);
    //print('myDataOnly end ${retval.length}');
    return retval;
  }

  Future<List<AbsExModel>> sharedData(String enterprise, {int? limit}) async {
    logger.finest('sharedData');
    Map<String, QueryValue> query = {};
    if (enterprise.isNotEmpty) {
      query['enterprise'] = QueryValue(value: enterprise);
    }
    query['isRemoved'] = QueryValue(value: false);
    //print('myDataOnly start');
    final retval = await queryFromDB(query, limit: limit);
    //print('myDataOnly end ${retval.length}');
    return retval;
  }

  @override
  Future<bool> isNameExist(String value, {String name = 'name'}) async {
    logger.finest('myDataOnly');
    Map<String, QueryValue> query = {};
    query['hostName'] = QueryValue(value: value);
    query['isRemoved'] = QueryValue(value: false);
    //print('myDataOnly start');
    final retval = await queryFromDB(query);
    //print('myDataOnly end ${retval.length}');
    return retval.isEmpty ? false : true;
  }

  HostModel createSample(
    String hostId,
    String hostName,
    String enterprise,
  ) {
    final Random random = Random();
    int randomNumber = random.nextInt(100);
    String url = 'https://picsum.photos/200/?random=$randomNumber';

    // String name = 'Host-';
    // name += CretaCommonUtils.getNowString(deli1: '', deli2: ' ', deli3: '', deli4: ' ');

    //print('old mid = ${onlyOne()!.mid}');
    HostModel sampleHost = HostModel.withName(
        pmid: '',
        hostId: hostId,
        hostName: hostName,
        enterprise: enterprise,
        parent: TeamManager.getCurrentTeam!.name,
        hostType: ServiceType.fromInt(CretaVars.instance.serviceType.index),
        creator: AccountManager.currentLoginUser.email,
        thumbnailUrl: url);

    sampleHost.order.set(getMaxOrder() + 1, save: false, noUndo: true, dontChangeBookTime: true);
    return sampleHost;
  }

  Future<HostModel> createNewHost(HostModel host) async {
    await createToDB(host);
    insert(host);
    return host;
  }

  void initMyStream(String userId, {int? limit}) {
    Map<String, QueryValue> query = {};
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);
    _stream = initStream(where: query, orderBy: 'updateTime', limit: limit);
  }

  void initSharedStream(String enterprise, {int? limit}) {
    Map<String, QueryValue> query = {};
    if (enterprise.isNotEmpty) {
      query['enterprise'] = QueryValue(value: enterprise);
    }
    query['isRemoved'] = QueryValue(value: false);
    _stream = initStream(where: query, orderBy: 'updateTime', limit: limit);
  }

  Widget streamHost({required Widget Function(List<Map<String, dynamic>>) consumerFunc}) {
    return streamData2(consumerFunc: consumerFunc, snapshot: _stream);
  }

  Widget myStreamDataOnly(String userId,
      {int? limit, required Widget Function(List<Map<String, dynamic>>) consumerFunc}) {
    Map<String, QueryValue> query = {};
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);

    return streamData(consumerFunc: consumerFunc, where: query, orderBy: 'updateTime');
  }

  Widget sharedStreamDataOnly(String enterprise,
      {int? limit, required Widget Function(List<Map<String, dynamic>>) consumerFunc}) {
    Map<String, QueryValue> query = {};
    if (enterprise.isNotEmpty) {
      query['enterprise'] = QueryValue(value: enterprise);
    }
    query['isRemoved'] = QueryValue(value: false);

    return streamData(consumerFunc: consumerFunc, where: query, orderBy: 'updateTime');
  }

  @override
  void onSearch(String value, Function afterSearch) {
    search(['hostName', 'hostId', 'description'], value, afterSearch);
  }
}
