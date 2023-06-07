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
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/link_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../frame/on_link_cursor.dart';
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
    final OffsetEventController sendEvent = Get.find(tag: 'frame-each-to-on-link');
    _linkSendEvent = sendEvent;
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
            logger.info('_linkReceiveEvent ($_position) ${StudioVariables.isLinkNewMode}');
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
                    if (StudioVariables.isLinkNewMode &&
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
                      if (_isHover && _isPlayAble() && StudioVariables.isNotLinkState)
                        PlayButton(
                          key: GlobalObjectKey(
                              'PlayButton${widget.frameModel.mid}${widget.applyScale}'),
                          applyScale: widget.applyScale,
                          frameModel: widget.frameModel,
                          playTimer: widget.playTimer,
                        ),
                      if (StudioVariables.isLinkNewMode &&
                          StudioVariables.isPreview == false &&
                          _isHover &&
                          hasContents)
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

  List<Widget> _drawLinkCursor(LinkManager linkManager) {
    linkManager.reOrdering();
    int len = linkManager.getAvailLength();
    if (len == 0) {
      return [];
    }
    //logger.info('^^^^^^^^^^^^^^^^^^drawEachLink----$len');
    return linkManager
        .orderMapIterator((model) => _drawEachLik(model as LinkModel, linkManager))
        .toList();
  }

  Widget _drawEachLik(LinkModel model, LinkManager linkManager) {
    const double stickerOffset = LayoutConst.stikerOffset / 2;
    double posX = (model.posX - stickerOffset) * widget.applyScale;
    double posY = (model.posY - stickerOffset) * widget.applyScale;
    //logger.info('^^^^^^^^^^^^^^^^^^drawEachLink----${model.mid}, ${posX.round()}, ${posY.round()}');
    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }
    _position = Offset(posX, posY);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: StudioVariables.isPreview || StudioVariables.isNotLinkState
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
                  if (StudioVariables.isLinkEditMode) _delButton(model, linkManager),
                ],
              ),
            ),
    );
  }

  Widget _mainButton(LinkModel model) {
    const double iconSize = 24;
    return GestureDetector(
      onTapUp: (d) {
        logger.info('button pressed ${model.mid}');
        BookMainPage.containeeNotifier!.setFrameClick(true);
        //여기서 연결된  프레임이나 페이지를 띄운다.
        //DraggableStickers.frameSelectNotifier?.set("", doNotify: true);
        return;
      },
      child: Icon(
        Icons.radio_button_checked_outlined,
        size: iconSize,
        color: _isMove ? CretaColor.primary : CretaColor.secondary,
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
}
