// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import 'package:creta03/pages/studio/containees/frame/camera_frame.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/design_system/component/creta_texture_widget.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/snippet.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../../../player/music/creta_music_mixin.dart';
import '../../left_menu/music/music_player_frame.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
import '../contents/contents_main.dart';
import 'frame_play_mixin.dart';
import 'on_frame_menu.dart';

class FrameEach extends StatefulWidget {
  final FrameManager frameManager;
  final PageModel pageModel;
  final FrameModel model;
  final double applyScale;
  final double width;
  final double height;
  final Offset frameOffset;
  const FrameEach({
    super.key,
    required this.frameManager,
    required this.pageModel,
    required this.model,
    required this.applyScale,
    required this.width,
    required this.height,
    required this.frameOffset,
  });

  @override
  State<FrameEach> createState() => _FrameEachState();
}

class _FrameEachState extends State<FrameEach> with ContaineeMixin, FramePlayMixin {
  double applyScale = 1;

  ContentsManager? _contentsManager;
  CretaPlayTimer? _playTimer;

  Future<bool>? _isInitialized;
  //final bool _isHover = false;
  bool _isShowBorder = false;

  //OffsetEventController? _linkSendEvent;
  AutoPlayChangeEventController? _linkReceiveEvent;
  //bool _isLinkEnter = false;

  @override
  void dispose() {
    super.dispose();
    _playTimer?.stop();
    //logger.info('==========================FrameEach dispose================');
  }

  @override
  void initState() {
    super.initState();
    _isInitialized = initChildren();

    // final OffsetEventController sendEvent = Get.find(tag: 'frame-each-to-on-link');
    // _linkSendEvent = sendEvent;
    final AutoPlayChangeEventController linkReceiveEvent = Get.find(tag: 'auto-play-to-frame');
    _linkReceiveEvent = linkReceiveEvent;
  }

  Future<bool> initChildren() async {
    //logger.info('==========================FrameEach initialized================');
    frameManager = widget.frameManager;
    if (frameManager == null) {
      logger.severe('frame manager is null');
    }
    _contentsManager = frameManager!.findContentsManager(widget.model.mid);
    if (_contentsManager == null) {
      //logger.info('new ContentsManager created (${widget.model.mid})');
      _contentsManager = frameManager!.newContentsManager(widget.model);
      _contentsManager!.clearAll();
    } else {
      //logger.info('old ContentsManager used (${widget.model.mid})');
    }
    if (_playTimer == null) {
      _playTimer = CretaPlayTimer(_contentsManager!, widget.frameManager);
      _contentsManager!.setPlayerHandler(_playTimer!);
    }
    if (_contentsManager!.onceDBGetComplete == false) {
      await _contentsManager!.getContents();
      _contentsManager!.addRealTimeListen(widget.model.mid);
      _contentsManager!.reOrdering();
    }
    //print('frame initChildren(${_contentsManager!.getAvailLength()})');
    return true;
  }

  @override
  Widget build(BuildContext context) {
    applyScale = widget.applyScale;
    if (_playTimer == null) {
      logger.severe('_playTimer is null');
    }
    _playTimer?.start();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentsManager>.value(
          value: _contentsManager!,
        ),
        ChangeNotifierProvider<CretaPlayTimer>.value(
          value: _playTimer!,
        ),
      ],
      //child: _isInitialized ? _frameDropZone() : _futureBuider(),
      child: _futureBuider(),
    );
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
            return Snippet.showWaitSign();
          }
          if (snapshot.hasError) {
            //error가 발생하게 될 경우 반환하게 되는 부분
            return Snippet.errMsgWidget(snapshot);
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return _frameDropZone();
          }
          return const SizedBox.shrink();
        });
  }

  Widget _frameDropZone() {
    logger.info('_frameDropZone...');

    _isShowBorder = showBorder(widget.model, widget.pageModel, _contentsManager!, true);
    // Widget frameBody = Stack(
    //   alignment: Alignment.center,
    //   children: [
    //     _applyAnimate(widget.model),
    //     OnFrameMenu(
    //       key: GlobalObjectKey('OnFrameMenu${widget.model.mid}'),
    //       playTimer: _playTimer,
    //       model: widget.model,
    //     ),
    //   ],
    // );

    return Center(
      child: _isDropAble(widget.model)
          ? DropZoneWidget(
              bookMid: widget.model.realTimeKey,
              parentId: '',
              onDroppedFile: (modelList) {
                _onDropFrame(widget.model.mid, modelList);
              },
              child: _frameBody1(),
            )
          : _frameBody1(),
    );
  }

  Widget _frameBody1() {
    //logger.info('================angle=${widget.model.angle.value}');

    if (widget.model.shouldInsideRotate()) {
      return Transform(
        key: GlobalObjectKey('Transform${widget.model.mid}'),
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..scale(1.0)
          ..rotateZ(CretaUtils.degreeToRadian(widget.model.angle.value)),
        child: _frameBody2(),
      );
    }
    return _frameBody2();
  }

  // Widget _frameBody2() {
  //   logger.info('frameBody2----------${LinkParams.isLinkNewMode}---------');
  //   if (LinkParams.isLinkNewMode == true) {
  //     return MouseRegion(
  //       cursor: SystemMouseCursors.none,
  //       onEnter: (event) {
  //         setState(() {
  //           logger.info('_isLinkEnter');
  //           _isLinkEnter = true;
  //         });
  //       },
  //       onExit: (event) {
  //         logger.info('_isLinkExit');
  //         setState(() {
  //           _isLinkEnter = false;
  //         });
  //       },
  //       onHover: (event) {
  //         logger.info('sendEvent ${event.position}');
  //         _linkSendEvent?.sendEvent(event.position);
  //       },
  //       child: _frameBody3(),
  //     );
  //   }
  //   return _frameBody3();
  // }

  Widget _frameBody2() {
    if (_contentsManager == null) {
      return const SizedBox.shrink();
    }
    logger.info('_frameBody2 ${widget.model.name.value}');
    logger.info('_frameBody2 ${widget.model.isShow.value}');
    logger.info('_frameBody2 ${widget.model.mid}');
    return StreamBuilder<bool>(
        stream: _linkReceiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is bool) {
            logger.info('_frameBody3 _linkReceiveEvent (AutoPlay=$snapshot.data)');
          }
          //return _applyAnimate(widget.model);

          return Stack(
            alignment: Alignment.center,
            children: [
              _applyAnimate(widget.model),
              //     LinkParams.isLinkNewMode &&
              //             StudioVariables.isPreview == false &&
              //             _isLinkEnter == true &&
              //             _contentsManager!.length() > 0
              //         ? _onLinkNewCursor()
              //         : const SizedBox.shrink(),
              (LinkParams.isLinkNewMode == false && StudioVariables.isPreview == false)
                  ? IgnorePointer(
                      child: OnFrameMenu(
                        key: GlobalObjectKey('OnFrameMenu${widget.model.mid}'),
                        playTimer: _playTimer,
                        model: widget.model,
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
            //     //     : StudioVariables.isPreview == false &&
            //     //             _isLinkEnter == true &&
            //     //             _contentsManager!.length() > 0
            //     //         ? _onLinkNewCursor()
            //     //         : const SizedBox.shrink(),
            //],
          );
        });
  }

  // Widget _onLinkNewCursor() {
  //   if (_contentsManager == null) {
  //     return const SizedBox.shrink();
  //   }
  //   // 새로운 링크를 만들때만 나타나는 투명판이다.
  //   return OnLinkCursor(
  //     key: GlobalObjectKey('OnLinkCursor${widget.model.mid}'),
  //     pageOffset: widget.frameManager.pageOffset,
  //     frameOffset: widget.frameOffset,
  //     frameManager: frameManager!,
  //     frameModel: widget.model,
  //     contentsManager: _contentsManager!,
  //     applyScale: widget.applyScale,
  //   );
  // }

  bool _isDropAble(FrameModel model) {
    if (LinkParams.isLinkNewMode) {
      return false;
    }
    if (model.frameType == FrameType.text) {
      return false;
    }
    if (model.frameType == FrameType.weather1) {
      return false;
    }
    if (model.frameType == FrameType.analogWatch) {
      return false;
    }
    if (model.frameType == FrameType.digitalWatch) {
      return false;
    }
    if (model.frameType == FrameType.stopWatch) {
      return false;
    }
    if (model.frameType == FrameType.countDownTimer) {
      return false;
    }
    if (model.frameType == FrameType.weather2) {
      return false;
    }
    if (model.frameType == FrameType.camera) {
      return false;
    }
    if (model.frameType == FrameType.map) {
      return false;
    }
    return true;
  }

  Future<void> _onDropFrame(String frameId, List<ContentsModel> contentsModelList) async {
    // 콘텐츠 매니저를 생성한다.
    FrameModel? frameModel = frameManager!.getModel(frameId) as FrameModel?;
    if (frameModel == null) {
      return;
    }

    await ContentsManager.createContents(
        frameManager, contentsModelList, frameModel, widget.pageModel, isResizeFrame: false,
        onUploadComplete: (model) {
      if (model.isMusic()) {
        GlobalObjectKey<MusicPlayerFrameState>? musicKey = musicKeyMap[widget.model.mid];
        if (musicKey != null) {
          musicKey.currentState!.addMusic(model);
        } else {
          debugPrint('musicKey is INVALID');
        }
      }
    });
  }

  Widget _applyAnimate(FrameModel model) {
    List<AnimationType> animations = AnimationType.toAniListFromInt(model.transitionEffect.value);
    logger.finest('transitionEffect=${model.order.value}:${model.transitionEffect.value}');
    if (animations.isEmpty) {
      return _isShowBorder ? _dottedShapeBox(model) : _shapeBox(model);
    }
    return getAnimation(
      _isShowBorder ? _dottedShapeBox(model) : _shapeBox(model),
      animations,
      model.mid,
    );
  }

  Widget _dottedShapeBox(FrameModel model) {
    return DottedBorder(
      dashPattern: const [6, 6],
      strokeWidth: 2,
      strokeCap: StrokeCap.round,
      color: CretaColor.text[700]!,
      child: _shapeBox(model),
    );
  }

  Widget _shapeBox(FrameModel model) {
    //return _textureBox(model);
    return _textureBox(model).asShape(
      mid: model.mid,
      shapeType: model.shape.value,
      offset: CretaUtils.getShadowOffset(
          model.shadowDirection.value, model.shadowOffset.value * applyScale),
      shadowBlur: model.shadowBlur.value,
      shadowSpread: model.shadowSpread.value * applyScale,
      shadowOpacity: model.isNoShadow() ? 0 : model.shadowOpacity.value,
      shadowColor: model.isNoShadow() ? Colors.transparent : model.shadowColor.value,
      // width: widget.width,
      // height: widget.height,
      strokeWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
      strokeColor: model.borderColor.value,
      radiusLeftBottom: model.getRealradiusLeftBottom(applyScale),
      radiusLeftTop: model.getRealradiusLeftTop(applyScale),
      radiusRightBottom: model.getRealradiusRightBottom(applyScale),
      radiusRightTop: model.getRealradiusRightTop(applyScale),
      borderCap: model.borderCap.value,
      applyScale: applyScale,
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
        height: widget.height,
        width: widget.width,
        gradient: StudioSnippet.gradient(
            gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
        opacity: opacity,
        bgColor1: bgColor1,
        bgColor2: bgColor2,
        //clipBorderRadius: _getBorderRadius(model),
        //radius: _getBorderRadius(model, addRadius: model.borderWidth.value * 0.7),
        //border: _getBorder(model),
        //borderStyle: model.borderType.value,
        //borderWidth: model.borderWidth.value,
        //boxShadow: _getShadow(model),
      );
    }
    return _frameBox(model, true);
  }

  // Widget _shadowBox(FrameModel model, bool useColor) {
  //   if (model.isNoShadow() == false && model.shadowIn.value == true) {
  //     return InnerShadow(
  //       shadows: [
  //         Shadow(
  //           shadowBlur:
  //               model.shadowBlur.value > 0 ? model.shadowBlur.value : model.shadowSpread.value,
  //           color: model.shadowOpacity.value == 1
  //               ? model.shadowColor.value
  //               : model.shadowColor.value.withOpacity(model.shadowOpacity.value),
  //           offset: CretaUtils.getShadowOffset(
  //               (180 + model.shadowDirection.value) % 360, model.shadowOffset.value),
  //         ),
  //       ],
  //       child: _frameBox(model, useColor),
  //     );
  //   }
  //   return _frameBox(model, useColor);
  // }

  Widget _frameBox(FrameModel model, bool useColor) {
    logger.info('_frameBox');
    return Container(
      key: ValueKey('Container${model.mid}'),
      decoration: useColor ? _frameDeco(model) : null,
      //color: Colors.transparent,
      width: double.infinity,
      height: double.infinity,
      child: _contentsMain(model),
    );
  }

  Widget _contentsMain(FrameModel model) {
    // if (model.isTextType() && model.isEditMode) {
    //   return InstantEditor(
    //     frameModel: model,
    //     frameManager: widget.frameManager,
    //     onEditComplete: () {
    //       setState(
    //         () {
    //           //_isEditorAlreadyExist = false;
    //           model.isEditMode = false;
    //         },
    //       );
    //       widget.frameManager.notify();
    //     },
    //   );
    // }

    if (model.isWeatherTYpe()) {
      return weatherFrame(model, widget.width, widget.height);
    }
    if (model.isWatchTYpe()) {
      return watchFrame(
        model,
        const Text('GMT-9'),
      );
    }
    if (model.isCameraType()) {
      return CameraFrame(model: model);
    }
    if (model.isMapType()) {
      return mapFrame(model);
    }
    return ClipRect(
      clipBehavior: Clip.hardEdge,
      child: ContentsMain(
        key: GlobalObjectKey<ContentsMainState>('ContentsMain${model.mid}'),
        frameModel: model,
        frameOffset: widget.frameOffset,
        pageModel: widget.pageModel,
        frameManager: frameManager!,
        contentsManager: _contentsManager!,
        applyScale: applyScale,
      ),
      // child: Image.asset(
      //   'assets/creta_default.png',
      //   fit: BoxFit.cover,
      // ),
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

  // BoxShadow _getShadow(FrameModel model) {
  //   return BoxShadow(
  //     color: model.shadowColor.value
  //         .withOpacity(CretaUtils.validCheckDouble(model.shadowOpacity.value, 0, 1)),
  //     offset: CretaUtils.getShadowOffset(model.shadowDirection.value, model.shadowOffset.value),
  //     shadowBlur: model.shadowBlur.value,
  //     spreadRadius: model.shadowSpread.value,
  //     //blurStyle: widget.shadowIn ? BlurStyle.inner : BlurStyle.normal,
  //   );
  // }

  // BoxBorder? _getBorder(FrameModel model) {
  //   if (model.borderColor.value == Colors.transparent ||
  //       model.borderWidth.value == 0 ||
  //       model.borderType.value == 0) {
  //     return null;
  //   }

  //   BorderSide bs = BorderSide(
  //       color: model.borderColor.value,
  //       width: model.borderWidth.value,
  //       style: BorderStyle.solid,
  //       strokeAlign: CretaUtils.borderPosition(model.borderPosition.value));

  //   if (model.borderType.value > 1) {
  //     return RDottedLineBorder(
  //       dottedLength: CretaUtils.borderStyle[model.borderType.value - 1][0],
  //       dottedSpace: CretaUtils.borderStyle[model.borderType.value - 1][1],
  //       bottom: bs,
  //       top: bs,
  //       left: bs,
  //       right: bs,
  //     );
  //   }
  //   return Border.all(
  //     color: model.borderColor.value,
  //     width: model.borderWidth.value,
  //     style: BorderStyle.solid,
  //     strokeAlign: CretaUtils.borderPosition(model.borderPosition.value),
  //   );
  // }

  // BorderRadius? _getBorderRadius(FrameModel model, {double addRadius = 0}) {
  //   double lt = model.radiusLeftTop.value + addRadius;
  //   double rt = model.radiusRightTop.value + addRadius;
  //   double rb = model.radiusRightBottom.value + addRadius;
  //   double lb = model.radiusLeftBottom.value + addRadius;
  //   if (lt == rt && rt == rb && rb == lb) {
  //     if (lt == 0) {
  //       return BorderRadius.zero;
  //     }
  //     return BorderRadius.all(Radius.circular(model.radiusLeftTop.value));
  //   }
  //   return BorderRadius.only(
  //     topLeft: Radius.circular(lt),
  //     topRight: Radius.circular(rt),
  //     bottomLeft: Radius.circular(lb),
  //     bottomRight: Radius.circular(rb),
  //   );
  // }
}
