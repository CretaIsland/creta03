import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/link_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/link_model.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../frame/sticker/draggable_stickers.dart';

class LinkWidget extends StatefulWidget {
  final double applyScale;
  final ContentsManager contentsManager;
  final ContentsModel contentsModel;
  const LinkWidget({
    super.key,
    required this.applyScale,
    required this.contentsManager,
    required this.contentsModel,
  });

  @override
  State<LinkWidget> createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {
  LinkManager? _linkManager;
  OffsetEventController? _linkReceiveEvent;
  bool _isMove = false;
  Offset _position = Offset.zero;
  Offset _prev = Offset.zero;

  @override
  void initState() {
    super.initState();
    _linkManager = widget.contentsManager.findLinkManager(widget.contentsModel.mid);
    final OffsetEventController linkReceiveEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkReceiveEvent = linkReceiveEvent;
  }

  @override
  Widget build(BuildContext context) {
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
            logger.info('_linkReceiveEvent ($_position)');
            return Consumer<LinkManager>(builder: (context, linkManager, child) {
              // LinkManager? linkManager =
              //     widget.contentsManager.findLinkManager(widget.contentsModel.mid);
              // if (linkManager == null) {
              //   return const SizedBox.shrink();
              // }
              return Stack(
                alignment: Alignment.center,
                children: [
                  ..._drawLinkCursor(linkManager),
                ],
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
    logger.info('^^^^^^^^^^^^^^^^^^drawEachLink----$len');
    return linkManager
        .orderMapIterator((model) => _drawEachLik(model as LinkModel, linkManager))
        .toList();
  }

  Widget _drawEachLik(LinkModel model, LinkManager linkManager) {
    const double stickerOffset = LayoutConst.stikerOffset / 2;
    double posX = (model.posX - stickerOffset) * widget.applyScale;
    double posY = (model.posY - stickerOffset) * widget.applyScale;
    logger.info('^^^^^^^^^^^^^^^^^^drawEachLink----${model.mid}, ${posX.round()}, ${posY.round()}');
    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }
    _position = Offset(posX, posY);

    return Positioned(
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
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
        child: StudioVariables.isAutoPlay == true || StudioVariables.isPreview == true
            ? _mainButton(model)
            : Stack(
                //alignment: Alignment.bottomRight,
                children: [
                  _mainButton(model),
                  _delButton(model, linkManager),
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
        if (StudioVariables.isAutoPlay == true) {
          // 플레이모드에서는 연결된  프레임이나 페이지를 띄운다.
          return;
        }
        // 플레이모드가 아닐때는 열결할 프레임과 페이지의목록을 보여준다.

        StudioVariables.isLinkSelectMode = !StudioVariables.isLinkSelectMode;
        if (StudioVariables.isLinkSelectMode == true) {
          showSnackBar(context, CretaStudioLang.linkIntro);
        }
        DraggableStickers.frameSelectNotifier?.set("", doNotify: true);
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
}
