// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';

import '../../../../data_io/page_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';

class PageMain extends StatefulWidget {
  final BookModel bookModel;
  final double pageWidth;
  final double pageHeight;

  const PageMain({
    super.key,
    required this.bookModel,
    required this.pageWidth,
    required this.pageHeight,
  });

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> with ContaineeMixin {
  PageModel? _pageModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PageManager>(builder: (context, pageManager, child) {
      _pageModel = pageManager.getSelected() as PageModel?;
      logger.finest('PageMain Invoked');
      return Container(
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.amber,
        child: Center(
          child: GestureDetector(
            onLongPressDown: (details) {
              logger.finest('page clicked');
              setState(() {
                BookMainPage.selectedClass = RightMenuEnum.Page;
              });
              BookMainPage.bookManagerHolder!.notify();
            },
            child: _applyAnimate(),
          ),
        ),
      );
    });
  }

  Widget _pageBox() {
    return Container(
      decoration: _pageDeco(),
      width: widget.pageWidth,
      height: widget.pageHeight,
    );
  }

  Widget _applyAnimate() {
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(_pageModel!.transitionEffect.value);

    if (animations.isEmpty || BookMainPage.pageManagerHolder!.isSelectedChanged() == false) {
      return _pageBox();
    }

    return getAnimation(_pageBox(), animations);
  }

  BoxDecoration _pageDeco() {
    double opacity = widget.bookModel.opacity.value;
    Color bgColor1 = widget.bookModel.bgColor1.value;
    Color bgColor2 = widget.bookModel.bgColor2.value;
    GradationType gradationType = widget.bookModel.gradationType.value;

    if (_pageModel != null && _pageModel!.bgColor1.value != Colors.transparent) {
      opacity = _pageModel!.opacity.value;
      bgColor1 = _pageModel!.bgColor1.value;
      bgColor2 = _pageModel!.bgColor2.value;
      gradationType = _pageModel!.gradationType.value;
    }

    return BoxDecoration(
      color: opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity),
      boxShadow: StudioSnippet.basicShadow(),
      gradient: StudioSnippet.gradient(gradationType, bgColor1, bgColor2),
    );
  }
}
