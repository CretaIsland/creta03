import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/frame_model.dart';
import '../../../../player/creta_play_timer.dart';
import 'sticker/draggable_stickers.dart';

class OnFrameMenu extends StatefulWidget {
  final CretaPlayTimer? playTimer;
  final FrameModel model;

  const OnFrameMenu({super.key, required this.playTimer, required this.model});

  @override
  State<OnFrameMenu> createState() => _OnFrameMenuState();
}

class _OnFrameMenuState extends State<OnFrameMenu> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    final int contentsCount = widget.playTimer!.contentsManager.getShowLength();
    return MouseRegion(
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
      // onHover: ((event) {
      //   //logger.info('onHover');
      //   setState(() {
      //     _isHover = true;
      //   });
      // }),
      // child: Transform(
      //   key: GlobalObjectKey('Transform${widget.model.mid}'),
      //   alignment: Alignment.center,
      //   transform: Matrix4.identity()
      //     ..scale(1.0)
      //     ..rotateZ(CretaUtils.degreeToRadian(widget.model.angle.value)),
      child: Container(
          width: double.infinity,
          height: double.infinity,
          //color: Colors.white,
          color: _isHover ? Colors.white.withOpacity(0.75) : Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
                BTN.fill_i_s(
                    icon: widget.playTimer != null && widget.playTimer!.isPause()
                        ? Icons.play_arrow
                        : Icons.pause_outlined,
                    onPressed: () {
                      logger.info('play Button pressed');
                      setState(() {
                        widget.playTimer?.togglePause();
                      });
                    }),
              if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
                Align(
                  alignment: const Alignment(-0.5, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_previous,
                      onPressed: () async {
                        if (widget.playTimer != null &&
                            widget.playTimer!.isPrevButtonBusy == false) {
                          logger.info('prev Button pressed');
                          await widget.playTimer?.releasePause();
                          await widget.playTimer?.prev();
                          setState(() {});
                        }
                      }),
                ),
              if (_isHover && contentsCount > 0 && _isPlayAble(widget.model))
                Align(
                  alignment: const Alignment(0.5, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_next,
                      onPressed: () async {
                        if (widget.playTimer != null &&
                            widget.playTimer!.isNextButtonBusy == false) {
                          logger.info('next Button pressed');
                          await widget.playTimer?.releasePause();
                          await widget.playTimer?.next();
                          setState(() {});
                        } else {
                          logger.info('next Button is busy');
                        }
                      }),
                ),
              if (_isHover && contentsCount == 0)
                Text(
                  '${widget.model.order.value}',
                  style: CretaFont.titleELarge.copyWith(color: Colors.black),
                ),
              if (DraggableStickers.isFrontBackHover)
                Text(
                  '${widget.model.order.value} : $contentsCount',
                  style: CretaFont.titleELarge.copyWith(color: Colors.white),
                ),
              if (DraggableStickers.isFrontBackHover)
                Text(
                  '${widget.model.order.value} : $contentsCount',
                  style: CretaFont.titleLarge,
                ),
            ],
          )),
      //),
    );
  }

  bool _isPlayAble(FrameModel model) {
    if (model.frameType == FrameType.text) {
      return false;
    }
    return true;
  }
}
