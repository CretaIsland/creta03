import 'package:creta_common/model/app_enums.dart';

import 'creta_studio_lang_en.dart';
import 'creta_studio_lang_kr.dart';
import 'creta_studio_lang_mixin.dart';
import 'creta_studo_lang_jp.dart';

// ignore: non_constant_identifier_names
AbsCretaStudioLang CretaStudioLang = CretaStudioLangKR();

abstract class AbsCretaStudioLang with CretaStudioLangMixin {
  //LanguageType language = LanguageType.korean;

  AbsCretaStudioLang() {
    textSizeMap = {
      hugeText: 64,
      bigText: 48,
      middleText: 36,
      smallText: 24,
      userDefineText: 40,
    };
  }

  static AbsCretaStudioLang cretaLangFactory(LanguageType language) {
    switch (language) {
      case LanguageType.korean:
        return CretaStudioLangKR();
      case LanguageType.english:
        return CretaStudioLangEN();
      // case LanguageType.chinese:
      //   return CretaLangChn();
      case LanguageType.japanese:
        return CretaStudioLangJP();
      default:
        return CretaStudioLangKR();
    }
  }

  static void changeLang(LanguageType language) {
    CretaStudioLang = cretaLangFactory(language);
  }
}
