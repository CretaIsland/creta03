import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../lang/creta_lang.dart';
import '../pages/studio/studio_variables.dart';

class CretaUtils {
  static Size getDisplaySize(BuildContext context) {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;
    StudioVariables.displaySize = Size(StudioVariables.displayWidth, StudioVariables.displayHeight);
    return StudioVariables.displaySize;
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
      //logger.fine('localOffset = $localOffset');

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
    logger.fine('key is null');
    return false;
  }

  static String? isPointInsideWidgetList(
      Map<String, GlobalKey> widgetKeyMap, Offset point, double margin) {
    logger.fine('widgetKeyMap = ${widgetKeyMap.length}');
    for (String aKey in widgetKeyMap.keys) {
      if (isPointInsideWidget(widgetKeyMap[aKey]!, point, margin)) {
        return aKey;
      }
    }
    return null;
  }
}
