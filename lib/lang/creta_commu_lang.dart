import 'package:creta_common/model/app_enums.dart';

import 'creta_commu_lang_en.dart';
import 'creta_commu_lang_jp.dart';
import 'creta_commu_lang_kr.dart';
import 'creta_commu_lang_mixin.dart';

// ignore: non_constant_identifier_names
AbsCretaCommuLang CretaCommuLang = CretaCommuLangKR();

abstract class AbsCretaCommuLang with CretaCommuLangMixin {
  //LanguageType language = LanguageType.korean;

  AbsCretaCommuLang();

  static AbsCretaCommuLang cretaLangFactory(LanguageType language) {
    switch (language) {
      case LanguageType.korean:
        return CretaCommuLangKR();
      case LanguageType.english:
        return CretaCommuLangEN();
      // case LanguageType.chinese:
      //   return CretaLangChn();
      case LanguageType.japanese:
        return CretaCommuLangJP();
      default:
        return CretaCommuLangKR();
    }
  }

  static void changeLang(LanguageType language) {
    CretaCommuLang = cretaLangFactory(language);
  }
}
