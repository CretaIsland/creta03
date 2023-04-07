// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/design_system/component/creta_texture_widget.dart';
import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/drag_and_drop/drop_zone_widget.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/player_handler.dart';
import '../../book_main_page.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';
import '../containee_nofifier.dart';
import '../contents/contents_main.dart';
import 'sticker/draggable_stickers.dart';

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

class _FrameEachState extends State<FrameEach> with ContaineeMixin {
  double applyScale = 1;

  ContentsManager? _contentsManager;
  PlayerHandler? _playerHandler;

  bool _isHover = false;

  @override
  void initState() {
    super.initState();
    initChildren();
    logger.finest('==========================FrameMain initialized================');
  }

  Future<void> initChildren() async {
    _playerHandler = PlayerHandler();

    _contentsManager = widget.frameManager.newContentsManager(widget.model);
    _contentsManager!.clearAll();
    await _contentsManager!.getContents();
    _contentsManager!.addRealTimeListen();
    _contentsManager!.reversOrdering();

    _contentsManager!.setPlayerHandler(_playerHandler!);

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
      child: _frameDropZone(),
    );
  }

  Widget _frameDropZone() {
    return DropZoneWidget(
      parentId: '',
      onDroppedFile: (model) {
        logger.info('frame dropzone contents added ${model.mid}');
        //model.isDynamicSize.set(true, save: false, noUndo: true);
        _onDropFrame(widget.model.mid, model); // 동영상에 맞게 frame size 를 조절하라는 뜻
      },
      child: MouseRegion(
          onEnter: ((event) {
            //logger.info('onEnter');
            setState(() {
              _isHover = true;
            });
          }),
          onExit: ((event) {
            //logger.info('onExit');
            setState(() {
              _isHover = false;
            });
          }),
          // onHover: ((event) {
          //   //logger.info('onHover');
          //   setState(() {
          //     _isHover = true;
          //   });
          // }),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _applyAnimate(widget.model),
              if (_isHover)
                BTN.fill_i_s(
                    icon: _playerHandler != null && _playerHandler!.isPause()
                        ? Icons.play_arrow
                        : Icons.pause_outlined,
                    onPressed: () {
                      logger.info('play Button pressed');
                      _playerHandler?.toggleIsPause();
                    }),
              if (_isHover)
                Align(
                  alignment: const Alignment(-0.4, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_previous,
                      onPressed: () {
                        logger.info('prev Button pressed');
                        _playerHandler?.prev();
                      }),
                ),
              if (_isHover)
                Align(
                  alignment: const Alignment(0.4, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_next,
                      onPressed: () {
                        logger.info('next Button pressed');
                        _playerHandler?.next();
                      }),
                ),
            ],
          )),
    );
  }

  void _onDropFrame(String frameId, ContentsModel contentsModel) async {
    // 콘텐츠 매니저를 생성한다.
    FrameModel? frameModel = widget.frameManager.getModel(frameId) as FrameModel?;
    if (frameModel == null) {
      return;
    }

    ContentsManager contentsManager = widget.frameManager.newContentsManager(frameModel);
    contentsModel.parentMid.set(frameModel.mid, save: false, noUndo: true);

    // 그림의 가로 세로 규격을 알아낸다.
    final reader = html.FileReader();
    reader.readAsArrayBuffer(contentsModel.file!);
    await reader.onLoad.first;
    Uint8List blob = reader.result as Uint8List;
    var image = await decodeImageFromList(blob);

    double imageWidth = image.width.toDouble();
    double imageHeight = image.height.toDouble();

    double pageHeight = widget.pageModel.height.value;
    double pageWidth = widget.pageModel.width.value;

    // width 가 더 크다
    if (imageWidth > pageWidth) {
      // 근데, width 가 page 를 넘어간다.
      imageHeight = imageHeight * (pageWidth / imageWidth);
      imageWidth = pageWidth;
    }
    //이렇게 했는데도, imageHeight 가 page 를 넘어간다.
    if (imageHeight > pageHeight) {
      imageWidth = imageWidth * (pageHeight / imageHeight);
      imageHeight = pageHeight;
    }

    contentsModel.width.set(imageWidth, save: false, noUndo: true);
    contentsModel.height.set(imageHeight, save: false, noUndo: true);
    contentsModel.aspectRatio
        .set(contentsModel.height.value / contentsModel.width.value, save: false, noUndo: true);
    double newOrder = contentsManager.lastOrder() + 1;
    contentsModel.order.set(newOrder, save: false, noUndo: true);

    logger.info(
        'create content order=$newOrder, name=${contentsModel.name}, ${contentsModel.width.value} x ${contentsModel.height.value}');

    //widget.frameManager.notify();
    // 콘텐츠 객체를 DB에 Crete 한다.
    await contentsManager.create(contentsModel, doNotify: true);

    // 업로드는  async 로 진행한다.
    if (contentsModel.file != null &&
        (contentsModel.remoteUrl == null || contentsModel.remoteUrl!.isEmpty)) {
      // upload 되어 있지 않으므로 업로드한다.
      StudioSnippet.uploadFile(contentsModel, contentsManager, blob);
    }
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
    DraggableStickers.selectedAssetId = frameModel.mid;
    widget.frameManager.setSelectedMid(frameModel.mid);
    //widget.frameManager.notify();

    // 플레이를 해야하는데, 플레이는 timer 가 model list 에 모델이 있을 경우 계속 돌리고 있게 된다.
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
    return Container(
      key: ValueKey('Container${model.mid}'),
      decoration: useColor ? _frameDeco(model) : null,
      width: double.infinity,
      height: double.infinity,
      child: ClipRect(
        clipBehavior: Clip.hardEdge,
        child: ContentsMain(
          key: ValueKey('ContentsMain${model.mid}'),
          frameModel: model,
          pageModel: widget.pageModel,
          frameManager: widget.frameManager,
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
