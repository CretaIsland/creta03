import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../data_io/link_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';

class OnLinkCursor extends StatefulWidget {
  //final Offset pageOffset;
  final Offset frameOffset;
  final FrameManager frameManager;
  final FrameModel frameModel;
  final ContentsManager contentsManager;
  final double applyScale;
  const OnLinkCursor({
    super.key,
    //required this.pageOffset,
    required this.frameOffset,
    required this.frameManager,
    required this.frameModel,
    required this.contentsManager,
    required this.applyScale,
  });

  @override
  State<OnLinkCursor> createState() => _OnLinkCursorState();
}

class _OnLinkCursorState extends State<OnLinkCursor> {
  OffsetEventController? _linkReceiveEvent;
  OffsetEventController? _linkSendEvent;
  BoolEventController? _linkSendEvent2;

  @override
  void initState() {
    super.initState();

    final OffsetEventController linkReceiveEvent = Get.find(tag: 'frame-each-to-on-link');
    _linkReceiveEvent = linkReceiveEvent;
    final OffsetEventController linkSendEvent = Get.find(tag: 'on-link-to-link-widget');
    _linkSendEvent = linkSendEvent;
    final BoolEventController linkSendEvent2 = Get.find(tag: 'link-widget-to-property');
    _linkSendEvent2 = linkSendEvent2;
  }

  @override
  Widget build(BuildContext context) {
    Offset offset = Offset.zero;
    return StreamBuilder<Offset>(
        stream: _linkReceiveEvent!.eventStream.stream,
        builder: (context, snapshot) {
          //logger.fine('_drawLinkCursor1 ($offset)');
          if (snapshot.data != null && snapshot.data is Offset) {
            offset = snapshot.data!;
          }
          //logger.fine('cursor postion ($offset)');
          if (offset == Offset.zero) {
            return const SizedBox.shrink();
          }
          return _drawLinkCursor(offset);
        });
  }

  Widget _drawLinkCursor(Offset position) {
    const double iconSize = 24;

    //logger.fine('_drawLinkCursor (${widget.pageOffset})');
    // if (widget.pageOffset == Offset.zero || position == Offset.zero) {
    //   return const SizedBox.shrink();
    // }

    // double posX = offset.dx - iconSize / 2;
    // double posY = offset.dy - iconSize / 2;
    //logger.fine("pageOffset.dx=${widget.pageOffset.dx}, frameOffset.dx=${widget.frameOffset.dx}");

    // double posX = position.dx -
    //     iconSize / 2 -
    //     widget.pageOffset.dx -
    //     widget.frameOffset.dx +
    //     BookMainPage.horizontalScrollOffset;
    // double posY = position.dy -
    //     iconSize / 2 -
    //     widget.pageOffset.dy -
    //     widget.frameOffset.dy +
    //     BookMainPage.verticalScrollOffset;

    double posX = position.dx - iconSize / 2;
    double posY = position.dy - iconSize / 2;

    logger.fine('_drawLinkCursor ($posX, $posY)');

    if (posX < 0 || posY < 0) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: posX,
      top: posY,
      child: GestureDetector(
        onLongPressDown: (details) async {
          logger.fine(
              'linkCursor clicked here ${details.globalPosition.dx}, ${details.globalPosition.dy}');

          ContentsModel? contentsModel = widget.contentsManager.getCurrentModel();
          if (contentsModel == null) {
            return;
          }

          double dataX = posX / widget.applyScale + LayoutConst.stikerOffset / 2;
          double dataY = posY / widget.applyScale + LayoutConst.stikerOffset / 2;

          LinkParams.isLinkNewMode = false;
          //StudioVariables.isLinkEditMode = true;
          logger.fine(
              'OnLinkCursor linkNew=${LinkParams.isLinkNewMode}, linkEdit=${contentsModel.isLinkEditMode}');
          BookMainPage.bookManagerHolder!.notify();

          // widget.contentsManager
          //     .createLink(
          //   contentsId: contentsModel.mid,
          //   posX: dataX,
          //   posY: dataY,
          //   doNotify: false,
          //   connectedMid: LinkParams.connectedMid,
          //   connectedClass: LinkParams.connectedClass,
          // )
          //     .then((value) {
          //   FrameModel? connectedFrame =
          //       widget.frameManager.getModel(LinkParams.connectedMid) as FrameModel?;
          //   if (connectedFrame != null) {
          //     //mychangeStack.startTrans();
          //     connectedFrame.isShow.set(false);
          //     //mychangeStack.endTrans();
          //     widget.frameManager.notify();
          //   }
          //   //contentsModel.isLinkEditMode = true;
          //   //contentsModel.isLinkEditMode = false;
          //   _linkSendEvent2!.sendEvent(contentsModel.isLinkEditMode);
          //   _linkSendEvent!.sendEvent(Offset(posX, posY));
          //   LinkParams.connectedClass = '';
          //   LinkParams.connectedMid = '';

          //   return value;
          // });
          LinkManager linkManager = widget.contentsManager.newLinkManager(contentsModel.mid);

          await linkManager.createNextLink(
            contentsModel: contentsModel,
            posX: dataX,
            posY: dataY,
            doNotify: false,
            name: LinkParams.connectedName,
            connectedMid: LinkParams.connectedMid,
            connectedClass: LinkParams.connectedClass,
            onComplete: _showTargetFrame,
          );
        },
        child: const Icon(
          Icons.radio_button_checked_outlined,
          size: iconSize,
          color: CretaColor.primary,
        ),
      ),
    );
  }

  void _showTargetFrame(bool show, ContentsModel contentsModel, Offset offset) {
    FrameModel? connectedFrame =
        widget.frameManager.getModel(LinkParams.connectedMid) as FrameModel?;
    if (connectedFrame != null) {
      //mychangeStack.startTrans();
      connectedFrame.isShow.set(false);
      //mychangeStack.endTrans();
      widget.frameManager.notify();
    }
    //contentsModel.isLinkEditMode = true;
    //contentsModel.isLinkEditMode = false;
    _linkSendEvent2!.sendEvent(contentsModel.isLinkEditMode);
    _linkSendEvent!.sendEvent(offset);
    LinkParams.connectedClass = '';
    LinkParams.connectedMid = '';
    LinkParams.connectedName = '';
  }
}
