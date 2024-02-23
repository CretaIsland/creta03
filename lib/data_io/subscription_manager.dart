import 'package:hycop/hycop.dart';
//import '../common/creta_utils.dart';
//import '../design_system/menu/creta_popup_menu.dart';
//import 'package:creta_common/lang/creta_lang.dart';
//import '../lang/creta_studio_lang.dart';
//import '../pages/login_page.dart';
import '../pages/login/creta_account_manager.dart';
//import 'package:creta_common/model/app_enums.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import '../model/subscription_model.dart';
//import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';

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

  Future<void> createSubscription(String channelId, String subscriptionChannelId) async {
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('channelId', QueryValue(value: channelId));
    addWhereClause('subscriptionChannelId', QueryValue(value: subscriptionChannelId));
    List<AbsExModel> modelList = await queryByAddedContitions();
    if (modelList.isEmpty) {
      SubscriptionModel model = SubscriptionModel.withName(
          channelId: channelId, subscriptionChannelId: subscriptionChannelId);
      return createToDB(model);
    }
    return Future.value();
  }

  Future<void> removeSubscription(String channelId, String subscriptionChannelId) async {
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('channelId', QueryValue(value: channelId));
    addWhereClause('subscriptionChannelId', QueryValue(value: subscriptionChannelId));
    List<AbsExModel> modelList = await queryByAddedContitions();
    if (modelList.isEmpty) {
      return Future.value();
    }
    SubscriptionModel model = modelList[0] as SubscriptionModel;
    return removeToDB(model.getMid);
  }

  Future<void> queryMySubscription(String subscriptionChannelId) {
    addWhereClause('isRemoved', QueryValue(value: false));
    addWhereClause('channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    addWhereClause('subscriptionChannelId', QueryValue(value: subscriptionChannelId));
    return queryByAddedContitions();
  }
}
