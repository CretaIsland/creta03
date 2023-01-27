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
}
