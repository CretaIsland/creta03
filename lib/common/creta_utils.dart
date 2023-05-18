// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../lang/creta_lang.dart';
import '../model/app_enums.dart';
import '../pages/studio/studio_variables.dart';

class ShadowData {
  final double spread;
  final double blur;
  final double direction;
  final double distance;
  final double opacity;

  ShadowData({
    required this.spread,
    required this.blur,
    required this.direction,
    required this.distance,
    required this.opacity,
  });
}

class CretaUtils {
  static Size getDisplaySize(BuildContext context) {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;
    StudioVariables.displaySize = Size(StudioVariables.displayWidth, StudioVariables.displayHeight);
    return StudioVariables.displaySize;
  }

  static String secToDurationString(double seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;

    final hoursStr = hours.toString().padLeft(2, '0');
    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = remainingSeconds.round().toString().padLeft(2, '0');

    String retval = '';

    if (hours > 0) {
      retval = '$hoursStr ${CretaLang.hours} ';
    }
    if (hours > 0 || minutes > 0) {
      retval += '$minutesStr ${CretaLang.minutes} ';
    }
    retval += '$secondsStr ${CretaLang.seconds}';
    return retval;
  }

  static String dateToDurationString(DateTime updateTime) {
    Duration duration = DateTime.now().difference(updateTime);
    if (duration.inDays >= 365) {
      return '${((duration.inDays / 365) * 10).round()} ${CretaLang.yearBefore}';
    }
    if (duration.inDays >= 30) {
      return '${((duration.inDays / 30) * 10).round()} ${CretaLang.monthBefore}';
    }
    if (duration.inDays >= 1) {
      return '${duration.inDays} ${CretaLang.dayBefore}';
    }
    if (duration.inHours >= 1) {
      return '${duration.inHours} ${CretaLang.hourBefore}';
    }

    return '${duration.inMinutes} ${CretaLang.minBefore}';
  }

  static List<String> jsonStringToList(String value) {
    if (value.isEmpty) {
      return [];
    }
    try {
      return json.decode(value).cast<String>().toList();
    } catch (e) {
      logger.severe('invalid json format ($value)');
    }
    return [];
  }

  static String listToString(List<String> list) {
    logger.finest('listToString=[${list.toString()}]');
    String retval = '';
    for (var e in list) {
      if (retval.isNotEmpty) {
        retval += ',';
      }
      retval += '"$e"';
    }
    logger.finest('listToString=[$retval]');
    return '[$retval]';
  }

  static String getNowString(
      {String deli1 = '/', String deli2 = ' ', String deli3 = ':', String deli4 = '.'}) {
    var now = DateTime.now();
    String name = '${now.year}';
    name += deli1;
    name += '${now.month}'.padLeft(2, '0');
    name += deli1;
    name += '${now.day}'.padLeft(2, '0');
    name += deli2;
    name += '${now.hour}'.padLeft(2, '0');
    name += deli3;
    name += '${now.minute}'.padLeft(2, '0');
    name += deli3;
    name += '${now.second}'.padLeft(2, '0');
    name += deli4;
    name += '${now.millisecond}'.padLeft(3, '0');
    return name;
  }

  static String getDateTimeString(DateTime dt,
      {String deli1 = '/', String deli2 = ' ', String deli3 = ':', String deli4 = '.'}) {
    String name = '${dt.year}';
    name += deli1;
    name += '${dt.month}'.padLeft(2, '0');
    name += deli1;
    name += '${dt.day}'.padLeft(2, '0');
    name += deli2;
    name += '${dt.hour}'.padLeft(2, '0');
    name += deli3;
    name += '${dt.minute}'.padLeft(2, '0');
    name += deli3;
    name += '${dt.second}'.padLeft(2, '0');
    name += deli4;
    name += '${dt.millisecond}'.padLeft(3, '0');
    return name;
  }

  static Color? string2Color(String? colorStr, {String defaultValue = 'Color(0xFFFFFFFF)'}) {
    if (defaultValue.isEmpty) {
      if (colorStr == null || colorStr.length < 16) {
        return null;
      }
    } else {
      if (colorStr == null || colorStr.length < 16) {
        return Color(int.parse(defaultValue.substring(8, 16), radix: 16));
      }
    }
    // MaterialColor(primary value: Color(0xfff44336)) 케이스와
    // Color(0xffffffff) 케이스가 있다.
    String example = 'MaterialColor(primary value: Color(0xfff44336))';
    String prefix = 'MaterialColor(primary value: Color(0x';

    if (colorStr.length >= example.length && colorStr.substring(0, prefix.length) == prefix) {
      return Color(int.parse(colorStr.substring(prefix.length, prefix.length + 8), radix: 16));
    }
    return Color(int.parse(colorStr.substring(8, 16), radix: 16));
  }

  static List<Color> string2ColorList(String? colorStrList) {
    if (colorStrList == null || colorStrList.isEmpty) {
      return [];
    }
    List<Color> retval = [];
    List<String> strList = CretaUtils.jsonStringToList(colorStrList);

    for (String ele in strList) {
      Color? color = string2Color(ele, defaultValue: '');
      if (color != null) {
        retval.add(color);
      }
    }
    return retval;
  }

  static String colorList2String(List<Color> colorList) {
    String retval = '';
    for (Color ele in colorList) {
      String str = ele.toString();
      if (retval.isNotEmpty) {
        retval += ",";
      }
      retval += '"$str"';
    }
    return '[$retval]';
  }

  static Color hexToColor(String hexString, {String alphaChannel = 'FF'}) {
    if (hexString.length >= 6) {
      if (hexString[0] == '#') {
        if (hexString.length == 7) {
          return Color(int.parse(hexString.replaceFirst('#', '0x$alphaChannel')));
        }
        return Color(int.parse(hexString.replaceFirst('#', '0x')));
      } else {
        if (hexString.length == 6) {
          return Color(int.parse('0x$alphaChannel$hexString'));
        }
        return Color(int.parse('0x$hexString'));
      }
    }
    return Colors.white;
  }

  static bool isPointInsideWidget(GlobalKey widgetKey, Offset point, double margin) {
    final RenderBox? widgetBox = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (widgetBox != null) {
      //final Offset localOffset = widgetBox.globalToLocal(point);
      //logger.finest('localOffset = $localOffset');

      // final Rect widgetRect =
      //     MatrixUtils.transformRect(widgetBox.getTransformTo(null), Offset.zero & widgetBox.size);
      final Rect widgetRect = MatrixUtils.transformRect(
          widgetBox.getTransformTo(null),
          Offset(-margin / 2, -margin / 2) &
              Size(widgetBox.size.width + margin / 2, widgetBox.size.height + margin / 2));
      //return widgetRect.contains(localOffset);

      // final Rect marginPlusRect = Offset(widgetRect.left - margin, widgetRect.top - margin) &
      //     Size(widgetRect.width + margin, widgetRect.height + margin);

      return widgetRect.contains(point);
    }
    logger.finest('key is null');
    return false;
  }

  static String? isPointInsideWidgetList(
      Map<String, GlobalKey> widgetKeyMap, Offset point, double margin) {
    logger.finest('widgetKeyMap = ${widgetKeyMap.length}');
    for (String aKey in widgetKeyMap.keys) {
      if (isPointInsideWidget(widgetKeyMap[aKey]!, point, margin)) {
        return aKey;
      }
    }
    return null;
  }

  static double degreeToRadian(double degree) {
    return degree * (pi / 180);
  }

  static Offset getShadowOffset(double degree, double shadowDistance) {
    //logger.finest('getShadowOffset= $degree, $shadowDistance');
    double radian = degreeToRadian(degree);
    double offsetX = shadowDistance * cos(radian);
    double offsetY = shadowDistance * sin(radian);
    //logger.finest('getShadowOffset= $radian, $offsetX, $offsetY');
    return Offset(offsetX, offsetY);
  }

  // static double borderPosition(BorderPositionType aType) {
  //   switch (aType) {
  //     case BorderPositionType.center:
  //       return BorderSide.strokeAlignCenter;
  //     case BorderPositionType.inSide:
  //       return BorderSide.strokeAlignInside;
  //     case BorderPositionType.outSide:
  //       return BorderSide.strokeAlignOutside;
  //     default:
  //       return 0;
  //   }
  //}

  static StrokeCap borderCap(BorderCapType aType) {
    switch (aType) {
      case BorderCapType.bevel:
        return StrokeCap.butt;
      case BorderCapType.miter:
        return StrokeCap.square;
      case BorderCapType.round:
        return StrokeCap.round;
      default:
        return StrokeCap.round;
    }
  }

  static StrokeJoin borderJoin(BorderCapType aType) {
    switch (aType) {
      case BorderCapType.bevel:
        return StrokeJoin.bevel;
      case BorderCapType.miter:
        return StrokeJoin.miter;
      case BorderCapType.round:
        return StrokeJoin.round;
      default:
        return StrokeJoin.round;
    }
  }

  static List<List<double>> borderStyle = [
    [132, 0],
    [4, 4],
    [8, 8],
    [12, 12],
    [16, 4],
    [16, 16],
  ];

  static List<ShadowData> shadowDataList = [
    ShadowData(spread: 3, blur: 4, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 3, blur: 0, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 3, blur: 4, direction: 135, distance: 3, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 135, distance: 3, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 90, distance: 3, opacity: 0.5),

    //   ShadowData(spread: 3, blur: 4, direction: 0, distance: 0),
    //   ShadowData(spread: 3, blur: 0, direction: 0, distance: 0),
    //   ShadowData(spread: 3, blur: 4, direction: 135, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 135, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 90, distance: 3),
    //   ShadowData(spread: 0, blur: 0, direction: 90, distance: 3),
  ];

  static double validCheckDouble(double target, double min, double max) {
    if (target < min) return min;
    if (target > max) return max;
    return target;
  }

  static int getStringSize(String str) {
    int retval = 0;
    for (int byte in str.codeUnits.toList()) {
      if (byte > 256) {
        // It's 2 bytes character
        retval += 2;
      } else {
        retval++;
      }
    }
    return retval;
  }

  static int getTextLineCount(String text, TextStyle textStyle, double width) {
    final span = TextSpan(text: text, style: textStyle);
    final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
    tp.layout(maxWidth: width);
    final line = tp.computeLineMetrics().length;
    return line;
  }

  // 특정 문자열에서 findChar 가 몇개나 포함되어 있는지 알려주는 함수이다.
  static int countAs(String input, String findChar) {
    return input.split('').where((char) => char == findChar).length;
  }

  static String getFontName(String font) {
    if (font == "NanumMyeongjo") {
      return CretaLang.fontNanum_Myeongjo;
    }
    if (font == "NotoSansKR") {
      return CretaLang.fontNoto_Sans_KR;
    }
    if (font == "Jua") {
      return CretaLang.fontJua;
    }
    if (font == "NanumGothic") {
      return CretaLang.fontNanum_Gothic;
    }
    if (font == "NanumPenScript") {
      return CretaLang.fontNanum_Pen_Script;
    }
    if (font == "NotoSansKR") {
      return CretaLang.fontNoto_Sans_KR;
    }
    if (font == "Macondo") {
      return CretaLang.fontMacondo;
    }
    return CretaLang.fontPretendard;
  }

  static String getFontFamily(String font) {
    if (font == CretaLang.fontNanum_Myeongjo) {
      return "NanumMyeongjo";
    }
    if (font == CretaLang.fontNoto_Sans_KR) {
      return "NotoSansKR";
    }
    if (font == CretaLang.fontJua) {
      return "Jua";
    }
    if (font == CretaLang.fontNanum_Gothic) {
      return "NanumGothic";
    }
    if (font == CretaLang.fontNanum_Pen_Script) {
      return "NanumPenScript";
    }
    if (font == CretaLang.fontNoto_Sans_KR) {
      return "NotoSansKR";
    }
    if (font == CretaLang.fontMacondo) {
      return "Macondo";
    }

    return "Pretendard";
  }

  static int getItemColumnCount(double pageWidth, double itemMinWidth, double itemXGap) {
    return (pageWidth < itemMinWidth) ? 1 : ((pageWidth + itemXGap) ~/ (itemMinWidth + itemXGap));
  }
}
