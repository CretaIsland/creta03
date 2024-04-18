import 'package:creta_common/model/app_enums.dart';

import 'creta_device_lang_en.dart';
import 'creta_device_lang_jp.dart';
import 'creta_device_lang_kr.dart';
import 'creta_device_lang_mixin.dart';

// ignore: non_constant_identifier_names
AbsCretaDeviceLang CretaDeviceLang = CretaDeviceLangKR();

abstract class AbsCretaDeviceLang with CretaDeviceLangMixin {
  //LanguageType language = LanguageType.korean;

  AbsCretaDeviceLang();

  static AbsCretaDeviceLang cretaLangFactory(LanguageType language) {
    switch (language) {
      case LanguageType.korean:
        return CretaDeviceLangKR();
      case LanguageType.english:
        return CretaDeviceLangEN();
      // case LanguageType.chinese:
      //   return CretaLangChn();
      case LanguageType.japanese:
        return CretaDeviceLangJP();
      default:
        return CretaDeviceLangKR();
    }
  }

  static void changeLang(LanguageType language) {
    CretaDeviceLang = cretaLangFactory(language);
  }
}
