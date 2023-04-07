import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../lang/creta_studio_lang.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';

class MiniMenuContents extends StatefulWidget {
  final Offset parentPosition;
  final Size parentSize;
  final double parentBorderWidth;
  final double pageHeight;
  final void Function() onContentsFlip;
  final void Function() onContentsRotate;
  final void Function() onContentsCrop;
  final void Function() onContentsFullscreen;
  final void Function() onContentsDelete;
  final void Function() onContentsEdit;

  const MiniMenuContents({
    super.key,
    required this.parentPosition,
    required this.parentSize,
    required this.parentBorderWidth,
    required this.pageHeight,
    required this.onContentsFlip,
    required this.onContentsRotate,
    required this.onContentsCrop,
    required this.onContentsFullscreen,
    required this.onContentsDelete,
    required this.onContentsEdit,
  });

  @override
  State<MiniMenuContents> createState() => _MiniMenuContentsState();
}

class _MiniMenuContentsState extends State<MiniMenuContents> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('MiniMenuContents build');

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
          tooltip: CretaStudioLang.flipConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameMain");
            widget.onContentsFlip.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.rotateConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.rotate_90_degrees_cw_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            widget.onContentsRotate.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.cropConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.crop_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onContentsCrop.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.fullscreenConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.fullscreen_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameCopy");
            widget.onContentsFullscreen.call();
          }),
      BTN.fill_blue_i_menu(
          tooltipFg: CretaColor.text,
          tooltip: CretaStudioLang.deleteConTooltip,
          icon: Icons.delete_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameDelete");
            widget.onContentsDelete.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.editConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.edit_outlined,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.info("MinuMenu onContentsEdit");
            widget.onContentsEdit.call();
          }),
    ];
  }
}
