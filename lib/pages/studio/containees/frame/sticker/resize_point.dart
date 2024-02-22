// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import '../../../studio_constant.dart';

import 'draggable_point.dart';
import 'resize_point_draggable.dart';

enum ResizePointType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  up,
  down,
  left,
  right,
}

const _cursorLookup = <ResizePointType, MouseCursor>{
  ResizePointType.topLeft: SystemMouseCursors.resizeUpLeft,
  ResizePointType.topRight: SystemMouseCursors.resizeUpRight,
  ResizePointType.bottomLeft: SystemMouseCursors.resizeDownLeft,
  ResizePointType.bottomRight: SystemMouseCursors.resizeDownRight,
  ResizePointType.up: SystemMouseCursors.resizeUpDown,
  ResizePointType.down: SystemMouseCursors.resizeUpDown,
  ResizePointType.left: SystemMouseCursors.resizeLeftRight,
  ResizePointType.right: SystemMouseCursors.resizeLeftRight,
};

class ResizePoint extends StatefulWidget {
  const ResizePoint(
      {Key? key,
      required this.onDrag,
      required this.type,
      this.onTap,
      required this.onComplete,
      this.enable = true,
      // ignore: unused_element
      this.onScaleUpdate,
      required this.onScaleStart,
      this.iconData})
      : super(key: key);

  final VoidCallback onScaleStart;
  final ValueSetter<Offset> onDrag;
  final ValueSetter<double>? onScaleUpdate;
  final ResizePointType type;
  final IconData? iconData;
  final void Function()? onTap;
  final void Function() onComplete;
  final bool enable;

  @override
  State<ResizePoint> createState() => _ResizePointState();
}

class _ResizePointState extends State<ResizePoint> {
  bool _isHover = false;

  MouseCursor get _cursor {
    return _cursorLookup[widget.type]!;
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MouseRegion(
  //     onHover: (event) {
  //       setState(() {
  //         _isHover = true;
  //       });
  //     },
  //     onExit: (event) {
  //       setState(() {
  //         _isHover = false;
  //       });
  //     },
  //     cursor: _cursor,
  //     child: DraggablePoint(
  //       mode: PositionMode.local,
  //       onDrag: (value) {
  //         widget.onDrag.call(value);
  //       },
  //       onScale: widget.onScale,
  //       onTap: widget.onTap,
  //       onComplete: () {
  //         widget.onComplete.call();
  //       },
  //       child: Container(
  //         width: LayoutConst.dragHandle,
  //         height: LayoutConst.dragHandle,
  //         decoration: BoxDecoration(
  //           border: Border.all(color: CretaColor.primary, width: 1),
  //           color: _isHover ? CretaColor.primary : Colors.white,
  //           shape: BoxShape.rectangle,
  //         ),
  //         child: widget.iconData != null
  //             ? Icon(
  //                 widget.iconData,
  //                 size: 12,
  //                 color: Colors.blue,
  //               )
  //             : Container(),
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isHover = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      cursor: widget.enable ? _cursor : MouseCursor.defer,
      child: ResizePointDraggable(
        mode: PositionMode.local,
        onDrag: (value) {
          //('ResizePointDraggable ----------onDrag-------------------');
          setState(() {
            _isHover = true;
          });
          widget.onDrag.call(value);
        },
        onScaleUpdate: (val) {
          // 얘는 멀티 터치의 경우만 호출된다.
          //print('ResizePointDraggable ----------onScaleUpdate-------------------');
          widget.onScaleUpdate?.call(val);
        },
        onScaleStart: widget.onScaleStart,
        onTap: widget.onTap,
        onComplete: () {
          //print('ResizePointDraggable ----------onComplete-------------------');
          setState(() {
            _isHover = false;
          });
          widget.onComplete.call();
        },
        child: _handle(),
      ),
    );
  }

  Widget _handle() {
    return Container(
      width: LayoutConst.cornerDiameter,
      height: LayoutConst.cornerDiameter,
      decoration: BoxDecoration(
        color: _isHover && widget.enable ? Colors.white : Colors.transparent,
        border: Border.all(
            color: _isHover && widget.enable ? CretaColor.primary : Colors.transparent, width: 1),
        shape: BoxShape.circle,
      ),
      child: _isHover == false
          ? Center(
              child: Container(
                width: LayoutConst.dragHandle,
                height: LayoutConst.dragHandle,
                decoration: BoxDecoration(
                  border: Border.all(color: CretaColor.primary, width: 1),
                  color: widget.enable ? Colors.white : CretaColor.primary,
                  shape: BoxShape.rectangle,
                ),
                child: widget.iconData != null
                    ? Icon(
                        widget.iconData,
                        size: 12,
                        color: Colors.blue,
                      )
                    : Container(),
              ),
            )
          : widget.iconData != null
              ? Icon(
                  widget.iconData,
                  size: 12,
                  color: Colors.blue,
                )
              : Container(),
    );
  }
}
