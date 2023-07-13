import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../studio_variables.dart';
import 'draggable_point.dart';

//enum PositionMode { local, global }

class ResizePointDraggable extends StatefulWidget {
  const ResizePointDraggable({
    Key? key,
    required this.child,
    required this.onComplete,
    this.onDrag,
    this.onScaleUpdate,
    required this.onScaleStart,
    this.onRotate,
    required this.onTap,
    this.mode = PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final VoidCallback onScaleStart;
  final ValueSetter<double>? onScaleUpdate;
  final ValueSetter<double>? onRotate;
  final VoidCallback? onTap;
  final VoidCallback onComplete;

  @override
  ResizePointDraggableState createState() => ResizePointDraggableState();
}

class ResizePointDraggableState extends State<ResizePointDraggable> {
  late Offset initPoint;
  var baseScaleFactor = 1.0;
  var scaleFactor = 1.0;
  var baseAngle = 0.0;
  var angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return StudioVariables.isHandToolMode == false //&& StudioVariables.isNotLinkState
        ? GestureDetector(
            // onLongPressDown: (detail) {
            //   logger.fine('Gest2 : onLongPressDown in ResizePointDraggable for Extended Area');
            //   //
            //   widget.onTap!();
            // },
            // onHorizontalDragStart: (details) {
            //   logger.fine('Gest2 : onHorizontalDragStart');
            //   initPoint = details.localPosition;
            // },
            // onHorizontalDragUpdate: (details) {
            //   logger.fine('Gest2 : onHorizontalDragUpdate');
            //   final dx = details.localPosition.dx - initPoint.dx;
            //   final dy = details.localPosition.dy - initPoint.dy;
            //   initPoint = details.localPosition;
            //   widget.onDrag?.call(Offset(dx, dy));
            // },
            // onHorizontalDragEnd: (details) {
            //   logger.fine('Gest2 : onHorizontalDragEnd');
            //   widget.onComplete();
            // },
            // onVerticalDragStart: (details) {
            //   logger.fine('Gest2 : onVerticalDragStart');
            //   initPoint = details.localPosition;
            // },
            // onVerticalDragUpdate: (details) {
            //   logger.fine('Gest2 : onVerticalDragUpdate');
            //   final dx = details.localPosition.dx - initPoint.dx;
            //   final dy = details.localPosition.dy - initPoint.dy;
            //   initPoint = details.localPosition;
            //   widget.onDrag?.call(Offset(dx, dy));
            // },
            // onVerticalDragEnd: (details) {
            //   logger.fine('Gest2 : onHorizontalDragEnd');
            //   widget.onComplete();
            // },
            onScaleStart: (details) {
              //print('ResizePointDraggableState onScaleStart --------------------------');

              mychangeStack.startTrans();
              switch (widget.mode) {
                case PositionMode.global:
                  initPoint = details.focalPoint;
                  break;
                case PositionMode.local:
                  logger.fine('Gest2 : onScaleStart');
                  initPoint = details.localFocalPoint;
                  break;
              }
              if (details.pointerCount > 1) {
                // 멀티 터치인 경우인것 같음.
                baseAngle = angle;
                logger.finest('baseAngle=$baseAngle}');
                baseScaleFactor = scaleFactor;
                widget.onRotate?.call(baseAngle);
                widget.onScaleUpdate?.call(baseScaleFactor);
              }
              widget.onScaleStart.call();
            },
            onScaleUpdate: (details) {
              switch (widget.mode) {
                case PositionMode.global:
                  final dx = details.focalPoint.dx - initPoint.dx;
                  final dy = details.focalPoint.dy - initPoint.dy;
                  initPoint = details.focalPoint;
                  widget.onDrag?.call(Offset(dx, dy));
                  break;
                case PositionMode.local:
                  logger.fine('Gest2 : onSateUpdate');
                  final dx = details.localFocalPoint.dx - initPoint.dx;
                  final dy = details.localFocalPoint.dy - initPoint.dy;
                  initPoint = details.localFocalPoint;
                  widget.onDrag?.call(Offset(dx, dy));
                  break;
              }
              if (details.pointerCount > 1) {
                scaleFactor = baseScaleFactor * details.scale;
                widget.onScaleUpdate?.call(scaleFactor);
                angle = baseAngle + details.rotation;

                logger.fine('baseAngle=$baseAngle, rotation=${details.rotation}');

                widget.onRotate?.call(angle);
              }
            },
            onScaleEnd: (details) {
              logger.fine('onScaleEnd ${details.toString()}');
              widget.onComplete();
              mychangeStack.endTrans();
            },
            child: widget.child,
          )
        : widget.child;
  }
}
