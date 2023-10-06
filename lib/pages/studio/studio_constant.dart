// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../design_system/creta_color.dart';

enum LeftMenuEnum {
  Template,
  Page,
  Frame,
  Storage,
  Image,
  Video,
  Text,
  Figure,
  Widget,
  Camera,
  Comment,
  None,
}

class LayoutConst {
  //
  static const double maxPageCount = 99;
  static const double minWorkWidth = 465;

  // top menu
  static const double topMenuBarHeight = 52;

  // stick menu
  static const double menuStickWidth = 80.0;
  static const double menuStickIconAreaHeight = 72.0;
  static const double menuStickIconSize = 32.0;

  // left/Right menu
  //static const double leftMenuWidth = 420;
  static const double leftMenuWidth = 380;
  static const double leftMenuWidthCollapsed = 100; // added by Mai 230516
  static const double rightMenuWidth = 380;
  static const double rightHideMenuWidth = 45;
  static const double rightMenuTitleHeight = 76;
  static const double innerMenuBarHeight = 36;
  static const double contentsListHeight = 24;

  // stick page
  static const double leftPageWidth = 210;

  // bottom Menu bar
  static const double bottomMenuBarHeight = 68;

  static const double layoutMargin = 4;
  static Color studioBGColor = CretaColor.text[200]!;
  static Color studioPageColor = Colors.white;
  static const Color menuStickBGColor = Colors.white;

  static const double maxPageSize = 1920 * 8;
  static const double minPageSize = 320;

  static const double cretaBannerMinHeight = 196;

  static const double cretaPaddingPixel = 40;
  static EdgeInsetsGeometry cretaPadding = const EdgeInsets.fromLTRB(
    LayoutConst.cretaPaddingPixel,
    LayoutConst.cretaBannerMinHeight,
    LayoutConst.cretaPaddingPixel,
    LayoutConst.cretaPaddingPixel / 2,
  );
  static EdgeInsetsGeometry cretaTopPadding = const EdgeInsets.fromLTRB(
    LayoutConst.cretaPaddingPixel,
    LayoutConst.cretaPaddingPixel,
    LayoutConst.cretaPaddingPixel,
    LayoutConst.cretaPaddingPixel / 2,
  );
  static const double topMenuCursorSize = 24;
  static const Size defaultFrameSize = Size(600, 400);
  static const Size bookThumbSize = Size(290.0, 256.0);
  static const double bookThumbSpacing = cretaPaddingPixel / 2;
  static const double bookDescriptionHeight = 56;

  static const double cretaScrollbarWidth = 13;
  static const double cretaTopTitleHeight = 80;
  static const double cretaTopTitleFilterHeightGap = 20;
  static const double cretaTopFilterHeight = 76;
  static const double cretaTopFilterItemHeight = 36;
  static const Size cretaTopTitlePaddingLT = Size(cretaPaddingPixel, cretaPaddingPixel);
  static const Size cretaTopTitlePaddingRB = Size(cretaPaddingPixel, cretaPaddingPixel);
  static const Size cretaTopFilterPaddingLT = Size(
      cretaPaddingPixel, cretaPaddingPixel + cretaTopTitleHeight + cretaTopTitleFilterHeightGap);
  static const Size cretaTopFilterPaddingRB = Size(cretaPaddingPixel, cretaPaddingPixel / 2);

  static const double cornerDiameter = 20.0;
  //static const double floatingActionPadding = 24;
  //static const double stikerOffset = cornerDiameter + floatingActionPadding;
  static const double stikerOffset = 20;

  static const double selectBoxBorder = 2.0;

  static const double dragHandle = 8;

  static const int minFrameSize = 50;

  static const double miniMenuWidth = 248;
  static const double miniMenuHeight = 40;
  static const double miniMenuGap = 8;
  static const double miniMenuArea = miniMenuHeight + miniMenuGap;

  static const double previewMenuHeight = 52;
}

class StudioConst {
  static const double orderVar = 0.0000001;
  static const int maxFavColor = 7;
  static const double maxFontSize = 512;
  static const double stepGranularity = 2.0; // <-- 폰트 사이즈 정밀도, 작을수록 속도가 느리다.  0.1 이 최소
  static const double minFontSize = stepGranularity * 5;
  static const double defaultTextPadding = 14.0;
  static const double defaultFontSize = 64.0;

  static List<List<Size>> signageResolution = [
    [],
    [
      Size(800, 600),
      Size(1400, 1050),
      Size(1440, 10800),
      Size(1920, 1440),
      Size(2048, 1536)
    ], // 4,3 스크린
    [Size(1280, 800), Size(1920, 1200), Size(2560, 1600)], //"16,10 스크린"
    [
      Size(1920, 1080),
      Size(1280, 720),
      Size(1366, 768),
      Size(1600, 900),
      Size(2560, 1440),
      Size(3840, 2160),
      Size(5120, 2880),
      Size(7680, 4320)
    ], //"16,9 스크린"
    [Size(2560, 1080), Size(3440, 1440), Size(5120, 2160)], //"21,9 스크린"
    [Size(3840, 1080), Size(5120, 1440)], //"32:9 스크린">
  ];

  static List<List<Size>> presentationResolution = [
    [],
    [Size(960, 720)],
    [Size(960, 540)],
    [Size(960, 600)],
    [Size(1920, 1080)],
    [Size(860, 1100)],
    [Size(1080, 1080)],
    [Size(1280, 720)],
    [Size(2560, 1440)],
    [Size(1200, 1200)],
    [Size(2560, 1440)],
    [Size(1080, 2280)],
    [Size(2048, 2732)],
    [Size(1600, 2560)],
    [Size(1440, 2560)],
    [Size(2550, 3300)],
    [Size(2480, 3508)],
    [Size(3508, 4961)],
    [Size(1748, 2480)],
    [Size(105, 148)],
    [Size(4169, 5906)],
    [Size(2953, 4169)],
    [Size(2079, 2953)],
    [Size(2705, 3827)],
    [Size(1913, 2705)],
    [Size(1346, 1913)],
  ];

  static List<Size> musicPlayerSize = [
    Size(480, 800),
    Size(480, 320),
    Size(460, 142),
    Size(260, 100),
  ];

  static List<ContentsType> depotsType = [
    ContentsType.none,
    ContentsType.image,
    ContentsType.video,
  ];

  static int maxMyFavFrame = 12;

  static List<String> languages = [
    '한국어',
    'Deutsch (Deutschland)',
    'English (US)',
    'Español (España)',
    'Français (France)',
    'हिंदी',
    'Bahasa Indonesia',
    'Italiano',
    '日本語',
    'Nederlands',
    'Polski',
    'Português (Brasil)',
    'Русский',
    '中文 (中国大陆)',
    '中文 (台灣)',
  ];
  static List<String> langCodes = [
    'ko',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'nl',
    'pl',
    'pt',
    'ru',
    'zh-cn',
    'zh-tw',
  ];
  static List<String> ttsCodes = [
    'ko-KR',
    'de-DE',
    'en-US',
    'es-ES',
    'fr-FR',
    'hi-IN',
    'id-ID',
    'it-IT',
    'ja-JP',
    'nl-NL',
    'pl-PL',
    'pt-BR',
    'ru-RU',
    'zh-CN',
    'zh-TW',
  ];

  static Map<String, String> lang2CodeMap = {};
  static Map<String, String> code2LangMap = {};
  static Map<String, String> code2TTSMap = {};
  static void initLangMap() {
    lang2CodeMap.clear();
    code2LangMap.clear();
    code2TTSMap.clear();
    int len = languages.length;
    for (int i = 0; i < len; i++) {
      lang2CodeMap[languages[i]] = langCodes[i];
      code2LangMap[langCodes[i]] = languages[i];
      code2TTSMap[langCodes[i]] = ttsCodes[i];
    }
  }

  static const double bigNumber = 100000000;

  static Map<String, int> fontWeightStr2Int = {
    'Thin': 100,
    'ExtraLight': 200,
    'Light': 300,
    'Regular': 400,
    'Medium': 500,
    'SemiBold': 600,
    'Bold': 700,
    'ExtraBold': 800,
    'Black': 900,
  };

  static Map<int, String> fontWeightInt2Str = {
    100: 'Thin',
    200: 'ExtraLight',
    300: 'Light',
    400: 'Regular',
    500: 'Medium',
    600: 'SemiBold',
    700: 'Bold',
    800: 'ExtraBold',
    900: 'Black',
  };

  static Map<int, FontWeight> fontWeight2Type = {
    100: FontWeight.w100,
    200: FontWeight.w200,
    300: FontWeight.w300,
    400: FontWeight.w400,
    500: FontWeight.w500,
    600: FontWeight.w600,
    700: FontWeight.w700,
    800: FontWeight.w800,
    900: FontWeight.w900,
  };

  static Map<String, List<int>> fontWeightListMap = {
    'Pretendard': [100, 200, 300, 400, 500, 600, 700, 800, 900],
    'NanumMyeongjo': [400, 700, 800],
    'Jua': [400],
    'NanumGothic': [400, 700, 800],
    'NanumPenScript': [400],
    'NotoSansKR': [100, 300, 400, 500, 700, 900],
    'Macondo': [400],
  };
}
