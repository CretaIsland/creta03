import 'package:flutter/material.dart';
//import 'package:hycop/common/util/logger.dart';

//import '../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';
//import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../studio_variables.dart';
import 'sticker/draggable_stickers.dart';

class OnFrameMenu extends StatefulWidget {
  final CretaPlayTimer? playTimer;
  final FrameModel model;
  final int orderIndex;

  const OnFrameMenu(
      {super.key, required this.playTimer, required this.orderIndex, required this.model});

  @override
  State<OnFrameMenu> createState() => _OnFrameMenuState();
}

class _OnFrameMenuState extends State<OnFrameMenu> {
  //bool _isHover = false;

  @override
  void didUpdateWidget(OnFrameMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.orderIndex != widget.orderIndex) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StudioVariables.isHandToolMode == false
        ? _buttonArea()
        // ? MouseRegion(
        //     onEnter: ((event) {
        //       setState(() {
        //         _isHover = true;
        //       });
        //     }),
        //     onExit: ((event) {
        //       setState(() {
        //         _isHover = false;
        //       });
        //     }),
        //     child: _buttonArea(),
        //     //),
        //   )
        : const SizedBox.shrink();
  }

  Widget _buttonArea() {
    //final int contentsCount = widget.playTimer!.contentsManager.getShowLength();

    return Container(
        width: double.infinity,
        height: double.infinity,
        //color: Colors.white,
        //color: _isHover ? Colors.white.withOpacity(0.15) : Colors.transparent,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
            //   BTN.fill_i_s(
            //       icon: widget.playTimer != null && widget.playTimer!.isPause()
            //           ? Icons.play_arrow
            //           : Icons.pause_outlined,
            //       onPressed: () {
            //         logger.fine('play Button pressed');
            //         setState(() {
            //           widget.playTimer?.togglePause();
            //         });
            //       }),
            // if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
            //   Align(
            //     alignment: const Alignment(-0.5, 0),
            //     child: BTN.fill_i_s(
            //         icon: Icons.skip_previous,
            //         onPressed: () async {
            //           if (widget.playTimer != null && widget.playTimer!.isPrevButtonBusy == false) {
            //             logger.fine('prev Button pressed');
            //             await widget.playTimer?.releasePause();
            //             await widget.playTimer?.prev();
            //             setState(() {});
            //           }
            //         }),
            //   ),
            // if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
            //   Align(
            //     alignment: const Alignment(0.5, 0),
            //     child: BTN.fill_i_s(
            //         icon: Icons.skip_next,
            //         onPressed: () async {
            //           if (widget.playTimer != null && widget.playTimer!.isNextButtonBusy == false) {
            //             logger.fine('next Button pressed');
            //             await widget.playTimer?.releasePause();
            //             await widget.playTimer?.next();
            //             setState(() {});
            //           } else {
            //             logger.fine('next Button is busy');
            //           }
            //         }),
            //   ),
            // if (contentsCount == 0)
            //   Text(
            //     '${widget.model.order.value}',
            //     style: CretaFont.titleELarge.copyWith(color: Colors.black),
            //   ),

            // _drawOrder, DrawOrder drawOrder
            if (DraggableStickers.isFrontBackHover)
              Text(
                '${widget.orderIndex}',
                //'${widget.model.order.value}',
                //'${widget.model.order.value} : $contentsCount',
                style: CretaFont.titleELarge.copyWith(color: Colors.white),
              ),
            if (DraggableStickers.isFrontBackHover)
              Text(
                '${widget.orderIndex}',
                //'${widget.model.order.value}',
                //'${widget.model.order.value} : $contentsCount',
                style: CretaFont.titleLarge,
              ),
          ],
        ));
  }

  // bool _isPlayAble(FrameModel model) {
  //   if (model.frameType == FrameType.text) {
  //     return false;
  //   }
  //   return true;
  // }
}
