// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

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

enum RightMenuEnum {
  Book,
  Page,
  Frame,
  Contents,
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
  static const double leftMenuWidth = 420;
  static const double rightMenuWidth = 380;
  static const double rightMenuTitleHeight = 76;
  static const double innerMenuBarHeight = 36;

  // stick page
  static const double leftPageWidth = 210;

  // bottom Menu bar
  static const double bottomMenuBarHeight = 68;

  static const double layoutMargin = 4;
  static Color studioBGColor = CretaColor.text[200]!;
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
}

class StudioConst {
  static const double orderVar = 0.0000001;
  static const int maxFavColor = 7;

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
    [
      Size(800, 600),
      Size(1400, 1050),
      Size(1440, 1080),
      Size(1920, 1440),
      Size(2048, 1536)
    ], // 4,3 스크린
    [Size(1280, 800), Size(1920, 1200), Size(2560, 1600)], //"16,10 스크린"
    [
      Size(1920, 1080),
      Size(1280, 720),
      Size(3840, 2160),
      Size(5120, 2880),
      Size(7680, 4320)
    ], //"16,9 스크린"
    [Size(2560, 1080), Size(3440, 1440), Size(5120, 2160)], //"21,9 스크린"
    [Size(3840, 1080), Size(5120, 1440)], //"32:9 스크린">
  ];
}
