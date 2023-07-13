// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:html' as html;
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';

// import '../../../../data_io/contents_manager.dart';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:one_clock/one_clock.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../left_menu/weather/weather_base.dart';
import '../../studio_variables.dart';
// import '../../../../model/contents_model.dart';
// import '../../../../model/frame_model.dart';
// import '../../../../model/page_model.dart';
// import '../../book_main_page.dart';
// import '../../studio_snippet.dart';
// import '../containee_nofifier.dart';
// import 'sticker/draggable_stickers.dart';

mixin FramePlayMixin {
  FrameManager? frameManager;

  void initFrameManager() {
    frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
  }

  Future<void> createNewFrameAndContents(List<ContentsModel> modelList, PageModel pageModel,
      {FrameModel? frameModel}) async {
    // 프레임을 생성한다.
    //if (mychangeStack.transState != TransState.start) {
    if (frameModel == null) {
      mychangeStack.startTrans();
    }
    frameModel ??= await frameManager!.createNextFrame(doNotify: false);
    // 코텐츠를 play 하고 DB 에 Crete 하고 업로드까지 한다.
    logger.info('frameCretated(${frameModel.mid}');
    await ContentsManager.createContents(frameManager, modelList, frameModel, pageModel);
    mychangeStack.endTrans();
  }

  bool showBorder(
      FrameModel model, PageModel pageModel, ContentsManager contentsManager, bool isThumbnail) {
    if (model.isWeatherTYpe()) {
      return false;
    }

    if (model.isWatchTYpe()) {
      return false;
    }
    if (model.isCameraType()) {
      return false;
    }
    if (contentsManager.length() > 0) {
      return false;
    }
    if (model.textureType.value != TextureType.none) {
      return false;
    }

    return (model.bgColor1.value == pageModel.bgColor1.value ||
            model.bgColor1.value == Colors.transparent) &&
        (model.borderWidth.value == 0 || model.borderColor.value == pageModel.bgColor1.value) &&
        (model.isNoShadow());
  }

  Widget getWeatherType2(int subType) {
    if (subType == WeatherScene.scorchingSun.index) return WeatherScene.scorchingSun.getWeather();
    if (subType == WeatherScene.sunset.index) return WeatherScene.sunset.getWeather();
    if (subType == WeatherScene.frosty.index) return WeatherScene.frosty.getWeather();
    if (subType == WeatherScene.snowfall.index) return WeatherScene.snowfall.getWeather();
    if (subType == WeatherScene.showerSleet.index) return WeatherScene.showerSleet.getWeather();
    if (subType == WeatherScene.stormy.index) return WeatherScene.stormy.getWeather();
    if (subType == WeatherScene.rainyOvercast.index) return WeatherScene.rainyOvercast.getWeather();
    return const SizedBox.shrink();
  }

  Widget weatherFrame(FrameModel model, double width, double height) {
    if (model.frameType == FrameType.weather1) {
      WeatherType value = WeatherType.sunny;
      if (model.subType >= 0 && model.subType <= WeatherType.dusty.index) {
        value = WeatherType.values[model.subType];
      }
      return WeatherBase(
        weatherWidget: WeatherBg(
          weatherType: value,
          width: width,
          height: height,
        ),
        width: width,
        height: height,
      );
    }
    if (model.frameType == FrameType.weather2) {
      return WeatherBase(
        weatherWidget: getWeatherType2(model.subType),
        width: width,
        height: height,
      );
    }
    return const SizedBox.shrink();
  }

  Widget watchFrame(FrameModel model, Widget? child) {
    if (model.frameType == FrameType.analogWatch) {
      return AnalogClock(
        //dateTime: DateTime(2023, 07, 14, 10, 12, 07),

        isLive: true,
        decoration: BoxDecoration(
            border: Border.all(width: 2.0, color: Colors.black),
            color: Colors.transparent,
            shape: BoxShape.circle),
      );
    }
    if (model.frameType == FrameType.digitalWatch) {
      return DigitalClock(
          showSeconds: true,
          isLive: true,
          digitalClockColor: Colors.black,
          textScaleFactor: ((model.width.value / (50 * 2)) + 1) *
              StudioVariables.applyScale, // 50 is minimum contstraint
          //digitalClockColor: Colors.transparent,
          // decoration: const BoxDecoration(
          //     color: Colors.yellow,
          //     shape: BoxShape.rectangle,
          //     borderRadius: BorderRadius.all(Radius.circular(15))),
          datetime: DateTime.now());
    }
    return const SizedBox.shrink();
  }

  // Future<Widget> cameraFrame(FrameModel model) async {
  //   RTCVideoRenderer renderer = RTCVideoRenderer();
  //   await renderer.initialize();

  //   Map<String, dynamic> videoConstraints = <String, dynamic>{
  //     'audio': false,
  //     'video': {
  //       'optional': [
  //         {
  //           'sourceId': mediaDeviceDataHolder!.selectedVideoInput,
  //         },
  //       ],
  //     },
  //   };
  //   MediaStream videoStream = await navigator.mediaDevices.getUserMedia(videoConstraints);
  //   Map<String, dynamic> audioConstraints = {
  //     'audio': {
  //       'optional': [
  //         {
  //           'sourceId': mediaDeviceDataHolder!.selectedAudioInput,
  //         },
  //       ],
  //     },
  //   };
  //   MediaStream audioStream = await navigator.mediaDevices.getUserMedia(audioConstraints);

  //   renderer.srcObject = videoStream;
  //   renderer.srcObject = audioStream;

  //   return Container(
  //     width: 100,
  //     height: 100,
  //     color: Colors.pink,
  //     child: RTCVideoView(renderer)
  //   );

  // }
}
