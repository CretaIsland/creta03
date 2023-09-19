// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
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
                  await _createTimeline(frameType: FrameType.timeline1);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 1',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline2);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 2',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline3);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 3',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline4);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 4',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline5);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 5',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline6);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 6',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
              LeftMenuEleButton(
                onPressed: () async {
                  await _createTimeline(frameType: FrameType.timeline7);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70.0,
                height: 70.0,
                hasBorder: false,
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(border: Border.all(color: CretaColor.primary)),
                  child: Center(
                      child: Text(
                    'Sample 7',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createTimeline({required FrameType frameType, int subType = -1}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 640.0;
    double height = 1056.0;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: subType,
    );
    mychangeStack.endTrans();
  }
}
