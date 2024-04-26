import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/model/app_enums.dart';

//import 'creta_studio_lang_en.dart';
//import 'creta_studio_lang_kr.dart';
//import 'creta_studio_lang_mixin.dart';
//import 'creta_studo_lang_jp.dart';

// ignore: non_constant_identifier_names
Map<String, dynamic> CretaStudioLang = {};
//AbsCretaStudioLang CretaStudioLang = CretaStudioLangKR();

abstract class AbsCretaStudioLang /*with CretaStudioLangMixin */ {
  AbsCretaStudioLang();

  static Future<Map<String, dynamic>> cretaLangFactory(LanguageType language) async {
    late String lang;
    switch (language) {
      case LanguageType.korean:
        lang = 'assets/lang/creta_lang_studio_kr.json';
        break;
      case LanguageType.english:
        lang = 'assets/lang/creta_lang_studio_en.json';
        break;
      case LanguageType.japanese:
        lang = 'assets/lang/creta_lang_studio_jp.json';
        break;
      default:
        lang = 'assets/qlang/creta_lang_studio_kr.json';
        break;
    }
    return await CretaCommonUtils.readJsonFromAssets(lang);
  }

  static Future<void> changeLang(LanguageType language) async {
    CretaStudioLang = await cretaLangFactory(language);
  }
}
