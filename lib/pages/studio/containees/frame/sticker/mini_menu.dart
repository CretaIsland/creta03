import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../lang/creta_studio_lang.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';

class MiniMenu extends StatefulWidget {
  final Offset parentPosition;
  final Size parentSize;
  final double parentBorderWidth;
  final double pageHeight;
  final void Function() onFrameDelete;
  final void Function() onFrameFront;
  final void Function() onFrameBack;
  final void Function() onFrameCopy;
  final void Function() onFrameRotate;
  final void Function() onFrameMain;

  const MiniMenu({
    super.key,
    required this.parentPosition,
    required this.parentSize,
    required this.parentBorderWidth,
    required this.pageHeight,
    required this.onFrameDelete,
    required this.onFrameFront,
    required this.onFrameBack,
    required this.onFrameCopy,
    required this.onFrameRotate,
    required this.onFrameMain,
  });

  @override
  State<MiniMenu> createState() => _MiniMenuState();
}

class _MiniMenuState extends State<MiniMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('MiniMenu build');

    double centerX =
        widget.parentPosition.dx + (widget.parentSize.width + LayoutConst.stikerOffset) / 2;
    double left = centerX - LayoutConst.miniMenuWidth / 2;
    double top = widget.parentPosition.dy +
        widget.parentSize.height +
        LayoutConst.miniMenuGap +
        LayoutConst.stikerOffset / 2;

    if (top + LayoutConst.miniMenuHeight > widget.pageHeight) {
      // 화면의 영역을 벗어나면 어쩔 것인가...
      // 겨...올라간다...

      top = widget.parentPosition.dy +
          widget.parentSize.height -
          LayoutConst.miniMenuGap -
          LayoutConst.miniMenuHeight;
    }

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: LayoutConst.miniMenuWidth,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          //color: CretaColor.primary.withOpacity(0.5),
          color: Colors.white.withOpacity(0.5),
          border: Border.all(
            width: 1,
            color: CretaColor.primary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buttonList(),
        ),
      ),
    );
  }

  List<Widget> _buttonList() {
    return [
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.mainFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.schedule_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameMain");
            widget.onFrameMain.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.frontFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_front_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            widget.onFrameFront.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.backFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_back_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onFrameBack.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.copyFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.copy_all_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameCopy");
            widget.onFrameCopy.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.rotateFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.screen_rotation_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameRotate");
            widget.onFrameRotate.call();
          }),
      BTN.fill_blue_i_menu(
          tooltipFg: CretaColor.text,
          tooltip: CretaStudioLang.deleteFrameTooltip,
          icon: Icons.delete_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameDelete");
            widget.onFrameDelete.call();
          }),
    ];
  }
}
