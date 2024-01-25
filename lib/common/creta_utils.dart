// ignore_for_file: avoid_web_libraries_in_flutter, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/browser_client.dart';
import 'package:hycop/hycop.dart';
import 'package:image/image.dart' as img;

import '../design_system/menu/creta_popup_menu.dart';
import '../lang/creta_lang.dart';
import '../lang/creta_studio_lang.dart';
import '../model/app_enums.dart';
import '../pages/login/creta_account_manager.dart';
import '../pages/studio/book_main_page.dart';
import '../pages/studio/studio_constant.dart';
import '../pages/studio/studio_variables.dart';
import '../routes.dart';

class ShadowData {
  final double spread;
  final double blur;
  final double direction;
  final double distance;
  final double opacity;
  final String? title;

  ShadowData({
    required this.spread,
    required this.blur,
    required this.direction,
    required this.distance,
    required this.opacity,
    this.title,
  });
}

class CretaUtils {
  static DateTime debugTime = DateTime.now();

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

  static DateTime getTimeSecondsAgo(int sec) {
    final currentTime = DateTime.now();
    DateTime retval = currentTime.subtract(Duration(seconds: sec));
    //print('10 secs before = ${retval.toString()}');
    return retval;
  }

  static bool hasTimePassed(DateTime baseTime, int milliseconds) {
    Duration duration = DateTime.now().difference(baseTime);
    if (duration.inMilliseconds > milliseconds) {
      return true;
    }
    return false;
  }

  // static String getTimeStrSecondsAgo(int sec) {
  //   final currentTime = DateTime.now();
  //   DateTime retval = currentTime.subtract(Duration(seconds: sec));
  //   //print('10 secs before = ${retval.toString()}');
  //   return CretaUtils.getDateTimeString(retval);
  // }

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

  static List<String> dynamicListToStringList(List<dynamic>? list) {
    List<String> retList = [];
    if (list == null) return retList;
    for (var value in list) {
      if (value is String) {
        retList.add(value);
      }
    }
    return retList;
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

  static Set<String> stringToSet(String inputString) {
    return inputString.split(',').toSet();
  }

  static String listToDisplay(List<String> list) {
    logger.finest('listToString=[${list.toString()}]');
    String retval = '';
    for (var e in list) {
      if (retval.isNotEmpty) {
        retval += ',';
      }
      retval += e;
    }
    logger.finest('listToString=[$retval]');
    return retval;
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

  static String getDateTimeString(DateTime dt) {
    return HycopUtils.dateTimeToDB(dt);
  }

  // static String getDateTimeDString2(DateTime dt,
  //     {String deli1 = '-', String deli2 = ' ', String deli3 = ':', String deli4 = '.'}) {
  //   String name = '${dt.year}';
  //   name += deli1;
  //   name += '${dt.month}'.padLeft(2, '0');
  //   name += deli1;
  //   name += '${dt.day}'.padLeft(2, '0');
  //   name += deli2;
  //   name += '${dt.hour}'.padLeft(2, '0');
  //   name += deli3;
  //   name += '${dt.minute}'.padLeft(2, '0');
  //   name += deli3;
  //   name += '${dt.second}'.padLeft(2, '0');
  //   name += deli4;
  //   name += '${dt.millisecond}'.padLeft(3, '0');
  //   return name;
  // }

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
    // ColorSwatch(primary value: Color(0xff2196f3)) 케이스도 있다.
    // 따라서 일단 Color(0x........) 을 추출해야 한다.
    String extract = CretaUtils.extractColorString(colorStr);
    //logger.severe('^^^^^$colorStr ==> $extract^^^^^^^^^^');

    if (extract.length == 8) {
      return Color(int.parse(extract, radix: 16));
    }
    return null;
    // String example = 'MaterialColor(primary value: Color(0xfff44336))';
    // String prefix = 'MaterialColor(primary value: Color(0x';

    // if (colorStr.length >= example.length && colorStr.substring(0, prefix.length) == prefix) {
    //   return Color(int.parse(colorStr.substring(prefix.length, prefix.length + 8), radix: 16));
    // }
    // return Color(int.parse(colorStr.substring(8, 16), radix: 16));
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

  static String extractColorString(String input) {
    final RegExp colorRegex = RegExp(r'Color\(0x(.{8})\)');

    final Match? match = colorRegex.firstMatch(input);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }

    return '';
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

  static Size getSizeByKey(GlobalKey widgetKey) {
    final RenderBox? box = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return Size.zero;
    //final Offset offset = box.localToGlobal(Offset.zero);
    return box.size;
  }

  static (Offset?, Size?) getBoxByKey(GlobalKey widgetKey) {
    final RenderBox? box = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return (null, null);
    final Offset offset = box.localToGlobal(Offset.zero);
    return (offset, box.size);
  }

  static bool isMousePointerOnWidget(GlobalKey widgetKey, Offset pointerPosition) {
    final RenderBox? box = widgetKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return false;

    final Offset widgetOffset = box.localToGlobal(Offset.zero);
    final Size size = box.size;

    return pointerPosition.dx >= widgetOffset.dx &&
        pointerPosition.dx < widgetOffset.dx + size.width &&
        pointerPosition.dy >= widgetOffset.dy &&
        pointerPosition.dy < widgetOffset.dy + size.height;
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

  static double getOuterWidth(double w, double h, double degree) {
    // 직각 삼각형에서,
    // 우리는 빗변의 길이 w 과  빗변과 하변 사이의 각 degree 를 알고 있다.
    // 이때,  하변 x 는 다음과 같다.
    double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
    double x = w * cos(rad);
    // 직각 삼각형에서,
    // 우리는 빗변의 길이 h 과  빗변과 하변 사이의 각 degree 를 알고 있다.
    // 이때,  수직한변 y 는 다음과 같다.
    double y = h * sin(rad);
    // 이 두값을 더하면, 기울여진 사각형의  외접 Width 가 된다.
    return x + y;
  }

  static double getOuterHeight(double w, double h, double degree) {
    // 직각 삼각형에서,
    // 우리는 빗변의 길이 h 과  빗변과 하변 사이의 각 degree 를 알고 있다.
    // 이때,  하변 x 는 다음과 같다.
    double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
    double x = h * cos(rad);
    // 직각 삼각형에서,
    // 우리는 빗변의 길이 w 과  빗변과 하변 사이의 각 degree 를 알고 있다.
    // 이때,  수직한변 y 는 다음과 같다.
    double y = w * sin(rad);
    // 이 두값을 더하면, 기울여진 사각형의  외접 Width 가 된다.
    return x + y;
  }

  static Size getOuterRotateSize(Size frameSize, double degree) {
    // Size 가  frameSize 인 사각형을 degree 만큼 회전시켰을 때,
    // 이 회전된 사각형의 외접 사각형의 사이즈를 구현다.
    double w = frameSize.width;
    double h = frameSize.height;

    double retW = getOuterWidth(w, h, degree);
    double retH = getOuterHeight(w, h, degree);
    return Size(retW, retH);
  }

  static double getInnerWidth(double w, double h, double degree) {
    // x 가 구하고자 하는 height 이고, y 가 구하고자하는 width 라면
    // sin(rad) * x + cos(rad) * y = w
    // sin(rad) * y + cos(rad) * x = h  이다..
    // 따라서 y 는
    double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
    double s = sin(rad);
    double c = cos(rad);

    double y = (s * h - c * w) / (s * s - c * c);
    return y;
  }

  static double getInnerHeight(double w, double h, double degree) {
    // x 가 구하고자 하는 height 이고, y 가 구하고자하는 width 라면
    // sin(rad) * x + cos(rad) * y = w
    // sin(rad) * y + cos(rad) * x = h  이다..
    // 따라서 y 는
    double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
    double s = sin(rad);
    double c = cos(rad);

    double x = (s * w - c * h) / (s * s - c * c);
    return x;
  }

  static Size getInnerRotateSize(Size frameSize, double degree) {
    // Size 가  frameSize 인 사각형을 degree 만큼 회전시켰을 때,
    // 이 회전된 사각형의 외접 사각형의 사이즈를 구현다.
    double w = frameSize.width;
    double h = frameSize.height;

    double retW = getInnerWidth(w, h, degree);
    double retH = getInnerHeight(w, h, degree);
    return Size(retW, retH);
  }

  // static double getTriangleHeight(double r, double degree) {
  //   // 직각 삼각형에서,
  //   // 직각 삼각형에서,
  //   // 밑변은 r 이고, 몉변과 빗변의 각이 degree 일때, 수직한 변의 길이를 구한다.
  //   double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
  //   return r * tan(rad);
  // }

  // static double getTriangleWidth(double r, double degree) {
  //   // 직각 삼각형에서,
  //   // 직각 삼각형에서,
  //   // 수직한 변은 r 이고, 몉변과 빗변의 각이 degree 일때, 빗변의 길이를 구한다.
  //   double rad = degree * (pi / 180); // degree 를 radian 으로 전환한다.
  //   return r / sin(rad);
  // }

  // static Size getRotateSize(Size frameSize, double degree) {
  //   // Size 가  frameSize 인 사각형을 degree 만큼 회전시켰을 때,
  //   // frameSize 에 내졉하는 사각형의 사이즐 구한다.

  //   double w = frameSize.width / 2;
  //   double h = frameSize.height / 2;

  //   double retW = 0;
  //   double retH = 0;
  //   if (w > h) {
  //     retW = getTriangleWidth(h, degree);
  //     retH = getTriangleHeight(h, degree);
  //   } else {
  //     retW = getTriangleHeight(w, degree);
  //     retH = getTriangleWidth(w, degree);
  //   }
  //   return Size(retW, retH);
  // }

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
    ShadowData(spread: 30, blur: 4, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 30, blur: 0, direction: 0, distance: 0, opacity: 0.5),
    ShadowData(spread: 30, blur: 4, direction: 135, distance: 10, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 135, distance: 10, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 90, distance: 10, opacity: 0.5),
    //ShadowData(spread: 0, blur: 0, direction: 45, distance: 3, opacity: 0.5),
    ShadowData(spread: 0, blur: 0, direction: 90, distance: 0, opacity: 1.0, title: 'custom'),

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

  static bool isValidEmail(String email) {
    RegExp regex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
    return regex.hasMatch(email);
  }

  static Size? getSize(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      logger.warning('takeAScreenShot box not is founeded');
      return null;
    }
    return box.size;
  }

  static Rect? getArea(GlobalKey key) {
    RenderBox? box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      logger.warning('takeAScreenShot box not is founeded');
      return null;
    }
    Offset position = box.localToGlobal(Offset.zero);
    return position & box.size;
  }

  static Offset? getPosition(GlobalKey key) {
    if (key.currentContext == null) {
      logger.warning('takeAScreenShot box not is founeded');
      return null;
    }
    RenderBox? box = key.currentContext!.findRenderObject() as RenderBox?;
    if (box == null) {
      logger.warning('takeAScreenShot box not is founeded');
      return null;
    }
    Offset position = box.localToGlobal(Offset.zero);
    //Offset position = box.globalToLocal(Offset.zero);
    return position;
  }

  static bool isRectContained(Rect outerRect, Rect innerRect) {
    return outerRect.contains(innerRect.topLeft) && outerRect.contains(innerRect.bottomRight);
  }

  // json 에서 문자열을 name 항목의 추출하는 함수
  static List<dynamic> findItemsByName(Map<String, dynamic> json, String name,
      {String Function(String input)? transform}) {
    List<dynamic> result = [];
    void search(Map<String, dynamic> map) {
      map.forEach((key, value) {
        //if (key == 'name' && value == name) {
        if (key == name) {
          result.add(map[name]);
        } else if (value is Map<String, dynamic>) {
          search(value);
        } else if (value is List<dynamic>) {
          for (var item in value) {
            if (item is Map<String, dynamic>) {
              search(item);
            }
          }
        }
      });
    }

    search(json);
    return result;
  }

  static List<CretaMenuItem> getLangItem(
      {required String defaultValue, required void Function(String) onChanged}) {
    return StudioConst.code2LangMap.keys.map(
      (code) {
        String langStr = StudioConst.code2LangMap[code]!;

        return CretaMenuItem(
          caption: langStr,
          onPressed: () {
            onChanged(StudioConst.lang2CodeMap[langStr]!);
          },
          selected: code == defaultValue,
        );
      },
    ).toList();
  }

  static double timeLap() {
    DateTime now = DateTime.now();
    int retval = now.difference(debugTime).inMicroseconds;
    debugTime = now;
    return retval.toDouble() / 1000000;
  }

// 텍스트가 차이하는 실제 화면상의 사이즈를 구해준다.

  static TextPainter getTextPainter(String text, TextStyle? style, TextAlign? align) {
    final span = TextSpan(text: text, style: style);
    // final words = span.toPlainText().split(RegExp('\\s+'));
    // final wordspan = TextSpan(
    //   style: style,
    //   text: words.join('\n'),
    // );

    return TextPainter(
      text: span, // span,
      textDirection: TextDirection.ltr,
      textAlign: align ?? TextAlign.center,
      maxLines: null, // to support multi-line
    )..layout();
  }

  // static (double, double, int) getLineSizeAndCount(String text, AutoSizeType autoSizeType,
  //     double boxWidth, double boxHeight, TextStyle? style, TextAlign? align,
  //     {double adjust = 2.0}) {
  //   //print(
  //   //    '_getLineHeightAndCount, style.fontSize=${style!.fontSize}------------------------------');

  //   //int offset = 0;
  //   List<String> lines = text.split('\n');
  //   double textLineWidth = 0;
  //   double textLineHeight = 0;
  //   List<int> eachLineCount = [];
  //   for (var line in lines) {
  //     TextPainter textPainter = getTextPainter(line, style, align);

  //     //TextRange range =
  //     // 글자수를 구할 수 있다.
  //     //int charCount = textPainter.getLineBoundary(TextPosition(offset: text.length)).end;
  //     double wMargin = (style!.fontSize! / adjust);
  //     // ignore: unused_local_variable
  //     double hMargin = wMargin * (boxHeight / boxWidth);

  //     final double lineWidth = textPainter.width; // + wMargin;
  //     if (textLineWidth < lineWidth) {
  //       textLineWidth = lineWidth;
  //     }
  //     int count = 1;
  //     if (autoSizeType != AutoSizeType.autoFrameSize) {
  //       count = (lineWidth / boxWidth).ceil();
  //     }
  //     eachLineCount.add(count);
  //     //print('frameWidth=${_realSize!.width.round()}, lineWidth=${lineWidth.round()}, count=$count');
  //     // 텍스트 하이트는 나중에, frameSize 를 늘리기 위해서 필요하다.
  //     textLineHeight = textPainter.preferredLineHeight; // + hMargin; //textPainter.height;

  //     //Size size = textPainter.size;
  //     //print('width,height = ${te ....................... xtPainter.width.round()},${textPainter.height.round()}');
  //     //print('size=${size.width.round()}, ${size.height.round()}), $visualLineCount, $ddd');
  //   }

  //   int textLineCount = 0;
  //   for (var ele in eachLineCount) {
  //     textLineCount += ele;
  //   }
  //   //print('old _textLineCount=$_textLineCount,  new textLineCount=$textLineCount -------------');

  //   return (textLineWidth, textLineHeight, textLineCount);
  // }

  // static (double, double) resizeText(
  //   double textLineWidth,
  //   double textLineHeight,
  //   int textLineCount,
  //   double padding,
  // ) {
  //   //print('lineCount=$textLineCount, lineHeight=$textLineHeight');
  //   return (
  //     textLineWidth + (padding * 2),
  //     (textLineHeight * textLineCount.toDouble()) + (padding * 2),
  //   );
  // }

  static (double, double) getTextBoxSize(
    String text,
    AutoSizeType autoSizeType,
    double boxWidth,
    double boxHeight,
    TextStyle? style,
    TextAlign? align,
    double padding,
    double outlineWidth, {
    double adjust = 2.0,
  }) {
    //print('text lenght = ${text.length}----------------');
    if (text.isEmpty) {
      text = ' '; // 비어있으면 계산을 못하기 때문에, 그냥 Space 를 넣는다.
      // if (style != null && style.fontSize != null) {
      //   double height = (style.fontSize! * StudioVariables.applyScale) + (padding * 2);
      //   //print('empty case height=$height');
      //   return (boxWidth, height);
      // }
      // //print('empty case height=100');
      // return (boxWidth, 100);
    }

    //int offset = 0;
    List<String> lines = text.split('\n');
    double textLineWidth = 0;
    double textLineHeight = 0;
    List<int> eachLineCount = [];

    for (var line in lines) {
      TextPainter textPainter = getTextPainter(line, style, align);

      //TextRange range =
      // 글자수를 구할 수 있다.
      //int charCount = textPainter.getLineBoundary(TextPosition(offset: text.length)).end;

      final double lineWidth = textPainter.width; // + wMargin;
      if (textLineWidth < lineWidth) {
        textLineWidth = lineWidth;
      }
      int count = 1;
      if (autoSizeType != AutoSizeType.autoFrameSize) {
        count = (lineWidth / boxWidth).ceil();
      }
      if (count == 0) count = 1; // 빈줄의 경우이다.
      eachLineCount.add(count);
      // 텍스트 하이트는 나중에, frameSize 를 늘리기 위해서 필요하다.
      textLineHeight = textPainter.preferredLineHeight; // + hMargin; //textPainter.height;
    }

    int textLineCount = 0;
    for (var ele in eachLineCount) {
      textLineCount += ele;
    }

    double width = textLineWidth + (padding * 2) + (outlineWidth * 2);
    double height =
        (textLineHeight * textLineCount.toDouble()) + (padding * 2) + (outlineWidth * 2);

    //print('textLineCount=$textLineCount, textLineHeight=$textLineHeight, height=$height');

    if (autoSizeType == AutoSizeType.autoFrameHeight ||
        autoSizeType == AutoSizeType.autoFrameSize) {
      double wMargin = (style!.fontSize! / adjust);
      //double hMargin = wMargin * (height / width);
      width += wMargin;
      //height += hMargin;
    }

    //print('height=$height');

    //print('width=$width, height=$height, textLineCount=$textLineCount -------------');

    //print('lineCount=$textLineCount, lineHeight=$textLineHeight');
    return (width, height);
  }

  static double getOptimalFontSize({
    required String text,
    required TextStyle style,
    required double containerWidth,
    required double containerHeight,
    double delta = 1.0,
  }) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );

    double minFontSize = StudioConst.minFontSize; // 시작 폰트 크기
    double maxFontSize = StudioConst.maxFontSize; // 최대 시도할 폰트 크기
    double currentSize = StudioConst.defaultFontSize;

    while (maxFontSize - minFontSize > delta) {
      currentSize = (minFontSize + maxFontSize) / 2;
      textPainter.text = TextSpan(text: text, style: style.copyWith(fontSize: currentSize));
      textPainter.layout(maxWidth: containerWidth);

      if (textPainter.size.height > containerHeight) {
        maxFontSize = currentSize;
      } else {
        minFontSize = currentSize;
      }
    }

    return currentSize;
  }

  // image crop
  static Uint8List cropImage(
      Uint8List sourceImgBytes, Offset cropOffset, double ratio, Size frameSize) {
    int cropWidth = 0;
    int cropHeight = 0;

    img.Image sourceImg = img.decodeImage(sourceImgBytes)!;

    if (sourceImg.width / sourceImg.height > ratio) {
      cropWidth = (sourceImg.height * ratio).toInt();
      cropHeight = sourceImg.height;
    } else {
      cropWidth = sourceImg.width;
      cropHeight = sourceImg.width ~/ ratio;
    }

    img.Image cropImg = img.copyCrop(sourceImg,
        x: (cropOffset.dx * (sourceImg.width / frameSize.width)).toInt(),
        y: (cropOffset.dy * (sourceImg.height / frameSize.height)).toInt(),
        width: cropWidth,
        height: cropHeight);

    Uint8List cropImgBytes = Uint8List.fromList(img.encodePng(cropImg));

    return cropImgBytes;
  }

  // 색상에 따라, 잘보이는 색을 선택해줌. (보색)
  static Color luminance(Color color) {
    if (color == Colors.transparent) return Colors.black;
    return color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  // localPosition 을 페이지내의 position 으로 바꿔줌
  // static Offset positionInPage(Offset localPosition, double? applyScale, int pageIndex,
  //     {bool isLocal = true, bool dontApplyStickerOffset = true}) {
  //   print('pageIndex=$pageIndex');
  //   applyScale ??= StudioVariables.applyScale;
  //   double dx = (localPosition.dx -
  //           BookMainPage.pageOffset.dx +
  //           //((isLocal && dontApplyStickerOffset) ? 0 : (LayoutConst.stikerOffset / 2))) /
  //           (LayoutConst.stikerOffset / 2)) /
  //       applyScale;
  //   double dy = (localPosition.dy -
  //           (isLocal ? BookMainPage.localPageOffset.dy * pageIndex : BookMainPage.pageOffset.dy) +
  //           //(((isLocal && dontApplyStickerOffset) ? 0 : (LayoutConst.stikerOffset / 2)))) /
  //           (LayoutConst.stikerOffset / 2)) /
  //       applyScale;

  //   print('localPosition.dy=${localPosition.dy}');
  //   print('dy=$dy');

  //   return Offset(dx, dy);
  // }

  // 커서모양을 정해주는 함수
  static MouseCursor getCursorShape() {
    if (BookMainPage.topMenuNotifier!.isTextCreate()) {
      return SystemMouseCursors.text;
    }
    if (BookMainPage.topMenuNotifier!.isFrameCreate()) {
      return SystemMouseCursors.cell;
    }
    return SystemMouseCursors.basic;
  }

  static Future<ui.Image> loadImageFromUrl(String imageUrl) async {
    // 이미지 URL에서 데이터를 가져옵니다.
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // http 응답이 성공적이면, 바이트 데이터를 dart:ui 의 Image로 변환합니다.
      final Uint8List uint8list = response.bodyBytes;
      final ui.Codec codec = await ui.instantiateImageCodec(uint8list);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      return frameInfo.image;
    } else {
      throw Exception('Failed to load image from the internet');
    }
  }

  static void saveLogToFile(String logData, String outFileName, {String folder = "download"}) {
    final blob = html.Blob([logData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute(folder, outFileName)
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  static Future<Response?> post(
    String url,
    Map<String, dynamic> body, {
    void Function(String code)? onError,
    void Function(String code)? onException,
  }) async {
    String jsonString = '{\n';
    int count = 0;
    for (var ele in body.entries) {
      if (count > 0) {
        jsonString += ',\n';
      }
      jsonString += '"${ele.key}": ${ele.value}';
      count++;
    }
    jsonString += '\n}';

    //String encodedJson = base64Encode(utf8.encode(jsonString));

    //print(jsonString);

    try {
      http.Client client = http.Client();
      if (client is BrowserClient) {
        client.withCredentials = true;
      }
      // HTTP POST 요청 수행
      http.Response response = await client.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          // 추가적인 헤더를 설정할 수 있습니다.
        },
        body: jsonString, //encodedJson, //jsonString,
      );
      if (response.statusCode != 200) {
        // 에러 처리
        logger.severe('$url Failed to send data');
        logger.severe('Status code: ${response.statusCode}');
        onError?.call('${response.statusCode}');
        return null;
      }

      logger.fine('pos $url succeed');
      return response;
    } catch (e) {
      // 예외 처리
      logger.severe('$url Failed to send data');
      logger.severe('An error occurred: $e');
      onException?.call('$e');
      return null;
    }
  }

  static Future<bool> inviteBook(
      BuildContext context, String email, String bookMid, String bookName, String userName) async {
    String base = Uri.base.origin;
    //print('---------------base=$base');

    String url = '${CretaAccountManager.getEnterprise!.mediaApiUrl}/sendEmail';
    String option = '''{
        "invitationUserName": "$userName",        
        "cretaBookName": "$bookName",        
        "cretaBookLink": "$base${AppRoutes.communityBook}?$bookMid"        
    }''';
    Map<String, dynamic> body = {
      "receiverEmail": ['"$email"'], // 수신인
      "emailType": '"invite"',
      "emailOption": option,
    };

    Response? res = await CretaUtils.post(url, body, onError: (code) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($code)');
    }, onException: (e) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($e)');
    });

    if (res != null) {
      showSnackBar(context, CretaStudioLang.inviteEmailSucceed);
      return true;
    }
    return false;
  }

  static Widget underConstruction(
      {required double width, required double height, EdgeInsetsGeometry? padding}) {
    return
        // Positioned.fill(
        //   child:
        Container(
      color: Colors.white.withOpacity(0.8),
      padding: padding ?? const EdgeInsets.all(10),
      width: width,
      height: height,
      child: Center(
        child: Image(
          image: const AssetImage('assets/underConstruction.gif'),
          height: min(width, height) - 50,
        ),
      ),
      //),
    );
  }

  // 비교적 간단히, 텍스트의 사이즈를 구하는 함수이다.
  static Size calculateTextSize(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return textPainter.size;
  }

  static Future<bool> sendResetPasswordEmail(
    BuildContext context,
    String email,
    String userId,
    String secret,
  ) async {
    String base = Uri.base.origin;
    //print('---------------base=$base');

    String url = '${CretaAccountManager.getEnterprise!.mediaApiUrl}/sendEmail';
    String option = '''{
        "subject": "[크레타] 계정의 비밀번호 초기화 요청이 있습니다",        
        "content": "비밀번호 초기화를 원하시면 아래 링크를 클릭하시고\\n그렇지 않으시면 무시하세요.\\n\\n$base${AppRoutes.resetPasswordConfirm}?userId=$userId&secret=$secret\\n\\n크레타 팀으로부터."
    }''';
    Map<String, dynamic> body = {
      "receiverEmail": ['"$email"'], // 수신인
      "emailType": '"resetPassword"',
      "emailOption": option,
    };

    Response? res = await CretaUtils.post(url, body, onError: (code) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($code)');
    }, onException: (e) {
      showSnackBar(context, '${CretaStudioLang.inviteEmailFailed}($e)');
    });

    if (res != null) {
      showSnackBar(context, '비밀벊');
      return true;
    }
    return false;
  }
}
