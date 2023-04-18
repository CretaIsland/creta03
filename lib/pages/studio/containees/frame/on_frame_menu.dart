import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../model/frame_model.dart';
import '../../../../player/player_handler.dart';
import 'sticker/draggable_stickers.dart';

class OnFrameMenu extends StatefulWidget {
  final PlayerHandler? playerHandler;
  final FrameModel model;

  const OnFrameMenu({super.key, required this.playerHandler, required this.model});

  @override
  State<OnFrameMenu> createState() => _OnFrameMenuState();
}

class _OnFrameMenuState extends State<OnFrameMenu> {
  bool _isHover = false;
  @override
  Widget build(BuildContext context) {
    final int contentsCount = widget.playerHandler!.getAvailLength();
    return MouseRegion(
      onEnter: ((event) {
        //logger.info('onEnter');
        setState(() {
          _isHover = true;
        });
      }),
      onExit: ((event) {
        //logger.info('onExit');
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
      child: Container(
          width: double.infinity,
          height: double.infinity,
          color: _isHover ? Colors.white.withOpacity(0.25) : Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (_isHover && contentsCount > 0)
                BTN.fill_i_s(
                    icon: widget.playerHandler != null && widget.playerHandler!.isPause()
                        ? Icons.play_arrow
                        : Icons.pause_outlined,
                    onPressed: () {
                      logger.info('play Button pressed');
                      setState(() {
                        widget.playerHandler?.toggleIsPause();
                      });
                    }),
              if (_isHover && contentsCount > 1)
                Align(
                  alignment: const Alignment(-0.5, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_previous,
                      onPressed: () async {
                        if (widget.playerHandler != null &&
                            widget.playerHandler!.isPrevButtonBusy() == false) {
                          logger.info('prev Button pressed');
                          await widget.playerHandler?.prev();
                        }
                      }),
                ),
              if (_isHover && contentsCount > 1)
                Align(
                  alignment: const Alignment(0.5, 0),
                  child: BTN.fill_i_s(
                      icon: Icons.skip_next,
                      onPressed: () async {
                        if (widget.playerHandler != null &&
                            widget.playerHandler!.isNextButtonBusy() == false) {
                          logger.info('next Button pressed');
                          await widget.playerHandler?.next();
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
    );
  }
}
