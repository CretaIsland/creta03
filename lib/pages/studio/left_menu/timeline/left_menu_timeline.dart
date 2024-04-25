// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_variables.dart';
import '../left_menu_ele_button.dart';

class LeftMenuTimeline extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuTimeline({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuTimeline> createState() => _LeftMenuTimelineState();
}

class _LeftMenuTimelineState extends State<LeftMenuTimeline> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: StudioVariables.workHeight - 240,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 24.0),
            child: Text(widget.title, style: widget.dataStyle),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 8.0),
            child: Scrollbar(
              controller: _scrollController,
              thickness: 6.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TimelineSample(
                        title: 'Showcase Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.showcaseTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/showcase_timeline.png'),
                          ),
                        ),
                      ),
                      TimelineSample(
                        title: 'Sccoer Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.footballTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/football_timeline.png'),
                          ),
                        ),
                      ),
                      TimelineSample(
                        title: 'Activity Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.activityTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/activity_timeline.png'),
                          ),
                        ),
                      ),
                      TimelineSample(
                        title: 'Success Stage Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.successTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/success_timeline.png'),
                          ),
                        ),
                      ),
                      TimelineSample(
                        title: 'Delivery Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.deliveryTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/delivery_timeline.png'),
                          ),
                        ),
                      ),
                      TimelineSample(
                        title: 'Weather Sample',
                        child: LeftMenuEleButton(
                          onPressed: () async {
                            await _createTimeline(frameType: FrameType.weatherTimeline);
                            BookMainPage.pageManagerHolder!.notify();
                          },
                          width: 82.0,
                          height: 124.0,
                          hasBorder: false,
                          child: Container(
                            width: 120.0,
                            height: 320.0,
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset('assets/timeline_samples/weather_timeline.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12.0, left: 12.0, right: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TimelineSample(
                    title: 'Monthly Sample',
                    child: LeftMenuEleButton(
                      onPressed: () async {
                        await _createTimeline(frameType: FrameType.monthHorizTimeline);
                        BookMainPage.pageManagerHolder!.notify();
                      },
                      width: 480.0,
                      height: 56.0,
                      hasBorder: false,
                      child: Container(
                        width: 540.0,
                        height: 240.0,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('assets/timeline_samples/monthHoriz_timeline.png'),
                      ),
                    ),
                  ),
                  TimelineSample(
                    title: 'Monthly Sample',
                    child: LeftMenuEleButton(
                      onPressed: () async {
                        await _createTimeline(frameType: FrameType.appHorizTimeline);
                        BookMainPage.pageManagerHolder!.notify();
                      },
                      width: 480.0,
                      height: 96.0,
                      hasBorder: false,
                      child: Container(
                        width: 540.0,
                        height: 240.0,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('assets/timeline_samples/appHoriz_timeline.png'),
                      ),
                    ),
                  ),
                  TimelineSample(
                    title: 'Delivery Sample 2',
                    child: LeftMenuEleButton(
                      onPressed: () async {
                        await _createTimeline(frameType: FrameType.deliveryHorizTimeline);
                        BookMainPage.pageManagerHolder!.notify();
                      },
                      width: 480.0,
                      height: 116.0,
                      hasBorder: false,
                      child: Container(
                        width: 540.0,
                        height: 240.0,
                        padding: const EdgeInsets.all(4.0),
                        child: Image.asset('assets/timeline_samples/deliveryHoriz_timeline.png'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  Future<void> _createTimeline({required FrameType frameType, int subType = -1}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 624.0;
    double height = 1080.0;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: frameType == FrameType.monthHorizTimeline
          ? Size(1920, 254)
          : frameType == FrameType.appHorizTimeline
              ? Size(1290, 340)
              : frameType == FrameType.deliveryHorizTimeline
                  ? Size(1644, 400)
                  : Size(width, height),
      pos: frameType == FrameType.monthHorizTimeline ? Offset(0, y) : Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: subType,
    );
    mychangeStack.endTrans();
  }
}
