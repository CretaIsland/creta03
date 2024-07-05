import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta03/model/enterprise_model.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_user_model/model/user_property_model.dart';
//import 'package:creta03/pages/login_page.dart';
import 'package:hycop/hycop.dart';

class EnterpriseManager extends CretaManager {
  //EnterpriseModel? enterpriseModel;

  EnterpriseManager() : super('creta_enterprise', null);

  static EnterpriseManager? _enterpriseManagerHolder;
  static EnterpriseManager get instance {
    if (_enterpriseManagerHolder == null) {
      _enterpriseManagerHolder = EnterpriseManager();
      _enterpriseManagerHolder!.configEvent(notifyModify: false);
      _enterpriseManagerHolder!.clearAll();
    }
    return _enterpriseManagerHolder!;
  }

  static EnterpriseModel? currentEnterpriseModel;

  static Future<void> initEnterprise() async {
    if (AccountManager.currentLoginUser.isSuperUser() == false && hasValidEnterprise()) {
      List<AbsExModel> enterprises = await _enterpriseManagerHolder!
          .myDataOnly(UserPropertyManager.getUserProperty!.enterprise);

      if (enterprises.isNotEmpty) {
        currentEnterpriseModel = enterprises.first as EnterpriseModel;
      }
    }
  }

  static bool isEnterpriseUser(String enterprise) {
    if (AccountManager.currentLoginUser.isSuperUser()) {
      return true;
    }
    return enterprise.isNotEmpty && enterprise != UserPropertyModel.defaultEnterprise;
  }

  static hasValidEnterprise() {
    return (UserPropertyManager.getUserProperty != null &&
        UserPropertyManager.getUserProperty!.enterprise.isNotEmpty &&
        UserPropertyManager.getUserProperty!.enterprise != UserPropertyModel.defaultEnterprise);
  }

  // static String superAdminCurrentEnterprise = '';
  // static String currentEnterpriseMid = '';

  // static String getEnterprise() {
  //   if (AccountManager.currentLoginUser.isSuperUser()) {
  //     if (EnterpriseManager.superAdminCurrentEnterprise.isNotEmpty) {
  //       return EnterpriseManager.superAdminCurrentEnterprise;
  //     }
  //   }
  //   return CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
  // }

  // Future<String> getEnterpriseMid() async {
  //   if (AccountManager.currentLoginUser.isSuperUser()) {
  //     if (EnterpriseManager.currentEnterpriseMid.isNotEmpty) {
  //       return EnterpriseManager.currentEnterpriseMid;
  //     }
  //   }
  //   if (CretaAccountManager.userPropertyManagerHolder.userPropertyModel == null) {
  //     logger.severe('userPropertyModel is null in getEnterpriseMid()');
  //     return '';
  //   }

  //   String name = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.enterprise;
  //   Map<String, QueryValue> query = {};
  //   query['name'] = QueryValue(value: name);
  //   final retval = await queryFromDB(query);

  //   if (retval.isEmpty) {
  //     logger.severe('queryFromDB is empty in getEnterpriseMid()');
  //     return '';
  //   }

  //   AbsExModel model = retval.first;
  //   return model.mid;
  // }

  @override
  Future<List<AbsExModel>> myDataOnly(String userId, {int? limit}) async {
    logger.finest('myDataOnly');
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    final retval = await queryFromDB(query, limit: limit);
    return retval;
  }

  @override
  CretaModel cloneModel(CretaModel src) {
    EnterpriseModel retval = newModel(src.mid) as EnterpriseModel;
    src.copyTo(retval);
    return retval;
  }

  EnterpriseModel? getModelByName(String name) {
    for (var model in modelList) {
      if (model is EnterpriseModel) {
        if (model.name == name) {
          return model;
        }
      }
    }
    return null;
  }

  @override
  AbsExModel newModel(String mid) => EnterpriseModel(mid);
  //
  // Future<void> initEnterprise() async {
  //   clearAll();
  //   await getEnterprise();
  // }
  //
  // Future<int> getEnterprise() async {
  //   int enterpriseCount = 0;
  //   startTransaction();
  //
  //   try {
  //     enterpriseCount = await _getEnterprise();
  //     if (enterpriseCount == 0) {
  //       enterpriseCount = 1;
  //     }
  //   } catch (error) {
  //     logger.severe('something wrong in enterpriseManager >> $error');
  //     enterpriseCount = 0;
  //   }
  //
  //   endTransaction();
  //   return enterpriseCount;
  // }
  //
  // Future<int> _getEnterprise({int limit = 99}) async {
  //   Map<String, QueryValue> query = {};
  //   query['name'] =
  //       QueryValue(value: LoginPage.userPropertyManagerHolder!.userPropertyModel!.enterprise);
  //   query['isRemoved'] = QueryValue(value: false);
  //   Map<String, OrderDirection> orderBy = {};
  //   orderBy['order'] = OrderDirection.ascending;
  //   await queryFromDB(query, orderBy: orderBy, limit: limit);
  //
  //   enterpriseModel = onlyOne() as EnterpriseModel?;
  //   return modelList.length;
  // }

  Future<EnterpriseModel> createEnterprise(
      {required String name,
      required String description,
      required String enterpriseUrl,
      required String adminEmail,
      String openAiKey = '',
      String openWeatherApiKey = '',
      String giphyApiKey = '',
      String newsApiKey = '',
      String currencyXchangeApi = '',
      String dailyWordApi = '',
      String socketUrl = '',
      String mediaApiUrl = '',
      String webrtcUrl = ''}) async {
    EnterpriseModel enterpriseModel = EnterpriseModel.withName(
        adminEmail: adminEmail,
        pparentMid: '',
        name: name,
        enterpriseUrl: enterpriseUrl,
        description: description,
        openAiKey: openAiKey,
        openWeatherApiKey: openWeatherApiKey,
        giphyApiKey: giphyApiKey,
        newsApiKey: newsApiKey,
        dailyWordApi: dailyWordApi,
        currencyXchangeApi: currencyXchangeApi,
        socketUrl: socketUrl,
        mediaApiUrl: mediaApiUrl,
        webrtcUrl: webrtcUrl);

    await createToDB(enterpriseModel);
    insert(enterpriseModel, postion: getAvailLength());
    selectedMid = enterpriseModel.mid;
    return enterpriseModel;
  }

  @override
  void onSearch(String value, Function afterSearch) {
    search(['name', 'description'], value, afterSearch);
  }
}
