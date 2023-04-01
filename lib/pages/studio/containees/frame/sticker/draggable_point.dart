import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../studio_variables.dart';

enum PositionMode { local, global }

class DraggablePoint extends StatefulWidget {
  const DraggablePoint({
    Key? key,
    required this.child,
    required this.onComplete,
    this.onDrag,
    this.onScale,
    this.onRotate,
    required this.onTap,
    this.mode = PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final ValueSetter<double>? onScale;
  final ValueSetter<double>? onRotate;
  final VoidCallback? onTap;
  final VoidCallback onComplete;

  @override
  DraggablePointState createState() => DraggablePointState();
}

class DraggablePointState extends State<DraggablePoint> {
  late Offset initPoint;
  var baseScaleFactor = 1.0;
  var scaleFactor = 1.0;
  var baseAngle = 0.0;
  var angle = 0.0;

  @override
  Widget build(BuildContext context) {
    return StudioVariables.handToolMode == false
        ? GestureDetector(
            behavior: HitTestBehavior.opaque,
            onLongPressDown: (detail) {
              logger.fine('Gest2 : onLongPressDown in DraggablePoint for Extended Area');
              //
              widget.onTap!();
            },
            onScaleStart: (details) {
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
                widget.onScale?.call(baseScaleFactor);
              }
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
                widget.onScale?.call(scaleFactor);
                angle = baseAngle + details.rotation;

                logger.fine('baseAngle=$baseAngle, rotation=${details.rotation}');

                widget.onRotate?.call(angle);
              }
            },
            onScaleEnd: (details) {
              logger.fine('onScaleEnd ${details.toString()}');
              widget.onComplete();
            },
            child: widget.child,
          )
        : widget.child;
  }
}
