import 'package:creta03/data_io/creta_manager.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta03/model/enterprise_model.dart';
//import 'package:creta03/pages/login_page.dart';
import 'package:hycop/hycop.dart';

class EnterpriseManager extends CretaManager {
  //EnterpriseModel? enterpriseModel;

  EnterpriseManager() : super('creta_enterprise', null);

  @override
  CretaModel cloneModel(CretaModel src) {
    EnterpriseModel retval = newModel(src.mid) as EnterpriseModel;
    src.copyTo(retval);
    return retval;
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
        pparentMid: '',
        name: name,
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
}
