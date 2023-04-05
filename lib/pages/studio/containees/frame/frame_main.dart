// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'dart:math';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:creta03/design_system/component/shape/creta_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
//import 'package:glass/glass.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/hycop_factory.dart';
import 'package:hycop/hycop/model/file_model.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
//import '../../../../data_io/page_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
//import '../../studio_constant.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';
import '../containee_nofifier.dart';
import '../contents/contents_main.dart';
import 'sticker/draggable_resizable.dart';
import 'sticker/draggable_stickers.dart';
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

    //applyScale = widget.bookModel.width.value / StudioVariables.availWidth;
    applyScale = widget.pageWidth / widget.bookModel.width.value;
    logger.fine('model.width=${widget.bookModel.width.value}, realWidth=${widget.pageWidth}');
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
    FrameModel? model = _frameManager!.getSelected() as FrameModel?;
    return StickerView(
      width: widget.pageWidth,
      height: widget.pageHeight,
      frameModel: model,
      // List of Stickers
      onUpdate: (update, mid) {
        logger.fine('onUpdate ${update.hint}');
        _setItem(update, mid);
        if (model != null && model.mid == mid) {
          BookMainPage.containeeNotifier!.openSize(doNoti: false);
          //_sendEvent!.sendEvent(model);
          //BookMainPage.containeeNotifier!.notify();
        }
      },
      onFrameDelete: (mid) {
        logger.fine('Frame onFrameDelete $mid');
        removeItem(mid);
        setState(() {});
      },
      onFrameBack: (aMid, bMid) {
        _exchangeOrder(aMid, bMid, 'onFrameBack');
        setState(() {});
      },
      onFrameFront: (aMid, bMid) {
        _exchangeOrder(aMid, bMid, 'onFrameFront');
        setState(() {});
      },
      onFrameCopy: (mid) async {
        logger.fine('Frame onFrameCopy');
        FrameModel? frame = _frameManager?.getSelected() as FrameModel?;
        await _frameManager?.copyFrame(frame!);
        setState(() {});
      },
      onFrameRotate: (mid, angle) {
        logger.info('FrameMain.onFrameRotate 1');
        FrameModel? frame = _frameManager?.getSelected() as FrameModel?;
        if (frame == null) {
          return;
        }
        frame.angle.set(angle);
        logger.info('FrameMain.onFrameRotate 2');
        //setState(() {});
      },
      onFrameMain: (mid) {
        logger.fine('Frame onFrameMain');
        _setMain(mid);
        setState(() {});
      },
      onTap: (mid) {
        logger.fine('onTap : from InkWell , frame_name.dart, no setState');
        FrameModel? frame = _frameManager?.getSelected() as FrameModel?;
        if (frame == null ||
            frame.mid != mid ||
            BookMainPage.containeeNotifier!.selectedClass != ContaineeEnum.Frame) {
          //setState(() {
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
          _frameManager?.setSelectedMid(mid);
          //});
        }
        frame = _frameManager?.getSelected() as FrameModel?;
        //if (frame != null) {
        //BookMainPage.clickEventHandler.publish(frame.eventSend.value); //skpark publish 는 나중에 빼야함.
        //}
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
          logger.fine('onComplete');
          _sendEvent?.sendEvent(model);
          BookMainPage.miniMenuNotifier?.notify();
        }
      },
      onDropContents: (model) async {
        //logger.fine('onDropContents, ${model.isDynamicSize.value}');

        // 프레임을 생성한다.
        FrameModel frameModel = await _frameManager!.createNextFrame(doNotify: false);

        // 콘텐츠 매니저를 생성한다.
        ContentsManager contentsManager = _frameManager!.newContentsManager(frameModel);
        model.parentMid.set(frameModel.mid, save: false, noUndo: true);

        // 그림의 가로 세로 규격을 알아낸다.
        final reader = html.FileReader();
        reader.readAsArrayBuffer(model.file!);
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

        model.width.set(imageWidth, save: false, noUndo: true);
        model.height.set(imageHeight, save: false, noUndo: true);
        model.aspectRatio.set(model.height.value / model.width.value, save: false, noUndo: true);

        logger.info('contentsSize, ${model.width.value} x ${model.height.value}');

        // 그림의 규격에 따라 프레임 사이즈를 수정해 준다
        _frameManager?.resizeFrame(
          frameModel,
          model.aspectRatio.value,
          model.width.value,
          model.height.value,
          invalidate: true,
        );

        // 콘텐츠 객체를 DB에 Crete 한다.
        await contentsManager.create(model, doNotify: false);

        // 업로드는  async 로 진행한다.
        if (model.file != null && (model.remoteUrl == null || model.remoteUrl!.isEmpty)) {
          // upload 되어 있지 않으므로 업로드한다.
          _uploadFile(model, contentsManager, blob);
        }
        BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: true);
        DraggableStickers.selectedAssetId = frameModel.mid;
        _frameManager!.setSelectedMid(frameModel.mid);
        //_frameManager!.notify();

        // 플레이를 해야하는데, 플레이는 timer 가 model list 에 모델이 있을 경우 계속 돌리고 있게 된다.
      },
      stickerList: getStickerList(),
    );
  }

  Future<void> _uploadFile(
    ContentsModel model,
    ContentsManager contentsManager,
    Uint8List blob,
  ) async {
    // 파일명을 확장자와 파일명으로 분리함.
    int pos = model.file!.name.lastIndexOf('.');
    String name = '';
    String ext = '';
    if (pos > 0) {
      name = model.file!.name.substring(0, pos);
      ext = model.file!.name.substring(pos);
    } else if (pos == 0) {
      name = '';
      ext = model.file!.name;
    } else {
      name = model.file!.name;
      ext = '';
    }

    String uniqFileName = '${name}_${model.bytes}$ext';

    FileModel? fileModel = await HycopFactory.storage!.uploadFile(uniqFileName, model.mime, blob);

    if (fileModel != null) {
      // modelList 가 그사이 갱신되었을 수가 있기 때문에, 다시 가져온다.
      ContentsModel? reModel = contentsManager.getModel(model.mid) as ContentsModel?;
      reModel ??= model;
      reModel.remoteUrl = fileModel.fileView;
      logger.info('uploaded url = ${reModel.url}');
      logger.info('uploaded fileName = ${reModel.name}');
      logger.info('uploaded remoteUrl = ${reModel.remoteUrl!}');
      logger.info('uploaded aspectRatio = ${reModel.aspectRatio.value}');
      //model.save(); //<-- save 는 지연되므로 setToDB 를 바로 호출하는 것이 바람직하다.
      await contentsManager.setToDB(reModel);
    } else {
      logger.severe('upload failed ${model.file!.name}');
    }
  }

  void _exchangeOrder(String aMid, String bMid, String hint) {
    FrameModel? aModel = _frameManager!.getModel(aMid) as FrameModel?;
    FrameModel? bModel = _frameManager!.getModel(bMid) as FrameModel?;
    if (aModel == null) {
      logger.fine('$aMid does not exist in modelList');
      return;
    }
    if (bModel == null) {
      logger.fine('$bMid does not exist in modelList');
      return;
    }
    logger.fine('Frame $hint :   ${aModel.order.value} <--> ${bModel.order.value}');

    double aOrder = aModel.order.value;
    double bOrder = bModel.order.value;

    mychangeStack.startTrans();
    aModel.order.set(bOrder);
    bModel.order.set(aOrder);
    mychangeStack.endTrans();
  }

  List<Sticker> getStickerList() {
    logger.fine('getStickerList()');
    //_frameManager!.frameKeyMap.clear();
    _frameManager!.reOrdering();
    return _frameManager!.orderMapIterator((e) {
      //_randomIndex += 10;
      FrameModel model = e as FrameModel;

      logger.fine('applyScale = $applyScale');

      BookMainPage.clickEventHandler.subscribeList(
        model.eventReceive.value,
        model,
        _receiveEvent,
        null,
      );

      double frameWidth = model.width.value * applyScale;
      double frameHeight = model.height.value * applyScale;
      double posX = model.posX.value * applyScale - LayoutConst.stikerOffset / 2;
      double posY = model.posY.value * applyScale - LayoutConst.stikerOffset / 2;

      GlobalKey? stickerKey = _frameManager!.frameKeyMap[model.mid];
      if (stickerKey == null) {
        stickerKey = GlobalKey();
        _frameManager!.frameKeyMap[model.mid] = stickerKey;
      }

      return Sticker(
        key: stickerKey,
        id: model.mid,
        position: Offset(posX, posY),
        angle: model.angle.value * (pi / 180),
        size: Size(frameWidth, frameHeight),
        borderWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
        isMain: model.isMain.value,
        child: Visibility(
            visible: _isVisible(model), child: _applyAnimate(model)), //skpark Visibility 는 나중에 빼야함.
      );
    });
    // return _frameManager!.modelList.map((e) {
    //   //_randomIndex += 10;
    //   FrameModel model = e as FrameModel;

    //   logger.fine('applyScale = $applyScale');

    //   BookMainPage.clickEventHandler.subscribeList(
    //     model.eventReceive.value,
    //     model,
    //     _receiveEvent,
    //     null,
    //   );

    //   double frameWidth = model.width.value * applyScale;
    //   double frameHeight = model.height.value * applyScale;
    //   double posX = model.posX.value * applyScale - LayoutConst.stikerOffset / 2;
    //   double posY = model.posY.value * applyScale - LayoutConst.stikerOffset / 2;

    //   GlobalKey? stickerKey = _frameManager!.frameKeyMap[model.mid];
    //   if (stickerKey == null) {
    //     stickerKey = GlobalKey();
    //     _frameManager!.frameKeyMap[model.mid] = stickerKey;
    //   }

    //   return Sticker(
    //     key: stickerKey,
    //     id: model.mid,
    //     position: Offset(posX, posY),
    //     angle: model.angle.value * (pi / 180),
    //     size: Size(frameWidth, frameHeight),
    //     borderWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
    //     isMain: model.isMain.value,
    //     child: Visibility(
    //         visible: _isVisible(model), child: _applyAnimate(model)), //skpark Visibility 는 나중에 빼야함.
    //   );
    // }).toList();
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
          frameManager: _frameManager!,
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

  void _setItem(DragUpdate update, String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      //logger.finest('before save widthxheight = ${model.width.value}x${model.height.value}');

      model.angle.set(update.angle * (180 / pi), save: false);
      model.posX.set((update.position.dx + LayoutConst.stikerOffset / 2) / applyScale, save: false);
      model.posY.set((update.position.dy + LayoutConst.stikerOffset / 2) / applyScale, save: false);
      model.width.set(update.size.width / applyScale, save: false);
      model.height.set(update.size.height / applyScale, save: false);
      model.save();

      //logger.finest('after save widthxheight = ${model.width.value}x${model.height.value}');
    }
  }

  void removeItem(String mid) async {
    for (var item in _frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;
      model.isRemoved.set(true);
    }
    // for (var item in _frameManager!.modelList) {
    //   if (item.mid != mid) continue;
    //   _frameManager!.modelList.remove(item);
    // }
    // await _frameManager!.removeToDB(mid);
  }

  void _setMain(String mid) async {
    for (var item in _frameManager!.modelList) {
      FrameModel model = item as FrameModel;
      if (item.mid == mid) {
        model.isMain.set(true);
      } else {
        model.isMain.set(false);
      }
    }
  }
}
