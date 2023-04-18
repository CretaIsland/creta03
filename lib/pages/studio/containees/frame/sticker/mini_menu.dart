// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hycop/common/util/logger.dart';

import '../../../../../data_io/contents_manager.dart';
import '../../../../../design_system/buttons/creta_button.dart';
import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../lang/creta_studio_lang.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';
import '../../containee_nofifier.dart';

class MiniMenu extends StatefulWidget {
  final ContentsManager contentsManager;

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
  final void Function(bool) onFrontBackHover;
  final void Function() onContentsFlip;
  final void Function() onContentsRotate;
  final void Function() onContentsCrop;
  final void Function() onContentsFullscreen;
  final void Function() onContentsDelete;
  final void Function() onContentsEdit;

  const MiniMenu({
    super.key,
    required this.contentsManager,
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
    required this.onFrontBackHover,
    required this.onContentsFlip,
    required this.onContentsRotate,
    required this.onContentsCrop,
    required this.onContentsFullscreen,
    required this.onContentsDelete,
    required this.onContentsEdit,
  });

  @override
  State<MiniMenu> createState() => MiniMenuState();
}

class MiniMenuState extends State<MiniMenu> {
  bool showFrame = false;

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
        LayoutConst.dragHandle;

    if (top + LayoutConst.miniMenuHeight > widget.pageHeight) {
      // 화면의 영역을 벗어나면 어쩔 것인가...
      // 겨...올라간다...

      top = widget.parentPosition.dy +
          widget.parentSize.height -
          LayoutConst.miniMenuGap -
          LayoutConst.miniMenuHeight +
          LayoutConst.dragHandle;
    }

    bool hasContents = widget.contentsManager.hasContents();

    return Consumer<ContaineeNotifier>(builder: (context, containeeNotifier, child) {
      return Positioned(
        left: left,
        top: top,
        child: SizedBox(
          width: LayoutConst.miniMenuWidth,
          height: LayoutConst.miniMenuHeight,
          child: showFrame
              ? Stack(
                  children: [
                    if (hasContents) _contentsMenu(),
                    _frameMenu(hasContents),
                  ],
                )
              : Stack(
                  children: [
                    _frameMenu(hasContents),
                    if (hasContents) _contentsMenu(),
                  ],
                ),
        ),
      );
    });
  }

  Widget _frameMenu(bool hasContents) {
    return Align(
      alignment: hasContents
          ? showFrame
              ? Alignment.topLeft
              : Alignment.topRight
          : Alignment.topCenter,
      child: Container(
        width: hasContents && showFrame
            ? LayoutConst.miniMenuWidth * 6 / 7
            : LayoutConst.miniMenuWidth,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          //color: CretaColor.primary.withOpacity(0.5),
          color: CretaColor.primary[100],
          border: Border.all(
            width: 1,
            color: CretaColor.primary,
          ),
          borderRadius: hasContents && showFrame
              ? const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  bottomLeft: Radius.circular(45),
                )
              : const BorderRadius.all(Radius.circular(45)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _frameButtons(hasContents),
        ),
      ),
    );
  }

  List<Widget> _frameButtons(bool hasContents) {
    return [
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.mainFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.schedule_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameMain");
            widget.onFrameMain.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.frontFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_front_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onHover: (hover) {
            widget.onFrontBackHover(hover);
          },
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            widget.onFrameFront.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.backFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_back_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onHover: (hover) {
            widget.onFrontBackHover(hover);
          },
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onFrameBack.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.copyFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.copy_all_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameCopy");
            widget.onFrameCopy.call();
          }),
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.rotateFrameTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.screen_rotation_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.info("MinuMenu onFrameRotate");
            widget.onFrameRotate.call();
          }),
      BTN.fill_blue_i_menu(
          tooltipFg: CretaColor.text,
          tooltip: CretaStudioLang.deleteFrameTooltip,
          icon: Icons.delete_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameDelete");
            widget.onFrameDelete.call();
          }),
      if (hasContents && showFrame == false)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang.toFrameMenu,
            icon: Icons.space_dashboard_outlined,
            decoType: CretaButtonDeco.opacity,
            iconColor: CretaColor.primary,
            buttonColor: CretaButtonColor.primary,
            onPressed: () {
              setState(() {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
                showFrame = true;
              });
            })
    ];
  }

  Widget _contentsMenu() {
    return Align(
      alignment: showFrame ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: showFrame ? LayoutConst.miniMenuWidth : LayoutConst.miniMenuWidth * 6 / 7,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          //color: CretaColor.primary.withOpacity(0.5),
          color: CretaColor.secondary[100],
          border: Border.all(
            width: 1,
            color: CretaColor.secondary,
          ),
          borderRadius: showFrame
              ? const BorderRadius.all(Radius.circular(45))
              : const BorderRadius.only(
                  topLeft: Radius.circular(45),
                  bottomLeft: Radius.circular(45),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _contentsButtons(),
        ),
      ),
    );
  }

  List<Widget> _contentsButtons() {
    return [
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang.flipConTooltip,
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
          tooltip: CretaStudioLang.rotateConTooltip,
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
          tooltip: CretaStudioLang.cropConTooltip,
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
          tooltip: CretaStudioLang.fullscreenConTooltip,
          tooltipFg: CretaColor.text,
          icon: Icons.fullscreen_outlined,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameCopy");
            widget.onContentsFullscreen.call();
          }),
      if (widget.contentsManager.iamBusy == false)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang.deleteConTooltip,
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
          tooltip: CretaStudioLang.editConTooltip,
          tooltipFg: CretaColor.text,
          iconColor: CretaColor.secondary,
          icon: Icons.edit_outlined,
          decoType: CretaButtonDeco.opacity,
          buttonColor: CretaButtonColor.secondary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.info("MinuMenu onContentsEdit");
            widget.onContentsEdit.call();
          }),
      if (showFrame)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang.toContentsMenu,
            icon: Icons.image_outlined,
            decoType: CretaButtonDeco.opacity,
            iconColor: CretaColor.secondary,
            buttonColor: CretaButtonColor.secondary,
            onPressed: () {
              setState(() {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents);
                showFrame = false;
              });
            }),
    ];
  }
}
