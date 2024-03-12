//import 'package:cloud_firestore/cloud_firestore.dart';
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
}
