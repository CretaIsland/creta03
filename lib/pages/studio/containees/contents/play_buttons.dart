import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
// ignore: depend_on_referenced_packages

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../../player/creta_play_timer.dart';
import '../../book_main_page.dart';

class PlayButton extends StatefulWidget {
  final double applyScale;
  final CretaPlayTimer playTimer;
  final FrameModel frameModel;
  final bool canMove;
  const PlayButton({
    super.key,
    required this.applyScale,
    required this.playTimer,
    required this.frameModel,
    this.canMove = true,
  });

  @override
  State<PlayButton> createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> {
  bool _isMove = false;
  Offset _position = Offset.zero;
  Offset _prev = Offset.zero;
  late double _width;
  final double _height = 28;

  @override
  void initState() {
    super.initState();

    //logger.fine('PlayButton initState');

    _width = widget.frameModel.width.value / 2 * widget.applyScale;
    if (_width < 28 * 3) {
      _width = 28 * 3;
    }

    const double stickerOffset = 0;
    //LayoutConst.stikerOffset;
    double posX = (widget.frameModel.width.value - stickerOffset) / 2 * widget.applyScale;
    double posY = (widget.frameModel.height.value - stickerOffset) / 2 * widget.applyScale;

    posX -= _width / 2;
    posY -= _height / 2;

    _position = Offset(posX, posY);
  }

  @override
  Widget build(BuildContext context) {
    return widget.canMove
        ? Positioned(
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
                  _position = Offset(_position.dx + dx, _position.dy + dy);
                });
              },
              onScaleEnd: (details) {
                setState(() {
                  _isMove = false;
                });
              },
              child: _buttons(),
            ),
          )
        : _buttons();
  }

  Widget _buttons() {
    return SizedBox(
      width: _width,
      height: _height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BTN.fill_i_s(
              useTapUp: true,
              icon: Icons.skip_previous,
              onPressed: () async {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                if (widget.playTimer.isPrevButtonBusy == false) {
                  logger.fine('prev Button pressed');
                  await widget.playTimer.releasePause();
                  await widget.playTimer.prev();
                  setState(() {
                    StudioVariables.stopNextContents = false;
                  });
                }
              }),
          BTN.fill_i_s(
              useTapUp: true,
              icon: widget.playTimer.isPause() ? Icons.play_arrow : Icons.pause_outlined,
              onPressed: () {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                logger.fine('play Button pressed');
                setState(() {
                  StudioVariables.stopNextContents = false;
                  widget.playTimer.togglePause();
                });
              }),
          BTN.fill_i_s(
              useTapUp: true,
              icon: Icons.skip_next,
              onPressed: () async {
                BookMainPage.containeeNotifier!.setFrameClick(true);
                if (widget.playTimer.isNextButtonBusy == false) {
                  logger.fine('next Button pressed');
                  await widget.playTimer.releasePause();
                  await widget.playTimer.next();
                  setState(() {
                    StudioVariables.stopNextContents = false;
                  });
                } else {
                  logger.fine('next Button is busy');
                }
              }),
        ],
      ),
    );
  }
}
