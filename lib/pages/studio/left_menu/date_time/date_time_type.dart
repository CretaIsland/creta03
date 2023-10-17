import 'package:creta03/data_io/contents_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'dart:async';

//import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/contents_model.dart';

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

class DateTimeType extends StatefulWidget {
  final DateTimeFormat dateTimeFormat;
  final FrameManager? frameManager;
  final String? frameMid;
  final Widget? child;

  const DateTimeType({
    super.key,
    required this.dateTimeFormat,
    required this.frameManager,
    required this.frameMid,
    required this.child,
  });

  @override
  State<DateTimeType> createState() => _DateTimeTypeState();

  static String getFormattedTime(DateTimeFormat format) {
    switch (format) {
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

class _DateTimeTypeState extends State<DateTimeType> {
  late String _formattedTime;
  late Timer _timer;
  ContentsModel? _contentsModel;
  // ContentsEventController? _sendEvent;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko');

    // final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');
    //final ContentsEventController sendEvent = Get.find(tag: 'contents-main-to-property');
    // _sendEvent = sendEvent;

    _formattedTime = DateTimeType.getFormattedTime(widget.dateTimeFormat);

    if (widget.frameManager != null && widget.frameMid != null) {
      _contentsModel = widget.frameManager!.getFirstContents(widget.frameMid!);
      _contentsModel?.remoteUrl = _formattedTime;
    }
    _updateTimeWithTimer();
  }

  void _updateTimeWithTimer() {
    Duration updateDuration;
    switch (widget.dateTimeFormat) {
      case DateTimeFormat.hourMinSec:
      case DateTimeFormat.hourMinSecJM:
      case DateTimeFormat.hourMin:
      case DateTimeFormat.hourMinJM:
      case DateTimeFormat.hourJM:
        updateDuration = const Duration(seconds: 1);
        break;
      case DateTimeFormat.date:
      case DateTimeFormat.day:
      case DateTimeFormat.dateDay:
      case DateTimeFormat.monthDay:
      case DateTimeFormat.dayMonYear:
      case DateTimeFormat.dateDayMonYear:
      case DateTimeFormat.month:
      case DateTimeFormat.yearMonth:
      case DateTimeFormat.quarter:
      case DateTimeFormat.quarterYear:
      case DateTimeFormat.year:
        updateDuration = const Duration(days: 1);
        break;
    }

    _timer = Timer.periodic(updateDuration, (timer) {
      if (mounted) {
        setState(() {
          _formattedTime = DateTimeType.getFormattedTime(widget.dateTimeFormat);
          if (widget.frameManager != null && widget.frameMid != null) {
            if (_contentsModel != null) {
              _contentsModel?.remoteUrl = _formattedTime;
            }
            ContentsManager? contentsManager =
                widget.frameManager!.getContentsManager(widget.frameMid!);
            contentsManager?.notify();
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(DateTimeType oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dateTimeFormat != widget.dateTimeFormat) {
      _timer.cancel();

      _updateTimeWithTimer();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.child != null) ? widget.child! : Text(_formattedTime);
  }
}
