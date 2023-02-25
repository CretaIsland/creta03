// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:glass/glass.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
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
    _frameManager?.removeRealTimeListen();
    saveManagerHolder?.unregisterManager('frame', postfix: widget.pageModel.mid);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: StudioVariables.virtualWidth,
      height: StudioVariables.virtualHeight,
      color: LayoutConst.studioBGColor,
      //color: Colors.amber,
      child: Center(
        child: GestureDetector(
          onLongPressDown: (details) {
            logger.finest('page clicked');
            BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
            //BookMainPage.bookManagerHolder!.notify();
          },
          child: _waitFrame(),
        ),
      ),
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
      child: _applyAnimate(),
    );
  }

  Widget _applyAnimate() {
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(widget.pageModel.transitionEffect.value);
    if (animations.isEmpty || BookMainPage.pageManagerHolder!.isSelectedChanged() == false) {
      return _textureBox();
    }
    return getAnimation(_textureBox(), animations);
  }

  TextureType _getTextureType() {
    if (widget.pageModel.bgColor1.value == Colors.transparent) {
      if (widget.pageModel.textureType.value == TextureType.none) {
        return widget.bookModel.textureType.value;
      }
    }
    return widget.pageModel.textureType.value;
  }

  Widget _textureBox() {
    if (_getTextureType() == TextureType.glass) {
      return _pageBox(useColor: false).asGlass();
    }
    return _pageBox();
  }

  Widget _pageBox({bool useColor = true}) {
    return Container(
      decoration: _pageDeco(useColor: useColor),
      width: widget.pageWidth,
      height: widget.pageHeight,
      child: FrameMain(
        key: GlobalKey(),
        pageWidth: widget.pageWidth,
        pageHeight: widget.pageHeight,
        pageModel: widget.pageModel,
        bookModel: widget.bookModel,
      ),
    );
  }

  BoxDecoration _pageDeco({bool useColor = true}) {
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
      color: useColor == true
          ? opacity == 1
              ? bgColor1
              : bgColor1.withOpacity(opacity)
          : null,
      boxShadow: StudioSnippet.basicShadow(),
      gradient: useColor == true ? StudioSnippet.gradient(gradationType, bgColor1, bgColor2) : null,
    );
  }
}
