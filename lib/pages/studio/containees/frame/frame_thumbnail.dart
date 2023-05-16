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
import '../../../../model/app_enums.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';
import '../contents/contents_thumbnail.dart';
import 'frame_play_mixin.dart';

class FrameThumbnail extends StatefulWidget {
  final FrameManager frameManager;
  final PageModel pageModel;
  final FrameModel model;
  final double applyScale;
  final double width;
  final double height;
  final bool isThumbnail;
  const FrameThumbnail({
    super.key,
    required this.frameManager,
    required this.pageModel,
    required this.model,
    required this.applyScale,
    required this.width,
    required this.height,
    this.isThumbnail = false,
  });

  @override
  State<FrameThumbnail> createState() => _FrameThumbnailState();
}

class _FrameThumbnailState extends State<FrameThumbnail> with ContaineeMixin, FramePlayMixin {
  double applyScale = 1;

  ContentsManager? _contentsManager;

  bool _isInitialized = false;
  //final bool _isHover = false;

  @override
  void dispose() {
    super.dispose();
    logger.info('==========================FrameThumbnail dispose================');
  }

  @override
  void initState() {
    super.initState();
    initChildren();
  }

  Future<void> initChildren() async {
    logger.info('==========================FrameThumbnail initialized================');
    frameManager = widget.frameManager;
    if (frameManager == null) {
      logger.severe('frame manager is null');
    }
    _contentsManager = frameManager!.findContentsManager(widget.model.mid);
    if (_contentsManager == null) {
      logger.info('new ContentsManager created (${widget.model.mid})');
      _contentsManager = frameManager!.newContentsManager(widget.model);
      _contentsManager!.clearAll();
    } else {
      logger.info('old ContentsManager used (${widget.model.mid})');
    }

    if (_contentsManager!.onceDBGetComplete == false) {
      await _contentsManager!.getContents();
      _contentsManager!.addRealTimeListen();
      _contentsManager!.reOrdering();
    }
    logger.info('initChildren(${_contentsManager!.getAvailLength()})');
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    applyScale = widget.applyScale;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ContentsManager>.value(
          value: _contentsManager!,
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
    return Center(child: _shapeBox(widget.model));
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
      radiusLeftBottom: model.getRealradiusLeftBottom(applyScale),
      radiusLeftTop: model.getRealradiusLeftTop(applyScale),
      radiusRightBottom: model.getRealradiusRightBottom(applyScale),
      radiusRightTop: model.getRealradiusRightTop(applyScale),
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
        child: ContentsThumbnail(
          key: GlobalObjectKey<ContentsThumbnailState>('ContentsThumbnail${model.mid}'),
          frameModel: model,
          pageModel: widget.pageModel,
          frameManager: frameManager!,
          contentsManager: _contentsManager!,
          width: widget.width,
          height: widget.height,
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
