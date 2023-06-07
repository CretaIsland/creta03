// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/creta_model.dart';
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

  @override
  void initState() {
    initChildren();
    super.initState();
    final PageEventController receiveEvent = Get.find(tag: 'page-property-to-main');
    _receiveEvent = receiveEvent;
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
      await BookMainPage.pageManagerHolder!.initFrameManager(_frameManager!);
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
    return getAnimation(_textureBox(), animations);
  }

  Widget _textureBox() {
    if (textureType == TextureType.glass) {
      logger.finest('GrassType!!!');
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
    //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false
    return StudioVariables.isHandToolMode == false
        ? GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onLongPressDown: pageClicked,
            onTapUp: (details) {
              //logger
              //    .info('onTapUp======================================${details.localPosition.dx}');
            },
            child: Container(
              decoration: useColor ? _pageDeco() : null,
              width: widget.pageWidth,
              height: widget.pageHeight,
              child: _waitFrame(),
            ),
          )
        : Container(
            decoration: useColor ? _pageDeco() : null,
            width: widget.pageWidth,
            height: widget.pageHeight,
            child: _waitFrame(),
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
    if (StudioVariables.isLinkNewMode == true) {
      StudioVariables.isLinkNewMode = false;
      StudioVariables.conenctedClass = '';
      StudioVariables.conenctedMid = '';
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
      logger.info('already _onceDBGetComplete');
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
      //logger.info('_drawFrame()');
      return FrameMain(
        frameMainKey: GlobalKey(),
        pageWidth: widget.pageWidth,
        pageHeight: widget.pageHeight,
        pageModel: widget.pageModel,
        bookModel: widget.bookModel,
      );
    });
  }
}
