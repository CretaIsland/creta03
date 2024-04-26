import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/model/app_enums.dart';

// import 'creta_device_lang_en.dart';
// import 'creta_device_lang_jp.dart';
// import 'creta_device_lang_kr.dart';
// import 'creta_device_lang_mixin.dart';

// ignore: non_constant_identifier_names
Map<String, dynamic> CretaMyPageLang = {};

abstract class AbsCretaMyPageLang /*with CretaMyPageLangMixin*/ {
  //LanguageType language = LanguageType.korean;

  AbsCretaMyPageLang();

  static Future<Map<String, dynamic>> cretaLangFactory(LanguageType language) async {
    late String lang;
    switch (language) {
      case LanguageType.korean:
        lang = 'assets/lang/creta_lang_mypage_kr.json';
        break;
      case LanguageType.english:
        lang = 'assets/lang/creta_lang_mypage_en.json';
        break;
      case LanguageType.japanese:
        lang = 'assets/lang/creta_lang_mypage_jp.json';
        break;
      default:
        lang = 'assets/lang/creta_lang_mypage_kr.json';
        break;
    }
    return await CretaCommonUtils.readJsonFromAssets(lang);
  }

  static Future<void> changeLang(LanguageType language) async {
    CretaMyPageLang = await cretaLangFactory(language);
  }
}
