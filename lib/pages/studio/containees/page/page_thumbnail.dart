// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/containees/frame/frame_thumbnail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
//import '../../../../player/abs_player.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../containee_mixin.dart';

class PageThumbnail extends StatefulWidget {
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;

  const PageThumbnail({
    super.key,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
  });

  @override
  State<PageThumbnail> createState() => PageThumbnailState();
}

class PageThumbnailState extends State<PageThumbnail> with ContaineeMixin {
  FrameManager? _frameManager;
  bool _onceDBGetComplete = false;
  FrameEventController? _receiveEventFromProperty;
  FrameEventController? _receiveEventFromMain;

  @override
  void initState() {
    super.initState();
    initChildren();
    final FrameEventController receiveEventFromMain = Get.find(tag: 'frame-main-to-property');
    final FrameEventController receiveEventFromProperty = Get.find(tag: 'frame-property-to-main');
    _receiveEventFromMain = receiveEventFromMain;
    _receiveEventFromProperty = receiveEventFromProperty;
  }

  Future<void> initChildren() async {
    //saveManagerHolder!.addBookChildren('frame=');
    _frameManager = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    // frame 을 init 하는 것은, bookMain 에서 하는 것으로 바뀌었다.
    // 여기서 frameManager 는 사실상 null 일수 가 없다. ( 신규로 frame 을 만드는 경우를 빼고)
    if (_frameManager == null) {
      logger.info('framManger newly creation start---------------------');
      _frameManager = BookMainPage.pageManagerHolder!.newFrameManager(
        widget.bookModel,
        widget.pageModel,
      );
      await BookMainPage.pageManagerHolder!.initFrameManager(_frameManager!);
      logger.info('framManger newly creation end---------------------');
    }
    _onceDBGetComplete = true;
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
    TextureType textureType = getTextureType(widget.bookModel, widget.pageModel);

    if (textureType == TextureType.glass) {
      logger.finest('GrassType!!!');
      double opacity = widget.bookModel.opacity.value;
      Color bgColor1 = widget.bookModel.bgColor1.value;
      Color bgColor2 = widget.bookModel.bgColor2.value;
      GradationType gradationType = widget.bookModel.gradationType.value;

      if (widget.pageModel.bgColor1.value != Colors.transparent) {
        opacity = widget.pageModel.opacity.value;
        bgColor1 = widget.pageModel.bgColor1.value;
        bgColor2 = widget.pageModel.bgColor2.value;
        gradationType = widget.pageModel.gradationType.value;
      }
      return _drawPage(true).asCretaGlass(
        gradient: StudioSnippet.gradient(
            gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
        opacity: opacity,
        bgColor1: bgColor1,
        bgColor2: bgColor2,
      );
    }
    return _drawPage(true);
  }

  Widget _drawPage(bool useColor) {
    return Container(
      decoration: useColor ? _pageDeco() : null,
      // width: widget.pageWidth,
      // height: widget.pageHeight,
      width: double.infinity,
      height: double.infinity,

      child: _waitFrame(),
    );
  }

  BoxDecoration _pageDeco() {
    double opacity = widget.bookModel.opacity.value;
    Color bgColor1 = widget.bookModel.bgColor1.value;
    Color bgColor2 = widget.bookModel.bgColor2.value;
    GradationType gradationType = widget.bookModel.gradationType.value;

    if (widget.pageModel.bgColor1.value != Colors.transparent) {
      opacity = widget.pageModel.opacity.value;
      bgColor1 = widget.pageModel.bgColor1.value;
      bgColor2 = widget.pageModel.bgColor2.value;
      gradationType = widget.pageModel.gradationType.value;
    }

    return BoxDecoration(
      color: opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity),
      boxShadow: StudioSnippet.basicShadow(),
      gradient: StudioSnippet.gradient(gradationType, bgColor1, bgColor2),
    );
  }

  Widget _waitFrame() {
    if (_onceDBGetComplete && _frameManager!.initFrameComplete) {
      logger.info('already _onceDBGetComplete');
      return _consumerFunc();
    }
    //var retval = CretaModelSnippet.waitData(
    var retval = CretaModelSnippet.waitDatum(
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
      child: _pageEffect(),
    );
  }

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
      logger.info('_drawFrames start = ${widget.pageModel.name.value}==================');
      logger.info('widget.pageWidth=${widget.pageWidth}==================');
      logger.info('widget.pageModel.width.value=${widget.pageModel.width.value}==================');
      logger.info('applyScale=$applyScale==================');

      return StreamBuilder<AbsExModel>(
          stream: _receiveEventFromMain!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              if (snapshot.data! is FrameModel) {
                logger.info('_receiveEventFromMain-----FrameModel');
                FrameModel model = snapshot.data! as FrameModel;
                frameManager.updateModel(model);
              } else {
                logger.info('_receiveEventFromMain-----Unknown Model');
              }
            }
            return StreamBuilder<AbsExModel>(
                stream: _receiveEventFromProperty!.eventStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data! is FrameModel) {
                      logger.info('_receiveEventFromProperty-----FrameModel');
                      FrameModel model = snapshot.data! as FrameModel;
                      frameManager.updateModel(model);
                    } else {
                      logger.info('_receiveEventFromProperty-----Unknown Model');
                    }
                  }

                  return Stack(
                    children: _frameManager!.orderMapIterator((model) {
                      FrameModel frameModel = model as FrameModel;
                      logger.info('frameManager.orderMapIterator-------${frameModel.name.value}');
                      double frameWidth =
                          (model.width.value + model.shadowSpread.value) * applyScale;
                      double frameHeight =
                          (model.height.value + model.shadowSpread.value) * applyScale;

                      return Positioned(
                        left: frameModel.posX.value * applyScale,
                        top: frameModel.posY.value * applyScale,
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..scale(1.0)
                            ..rotateZ(CretaUtils.degreeToRadian(frameModel.angle.value)),
                          child: SizedBox(
                            width: frameWidth,
                            height: frameHeight,
                            child: FrameThumbnail(
                              key: GlobalKey(),
                              model: model,
                              pageModel: widget.pageModel,
                              frameManager: _frameManager!,
                              applyScale: applyScale,
                              width: frameWidth,
                              height: frameHeight,
                            ),
                          ),
                        ),
                      );
                    }).toList(),

                    //children: getStickerList(),
                  );
                });
          });
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
  //     List<String> eventNameList = CretaUtils.jsonStringToList(model.eventReceive.value);
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
