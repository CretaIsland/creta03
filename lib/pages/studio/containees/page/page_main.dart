// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
//import 'package:glass/glass.dart';
import 'package:provider/provider.dart';
import 'package:hycop/common/undo/save_manager.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/component/creta_texture_widget.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/creta_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';
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
      logger.severe('GrassType!!!');
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
      onLongPressDown: (details) {
        //logger.fine('page clicked , ${details.localPosition}, ${details.globalPosition}');

        // String? selectedMid = CretaUtils.isPointInsideWidgetList(
        //     _frameManager!.frameKeyMap, details.globalPosition, floatingActionDiameter);

        // if (selectedMid != null) {
        //   FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
        //   frameManager?.setSelectedMid(selectedMid);
        //   BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
        //   return;
        // }

        // logger.fine('page clicked');
        // BookMainPage.containeeNotifier!.set(ContaineeEnum.Page);
      },
      child: Container(
        decoration: useColor ? _pageDeco() : null,
        width: widget.pageWidth,
        height: widget.pageHeight,
        child: _waitFrame(),
      ),
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
      child: _drawFrames(),
    );
  }

  Widget _drawFrames() {
    return
        // SizedBox(
        //   width: widget.pageWidth,
        //   height: widget.pageHeight,
        //   child:
        FrameMain(
      key: GlobalKey(),
      pageWidth: widget.pageWidth,
      pageHeight: widget.pageHeight,
      pageModel: widget.pageModel,
      bookModel: widget.bookModel,
      //     ),
    );
  }
}
