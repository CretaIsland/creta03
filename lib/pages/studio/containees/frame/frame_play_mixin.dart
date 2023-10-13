// ignore_for_file: avoid_web_libraries_in_flutter

// import 'dart:html' as html;
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:hycop/common/util/logger.dart';
// import 'package:hycop/hycop/enum/model_enums.dart';

// import '../../../../data_io/contents_manager.dart';

import 'package:creta03/pages/studio/containees/frame/sticker/mini_menu.dart';
import 'package:creta03/pages/studio/left_menu/clock/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:weather_animation/weather_animation.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/clock/analog_clock.dart';
import '../../../../design_system/component/clock/digital_clock.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../left_menu/clock/stop_watch.dart';
import '../../left_menu/google_map/creta_map_widget.dart';
import '../../left_menu/timeline/horizontal_timeline.dart';
import '../../left_menu/timeline/showcase_timeline.dart';
import '../../left_menu/timeline/football_timeline.dart';
import '../../left_menu/timeline/activity_timeline.dart';
import '../../left_menu/timeline/success_timeline.dart';
import '../../left_menu/timeline/delivery_timeline.dart';
import '../../left_menu/timeline/weather_timeline.dart';
import '../../left_menu/weather/weather_base.dart';
import '../../left_menu/weather/weather_sticker_base.dart';
import '../../left_menu/weather/weather_sticker_elements.dart';
import '../../studio_constant.dart';
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

  void setFrameManager(FrameModel? frameModel) {
    if (frameModel == null) {
      frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    } else {
      frameManager = BookMainPage.pageManagerHolder!.findFrameManager(frameModel.parentMid.value);
    }
  }

  Future<ContentsManager?> createNewFrameAndContents(
      List<ContentsModel> modelList, PageModel pageModel,
      {FrameModel? frameModel}) async {
    // 프레임을 생성한다.
    //if (mychangeStack.transState != TransState.start) {
    if (frameModel == null) {
      mychangeStack.startTrans();
    }
    frameModel ??= await frameManager!.createNextFrame(doNotify: false);
    // 코텐츠를 play 하고 DB 에 Create 하고 업로드까지 한다.
    logger.info('frameCreated(${frameModel.mid}');
    ContentsManager? manager =
        await ContentsManager.createContents(frameManager, modelList, frameModel, pageModel);

    mychangeStack.endTrans();
    return manager;
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
    if (model.isStickerType()) {
      return false;
    }
    if (model.isTimelineType()) {
      return false;
    }
    if (model.isMapType()) {
      return false;
    }
    if (contentsManager.getShowLength() > 0) {
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
    if (model.frameType == FrameType.weatherSticker) {
      return const WeatherStickerElements();
    }
    if (model.frameType == FrameType.weatherSticker1) {
      return WeatherStickerBase(
        weatherStickerWidget: Image.asset('assets/weather_sticker/구름조금_A_black.png'),
      );
    }
    if (model.frameType == FrameType.weatherSticker2) {
      return WeatherStickerBase(
        weatherStickerWidget: Image.asset('assets/weather_sticker/구름조금_A_white.png'),
      );
    }
    if (model.frameType == FrameType.weatherSticker3) {
      return WeatherStickerBase(
        weatherStickerWidget: Image.asset('assets/weather_sticker/구름조금_B_color.png'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget watchFrame({
    required ContentsManager? contentsManager,
    required FrameModel model,
    required Widget? child,
    required BuildContext context,
    required double applyScale,
    required bool isThumbnail,
    required double width,
    required double height,
  }) {
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
      ContentsModel? contentsModel;
      if (contentsManager != null) {
        contentsModel = contentsManager.getFirstModel();
      }
      if (contentsModel == null) {
        if (frameManager != null) {
          contentsModel = frameManager!.getFirstContents(model.mid);
        }
        if (contentsModel == null) {
          // overlay 경우일 가능성이 크다.
          //print('sdfdfsdfsdfsdfdfdffs');
          if (model.isOverlay.value == true) {
            //print('-------------------------------');
            frameManager = BookMainPage.pageManagerHolder!.findFrameManager(model.parentMid.value);
            contentsModel = frameManager!.getFirstContents(model.mid);
          }
        }
      }

      //print('applyScale = $applyScale');
      TextStyle? style;
      if (contentsModel != null) {
        style =
            contentsModel.makeTextStyle(context, applyScale: applyScale, isThumbnail: isThumbnail);
        //print('contentModel is not null, fontSize=${contentsModel.fontSize.value}');
      } else {
        //print('contentModel is null');
        style = DefaultTextStyle.of(context)
            .style
            .copyWith(fontSize: StudioConst.defaultFontSize * applyScale);
      }
      //print('width,height = $width, $height');

      return Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(StudioConst.defaultTextPadding),
        alignment: contentsModel != null
            ? bothSideAlign(contentsModel.align.value, contentsModel.valign.value)
            : Alignment.center,
        child: DigitalClock(
            textScaleFactor: applyScale,
            textStyle: style,
            showSeconds: true,
            isLive: true,
            digitalClockColor: Colors.black,
            // textScaleFactor:
            //     ((model.width.value / (50 * 2)) + 1) * applyScale, // 50 is minimum contstraint
            //digitalClockColor: Colors.transparent,
            // decoration: const BoxDecoration(
            //     color: Colors.yellow,
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.all(Radius.circular(15))),
            datetime: DateTime.now()),
      );
    }
    if (model.frameType == FrameType.stopWatch) {
      return const StopWatch();
    }
    if (model.frameType == FrameType.countDownTimer) {
      return const CountDownTimer();
    }
    return const SizedBox.shrink();
  }

  Widget stickerFrame(FrameModel model) {
    return Container(
      width: 50,
      height: 50,
      color: Colors.pink[300],
    );
  }

  Widget timelineFrame(FrameModel model) {
    if (model.frameType == FrameType.showcaseTimeline) {
      return const ShowcaseTimeline();
    }
    if (model.frameType == FrameType.footballTimeline) {
      return const FootballTimeline();
    }
    if (model.frameType == FrameType.activityTimeline) {
      return const ActivityTimeline();
    }
    if (model.frameType == FrameType.successTimeline) {
      return const SuccessTimeline();
    }
    if (model.frameType == FrameType.deliveryTimeline) {
      return const DeliveryTimeline();
    }
    if (model.frameType == FrameType.weatherTimeline) {
      return const WeatherTimeline();
    }
    if (model.frameType == FrameType.monthHorizTimeline) {
      return const HorizontalTimeline(type: FrameType.monthHorizTimeline);
    }
    if (model.frameType == FrameType.appHorizTimeline) {
      return const HorizontalTimeline(type: FrameType.appHorizTimeline);
    }
    if (model.frameType == FrameType.deliveryHorizTimeline) {
      return const HorizontalTimeline(type: FrameType.deliveryHorizTimeline);
    }
    return const SizedBox.shrink();
  }

  Widget mapFrame(FrameModel model) {
    return const CretaMapWidget();
  }

  Future<ContentsModel> _defaultTextModel(
    String frameMid,
    String bookMid, {
    FontSizeType fontSizeType = FontSizeType.userDefine,
    String remoteUrl = CretaStudioLang.defaultText,
    String name = CretaStudioLang.defaultText,
  }) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);
    retval.contentsType = ContentsType.text;
    retval.name = name;
    retval.remoteUrl = remoteUrl;
    retval.fontSizeType.set(fontSizeType, noUndo: true, save: false);
    return retval;
  }

  Future<void> createText(double widthRatio, double fontSize, FontSizeType fontSizeType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 80% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * widthRatio;
    double height = width / 6;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager!.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: FrameType.text,
    );
    ContentsModel model =
        await _defaultTextModel(frameModel.mid, frameModel.realTimeKey, fontSizeType: fontSizeType);
    model.setTextStyleProperty(
      //fontSize: fontSize / StudioVariables.applyScale,
      fontSize: fontSize,
    );

    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
  }

  //Future<void> createTextByClick(BuildContext context, LongPressDownDetails details) async {
  Future<void> createTextByClick(BuildContext context, Offset details) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    late TextStyle style;
    ExtraTextStyle? extraStyle;
    (style, extraStyle) = ContentsModel.getLastTextStyle(context);
    double fontSize = StudioConst.defaultFontSize * StudioVariables.applyScale;
    if (style.fontSize != null) {
      //print('use style.fontSize=${style.fontSize}');
      fontSize = style.fontSize!;
    } else {
      style = style.copyWith(fontSize: fontSize);
      ContentsModel.setLastTextStyle(style, null);
    }
    double height = (fontSize / StudioVariables.applyScale) +
        (StudioConst.defaultTextPadding * 2); // 모델상의 크기다. 실제 크기가 아니다.
    double width = height;
    //print('localPostion= ${details.localPosition}, width= $width');

    Offset pos = CretaUtils.positionInPage(details /*.localPosition*/, null);
    // 커서의 크기가 있어서, 조금 빼주어야 텍스트 박스가 커서 위치에 맞게 나온다.
    double posOffset = LayoutConst.topMenuCursorSize / StudioVariables.applyScale;
    pos = Offset((pos.dx - posOffset > 0 ? pos.dx - posOffset : 0),
        (pos.dy - posOffset > 0 ? pos.dy - posOffset : 0));

    //print('position in page= (${pos.dx}, ${pos.dy})');

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager!.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: pos,
      bgColor1: Colors.transparent,
      type: FrameType.text,
    );
    frameModel.isEditMode = true; // 바로 Editor 모드로 들어가도록 한다.
    //print('style.fontSize = ${style.fontSize!}');
    ContentsModel model = await _defaultTextModel(
      frameModel.mid,
      frameModel.realTimeKey,
      name: 'Text',
      remoteUrl: '',
    );
    model.setTextStyle(style);
    if (extraStyle != null) {
      model.setExtraTextStyle(extraStyle);
    }
    model.autoSizeType.set(AutoSizeType.autoFrameSize); // 가로 세로 모두 늘어나는 모드
    //print('createTextByClieck');

    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
    MiniMenu.setShowFrame(false); //  프레임이 아닌 콘텐츠가 선택되도록 하기 위해.
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
