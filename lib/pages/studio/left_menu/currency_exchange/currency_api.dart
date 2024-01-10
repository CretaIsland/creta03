import 'package:creta03/pages/studio/left_menu/currency_exchange/model/currencies_model.dart';
import 'package:creta03/pages/studio/left_menu/currency_exchange/model/rates_model.dart';
import 'package:http/http.dart' as http;
import '../../../login/creta_account_manager.dart';

String key = CretaAccountManager.getEnterprise!.currencyXchangeApi;

// String key = '659d9fae0ef14f97960cef1637379d8b';
class AppUrl {
  static const String baseUrl = 'https://openexchangerates.org/api/';
  static String currenciesUrl = '${baseUrl}currencies.json?app_id=$key';
  static String ratesUrl = '${baseUrl}latest.json?base=USD&app_id=$key';
}

Future<RatesModel> fetchRates() async {
  var response = await http.get(Uri.parse(AppUrl.ratesUrl));
  final ratesModel = ratesModelFromJson(response.body);
  return ratesModel;
}

Future<Map> fetchCurrencies() async {
  var response = await http.get(Uri.parse(AppUrl.currenciesUrl));
  final allCurrencies = allCurrenciesFromJson(response.body);
  return allCurrencies;
}
