import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../data_io/contents_manager.dart';
import '../../../../../design_system/buttons/creta_button.dart';
import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';

//
// 사용되지 않는 파일임...
//

class MiniMenuContents extends StatefulWidget {
  final ContentsManager contentsManager;
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
    required this.contentsManager,
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
    double top = widget.parentPosition.dy -
        LayoutConst.miniMenuGap -
        LayoutConst.miniMenuHeight +
        LayoutConst.dragHandle;

    if (widget.parentPosition.dy < LayoutConst.miniMenuGap + LayoutConst.miniMenuHeight) {
      // 화면의 영역을 벗어나면 어쩔 것인가...
      // 겨...올라간다...

      top = widget.parentPosition.dy + LayoutConst.miniMenuGap + 2 * LayoutConst.dragHandle;
    }

    ContentsModel? model = widget.contentsManager.getSelected() as ContentsModel?;

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: LayoutConst.miniMenuWidth,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          //color: CretaColor.primary.withOpacity(0.5),
          color: CretaColor.secondary[100],
          border: Border.all(
            width: 1,
            color: CretaColor.secondary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _contentsMenu(model),
        ),
      ),
    );
  }

  List<Widget> _contentsMenu(ContentsModel? model) {
    return [
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['flipConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameMain");
            widget.onContentsFlip.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['rotateConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.rotate_90_degrees_cw_outlined,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            widget.onContentsRotate.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['cropConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.crop_outlined,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onContentsCrop.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['fullscreenConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: model != null ? model.fitIcon() : Icons.photo_size_select_large,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameCopy");
            if (model == null) {
              logger.severe('selected contents is null');
              return;
            }
            model.setNextFit();
            widget.contentsManager.notify();
            widget.onContentsFullscreen.call();
            setState(() {});
          }),
      if (!widget.contentsManager.iamBusy)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang['deleteConTooltip']!,
            iconColor: CretaColor.secondary,
            icon: Icons.delete_outlined,
            buttonColor: CretaButtonColor.secondary,
            decoType: CretaButtonDeco.opacity,
            onPressed: () {
              BookMainPage.containeeNotifier!.setFrameClick(true);
              logger.fine("MinuMenu onFrameDelete");
              widget.onContentsDelete.call();
            }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['editConTooltip']!,
          tooltipFg: CretaColor.text,
          iconColor: CretaColor.secondary,
          icon: Icons.edit_outlined,
          decoType: CretaButtonDeco.opacity,
          buttonColor: CretaButtonColor.secondary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onContentsEdit");
            widget.onContentsEdit.call();
          }),
    ];
  }
}
