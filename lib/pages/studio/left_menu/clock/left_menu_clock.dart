// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:one_clock/one_clock.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../left_menu_ele_button.dart';

class LeftMenuClock extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuClock({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuClock> createState() => _LeftMenuWeatherState();
}

class _LeftMenuWeatherState extends State<LeftMenuClock> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 24.0),
            child: Wrap(
              spacing: 12.0,
              runSpacing: 6.0,
              children: [
                LeftMenuEleButton(
                  onPressed: () async {
                    await _createWatch(frameType: FrameType.analogWatch);
                    BookMainPage.pageManagerHolder!.notify();
                  },
                  width: widget.width,
                  height: widget.width,
                  hasBorder: false,
                  child: AnalogClock(
                    datetime: DateTime.now(),
                    isLive: false,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.black),
                        color: Colors.transparent,
                        shape: BoxShape.circle),
                  ),
                ),
                LeftMenuEleButton(
                  onPressed: () async {
                    await _createWatch(frameType: FrameType.digitalWatch);
                    BookMainPage.pageManagerHolder!.notify();
                  },
                  width: widget.width,
                  height: widget.width,
                  hasBorder: false,
                  child: DigitalClock(
                      showSeconds: true,
                      isLive: false,
                      digitalClockColor: Colors.black,
                      // decoration: const BoxDecoration(
                      //     color: Colors.yellow,
                      //     shape: BoxShape.rectangle,
                      //     borderRadius: BorderRadius.all(Radius.circular(15))),
                      datetime: DateTime.now()),
                ),
                LeftMenuEleButton(
                  onPressed: () async {
                    await _createWatch(frameType: FrameType.stopWatch);
                    BookMainPage.pageManagerHolder!.notify();
                  },
                  width: 94,
                  height: 94,
                  hasBorder: false,
                  // child: StopWatch(),
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.timer, color: Colors.white, size: 24),
                    ),
                  ),
                ),
                LeftMenuEleButton(
                  onPressed: () async {
                    await _createWatch(frameType: FrameType.countDownTimer);
                    BookMainPage.pageManagerHolder!.notify();
                  },
                  width: 94,
                  height: 94,
                  hasBorder: false,
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey,
                    child: const Center(
                      child: Icon(Icons.timer, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Future<void> _createWatch({required FrameType frameType, int subType = -1}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 320.0;
    double height = 320.0;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: frameType == FrameType.stopWatch
          ? Size(500, 550)
          : frameType == FrameType.countDownTimer
              ? Size(440, 280)
              : Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: subType,
      shape: frameType == FrameType.analogWatch ? ShapeType.circle : null,
    );
    mychangeStack.endTrans();
  }
}
