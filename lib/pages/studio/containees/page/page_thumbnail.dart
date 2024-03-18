// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/containees/frame/frame_thumbnail.dart';
import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

//import '../../../../../design_system/component/creta_texture_widget.dart';
//import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../model/frame_model_util.dart';
import 'package:creta_studio_model/model/page_model.dart';
//import '../../../../player/abs_player.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
//import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';
import '../../../../data_io/key_handler.dart';

class PageThumbnail extends StatefulWidget {
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;
  final int pageIndex;
  //final double shrinkRatio;
  final void Function(String pageMid) changeEventReceived;

  const PageThumbnail({
    super.key,
    required this.pageIndex,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
    required this.changeEventReceived,
    //required this.shrinkRatio,
  });

  @override
  State<PageThumbnail> createState() => PageThumbnailState();
}

class PageThumbnailState extends CretaState<PageThumbnail> with ContaineeMixin {
  FrameManager? _frameManager;
  bool _onceDBGetComplete = false;
  //FrameEventController? _receiveEventFromProperty;
  //FrameEventController? _receiveEventFromMain;

  double opacity = 1;
  Color bgColor1 = Colors.transparent;
  Color bgColor2 = Colors.transparent;
  GradationType gradationType = GradationType.none;
  TextureType textureType = TextureType.none;

  //bool _buildComplete = false;

  @override
  void initState() {
    super.initState();
    initChildren();
    //final FrameEventController receiveEventFromMain = Get.find(tag: 'frame-main-to-property');
    //final FrameEventController receiveEventFromProperty = Get.find(tag: 'frame-property-to-main');

    //_receiveEventFromMain = receiveEventFromMain;
    //_receiveEventFromProperty = receiveEventFromProperty;

    afterBuild();
  }

  @override
  void didUpdateWidget(PageThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pageIndex != widget.pageIndex) {
      widget.changeEventReceived.call(widget.pageModel.mid);
      //setState(() {});
    }
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //_buildComplete = true;
      //if (_buildComplete) {
      widget.changeEventReceived.call(widget.pageModel.mid);
      //}
    });
  }

  Future<void> initChildren() async {
    //saveManagerHolder!.addBookChildren('frame=');
    _frameManager = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    //print('thumbnail initChilren frameManager=${widget.pageModel.mid}');
    // frame 을 init 하는 것은, bookMain 에서 하는 것으로 바뀌었다.
    // 여기서 frameManager 는 사실상 null 일수 가 없다. ( 신규로 frame 을 만드는 경우를 빼고)
    if (_frameManager == null) {
      logger.severe('PageThumbnailState _frameManager not found, something wierd');
      _frameManager = BookMainPage.pageManagerHolder!.newFrameManager(
        widget.bookModel,
        widget.pageModel,
      );
      await BookMainPage.pageManagerHolder!.initFrameManager(_frameManager!, widget.pageModel.mid);
    }

    _onceDBGetComplete = true;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    // logger.severe('dispose');
    // _frameManager?.removeRealTimeListen();
    // saveManagerHolder?.unregisterManager('frame', postfix: widget.pageModel.mid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 페이지가 변하기 때문에, 여기서 다시 _frameManager 를 구해 주어야 한다.
    _frameManager = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    // 이 시점에는 FrameManager Overay 에는 없는데,
    // modelList  에는 있는  frame  을 오히려 제거해 주어야 한다.
    _frameManager!.eliminateOverlay();
    // print('thumbnail mergeOverlay');
    _frameManager!.mergeOverlay();

    opacity = widget.pageModel.opacity.value;
    bgColor1 = widget.pageModel.bgColor1.value;
    bgColor2 = widget.pageModel.bgColor2.value;
    gradationType = widget.pageModel.gradationType.value;
    textureType = widget.pageModel.textureType.value;

    if (bgColor1 == Colors.transparent) {
      // 배경색이 transparent 일때,  모든 배경색 관련 값은 무효다.
      gradationType = GradationType.none;
      opacity = 1;
      bgColor2 = Colors.transparent;
      if (textureType == TextureType.glass) {
        textureType = TextureType.none;
      }
    }

    return Center(
      child: Container(
        width: widget.pageWidth,
        height: widget.pageHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.amber,
        child: Center(child: _textureBox()),
      ),
      //),
    );
  }

  Widget _textureBox() {
    // if (textureType == TextureType.glass) {
    //   logger.finest('GrassType!!!');

    //   return _drawPage(false).asCretaGlass(
    //     width: widget.pageWidth,
    //     height: widget.pageHeight,
    //     gradient: StudioSnippet.gradient(
    //         gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
    //     opacity: opacity,
    //     bgColor1: bgColor1,
    //     bgColor2: bgColor2,
    //   );
    // }
    return _drawPage(true);
  }

  Widget _drawPage(bool useColor) {
    return Container(
      key: BookMainPage.pageManagerHolder!.registerPageImageThumbnail(widget.pageModel.mid),
      decoration: useColor ? _pageDeco() : null,
      // width: widget.pageWidth,
      // height: widget.pageHeight,
      width: double.infinity,
      height: double.infinity,

      child: _waitFrame(),
    );
  }

  BoxDecoration _pageDeco() {
    Color c1 = opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity);
    Color c2 = opacity == 1 ? bgColor2 : bgColor2.withOpacity(opacity);

    return BoxDecoration(
      color: c1,
      boxShadow: StudioSnippet.basicShadow(),
      gradient: (bgColor1 != Colors.transparent && bgColor2 != Colors.transparent)
          ? StudioSnippet.gradient(gradationType, c1, c2)
          : null,
    );
  }

  Widget _waitFrame() {
    if (_onceDBGetComplete && _frameManager!.initFrameComplete) {
      //print('already _onceDBGetComplete page thumbnailr');
      return _consumerFunc();
    }
    //var retval = CretaManager.waitData(
    //print('waitDatum here');
    var retval = CretaManager.waitDatum(
      managerList: [_frameManager!],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _consumerFunc,
    );

    //_onceDBGetComplete = true;
    logger.finest('first_onceDBGetComplete page');
    return retval;
    //return consumerFunc();
  }

  Widget _consumerFunc() {
    //progressHolder = ProgressNotifier();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameManager>.value(
          value: _frameManager!,
        ),
        // ChangeNotifierProvider<SelectedModel>(
        //   create: (context) {
        //     selectedModelHolder = SelectedModel();
        //     return selectedModelHolder!;
        //   },
        // ),
      ],
      child: _drawFrames(), //_pageEffect(),
    );
  }

  // ignore: unused_element
  Widget _pageEffect() {
    if (widget.pageModel.effect.value != EffectType.none) {
      return Stack(
        alignment: Alignment.center,
        children: [
          effectWidget(widget.pageModel),
          _drawFrames(),
        ],
      );
    }
    return _drawFrames();
  }

  Widget _drawFrames() {
    return Consumer<FrameManager>(builder: (context, frameManager, child) {
      double applyScale = widget.pageWidth / widget.pageModel.width.value;

      // print('widget.pageWidth = ${widget.pageWidth}');
      // print('widget.pageModel.width=${widget.pageModel.width.value}');
      // print('StudioVariables.applyScale=${StudioVariables.applyScale}');

      // return StreamBuilder<AbsExModel>(
      //     stream: _receiveEventFromMain!.eventStream.stream,
      //     builder: (context, snapshot) {
      //       if (snapshot.data != null) {
      //         if (snapshot.data! is FrameModel) {
      //           logger.fine('_receiveEventFromMain-----------------------------------FrameModel');
      //           FrameModel model = snapshot.data! as FrameModel;
      //           frameManager.updateModel(model);

      //           if (_buildComplete) {
      //             widget.changeEventReceived.call(model.parentMid.value);
      //           }
      //         } else {
      //           logger.fine('_receiveEventFromMain-----Unknown Model');
      //         }
      //       }
      // return StreamBuilder<AbsExModel>(
      //     stream: _receiveEventFromProperty!.eventStream.stream,
      //     builder: (context, snapshot) {
      //       if (snapshot.data != null) {
      //         if (snapshot.data! is FrameModel) {
      //           logger.fine('_receiveEventFromProperty-----FrameModel');
      //           FrameModel model = snapshot.data! as FrameModel;
      //           frameManager.updateModel(model);
      //           if (_buildComplete) {
      //             widget.changeEventReceived.call(model.parentMid.value);
      //           }
      //           //widget.changeEventReceived.call(model.parentMid.value);
      //         } else {
      //           logger.fine('_receiveEventFromProperty-----Unknown Model');
      //         }
      //       }

      BookMainPage.thumbnailChanged = true;
      //print('-----------------------------------------------');
      return Stack(
        children: _frameManager!.orderMapIterator((model) {
          FrameModel frameModel = model as FrameModel;

          //if (_frameManager!.isVisible(model) == false) {
          if (FrameModelUtil.isVisible(widget.pageModel.mid, frameModel) == false &&
              FrameModelUtil.isBackgroundMusic(frameModel) == false) {
            return SizedBox.shrink();
          }
          // if (frameModel.parentMid.value != widget.pageModel.mid) {
          //   if (frameModel.isOverlay.value == true) {
          //     return SizedBox.shrink();
          //   }
          // }
          //print(
          //    '''frameModel=${frameModel.name.value}, ${frameModel.isOverlay.value}, ${(frameModel.parentMid.value != widget.pageModel.mid)}); ''');

          //print('${frameModel.mid}, ${frameModel.parentMid.value}');

          //logger.fine('frameManager.orderMapIterator-------${frameModel.name.value}');
          double frameWidth =
              (frameModel.width.value /* + model.shadowSpread.value */) * applyScale;
          double frameHeight =
              (frameModel.height.value /* + model.shadowSpread.value */) * applyScale;
          // isOverlay   가 있기 때문에, page mid 도 키로 쓰지 않으면 중복된다.

          Widget frameBox = SizedBox(
            width: frameWidth,
            height: frameHeight,
            child: FrameThumbnail(
              key: _frameManager!.registerFrameThumbnailKey(widget.pageModel.mid, frameModel.mid),
              model: frameModel,
              pageModel: widget.pageModel,
              //frameManager: _frameManager!,
              applyScale: applyScale,
              width: frameWidth,
              height: frameHeight,
              chageEventReceived: widget.changeEventReceived,
            ),
          );

          return Positioned(
            left: frameModel.posX.value * applyScale,
            top: frameModel.posY.value * applyScale,
            child:
                // frameModel.shouldOutsideRotate()
                //     ? Transform(
                //         alignment: Alignment.center,
                //         transform: Matrix4.identity()
                //           ..scale(1.0)
                //           ..rotateZ(CretaCommonUtils.degreeToRadian(frameModel.angle.value)),
                //         child: frameBox,
                //       )
                //     :
                frameBox,
          );
        }).toList(),

        //children: getStickerList(),
      );
      //});
      //});
    });
  }

  // List<Sticker> getStickerList() {
  //   logger.fine('getStickerList()');
  //   //frameManager!.frameKeyMap.clear();
  //   _frameManager!.reOrdering();
  //   return _frameManager!.orderMapIterator((e) {
  //     //_randomIndex += 10;
  //     FrameModel model = e as FrameModel;
  //     double applyScale = widget.pageWidth / widget.pageModel.width.value;
  //     logger.fine('applyScale = $applyScale');

  //     // BookMainPage.clickEventHandler.subscribeList(
  //     //   model.eventReceive.value,
  //     //   model,
  //     //   _receiveEvent,
  //     //   null,
  //     // );

  //     double frameWidth = (model.width.value + model.shadowSpread.value) * applyScale;
  //     double frameHeight = (model.height.value + model.shadowSpread.value) * applyScale;
  //     double posX = model.posX.value * applyScale - LayoutConst.stikerOffset / 2;
  //     double posY = model.posY.value * applyScale - LayoutConst.stikerOffset / 2;

  //     // GlobalKey? stickerKey = _frameManager!.frameKeyMap[model.mid];
  //     // if (stickerKey == null) {
  //     //   stickerKey = GlobalKey();
  //     //   _frameManager!.frameKeyMap[model.mid] = stickerKey;
  //     // }

  //     return Sticker(
  //       key: GlobalKey(),
  //       id: model.mid,
  //       position: Offset(posX, posY),
  //       angle: model.angle.value * (pi / 180),
  //       size: Size(frameWidth, frameHeight),
  //       borderWidth: (model.borderWidth.value * applyScale).ceilToDouble(),
  //       isMain: model.isMain.value,
  //       child: Visibility(
  //       //visible: _isVisible(model), child: _applyAnimate(model)), //skpark Visibility 는 나중에 빼야함.
  //       visible: _isVisible(model),
  //       child: FrameThumbnail(
  //         model: model,
  //         pageModel: widget.pageModel,
  //         frameManager: _frameManager!,
  //         applyScale: applyScale,
  //         width: frameWidth,
  //         height: frameHeight,
  //       ),
  //       //),
  //     );
  //   });
  // }

  // bool _isVisible(FrameModel model) {
  //   if (model.eventReceive.value.length > 2 && model.showWhenEventReceived.value == true) {
  //     logger.fine(
  //         '_isVisible eventReceive=${model.eventReceive.value}  showWhenEventReceived=${model.showWhenEventReceived.value}');
  //     List<String> eventNameList = CretaCommonUtils.jsonStringToList(model.eventReceive.value);
  //     for (String eventName in eventNameList) {
  //       if (BookMainPage.clickReceiverHandler.isEventOn(eventName) == true) {
  //         return true;
  //       }
  //     }
  //     return false;
  //   }

  //   return true;
  // }
}
