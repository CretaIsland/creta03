// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'package:creta03/pages/studio/containees/frame/camera_frame.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_snippet.dart';

import 'package:creta03/design_system/component/creta_texture_widget.dart';
import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/snippet.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';
import '../contents/contents_thumbnail.dart';
import 'frame_play_mixin.dart';
import '../../../../data_io/key_handler.dart';

class FrameThumbnail extends StatefulWidget {
  //final FrameManager frameManager;
  final PageModel pageModel;
  final FrameModel model;
  final double applyScale;
  final double width;
  final double height;
  final bool isThumbnail;
  final void Function(String pageMid) chageEventReceived;
  const FrameThumbnail({
    super.key,
    //required this.frameManager,
    required this.pageModel,
    required this.model,
    required this.applyScale,
    required this.width,
    required this.height,
    required this.chageEventReceived,
    this.isThumbnail = false,
  });

  @override
  State<FrameThumbnail> createState() => FrameThumbnailState();
}

class FrameThumbnailState extends CretaState<FrameThumbnail> with ContaineeMixin, FramePlayMixin {
  double applyScale = 1;
  bool _isShowBorder = false;

  ContentsManager? _contentsManager;
  FrameManager? _anotherFrameManager;

  Future<bool>? _isInitialized;
  //final bool _isHover = false;

  @override
  void dispose() {
    super.dispose();
    //logger.fine('FrameThumbnail dispose================');
  }

  @override
  void initState() {
    super.initState();
    _isInitialized = initChildren();
  }

  //bool initChildren() {
  Future<bool> initChildren() async {
    setFrameManager(BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid)!);
    if (frameManager == null) {
      logger.severe('frame manager is null');
    }
    // _contentsManager = frameManager!.findContentsManager(widget.model.mid);
    // if (_contentsManager == null) {
    //   //print('new ContentsManager created (${widget.model.mid})');
    //   if (widget.model.isOverlay.value == true) {
    //     //  Overlay 이기 때문에,  ContentsManager 가 다른 frameManager 에 있는 것이므로
    //     // 해당 프레임을 찾아야 한다.
    //     _anotherFrameManager =
    //         BookMainPage.pageManagerHolder!.findFrameManager(widget.model.parentMid.value);
    //     _contentsManager = frameManager!.newContentsManager(widget.model);
    //     _contentsManager!.clearAll();
    //   } else {
    //     _contentsManager = frameManager!.newContentsManager(widget.model);
    //     _contentsManager!.clearAll();
    //   }
    // } else {
    //   //logger.fine('old ContentsManager used (${widget.model.mid})');
    // }
    _contentsManager = frameManager!.findContentsManager(widget.model);
    //while (_contentsManager!.onceDBGetComplete == false) {
    while (_contentsManager == null) {
      logger.info('wait _contentsManager');
      // 1.1 초를 쉬어서, FrameMain  에서   contents 를 가져올 시간을 벌어준다.
      await Future.delayed(const Duration(milliseconds: 1100));

      if (widget.model.isOverlay.value == true) {
        //  Overlay 이기 때문에,  ContentsManager 가 다른 frameManager 에 있는 것이므로
        // 해당 프레임을 찾아야 한다.
        _anotherFrameManager =
            BookMainPage.pageManagerHolder!.findFrameManager(widget.model.parentMid.value);
        if (_anotherFrameManager != null) {
          _contentsManager = _anotherFrameManager!.findContentsManager(widget.model);
        } else {
          logger.severe('overlay frame not found');
        }
      } else {
        _contentsManager = frameManager!.findContentsManager(widget.model);
        //썸네일에서는 가져오지 말아야 한다. 같은 COntentsManager를 쓰기때문이다.
        // await _contentsManager!.getContents();
        // _contentsManager!.addRealTimeListen(widget.model.mid);
        // _contentsManager!.reOrdering();
      }
    }
    //print('frameThumbnail initChildren(${_contentsManager!.getAvailLength()})');
    //print('frameThumbnail initChildren()');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //_initContentsManager();
    //_contentsManager = frameManager!.findContentsManager(widget.model);
    applyScale = widget.applyScale;
    // if (_contentsManager != null) {
    //   return MultiProvider(
    //     providers: [
    //       ChangeNotifierProvider<ContentsManager>.value(
    //         value: _contentsManager!,
    //       ),
    //     ],
    //     //child: _isInitialized ? _frameDropZone() : _futureBuider(),
    //     child: _futureBuider(),
    //   );
    // }
    return _futureBuider();
  }

  // Future<bool> _waitInit() async {
  //   //await widget.init();
  //   //bool isReady = widget.wcontroller!.value.isInitialized;
  //   while (!_isInitialized) {
  //     await Future.delayed(const Duration(milliseconds: 100));
  //   }
  //   return true;
  // }

  Widget _futureBuider() {
    return FutureBuilder<bool>(
        initialData: false,
        //future: _waitInit(),
        future: _isInitialized,
        builder: (context, snapshot) {
          if (snapshot.hasData == false) {
            //해당 부분은 data를 아직 받아 오지 못했을때 실행되는 부분을 의미한다.
            return CretaSnippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
                providers: [
                  ChangeNotifierProvider<ContentsManager>.value(
                    value: _contentsManager!,
                  ),
                ],
                //child: _isInitialized ? _frameDropZone() : _futureBuider(),
                child: _frameDropZone());
          }
          return const SizedBox.shrink();
        });
  }

  Widget _frameDropZone() {
    //print('_frameDropZone...');
    _isShowBorder = showBorder(widget.model, widget.pageModel, _contentsManager!, false);
    if (widget.model.shouldInsideRotate()) {
      // isOrverlay case 가 있기 때문에  page mid 도 key 에 넣어주어야 한다.
      return Transform(
        key: GlobalObjectKey('ThumbNail_Transform${widget.pageModel.mid}/${widget.model.mid}'),
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(1.0)
          ..rotateZ(CretaCommonUtils.degreeToRadian(widget.model.angle.value)),
        child: _isShowBorder ? _dottedShapeBox(widget.model) : _shapeBox(widget.model),
      );
    }
    return _isShowBorder ? _dottedShapeBox(widget.model) : _shapeBox(widget.model);
  }

  Widget _dottedShapeBox(FrameModel model) {
    return DottedBorder(
      dashPattern: const [2, 2],
      strokeWidth: 1,
      strokeCap: StrokeCap.round,
      color: CretaColor.text[700]!,
      child: _shapeBox(model),
    );
  }

  Widget _shapeBox(FrameModel model) {
    return Center(
      child: _textureBox(model).asShape(
        mid: model.mid,
        shapeType: model.shape.value,
        offset: CretaCommonUtils.getShadowOffset(
            model.shadowDirection.value, model.shadowOffset.value * applyScale),
        shadowBlur: model.shadowBlur.value,
        shadowSpread: model.shadowSpread.value * applyScale,
        shadowOpacity: model.isNoShadow() ? 0 : model.shadowOpacity.value,
        shadowColor: model.isNoShadow() ? Colors.transparent : model.shadowColor.value,
        strokeWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
        strokeColor: model.borderColor.value,
        radiusLeftBottom: model.getRealradiusLeftBottom(applyScale),
        radiusLeftTop: model.getRealradiusLeftTop(applyScale),
        radiusRightBottom: model.getRealradiusRightBottom(applyScale),
        radiusRightTop: model.getRealradiusRightTop(applyScale),
        borderCap: model.borderCap.value,
        applyScale: applyScale,
      ),
    );
  }

  Widget _textureBox(FrameModel model) {
    logger.finest('mid=${model.mid}, ${model.textureType.value}');
    if (model.textureType.value == TextureType.glass) {
      logger.finest('frame Glass!!!');
      double opacity = model.opacity.value;
      Color bgColor1 = model.bgColor1.value;
      Color bgColor2 = model.bgColor2.value;
      GradationType gradationType = model.gradationType.value;
      return _frameBox(model, false).asCretaGlass(
        width: widget.width,
        height: widget.height,
        gradient: StudioSnippet.gradient(
            gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
        opacity: opacity,
        bgColor1: bgColor1,
        bgColor2: bgColor2,
      );
    }
    return _frameBox(model, true);
  }

  Widget _frameBox(FrameModel model, bool useColor) {
    //logger.fine('_frameBox');
    if (model.isWeatherTYpe()) {
      return weatherFrame(model: model, width: widget.width, height: widget.height);
    }
    if (model.isWatchTYpe()) {
      // return watchFrame(model, null);
      if (model.frameType == FrameType.stopWatch) {
        return Container(
          width: 20,
          height: 20,
          color: Colors.grey,
          child: const Center(
            child: Icon(Icons.access_alarms, color: Colors.white, size: 24),
          ),
        );
      } else if (model.frameType == FrameType.countDownTimer) {
        return Container(
          width: 20,
          height: 20,
          color: Colors.grey,
          child: const Center(
            child: Icon(Icons.timer, color: Colors.white, size: 24),
          ),
        );
      }
      return watchFrame(
          contentsManager: _contentsManager,
          model: model,
          child: null,
          context: context,
          applyScale: applyScale,
          isThumbnail: true,
          width: widget.width,
          height: widget.height,
          timeChanged: () {});
    }
    if (model.isTimelineType()) {
      // return timelineFrame(model);
      if (model.frameType == FrameType.showcaseTimeline) {
        return Image.asset('assets/timeline_samples/showcase_timeline.png');
      }
      if (model.frameType == FrameType.footballTimeline) {
        return Image.asset('assets/timeline_samples/football_timeline.png');
      }
      if (model.frameType == FrameType.activityTimeline) {
        return Image.asset('assets/timeline_samples/activity_timeline.png');
      }
      if (model.frameType == FrameType.successTimeline) {
        return Image.asset('assets/timeline_samples/success_timeline.png');
      }
      if (model.frameType == FrameType.deliveryTimeline) {
        return Image.asset('assets/timeline_samples/delivery_timeline.png');
      }
      if (model.frameType == FrameType.weatherTimeline) {
        return Image.asset('assets/timeline_samples/weather_timeline.png');
      }
      if (model.frameType == FrameType.monthHorizTimeline) {
        return Image.asset('assets/timeline_samples/monthHoriz_timeline.png');
      }
      if (model.frameType == FrameType.appHorizTimeline) {
        return Image.asset('assets/timeline_samples/appHoriz_timeline.png');
      }
      if (model.frameType == FrameType.deliveryHorizTimeline) {
        return Image.asset('assets/timeline_samples/deliveryHoriz_timeline.png');
      }
    }
    if (model.isCameraType()) {
      return CameraFrame(model: model);
    }
    if (model.isMapType()) {
      return Image.asset('assets/google_map_thumbnail.png');
    }

    if (model.isDateTimeType()) {
      return dateTimeFrame(
        frameModel: model,
        frameManager: frameManager!,
        frameMid: model.mid,
        child: _childThumbnail(model, useColor),
      );
    }

    if (model.isNewsType()) {
      return newsFrame(
        frameModel: model,
        width: widget.width,
        height: widget.height,
      );
    }

    if (model.isDailyQuoteType()) {
      return Image.asset('quote_BG.jpg');
    }

    if (model.isDailyWordType()) {
      return Image.asset('word_BG.jpg');
    }

    if (model.isCurrencyXchangeType()) {
      return Image.asset('money-exchange.png');
    }

    // if (_contentsManager!.length() == 0) {
    //   // print('No contents in this frame');
    //   return const SizedBox.shrink();
    // }

    return _childThumbnail(model, useColor);
  }

  Widget _childThumbnail(FrameModel model, bool useColor) {
    //print('_childThumbnail(${model.bgColor1.value}, $useColor)');
    return Container(
      key: ValueKey('Container${model.mid}'),
      decoration: useColor ? _frameDeco(model) : null,
      width: double.infinity,
      height: double.infinity,
      child: _contentsManager!.length() > 0
          ? ClipRect(
              clipBehavior: Clip.hardEdge,
              child: ContentsThumbnail(
                // key: GlobalObjectKey<ContentsThumbnailState>(
                //     'ContentsThumbnail${widget.pageModel.mid}/${model.mid}'),
                key: _contentsManager!.registerContentsThumbKey(widget.pageModel.mid, model.mid),
                frameModel: model,
                pageModel: widget.pageModel,
                frameManager: frameManager!,
                contentsManager: _contentsManager!,
                width: widget.width,
                height: widget.height,
                applyScale: applyScale,
              ),
              // child: Image.asset(
              //   'assets/creta_default.png',
              //   fit: BoxFit.cover,
              // ),
            )
          : const SizedBox.shrink(),
    );
  }

  BoxDecoration _frameDeco(FrameModel model) {
    double opacity = model.opacity.value;
    Color bgColor1 = model.bgColor1.value;
    Color bgColor2 = model.bgColor2.value;
    GradationType gradationType = model.gradationType.value;

    return BoxDecoration(
      color: opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity),
      //boxShadow: StudioSnippet.basicShadow(),
      gradient: StudioSnippet.gradient(gradationType, bgColor1, bgColor2),
      //borderRadius: _getBorderRadius(model),
      //border: _getBorder(model),
      //boxShadow: model.isNoShadow() == true ? null : [_getShadow(model)],
    );
  }
}
