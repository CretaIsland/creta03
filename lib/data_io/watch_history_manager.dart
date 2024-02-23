import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../model/watch_history_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

class WatchHistoryManager extends CretaManager {
  WatchHistoryManager() : super('creta_watch_history', null) {
    saveManagerHolder?.registerManager('watchHistory', this);
  }

  @override
  AbsExModel newModel(String mid) => WatchHistoryModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    WatchHistoryModel retval = newModel(src.mid) as WatchHistoryModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.book);
}
