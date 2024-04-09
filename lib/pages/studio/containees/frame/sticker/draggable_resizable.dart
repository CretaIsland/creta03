// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'dart:math' as math;

import 'package:creta03/pages/studio/studio_variables.dart';
import 'package:flutter/material.dart';

import 'package:hycop/common/util/logger.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../../../data_io/key_handler.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import '../../../book_main_page.dart';
import '../../../studio_constant.dart';
import 'draggable_point.dart';
import 'main_symbol.dart';
import 'seleted_box.dart';
import 'stickerview.dart';
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
    required this.sticker,
    // required this.mid,
    // required this.pageMid,
    // required this.angle,
    // required this.isMain,
    // required this.borderWidth,
    // required this.frameSize,
    required this.realPosition,
    required this.frameModel,
    required this.pageWidth,
    required this.pageHeight,
    required this.onComplete,
    required this.onScaleStart,
    //BoxConstraints? constraints,
    this.onResizeButtonTap,
    required this.child,
    this.onUpdate,
    //this.onTap,
    this.onLayerTapped,
    this.onEdit,
    this.onFrameDelete,
    this.isResiable = true,
    this.isVerticalResiable = true,
    this.isHorizontalResiable = true,
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
  final void Function()? onResizeButtonTap;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  //final bool canTransform;

  /// The child's original size.
  final Sticker sticker;
  // final String mid;
  // final String pageMid;
  // final Size frameSize;
  // final double angle;
  // final double borderWidth;
  // final bool isMain;

  final Offset realPosition;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  //final BoxConstraints constraints; // not used

  final double pageWidth;
  final double pageHeight;
  final FrameModel? frameModel;
  final bool isResiable;
  final bool isVerticalResiable;
  final bool isHorizontalResiable;

  @override
  // ignore: library_private_types_in_public_api
  DraggableResizableState createState() => DraggableResizableState();
}

class DraggableResizableState extends CretaState<DraggableResizable> {
  late Size _size;
  late Offset _position;
  //late BoxConstraints constraints;
  late double _angle;
  // late double _angleDelta;
  // late double _baseAngle;

  bool get isTouchInputSupported => true;
  // bool _mainSymbolSwitch = true;
  // Timer? _mainSymbolSwitchTimer;

  bool _isFixedRatio = false;
  double _whRatio = 1;
  @override
  bool invalidate() {
    setState(() {
      _size = widget.sticker.frameSize;
      _position = widget.realPosition;
      _angle = widget.sticker.angle;
    });
    return true;
  }

  @override
  void didUpdateWidget(DraggableResizable oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool sizeChanged = false;
    bool posiChanged = false;
    bool anglChanged = false;

    if (widget.sticker.frameSize != oldWidget.sticker.frameSize) {
      //print('didUpdateWidget of DraggableResizable 1');
      sizeChanged = true;
    }
    if (widget.realPosition != oldWidget.realPosition) {
      //print('didUpdateWidget of DraggableResizable 2');
      posiChanged = true;
    }
    if (widget.sticker.angle != oldWidget.sticker.angle) {
      //print('didUpdateWidget of DraggableResizable 3');
      anglChanged = true;
    }

    // if (widget.frameModel != null && oldWidget.frameModel != null) {
    //   if (widget.frameModel!.isFixedRatio.value != oldWidget.frameModel!.isFixedRatio.value) {
    //     _isFixedRatio = widget.frameModel!.isFixedRatio.value;
    //     print('DraggableResizable.didUpdateWidget ===================$_isFixedRatio');
    //   }
    // }

    if (sizeChanged || posiChanged || anglChanged) {
      //setState(() {
      _size = widget.sticker.frameSize;
      _whRatio = (_size.height / _size.width);
      _angle = widget.sticker.angle;
      _position = widget.realPosition;
      //});
    }
  }

  @override
  void dispose() {
    super.dispose();
    //_mainSymbolSwitchTimer?.cancel();
  }

  @override
  void initState() {
    super.initState();
    _size = widget.sticker.frameSize;
    //constraints = const BoxConstraints.expand(width: 1, height: 1);
    _angle = widget.sticker.angle;
    _position = widget.realPosition;
    // _baseAngle = 0;
    // _angleDelta = 0;
    // _mainSymbolSwitchTimer = Timer.periodic(Duration(seconds: 2), (Timer t) {
    //   if (widget.sticker.isMain && StudioVariables.isPreview == false) {
    //     setState(() {
    //       _mainSymbolSwitch = !_mainSymbolSwitch;
    //     });
    //   }
    // });

    //bool isAutoFit = (widget.frameModel != null && widget.frameModel!.isAutoFit.value);
    _whRatio = (_size.height / _size.width);
  }

  @override
  Widget build(BuildContext context) {
    _isFixedRatio = (widget.frameModel != null && widget.frameModel!.isFixedRatio.value);
    // _isFixedRatio = (widget.frameModel != null && widget.frameModel!.isFixedRatio.value);
    // _whRatio = (_size.height / _size.width);

    // return LayoutBuilder(builder: (context, constraint) {
    final normalizedWidth = _size.width;
    final normalizedHeight = _size.height;
    final normalizedLeft = _position.dx;
    final normalizedTop = _position.dy;

    double resizePointerOffset =
        (LayoutConst.selectBoxBorder + LayoutConst.stikerOffset - LayoutConst.cornerDiameter) / 2;

    final stickerContainer = Container(
      key: Key('stickerContainer-$widget.mid}'),
      alignment: Alignment.center,
      height: normalizedHeight + LayoutConst.stikerOffset,
      width: normalizedWidth + LayoutConst.stikerOffset,
      child: SizedBox(
        height: normalizedHeight,
        width: normalizedWidth,
        child: Center(child: widget.child),
      ),
    );

    return Stack(
      children: <Widget>[
        Positioned(
          top: normalizedTop,
          left: normalizedLeft,
          child: DraggablePoint(
            key: Key('draggableResizable_child_draggablePoint-${widget.sticker.id}'),
            onComplete: widget.onComplete,
            onScaleStart: widget.onScaleStart,
            onDrag: onDrag,
            onScale: onScale,
            onRotate: onRotate,
            child: Stack(
              alignment: Alignment.center,
              children: [
                stickerContainer, // 스티커 본체
                if (!StudioVariables.isPreview)
                  selectedBox(normalizedWidth, normalizedHeight, resizePointerOffset),
                if (widget.sticker.isMain && StudioVariables.isPreview == false)
                  MainSymbol(sticker: widget.sticker),
                if (widget.frameModel!.isOverlay.value && StudioVariables.isPreview == false)
                  overlaySymbol(),
              ],
            ),
          ),
        ),
      ],
    );
    //});
  }

  Widget selectedBox(double width, double height, double offset) {
    return SelectedBox(
      key: GlobalObjectKey('SelectedBox-${widget.sticker.pageMid}/$widget.mid}'),
      isResiable: widget.isResiable,
      isVerticalResiable: widget.isVerticalResiable,
      isHorizontalResiable: widget.isHorizontalResiable,
      mid: widget.sticker.id,
      normalizedHeight: height,
      normalizedWidth: width,
      resizePointerOffset: offset,
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
    );
  }

  Widget overlaySymbol() {
    return Positioned(
      left: LayoutConst.stikerOffset / 2 + 4 + (widget.sticker.isMain == true ? 24 : 0),
      top: LayoutConst.stikerOffset / 2 + 4,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircleAvatar(
          backgroundColor: Colors.white.withOpacity(0.1),
          //radius: 16,
          child: Transform.rotate(
            angle: math.pi / 6, // 180/4 = 30도로 회전
            child: Icon(
              Icons.push_pin_outlined,
              color: widget.sticker.pageMid != widget.frameModel!.parentMid.value
                  ? CretaColor.stateNormal
                  : CretaColor.stateCritical,
              size: 16,
            ),
          ),
        ),
      ),
    );
  }

  void onRotate(double a) {
    setState(() => _angle = a * 0.5);
    logger.finest('onRotate $a');
    //setState(() => _angle = a);
    onUpdate('onRotate');
  }

  void onDrag(Offset details) {
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
  }

  void onScale(double s) {
    logger.fine('onScale($s)');
    final updatedSize = Size(
      widget.sticker.frameSize.width * s,
      widget.sticker.frameSize.height * s,
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
  }

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
        widget.sticker.id,
      );
    }
  }

  void onDragBottomRight(Offset details) {
    //ok
    var newHeight = math.max(_size.height + details.dy, 0.0);
    var newWidth = math.max(_size.width + details.dx, 0.0);
    if (_isFixedRatio) {
      if (details.dx.abs() > details.dy.abs()) {
        newHeight = newWidth * _whRatio;
      } else {
        newWidth = newHeight / _whRatio;
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

    if (_isFixedRatio) {
      if (details.dx.abs() > details.dy.abs()) {
        newHeight = newWidth * _whRatio;
        updatedPosition = Offset(_position.dx, _position.dy + _size.height - newHeight);
      } else {
        newWidth = newHeight / _whRatio;
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
    if (_isFixedRatio) {
      if (details.dx.abs() > details.dy.abs()) {
        newHeight = newWidth * _whRatio;
        updatedPosition =
            Offset(_position.dx + details.dx, _position.dy + _size.height - newHeight);
      } else {
        newWidth = newHeight / _whRatio;
        updatedPosition = Offset(_position.dx + _size.width - newWidth, _position.dy + details.dy);
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
    if (_isFixedRatio) {
      if (details.dx.abs() > details.dy.abs()) {
        newHeight = newWidth * _whRatio;
      } else {
        newWidth = newHeight / _whRatio;
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
    if (_isFixedRatio) {
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
    if (_isFixedRatio) {
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
    if (_isFixedRatio) {
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
    if (_isFixedRatio) {
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

  bool _sizeValidCheck(Size updatedSize, Offset pos, Offset moveDirection, Offset details) {
    // double offset = LayoutConst.stikerOffset / 2;

    // if (moveDirection.dx < 0) {
    //   if (updatedSize.width < LayoutConst.minFrameSize) {
    //     logger.fine('mininumSize constraint  ${updatedSize.width}, ${updatedSize.height}');
    //     return false;
    //   }
    // }
    // if (moveDirection.dy < 0) {
    //   if (updatedSize.height < LayoutConst.minFrameSize) {
    //     logger.fine('mininumSize constraint  ${updatedSize.width}, ${updatedSize.height}');
    //     return false;
    //   }
    // }
    // if (moveDirection.dx > 0) {
    //   if (pos.dx + updatedSize.width + offset > widget.pageWidth) {
    //     logger.fine(
    //         'maxinumSize constraint  ${updatedSize.width}, ${updatedSize.height}, pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }

    // if (moveDirection.dy < 0) {
    //   if (pos.dy + updatedSize.height + offset > widget.pageHeight) {
    //     logger.fine(
    //         'maxinumSize constraint  ${updatedSize.width}, ${updatedSize.height} pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    return _moveValidCheck(updatedSize, pos, details);
  }

  // 자석기능
  Offset _applyMagnet(Size updatedSize, Offset pos, Offset move) {
    double leftLimit = BookMainPage.pageOffset.dx - (LayoutConst.stikerOffset / 2);
    double rightLimit = leftLimit + widget.pageWidth;
    //print('leftLimit=$leftLimit, rightLimit=$rightLimit');
    double leftGap = pos.dx - leftLimit;
    double rightGap = rightLimit - (pos.dx + updatedSize.width);
    //print('leftGap=$leftGap,rightGap=$rightGap, ');

    double topLimit = BookMainPage.pageOffset.dy -
        (LayoutConst.stikerOffset / 2); // + StudioConst.pageControlHeight;
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
    //     logger.fine('1.postion constraint  ${move.dx},pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }
    // if (move.dy <= 0) {
    //   if (pos.dy + offset < 0) {
    //     logger.fine('2.postion constraint ${move.dy}, pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    // if (move.dx >= 0) {
    //   if (updatedSize.width + pos.dx + offset > widget.pageWidth) {
    //     logger.fine('3.postion constraint  ${updatedSize.width},pos.dx=${pos.dx}, offset=$offset');
    //     return false;
    //   }
    // }
    // if (move.dy >= 0) {
    //   if (updatedSize.height + pos.dy + offset > widget.pageHeight) {
    //     logger.fine('4.postion constraint ${updatedSize.height}, pos.dy=${pos.dy}, offset=$offset');
    //     return false;
    //   }
    // }

    return true;
  }

  // bool isRotate() {
  //   return (widget.frameModel != null && widget.frameModel!.shouldOutsideRotate());
  // }
}
