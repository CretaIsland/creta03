// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:glass/glass.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/frame_manager.dart';
//import '../../../../data_io/page_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
//import '../../studio_constant.dart';
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
    applyScale = StudioVariables.scale / StudioVariables.fitScale;
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
        //logger.fine('saveItem ${update.angle}');
        saveItem(update, mid);
        // FrameModel? model = _frameManager!.getModel(mid) as FrameModel?;
        // if (model != null) {
        //   _frameEvent?.sendEvent(model);
        // }
        FrameModel? model = _frameManager!.getSelected() as FrameModel?;
        if (model != null && model.mid == mid) {
          BookMainPage.containeeNotifier!.notify();
        }
      },
      onDelete: (mid) {
        logger.finest('removeItem');
        removeItem(mid);
      },
      onTap: (mid) {
        logger.fine('frame clicked');
        // setState(() {
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
        _frameManager?.setSelectedMid(mid); // });
        //BookMainPage.bookManagerHolder!.notify();
      },
      onResizeButtonTap: () {
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
      double posX = model.posX.value * applyScale;
      double posY = model.posY.value * applyScale;

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
    );
  }

  // ignore: unused_element

  void saveItem(DragUpdate update, String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      logger.fine('before save widthxheight = ${model.width.value}x${model.height.value}');

      model.angle.set(update.angle * (180 / pi), save: false);
      model.posX.set(update.position.dx, save: false);
      model.posY.set(update.position.dy, save: false);
      model.width.set(update.size.width, save: false);
      model.height.set(update.size.height, save: false);
      model.save();

      logger.fine('after save widthxheight = ${model.width.value}x${model.height.value}');
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
