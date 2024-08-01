//import 'dart:async';

import 'package:text_to_speech/text_to_speech.dart';

import '../../pages/studio/studio_variables.dart';

//import '../../common/util/logger.dart';

class MyTTS {
  //final String defaultLanguage = 'en-US';
  String languageCode = 'en-US';

  MyTTS();
  void setLang(String lang) => languageCode = lang;

  TextToSpeech tts = TextToSpeech();

  double volume = 1; // Range: 0-1
  double rate = 1.0; // Range: 0-2
  double pitch = 1.0; // Range: 0-2

  // String? language;
  // List<String> languages = <String>[];
  // List<String> languageCodes = <String>[];
  // String? voice;

  // Future<void> initLanguages() async {
  //   /// populate lang code (i.e. en-US)
  //   languageCodes = await tts.getLanguages();

  //   for (String str in languageCodes) {
  //     logHolder.log('code: $str', level: 6);
  //   }

  //   /// populate displayed language (i.e. English)
  //   final List<String>? displayLanguages = await tts.getDisplayLanguages();
  //   if (displayLanguages == null) {
  //     return;
  //   }

  //   languages.clear();
  //   for (final dynamic lang in displayLanguages) {
  //     languages.add(lang as String);
  //     logHolder.log('lang: $lang', level: 6);
  //   }

  //   final String? defaultLangCode = await tts.getDefaultLanguage();
  //   if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
  //     languageCode = defaultLangCode;
  //   } else {
  //     languageCode = defaultLanguage;
  //   }
  //   language = await tts.getDisplayLanguageByCode(languageCode!);

  //   /// get voice
  //   voice = await _getVoiceByLang(languageCode!);
  // }

  // Future<String?> _getVoiceByLang(String lang) async {
  //   final List<String>? voices = await tts.getVoiceByLang(languageCode!);
  //   if (voices != null && voices.isNotEmpty) {
  //     return voices.first;
  //   }
  //   return null;
  // }

  //bool get supportPause => defaultTargetPlatform != TargetPlatform.android;

  //bool get supportResume => defaultTargetPlatform != TargetPlatform.android;

  void speak(String text) {
    tts.setVolume(StudioVariables.isMute ? 0 : volume);
    tts.setRate(rate);
    //if (languageCode != null) {
    tts.setLanguage(languageCode);
    //}
    tts.setPitch(pitch);
    tts.speak(text);
  }

  void stop() {
    tts.stop();
  }

  void resume() {
    tts.resume();
  }

  void pause() {
    tts.pause();
  }
}
