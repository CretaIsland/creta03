// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:hycop/common/undo/undo.dart';

import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../left_menu_ele_button.dart';

class LeftMenuSticker extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuSticker({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuSticker> createState() => _LeftMenuStickerState();
}

class _LeftMenuStickerState extends State<LeftMenuSticker> {
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
                  await _createSticker(frameType: FrameType.sticker);
                  BookMainPage.pageManagerHolder!.notify();
                },
                width: 70,
                height: 70,
                hasBorder: false,
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.pink[300],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _createSticker({required FrameType frameType, int subType = -1}) async {
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
          ? Size(460, 480)
          : frameType == FrameType.countDownTimer
              ? Size(474, 284)
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
