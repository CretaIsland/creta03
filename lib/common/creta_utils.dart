import 'dart:convert';
import 'package:hycop/common/util/logger.dart';

import '../lang/creta_lang.dart';

class CretaUtils {
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
      retval += "'$e'";
    }
    logger.finest('listToString=[$retval]');
    return '[$retval]';
  }
}
