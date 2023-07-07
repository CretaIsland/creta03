// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/link_manager.dart';
import '../../../../design_system/component/polygon_connection_painter.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/link_model.dart';
import '../../../../model/page_model.dart';
//import '../../../../player/abs_player.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
import '../containee_nofifier.dart';
import '../frame/frame_main.dart';

class PageMain extends StatefulWidget {
  final GlobalObjectKey pageKey;
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;

  const PageMain({
    required this.pageKey,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
  }) : super(key: pageKey);

  @override
  State<PageMain> createState() => PageMainState();
}

class PageMainState extends State<PageMain> with ContaineeMixin {
  FrameManager? _frameManager;

  bool _onceDBGetComplete = false;

  double opacity = 1;
  Color bgColor1 = Colors.transparent;
  Color bgColor2 = Colors.transparent;
  GradationType gradationType = GradationType.none;
  TextureType textureType = TextureType.none;
  PageEventController? _receiveEvent;
  //BoolEventController? _lineDrawReceiveEvent;
  //FrameEventController? _receiveEventFromProperty;

  @override
  void initState() {
    initChildren();
    super.initState();
    final PageEventController receiveEvent = Get.find(tag: 'page-property-to-main');
    _receiveEvent = receiveEvent;
    //final FrameEventController receiveEventFromProperty = Get.find(tag: 'frame-property-to-main');
    //_receiveEventFromProperty = receiveEventFromProperty;
    //final BoolEventController lineDrawReceiveEvent = Get.find(tag: 'draw-link');
    //_lineDrawReceiveEvent = lineDrawReceiveEvent;
    afterBuild();
  }

  Future<void> initChildren() async {
    //saveManagerHolder!.addBookChildren('frame=');
    _frameManager = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    // frame 을 init 하는 것은, bookMain 에서 하는 것으로 바뀌었다.
    // 여기서 frameManager 는 사실상 null 일수 가 없다. ( 신규로 frame 을 만드는 경우를 빼고)
    if (_frameManager == null) {
      _frameManager = BookMainPage.pageManagerHolder!.newFrameManager(
        widget.bookModel,
        widget.pageModel,
      );
      await BookMainPage.pageManagerHolder!.initFrameManager(_frameManager!, widget.pageModel.mid);
    }
    _onceDBGetComplete = true;
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final RenderBox? box = widget.pageKey.currentContext?.findRenderObject() as RenderBox?;
      // if (box != null) {
      //   logger.info('box.size=${box.size}');
      //   Offset pageOffset = box.localToGlobal(Offset.zero);
      //   logger.info('box.position=$pageOffset');
      // }
      if (LinkParams.connectedClass == 'page') {
        LinkParams.connectedMid = '';
      }
    });
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
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is PageModel) {
            PageModel model = snapshot.data! as PageModel;
            BookMainPage.pageManagerHolder!.updateModel(model);
          }
          //return CretaManager.waitReorder(manager: frameManager!, child: showFrame());
          return _build(context);
        });
  }

  Widget _build(BuildContext context) {
    // if (widget.pageModel.bgColor1.value != Colors.transparent) {
    opacity = widget.pageModel.opacity.value;
    bgColor1 = widget.pageModel.bgColor1.value;
    bgColor2 = widget.pageModel.bgColor2.value;
    gradationType = widget.pageModel.gradationType.value;
    // } else {
    //   opacity = widget.bookModel.opacity.value;
    //   bgColor1 = widget.bookModel.bgColor1.value;
    //   bgColor2 = widget.bookModel.bgColor2.value;
    //   gradationType = widget.bookModel.gradationType.value;
    // }

    //if (widget.pageModel.textureType.value != TextureType.none) {
    textureType = widget.pageModel.textureType.value;
    //} else {
    //  textureType = widget.bookModel.textureType.value;
    //}

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
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.amber,
        child: Center(child: _animatedPage()),
      ),
      //),
    );
  }

  Widget _animatedPage() {
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(widget.pageModel.transitionEffect.value);
    if (animations.isEmpty || BookMainPage.pageManagerHolder!.isSelectedChanged() == false) {
      return _textureBox();
    }
    return getAnimation(
      _textureBox(),
      animations,
      widget.pageModel.mid,
    );
  }

  Widget _textureBox() {
    if (textureType == TextureType.glass) {
      logger.finest('GrassType!!!');
      return _clickPage(true).asCretaGlass(
        width: widget.pageWidth,
        height: widget.pageHeight,
        gradient: StudioSnippet.gradient(
            gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
        opacity: opacity,
        bgColor1: bgColor1,
        bgColor2: bgColor2,
      );
    }
    return _clickPage(true);
  }

  Widget _clickPage(bool useColor) {
    //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false
    return StudioVariables.isHandToolMode == false
        ? GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPressDown: pageClicked,
            onTapUp: (details) {
              //logger
              //    .info('onTapUp======================================${details.localPosition.dx}');
            },
            child: _drawPage(useColor),
          )
        : _drawPage(useColor);
  }

  Widget _drawPage(bool useColor) {
    //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false
    return Stack(
      children: [
        Container(
          decoration: useColor ? _pageDeco() : null,
          width: widget.pageWidth,
          height: widget.pageHeight - LayoutConst.miniMenuArea,
        ),
        SizedBox(
          width: widget.pageWidth,
          height: widget.pageHeight,
          child: _waitFrame(),
        ),
      ],
    );
  }

  void pageClicked(LongPressDownDetails details) {
    logger.info(
        'Gest3 : onLongPressDown in PageMain ${BookMainPage.containeeNotifier!.isFrameClick}');
    if (BookMainPage.containeeNotifier!.isFrameClick == true) {
      BookMainPage.containeeNotifier!.setFrameClick(false);
      logger.info('frame clicked ${BookMainPage.containeeNotifier!.isFrameClick}');
      return;
    }
    logger.info('page clicked');
    //setState(() {
    _frameManager?.clearSelectedMid();
    //});
    if (LinkParams.isLinkNewMode == true) {
      LinkParams.isLinkNewMode = false;
      LinkParams.connectedClass = '';
      LinkParams.connectedMid = '';
      BookMainPage.bookManagerHolder!.notify();
    } else {
      BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
    }
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
      logger.info('already _onceDBGetComplete page main');
      return _consumerFunc();
    }
    //var retval = CretaModelSnippet.waitData(
    var retval = CretaModelSnippet.waitDatum(
      managerList: [
        _frameManager!,
      ],
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
      // if (StudioVariables.isPreview) {
      //   return Stack(
      //     children: [
      //       FrameMain(
      //         frameMainKey: GlobalKey(),
      //         pageWidth: widget.pageWidth,
      //         pageHeight: widget.pageHeight,
      //         pageModel: widget.pageModel,
      //         bookModel: widget.bookModel,
      //       ),
      //       _drawLinks(frameManager),
      //     ],
      //   );
      // }
      return FrameMain(
        frameMainKey: GlobalKey(),
        pageWidth: widget.pageWidth,
        pageHeight: widget.pageHeight,
        pageModel: widget.pageModel,
        bookModel: widget.bookModel,
      );
    });
  }

  // ignore: unused_element
  Widget _drawLinks(FrameManager frameManager) {
    // return StreamBuilder<AbsExModel>(
    //     stream: _receiveEventFromProperty!.eventStream.stream,
    //     builder: (context, snapshot) {
    //       if (snapshot.data != null) {
    //         if (snapshot.data! is FrameModel) {
    //           FrameModel model = snapshot.data! as FrameModel;
    //           frameManager.updateModel(model);
    //           logger.info('_drawLinks _receiveEventFromProperty-----${model.posY.value}');
    //         } else {
    //           logger.info('_receiveEventFromProperty-----Unknown Model');
    //         }
    //       }
    //       return Stack(
    //         children: [
    //           ..._drawLines(frameManager),
    //         ],
    //       );
    //     });
    return Stack(
      children: [
        ..._drawLines(frameManager),
      ],
    );
  }

  List<Widget> _drawLines(FrameManager frameManager) {
    logger.info('_drawLines()--------------------------------------------');
    List<LinkModel> linkList = [];
    frameManager.listIterator((frameModel) {
      ContentsManager? contentsManager = frameManager.findContentsManager(frameModel.mid);
      if (contentsManager == null) {
        return null;
      }
      ContentsModel? contentsModel = contentsManager.getCurrentModel();
      if (contentsModel == null) {
        return null;
      }
      LinkManager? linkManager = contentsManager.findLinkManager(contentsModel.mid);
      if (linkManager == null) {
        return SizedBox.shrink();
      }
      if (linkManager.length() == 0) {
        return SizedBox.shrink();
      }
      logger.info(
          '_drawLines()-${linkManager.length()}-----${contentsModel.name}--------------------------------------');

      linkList = [
        ...linkList,
        ...linkManager.orderMapIterator((ele) {
          LinkModel model = ele as LinkModel;
          model.stickerKey = frameManager.frameKeyMap[model.connectedMid];
          return model;
        }).toList()
      ];

      return null;
    });
    return linkList.map((model) => _drawEachLine(model, frameManager.pageOffset)).toList();
  }

  Widget _drawEachLine(LinkModel model, Offset pageOffset) {
    if (model.connectedClass == 'page') {
      return const SizedBox.shrink();
    }
    if (model.showLinkLine == false) {
      return const SizedBox.shrink();
    }
    logger.info('_drawEachLine()--------------------------------------------');

    final GlobalKey? stickerKey = model.stickerKey;
    final GlobalObjectKey? iconKey = model.iconKey;
    if (stickerKey == null || iconKey == null) {
      return const SizedBox.shrink();
    }

    final RenderBox? frame = stickerKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? icon = iconKey.currentContext?.findRenderObject() as RenderBox?;
    if (frame == null || icon == null) {
      return const SizedBox.shrink();
    }

    Offset frameOffset = frame.localToGlobal(Offset.zero);
    frameOffset = frameOffset - pageOffset;
    final Size frameSize = frame.size;

    final Offset frameTop = Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy);
    final Offset frameBottom =
        Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy + frameSize.height);
    final Offset frameLeft = Offset(frameOffset.dx, frameSize.height / 2 + frameOffset.dy);
    final Offset frameRight =
        Offset(frameOffset.dx + frameSize.width, frameSize.height / 2 + frameOffset.dy);

    Offset iconOffset = icon.localToGlobal(Offset.zero);
    iconOffset = iconOffset - pageOffset;
    final Size iconSize = icon.size;
    // icon center;
    final double iconX = iconOffset.dx + iconSize.width / 2; // center
    final double iconY = iconOffset.dy + iconSize.height / 2;

    final num dist1 = pow((frameTop.dx - iconX), 2) + pow((frameTop.dy - iconY), 2);
    final num dist2 = pow((frameBottom.dx - iconX), 2) + pow((frameBottom.dy - iconY), 2);
    final num dist3 = pow((frameLeft.dx - iconX), 2) + pow((frameLeft.dy - iconY), 2);
    final num dist4 = pow((frameRight.dx - iconX), 2) + pow((frameRight.dy - iconY), 2);

    final num smallestDist = min(min(dist1, dist2), min(dist3, dist4));

    Offset finalFrameOffset = Offset.zero;
    if (dist1 == smallestDist) {
      finalFrameOffset = frameTop;
    } else if (dist2 == smallestDist) {
      finalFrameOffset = frameBottom;
    } else if (dist3 == smallestDist) {
      finalFrameOffset = frameLeft;
    } else if (dist4 == smallestDist) {
      finalFrameOffset = frameRight;
    }

    if (finalFrameOffset == Offset.zero) {
      return const SizedBox.shrink();
    }

    logger
        .info('Line ------ (${finalFrameOffset.dx},${finalFrameOffset.dy}) <--- ($iconX,$iconY) ');

    return CustomPaint(
      painter: PolygonConnectionPainter(
        startPoint: Offset(iconX, iconY),
        endPoint: finalFrameOffset,
      ),
    );
  }
}
