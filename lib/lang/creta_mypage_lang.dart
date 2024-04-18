//class CretaMyPageLang {

import 'package:creta_common/model/app_enums.dart';

import 'creta_mypage_lang_en.dart';
import 'creta_mypage_lang_jp.dart';
import 'creta_mypage_lang_kr.dart';
import 'creta_mypage_lang_mixin.dart';

// ignore: non_constant_identifier_names
AbsCretaMyPageLang CretaMyPageLang = CretaMyPageLangKR();

abstract class AbsCretaMyPageLang with CretaMyPageLangMixin {
  //LanguageType language = LanguageType.korean;

  AbsCretaMyPageLang();

  static AbsCretaMyPageLang cretaLangFactory(LanguageType language) {
    switch (language) {
      case LanguageType.korean:
        return CretaMyPageLangKR();
      case LanguageType.english:
        return CretaMyPageLangEN();
      // case LanguageType.chinese:
      //   return CretaLangChn();
      case LanguageType.japanese:
        return CretaMyPageLangJP();
      default:
        return CretaMyPageLangKR();
    }
  }

  static void changeLang(LanguageType language) {
    CretaMyPageLang = cretaLangFactory(language);
  }
}
