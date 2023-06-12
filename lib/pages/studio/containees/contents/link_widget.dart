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
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/link_model.dart';
import '../../../../model/page_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../book_main_page.dart';
import '../../book_preview_menu.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
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
  const LinkWidget({
    super.key,
    required this.applyScale,
    required this.frameManager,
    required this.contentsManager,
    required this.playTimer,
    required this.contentsModel,
    required this.frameModel,
    required this.frameOffset,
  });

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  LinkManager? _linkManager;
  OffsetEventController? _linkReceiveEvent;
  OffsetEventController? _linkSendEvent;
  //BoolEventController? _lineDrawSendEvent;
  bool _isMove = false;
  Offset _position = Offset.zero;
  Offset _prev = Offset.zero;
  bool _isHover = false;

  @override
  void initState() {
    super.initState();
    _linkManager = widget.contentsManager.findLinkManager(widget.contentsModel.mid);
    final OffsetEventController linkReceiveEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkReceiveEvent = linkReceiveEvent;
    final OffsetEventController linkSendEvent = Get.find(tag: 'frame-each-to-on-link');
    _linkSendEvent = linkSendEvent;
    // final BoolEventController lineDrawSendEvent = Get.find(tag: 'draw-link');
    // _lineDrawSendEvent = lineDrawSendEvent;
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
            //logger.info('_linkReceiveEvent ($_position) ${LinkParams.isLinkNewMode}');
            return Consumer<LinkManager>(builder: (context, linkManager, child) {
              // LinkManager? linkManager =
              //     widget.contentsManager.findLinkManager(widget.contentsModel.mid);
              // if (linkManager == null) {
              //   return const SizedBox.shrink();
              // }

              return SizedBox(
                width: double.infinity,
                height: double.infinity,
                //color: Colors.amber,
                child: MouseRegion(
                  cursor: LinkParams.isLinkNewMode ? SystemMouseCursors.none : MouseCursor.defer,
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
                      logger.info('sendEvent ${event.position}');
                      _linkSendEvent?.sendEvent(event.position);
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
                        ),
                      if (_isHover &&
                          LinkParams.isLinkNewMode == false &&
                          widget.contentsModel.isLinkEditMode == false)
                        _drawOrder(hasContents),
                      if (_showLinkCursor(hasContents))
                        OnLinkCursor(
                          key: GlobalObjectKey('OnLinkCursor${widget.frameModel.mid}'),
                          pageOffset: widget.frameManager.pageOffset,
                          frameOffset: widget.frameOffset,
                          frameManager: widget.frameManager,
                          frameModel: widget.frameModel,
                          contentsManager: widget.contentsManager,
                          applyScale: widget.applyScale,
                        ),
                    ],
                  ),
                ),
              );
            });
          }),
    );
  }

  bool _showLinkCursor(bool hasContents) {
    if (!_isHover) return false;
    if (!LinkParams.isLinkNewMode) return false;
    if (!hasContents) return false;
    if (StudioVariables.isPreview) return false;
    if (LinkParams.connectedClass == 'frame') {
      if (LinkParams.connectedMid == widget.frameModel.mid) {
        return false;
      }
    }
    return true;
  }

  bool _showPlayButton() {
    //logger.info('_showPlayButton(${LinkParams.isLinkNewMode})');
    if (!_isHover) return false;
    if (!_isPlayAble()) return false;
    if (LinkParams.isLinkNewMode) return false;
    if (widget.contentsModel.isLinkEditMode) return false;
    return true;
  }

  List<Widget> _drawLinkCursor(LinkManager linkManager) {
    linkManager.reOrdering();
    int len = linkManager.getAvailLength();
    if (len == 0) {
      return [];
    }
    //logger.info('^^^^^^^^^^^^^^^^^^drawEachLink----$len');
    return linkManager
        .orderMapIterator((model) => _drawEachLink(model as LinkModel, linkManager))
        .toList();
  }

  Widget _drawEachLink(LinkModel model, LinkManager linkManager) {
    model.iconKey = GlobalObjectKey('linkIcon${model.mid}');
    const double stickerOffset = LayoutConst.stikerOffset / 2;
    double posX = (model.posX - stickerOffset) * widget.applyScale;
    double posY = (model.posY - stickerOffset) * widget.applyScale;
    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }
    _position = Offset(posX, posY);
    //logger.info('^^^^^^^^^^^^^^^^^^_position----$posX, $posY,,,');

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: StudioVariables.isPreview ||
              (LinkParams.isLinkNewMode == false && widget.contentsModel.isLinkEditMode == false)
          ? _mainButton(model)
          : GestureDetector(
              onScaleStart: (details) {
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
                  model.posX += dx;
                  model.posY += dy;
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
    const double iconSize = 24;
    int index = -1;
    if (model.connectedClass == 'page') {
      // 이경우 페이지 번호를 구해야 한다.
      index = BookMainPage.pageManagerHolder!.getIndex(model.connectedMid);
    }
    return GestureDetector(
      onTapUp: (d) {
        logger.info('link button pressed ${model.mid}');
        BookMainPage.containeeNotifier!.setFrameClick(true);

        if (widget.contentsModel.isLinkEditMode == true) return;
        if (LinkParams.isLinkNewMode == true) return;

        const double stickerOffset = LayoutConst.stikerOffset / 2;
        double posX = (model.posX - stickerOffset) * widget.applyScale;
        double posY = (model.posY - stickerOffset) * widget.applyScale;

        if (model.connectedClass == 'page') {
          // show Page
          PageModel? pageModel =
              BookMainPage.pageManagerHolder!.getModel(model.connectedMid) as PageModel?;
          if (pageModel != null) {
            bool isShow = true;
            pageModel.isTempVisible = isShow;
            if (isShow == true) {
              LinkParams.linkPostion = Offset(posX, posY);
              LinkParams.orgPostion = widget.frameOffset;
              LinkParams.connectedMid = model.connectedMid;
              LinkParams.connectedClass = 'page';
              LinkParams.invokerMid = widget.frameManager.pageModel.mid;
            } else {
              LinkParams.linkPostion = null;
              LinkParams.orgPostion = null;
              LinkParams.connectedMid = '';
              LinkParams.connectedClass = '';
            }
            //_lineDrawSendEvent?.sendEvent(isShow);
            //_linkManager?.notify();

            BookPreviewMenu.previewMenuPressed = true;
            BookMainPage.pageManagerHolder?.setSelectedMid(model.connectedMid);
          }
        } else if (model.connectedClass == 'frame') {
          // show frame
          FrameModel? frameModel = widget.frameManager.getModel(model.connectedMid) as FrameModel?;
          if (frameModel != null) {
            bool isShow = !frameModel.isTempVisible;
            frameModel.isTempVisible = isShow;
            if (isShow == true) {
              double order = widget.frameManager.getMaxOrder() + 1;
              frameModel.order.set(order);
              // 여기서 연결선을 연결한다....
              LinkParams.linkPostion = Offset(posX, posY);
              LinkParams.orgPostion = widget.frameOffset;
              LinkParams.connectedMid = model.connectedMid;
              LinkParams.connectedClass = 'frame';
            } else {
              LinkParams.linkPostion = null;
              LinkParams.orgPostion = null;
              LinkParams.connectedMid = '';
              LinkParams.connectedClass = '';
            }
            model.showLinkLine = isShow;
            //_lineDrawSendEvent?.sendEvent(isShow);
            widget.frameManager.notify();
            //_linkManager?.notify();
          }
        }
        return;
      },
      child: index < 0 || StudioVariables.isPreview == true
          ? Container(
              width: iconSize + 4,
              height: iconSize + 4,
              //color: Colors.amber.withOpacity(0.5),
              alignment: Alignment.topLeft,
              child: Icon(
                key: model.iconKey,
                Icons.radio_button_checked_outlined,
                size: iconSize,
                color: _isMove ? CretaColor.primary : CretaColor.secondary,
              ),
            )
          : Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  width: iconSize + 6,
                  height: iconSize,
                  //color: Colors.amber.withOpacity(0.5),
                  alignment: Alignment.topLeft,
                  child: Icon(
                    key: model.iconKey,
                    Icons.radio_button_checked_outlined,
                    size: iconSize,
                    color: _isMove ? CretaColor.primary : CretaColor.secondary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6.0),
                  child: Text(index > 9 ? '$index' : '0$index',
                      style: CretaFont.bodyESmall.copyWith(fontSize: 6, color: Colors.white)),
                ),
              ],
            ),
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

  Widget _delButton(LinkModel model, LinkManager linkManager) {
    const double iconSize = 10;
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        child: const Icon(Icons.close, size: iconSize, color: Colors.white),
        onLongPressDown: (detail) {
          logger.info('delete button pressed ${model.mid}');
          linkManager.delete(link: model);
        },
      ),
    );
  }

  bool _isPlayAble() {
    if (widget.contentsModel.contentsType == ContentsType.text) {
      return false;
    }
    return true;
  }

  Widget _drawOrder(bool hasContents) {
    if (_isHover && !hasContents) {
      return Text(
        '${widget.contentsModel.order.value}',
        style: CretaFont.titleELarge.copyWith(color: Colors.black),
      );
    }
    if (DraggableStickers.isFrontBackHover) {
      return Text(
        '${widget.contentsModel.order.value} : $hasContents',
        style: CretaFont.titleELarge.copyWith(color: Colors.white),
      );
    }
    if (DraggableStickers.isFrontBackHover) {
      return Text(
        '${widget.contentsModel.order.value} : $hasContents',
        style: CretaFont.titleLarge,
      );
    }
    return const SizedBox.shrink();
  }
}
