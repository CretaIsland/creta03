// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/creta_color.dart';
import '../../../studio_constant.dart';

import 'draggable_point.dart';

enum ResizePointType {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
}

const _cursorLookup = <ResizePointType, MouseCursor>{
  ResizePointType.topLeft: SystemMouseCursors.resizeUpLeft,
  ResizePointType.topRight: SystemMouseCursors.resizeUpRight,
  ResizePointType.bottomLeft: SystemMouseCursors.resizeDownLeft,
  ResizePointType.bottomRight: SystemMouseCursors.resizeDownRight,
};

class ResizePoint extends StatefulWidget {
  const ResizePoint(
      {Key? key,
      required this.onDrag,
      required this.type,
      required this.onTap,
      required this.onComplete,
      // ignore: unused_element
      this.onScale,
      this.iconData})
      : super(key: key);

  final ValueSetter<Offset> onDrag;
  final ValueSetter<double>? onScale;
  final ResizePointType type;
  final IconData? iconData;
  final void Function() onTap;
  final void Function() onComplete;

  @override
  State<ResizePoint> createState() => _ResizePointState();
}

class _ResizePointState extends State<ResizePoint> {
  bool _isHover = false;

  MouseCursor get _cursor {
    return _cursorLookup[widget.type]!;
  }

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
      cursor: _cursor,
      child: DraggablePoint(
        mode: PositionMode.local,
        onDrag: (value) {
          setState(() {
            _isHover = true;
          });
          widget.onDrag.call(value);
        },
        onScale: widget.onScale,
        onTap: widget.onTap,
        onComplete: () {
          setState(() {
            _isHover = false;
            logger.fine('onComplete');
          });
          widget.onComplete.call();
        },
        child: Container(
          width: LayoutConst.cornerDiameter,
          height: LayoutConst.cornerDiameter,
          decoration: BoxDecoration(
            color: _isHover ? Colors.white : Colors.transparent,
            border: Border.all(color: _isHover ? CretaColor.primary : Colors.transparent, width: 1),
            shape: BoxShape.rectangle,
          ),
          child: _isHover == false
              ? Center(
                  child: Container(
                    width: LayoutConst.dragHandle,
                    height: LayoutConst.dragHandle,
                    decoration: BoxDecoration(
                      border: Border.all(color: CretaColor.primary, width: 1),
                      color: Colors.white,
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
        ),
      ),
    );
  }
}
