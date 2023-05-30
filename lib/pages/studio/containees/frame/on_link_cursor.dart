import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../model/frame_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';

class OnLinkCursor extends StatefulWidget {
  final Offset pageOffset;
  final Offset frameOffset;
  final FrameManager frameManager;
  final FrameModel model;
  final double applyScale;
  const OnLinkCursor({
    super.key,
    required this.pageOffset,
    required this.frameOffset,
    required this.frameManager,
    required this.model,
    required this.applyScale,
  });

  @override
  State<OnLinkCursor> createState() => _OnLinkCursorState();
}

class _OnLinkCursorState extends State<OnLinkCursor> {
  OffsetEventController? _linkReceiveEvent;

  @override
  void initState() {
    super.initState();

    final OffsetEventController linkReceiveEvent = Get.find(tag: 'cross-scrollbar-to-page-main');
    _linkReceiveEvent = linkReceiveEvent;
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = Offset.zero;
    return StreamBuilder<Offset>(
        stream: _linkReceiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data is Offset) {
            offset = snapshot.data!;
          }
          //logger.info('_drawLinkCursor ($offset)');
          if (StudioVariables.isLinkMode == false || offset == Offset.zero) {
            return const SizedBox.shrink();
          }
          return _drawLinkCursor(offset);
        });
  }

  Widget _drawLinkCursor(Offset position) {
    const double iconSize = 24;

    //logger.info('_drawLinkCursor (${widget.pageOffset})');
    if (widget.pageOffset == Offset.zero || position == Offset.zero) {
      return const SizedBox.shrink();
    }

    // double posX = offset.dx - iconSize / 2;
    // double posY = offset.dy - iconSize / 2;
    double posX = position.dx - iconSize / 2 - widget.pageOffset.dx - widget.frameOffset.dx;
    double posY = position.dy - iconSize / 2 - widget.pageOffset.dy - widget.frameOffset.dy;

    //logger.info('_drawLinkCursor ($posX, $posY)');

    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onLongPressDown: (details) {
          logger.info(
              'linkCursor clicked here ${details.globalPosition.dx}, ${details.globalPosition.dy}');

          double dataX = posX / widget.applyScale + LayoutConst.stikerOffset / 2;
          double dataY = posY / widget.applyScale + LayoutConst.stikerOffset / 2;

          StudioVariables.isLinkMode = false;
          BookMainPage.bookManagerHolder!.notify();
          widget.frameManager.createLink(frameId: widget.model.mid, posX: dataX, posY: dataY);
        },
        child: const Icon(
          Icons.radio_button_checked_outlined,
          size: iconSize,
          color: CretaColor.primary,
        ),
      ),
    );
  }
}
