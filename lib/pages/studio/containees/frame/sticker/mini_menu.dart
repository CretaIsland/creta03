// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hycop/common/util/logger.dart';

import '../../../../../data_io/contents_manager.dart';
import '../../../../../data_io/frame_manager.dart';
import '../../../../../design_system/buttons/creta_button.dart';
import '../../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../../model/frame_model_util.dart';
import '../../../book_main_page.dart';
import '../../../left_menu/left_menu_page.dart';
import '../../../studio_constant.dart';
import '../../../studio_variables.dart';
import '../../containee_nofifier.dart';
import 'draggable_stickers.dart';
import 'stickerview.dart';

class MiniMenu extends StatefulWidget {
  final ContentsManager? contentsManager;
  final FrameManager frameManager;

  static bool _showFrame = false;
  static bool get showFrame => _showFrame;
  static void setShowFrame(bool val) {
    //print('setShowFrame($val)------------------------');
    _showFrame = val;
  }

  final Sticker sticker;
  final double pageHeight;
  final FrameModel frameModel;
  final void Function() onFrameDelete;
  final void Function() onFrameFront;
  final void Function() onFrameBack;
  final void Function() onFrameCopy;
  //final void Function() onFrameRotate;

  final void Function() onFrameShowUnshow;
  final void Function() onFrameMain;
  final void Function(bool)? onFrontBackHover;
  final void Function() onContentsFlip;
  final void Function() onContentsRotate;
  final void Function() onContentsCrop;
  final void Function() onContentsFullscreen;
  final void Function() onContentsDelete;
  final void Function() onContentsEdit;

  const MiniMenu({
    super.key,
    required this.frameModel,
    required this.contentsManager,
    required this.frameManager,
    required this.sticker,
    required this.pageHeight,
    required this.onFrameDelete,
    required this.onFrameFront,
    required this.onFrameBack,
    required this.onFrameCopy,
    //required this.onFrameRotate,

    required this.onFrameShowUnshow,
    required this.onFrameMain,
    this.onFrontBackHover,
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
  //bool showFrame = false;
  final double radius = LayoutConst.miniMenuHeight / 2;
  //OffsetEventController? _linkSendEvent;

  late bool isFirstTime;
  late FrameModel _frameModel;
  late Sticker _sticker;

  @override
  void didUpdateWidget(MiniMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.frameModel != widget.frameModel) {
      //print('frameModel changed');
      _frameModel = widget.frameModel;
    }
    if (oldWidget.sticker != widget.sticker) {
      //print('sticker changed');
      _sticker = widget.sticker;
    }
  }

  @override
  void dispose() {
    //print('MiniMenuState.dispose');
    DraggableStickers.isFrontBackHover = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    //final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    //_linkSendEvent = linkSendEvent;
    isFirstTime = true;
    //print('MiniMenu initState isFirstTime=$isFirstTime');

    _frameModel = widget.frameModel;
    _sticker = widget.sticker;
  }

  @override
  Widget build(BuildContext context) {
    //print('MiniMenu build isFirstTime=$isFirstTime');

    // Offset stickerOffset = Offset.zero;
    // if (isFirstTime == true) {
    //   stickerOffset = _sticker.position + BookMainPage.pageOffset;
    //   isFirstTime = false;
    // } else {
    //   stickerOffset = _sticker.position;
    // }
    // double centerX = stickerOffset.dx + (_sticker.frameSize.width + LayoutConst.stikerOffset) / 2;

    // double left = centerX - LayoutConst.miniMenuWidth / 2;
    // double top = stickerOffset.dy +
    //     _sticker.frameSize.height +
    //     LayoutConst.miniMenuGap +
    //     LayoutConst.dragHandle;

    double posX = FrameModelUtil.getRealPosX(_frameModel);
    double posY = FrameModelUtil.getRealPosY(_frameModel);

    //print('pos=$posX, $posY');

    //double centerX = posX + (_sticker.frameSize.width + LayoutConst.stikerOffset) / 2;
    //double left = centerX - LayoutConst.miniMenuWidth / 2;
    double left = posX +
        ((_sticker.frameSize.width - LayoutConst.miniMenuWidth) / 2) +
        LayoutConst.stikerOffset / 2;
    double top =
        posY + _sticker.frameSize.height + LayoutConst.miniMenuGap + LayoutConst.dragHandle; // +
    //LayoutConst.stikerOffset / 2;

    //print('_sticker.frameSize.height=${_sticker.frameSize.height}');
    //print('left,top=$left, $top');

    // if (top + LayoutConst.miniMenuHeight > widget.pageHeight) {
    //   // 화면의 영역을 벗어나면 어쩔 것인가...
    //   // 겨...올라간다...

    //   top = widget.parentPosition.dy +
    //       widget.parentSize.height -
    //       LayoutConst.miniMenuGap -
    //       LayoutConst.miniMenuHeight +
    //       LayoutConst.dragHandle;
    // }
    bool hasContents = false;
    if (widget.contentsManager != null) {
      hasContents = widget.contentsManager!.hasContents();
    }

    ContentsModel? model;
    if (hasContents) {
      model = widget.contentsManager!.getSelected() as ContentsModel?;
    }

    //print('MiniMenu ${BookMainPage.miniMenuNotifier!.isShow} ......');

    return Visibility(
      visible: BookMainPage.miniMenuNotifier!.isShow,
      child: Consumer<ContaineeNotifier>(builder: (context, containeeNotifier, child) {
        //print('Consumer<ContaineeNotifier> - MiniMenu  ${CretaCommonUtils.timeLap()}');
        return Positioned(
          left: left,
          top: top,
          child: SizedBox(
            width: LayoutConst.miniMenuWidth,
            height: LayoutConst.miniMenuHeight,
            child: MiniMenu.showFrame
                ? Stack(
                    children: [
                      if (hasContents) _contentsMenu(model),
                      _frameMenu(hasContents),
                    ],
                  )
                : Stack(
                    children: [
                      _frameMenu(hasContents),
                      if (hasContents) _contentsMenu(model),
                    ],
                  ),
          ),
        );
      }),
    );
  }

  Widget _frameMenu(bool hasContents) {
    return Align(
      alignment: hasContents
          ? MiniMenu.showFrame
              ? Alignment.topLeft
              : Alignment.topRight
          : Alignment.topCenter,
      child: Container(
        width: hasContents && MiniMenu.showFrame
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
          borderRadius: hasContents && MiniMenu.showFrame
              ? BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                )
              : BorderRadius.all(Radius.circular(radius)),
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
      // 보이기 안보이기
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['showUnshow']!,
          tooltipFg: CretaColor.text,
          icon:
              _frameModel.isShow.value ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onShowUnshow");
            _frameModel.isShow.set(!_frameModel.isShow.value);
            widget.frameManager.changeOrderByIsShow(_frameModel);
            widget.onFrameShowUnshow.call();
            LeftMenuPage.treeInvalidate();
            setState(() {});
          }),
      // 메인 프레임 설정
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['mainFrameTooltip']!,
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
      // 앞으로 가져오기
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['frontFrameTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_front_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          noHoverEffect: true,
          onHover: widget.onFrontBackHover,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            widget.onFrameFront.call();
          }),
      //뒤로 보내기
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['backFrameTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.flip_to_back_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          noHoverEffect: true,
          onHover: widget.onFrontBackHover,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onFrameBack.call();
          }),
      // 복사하기
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['copyFrameTooltip']!,
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
      // BTN.fill_blue_i_menu(
      //     tooltip: CretaStudioLang['rotateFrameTooltip']!,
      //     tooltipFg: CretaColor.text,
      //     icon: Icons.screen_rotation_outlined,
      //     decoType: CretaButtonDeco.opacity,
      //     iconColor: CretaColor.primary,
      //     buttonColor: CretaButtonColor.primary,
      //     onPressed: () {
      //       BookMainPage.containeeNotifier!.setFrameClick(true);
      //       logger.fine("MinuMenu onFrameRotate");
      //       widget.onFrameRotate.call();
      //     }),
      // 링크하기
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['linkFrameTooltip']!,
          tooltipFg: CretaColor.text,
          icon: LinkParams.isLinkNewMode ? Icons.close : Icons.radio_button_checked_outlined,
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            logger.fine("MinuMenu onFrameLink");
            BookMainPage.containeeNotifier!.setFrameClick(true);
            setState(() {
              LinkParams.isLinkNewMode = !LinkParams.isLinkNewMode;
            });
            if (LinkParams.isLinkNewMode) {
              if (LinkParams.linkNew(_frameModel)) {
                //_linkSendEvent?.sendEvent(const Offset(1, 1));
                BookMainPage.bookManagerHolder!.notify();
              }
            } else {
              LinkParams.linkCancel(_frameModel);
            }
          }),

      // BTN.fill_blue_i_menu(
      //     tooltipFg: CretaColor.text,
      //     tooltip: CretaStudioLang['deleteFrameTooltip']!,
      //     icon: Icons.delete_outlined,
      //     decoType: CretaButtonDeco.opacity,
      //     iconColor: CretaColor.primary,
      //     buttonColor: CretaButtonColor.primary,
      //     onPressed: () {
      //       BookMainPage.containeeNotifier!.setFrameClick(true);
      //       logger.fine("MinuMenu onFrameDelete");
      //       widget.onFrameDelete.call();
      //     }),

      // 삭제하기
      BTN.fill_blue_image_menu(
          tooltipFg: CretaColor.text,
          tooltip: CretaStudioLang['deleteFrameTooltip']!,
          iconImageFile: "assets/delete_frame.svg",
          decoType: CretaButtonDeco.opacity,
          iconColor: CretaColor.primary,
          buttonColor: CretaButtonColor.primary,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameDelete");
            widget.onFrameDelete.call();
          }),

      if (hasContents && MiniMenu.showFrame == false)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang['toFrameMenu']!,
            icon: Icons.space_dashboard_outlined,
            decoType: CretaButtonDeco.opacity,
            iconColor: CretaColor.primary,
            buttonColor: CretaButtonColor.primary,
            onPressed: () {
              setState(() {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
                MiniMenu.setShowFrame(true);
                LeftMenuPage.treeInvalidate();
              });
            })
    ];
  }

  Widget _contentsMenu(ContentsModel? model) {
    return Align(
      alignment: MiniMenu.showFrame ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        width: MiniMenu.showFrame ? LayoutConst.miniMenuWidth : LayoutConst.miniMenuWidth * 6 / 7,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          //color: CretaColor.primary.withOpacity(0.5),
          color: CretaColor.secondary[100],
          border: Border.all(
            width: 1,
            color: CretaColor.secondary,
          ),
          borderRadius: MiniMenu.showFrame
              ? BorderRadius.all(Radius.circular(radius))
              : BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  bottomLeft: Radius.circular(radius),
                ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _contentsButtons(model),
        ),
      ),
    );
  }

  List<Widget> _contentsButtons(ContentsModel? model) {
    return [
      // 콘텐츠 반전
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
            model!.isFlip.set(!model.isFlip.value);
            widget.contentsManager?.notify();
            widget.onContentsFlip.call();
            setState(() {});
          }),
      // 콘텐츠 회전
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['rotateConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: model != null && model.isFlip.value
              ? Icons.rotate_90_degrees_ccw_outlined
              : Icons.rotate_90_degrees_cw_outlined,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          onPressed: () {
            if (model == null) return;
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameFront");
            double newAngle = (((model.angle.value / 15).floor() + 1) * 15) % 360;
            model.angle.set(newAngle);
            widget.contentsManager?.notify();
            widget.onContentsRotate.call();
          }),
      // 콘텐츠 크롭
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['cropConTooltip']!,
          tooltipFg: CretaColor.text,
          icon: Icons.crop_outlined,
          iconColor: CretaColor.secondary,
          buttonColor: CretaButtonColor.secondary,
          decoType: CretaButtonDeco.opacity,
          enable: false,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onFrameBack");
            widget.onContentsCrop.call();
          }),
      // 콘텐츠 맞춤
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
            widget.contentsManager?.notify();
            widget.onContentsFullscreen.call();
            setState(() {});
          }),
      // 콘텐츠 삭제
      if (widget.contentsManager != null && widget.contentsManager!.iamBusy == false)
        BTN.fill_blue_image_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang['deleteConTooltip']!,
            iconColor: CretaColor.secondary,
            iconImageFile: "assets/delete_content.svg",
            buttonColor: CretaButtonColor.secondary,
            decoType: CretaButtonDeco.opacity,
            onPressed: () {
              BookMainPage.containeeNotifier!.setFrameClick(true);
              logger.fine("MinuMenu onContentsDelete");
              widget.onContentsDelete.call();
            }),
      // BTN.fill_blue_i_menu(
      //     tooltipFg: CretaColor.text,
      //     tooltip: CretaStudioLang['deleteConTooltip']!,
      //     iconColor: CretaColor.secondary,
      //     icon: Icons.delete_outlined,
      //     buttonColor: CretaButtonColor.secondary,
      //     decoType: CretaButtonDeco.opacity,
      //     onPressed: () {
      //       BookMainPage.containeeNotifier!.setFrameClick(true);
      //       logger.fine("MinuMenu onFrameDelete");
      //       widget.onContentsDelete.call();
      //     }),
      // 콘텐츠 편집
      BTN.fill_blue_i_menu(
          tooltip: CretaStudioLang['editConTooltip']!,
          tooltipFg: CretaColor.text,
          iconColor: CretaColor.secondary,
          icon: Icons.edit_outlined,
          decoType: CretaButtonDeco.opacity,
          buttonColor: CretaButtonColor.secondary,
          enable: false,
          onPressed: () {
            BookMainPage.containeeNotifier!.setFrameClick(true);
            logger.fine("MinuMenu onContentsEdit");
            widget.onContentsEdit.call();
          }),

      if (MiniMenu.showFrame)
        BTN.fill_blue_i_menu(
            tooltipFg: CretaColor.text,
            tooltip: CretaStudioLang['toContentsMenu']!,
            icon: Icons.image_outlined,
            decoType: CretaButtonDeco.opacity,
            iconColor: CretaColor.secondary,
            buttonColor: CretaButtonColor.secondary,
            onPressed: () {
              setState(() {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents);
                MiniMenu.setShowFrame(false);
                LeftMenuPage.treeInvalidate();
              });
            }),
    ];
  }
}
