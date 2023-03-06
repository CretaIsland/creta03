// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:glass/glass.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:r_dotted_line_border/r_dotted_line_border.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
//import '../../../../data_io/page_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
//import '../../studio_constant.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
import '../containee_nofifier.dart';
import 'sticker/draggable_resizable.dart';
import 'sticker/stickerview.dart';

class FrameMain extends StatefulWidget {
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;

  const FrameMain({
    super.key,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
  });

  @override
  State<FrameMain> createState() => _FrameMainState();
}

class _FrameMainState extends State<FrameMain> with ContaineeMixin {
  FrameManager? _frameManager;
  //int _randomIndex = 0;
  double applyScale = 1;
  // ignore: unused_field
  FrameEventController? _frameEvent;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //applyScale = StudioVariables.scale / StudioVariables.fitScale;

    applyScale = widget.bookModel.width.value / StudioVariables.availWidth;
    //applyScaleH = widget.bookModel.height.value / StudioVariables.availHeight;

    _frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    logger.info('==========================FrameMain initialized================');

    final FrameEventController frameEvent = Get.find(/*tag: 'frameEvent1'*/);
    _frameEvent = frameEvent;
    return StreamBuilder<FrameModel>(
        stream: frameEvent.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            _frameManager!.updateModel(snapshot.data!);
          }
          return showFrame();
        });
    // return Consumer<FrameManager>(builder: (context, frameManager, child) {
    //   _frameManager = frameManager;
    //   logger.finest('FrameMain Invoked ${widget.pageModel.mid}');
    //   return showFrame();
    // });
    //return showFrame();
  }

  Widget showFrame() {
    return StickerView(
      width: widget.pageWidth,
      height: widget.pageHeight,
      // List of Stickers
      onUpdate: (update, mid) {
        logger.finest('onUpdate $update');
        saveItem(update, mid);
        FrameModel? model = _frameManager!.getSelected() as FrameModel?;
        if (model != null && model.mid == mid) {
          BookMainPage.containeeNotifier!.openSize(doNoti: false);
          BookMainPage.containeeNotifier!.notify();
        }
      },
      onDelete: (mid) {
        logger.finest('removeItem');
        removeItem(mid);
      },
      onTap: (mid) {
        logger.fine('Gest1 : onTop in StikcersView but File is frame_name.dart, setState');
        FrameModel? frame = _frameManager?.getSelected() as FrameModel?;
        if (frame == null ||
            frame.mid != mid ||
            BookMainPage.containeeNotifier!.selectedClass != ContaineeEnum.Frame) {
          setState(() {
            BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
            _frameManager?.setSelectedMid(mid);
          });
        }
        //BookMainPage.bookManagerHolder!.notify();
      },
      onResizeButtonTap: () {
        BookMainPage.containeeNotifier!.openSize(doNoti: false);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
      },
      stickerList: getStickerList(),
    );
  }

  List<Sticker> getStickerList() {
    logger.finest('getStickerList()');
    _frameManager!.frameKeyMap.clear();
    return _frameManager!.modelList.map((e) {
      //_randomIndex += 10;
      FrameModel model = e as FrameModel;

      logger.info('applyScale = $applyScale');

      double frameWidth = model.width.value * applyScale;
      double frameHeight = model.height.value * applyScale;
      double posX = model.posX.value * applyScale - LayoutConst.floatingActionPadding;
      double posY = model.posY.value * applyScale - LayoutConst.floatingActionPadding;

      GlobalKey<StickerState> stickerKey = GlobalKey<StickerState>();
      _frameManager!.frameKeyMap[model.mid] = stickerKey;

      return Sticker(
        key: stickerKey,
        id: model.mid,
        position: Offset(posX, posY),
        angle: model.angle.value * (pi / 180),
        size: Size(frameWidth, frameHeight),
        child: _applyAnimate(model),
      );
    }).toList();
  }

  Widget _applyAnimate(FrameModel model) {
    List<AnimationType> animations = AnimationType.toAniListFromInt(model.transitionEffect.value);

    if (animations.isEmpty || _frameManager!.isSelectedChanged() == false) {
      return _textureBox(model);
    }
    return getAnimation(_textureBox(model), animations);
  }

  Widget _textureBox(FrameModel model) {
    logger.severe('mid=${model.mid}, ${model.textureType.value}');
    if (model.textureType.value == TextureType.glass) {
      logger.severe('frame Glass!!!');
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
        clipBorderRadius: _getBorderRadius(model),
        radius: _getBorderRadius(model, addRadius: model.borderWidth.value * 0.7),
        border: _getBorder(model),
        borderStyle: model.borderType.value,
        borderWidth: model.borderWidth.value,
      );
    }

    return _frameBox(model, true);
  }

  Widget _frameBox(FrameModel model, bool useColor) {
    return Container(
      decoration: useColor ? _frameDeco(model) : null,
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Text('${model.order.value}'),
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
      borderRadius: _getBorderRadius(model),
      border: _getBorder(model),
    );
  }

  BoxBorder? _getBorder(FrameModel model) {
    if (model.borderColor.value == Colors.transparent || model.borderWidth.value == 0) {
      return null;
    }

    BorderSide bs = BorderSide(
        color: model.borderColor.value,
        width: model.borderWidth.value,
        style: BorderStyle.solid,
        strokeAlign: CretaUtils.borderPosition(model.borderPosition.value));

    if (model.borderType.value != 0) {
      return RDottedLineBorder(
        dottedLength: CretaUtils.borderStyle[model.borderType.value][0],
        dottedSpace: CretaUtils.borderStyle[model.borderType.value][1],
        bottom: bs,
        top: bs,
        left: bs,
        right: bs,
      );
    }
    return Border.all(
      color: model.borderColor.value,
      width: model.borderWidth.value,
      style: BorderStyle.solid,
      strokeAlign: CretaUtils.borderPosition(model.borderPosition.value),
    );
  }

  BorderRadius? _getBorderRadius(FrameModel model, {double addRadius = 0}) {
    double lt = model.radiusLeftTop.value + addRadius;
    double rt = model.radiusRightTop.value + addRadius;
    double rb = model.radiusRightBottom.value + addRadius;
    double lb = model.radiusLeftBottom.value + addRadius;
    if (lt == rt && rt == rb && rb == lb) {
      if (lt == 0) {
        return BorderRadius.zero;
      }
      return BorderRadius.all(Radius.circular(model.radiusLeftTop.value));
    }
    return BorderRadius.only(
      topLeft: Radius.circular(lt),
      topRight: Radius.circular(rt),
      bottomLeft: Radius.circular(lb),
      bottomRight: Radius.circular(rb),
    );
  }
  // ignore: unused_element

  void saveItem(DragUpdate update, String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      //logger.fine('before save widthxheight = ${model.width.value}x${model.height.value}');

      model.angle.set(update.angle * (180 / pi), save: false);
      model.posX
          .set((update.position.dx + LayoutConst.floatingActionDiameter) / applyScale, save: false);
      model.posY
          .set((update.position.dy + LayoutConst.floatingActionDiameter) / applyScale, save: false);
      model.width.set(update.size.width / applyScale, save: false);
      model.height.set(update.size.height / applyScale, save: false);
      model.save();

      //logger.fine('after save widthxheight = ${model.width.value}x${model.height.value}');
    }
  }

  void removeItem(String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      _frameManager!.modelList.remove(item);
    }
    await _frameManager!.removeToDB(mid);
  }
}
