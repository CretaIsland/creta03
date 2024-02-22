// ignore_for_file: library_private_types_in_public_api, no_logic_in_create_state

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_common/common/creta_const.dart';

import 'clock_painter.dart';

class DigitalClock extends StatefulWidget {
  final DateTime? datetime;

  final bool showNumbers;
  final bool showAllNumbers;
  final bool showSeconds;
  final bool useMilitaryTime;

  final Color digitalClockColor;
  final Color numberColor;
  final bool isLive;
  final double textScaleFactor;
  final double scaleFactor;
  final TextStyle? textStyle;
  final Widget? child;
  final ContentsModel? contentsModel;
  final void Function()? timeChanged;

  const DigitalClock(
      {this.datetime,
      this.textStyle,
      this.showNumbers = true,
      this.showSeconds = true,
      this.showAllNumbers = false,
      this.useMilitaryTime = true,
      this.digitalClockColor = Colors.black,
      this.numberColor = Colors.black,
      this.textScaleFactor = 1.0,
      this.scaleFactor = 1.0,
      this.child,
      this.contentsModel,
      this.timeChanged,
      isLive,
      Key? key})
      : isLive = isLive ?? (datetime == null),
        super(key: key);

  @override
  _DigitalClockState createState() => _DigitalClockState(datetime);
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime initialDatetime; // to keep track of time changes
  DateTime datetime;

  double _width = 0;
  double _height = 0;
  late TextPainter _digitalClockTP;

  Duration updateDuration = const Duration(seconds: 1); // repaint frequency
  _DigitalClockState(datetime)
      : datetime = datetime ?? DateTime.now(),
        initialDatetime = datetime ?? DateTime.now();

  //ContentsEventController? _sendEvent;

  @override
  void initState() {
    super.initState();
    // don't repaint the clock every second if second hand is not shown
    updateDuration = widget.showSeconds ? const Duration(seconds: 1) : const Duration(minutes: 1);

    if (widget.isLive) {
      // update clock every second or minute based on second hand's visibility.
      Timer.periodic(updateDuration, update);
    }

    // final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');

    // _sendEvent = sendEvent;
  }

  update(Timer timer) {
    if (mounted) {
      // update is only called on live clocks. So, it's safe to update datetime.
      datetime = initialDatetime.add(updateDuration * timer.tick);
      if (widget.timeChanged != null) {
        widget.timeChanged!.call();
      } else {
        setState(() {});
        // if (widget.contentsModel != null) {
        //   _sendEvent?.sendEvent(widget.contentsModel!);
        // }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _paintDigitalClock(
      textStyle: widget.textStyle,
      showSeconds: widget.showSeconds,
      useMilitaryTime: widget.useMilitaryTime,
      digitalClockColor: widget.digitalClockColor,
      textScaleFactor: widget.textScaleFactor,
    );

    if (widget.child != null) {
      return widget.child!;
    }

    return CustomPaint(
      size: Size(_width, _height),
      painter: DigitalClockPainter(
        datetime: datetime,
        digitalClockTP: _digitalClockTP,
        // textStyle: widget.textStyle,
        // showSeconds: widget.showSeconds,
        // useMilitaryTime: widget.useMilitaryTime,
        // digitalClockColor: widget.digitalClockColor,
        // textScaleFactor: widget.textScaleFactor,
        //numberColor: widget.numberColor,
      ),
    );
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!widget.isLive && widget.datetime != oldWidget.datetime) {
      datetime = widget.datetime ?? DateTime.now();
      datetime = DateTime.now();
    }
  }

  void _paintDigitalClock({
    TextStyle? textStyle,
    Color digitalClockColor = Colors.black,
    bool showSeconds = true,
    double textScaleFactor = 1,
    bool useMilitaryTime = true,
  }) {
    int hourInt = datetime.hour;
    String meridiem = '';
    if (!useMilitaryTime) {
      if (hourInt > 12) {
        hourInt = hourInt - 12;
        meridiem = ' PM';
      } else {
        meridiem = ' AM';
      }
    }
    String hour = hourInt.toString().padLeft(2, "0");
    String minute = datetime.minute.toString().padLeft(2, "0");
    String second = datetime.second.toString().padLeft(2, "0");
    String textToBeDisplayed = "$hour:$minute${showSeconds ? ":$second" : ""}$meridiem";
    double defaultFontSize = CretaConst.defaultFontSize * widget.scaleFactor * textScaleFactor;

    if (widget.contentsModel != null) {
      widget.contentsModel!.remoteUrl = textToBeDisplayed;
    }

    TextSpan digitalClockSpan = TextSpan(
        style: textStyle ??
            TextStyle(
                color: digitalClockColor,
                fontSize: defaultFontSize,
                //fontSize: 11,
                fontWeight: FontWeight.bold),
        text: textToBeDisplayed);

    _digitalClockTP = TextPainter(
        text: digitalClockSpan,
        textAlign: TextAlign.start,
        textDirection: TextDirection.ltr,
        textHeightBehavior: const TextHeightBehavior(
          applyHeightToFirstAscent: false,
          applyHeightToLastDescent: false,
        ));

    _digitalClockTP.layout();

    //print('style.height=${digitalClockSpan.style!.height}');

    double heightMultiplier = digitalClockSpan.style!.height ?? 1.0;
    _height = digitalClockSpan.style!.fontSize! * heightMultiplier;
    _width = _digitalClockTP.size.width;
  }
}
