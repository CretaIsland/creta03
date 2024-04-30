// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/studio/left_menu/left_menu_ele_button.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_live_data.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_sticker_base.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_sticker_elements.dart';
import 'package:flutter/material.dart';
import 'package:creta03/pages/studio/left_menu/weather/weather_base.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../lang/creta_studio_lang.dart';
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
    return SizedBox(
      // height: StudioVariables.workHeight - 220.0,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 24.0),
              child: Text(widget.title, style: widget.dataStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 24.0, right: 24),
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
                    },
                  ),
                  _getElement(WeatherInfoType.cityname, 180),
                  _getElement(WeatherInfoType.temperature, 100),
                  _getElement(WeatherInfoType.humidity, 100),
                  _getElement(WeatherInfoType.uv, 120),
                  _getElement(WeatherInfoType.visibility, 140),
                  _getElement(WeatherInfoType.microDust, 160),
                  _getElement(WeatherInfoType.superMicroDust, 160),
                  _getElement(WeatherInfoType.pressure, 160),
                  _getElement(WeatherInfoType.wind, 160),
                ],
              ),
            ),
            const WeatherLiveData(),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 24.0),
              child: Text(CretaStudioLang["weatherSticker"], //'날씨 스티커',
                  style: widget.dataStyle),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 24.0),
              child: Wrap(
                spacing: 12.0,
                runSpacing: 6.0,
                children: [
                  LeftMenuEleButton(
                    width: 90.0,
                    height: 90.0,
                    onPressed: () async {
                      await _createWeatherStickers(FrameType.weatherSticker1);
                      BookMainPage.pageManagerHolder!.notify();
                    },
                    child: WeatherStickerBase(
                      weatherStickerWidget: Container(
                        color: CretaColor.text[200],
                        child: Image.asset('assets/weather_sticker/흐린후갬_A_black.png'),
                      ),
                    ),
                  ),
                  LeftMenuEleButton(
                    width: 90.0,
                    height: 90.0,
                    onPressed: () async {
                      await _createWeatherStickers(FrameType.weatherSticker2);
                      BookMainPage.pageManagerHolder!.notify();
                    },
                    child: WeatherStickerBase(
                      weatherStickerWidget: Container(
                        color: CretaColor.text[200],
                        child: Image.asset('assets/weather_sticker/흐린후갬_B_color.png'),
                      ),
                    ),
                  ),
                  LeftMenuEleButton(
                    width: 90.0,
                    height: 90.0,
                    onPressed: () async {
                      await _createWeatherStickers(FrameType.weatherSticker3);
                      BookMainPage.pageManagerHolder!.notify();
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      color: CretaColor.text[200],
                      child: WeatherStickerElements(
                        frameModel: null,
                        weatherType: WeatherStickerType.cloudy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 30.0),
          ],
        ),
      ),
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

  Future<void> _createWeatherStickers(FrameType frameType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
    double width = 160;
    double height = 160;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    int subType = -1;
    subType = WeatherType.cloudy.index;

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

  void _onPressedCreateWeatherInfo(WeatherInfoType infoType) async {
    await _createWeatherInfo(infoType);
    BookMainPage.pageManagerHolder!.notify();
  }

  Future<void> _createWeatherInfo(WeatherInfoType infoType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 320;
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
    retval.remoteUrl = '$name $text';
    retval.autoSizeType.set(AutoSizeType.autoFrameSize, save: false);
    retval.fontSize.set(48, noUndo: true, save: false);
    retval.fontSizeType.set(FontSizeType.small, noUndo: true, save: false);
    //retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }
}
