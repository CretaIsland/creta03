// ignore_for_file: depend_on_referenced_packages, avoid_web_libraries_in_flutter

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';

//import '../../../../common/creta_utils.dart';
//import '../../../../common/creta_utils.dart';
import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../left_menu/left_menu_page.dart';
import '../../right_menu/right_menu.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';
import '../containee_nofifier.dart';
import 'frame_each.dart';
import 'frame_play_mixin.dart';
import 'sticker/draggable_resizable.dart';
import 'sticker/draggable_stickers.dart';
import 'sticker/mini_menu.dart';
import 'sticker/stickerview.dart';

class FrameMain extends StatefulWidget {
  final GlobalKey frameMainKey;

  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;
  final bool isPrevious;

  const FrameMain({
    required this.frameMainKey,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
    this.isPrevious = false,
  }) : super(key: frameMainKey);

  @override
  State<FrameMain> createState() => _FrameMainState();
}

class _FrameMainState extends State<FrameMain> with FramePlayMixin {
  //int _randomIndex = 0;
  double applyScale = 1;
  // ignore: unused_field
  FrameEventController? _receiveEvent;
  FrameEventController? _sendEvent;

  //final Offset _pageOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    //logger.finest('==========================FrameMain initialized================');

    final FrameEventController receiveEvent = Get.find(tag: 'frame-property-to-main');
    final FrameEventController sendEvent = Get.find(tag: 'frame-main-to-property');
    _receiveEvent = receiveEvent;
    _sendEvent = sendEvent;

    // final OffsetEventController linkReceiveEvent = Get.find(tag: 'frame-each-to-on-link');
    // _linkReceiveEvent = linkReceiveEvent;

    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final RenderBox? box = widget.frameMainKey.currentContext?.findRenderObject() as RenderBox?;
      // if (box != null) {
      //   logger.info('box.size=${box.size}');
      //   Offset pageOffset = box.localToGlobal(Offset.zero);
      //   frameManager?.setPageOffset(pageOffset);
      //   logger.info('box.position=$pageOffset');
      // }
      //frameManager?.setFrameMainKey(widget.frameMainKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    //applyScale = StudioVariables.scale / StudioVariables.fitScale;
    // print('FrameMain build');
    //applyScale = widget.bookModel.width.value / StudioVariables.availWidth;
    applyScale = widget.pageWidth / widget.bookModel.width.value;
    StudioVariables.applyScale = applyScale;
    logger.fine('model.width=${widget.bookModel.width.value}, realWidth=${widget.pageWidth}');
    //applyScaleH = widget.bookModel.height.value / StudioVariables.availHeight;

    initFrameManager();
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is FrameModel) {
            FrameModel model = snapshot.data! as FrameModel;
            //print('_receiveEvent = ${model.height.value * StudioVariables.applyScale}');
            frameManager!.updateModel(model);
          }
          //return CretaManager.waitReorder(manager: frameManager!, child: showFrame());
          return showFrame();
        });
  }

  Widget showFrame() {
    //FrameModel? model = frameManager!.getSelected() as FrameModel?;
    //logger.info('showFrame $applyScale  ${StudioVariables.applyScale}');
    //print('showFrame----------------------------------');
    return StickerView(
      //key: ValueKey('StickerView-${widget.pageModel.mid}'),
      book: widget.bookModel,
      pageMid: widget.pageModel.mid,
      width: widget.pageWidth,
      height: widget.pageHeight,
      frameManager: frameManager,
      // List of Stickers
      onUpdate: (update, mid) {
        //print('onUpdate ${update.hint}--------------------');
        _setItem(update, mid);
        FrameModel? model = frameManager!.getModel(mid) as FrameModel?;
        if (model != null && model.mid == mid) {
          BookMainPage.containeeNotifier!.openSize(doNoti: false);
          //_sendEvent!.sendEvent(model);
          //BookMainPage.containeeNotifier!.notify();
        }
      },
      onFrameDelete: (mid) async {
        logger.fine('Frame onFrameDelete $mid');
        FrameModel? model = await removeItem(mid);
        if (model != null) {
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Page, doNoti: true);
          _sendEvent?.sendEvent(model);
          setState(() {});
          LeftMenuPage.initTreeNodes();
          LeftMenuPage.treeInvalidate();
        }
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
        FrameModel? frame = frameManager!.getSelected() as FrameModel?;
        if (frame != null) {
          await frameManager?.copyFrame(frame);
          setState(() {});
        }
      },
      // onFrameRotate: (mid, angle) {
      //   logger.info('FrameMain.onFrameRotate 1');
      //   FrameModel? frame = frameManager?.getSelected() as FrameModel?;
      //   if (frame == null) {
      //     return;
      //   }
      //   frame.angle.set(angle);
      //   logger.info('FrameMain.onFrameRotate 2');
      //   _sendEvent?.sendEvent(frame);

      //   //setState(() {});
      // },
      // onFrameLink: (mid) {
      //   logger.info('FrameMain.onFrameLink  ${LinkParams.isLinkNewMode}');
      //   BookMainPage.bookManagerHolder!.notify();
      //   //setState(() {});
      // },
      onFrameShowUnshow: (mid) {
        frameManager!.refreshFrame(mid);
        setState(() {});
      },
      onFrameMain: (mid) {
        logger.fine('Frame onFrameMain');
        _setMain(mid);
        setState(() {});
      },
      onTap: (mid) {
        //print('FrameMain.onTap : from InkWell , frame_main.dart, no setState $mid');

        if (MiniMenu.showFrame == false) {
          ContentsManager? contentsManager = frameManager?.getContentsManager(mid);
          if (contentsManager != null) {
            ContentsModel? content = contentsManager.getCurrentModel();
            if (content != null && contentsManager.getAvailLength() > 0) {
              //print('contentsManager is not null');
              //print('3.frameManager?.setSelectedMid : ${CretaUtils.timeLap()}');
              frameManager?.setSelectedMid(mid, doNotify: false);
              // print('4.contentsManager.setSelectedMid : ${CretaUtils.timeLap()}');
              contentsManager.setSelectedMid(content.mid, doNotify: false);

              // 아래 5번 6번 두가지 Notification 때문에, 느려지게 된다.  따라서, 이를 여기서 하지 않고,
              // SelectedBox 에서 SelectedBox 가 다 그려지고 나서 하도록 한다.

              // print('5 notify MiniMenuNotifier : ${CretaUtils.timeLap()}');
              // BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
              //print('6.not notify, set only ContaineeNotifier : ${CretaUtils.timeLap()}');
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: false);
              //print('7.before tree update : ${CretaUtils.timeLap()}');
              _invokeNotify();

              LeftMenuPage.treeInvalidate();
              //print('8.after tee update.${CretaUtils.timeLap()}');

              return;
            } else {
              //print('get current model is null');
            }
          }
          //print('contentsManager is null');
        }
        FrameModel? frame = frameManager?.getSelected() as FrameModel?;
        //print('MiniMenu.showFrame == true case');
        if (frame == null ||
            frame.mid != mid ||
            BookMainPage.miniMenuNotifier!.isShow == false ||
            BookMainPage.containeeNotifier!.selectedClass != ContaineeEnum.Frame ||
            RightMenu.isOpen == false) {
          //print('3.frameManager?.setSelectedMid : ${CretaUtils.timeLap()}');

          frameManager?.setSelectedMid(mid, doNotify: false);
          //setState(() {
          // 아래 4번 5 번 두가지 Notification 때문에, 느려지게 된다.  따라서, 이를 여기서 하지 않고,
          // SelectedBox 에서 SelectedBox 가 다 그려지고 나서 하도록 한다.
          // Delay 를 주고 async 함수로 보냈다.
          // print('4.notify...here....${CretaUtils.timeLap()}');
          // BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
          //print('5.not notify, set only ContaineeNotifier: ${CretaUtils.timeLap()}');
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: false);

          _invokeNotify();
          //print('6.before tree update : ${CretaUtils.timeLap()}');
          LeftMenuPage.treeInvalidate();
          //print('7.after tee update.${CretaUtils.timeLap()}');

          //});
        }
        //frame = frameManager?.getSelected() as FrameModel?;

        //frame = frameManager?.getSelected() as FrameModel?;
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
        FrameModel? model = frameManager!.getModel(mid) as FrameModel?;
        if (model == null) {
          return;
        }
        //FrameModel? model = frameManager!.getSelected() as FrameModel?;

        if (model.mid == mid) {
          //print('2FrameMain onComplete----------------------------------------------');
          model.save();
          //print('onComplete');
          _sendEvent?.sendEvent(model);

          BookMainPage.miniMenuNotifier!.set(true);
          //BookMainPage.miniMenuContentsNotifier!.isShow = true;
          //BookMainPage.miniMenuContentsNotifier?.notify();
        }
        if (model.isTextType()) {
          ContentsManager? contentsManager = frameManager?.getContentsManager(mid);
          if (contentsManager != null) {
            ContentsModel? contentsModel = contentsManager.getFirstModel();
            if (contentsModel != null) {
              //print('font/frame size changed notify');
              if (contentsModel.isText() && contentsModel.isAutoFrameOrSide()) {
                _receiveEvent?.sendEvent(model); // autoFrameSize 를 위해, 프레임사이즈가 변경되도록 하기 위해
              }
            }
            BookMainPage.containeeNotifier!.notify(); // for rightMenu
            contentsManager.notify();
          }
        }
      },
      onScaleStart: (mid) {
        FrameModel? model = frameManager!.getSelected() as FrameModel?;
        if (model != null && model.mid == mid) {
          //print('--------------------------------------11111');
          BookMainPage.miniMenuNotifier!.set(false);
          //BookMainPage.miniMenuContentsNotifier!.isShow = false;
          //BookMainPage.miniMenuContentsNotifier?.notify();
        }
      },
      onFrontBackHover: (hover) {
        setState(() {
          DraggableStickers.isFrontBackHover = hover;
        });
      },
      onDropPage: (modelList) async {
        logger.info('onDropPage(${modelList.length})');
        await createNewFrameAndContents(modelList, widget.pageModel);
      },

      stickerList: getStickerList(),
    );
  }

  Future<void> _invokeNotify() async {
    await Future.delayed(const Duration(milliseconds: 100));
    // 속도 향상을 위해, miniMenuNotifier  와 containeeNotifier 를 이곳에서 한다.
    //print('5 before set and notify MiniMenuNotifier : ${CretaUtils.timeLap()}');
    BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
    //print('6.before notify ContaineeNotifier : ${CretaUtils.timeLap()}');
    BookMainPage.containeeNotifier!.notify();
  }

  void _exchangeOrder(String aMid, String bMid, String hint) {
    // FrameModel? aModel = frameManager!.getModel(aMid) as FrameModel?;
    // FrameModel? bModel = frameManager!.getModel(bMid) as FrameModel?;
    // if (aModel == null) {
    //   logger.fine('$aMid does not exist in modelList');
    //   return;
    // }
    // if (bModel == null) {
    //   logger.fine('$bMid does not exist in modelList');
    //   return;
    // }
    // logger.fine('Frame $hint :   ${aModel.order.value} <--> ${bModel.order.value}');

    // double aOrder = aModel.order.value;
    // double bOrder = bModel.order.value;

    // mychangeStack.startTrans();
    // aModel.order.set(bOrder);
    // bModel.order.set(aOrder);
    // mychangeStack.endTrans();
    frameManager?.exchangeOrder(aMid, bMid, hint);
  }

  List<Sticker> getStickerList() {
    //print('getStickerList()');
    //frameManager!.frameKeyMap.clear();
    frameManager!.reOrdering();
    return frameManager!.orderMapIterator((e) {
      //_randomIndex += 10;
      FrameModel model = e as FrameModel;

      logger.fine('applyScale = $applyScale');

      BookMainPage.clickEventHandler.subscribeList(
        model.eventReceive.value,
        model,
        _receiveEvent,
        null,
      );

      double frameWidth = (model.width.value /* + model.shadowSpread.value */) * applyScale;
      double frameHeight = (model.height.value /* + model.shadowSpread.value */) * applyScale;
      double posX = model.posX.value * applyScale - LayoutConst.stikerOffset / 2;
      double posY = model.posY.value * applyScale - LayoutConst.stikerOffset / 2;

      GlobalKey<StickerState>? stickerKey;
      if (widget.isPrevious == false) {
        stickerKey = frameManager!.frameKeyMap[model.mid];
        if (stickerKey == null) {
          stickerKey = GlobalKey<StickerState>();
          frameManager!.frameKeyMap[model.mid] = stickerKey;
        }
      } else {
        stickerKey = GlobalKey<StickerState>();
      }

      ContentsManager? contentsManager = frameManager!.getContentsManager(model.mid);
      if (contentsManager != null) {
        ContentsModel? contentsModel = contentsManager.getFirstModel();
        if (contentsModel != null) {
          if (contentsModel.isAutoFrameOrSide()) {
            // 자동 프레임사이즈를 결정해 주어야 한다.
            //print('AutoSizeType.autoFrameSize before $frameHeight');
            late String uri;
            late TextStyle style;
            (style, uri, _) = contentsModel.makeInfo(null, StudioVariables.applyScale, false);

            late double newFrameWidth;
            late double newFrameHeight;
            (newFrameWidth, newFrameHeight) = CretaUtils.getTextBoxSize(
              uri,
              contentsModel.autoSizeType.value,
              frameWidth,
              frameHeight,
              style,
              contentsModel.align.value,
              StudioConst.defaultTextPadding * StudioVariables.applyScale,
            );
            //print('AutoSizeType.autoFrameSize after  $frameHeight --> $newFrameHeight ($uri)');
            //model.width.set(frameWidth / StudioVariables.applyScale, noUndo: true);
            model.height.set(newFrameHeight / StudioVariables.applyScale, noUndo: true);
            frameHeight = newFrameHeight;
            if (contentsModel.isAutoFrameSize()) {
              model.width.set(newFrameWidth / StudioVariables.applyScale, noUndo: true);
              frameWidth = newFrameWidth;
            }
            // 바뀐값으로 frameHeight 값을 다시 바꾸어 놓아야 한다.
            //print('frameHeight changed ${frameHeight / StudioVariables.applyScale}-----');
          }
        }
      }

      Widget eachFrame =
          //  ContextMenuOverlay(
          //   //key: const GlobalObjectKey('frameRightMenu'),
          //   cardBuilder: (_, children) {
          //     return SizedBox(
          //       width: 180,
          //       child: Column(children: children),
          //     );
          //   },
          //   buttonStyle: ContextMenuButtonStyle(
          //     fgColor: CretaColor.text[500],
          //     bgColor: CretaColor.text[100],
          //     hoverFgColor: CretaColor.text[700],
          //     hoverBgColor: CretaColor.text[300],
          //     textStyle: CretaFont.bodySmall,
          //   ),
          //   child: ContextMenuRegion(
          //     isEnabled: StudioVariables.isPreview == false,
          //     contextMenu: GenericContextMenu(buttonConfigs: [
          //       ContextMenuButtonConfig(
          //         "감추기",
          //         onPressed: () {
          //           logger.info('View image in browser');
          //         },
          //       ),
          //       ContextMenuButtonConfig(
          //         "최대크기로",
          //         onPressed: () {
          //           logger.info('Copy image path');
          //         },
          //       )
          //     ]),
          //    child:
          FrameEach(
        model: model,
        pageModel: widget.pageModel,
        frameManager: frameManager!,
        applyScale: applyScale,
        width: frameWidth,
        height: frameHeight,
        frameOffset: Offset(posX, posY),
        //),
        //),
      );

      return Sticker(
        key: stickerKey,
        model: model,
        //id: model.mid,
        position: Offset(posX, posY),
        angle: model.angle.value * (pi / 180),
        size: Size(frameWidth, frameHeight),
        borderWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
        isMain: model.isMain.value,
        //child: Visibility(
        //visible: _isVisible(model), child: _applyAnimate(model)), //skpark Visibility 는 나중에 빼야함.
        //visible: _isVisible(model),
        child: LinkParams.connectedMid == model.mid &&
                LinkParams.linkPostion != null &&
                LinkParams.orgPostion != null
            ? eachFrame
                .animate()
                .scaleXY(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut)
                .move(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    begin: LinkParams.linkPostion! +
                        LinkParams.orgPostion! -
                        Offset(frameWidth / 2, frameHeight / 2) -
                        Offset(posX, posY))
            : eachFrame,
        //),
      );
    });
    // return frameManager!.modelList.map((e) {
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

    //   GlobalKey? stickerKey = frameManager!.frameKeyMap[model.mid];
    //   if (stickerKey == null) {
    //     stickerKey = GlobalKey();
    //     frameManager!.frameKeyMap[model.mid] = stickerKey;
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

  // bool _isVisible(FrameModel model) {
  //   if (model.eventReceive.value.length > 2 && model.showWhenEventReceived.value == true) {
  //     logger.fine(
  //         '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
  //     List<String> eventNameList = CretaUtils.jsonStringToList(model.eventReceive.value);
  //     for (String eventName in eventNameList) {
  //       if (BookMainPage.clickReceiverHandler.isEventOn(eventName) == true) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }
  //   if (BookMainPage.filterManagerHolder!.isVisible(model) == false) {
  //     return false;
  //   }
  //   //if (model.eventReceive.value.isNotEmpty && model.showWhenEventReceived.value == true) {
  //   //   logger.fine(
  //   //       '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
  //   //   if (ClickReceiverHandler.isEventOn(model.eventReceive.value) == true) {
  //   //     return true;
  //   //   }
  //   //   return false;
  //   // }
  //   // if (model.isShow.value == false) {
  //   //   if (model.isTempVisible) return true;
  //   //   return false;
  //   // } else {
  //   //   if (!model.isTempVisible) return false;
  //   //   return true;
  //   // }
  //   return model.isShow.value;
  // }

  // Widget _applyAnimate(FrameModel model) {
  //   List<AnimationType> animations = AnimationType.toAniListFromInt(model.transitionEffect.value);
  //   logger.finest('transitionEffect=${model.order.value}:${model.transitionEffect.value}');
  //   //if (animations.isEmpty || frameManager!.isSelectedChanged() == false) {
  //   if (animations.isEmpty) {
  //     return _shapeBox(model);
  //   }
  //   return getAnimation(_shapeBox(model), animations);
  // }

  // Widget _shapeBox(FrameModel model) {
  //   return _textureBox(model).asShape(
  //     mid: model.mid,
  //     shapeType: model.shape.value,
  //     offset: CretaUtils.getShadowOffset(model.shadowDirection.value, model.shadowOffset.value),
  //     blurRadius: model.shadowBlur.value,
  //     blurSpread: model.shadowSpread.value,
  //     opacity: model.shadowOpacity.value,
  //     shadowColor: model.shadowColor.value,
  //     // width: model.width.value,
  //     // height: model.height.value,
  //     strokeWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
  //     strokeColor: model.borderColor.value,
  //     radiusLeftBottom: model.radiusLeftBottom.value,
  //     radiusLeftTop: model.radiusLeftTop.value,
  //     radiusRightBottom: model.radiusRightBottom.value,
  //     radiusRightTop: model.radiusRightTop.value,
  //     borderCap: model.borderCap.value,
  //   );
  // }

  // Widget _textureBox(FrameModel model) {
  //   logger.finest('mid=${model.mid}, ${model.textureType.value}');
  //   if (model.textureType.value == TextureType.glass) {
  //     logger.finest('frame Glass!!!');
  //     double opacity = model.opacity.value;
  //     Color bgColor1 = model.bgColor1.value;
  //     Color bgColor2 = model.bgColor2.value;
  //     GradationType gradationType = model.gradationType.value;
  //     return _frameBox(model, false).asCretaGlass(
  //       gradient: StudioSnippet.gradient(
  //           gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
  //       opacity: opacity,
  //       bgColor1: bgColor1,
  //       bgColor2: bgColor2,
  //       //clipBorderRadius: _getBorderRadius(model),
  //       //radius: _getBorderRadius(model, addRadius: model.borderWidth.value * 0.7),
  //       //border: _getBorder(model),
  //       //borderStyle: model.borderType.value,
  //       //borderWidth: model.borderWidth.value,
  //       //boxShadow: _getShadow(model),
  //     );
  //   }
  //   return _frameBox(model, true);
  // }

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

  // Widget _frameBox(FrameModel model, bool useColor) {
  //   return Container(
  //     key: ValueKey('Container${model.mid}'),
  //     decoration: useColor ? _frameDeco(model) : null,
  //     width: double.infinity,
  //     height: double.infinity,
  //     child: ClipRect(
  //       clipBehavior: Clip.hardEdge,
  //       child: ContentsMain(
  //         key: ValueKey('ContentsMain${model.mid}'),
  //         frameModel: model,
  //         pageModel: widget.pageModel,
  //         frameManager: frameManager!,
  //       ),
  //       // child: Image.asset(
  //       //   'assets/creta_default.png',
  //       //   fit: BoxFit.cover,
  //       // ),
  //     ),
  //   );
  // }

  // BoxDecoration _frameDeco(FrameModel model) {
  //   double opacity = model.opacity.value;
  //   Color bgColor1 = model.bgColor1.value;
  //   Color bgColor2 = model.bgColor2.value;
  //   GradationType gradationType = model.gradationType.value;

  //   return BoxDecoration(
  //     color: opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity),
  //     //boxShadow: StudioSnippet.basicShadow(),
  //     gradient: StudioSnippet.gradient(gradationType, bgColor1, bgColor2),
  //     //borderRadius: _getBorderRadius(model),
  //     //border: _getBorder(model),
  //     //boxShadow: model.isNoShadow() == true ? null : [_getShadow(model)],
  //   );
  // }

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
    for (var item in frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      //logger.finest('before save widthxheight = ${model.width.value}x${model.height.value}');
      Offset pos = CretaUtils.positionInPage(update.position, applyScale);

      model.angle.set(update.angle * (180 / pi), save: false);
      model.posX.set(pos.dx, save: false);
      model.posY.set(pos.dy, save: false);
      model.width.set(update.size.width / applyScale, save: false);

      //print('setItem...................................');
      model.height.set(update.size.height / applyScale, save: false);
      //model.save();

      //logger.finest('after save widthxheight = ${model.width.value}x${model.height.value}');
    }
  }

  Future<FrameModel?> removeItem(String mid) async {
    mychangeStack.startTrans();
    for (var item in frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;
      model.isRemoved.set(true);
      await frameManager!.removeChild(model.mid);
      return model;
    }
    mychangeStack.endTrans();
    // for (var item in frameManager!.modelList) {
    //   if (item.mid != mid) continue;
    //   frameManager!.modelList.remove(item);
    // }
    // await frameManager!.removeToDB(mid);
    return null;
  }

  void _setMain(String mid) async {
    bool isMain = false;
    for (var item in frameManager!.modelList) {
      FrameModel model = item as FrameModel;
      if (item.mid == mid) {
        model.isMain.set(!model.isMain.value);
        isMain = model.isMain.value;
        break;
      }
    }
    if (isMain == true) {
      for (var item in frameManager!.modelList) {
        FrameModel model = item as FrameModel;
        if (item.mid != mid) {
          model.isMain.set(false);
        }
      }
    }
  }

  // Widget _drawLinkCursor() {
  //   const double iconSize = 24;
  //   Offset offset = Offset.zero;

  //   return StreamBuilder<Offset>(
  //       stream: _linkReceiveEvent!.eventStream.stream,
  //       builder: (context, snapshot) {
  //         if (snapshot.data != null && snapshot.data is Offset) {
  //           offset = snapshot.data!;
  //         }
  //         //logger.info('_drawLinkCursor ($offset)');
  //         if (StudioVariables.isLinkMode == false || offset == Offset.zero) {
  //           return const SizedBox.shrink();
  //         }

  //         // double posX = offset.dx - iconSize / 2;
  //         // double posY = offset.dy - iconSize / 2;
  //         double posX = offset.dx - iconSize / 2 - _pageOffset.dx;
  //         double posY = offset.dy - iconSize / 2 - _pageOffset.dy;

  //         //logger.info('_drawLinkCursor ($posX, $posY)');

  //         if (posX < 0 || posY < 0) {
  //           return const SizedBox.shrink();
  //         }

  //         return Positioned(
  //           left: posX,
  //           top: posY,
  //           child: const Icon(
  //             Icons.radio_button_checked_outlined,
  //             size: iconSize,
  //             color: CretaColor.primary,
  //           ),
  //         );
  //       });
  // }
}
