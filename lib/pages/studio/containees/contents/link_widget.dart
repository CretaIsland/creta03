import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/link_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/component/creta_right_mouse_menu.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../design_system/menu/creta_popup_menu.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../book_main_page.dart';
import '../../book_preview_menu.dart';
import '../../left_menu/left_menu_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../containee_nofifier.dart';
import '../frame/on_link_cursor.dart';
import '../frame/sticker/draggable_stickers.dart';
import 'play_buttons.dart';

class LinkWidget extends StatefulWidget {
  final double applyScale;
  final FrameManager frameManager;
  final ContentsManager contentsManager;
  final CretaPlayTimer playTimer;
  final ContentsModel contentsModel;
  final FrameModel frameModel;
  final Offset frameOffset;
  final void Function() onFrameShowUnshow;
  const LinkWidget({
    super.key,
    required this.applyScale,
    required this.frameManager,
    required this.contentsManager,
    required this.playTimer,
    required this.contentsModel,
    required this.frameModel,
    required this.frameOffset,
    required this.onFrameShowUnshow,
  });

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  LinkManager? _linkManager;
  OffsetEventController? _linkReceiveEvent;
  OffsetEventController? _linkSendEvent;
  FrameEventController? _sendEvent;
  //BoolEventController? _lineDrawSendEvent;
  bool _isMove = false;
  Offset _position = Offset.zero;
  Offset _prev = Offset.zero;
  bool _isHover = false;
  BookModel? _bookModel;
  int _linkCount = 0;

  @override
  void initState() {
    super.initState();
    _linkManager = widget.contentsManager.findLinkManager(widget.contentsModel.mid);
    final OffsetEventController linkReceiveEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkReceiveEvent = linkReceiveEvent;
    final OffsetEventController linkSendEvent = Get.find(tag: 'frame-each-to-on-link');
    _linkSendEvent = linkSendEvent;
    final FrameEventController sendEvent = Get.find(tag: 'frame-property-to-main');
    _sendEvent = sendEvent;
    // final BoolEventController lineDrawSendEvent = Get.find(tag: 'draw-link');
    // _lineDrawSendEvent = lineDrawSendEvent;
    _bookModel = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
  }

  @override
  Widget build(BuildContext context) {
    bool hasContents = widget.contentsManager.length() > 0;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LinkManager>.value(
          value: _linkManager!,
        ),
      ],
      child: StreamBuilder<Offset>(
          stream: _linkReceiveEvent!.eventStream.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null && snapshot.data is Offset) {
              _position = snapshot.data!;
            }
            //logger.fine('_linkReceiveEvent ($_position) ${LinkParams.isLinkNewMode}');
            return Consumer<LinkManager>(builder: (context, linkManager, child) {
              // LinkManager? linkManager =
              //     widget.contentsManager.findLinkManager(widget.contentsModel.mid);
              // if (linkManager == null) {
              //   return const SizedBox.shrink();
              // }

              bool showLinkCursor = _showLinkCursor(hasContents);

              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: MouseRegion(
                  //cursor: SystemMouseCursors.none,
                  cursor: StudioVariables.hideMouse
                      ? SystemMouseCursors.none
                      : LinkParams.isLinkNewMode
                          ? SystemMouseCursors.none
                          : MouseCursor.defer,
                  onEnter: ((event) {
                    setState(() {
                      _isHover = true;
                    });
                  }),
                  onExit: ((event) {
                    setState(() {
                      _isHover = false;
                    });
                  }),
                  onHover: (event) {
                    if (LinkParams.isLinkNewMode &&
                        StudioVariables.isPreview == false &&
                        hasContents) {
                      //logger.fine('sendEvent ${event.localPosition}');
                      _linkSendEvent?.sendEvent(event.localPosition);
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ..._drawLinkCursor(linkManager),
                      if (_showPlayButton())
                        PlayButton(
                          key: GlobalObjectKey(
                              'PlayButton${widget.frameModel.mid}${widget.applyScale}'),
                          applyScale: widget.applyScale,
                          frameModel: widget.frameModel,
                          playTimer: widget.playTimer,
                          canMove: (_linkCount > 0),
                        ),
                      // if (DraggableStickers.isFrontBackHover &&
                      //     LinkParams.isLinkNewMode == false &&
                      //     widget.contentsModel.isLinkEditMode == false)
                      //   _drawOrder(hasContents),
                      if (showLinkCursor) // 생성시 그려지는 것을 말한다.
                        OnLinkCursor(
                          key: GlobalObjectKey('OnLinkCursor${widget.frameModel.mid}'),
                          //pageOffset: widget.frameManager.pageOffset,
                          frameOffset: widget.frameOffset,
                          frameManager: widget.frameManager,
                          frameModel: widget.frameModel,
                          contentsManager: widget.contentsManager,
                          applyScale: widget.applyScale,
                        ),
                      if (_showVisibleButton()) _drawVisibleButton(),
                      if (_showVisibleButton()) _drawMaximizeButton(),
                      if (_showVisibleButton()) _drawStopNextContents(),
                    ],
                  ),
                ),
              );
            });
          }),
    );
  }

  bool _showLinkCursor(bool hasContents) {
    if (!_isHover) {
      return false;
    }
    if (!LinkParams.isLinkNewMode) {
      return false;
    }
    if (!hasContents) {
      return false;
    }
    if (StudioVariables.isPreview) {
      return false;
    }
    if (LinkParams.connectedClass == 'frame') {
      if (LinkParams.connectedMid == widget.frameModel.mid) {
        return false;
      }
    }
    return true;
  }

  Widget _drawVisibleButton() {
    double buttonSize = 20;
    double margin = 20;
    double posX = (widget.frameModel.width.value - buttonSize - margin) * widget.applyScale;
    double posY = margin / 2 * widget.applyScale;

    return Positioned(
        left: posX,
        top: posY,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: BTN.fill_i_s(
              useTapUp: true,
              icon: widget.frameModel.isShow.value
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              onPressed: () {
                BookMainPage.containeeNotifier!.setFrameClick(true);

                widget.frameModel.isShow.set(!widget.frameModel.isShow.value);
                widget.frameManager.changeOrderByIsShow(widget.frameModel);
                //widget.frameModel.isTempVisible = widget.frameModel.isShow.value;
                widget.onFrameShowUnshow.call();
              }),
        ));
  }

  Widget _drawStopNextContents() {
    double buttonSize = 20;
    double margin = 20;
    double posX = (widget.frameModel.width.value - 3 * (buttonSize + margin)) * widget.applyScale;
    double posY = margin / 2 * widget.applyScale;

    return Positioned(
        left: posX,
        top: posY,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: BTN.fill_i_s(
              useTapUp: true,
              icon: StudioVariables.stopNextContents == true
                  ? Icons.push_pin_outlined
                  : Icons.repeat_outlined,
              onPressed: () {
                setState(
                  () {
                    StudioVariables.stopNextContents = !StudioVariables.stopNextContents;
                  },
                );
              }),
        ));
  }

  Widget _drawMaximizeButton() {
    double buttonSize = 20;
    double margin = 20;
    double posX = (widget.frameModel.width.value - 2 * (buttonSize + margin)) * widget.applyScale;
    double posY = margin / 2 * widget.applyScale;

    bool isFullScreen = widget.frameModel.isFullScreenTest(_bookModel!);

    return Positioned(
        left: posX,
        top: posY,
        child: SizedBox(
          width: buttonSize,
          height: buttonSize,
          child: BTN.fill_i_s(
              useTapUp: true,
              icon: isFullScreen ? Icons.fullscreen_exit_outlined : Icons.fullscreen_outlined,
              onPressed: () {
                if (_bookModel == null) return;
                setState(() {
                  widget.frameModel.toggleFullscreen(isFullScreen, _bookModel!);
                  //logger.finest('sendEvent');
                  _sendEvent!.sendEvent(widget.frameModel);
                  _notifyToThumbnail();
                });
              }),
        ));
  }

  bool _showPlayButton() {
    //logger.fine('_showPlayButton(${LinkParams.isLinkNewMode})');
    if (!_isHover) return false;
    if (!_isPlayAble()) return false;
    if (LinkParams.isLinkNewMode) return false;
    if (widget.contentsModel.isLinkEditMode) return false;
    if (StudioVariables.hideMouse) return false;
    if (widget.frameModel.width.value * StudioVariables.applyScale < 96) return false;

    // Frame 이 선택된 경우에만 보이도록 수정한다.
    // if (CretaManager.frameSelectNotifier != null) {
    //   if (CretaManager.frameSelectNotifier!.selectedAssetId != widget.frameModel.mid) {
    //     return false;
    //   }
    // }
    //if (widget.contentsModel.contentsType == ContentsType.document) return false;
    DraggableStickers.isFrontBackHover = false;
    return true;
  }

  bool _showVisibleButton() {
    //logger.fine('_showPlayButton(${LinkParams.isLinkNewMode})');
    if (!_isHover) return false;
    //if (!_isPlayAble()) return false;
    if (LinkParams.isLinkNewMode) return false;
    if (widget.contentsModel.isLinkEditMode) return false;
    if (StudioVariables.isPreview == false) return false;
    if (StudioVariables.hideMouse) return false;
    //if (widget.contentsModel.contentsType == ContentsType.document) return false;
    return true;
  }

  List<Widget> _drawLinkCursor(LinkManager linkManager) {
    linkManager.reOrdering();
    int len = linkManager.getAvailLength();
    if (len == 0) {
      return [];
    }
    //logger.fine('^^^^^^^^^^^^^^^^^^drawEachLink----$len');
    return linkManager
        .orderMapIterator((model) => _drawEachLink(model as LinkModel, linkManager))
        .toList();
  }

  Widget _drawEachLink(LinkModel model, LinkManager linkManager) {
    model.iconKey = GlobalObjectKey('linkIcon${model.mid}');
    const double stickerOffset = LayoutConst.stikerOffset / 2;
    double posX = (model.posX.value - stickerOffset) * widget.applyScale;
    double posY = (model.posY.value - stickerOffset) * widget.applyScale;
    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }
    _position = Offset(posX, posY);
    logger.info('--------------------drawEachLink--------------------------');
    _linkCount++;
    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: StudioVariables.isPreview ||
              (LinkParams.isLinkNewMode == false && widget.contentsModel.isLinkEditMode == false)
          ? GestureDetector(
              onSecondaryTapDown: (details) {
                if (StudioVariables.isPreview == true) return;
                linkManager.setSelectedMid(model.mid);
                _showRightMouseMenu(
                    model, linkManager, details.globalPosition.dx, details.globalPosition.dy);
              },
              child: _mainButton(model))
          : GestureDetector(
              onSecondaryTapDown: (details) {
                if (StudioVariables.isPreview == true) return;
                linkManager.setSelectedMid(model.mid);
                _showRightMouseMenu(
                    model, linkManager, details.globalPosition.dx, details.globalPosition.dy);
              },
              onScaleStart: (details) {
                //print('linkWidget onScaleStart ----------------------------------------');
                _prev = details.localFocalPoint;
                setState(() {
                  _isMove = true;
                });
              },
              onScaleUpdate: (details) {
                if (_isMove == false) return;

                double dx = (details.localFocalPoint.dx - _prev.dx) / widget.applyScale;
                double dy = (details.localFocalPoint.dy - _prev.dy) / widget.applyScale;
                _prev = details.localFocalPoint;

                setState(() {
                  model.posX.set(model.posX.value + dx);
                  model.posY.set(model.posY.value + dy);
                });
              },
              onScaleEnd: (details) {
                _linkManager?.update(link: model).then((value) {
                  setState(() {
                    _isMove = false;
                  });
                  return value;
                });
              },
              child: Stack(
                //alignment: Alignment.bottomRight,
                children: [
                  _mainButton(model),
                  if (widget.contentsModel.isLinkEditMode == true) _delButton(model, linkManager),
                ],
              ),
            ),
    );
  }

  Widget _mainButton(LinkModel model) {
    double iconSize = model.iconSize.value;
    //int index = -1;
    // if (model.connectedClass == 'page') {
    //   // 이경우 페이지 번호를 구해야 한다.
    //   index = BookMainPage.pageManagerHolder!.getIndex(model.connectedMid);
    // }

    return GestureDetector(
      onTapUp: (d) {
        logger.fine('link button pressed ${model.connectedMid},${model.connectedClass}');
        logger
            .info('link button pressed ${widget.frameModel.mid},${widget.frameModel.isShow.value}');
        BookMainPage.containeeNotifier!.setFrameClick(true);

        if (widget.contentsModel.isLinkEditMode == true) return;
        if (LinkParams.isLinkNewMode == true) return;

        const double stickerOffset = LayoutConst.stikerOffset / 2;
        double posX = (model.posX.value - stickerOffset) * widget.applyScale;
        double posY = (model.posY.value - stickerOffset) * widget.applyScale;

        if (model.connectedClass == 'page') {
          // show Page
          PageModel? pageModel =
              BookMainPage.pageManagerHolder!.getModel(model.connectedMid) as PageModel?;
          if (pageModel != null) {
            //print('connected = ${model.connectedMid} founded');

            bool isShow = true;
            pageModel.isTempVisible = isShow;
            if (isShow == true) {
              LinkParams.linkPostion = Offset(posX, posY);
              LinkParams.orgPostion = widget.frameOffset;
              LinkParams.connectedMid = model.connectedMid;
              LinkParams.connectedClass = 'page';
              LinkParams.connectedName = model.name;
              LinkParams.invokerMid = widget.frameManager.pageModel.mid;
            } else {
              LinkParams.linkPostion = null;
              LinkParams.orgPostion = null;
              LinkParams.connectedMid = '';
              LinkParams.connectedClass = '';
              LinkParams.connectedName = '';
            }
            //_lineDrawSendEvent?.sendEvent(isShow);
            //_linkManager?.notify();

            BookPreviewMenu.previewMenuPressed = true;
            BookMainPage.pageManagerHolder?.setSelectedMid(model.connectedMid);
          } else {
            logger.severe('connected = ${model.connectedMid} not founded');
          }
        } else if (model.connectedClass == 'frame') {
          // show frame
          FrameModel? childModel = widget.frameManager.getModel(model.connectedMid) as FrameModel?;
          if (childModel != null) {
            // print('linkMid=${model.mid}');
            // print('connected=${model.connectedMid}');
            // print('childMid=${childModel.mid}');
            // print('frameMid=${widget.frameModel.mid}');
            // print('PageMid=${widget.frameModel.parentMid.value}');
            //print('connected = ${model.connectedMid} founded');

            childModel.isShow.set(!childModel.isShow.value, save: false, noUndo: true);
            if (childModel.isShow.value == true) {
              double order = widget.frameManager.getMaxOrder();
              if (childModel.order.value < order) {
                widget.frameManager.changeOrderByIsShow(childModel);
                widget.frameManager.reOrdering();
              }
              // 여기서 연결선을 연결한다....
              LinkParams.linkPostion = Offset(posX, posY);
              LinkParams.orgPostion = widget.frameOffset;
              LinkParams.connectedMid = model.connectedMid;
              LinkParams.connectedClass = 'frame';
              LinkParams.connectedName = model.name;
            } else {
              //print('##################################################');
              LinkParams.linkPostion = null;
              LinkParams.orgPostion = null;
              LinkParams.connectedMid = '';
              LinkParams.connectedClass = '';
              LinkParams.connectedName = '';
              widget.frameManager.changeOrderByIsShow(childModel);
              widget.frameManager.reOrdering();
            }
            model.showLinkLine = childModel.isShow.value;
            childModel.save();
            //_lineDrawSendEvent?.sendEvent(isShow);
            logger.fine(
                'link button pressed ${widget.frameModel.mid},${widget.frameModel.isShow.value}');
            widget.frameManager.notify();
            //_linkManager?.notify();
          } else {
            logger.severe('connected = ${model.connectedMid} not founded');
          }
        }
        return;
      },
      child: Consumer<ContaineeNotifier>(builder: (context, manager, child) {
        return Container(
          width: iconSize + 4,
          height: iconSize + 4,
          decoration: model.mid == _linkManager!.getSelectedMid() &&
                  widget.frameManager.isSelected(widget.frameModel.mid) // 선택된 것.
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(width: 1, color: CretaColor.text[700]!),
                )
              : null,
          //color: Colors.amber.withOpacity(0.5),
          alignment: Alignment.center,
          child: Icon(
            key: model.iconKey,
            LinkIconType.toIcon(model.iconData.value), //Icons.radio_button_checked_outlined,
            size: iconSize,
            color: _isMove ? CretaColor.primary : model.bgColor.value,
          ),
        );
      }),

      // child: index < 0 || StudioVariables.isPreview == true
      //     ? Container(
      //         width: iconSize + 4,
      //         height: iconSize + 4,
      //         //color: Colors.amber.withOpacity(0.5),
      //         alignment: Alignment.topLeft,
      //         child: Icon(
      //           key: model.iconKey,
      //           LinkIconType.toIcon(model.iconData.value), //Icons.radio_button_checked_outlined,
      //           size: iconSize,
      //           color: _isMove ? CretaColor.primary : model.bgColor.value,
      //         ),
      //       )
      //     : Stack(
      //         alignment: Alignment.centerLeft,
      //         children: [
      //           Container(
      //             width: iconSize + 6,
      //             height: iconSize,
      //             //color: Colors.amber.withOpacity(0.5),
      //             alignment: Alignment.topLeft,
      //             child: Icon(
      //               key: model.iconKey,
      //               LinkIconType.toIcon(
      //                   model.iconData.value), //Icons.radio_button_checked_outlined,
      //               size: iconSize,
      //               color: _isMove ? CretaColor.primary : model.bgColor.value,
      //             ),
      //           ),
      //           Padding(
      //             padding: const EdgeInsets.only(left: 6.0),
      //             child: Text(index > 9 ? '$index' : '0$index',
      //                 style: CretaFont.bodyESmall.copyWith(fontSize: 6, color: Colors.white)),
      //           ),
      //         ],
      //       ),
    );
    // return IconButton(
    //   icon: Icon(
    //     Icons.radio_button_checked_outlined,
    //     size: iconSize,
    //     color: _isMove ? CretaColor.primary : CretaColor.secondary,
    //   ),
    //   onPressed: () {
    //
    //   },
    // );
  }

  // 오른쪽 마우스 버튼 액션
  void _showRightMouseMenu(LinkModel model, LinkManager linkManager, double dx, double dy) {
    CretaRightMouseMenu.showMenu(
      title: 'linkRightMouseMenu',
      context: context,
      popupMenu: [
        CretaMenuItem(
            caption: CretaStudioLang['deleteLink']!,
            onPressed: () {
              linkManager.delete(link: model);
              LeftMenuPage.initTreeNodes();
              LeftMenuPage.treeInvalidate();
            }),
        CretaMenuItem(
            caption: widget.contentsModel.isLinkEditMode
                ? CretaStudioLang['linkControlOff']!
                : CretaStudioLang['linkControlOn']!,
            onPressed: () {
              widget.contentsModel.isLinkEditMode = !widget.contentsModel.isLinkEditMode;
              if (widget.contentsModel.isLinkEditMode == true) {
                StudioVariables.isAutoPlay = true;
              }
              _linkSendEvent!.sendEvent(const Offset(1, 1));
              setState(() {});
            }),
        CretaMenuItem(
            caption: CretaLang['properties']!,
            onPressed: () {
              //  링크 속성 메뉴를 누르면, 현재 Frame 이 seletct 된것으로 간주해야 한다.
              widget.frameManager.setSelectedMid(widget.frameModel.mid);
              widget.contentsManager.setSelectedMid(widget.contentsModel.mid);
              linkManager.setSelectedMid(model.mid);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Link, doNoti: true);

              LeftMenuPage.initTreeNodes();
              LeftMenuPage.treeInvalidate();
            }),
      ],
      itemHeight: 24,
      x: dx,
      y: dy,
      width: 160,
      //height: menuHeight,
      //textStyle: CretaFont.bodySmall,
      iconSize: 12,
      alwaysShowBorder: true,
      borderRadius: 8,
    );
  }

  Widget _delButton(LinkModel model, LinkManager linkManager) {
    const double iconSize = 10;
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        child: const Icon(Icons.close, size: iconSize, color: Colors.white),
        onLongPressDown: (detail) {
          logger.fine('delete button pressed ${model.mid}');
          linkManager.delete(link: model);
        },
      ),
    );
  }

  bool _isPlayAble() {
    if (widget.contentsModel.contentsType == ContentsType.text) {
      return false;
    }
    if (widget.contentsModel.contentsType == ContentsType.pdf) {
      return false;
    }
    return true;
  }

  void _notifyToThumbnail() {
    BookMainPage.pageManagerHolder?.invalidateThumbnail(widget.frameModel.parentMid.value);
  }

  // Widget _drawOrder(bool hasContents) {
  //   if (_isHover && !hasContents) {
  //     return Text(
  //       '${widget.contentsModel.order.value}',
  //       style: CretaFont.titleELarge.copyWith(color: Colors.black),
  //     );
  //   }
  //   if (DraggableStickers.isFrontBackHover) {
  //     return Text(
  //       '${widget.contentsModel.order.value} : $hasContents',
  //       style: CretaFont.titleELarge.copyWith(color: Colors.white),
  //     );
  //   }
  //   if (DraggableStickers.isFrontBackHover) {
  //     return Text(
  //       '${widget.contentsModel.order.value} : $hasContents',
  //       style: CretaFont.titleLarge,
  //     );
  //   }
  //   return const SizedBox.shrink();
  // }
}
