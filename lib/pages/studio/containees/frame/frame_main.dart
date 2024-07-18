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
import 'package:creta_common/common/creta_vars.dart';
import '../../../../common/creta_utils.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/creta_popup.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
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
  State<FrameMain> createState() => FrameMainState();
}

class FrameMainState extends State<FrameMain> with FramePlayMixin {
  //int _randomIndex = 0;
  // ignore: unused_field
  FrameEventController? _receiveEvent;
  FrameEventController? _sendEvent;
  FrameEachEventController? _showOrderSendEvent;

  String _mainFrameCandiator = ''; // frame 중에 콘텐츠가 있으면서, order 가 가장 높은것.  즉, mainFrame 의 1번 후보자.

  //final Offset _pageOffset = Offset.zero;

  void _updatePage() {
    if (BookMainPage.allPageInfos.isEmpty) {
      BookMainPage.allPageInfos = BookMainPage.pageManagerHolder!.getPageInfoList(_getStickerList);
    }
  }

  @override
  void initState() {
    super.initState();

    //logger.finest('==========================FrameMain initialized================');

    final FrameEventController receiveEvent = Get.find(tag: 'frame-property-to-main');
    final FrameEventController sendEvent = Get.find(tag: 'frame-main-to-property');
    _receiveEvent = receiveEvent;
    _sendEvent = sendEvent;

    final FrameEachEventController showOrderSendEvent = Get.find(tag: 'to-FrameEach');
    _showOrderSendEvent = showOrderSendEvent;

    if (StudioVariables.isPreview) {
      // 사이즈가 변하고 있을 때는 사용사가 사용한다는 뜻이며,
      // 사이즈가 변하지 않는 다는 것은 DID 등에서 방송하고 있다는 뜻이다.
      // 사이즈가 변할때는  _updatePage 를 하게 되면, frameSize 나 위치가 적절히 조정이 되지 않기 때문에,
      _updatePage();
    }

    // final OffsetEventController linkReceiveEvent = Get.find(tag: 'frame-each-to-on-link');
    // _linkReceiveEvent = linkReceiveEvent;
    afterBuild();
  }

  Future<void> afterBuild() async {
    //WidgetsBinding.instance.addPostFrameCallback((_) async {
    // final RenderBox? box = widget.frameMainKey.currentContext?.findRenderObject() as RenderBox?;
    // if (box != null) {
    //   logger.fine('box.size=${box.size}');
    //   Offset pageOffset = box.localToGlobal(Offset.zero);
    //   frameManager?.setPageOffset(pageOffset);
    //   logger.fine('box.position=$pageOffset');
    // }
    //frameManager?.setFrameMainKey(widget.frameMainKey);
    //});
  }

  @override
  Widget build(BuildContext context) {
    //applyScale = StudioVariables.scale / StudioVariables.fitScale;
    // print('FrameMain build');
    //StudioVariables.applyScale = widget.bookModel.width.value / StudioVariables.availWidth;

    //BookMainPage.resetScale(widget.bookModel);

    logger.fine('parentPage= ${widget.pageModel.name.value}, =${widget.pageModel.mid}');
    FrameManager? founded = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    if (founded != null) {
      setFrameManager(founded);
    } else {
      logger.severe('something wiered, frameManager not found !!!');
      resetFrameManager(widget.pageModel.mid);
    }

    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is FrameModel) {
            FrameModel model = snapshot.data! as FrameModel;
            //findFrameManager(model);
            //print("_receiveEvent 'frame-property-to-main'");
            if (!frameManager!.updateModel(model)) {
              //print('updateModel failed(${model.name.value})');
            }
          }
          //return CretaManager.waitReorder(manager: frameManager!, child: showFrame());
          return showFrame();
        });
  }

  Future<void> _deleteFrame(FrameModel model) async {
    await removeItem(model.mid);

    BookMainPage.containeeNotifier!.set(ContaineeEnum.Page, doNoti: true);
    _sendEvent?.sendEvent(model);
    BookMainPage.pageManagerHolder?.invalidateThumbnail(widget.pageModel.mid);
    setState(() {});
    LeftMenuPage.initTreeNodes();
    LeftMenuPage.treeInvalidate();
  }

  Widget showFrame() {
    //FrameModel? model = frameManager!.getSelected() as FrameModel?;
    //logger.fine('showFrame $applyScale  ${StudioVariables.applyScale}');
    //print('showFrame----------------------------------');
    return StickerView(
      // key: (StudioVariables.isPreview)
      //     ? BookMainPage.pageManagerHolder?.registerStickerView()
      //     : null,
      book: widget.bookModel,
      page: widget.pageModel,
      allPageInfos: (StudioVariables.isPreview && StudioVariables.isSizeChanging == false)
          ? BookMainPage.allPageInfos
          : null,
      width: widget.pageWidth,
      height: widget.pageHeight,
      frameManager: frameManager,
      stickerList: _getStickerList(frameManager!, widget.pageModel), // List of Stickers
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
        FrameModel? model = frameManager!.getModel(mid) as FrameModel?;
        if (model != null) {
          if (model.isOverlay.value == true) {
            // ignore: use_build_context_synchronously
            CretaPopup.yesNoDialog(
              context: context,
              title: "${CretaStudioLang['deleteFrameTooltip']!}      ",
              icon: Icons.file_download_outlined,
              question:
                  '${CretaStudioLang['isOverlayFrame']!} ${CretaStudioLang['deleteConfirm']!}',
              noBtText: CretaVars.instance.isDeveloper
                  ? CretaStudioLang['noBtDnTextDeloper']!
                  : CretaStudioLang['noBtDnText']!,
              yesBtText: CretaStudioLang['yesBtDnText']!,
              yesIsDefault: true,
              onNo: () {},
              onYes: () async {
                await _deleteFrame(model);
              },
            );
          } else {
            await _deleteFrame(model);
          }
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
      //   logger.fine('FrameMain.onFrameRotate 1');
      //   FrameModel? frame = frameManager?.getSelected() as FrameModel?;
      //   if (frame == null) {
      //     return;
      //   }
      //   frame.angle.set(angle);
      //   logger.fine('FrameMain.onFrameRotate 2');
      //   _sendEvent?.sendEvent(frame);

      //   //setState(() {});
      // },
      // onFrameLink: (mid) {
      //   logger.fine('FrameMain.onFrameLink  ${LinkParams.isLinkNewMode}');
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
              //print('3.frameManager?.setSelectedMid : ${CretaCommonUtils.timeLap()}');
              frameManager?.setSelectedMid(mid, doNotify: false);
              // print('4.contentsManager.setSelectedMid : ${CretaCommonUtils.timeLap()}');
              contentsManager.setSelectedMid(content.mid, doNotify: false);

              // 아래 5번 6번 두가지 Notification 때문에, 느려지게 된다.  따라서, 이를 여기서 하지 않고,
              // SelectedBox 에서 SelectedBox 가 다 그려지고 나서 하도록 한다.

              // print('5 notify MiniMenuNotifier : ${CretaCommonUtils.timeLap()}');
              // BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
              //print('6.not notify, set only ContaineeNotifier : ${CretaCommonUtils.timeLap()}');
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents, doNoti: false);
              //print('7.before tree update : ${CretaCommonUtils.timeLap()}');
              _invokeNotify();

              LeftMenuPage.treeInvalidate();
              //print('8.after tee update.${CretaCommonUtils.timeLap()}');

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
          //print('3.frameManager?.setSelectedMid : ${CretaCommonUtils.timeLap()}');

          frameManager?.setSelectedMid(mid, doNotify: false);
          //setState(() {
          // 아래 4번 5 번 두가지 Notification 때문에, 느려지게 된다.  따라서, 이를 여기서 하지 않고,
          // SelectedBox 에서 SelectedBox 가 다 그려지고 나서 하도록 한다.
          // Delay 를 주고 async 함수로 보냈다.
          // print('4.notify...here....${CretaCommonUtils.timeLap()}');
          // BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
          //print('5.not notify, set only ContaineeNotifier: ${CretaCommonUtils.timeLap()}');
          BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame, doNoti: false);

          _invokeNotify();
          //print('6.before tree update : ${CretaCommonUtils.timeLap()}');
          LeftMenuPage.treeInvalidate();
          //print('7.after tee update.${CretaCommonUtils.timeLap()}');

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
          //frameManager?.setToDB(model); // save()로 저장하게되면, 나중에 백그라운드 저장되면서 느려진다.
          model.save(); // 그러나 만약 save 를 하지 않으면... undo redo 가 안된다.
          _sendEvent?.sendEvent(model);
          if (false == BookMainPage.pageManagerHolder?.invalidateThumbnail(widget.pageModel.mid)) {
            logger.severe('notify to thumbnail failed');
          }

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
        //  여기서 setState 를 하지말고, 정확하게 이벤트를 날려서,
        //  order 만 화면에 표시하는 부분에 정확하게 이벤트를 날리는 것으로 바꿔서 효율을 높인다.
        //setState(() {
        DraggableStickers.isFrontBackHover = hover;
        _showOrderSendEvent!.sendEvent(true);
        //print('onFrontBackHover = ${DraggableStickers.isFrontBackHover}');
        //});
      },
      onDropPage: (modelList) async {
        logger.fine('onDropPage(${modelList.length})');
        await createNewFrameAndContents(modelList, widget.pageModel);
      },
    );
  }

  //Future<void> _invokeNotify() async {
  void _invokeNotify() {
    //await Future.delayed(const Duration(milliseconds: 100));
    // 속도 향상을 위해, miniMenuNotifier  와 containeeNotifier 를 이곳에서 한다.
    //print('5 before set and notify MiniMenuNotifier : ${CretaCommonUtils.timeLap()}');
    BookMainPage.miniMenuNotifier!.set(true, doNoti: true);
    //print('6.before notify ContaineeNotifier : ${CretaCommonUtils.timeLap()}');
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

  // List<Sticker> getStickerList() {
  //   List<Sticker> stickerList = _getStickerList();
  //   return _getOverLayList(stickerList);
  // }

  List<Sticker> _getStickerList(FrameManager manager, PageModel pageModel) {
    //frameManager!.stickerKeyMap.clear();

    manager.eliminateOverlay();
    manager.mergeOverlay();

    manager.reOrdering();
    _mainFrameCandiator = manager.getMainFrameCandidator();

    return manager.orderMapIterator((e) {
      //_randomIndex += 10;
      FrameModel model = e as FrameModel;
      BookMainPage.clickEventHandler.subscribeList(
        model.eventReceive.value,
        model,
        _receiveEvent,
        null,
      );

      return _createSticker(model, manager, pageModel);
    });
  }

  // List<Sticker> _getOverLayList(List<Sticker> stickerList) {
  //   List<Sticker> retval = stickerList;
  //   for (FrameModel model in BookMainPage.overlayList()) {
  //     // overlay 중에 원본 overlay 는 이미 스티커가 만들어져 있으므로 만들지 않는다.
  //     if (model.parentMid.value != widget.pageModel.mid) {
  //       retval.add(_createSticker(model));
  //       frameManager!.modelList.add(model);
  //     }
  //   }
  //   frameManager!.reOrdering();

  //   return retval;
  // }

  Sticker _createSticker(FrameModel model, FrameManager manager, PageModel pageModel) {
    double frameWidth =
        (model.width.value /* + model.shadowSpread.value */) * StudioVariables.applyScale;
    double frameHeight =
        (model.height.value /* + model.shadowSpread.value */) * StudioVariables.applyScale;
    double posX = model.posX.value * StudioVariables.applyScale - LayoutConst.stikerOffset / 2;
    double posY = model.posY.value * StudioVariables.applyScale - LayoutConst.stikerOffset / 2;

    // GlobalKey<StickerState>? stickerKey;
    // if (widget.isPrevious == false) {
    //   stickerKey = frameManager!.stickerKeyGen(widget.pageModel.mid, model.mid);
    // } else {
    //   stickerKey = GlobalKey<StickerState>();
    // }

    // Text Type 의 경우 사이즈 계산을 위해서
    //print('7 : ${model.name.value}');
    ContentsModel? contentsModel = manager.getFirstContents(model.mid);
    if (contentsModel != null && contentsModel.isText()) {
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
          contentsModel.outLineWidth.value,
        );
        //print('AutoSizeType.autoFrameSize after  $frameHeight --> $newFrameHeight ($uri)');
        //model.width.set(frameWidth / StudioVariables.applyScale, noUndo: true);
        model.height.set((newFrameHeight / StudioVariables.applyScale).roundToDouble(),
            noUndo: true, dontRealTime: true);
        frameHeight = newFrameHeight;
        if (contentsModel.isAutoFrameSize()) {
          model.width.set((newFrameWidth / StudioVariables.applyScale).roundToDouble(),
              noUndo: true, dontRealTime: true);
          frameWidth = newFrameWidth;
        }
        // 바뀐값으로 frameHeight 값을 다시 바꾸어 놓아야 한다.
        //print('frameHeight changed ${frameHeight / StudioVariables.applyScale}-----');
      }
    }

    // String frameKeyStr =
    //     //'FrameEach${model.width.value}${frameManager!.stickerKeyMangler(widget.pageModel.mid, model.mid)}';
    //     frameManager!.frameKeyMangler(widget.pageModel.mid, model.mid);
    // GlobalKey<FrameEachState> frameKey = GlobalObjectKey<FrameEachState>(frameKeyStr);

    Widget eachFrame = FrameEach(
      key: manager.registerFrameEachKey(pageModel.mid, model.mid),
      model: model,
      pageModel: pageModel,
      frameManager: manager,
      //applyScale: StudioVariables.applyScale,
      width: frameWidth,
      height: frameHeight,
      frameOffset: Offset(posX, posY),
    );

    bool isMain = (model.isMain.value || _mainFrameCandiator == model.mid);

    return Sticker(
      key: manager.registerStickerKey(pageModel.mid, model.mid),
      //frameKey: frameKey,
      frameManager: manager,
      isOverlay: model.isOverlay.value,
      model: model,
      pageMid: pageModel.mid,
      //id: model.mid,
      position: Offset(posX, posY),
      angle: model.angle.value * (pi / 180),
      frameSize: Size(frameWidth, frameHeight),
      borderWidth: (model.borderWidth.value * StudioVariables.applyScale).ceilToDouble(),
      isMain: isMain,
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
  }

  void _setItem(DragUpdate update, String mid) async {
    for (var item in frameManager!.modelList) {
      if (item.mid != mid) continue;
      FrameModel model = item as FrameModel;

      //print('before save widthxheight = ${model.width.value}x${model.height.value}');
      Offset pos = BookMainPage.bookManagerHolder!.positionInPage(
        update.position,
        StudioVariables.applyScale,
      );

      model.angle.set(update.angle * (180 / pi), save: false);
      model.posX.set(pos.dx, save: false);
      model.posY.set(pos.dy, save: false);
      model.width
          .set((update.size.width / StudioVariables.applyScale).roundToDouble(), save: false);

      //print('setItem...................................');
      model.height
          .set((update.size.height / StudioVariables.applyScale).roundToDouble(), save: false);
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
      if (model.isOverlay.value == true) {
        model.isOverlay.set(false);
        MyChange<FrameModel> c = MyChange<FrameModel>(
          model,
          execute: () async {
            BookMainPage.removeOverlay(model.mid);
          },
          redo: () async {
            BookMainPage.removeOverlay(model.mid);
          },
          undo: (FrameModel old) async {
            BookMainPage.addOverlay(model);
          },
        );
        mychangeStack.add(c);
      }
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
      _mainFrameCandiator = '';
      for (var item in frameManager!.modelList) {
        FrameModel model = item as FrameModel;
        if (item.mid != mid) {
          model.isMain.set(false); // 다른것들을 메인에서 해제
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
  //         //logger.fine('_drawLinkCursor ($offset)');
  //         if (StudioVariables.isLinkMode == false || offset == Offset.zero) {
  //           return const SizedBox.shrink();
  //         }

  //         // double posX = offset.dx - iconSize / 2;
  //         // double posY = offset.dy - iconSize / 2;
  //         double posX = offset.dx - iconSize / 2 - _pageOffset.dx;
  //         double posY = offset.dy - iconSize / 2 - _pageOffset.dy;

  //         //logger.fine('_drawLinkCursor ($posX, $posY)');

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
