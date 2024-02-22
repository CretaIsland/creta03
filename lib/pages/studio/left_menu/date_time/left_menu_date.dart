// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:creta03/data_io/contents_manager.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta03/pages/studio/left_menu/date_time/date_time_elements.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import 'date_time_type.dart';

class LeftMenuDate extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuDate({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuDate> createState() => _LeftMenuDateState();
}

class _LeftMenuDateState extends State<LeftMenuDate> {
  late Border _border;
  late BorderRadius _radius;

  @override
  void initState() {
    super.initState();
    _border = Border.all(
      color: CretaColor.text[400]!,
      width: 1,
    );
    _radius = BorderRadius.horizontal(
      left: Radius.circular(16),
      right: Radius.circular(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 24.0),
            child: Text(widget.title, style: widget.dataStyle),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 10.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 6.0,
                children: [
                  _getElement(DateTimeFormat.date, 70),
                  _getElement(DateTimeFormat.day, 50),
                  _getElement(DateTimeFormat.month, 50),
                  _getElement(DateTimeFormat.year, 70),
                  _getElement(DateTimeFormat.quarter, 90),
                  _getElement(DateTimeFormat.dateDay, 90),
                  _getElement(DateTimeFormat.monthDay, 100),
                  _getElement(DateTimeFormat.yearMonth, 110),
                  _getElement(DateTimeFormat.dayMonYear, 130),
                  _getElement(DateTimeFormat.dateDayMonYear, 160),
                  _getElement(DateTimeFormat.quarterYear, 120),
                  _getElement(DateTimeFormat.hourMin, 110),
                  _getElement(DateTimeFormat.hourMinSec, 140),
                  _getElement(DateTimeFormat.hourJM, 80),
                  _getElement(DateTimeFormat.hourMinJM, 110),
                  _getElement(DateTimeFormat.hourMinSecJM, 140),
                ],
              )),
        ],
      ),
    );
  }

  Widget _getElement(
    DateTimeFormat infoType,
    double width,
  ) {
    return DateTimeElements(
        infoType: infoType,
        width: width,
        height: 32,
        border: _border,
        radius: _radius,
        onPressed: _onPressedCreateDateTimeFormat);
  }

  void _onPressedCreateDateTimeFormat(DateTimeFormat infoType) async {
    await _createDateTimeFormat(infoType);
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _createDateTimeFormat(DateTimeFormat infoType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 560;
    double height = 110;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: FrameType.dateTimeFormat,
      subType: infoType.index,
    );

    String dateTimeVal = DateTimeType.getFormattedTime(infoType);

    ContentsModel model = await _dateTimeTextModel(
      dateTimeVal,
      frameModel.mid,
      frameModel.realTimeKey,
    );
    await ContentsManager.createContents(frameManager, [model], frameModel, pageModel);
    mychangeStack.endTrans();
  }

  Future<ContentsModel> _dateTimeTextModel(String value, String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.text;
    retval.name = value;
    retval.autoSizeType.set(AutoSizeType.autoFrameSize, save: false);
    retval.remoteUrl = value;
    retval.textType = TextType.date;
    retval.fontSize.set(48, noUndo: true, save: false);
    retval.fontSizeType.set(FontSizeType.userDefine, noUndo: true, save: false);
    //retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
