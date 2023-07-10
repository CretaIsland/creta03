// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_base.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import 'weather_element.dart';
import 'wether_variables.dart';

class LeftMenuWeather extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuWeather({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuWeather> createState() => _LeftMenuWeatherState();
}

class _LeftMenuWeatherState extends State<LeftMenuWeather> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: widget.dataStyle),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Wrap(
            spacing: 12.0,
            runSpacing: 6.0,
            children: [
              WeatherBase(
                nameText: Text('BG Type 1', style: widget.dataStyle),
                weatherWidget: WeatherBg(
                  weatherType: WeatherType.sunny,
                  width: widget.width,
                  height: widget.height,
                ),
                width: widget.width,
                height: widget.height,
                onPressed: () async {
                  await _createWeather(FrameType.weather1);
                  BookMainPage.pageManagerHolder!.notify();
                  //BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
                },
              ),
              WeatherBase(
                nameText: Text('BG Type 2', style: widget.dataStyle),
                weatherWidget: WeatherScene.scorchingSun.getWeather(),
                width: widget.width,
                height: widget.height,
                onPressed: () async {
                  await _createWeather(FrameType.weather2);
                  BookMainPage.pageManagerHolder!.notify();
                  //BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
                },
              ),
              _getElement(WeatherInfoType.temperature, 100),
              _getElement(WeatherInfoType.humidity, 100),
              _getElement(WeatherInfoType.uv, 120),
              _getElement(WeatherInfoType.visibility, 140),
              _getElement(WeatherInfoType.microDust, 160),
              _getElement(WeatherInfoType.superMicroDust, 160),
              _getElement(WeatherInfoType.pressure, 160),
              _getElement(WeatherInfoType.wind, 220),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getElement(
    WeatherInfoType infoType,
    double width,
  ) {
    return WeatherElement(
        infoType: infoType,
        width: width,
        height: 32,
        hasTitle: true,
        border: _border,
        radius: _radius,
        onPressed: _onPressedCreateWeatherInfo);
  }

  Future<void> _createWeather(FrameType frameType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.5;
    double height = pageModel.height.value * 0.5;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    int defaultSubType = -1;
    if (frameType == FrameType.weather1) defaultSubType = WeatherType.sunny.index;
    if (frameType == FrameType.weather2) defaultSubType = WeatherScene.scorchingSun.index;

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      subType: defaultSubType,
    );
    mychangeStack.endTrans();
  }

  void _onPressedCreateWeatherInfo(WeatherInfoType infoType) async {
    await _createWeatherInfo(infoType);
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _createWeatherInfo(WeatherInfoType infoType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 240;
    double height = 64;
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
      type: FrameType.text,
      subType: infoType.index,
    );
    ContentsModel model = await _weatherTextModel(
      WeatherVariables.getTitleText(infoType),
      WeatherVariables.getInfoText(infoType),
      frameModel.mid,
      frameModel.realTimeKey,
    );
    await ContentsManager.createContents(frameManager, [model], frameModel, pageModel);
    mychangeStack.endTrans();
  }

  Future<ContentsModel> _weatherTextModel(
      String name, String text, String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.text;

    retval.name = name;
    //retval.remoteUrl = '$name $text';
    retval.remoteUrl = text;
    retval.textType = TextType.weather;
    retval.fontSize.set(48, noUndo: true, save: false);
    retval.fontSizeType.set(FontSizeType.small, noUndo: true, save: false);
    //retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}