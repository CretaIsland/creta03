// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:hycop/common/util/logger.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../studio_constant.dart';
import 'draggable_point.dart';
import 'floating_action_icon.dart';
import 'resize_point.dart';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.angle,
    required this.position,
    required this.size,
    //required this.constraints,
    required this.hint,
  });

  /// The angle of the draggable asset.
  final double angle;

  /// The position of the draggable asset.
  final Offset position;

  /// The size of the draggable asset.
  final Size size;

  /// The constraints of the parent view.
  //final Size constraints;

  final String hint;
}

/// {@template draggable_resizable}
/// A widget which allows a user to drag and resize the provided [child].
/// {@endtemplate}
class DraggableResizable extends StatefulWidget {
  /// {@macro draggable_resizable}
  DraggableResizable({
    Key? key,
    required this.mid,
    required this.child,
    required this.size,
    required this.position,
    required this.angle,
    required this.isMain,
    required this.pageWidth,
    required this.pageHeight,
    required this.borderWidth,
    required this.onComplete,
    //BoxConstraints? constraints,
    required this.onResizeButtonTap,
    this.onUpdate,
    this.onTap,
    this.onLayerTapped,
    this.onEdit,
    this.onFrameDelete,
    this.canTransform = false,
  }) : //constraints = constraints ?? BoxConstraints.loose(Size.infinite),
        super(key: key);

  /// The child which will be draggable/resizable.
  final Widget child;

  // final VoidCallback? onTap;

  /// Drag/Resize value setter.
  //final ValueSetter<DragUpdate>? onUpdate;
  final void Function(DragUpdate value, String mid)? onUpdate;

  /// Delete callback
  final VoidCallback onComplete;
  final VoidCallback? onTap;
  final VoidCallback? onFrameDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLayerTapped;
  final void Function() onResizeButtonTap;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  /// The child's original size.
  final String mid;
  final Size size;
  final Offset position;
  final double angle;
  final double borderWidth;
  final bool isMain;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  //final BoxConstraints constraints; // not used

  final double pageWidth;
  final double pageHeight;

  @override
  // ignore: library_private_types_in_public_api
  _DraggableResizableState createState() => _DraggableResizableState();
}

class _DraggableResizableState extends State<DraggableResizable> {
  late Size size;
  late Offset position;
  //late BoxConstraints constraints;
  late double angle;
  late double angleDelta;
  late double baseAngle;

  bool get isTouchInputSupported => true;

  @override
  void initState() {
    logger.finest('_DraggableResizableState.initState()');
    super.initState();
    size = widget.size;
    //constraints = const BoxConstraints.expand(width: 1, height: 1);
    angle = widget.angle;
    position = widget.position;
    baseAngle = 0;
    angleDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final normalizedWidth = size.width;
        final normalizedHeight = size.height;

        logger.fine('DraggableResize: $normalizedHeight, $normalizedWidth');

        final normalizedLeft = position.dx;
        final normalizedTop = position.dy;

        void onUpdate(String hint, {bool save = true}) {
          if (hint == 'onTap') {
            logger.finest('onUpdate : onUpdate($hint),$save in DraggableResizable');
            widget.onTap?.call();
          }

          if (save) {
            widget.onUpdate?.call(
              DragUpdate(
                position: position,
                size: size,
                angle: angle,
                hint: hint,
              ),
              widget.mid,
            );
          }
        }

        void onDragBottomRight(Offset details) {
          final newHeight = math.max(size.height + details.dy, 0.0);
          final newWidth = math.max(size.width + details.dx, 0.0);

          final updatedSize = Size(newWidth, newHeight);
          if (_sizeValidChcheck(updatedSize, position) == false) return;

          setState(() {
            size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragTopRight(Offset details) {
          final newHeight = math.max(size.height - details.dy, 0.0);
          final newWidth = math.max(size.width + details.dx, 0.0);

          final updatedSize = Size(newWidth, newHeight);
          final updatedPosition = Offset(position.dx, position.dy + details.dy);

          if (_sizeValidChcheck(updatedSize, updatedPosition) == false) return;

          setState(() {
            position = updatedPosition;
            size = updatedSize;
          });

          onUpdate('onDragTopRight');
        }

        void onDragTopLeft(Offset details) {
          final newHeight = math.max(size.height - details.dy, 0.0);
          final newWidth = math.max(size.width - details.dx, 0.0);

          final updatedSize = Size(newWidth, newHeight);
          final updatedPosition = Offset(position.dx + details.dx, position.dy + details.dy);

          if (_sizeValidChcheck(updatedSize, updatedPosition) == false) return;

          setState(() {
            position = updatedPosition;
            size = updatedSize;
          });

          onUpdate('onDragTopLeft');
        }

        void onDragBottomLeft(Offset details) {
          final newHeight = math.max(size.height + details.dy, 0.0);
          final newWidth = math.max(size.width - details.dx, 0.0);

          final updatedSize = Size(newWidth, newHeight);
          final updatedPosition = Offset(position.dx + details.dx, position.dy);

          if (_sizeValidChcheck(updatedSize, updatedPosition) == false) return;

          setState(() {
            position = updatedPosition;
            size = updatedSize;
          });

          onUpdate('onDragBottomLeft');
        }

        void onDragRight(Offset details) {
          //final newHeight = math.max(size.height + details.dy, 0.0);
          final newWidth = math.max(size.width + details.dx, 0.0);

          final updatedSize = Size(newWidth, size.height);

          if (_sizeValidChcheck(updatedSize, position) == false) return;

          setState(() {
            size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragLeft(Offset details) {
          //final newHeight = math.max(size.height + details.dy, 0.0);
          final newWidth = math.max(size.width - details.dx, 0.0);

          final updatedSize = Size(newWidth, size.height);
          final updatedPosition = Offset(position.dx + details.dx, position.dy);

          if (_sizeValidChcheck(updatedSize, updatedPosition) == false) return;

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragDown(Offset details) {
          final newHeight = math.max(size.height + details.dy, 0.0);
          //final newWidth = math.max(size.width + details.dx, 0.0);

          final updatedSize = Size(size.width, newHeight);

          if (_sizeValidChcheck(updatedSize, position) == false) return;

          setState(() {
            size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragUp(Offset details) {
          final newHeight = math.max(size.height - details.dy, 0.0);
          //final newWidth = math.max(size.width - details.dx, 0.0);

          final updatedSize = Size(size.width, newHeight);
          final updatedPosition = Offset(position.dx, position.dy + details.dy);

          if (_sizeValidChcheck(updatedSize, updatedPosition) == false) return;

          setState(() {
            size = updatedSize;
            position = updatedPosition;
          });
          onUpdate('onDragBottomRight');
        }

        final decoratedChild = Container(
          // skpark 확장된 박스임...
          key: const Key('draggableResizable_child_container'),
          alignment: Alignment.center,
          height: normalizedHeight + LayoutConst.stikerOffset,
          width: normalizedWidth + LayoutConst.stikerOffset,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.red),
          ),
          child: Container(
            height: normalizedHeight,
            width: normalizedWidth,
            decoration: BoxDecoration(
              border: Border.all(
                width: LayoutConst.selectBoxBorder,
                color: widget.canTransform ? CretaColor.primary : Colors.transparent,
              ),
            ),
            child: Center(child: widget.child),
          ),
        );

        final mainSymbol = Positioned(
          left: LayoutConst.stikerOffset / 2 + 4,
          top: LayoutConst.stikerOffset / 2 + 4,
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.5),
              //radius: 16,
              child: Icon(
                Icons.auto_stories_outlined,
                size: 16,
                color: CretaColor.primary,
              ),
            ),
          ),
        );

        final topLeftCorner = ResizePoint(
          key: const Key('draggableResizable_topLeft_resizePoint'),
          type: ResizePointType.topLeft,
          onDrag: onDragTopLeft,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final bottomRightCorner = ResizePoint(
          key: const Key('draggableResizable_bottomRight_resizePoint'),
          type: ResizePointType.bottomRight,
          onDrag: onDragBottomRight,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final topRightCorner = ResizePoint(
          key: const Key('draggableResizable_topRight_resizePoint'),
          type: ResizePointType.topRight,
          onDrag: onDragTopRight,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final bottomLeftCorner = ResizePoint(
          key: const Key('draggableResizable_bottomLeft_resizePoint'),
          type: ResizePointType.bottomLeft,
          onDrag: onDragBottomLeft,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final upPlane = ResizePoint(
          key: const Key('draggableResizable_upPlane_resizePoint'),
          type: ResizePointType.up,
          onDrag: onDragUp,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final rightPlane = ResizePoint(
          key: const Key('draggableResizable_rightPlane_resizePoint'),
          type: ResizePointType.right,
          onDrag: onDragRight,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final downPlane = ResizePoint(
          key: const Key('draggableResizable_downPlane_resizePoint'),
          type: ResizePointType.down,
          onDrag: onDragDown,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final leftPlane = ResizePoint(
          key: const Key('draggableResizable_leftPlane_resizePoint'),
          type: ResizePointType.left,
          onDrag: onDragLeft,
          onTap: widget.onResizeButtonTap,
          //iconData: Icons.zoom_out_map,
          onComplete: widget.onComplete,
        );

        final center = Offset(
          -((normalizedWidth +
                  FloatingActionIcon.floatingActionDiameter +
                  LayoutConst.stikerOffset) /
              2),
          (normalizedHeight +
                  FloatingActionIcon.floatingActionDiameter +
                  LayoutConst.stikerOffset) /
              2,
        );

        final rotateAnchor = GestureDetector(
          behavior: HitTestBehavior.translucent,
          key: const Key('draggableResizable_rotate_gestureDetector'),
          onScaleStart: (details) {
            logger.finest('draggableResizable_rotate_gestureDetector.onScaleStart');
            final offsetFromCenter = details.localFocalPoint - center;
            setState(() {
              angleDelta = baseAngle -
                  offsetFromCenter.direction -
                  FloatingActionIcon.floatingActionDiameter;
            });
          },
          onScaleUpdate: (details) {
            logger.finest('draggableResizable_rotate_gestureDetector.onScaleUpdate');
            final offsetFromCenter = details.localFocalPoint - center;
            setState(
              () {
                //angle = offsetFromCenter.direction + angleDelta * 0.5;
                angle = offsetFromCenter.direction + angleDelta;
                logger.finest('org :$angle:$angleDelta,');
                double degree = angle * 180 / pi % -360;
                angle = degree * pi / 180;
              },
            );
            onUpdate('onScaleUpdate');
          },
          onScaleEnd: (_) => setState(() {
            logger.finest('onScaleEnd $angle');
            baseAngle = angle;
            widget.onComplete();
          }),
          child: FloatingActionIcon(
            key: const Key('draggableResizable_rotate_floatingActionIcon'),
            iconData: Icons.rotate_90_degrees_ccw,
            onTap: () {},
          ),
        );

        logger.finest('DraggableResizable : $normalizedTop, $normalizedLeft');

        double resizePointerOffset =
            (LayoutConst.selectBoxBorder + LayoutConst.stikerOffset - LayoutConst.cornerDiameter) /
                2;

        double heightCenter = normalizedHeight / 2 + resizePointerOffset;
        double widthCenter = normalizedWidth / 2 + resizePointerOffset;

        return Stack(
          children: <Widget>[
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(1.0)
                  ..rotateZ(angle),
                child: DraggablePoint(
                  //mode: PositionMode.local,
                  key: const Key('draggableResizable_child_draggablePoint'),
                  onComplete: () {
                    widget.onComplete();
                  },
                  onTap: () {
                    onUpdate('onTap', save: false);
                  },
                  onDrag: (d) {
                    Offset newPosition = Offset(position.dx + d.dx, position.dy + d.dy);
                    if (_sizeValidChcheck(widget.size, newPosition) == false) {
                      return;
                    }
                    setState(() {
                      position = newPosition;
                    });
                    onUpdate('onDrag');
                  },
                  onScale: (s) {
                    logger.fine('onScale($s)');
                    final updatedSize = Size(
                      widget.size.width * s,
                      widget.size.height * s,
                    );

                    //if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

                    final midX = position.dx + (size.width / 2);
                    final midY = position.dy + (size.height / 2);
                    final updatedPosition = Offset(
                      midX - (updatedSize.width / 2),
                      midY - (updatedSize.height / 2),
                    );

                    setState(() {
                      size = updatedSize;
                      position = updatedPosition;
                    });
                    onUpdate('onScale');
                  },
                  onRotate: (a) {
                    setState(() => angle = a * 0.5);
                    logger.finest('onRotate $a');
                    //setState(() => angle = a);
                    onUpdate('onRotate');
                  },
                  child: Stack(
                    children: [
                      decoratedChild,
                      if (widget.isMain) mainSymbol,
                      if (widget.canTransform && isTouchInputSupported) ...[
                        Positioned(
                          // upPlane
                          left: widthCenter,
                          child: rotateAnchor,
                        ),
                        Positioned(
                          //topLeft
                          top: resizePointerOffset,
                          left: resizePointerOffset,
                          child: topLeftCorner,
                        ),
                        Positioned(
                          // bottomLeft
                          bottom: resizePointerOffset,
                          left: resizePointerOffset,
                          child: bottomLeftCorner,
                        ),
                        Positioned(
                          //bottomRight
                          bottom: resizePointerOffset,
                          right: resizePointerOffset,
                          child: bottomRightCorner,
                        ),
                        Positioned(
                          // topRight
                          top: resizePointerOffset,
                          right: resizePointerOffset,
                          child: topRightCorner,
                        ),

                        // centerButtons !!!

                        Positioned(
                          //topMidle
                          top: resizePointerOffset,
                          left: widthCenter,
                          child: upPlane,
                        ),
                        Positioned(
                          // leftMiddle
                          top: heightCenter,
                          left: resizePointerOffset,
                          child: leftPlane,
                        ),
                        Positioned(
                          //bottomMiddle
                          bottom: resizePointerOffset,
                          left: widthCenter,
                          child: downPlane,
                        ),
                        Positioned(
                          // rightMiddle
                          top: heightCenter,
                          right: resizePointerOffset,
                          child: rightPlane,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _sizeValidChcheck(Size size, Offset pos) {
    double offset = LayoutConst.stikerOffset / 2;

    if (size.width < LayoutConst.minFrameSize) {
      logger.fine('mininumSize constraint');
      return false;
    }
    if (size.height < LayoutConst.minFrameSize) {
      logger.fine('mininumSize constraint');
      return false;
    }
    if (pos.dx + offset < 0) {
      logger.fine('postion constraint  pos.dx=${pos.dx}, offset=$offset');
      return false;
    }
    if (pos.dy + offset < 0) {
      logger.fine('postion constraint pos.dy=${pos.dy}, offset=$offset');
      return false;
    }

    if (pos.dx + size.width + offset > widget.pageWidth) {
      logger.fine('maxinumSize constraint');
      return false;
    }
    if (pos.dy + size.height + offset > widget.pageHeight) {
      logger.fine('maxinumSize constraint');
      return false;
    }

    return true;
  }
}
