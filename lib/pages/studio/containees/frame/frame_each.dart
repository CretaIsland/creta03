// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/design_system/component/creta_texture_widget.dart';
import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/snippet.dart';
import '../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/player_handler.dart';
import '../../studio_snippet.dart';
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
  const FrameEach({
    super.key,
    required this.frameManager,
    required this.pageModel,
    required this.model,
    required this.applyScale,
    required this.width,
    required this.height,
  });

  @override
  State<FrameEach> createState() => _FrameEachState();
}

class _FrameEachState extends State<FrameEach> with ContaineeMixin, FramePlayMixin {
  double applyScale = 1;

  ContentsManager? _contentsManager;
  PlayerHandler? _playerHandler;

  bool _isInitialized = false;
  //final bool _isHover = false;

  @override
  void initState() {
    super.initState();
    initChildren();
    logger.finest('==========================FrameMain initialized================');
  }

  Future<void> initChildren() async {
    _playerHandler = PlayerHandler();
    frameManager = widget.frameManager;
    _contentsManager = frameManager!.newContentsManager(widget.model);
    _contentsManager!.clearAll();
    await _contentsManager!.getContents();
    _contentsManager!.addRealTimeListen();
    _contentsManager!.reOrdering();

    logger.info('initChildren(${_contentsManager!.getAvailLength()})');

    _contentsManager!.setPlayerHandler(_playerHandler!);
    _isInitialized = true;

    _playerHandler!.start(_contentsManager!);
  }

  @override
  Widget build(BuildContext context) {
    applyScale = widget.applyScale;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentsManager>.value(
          value: _contentsManager!,
        ),
        ChangeNotifierProvider<PlayerHandler>.value(
          value: _playerHandler!,
        ),
      ],
      child: _isInitialized ? _frameDropZone() : _futureBuider(),
    );
  }

  Future<bool> _waitInit() async {
    //await widget.init();
    //bool isReady = widget.wcontroller!.value.isInitialized;
    while (!_isInitialized) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return true;
  }

  Widget _futureBuider() {
    return FutureBuilder<bool>(
        future: _waitInit(),
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
    logger.info('_frameDropZone');
    return DropZoneWidget(
      parentId: '',
      onDroppedFile: (modelList) {
        // logger.info('frame dropzone contents added ${model.mid}');
        //model.isDynamicSize.set(true, save: false, noUndo: true);
        _onDropFrame(widget.model.mid, modelList); // 동영상에 맞게 frame size 를 조절하라는 뜻
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          _applyAnimate(widget.model),
          OnFrameMenu(
            playerHandler: _playerHandler,
            model: widget.model,
          ),
        ],
      ),
      // child: MouseRegion(
      //     onEnter: ((event) {
      //       //logger.info('onEnter');
      //       setState(() {
      //         _isHover = true;
      //       });
      //     }),
      //     onExit: ((event) {
      //       //logger.info('onExit');
      //       setState(() {
      //         _isHover = false;
      //       });
      //     }),
      //     // onHover: ((event) {
      //     //   //logger.info('onHover');
      //     //   setState(() {
      //     //     _isHover = true;
      //     //   });
      //     // }),
      //     child: Stack(
      //       alignment: Alignment.center,
      //       children: [
      //         _applyAnimate(widget.model),
      //         if (_isHover)
      //           BTN.fill_i_s(
      //               icon: _playerHandler != null && _playerHandler!.isPause()
      //                   ? Icons.play_arrow
      //                   : Icons.pause_outlined,
      //               onPressed: () {
      //                 logger.info('play Button pressed');
      //                 _playerHandler?.toggleIsPause();
      //               }),
      //         if (_isHover)
      //           Align(
      //             alignment: const Alignment(-0.25, 0),
      //             child: BTN.fill_i_s(
      //                 icon: Icons.skip_previous,
      //                 onPressed: () {
      //                   logger.info('prev Button pressed');
      //                   _playerHandler?.prev();
      //                 }),
      //           ),
      //         if (_isHover)
      //           Align(
      //             alignment: const Alignment(0.25, 0),
      //             child: BTN.fill_i_s(
      //                 icon: Icons.skip_next,
      //                 onPressed: () {
      //                   logger.info('next Button pressed');
      //                   _playerHandler?.next();
      //                 }),
      //           ),
      //         if (DraggableStickers.isFrontBackHover)
      //           Text(
      //             '${widget.model.order.value} : $contentsCount',
      //             style: CretaFont.titleELarge.copyWith(color: Colors.white),
      //           ),
      //         if (DraggableStickers.isFrontBackHover)
      //           Text(
      //             '${widget.model.order.value} : $contentsCount',
      //             style: CretaFont.titleLarge,
      //           ),
      //       ],
      //     )),
    );
  }

  void _onDropFrame(String frameId, List<ContentsModel> contentsModelList) async {
    // 콘텐츠 매니저를 생성한다.
    FrameModel? frameModel = frameManager!.getModel(frameId) as FrameModel?;
    if (frameModel == null) {
      return;
    }

    await createContents(
      contentsModelList,
      frameModel,
      widget.pageModel,
      isResizeFrame: false,
    );
  }

  Widget _applyAnimate(FrameModel model) {
    List<AnimationType> animations = AnimationType.toAniListFromInt(model.transitionEffect.value);
    logger.finest('transitionEffect=${model.order.value}:${model.transitionEffect.value}');
    if (animations.isEmpty) {
      return _shapeBox(model);
    }
    return getAnimation(_shapeBox(model), animations);
  }

  Widget _shapeBox(FrameModel model) {
    return _textureBox(model).asShape(
      mid: model.mid,
      shapeType: model.shape.value,
      offset: CretaUtils.getShadowOffset(model.shadowDirection.value, model.shadowOffset.value),
      blurRadius: model.shadowBlur.value,
      blurSpread: model.shadowSpread.value * applyScale,
      opacity: model.shadowOpacity.value,
      shadowColor: model.shadowColor.value,
      // width: widget.width,
      // height: widget.height,
      strokeWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
      strokeColor: model.borderColor.value,
      radiusLeftBottom: model.radiusLeftBottom.value,
      radiusLeftTop: model.radiusLeftTop.value,
      radiusRightBottom: model.radiusRightBottom.value,
      radiusRightTop: model.radiusRightTop.value,
      borderCap: model.borderCap.value,
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
  //           blurRadius:
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
      width: double.infinity,
      height: double.infinity,
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: ContentsMain(
          key: GlobalObjectKey<ContentsMainState>('ContentsMain${model.mid}'),
          frameModel: model,
          pageModel: widget.pageModel,
          frameManager: frameManager!,
          contentsManager: _contentsManager!,
          playerHandler: _playerHandler!,
        ),
        // child: Image.asset(
        //   'assets/creta_default.png',
        //   fit: BoxFit.cover,
        // ),
      ),
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
  //     blurRadius: model.shadowBlur.value,
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
