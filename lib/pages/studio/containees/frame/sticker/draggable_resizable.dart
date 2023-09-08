// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math' as math;

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';

import 'package:hycop/common/util/logger.dart';
import '../../../../../design_system/creta_color.dart';
import '../../../../../model/frame_model.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';
import 'draggable_point.dart';
import 'seleted_box.dart';
//import 'floating_action_icon.dart';

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
    required this.frameModel,
    required this.pageWidth,
    required this.pageHeight,
    required this.borderWidth,
    required this.onComplete,
    required this.onScaleStart,
    //BoxConstraints? constraints,
    required this.onResizeButtonTap,
    this.onUpdate,
    //this.onTap,
    this.onLayerTapped,
    this.onEdit,
    this.onFrameDelete,
    //this.canTransform = false,
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
  final VoidCallback onScaleStart;
  //final VoidCallback? onTap;
  final VoidCallback? onFrameDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onLayerTapped;
  final void Function() onResizeButtonTap;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  //final bool canTransform;

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
  final FrameModel? frameModel;

  @override
  // ignore: library_private_types_in_public_api
  _DraggableResizableState createState() => _DraggableResizableState();
}

class _DraggableResizableState extends State<DraggableResizable> {
  late Size _size;
  late Offset _position;
  //late BoxConstraints constraints;
  late double _angle;
  // late double _angleDelta;
  // late double _baseAngle;

  bool get isTouchInputSupported => true;

  @override
  void initState() {
    logger.finest('_DraggableResizableState.initState()');
    super.initState();
    _size = widget.size;
    //constraints = const BoxConstraints.expand(width: 1, height: 1);
    _angle = widget.angle;
    _position = widget.position;
    // _baseAngle = 0;
    // _angleDelta = 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isFixedRatio = (widget.frameModel != null && widget.frameModel!.isFixedRatio.value);
    //bool isAutoFit = (widget.frameModel != null && widget.frameModel!.isAutoFit.value);
    double whRatio = (_size.height / _size.width);

    logger.info('DraggableResizable');

    return LayoutBuilder(
      builder: (context, constraints) {
        final normalizedWidth = _size.width;
        final normalizedHeight = _size.height;

        logger.fine('DraggableResize: $normalizedHeight, $normalizedWidth');

        final normalizedLeft = _position.dx;
        final normalizedTop = _position.dy;

        void onUpdate(String hint, {bool save = true}) {
          //print('onUpdate $hint--------------------------------------------------------');
          // if (hint == 'onTap') {
          //   logger.finest('onUpdate : onUpdate($hint),$save in DraggableResizable');
          //   widget.onTap?.call();
          // }

          if (save) {
            widget.onUpdate?.call(
              DragUpdate(
                position: _position,
                size: _size,
                angle: _angle,
                hint: hint,
              ),
              widget.mid,
            );
          }
        }

        void onDragBottomRight(Offset details) {
          //ok
          var newHeight = math.max(_size.height + details.dy, 0.0);
          var newWidth = math.max(_size.width + details.dx, 0.0);
          if (isFixedRatio) {
            if (details.dx.abs() > details.dy.abs()) {
              newHeight = newWidth * whRatio;
            } else {
              newWidth = newHeight / whRatio;
            }
          }

          final updatedSize = Size(newWidth, newHeight);
          // x 값은 클수록 사이즈가 커진다.
          // y 값은 클수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx, details.dy);
          if (_sizeValidCheck(updatedSize, _position, moveDirection, details) == false) return;

          setState(() {
            _size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragTopRight(Offset details) {
          //ok
          var newHeight = math.max(_size.height - details.dy, 0.0);
          var newWidth = math.max(_size.width + details.dx, 0.0);
          var updatedPosition = Offset(_position.dx, _position.dy + details.dy);

          if (isFixedRatio) {
            if (details.dx.abs() > details.dy.abs()) {
              newHeight = newWidth * whRatio;
              updatedPosition = Offset(_position.dx, _position.dy + _size.height - newHeight);
            } else {
              newWidth = newHeight / whRatio;
            }
          }

          final updatedSize = Size(newWidth, newHeight);
          // x 값은 클수록 사이즈가 커진다.
          // y 값은 작을수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx, details.dy * -1);
          if (_sizeValidCheck(updatedSize, updatedPosition, moveDirection, details) == false) {
            return;
          }

          setState(() {
            _position = updatedPosition;
            _size = updatedSize;
          });

          onUpdate('onDragTopRight');
        }

        void onDragTopLeft(Offset details) {
          //ok
          var newHeight = math.max(_size.height - details.dy, 0.0);
          var newWidth = math.max(_size.width - details.dx, 0.0);
          var updatedPosition = Offset(_position.dx + details.dx, _position.dy + details.dy);
          if (isFixedRatio) {
            if (details.dx.abs() > details.dy.abs()) {
              newHeight = newWidth * whRatio;
              updatedPosition =
                  Offset(_position.dx + details.dx, _position.dy + _size.height - newHeight);
            } else {
              newWidth = newHeight / whRatio;
              updatedPosition =
                  Offset(_position.dx + _size.width - newWidth, _position.dy + details.dy);
            }
          }
          final updatedSize = Size(newWidth, newHeight);

          // x 값은 작을수록 사이즈가 커진다.
          // y 값은 작을수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx * -1, details.dy * -1);
          if (_sizeValidCheck(updatedSize, updatedPosition, moveDirection, details) == false) {
            return;
          }

          setState(() {
            _position = updatedPosition;
            _size = updatedSize;
          });

          onUpdate('onDragTopLeft');
        }

        void onDragBottomLeft(Offset details) {
          var newHeight = math.max(_size.height + details.dy, 0.0);
          var newWidth = math.max(_size.width - details.dx, 0.0);
          var updatedPosition = Offset(_position.dx + details.dx, _position.dy);
          if (isFixedRatio) {
            if (details.dx.abs() > details.dy.abs()) {
              newHeight = newWidth * whRatio;
            } else {
              newWidth = newHeight / whRatio;
              updatedPosition = Offset(_position.dx + _size.width - newWidth, _position.dy);
            }
          }
          final updatedSize = Size(newWidth, newHeight);

          // x 값은 작을수록 사이즈가 커진다.
          // y 값은 클수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx * -1, details.dy);
          if (_sizeValidCheck(updatedSize, updatedPosition, moveDirection, details) == false) {
            return;
          }

          setState(() {
            _position = updatedPosition;
            _size = updatedSize;
          });

          onUpdate('onDragBottomLeft');
        }

        void onDragRight(Offset details) {
          var newWidth = math.max(_size.width + details.dx, 0.0);
          var newHeight = _size.height;
          if (isFixedRatio) {
            newHeight = newWidth * (_size.height / _size.width);
          }
          final updatedSize = Size(newWidth, newHeight);

          // x 값은 클수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx, details.dy);
          if (_sizeValidCheck(updatedSize, _position, moveDirection, details) == false) return;

          setState(() {
            _size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragLeft(Offset details) {
          //final newHeight = math.max(_size.height + details.dy, 0.0);
          var newWidth = math.max(_size.width - details.dx, 0.0);
          var newHeight = _size.height;
          var updatedPosition = Offset(_position.dx + details.dx, _position.dy);
          if (isFixedRatio) {
            newHeight = newWidth * (_size.height / _size.width);
          }
          final updatedSize = Size(newWidth, newHeight);

          // x 값은 작을수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx * -1, details.dy);
          if (_sizeValidCheck(updatedSize, updatedPosition, moveDirection, details) == false) {
            return;
          }

          setState(() {
            _size = updatedSize;
            _position = updatedPosition;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragDown(Offset details) {
          var newHeight = math.max(_size.height + details.dy, 0.0);
          var newWidth = _size.width;
          if (isFixedRatio) {
            newWidth = newHeight / (_size.height / _size.width);
          }
          final updatedSize = Size(newWidth, newHeight);

          // y 값은 클수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx, details.dy);
          if (_sizeValidCheck(updatedSize, _position, moveDirection, details) == false) return;

          setState(() {
            _size = updatedSize;
          });
          onUpdate('onDragBottomRight');
        }

        void onDragUp(Offset details) {
          var newHeight = math.max(_size.height - details.dy, 0.0);
          var newWidth = _size.width;
          var updatedPosition = Offset(_position.dx, _position.dy + details.dy);
          if (isFixedRatio) {
            newWidth = newHeight / (_size.height / _size.width);
          }
          final updatedSize = Size(newWidth, newHeight);

          // y 값은 작을수록 사이즈가 커진다.
          Offset moveDirection = Offset(details.dx, details.dy * -1);
          if (_sizeValidCheck(updatedSize, updatedPosition, moveDirection, details) == false) {
            return;
          }

          setState(() {
            _size = updatedSize;
            _position = updatedPosition;
          });
          onUpdate('onDragBottomRight');
        }

        final decoratedChild = Container(
          key: Key('decoratedChild2-$widget.mid}'),
          alignment: Alignment.center,
          height: normalizedHeight + LayoutConst.stikerOffset,
          width: normalizedWidth + LayoutConst.stikerOffset,
          child: SizedBox(
            height: normalizedHeight,
            width: normalizedWidth,
            child: Center(child: widget.child),
          ),
        );

        // final selectedBox = Container(
        //   key: Key('selectedBox-$widget.mid}'),
        //   alignment: Alignment.center,
        //   height: normalizedHeight + LayoutConst.stikerOffset,
        //   width: normalizedWidth + LayoutConst.stikerOffset,
        //   child: Container(
        //       height: normalizedHeight,
        //       width: normalizedWidth,
        //       decoration: BoxDecoration(
        //         border: Border.all(
        //           width: LayoutConst.selectBoxBorder,
        //           color: CretaColor.primary,
        //         ),
        //       )),
        // );

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

        logger.finest('DraggableResizable : $normalizedTop, $normalizedLeft');

        double resizePointerOffset =
            (LayoutConst.selectBoxBorder + LayoutConst.stikerOffset - LayoutConst.cornerDiameter) /
                2;

        // double heightCenter = normalizedHeight / 2 + resizePointerOffset;
        // double widthCenter = normalizedWidth / 2 + resizePointerOffset;

        Widget dragablePoint = DraggablePoint(
          //mode: PositionMode.local,
          key: Key('draggableResizable_child_draggablePoint-${widget.mid}'),
          onComplete: () {
            widget.onComplete();
          },
          onScaleStart: () {
            widget.onScaleStart();
          },
          // onTap: () {
          //   onUpdate('onTap', save: false);
          // },
          onDrag: (details) {
            Offset newPosition = Offset(_position.dx + details.dx, _position.dy + details.dy);
            if (_moveValidCheck(_size, newPosition, details) == false) {
              return;
            }
            if (StudioVariables.useMagnet) {
              newPosition = _applyMagnet(_size, newPosition, details);
            }

            setState(() {
              _position = newPosition;
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

            final midX = _position.dx + (_size.width / 2);
            final midY = _position.dy + (_size.height / 2);
            final updatedPosition = Offset(
              midX - (updatedSize.width / 2),
              midY - (updatedSize.height / 2),
            );

            setState(() {
              _size = updatedSize;
              _position = updatedPosition;
            });
            onUpdate('onScale');
          },
          onRotate: (a) {
            setState(() => _angle = a * 0.5);
            logger.finest('onRotate $a');
            //setState(() => _angle = a);
            onUpdate('onRotate');
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              decoratedChild,
              if (!StudioVariables.isPreview)
                SelectedBox(
                  key: GlobalObjectKey('SelectedBox-$widget.mid}'),
                  mid: widget.mid,
                  normalizedHeight: normalizedHeight,
                  normalizedWidth: normalizedWidth,
                  resizePointerOffset: resizePointerOffset,
                  onDragTopLeft: onDragTopLeft,
                  onDragBottomRight: onDragBottomRight,
                  onDragTopRight: onDragTopRight,
                  onDragBottomLeft: onDragBottomLeft,
                  onDragUp: onDragUp,
                  onDragRight: onDragRight,
                  onDragDown: onDragDown,
                  onDragLeft: onDragLeft,
                  onScaleStart: widget.onScaleStart,
                  onResizeButtonTap: widget.onResizeButtonTap,
                  onComplete: widget.onComplete,
                  frameModel: widget.frameModel,
                ),
              if (widget.isMain) mainSymbol,
            ],
          ),
        );

        return Stack(
          children: <Widget>[
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child:
                  // isRotate()
                  //     ? Transform(
                  //         alignment: Alignment.center,
                  //         transform: Matrix4.identity()
                  //           ..scale(1.0)
                  //           ..rotateZ(_angle),
                  //         child: dragablePoint,
                  //       )
                  //     :
                  dragablePoint,
            ),
          ],
        );
      },
    );
  }

  bool _sizeValidCheck(Size updatedSize, Offset pos, Offset moveDirection, Offset details) {
    // double offset = LayoutConst.stikerOffset / 2;

    // if (moveDirection.dx < 0) {
    //   if (updatedSize.width < LayoutConst.minFrameSize) {
    //     logger.info('mininumSize constraint  ${updatedSize.width}, ${updatedSize.height}');
    //     return false;
    //   }
    // }
    // if (moveDirection.dy < 0) {
    //   if (updatedSize.height < LayoutConst.minFrameSize) {
    //     logger.info('mininumSize constraint  ${updatedSize.width}, ${updatedSize.height}');
    //     return false;
    //   }
    // }
    // if (moveDirection.dx > 0) {
    //   if (pos.dx + updatedSize.width + offset > widget.pageWidth) {
    //     logger.info(
    //         'maxinumSize constraint  ${updatedSize.width}, ${updatedSize.height}, pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }

    // if (moveDirection.dy < 0) {
    //   if (pos.dy + updatedSize.height + offset > widget.pageHeight) {
    //     logger.info(
    //         'maxinumSize constraint  ${updatedSize.width}, ${updatedSize.height} pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    return _moveValidCheck(updatedSize, pos, details);
  }

  Offset _applyMagnet(Size updatedSize, Offset pos, Offset move) {
    double leftLimit = BookMainPage.pageOffset.dx - (LayoutConst.stikerOffset / 2);
    double rightLimit = leftLimit + widget.pageWidth;
    //print('leftLimit=$leftLimit, rightLimit=$rightLimit');
    double leftGap = pos.dx - leftLimit;
    double rightGap = rightLimit - (pos.dx + updatedSize.width);
    //print('leftGap=$leftGap,rightGap=$rightGap, ');

    double topLimit = BookMainPage.pageOffset.dy - (LayoutConst.stikerOffset / 2);
    double bottomLimit = topLimit + widget.pageHeight;
    //print('topLimit=$topLimit, bottomLimit=$bottomLimit');
    double topGap = pos.dy - topLimit;
    double bottomGap = bottomLimit - (pos.dy + updatedSize.height);
    //print('topGap=$topGap,bottomGap=$bottomGap, ');

    double dx = pos.dx;
    double dy = pos.dy;

    if (leftGap < StudioVariables.magnetMargin && leftGap > -StudioVariables.magnetMargin) {
      dx = dx - leftGap;
    } else if (rightGap < StudioVariables.magnetMargin &&
        rightGap > -StudioVariables.magnetMargin) {
      dx = dx + rightGap;
    }

    if (topGap < StudioVariables.magnetMargin && topGap > -StudioVariables.magnetMargin) {
      dy = dy - topGap;
    } else if (bottomGap < StudioVariables.magnetMargin &&
        bottomGap > -StudioVariables.magnetMargin) {
      dy = dy + bottomGap;
    }
    return Offset(dx, dy);
  }

  bool _moveValidCheck(Size updatedSize, Offset pos, Offset move) {
    // double offset = LayoutConst.stikerOffset / 2;
    // if (move.dx <= 0) {
    //   if (pos.dx + offset < 0) {
    //     logger.info('1.postion constraint  ${move.dx},pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }
    // if (move.dy <= 0) {
    //   if (pos.dy + offset < 0) {
    //     logger.info('2.postion constraint ${move.dy}, pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    // if (move.dx >= 0) {
    //   if (updatedSize.width + pos.dx + offset > widget.pageWidth) {
    //     logger.info('3.postion constraint  ${updatedSize.width},pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }
    // if (move.dy >= 0) {
    //   if (updatedSize.height + pos.dy + offset > widget.pageHeight) {
    //     logger.info('4.postion constraint ${updatedSize.height}, pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    return true;
  }

  // bool isRotate() {
  //   return (widget.frameModel != null && widget.frameModel!.shouldOutsideRotate());
  // }
}
