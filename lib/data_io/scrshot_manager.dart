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
import '../model/scrshot_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class ScrshotManager extends CretaManager {
  //ScrshotModel? channelModel;

  ScrshotManager() : super('creta_scrshot', null) {
    //saveManagerHolder?.registerManager('scrshot', this);
  }

  @override
  AbsExModel newModel(String mid) => ScrshotModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    ScrshotModel retval = newModel(src.mid) as ScrshotModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.scrshot);

  Future<List<AbsExModel>> getScrshotHistory(String hostId, {int limit = 30}) async {
    logger.finest('lastestData');
    Map<String, QueryValue> query = {};
    query['hostId'] = QueryValue(value: hostId);
    Map<String, OrderDirection> orderBy = {};
    orderBy['updateTime'] = OrderDirection.descending;
    //query['isRemoved'] = QueryValue(value: false);
    //print('myDataOnly start');
    final retval = await queryFromDB(query, limit: limit, orderBy: orderBy);
    //print('myDataOnly end ${retval.length}');
    return retval;
  }
}
