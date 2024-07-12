import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
//import '../pages/login_page.dart';
//import '../pages/login/creta_account_manager.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import '../model/demo_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class DemoManager extends CretaManager {
  //DemoModel? channelModel;
  late Stream<QuerySnapshot> _stream;

  DemoManager() : super('creta_demo', null) {
    //saveManagerHolder?.registerManager('demo', this);
  }

  @override
  AbsExModel newModel(String mid) => DemoModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    DemoModel retval = newModel(src.mid) as DemoModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.demo);

  void initMyStream(String userId, {int? limit}) {
    Map<String, QueryValue> query = {};
    query['creator'] = QueryValue(value: userId);
    query['isRemoved'] = QueryValue(value: false);
    _stream = initStream(where: query, orderBy: 'updateTime', limit: limit);
  }

  Widget streamHost({required Widget Function(List<Map<String, dynamic>>) consumerFunc}) {
    return streamData2(consumerFunc: consumerFunc, snapshot: _stream);
  }
}
