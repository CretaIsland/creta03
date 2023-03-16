// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:glass/glass.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

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
  FrameEventController? _receiveEvent;
  FrameEventController? _sendEvent;
  @override
  void initState() {
    super.initState();

    logger.finest('==========================FrameMain initialized================');

    final FrameEventController receiveEvent = Get.find(tag: 'frame-property-to-main');
    final FrameEventController sendEvent = Get.find(tag: 'frame-main-to-property');
    _receiveEvent = receiveEvent;
    _sendEvent = sendEvent;
  }

  @override
  Widget build(BuildContext context) {
    //applyScale = StudioVariables.scale / StudioVariables.fitScale;

    applyScale = widget.bookModel.width.value / StudioVariables.availWidth;
    //applyScaleH = widget.bookModel.height.value / StudioVariables.availHeight;

    _frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            FrameModel model = snapshot.data! as FrameModel;
            _frameManager!.updateModel(model);
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
        logger.finest('onUpdate ${update.hint}');
        _setItem(update, mid);
        FrameModel? model = _frameManager!.getSelected() as FrameModel?;
        if (model != null && model.mid == mid) {
          BookMainPage.containeeNotifier!.openSize(doNoti: false);
          //_sendEvent!.sendEvent(model);
          //BookMainPage.containeeNotifier!.notify();
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
        frame = _frameManager?.getSelected() as FrameModel?;
        if (frame != null) {
          BookMainPage.clickEventHandler.publish(frame.eventSend.value); //skpark publish 는 나중에 빼야함.
        }
        //BookMainPage.bookManagerHolder!.notify();
      },
      onResizeButtonTap: () {
        logger.finest('onResizeButtonTap');
        BookMainPage.containeeNotifier!.openSize(doNoti: false);
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
      },
      onComplete: (mid) {
        FrameModel? model = _frameManager!.getSelected() as FrameModel?;
        if (model != null && model.mid == mid) {
          //model.save();
          _sendEvent!.sendEvent(model);
        }
      },
      stickerList: getStickerList(),
    );
  }

  List<Sticker> getStickerList() {
    logger.finest('getStickerList()');
    //_frameManager!.frameKeyMap.clear();
    return _frameManager!.modelList.map((e) {
      //_randomIndex += 10;
      FrameModel model = e as FrameModel;

      logger.finest('applyScale = $applyScale');

      BookMainPage.clickEventHandler.subscribeList(
        model.eventReceive.value,
        model,
        _receiveEvent,
        null,
      );

      double frameWidth = model.width.value * applyScale;
      double frameHeight = model.height.value * applyScale;
      //double posX = (model.posX.value - LayoutConst.floatingActionPadding) * applyScale;
      //double posY = (model.posY.value - LayoutConst.floatingActionPadding) * applyScale;
      double posX = model.posX.value * applyScale - LayoutConst.floatingActionPadding;
      double posY = model.posY.value * applyScale - LayoutConst.floatingActionPadding;

      GlobalKey<StickerState>? stickerKey =
          _frameManager!.frameKeyMap[model.mid] as GlobalKey<StickerState>?;
      if (stickerKey == null) {
        stickerKey = GlobalKey<StickerState>();
        //Get.put(FrameEventController(), tag: model.mid);
        _frameManager!.frameKeyMap[model.mid] = stickerKey;
      }

      return Sticker(
        key: stickerKey,
        id: model.mid,
        position: Offset(posX, posY),
        angle: model.angle.value * (pi / 180),
        size: Size(frameWidth, frameHeight),
        child: Visibility(
            visible: _isVisible(model), child: _applyAnimate(model)), //skpark Visibility 는 나중에 빼야함.
      );
    }).toList();
  }

  bool _isVisible(FrameModel model) {
    if (model.eventReceive.value.length > 2 && model.showWhenEventReceived.value == true) {
      logger.fine(
          '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
      List<String> eventNameList = CretaUtils.jsonStringToList(model.eventReceive.value);
      for (String eventName in eventNameList) {
        if (BookMainPage.clickReceiverHandler.isEventOn(eventName) == true) {
          return true;
        }
      }
      return false;
    }
    //if (model.eventReceive.value.isNotEmpty && model.showWhenEventReceived.value == true) {
    //   logger.fine(
    //       '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
    //   if (ClickReceiverHandler.isEventOn(model.eventReceive.value) == true) {
    //     return true;
    //   }
    //   return false;
    // }
    return true;
  }

  Widget _applyAnimate(FrameModel model) {
    List<AnimationType> animations = AnimationType.toAniListFromInt(model.transitionEffect.value);
    logger.finest('transitionEffect=${model.order.value}:${model.transitionEffect.value}');
    //if (animations.isEmpty || _frameManager!.isSelectedChanged() == false) {
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
      blurSpread: model.shadowSpread.value,
      opacity: model.shadowOpacity.value,
      shadowColor: model.shadowColor.value,
      // width: model.width.value,
      // height: model.height.value,
      strokeWidth: model.borderWidth.value,
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
      key: GlobalKey(),
      decoration: useColor ? _frameDeco(model) : null,
      width: double.infinity,
      height: double.infinity,
      child: ClipRect(
        //child: Text('${model.order.value}'),
        clipBehavior: Clip.hardEdge,
        child: Image.asset(
          'assets/creta_default.png',
          fit: BoxFit.cover,
        ),
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

  void _setItem(DragUpdate update, String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      //logger.finest('before save widthxheight = ${model.width.value}x${model.height.value}');

      model.angle.set(update.angle * (180 / pi), save: false);
      // model.posX
      //     .set((update.position.dx + LayoutConst.floatingActionPadding) / applyScale, save: false);
      // model.posY
      //     .set((update.position.dy + LayoutConst.floatingActionPadding) / applyScale, save: false);
      model.posX
          .set(update.position.dx / applyScale + LayoutConst.floatingActionPadding, save: false);
      model.posY
          .set(update.position.dy / applyScale + LayoutConst.floatingActionPadding, save: false);
      model.width.set(update.size.width / applyScale, save: false);
      model.height.set(update.size.height / applyScale, save: false);
      model.save();

      //logger.finest('after save widthxheight = ${model.width.value}x${model.height.value}');
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
