import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

enum DateTimeFormat {
  date,
  day,
  month,
  year,
  quarter,
  dateDay,
  monthDay,
  yearMonth,
  dayMonYear,
  dateDayMonYear,
  quarterYear,
  hourMin,
  hourMinSec,
  hourJM,
  hourMinJM,
  hourMinSecJM,
}

class DateTimeType {
  static String getDateText(DateTimeFormat dateTimeFormat) {
    initializeDateFormatting('ko');
    switch (dateTimeFormat) {
      case DateTimeFormat.date:
        return DateFormat.EEEE('ko').format(DateTime.now());
      case DateTimeFormat.day:
        return DateFormat.d('ko').format(DateTime.now());
      case DateTimeFormat.month:
        return DateFormat.LLL('ko').format(DateTime.now());
      case DateTimeFormat.year:
        return DateFormat.y('ko').format(DateTime.now());
      case DateTimeFormat.quarter:
        return DateFormat('제 QQQ분기').format(DateTime.now());
      case DateTimeFormat.dateDay:
        return DateFormat('EEEE, d일', 'ko').format(DateTime.now());
      case DateTimeFormat.monthDay:
        return DateFormat('M월 d일').format(DateTime.now());
      case DateTimeFormat.yearMonth:
        return DateFormat('y년 M월').format(DateTime.now());
      case DateTimeFormat.dayMonYear:
        return DateFormat('y년 M월 d일').format(DateTime.now());
      case DateTimeFormat.dateDayMonYear:
        return DateFormat('y년 M월 d일 (E)', 'ko').format(DateTime.now());
      case DateTimeFormat.quarterYear:
        return DateFormat.yQQQ('ko').format(DateTime.now());
      case DateTimeFormat.hourMin:
        return DateFormat('H시 m분').format(DateTime.now());
      case DateTimeFormat.hourMinSec:
        return DateFormat('H시 m분 s초').format(DateTime.now());
      case DateTimeFormat.hourJM:
        return DateFormat.j('ko').format(DateTime.now());
      case DateTimeFormat.hourMinJM:
        return DateFormat.jm('ko').format(DateTime.now());
      case DateTimeFormat.hourMinSecJM:
        return DateFormat.jms('ko').format(DateTime.now());
    }
  }
}
