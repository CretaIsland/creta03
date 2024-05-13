//import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
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

  @override
  Future<bool> isNameExist(String value) async {
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
        parent: TeamManager.getCurrentTeam!.name,
        hostType: ServiceType.fromInt(CretaVars.serviceType.index),
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
}
