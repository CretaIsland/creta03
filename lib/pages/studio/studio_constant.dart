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

class LayoutConst {
  // stick menu
  static const double menuStickWidth = 80.0;
  static const double menuStickIconAreaHeight = 72.0;
  static const double menuStickIconSize = 32.0;

  // left menu
  static const double leftMenuWidth = 420;

  // bottom Menu bar
  static const double bottomMenuBarHeight = 68;

  static const double layoutMargin = 4;
  static Color studioBGColor = CretaColor.text[200]!;
  static const Color menuStickBGColor = Colors.white;
}
