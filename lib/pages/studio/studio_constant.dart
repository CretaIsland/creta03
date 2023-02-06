// ignore_for_file: constant_identifier_names

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

class StudioConst {
  static const double orderVar = 0.0000001;
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

  // left menu
  static const double leftMenuWidth = 420;

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
