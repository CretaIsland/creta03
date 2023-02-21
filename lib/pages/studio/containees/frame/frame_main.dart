// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';

import '../../../../data_io/frame_manager.dart';
//import '../../../../data_io/page_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/book_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_snippet.dart';
import '../../studio_variables.dart';
import '../containee_mixin.dart';

class FramMain extends StatefulWidget {
  final BookModel bookModel;
  final PageModel pageModel;
  final double frameWidth;
  final double frameHeight;

  const FramMain({
    super.key,
    required this.bookModel,
    required this.pageModel,
    required this.frameWidth,
    required this.frameHeight,
  });

  @override
  State<FramMain> createState() => _FramMainState();
}

class _FramMainState extends State<FramMain> with ContaineeMixin {
  FrameModel? _frameModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FrameManager>(builder: (context, frameManager, child) {
      _frameModel = frameManager.getSelected() as FrameModel;
      logger.finest('FramMain Invoked');
      return Container(
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        color: LayoutConst.studioBGColor,
        //color: Colors.amber,
        child: Center(
          child: GestureDetector(
            onLongPressDown: (details) {
              logger.finest('frame clicked');
              setState(() {
                BookMainPage.selectedClass = RightMenuEnum.Frame;
              });
              BookMainPage.bookManagerHolder!.notify();
            },
            child: _applyAnimate(),
          ),
        ),
      );
    });
  }

  Widget _frameBox() {
    return Container(
      decoration: _frameDeco(),
      width: widget.frameWidth,
      height: widget.frameHeight,
    );
  }

  Widget _applyAnimate() {
    List<AnimationType> animations =
        AnimationType.toAniListFromInt(_frameModel!.transitionEffect.value);

    if (animations.isEmpty || BookMainPage.frameManagerHolder!.isSelectedChanged() == false) {
      return _frameBox();
    }
    return getAnimation(_frameBox(), animations);
  }

  BoxDecoration _frameDeco() {
    double opacity = _frameModel!.opacity.value;
    Color bgColor1 = _frameModel!.bgColor1.value;
    Color bgColor2 = _frameModel!.bgColor2.value;
    GradationType gradationType = _frameModel!.gradationType.value;

    return BoxDecoration(
      color: opacity == 1 ? bgColor1 : bgColor1.withOpacity(opacity),
      boxShadow: StudioSnippet.basicShadow(),
      gradient: StudioSnippet.gradient(gradationType, bgColor1, bgColor2),
    );
  }
}
