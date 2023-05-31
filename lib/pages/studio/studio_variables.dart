import 'dart:ui';

import '../../common/creta_constant.dart';
import 'studio_constant.dart';

class StudioVariables {
  static double topMenuBarHeight = LayoutConst.topMenuBarHeight;
  static double menuStickWidth = LayoutConst.menuStickWidth;
  static double appbarHeight = CretaConstant.appbarHeight;

  static double fitScale = 1.0;
  static double scale = 1.0;
  static bool autoScale = true;

  static double displayWidth = 1920;
  static double displayHeight = 961;
  static Size displaySize = Size.zero;

  static double workWidth = 1920 - 80;
  static double workHeight = 961;
  static double workRatio = 1;

  static double availWidth = 0; // work width의 90% 영역
  static double availHeight = 0; // work height의 90% 영역

  static double virtualWidth = 1920 - 80;
  static double virtualHeight = 961;

  static bool isHandToolMode = false;
  static bool isLinkMode = false;

  static double applyScale = 1;

  static bool isMute = false;
  static bool isReadOnly = false;
  static bool isAutoPlay = true;

  static bool isPreview = false;
  static bool isLinkSelectMode = false;
}
