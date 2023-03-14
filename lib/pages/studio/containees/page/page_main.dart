// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:floating_bubbles/floating_bubbles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:parallax_rain/parallax_rain.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:snowfall/snowfall/snowfall_widget.dart';
import 'package:starsview/config/MeteoriteConfig.dart';
import 'package:starsview/config/StarsConfig.dart';
import 'package:starsview/starsview.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/effect/confetti.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
import '../containee_nofifier.dart';
import '../frame/frame_main.dart';

class PageMain extends StatefulWidget {
  final BookModel bookModel;
  final PageModel pageModel;
  final double pageWidth;
  final double pageHeight;

  const PageMain({
    super.key,
    required this.bookModel,
    required this.pageModel,
    required this.pageWidth,
    required this.pageHeight,
  });

  @override
  State<PageMain> createState() => PageMainState();
}

class PageMainState extends State<PageMain> with ContaineeMixin {
  FrameManager? _frameManager;
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    initChildren(widget.bookModel);
    super.initState();
  }

  Future<void> initChildren(BookModel model) async {
    saveManagerHolder!.addBookChildren('frame=');

    _frameManager = BookMainPage.pageManagerHolder!.findFrameManager(widget.pageModel.mid);
    if (_frameManager == null) {
      _frameManager = BookMainPage.pageManagerHolder!.newFrame(
        widget.bookModel,
        widget.pageModel,
      );
      await BookMainPage.pageManagerHolder!.initFrame(_frameManager!);
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
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        //color: LayoutConst.studioBGColor,
        color: Colors.amber,
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
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPressDown: pageClicked,
      child: Container(
        decoration: useColor ? _pageDeco() : null,
        width: widget.pageWidth,
        height: widget.pageHeight,
        child: _waitFrame(),
      ),
    );
  }

  void pageClicked(LongPressDownDetails details) {
    logger.finest(
        'Gest3 : onLongPressDown in PageMain ${BookMainPage.containeeNotifier!.isFrameClick}');
    if (BookMainPage.containeeNotifier!.isFrameClick == true) {
      BookMainPage.containeeNotifier!.setFrameClick(false);
      logger.finest('frame clicked ${BookMainPage.containeeNotifier!.isFrameClick}');
      return;
    }
    logger.finest('page clicked');
    setState(() {
      _frameManager?.clearSelectedMid();
    });
    BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
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
    if (_onceDBGetComplete) {
      logger.finest('already _onceDBGetComplete');
      return _consumerFunc();
    }
    //var retval = CretaModelSnippet.waitData(
    var retval = CretaModelSnippet.waitDatum(
      managerList: [_frameManager!],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _consumerFunc,
    );

    //_onceDBGetComplete = true;
    logger.finest('first_onceDBGetComplete');
    return retval;
    //return consumerFunc();
  }

  Widget _consumerFunc() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FrameManager>.value(
          value: _frameManager!,
        ),
      ],
      child: _pageEffect(),
    );
  }

  Widget _pageEffect() {
    if (widget.pageModel.effect.value != EffectType.none) {
      return Stack(
        alignment: Alignment.center,
        children: [
          _effectWidget(),
          _drawFrames(),
        ],
      );
    }
    return _drawFrames();
  }

  Widget _effectWidget() {
    switch (widget.pageModel.effect.value) {
      case EffectType.conffeti:
        return ConfettiEffect();
      case EffectType.snow:
        return SnowfallWidget(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        );
      case EffectType.rain:
        return ParallaxRain(
          dropColors: const [
            Colors.red,
            Colors.green,
            Colors.blue,
            Colors.yellow,
            Colors.brown,
            Colors.blueGrey
          ],
          dropHeight: 10,
          dropFallSpeed: 3,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
          ),
        );

      case EffectType.bubble:
        return Positioned.fill(
          child: FloatingBubbles.alwaysRepeating(
            noOfBubbles: 50,
            colorsOfBubbles: const [
              Colors.white,
              Colors.red,
            ],
            sizeFactor: 0.2,
            opacity: 70,
            speed: BubbleSpeed.slow,
            paintingStyle: PaintingStyle.fill,
            shape: BubbleShape.circle, //This is the default
          ),
          // FloatingBubbles(
          //   noOfBubbles: 25,
          //   colorsOfBubbles: [
          //     Colors.green.withAlpha(30),
          //     Colors.red,
          //   ],
          //   sizeFactor: 0.16,
          //   duration: 120, // 120 seconds.
          //   opacity: 70,
          //   paintingStyle: PaintingStyle.stroke,
          //   strokeWidth: 8,
          //   shape: BubbleShape
          //       .circle, // circle is the default. No need to explicitly mention if its a circle.
          //   speed: BubbleSpeed.normal, // normal is the default
          // ),
        );
      case EffectType.star:
        return Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[
                    Colors.red,
                    Colors.blue,
                  ],
                ),
              ),
            ),
            StarsView(
              fps: 60,
              starsConfig: StarsConfig(
                maxStarSize: 6,
                colors: [
                  Colors.white,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.lightBlue,
                  Colors.lightGreen
                ],
              ),
              meteoriteConfig: MeteoriteConfig(
                maxMeteoriteSize: 10,
                colors: [
                  Colors.white,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.lightBlue,
                  Colors.lightGreen
                ],
              ),
            ),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _drawFrames() {
    return Consumer<FrameManager>(builder: (context, frameManager, child) {
      return FrameMain(
        key: GlobalKey(),
        pageWidth: widget.pageWidth,
        pageHeight: widget.pageHeight,
        pageModel: widget.pageModel,
        bookModel: widget.bookModel,
      );
    });
  }
}
