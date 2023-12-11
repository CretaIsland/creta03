import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../book_main_page.dart';
import '../../../studio_variables.dart';

enum PositionMode { local, global }

class DraggablePoint extends StatefulWidget {
  const DraggablePoint({
    Key? key,
    required this.child,
    required this.onComplete,
    required this.onScaleStart,
    this.onDrag,
    this.onScale,
    this.onRotate,
    //required this.onTap,
    this.mode = PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final ValueSetter<double>? onScale;
  final VoidCallback onScaleStart;
  final ValueSetter<double>? onRotate;
  //final VoidCallback? onTap;
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
    //logger.fine('DraggablePoint');
    return StudioVariables.isHandToolMode == false &&
            //StudioVariables.isNotLinkState &&
            StudioVariables.isPreview == false
        ? GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            // InkWell 보다 먼저 호출되기 때문에, 이 부분을 활용하여, frame 이 눌러졌다는 사실을 알 수 있다.
            onLongPressDown: (detail) {
              logger.fine('DraggablePoint.GestureDetector');
              //print(
              //    'DraggablePoint.GestureDetector ${BookMainPage.containeeNotifier!.selectedClass}');
              //BookMainPage.miniMenuNotifier?.set(true, doNoti: true);
              BookMainPage.containeeNotifier!.setFrameClick(true);
              //widget.onTap!();
            },
            onScaleStart: (details) {
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
                widget.onScale?.call(baseScaleFactor);
              }
              //print('DraggablePointState onScaleStart --------------------------');
              widget.onScaleStart();
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
              //print('DraggablePointState onScaleUpdate --------------------------');

              if (details.pointerCount > 1) {
                scaleFactor = baseScaleFactor * details.scale;
                widget.onScale?.call(scaleFactor);
                angle = baseAngle + details.rotation;

                logger.fine('baseAngle=$baseAngle, rotation=${details.rotation}');

                widget.onRotate?.call(angle);
              }
            },
            onScaleEnd: (details) {
              //print('DraggablePointState onScaleEnd --------------------------');

              logger.fine('onScaleEnd ${details.toString()}');
              widget.onComplete();
              mychangeStack.endTrans();
            },
            child: widget.child,
          )
        : widget.child;
  }
}
