import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import '../lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import '../model/app_enums.dart';
//import '../model/book_model.dart';
import '../model/subscription_model.dart';
//import '../model/book_model.dart';
import '../model/creta_model.dart';
import 'creta_manager.dart';

class SubscriptionManager extends CretaManager {
  SubscriptionManager() : super('creta_subscription', null) {
    saveManagerHolder?.registerManager('subscription', this);
  }

  @override
  AbsExModel newModel(String mid) => SubscriptionModel(mid);

  @override
  CretaModel cloneModel(CretaModel src) {
    SubscriptionModel retval = newModel(src.mid) as SubscriptionModel;
    src.copyTo(retval);
    return retval;
  }

  String prefix() => CretaManager.modelPrefix(ExModelType.subscription);
}
