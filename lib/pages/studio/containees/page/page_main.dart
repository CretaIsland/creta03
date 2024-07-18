// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/containees/page/top_menu_tracer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
//import 'package:glass/glass.dart';
import 'package:hycop/common/util/logger.dart';

//import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
//import '../../../../player/abs_player.dart';
import '../../book_main_page.dart';
import '../../left_menu/left_menu_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';
import '../containee_nofifier.dart';
import '../frame/frame_play_mixin.dart';
import 'page_real_main.dart';

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

class PageMainState extends State<PageMain> with FramePlayMixin {
  //FrameManager? frameManager;  <-- move to FramePlayMixin

  double opacity = 1;
  Color bgColor1 = Colors.transparent;
  Color bgColor2 = Colors.transparent;
  GradationType gradationType = GradationType.none;
  TextureType textureType = TextureType.none;
  PageEventController? _receiveEvent;
  bool _onceDBGetComplete = false;

  void invalidate() {
    setState(() {});
  }

  //BoolEventController? _lineDrawReceiveEvent;
  //FrameEventController? _receiveEventFromProperty;

  Future<void> initChildren() async {
    //saveManagerHolder!.addBookChildren('frame=');
    resetFrameManager(widget.pageModel.mid);
    // frame 을 init 하는 것은, bookMain 에서 하는 것으로 바뀌었다.
    // 여기서 frameManager 는 사실상 null 일수 가 없다. ( 신규로 frame 을 만드는 경우를 빼고)
    if (frameManager == null) {
      //logger.severe('PageMainState _frameManager not found, something wierd');
      setFrameManager(BookMainPage.pageManagerHolder!.newFrameManager(
        widget.bookModel,
        widget.pageModel,
      ));

      await BookMainPage.pageManagerHolder!.initFrameManager(frameManager!, widget.pageModel.mid);
    }
    _onceDBGetComplete = true;
  }

  @override
  void initState() {
    super.initState();
    initChildren();

    final PageEventController receiveEvent = Get.find(tag: 'page-property-to-main');
    _receiveEvent = receiveEvent;
    //final FrameEventController receiveEventFromProperty = Get.find(tag: 'frame-property-to-main unused');
    //_receiveEventFromProperty = receiveEventFromProperty;
    //final BoolEventController lineDrawReceiveEvent = Get.find(tag: 'draw-link');
    //_lineDrawReceiveEvent = lineDrawReceiveEvent;

    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // final RenderBox? box = widget.pageKey.currentContext?.findRenderObject() as RenderBox?;
      // if (box != null) {
      //   logger.fine('box.size=${box.size}');
      //   Offset pageOffset = box.localToGlobal(Offset.zero);
      //   logger.fine('box.position=$pageOffset');
      // }
      if (LinkParams.connectedClass == 'page') {
        LinkParams.connectedMid = '';
        LinkParams.connectedName = '';
      }
    });
  }

  @override
  void dispose() {
    // logger.severe('dispose');
    // frameManager?.removeRealTimeListen();
    // saveManagerHolder?.unregisterManager('frame', postfix: widget.pageModel.mid);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print('-------pageMain build transitionIndicator=${widget.pageModel.transitionEffect.value}');
    return Stack(
      children: [
        _build(context),
        // 커서를 추적하면서,  프레임을 만들거나, 텍스트를 신규하기 위한 위짓.
        TopMenuTracer(
          frameManager: frameManager!,
        ),
      ],
    );
  }

  Widget _build(BuildContext context) {
    return StreamBuilder<AbsExModel>(
        stream: _receiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is PageModel) {
            PageModel model = snapshot.data! as PageModel;
            BookMainPage.pageManagerHolder!.updateModel(model);
          }
          //return CretaManager.waitReorder(manager: frameManager!, child: showFrame());

          //print('pageMain _build');
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
              //color: Colors.blueAccent,
              child: Center(
                child: StudioVariables.isHandToolMode == false
                    ? GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onLongPressDown: _pageClicked,
                        onTapUp: (details) {},
                        onSecondaryTapDown: _showRightMouseMenu,
                        child: _textureBox(), //_animatedPage(),
                      )
                    : _textureBox(), //_animatedPage(),
              ),
            ),
            //),
          );
        });
  }

  void _showRightMouseMenu(TapDownDetails details) {
    if (StudioVariables.isPreview) {
      return;
    }
    logger.fine('right mouse button clicked ${details.globalPosition}');
    logger.fine('right mouse button clicked ${details.localPosition}');
    CretaRightMouseMenu.showMenu(
      title: 'pageRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            disabled:
                StudioVariables.clipBoard != null && StudioVariables.clipBoardDataType == 'frame'
                    ? false
                    : true,
            caption: CretaStudioLang['paste']!,
            onPressed: () {
              if (StudioVariables.clipBoard is FrameModel?) {
                FrameModel? frame = StudioVariables.clipBoard as FrameModel?;
                FrameManager? srcManager = StudioVariables.clipBoardManager as FrameManager?;
                if (frame != null && srcManager != null) {
                  frameManager?.copyFrame(frame,
                      parentMid: widget.pageModel.mid,
                      srcFrameManager: srcManager,
                      samePage: widget.pageModel.mid == frame.parentMid.value);
                }
              }
            }),
      ],
      itemHeight: 24,
      x: details.globalPosition.dx,
      y: details.globalPosition.dy,
      width: 150,
      height: 36,
      //textStyle: CretaFont.bodySmall,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }

  // Widget _animatedPage() {
  //   List<AnimationType> animations =
  //       AnimationType.toAniListFromInt(widget.pageModel.transitionEffect.value);
  //   if (animations.isEmpty || BookMainPage.pageManagerHolder!.isSelectedChanged() == false) {
  //     return _textureBox();
  //   }
  //   return getAnimation(
  //     _textureBox(),
  //     animations,
  //     widget.pageModel.mid,
  //   );
  // }

  Widget _textureBox() {
    bool useColor = textureType != TextureType.glass;

    // GlobalObjectKey currentKey =
    //     BookMainPage.pageManagerHolder!.createPageKey(widget.pageModel.mid);

    Widget current = PageRealMain(
      //pageKey: BookMainPage.pageManagerHolder!.registerPage(widget.pageModel.mid),
      key: ValueKey('PageRealMain${widget.pageModel.mid}'),
      bookModel: widget.bookModel,
      pageModel: widget.pageModel,
      pageWidth: widget.pageWidth,
      pageHeight: widget.pageHeight, // + LayoutConst.miniMenuArea,);
      useColor: useColor,
      bgColor1: bgColor1,
      bgColor2: bgColor2,
      gradationType: gradationType,
      opacity: opacity,
      frameManager: frameManager!,
      onceDBGetComplete: _onceDBGetComplete,
    );

    return current;

    // PageModel? pageModel = BookMainPage.pageManagerHolder?.prevModel;
    // pageModel ??= widget.pageModel;
    // GlobalObjectKey previousKey = BookMainPage.pageManagerHolder!.createPageKey(pageModel.mid);

    // Widget previous = PageRealMain(
    //   pageKey: previousKey,
    //   bookModel: widget.bookModel,
    //   pageModel: pageModel,
    //   pageWidth: StudioVariables.drawableWidth,
    //   pageHeight: StudioVariables.drawableHeight, // + LayoutConst.miniMenuArea,);
    //   useColor: useColor,
    //   bgColor1: pageModel.bgColor1.value,
    //   bgColor2: pageModel.bgColor2.value,
    //   gradationType: pageModel.gradationType.value,
    //   opacity: pageModel.opacity.value,
    //   frameManager: frameManager!,
    //   onceDBGetComplete: _onceDBGetComplete,
    // );

    // return AnimatedSwitcher(
    //   duration: const Duration(seconds: 1),
    //   transitionBuilder: (Widget child, Animation<double> animation) {
    //     const begin = Offset(0.0, 1.0);
    //     const end = Offset.zero;
    //     const curve = Curves.easeInOut;

    //     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    //     return SlideTransition(
    //       position: tween.animate(animation),
    //       child: child,
    //     );
    //   },
    //   child: BookMainPage.pageManagerHolder!.transitForward ? current : previous,
    // );

    // 당분간 page 에서 texture 는 사용하지 않는다.
    // if (textureType == TextureType.glass) {
    //   return _realPageArea(false).asCretaGlass(
    //     width: StudioVariables.virtualWidth,
    //     height: StudioVariables.virtualHeight,
    //     pageWidth: widget.pageWidth,
    //     pageHeight: widget.pageHeight,
    //     gradient: StudioSnippet.gradient(
    //         gradationType, bgColor1.withOpacity(opacity), bgColor2.withOpacity(opacity / 2)),
    //     opacity: opacity,
    //     bgColor1: bgColor1,
    //     bgColor2: bgColor2,
    //   );
    // }
  }

  // Widget _clickPage(bool useColor) {
  //   //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false
  //   return StudioVariables.isHandToolMode == false
  //       ? GestureDetector(
  //           behavior: HitTestBehavior.deferToChild,
  //           onLongPressDown: pageClicked,
  //           onTapUp: (details) {},
  //           child: _realPageArea(useColor),
  //         )
  //       : _realPageArea(useColor);
  // }

//
// 여기사 진짜 Page 부분만을 그리는 부분이다.  !!!!!!!!
// real Page area
  // Widget _realPageArea(bool useColor) {
  //   //return StudioVariables.isHandToolMode == false && StudioVariables.isLinkMode == false

  //   Widget pageWidget = Stack(
  //     children: [
  //       Align(
  //         alignment: Alignment.center,
  //         child: Container(
  //           decoration: useColor ? _pageDeco() : null,
  //           width: widget.pageWidth,
  //           height: widget.pageHeight, // - LayoutConst.miniMenuArea,
  //         ),
  //       ),
  //       SizedBox(
  //         width: StudioVariables.virtualWidth,
  //         height: StudioVariables.virtualHeight,
  //         // width: widget.pageWidth,
  //         // height: widget.pageHeight,
  //         child: _waitFrame(),
  //       ),
  //       //_pageController(),
  //     ],
  //   );

  //   return _pageTransition(pageWidget);
  // }

  // bool _isThisTransType(PageTransitionType type) {
  //   if (StudioVariables.isPreview == false) {
  //     // pageTransition 은 preView mode 에서만 동작한다.
  //     return false;
  //   }
  //   // if (_transitionEffect == type.value) {
  //   //   print('show case  ${widget.pageModel.name.value} : $_transitionEffect');
  //   //   return true;
  //   // }
  //   // 나타날때,
  //   if (_transitionIndicator == true && _transitionEffect == type.value) {
  //     //print('show case  ${widget.pageModel.name.value} : $_transitionEffect');
  //     return true;
  //   }
  //   // 사라질때,
  //   if (_transitionEffect2 == type.value &&
  //       (_transitionIndicator == false || _transitionEffect != _transitionEffect2)) {
  //     return true;
  //   }
  //   return false;
  // }

  // Widget _pageTransition(Widget child) {
  //   if (_isThisTransType(PageTransitionType.fade)) {
  //     return AnimatedOpacity(
  //       curve: Curves.easeInOutQuart,
  //       opacity: _transitionIndicator ? 1.0 : 0.1,
  //       duration: widget.pageModel.getPageDuration(),
  //       child: child,
  //     );
  //   } // fadeIn,fadeOut
  //   if (_isThisTransType(PageTransitionType.scale)) {
  //     //print('scale, $_transitionIndicator');
  //     return AnimatedScale(
  //       curve: Curves.easeInOutQuart,
  //       scale: _transitionIndicator ? 1.0 : 0.1,
  //       duration: widget.pageModel.getPageDuration(),
  //       child: child,
  //     );
  //   } // fadeIn,fa
  //   return child;
  // }

  // ignore: unused_element
  // Widget _pageController() {
  //   return Align(
  //     alignment: Alignment.center,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Center(
  //           // StudioConst.pageControlHeight = 32.0
  //           child: Padding(
  //             padding: const EdgeInsets.only(bottom: 8.0),
  //             child: BTN.fill_gray_i_s(
  //               bgColor: LayoutConst.studioBGColor,
  //               onPressed: () {
  //                 BookMainPage.pageManagerHolder?.gotoPrev();
  //               },
  //               icon: Icons.keyboard_arrow_up_outlined,
  //             ),
  //           ),
  //         ),
  //         IgnorePointer(
  //           child: Container(
  //             color: Colors.transparent,
  //             width: widget.pageWidth,
  //             height: widget.pageHeight, // - LayoutConst.miniMenuArea,
  //           ),
  //         ),
  //         Center(
  //           child: Padding(
  //             padding: const EdgeInsets.only(top: 8.0),
  //             child: BTN.fill_gray_i_s(
  //               bgColor: LayoutConst.studioBGColor,
  //               onPressed: () {
  //                 BookMainPage.pageManagerHolder?.gotoNext();
  //               },
  //               icon: Icons.keyboard_arrow_down_outlined,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _pageClicked(LongPressDownDetails details) async {
    //print('_pageClicked');
    if (frameManager!.clickedInsideSelectedFrame(details.globalPosition) == true) {
      //print('selected frame clicked');
      FrameModel? frameModel = frameManager!.getSelected() as FrameModel?;
      if (frameModel != null && frameModel.isEditMode == true) {
        // BookMainPage.containeeNotifier!.setFrameClick(true);
        // frameManager!.setSelectedMid(frameModel.mid);
        // BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents);
        //CretaManager.frameSelectNotifier?.set(frameModel.mid);
        //print('Its edit mode');
        return;
      }
    }

    logger.fine(
        'Gest3 : onLongPressDown ${details.localPosition}in PageMain ${BookMainPage.containeeNotifier!.isFrameClick}');
    if (BookMainPage.containeeNotifier!.isFrameClick == true) {
      BookMainPage.containeeNotifier!.setFrameClick(false);
      //print('frame clicked ${BookMainPage.containeeNotifier!.isFrameClick}');
      BookMainPage.outSideClick = false;
      BookMainPage.topMenuNotifier?.clear(); // 커서의 모양을 되돌린다.
      return;
    }
    BookMainPage.outSideClick = false;
    //print('page clicked');

    // if (BookMainPage.topMenuNotifier!.isText()) {
    //   // create text box here
    //   //print('createTextBox');
    //   StudioVariables.isHandToolMode = false;
    //   await createTextByClick(context, details);
    //   BookMainPage.topMenuNotifier?.clear(); // 커서의 모양을 되돌린다.
    //   BookMainPage.containeeNotifier!.setFrameClick(true); //  바탕페이지가 눌리는 것을 막기위해
    //   return;
    // } else if (BookMainPage.topMenuNotifier!.isFrame()) {
    //   // create frame box here
    //   //print('createFrame');
    //   Offset center = Offset(
    //     (CretaVars.instance.defaultFrameSize().width / 2) * StudioVariables.applyScale,
    //     (CretaVars.instance.defaultFrameSize().height / 2) * StudioVariables.applyScale,
    //   );
    //   Offset pos = CretaCommonUtils.positionInPage(details.localPosition - center, null);
    //   frameManager!.createNextFrame(pos: pos, size: CretaVars.instance.defaultFrameSize()).then((value) {
    //     frameManager!.notify();
    //     return null;
    //   });

    //   BookMainPage.topMenuNotifier?.clear();
    //   return; // 커서의 모양을 되돌린다.
    // } else {
    //   //setState(() {
    //   //print('clearSelectedMid');
    //   frameManager?.clearSelectedMid();
    // }
    frameManager?.clearSelectedMid();
    BookMainPage.miniMenuNotifier?.set(false, doNoti: true);

    //});
    if (LinkParams.isLinkNewMode == true) {
      LinkParams.isLinkNewMode = false;
      LinkParams.connectedClass = '';
      LinkParams.connectedMid = '';
      LinkParams.connectedName = '';
      logger.fine('BookMainPage.bookManagerHolder!.notify()');
      BookMainPage.bookManagerHolder!.notify();
    } else {
      //print('BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);');
      BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
      LeftMenuPage.treeInvalidate();
    }
  }

  // BoxDecoration _pageDeco() {
  //   Color c1 = opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity);
  //   Color c2 = opacity == 1 ? bgColor2 : bgColor2.withOpacity(opacity);

  //   return BoxDecoration(
  //     color: c1,
  //     boxShadow: StudioSnippet.basicShadow(),
  //     gradient: (bgColor1 != Colors.transparent && bgColor2 != Colors.transparent)
  //         ? StudioSnippet.gradient(gradationType, c1, c2)
  //         : null,
  //   );
  // }

  // Widget _waitFrame() {
  //   if (_onceDBGetComplete && frameManager!.initFrameComplete) {
  //     logger.fine('already _onceDBGetComplete page main');
  //     return _consumerFunc();
  //   }
  //   //var retval = CretaManager.waitData(
  //   var retval = CretaManager.waitDatum(
  //     managerList: [
  //       frameManager!,
  //     ],
  //     //userId: AccountManager.currentLoginUser.email,
  //     consumerFunc: _consumerFunc,
  //   );

  //   //_onceDBGetComplete = true;
  //   logger.finest('first_onceDBGetComplete page');
  //   return retval;
  //   //return consumerFunc();
  // }

  // Widget _consumerFunc() {
  //   //progressHolder = ProgressNotifier();

  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider<FrameManager>.value(
  //         value: frameManager!,
  //       ),
  //       // ChangeNotifierProvider<SelectedModel>(
  //       //   create: (context) {
  //       //     selectedModelHolder = SelectedModel();
  //       //     return selectedModelHolder!;
  //       //   },
  //       // ),
  //     ],
  //     child: _pageEffect(),
  //   );
  // }

  // Widget _pageEffect() {
  //   if (widget.pageModel.effect.value != EffectType.none) {
  //     return Stack(alignment: Alignment.center, children: [
  //       effectWidget(widget.pageModel),
  //       _drawFrames(),
  //       //_pageController(),
  //     ]);
  //   }
  //   return _drawFrames();
  // }

  // Widget _drawFrames() {
  //   return Consumer<FrameManager>(builder: (context, manager, child) {
  //     //print('_drawFrames'); // if (StudioVariables.isPreview) {
  //     //   return Stack(
  //     //     children: [
  //     //       FrameMain(
  //     //         frameMainKey: GlobalKey(),
  //     //         pageWidth: widget.pageWidth,
  //     //         pageHeight: widget.pageHeight,
  //     //         pageModel: widget.pageModel,
  //     //         bookModel: widget.bookModel,
  //     //       ),
  //     //       _drawLinks(manager),
  //     //     ],
  //     //   );
  //     // }
  //     return FrameMain(
  //       frameMainKey: GlobalObjectKey('FrameMain${widget.pageModel.mid}'),
  //       pageWidth: widget.pageWidth,
  //       pageHeight: widget.pageHeight,
  //       pageModel: widget.pageModel,
  //       bookModel: widget.bookModel,
  //     );
  //   });
  // }

  // // ignore: unused_element
  // Widget _drawLinks(FrameManager manager) {
  //   // return StreamBuilder<AbsExModel>(
  //   //     stream: _receiveEventFromProperty!.eventStream.stream,
  //   //     builder: (context, snapshot) {
  //   //       if (snapshot.data != null) {
  //   //         if (snapshot.data! is FrameModel) {
  //   //           FrameModel model = snapshot.data! as FrameModel;
  //   //           manager.updateModel(model);
  //   //           logger.fine('_drawLinks _receiveEventFromProperty-----${model.posY.value}');
  //   //         } else {
  //   //           logger.fine('_receiveEventFromProperty-----Unknown Model');
  //   //         }
  //   //       }
  //   //       return Stack(
  //   //         children: [
  //   //           ..._drawLines(manager),
  //   //         ],
  //   //       );
  //   //     });
  //   return Stack(
  //     children: [
  //       ..._drawLines(manager),
  //     ],
  //   );
  // }

  // List<Widget> _drawLines(FrameManager manager) {
  //   logger.fine('_drawLines()--------------------------------------------');
  //   List<LinkModel> linkList = [];
  //   manager.listIterator((frameModel) {
  //     ContentsManager contentsManager = manager.findOrCreateContentsManager(frameModel as FrameModel);
  //     // if (contentsManager == null) {
  //     //   return null;
  //     // }
  //     ContentsModel? contentsModel = contentsManager.getCurrentModel();
  //     if (contentsModel == null) {
  //       return null;
  //     }
  //     LinkManager? linkManager = contentsManager.findLinkManager(contentsModel.mid);
  //     if (linkManager == null) {
  //       return SizedBox.shrink();
  //     }
  //     if (linkManager.length() == 0) {
  //       return SizedBox.shrink();
  //     }
  //     logger.fine(
  //         '_drawLines()-${linkManager.length()}-----${contentsModel.name}--------------------------------------');

  //     linkList = [
  //       ...linkList,
  //       ...linkManager.orderMapIterator((ele) {
  //         LinkModel model = ele as LinkModel;
  //         model.stickerKey = manager.findStickerKey(widget.pageModel.mid, model.connectedMid);
  //         return model;
  //       }).toList()
  //     ];

  //     return null;
  //   });
  //   return linkList.map((model) => _drawEachLine(model)).toList();
  // }

  // Widget _drawEachLine(LinkModel model) {
  //   if (model.connectedClass == 'page') {
  //     return const SizedBox.shrink();
  //   }
  //   if (model.showLinkLine == false) {
  //     return const SizedBox.shrink();
  //   }
  //   logger.fine('_drawEachLine()--------------------------------------------');

  //   final GlobalKey? stickerKey = model.stickerKey;
  //   final GlobalObjectKey? iconKey = model.iconKey;
  //   if (stickerKey == null || iconKey == null) {
  //     return const SizedBox.shrink();
  //   }

  //   final RenderBox? frame = stickerKey.currentContext?.findRenderObject() as RenderBox?;
  //   final RenderBox? icon = iconKey.currentContext?.findRenderObject() as RenderBox?;
  //   if (frame == null || icon == null) {
  //     return const SizedBox.shrink();
  //   }

  //   Offset frameOffset = frame.localToGlobal(Offset.zero);
  //   frameOffset = frameOffset;
  //   final Size frameSize = frame.size;

  //   final Offset frameTop = Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy);
  //   final Offset frameBottom =
  //       Offset(frameSize.width / 2 + frameOffset.dx, frameOffset.dy + frameSize.height);
  //   final Offset frameLeft = Offset(frameOffset.dx, frameSize.height / 2 + frameOffset.dy);
  //   final Offset frameRight =
  //       Offset(frameOffset.dx + frameSize.width, frameSize.height / 2 + frameOffset.dy);

  //   Offset iconOffset = icon.localToGlobal(Offset.zero);
  //   iconOffset = iconOffset;
  //   final Size iconSize = icon.size;
  //   // icon center;
  //   final double iconX = iconOffset.dx + iconSize.width / 2; // center
  //   final double iconY = iconOffset.dy + iconSize.height / 2;

  //   final num dist1 = pow((frameTop.dx - iconX), 2) + pow((frameTop.dy - iconY), 2);
  //   final num dist2 = pow((frameBottom.dx - iconX), 2) + pow((frameBottom.dy - iconY), 2);
  //   final num dist3 = pow((frameLeft.dx - iconX), 2) + pow((frameLeft.dy - iconY), 2);
  //   final num dist4 = pow((frameRight.dx - iconX), 2) + pow((frameRight.dy - iconY), 2);

  //   final num smallestDist = min(min(dist1, dist2), min(dist3, dist4));

  //   Offset finalFrameOffset = Offset.zero;
  //   if (dist1 == smallestDist) {
  //     finalFrameOffset = frameTop;
  //   } else if (dist2 == smallestDist) {
  //     finalFrameOffset = frameBottom;
  //   } else if (dist3 == smallestDist) {
  //     finalFrameOffset = frameLeft;
  //   } else if (dist4 == smallestDist) {
  //     finalFrameOffset = frameRight;
  //   }

  //   if (finalFrameOffset == Offset.zero) {
  //     return const SizedBox.shrink();
  //   }

  //   logger
  //       .info('Line ------ (${finalFrameOffset.dx},${finalFrameOffset.dy}) <--- ($iconX,$iconY) ');

  //   return CustomPaint(
  //     painter: PolygonConnectionPainter(
  //       startPoint: Offset(iconX, iconY),
  //       endPoint: finalFrameOffset,
  //     ),
  //   );
  // }
}
