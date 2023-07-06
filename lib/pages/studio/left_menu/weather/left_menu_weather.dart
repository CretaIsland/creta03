import 'package:flutter/material.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_base.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title, style: widget.titleStyle),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Wrap(
            spacing: 12.0,
            children: [
              WeatherBase(
                nameText: Text('Type 1', style: widget.dataStyle.copyWith(color: Colors.white)),
                weatherWidget: WeatherBg(
                  weatherType: WeatherType.sunny,
                  width: widget.width,
                  height: widget.height,
                ),
                width: widget.width,
                height: widget.height,
                onPressed: () async {
                  print('type1 pressed');
                  await _createWeather(FrameType.weather1);
                  BookMainPage.pageManagerHolder!.notify();
                  BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
                },
              ),
              WeatherBase(
                nameText: Text('Type 2', style: widget.dataStyle),
                weatherWidget: WeatherScene.scorchingSun.getWeather(),
                width: widget.width,
                height: widget.height,
                onPressed: () async {
                  print('type2 pressed');
                  await _createWeather(FrameType.weather2);
                  BookMainPage.pageManagerHolder!.notify();
                  BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
                },
              ),
            ],
          ),
        ),
      ],
    );
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
}
