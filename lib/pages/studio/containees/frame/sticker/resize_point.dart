import 'package:flutter/material.dart';

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

class ResizePoint extends StatelessWidget {
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

  MouseCursor get _cursor {
    return _cursorLookup[type]!;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _cursor,
      child: DraggablePoint(
        mode: PositionMode.local,
        onDrag: onDrag,
        onScale: onScale,
        onTap: onTap,
        onComplete: onComplete,
        child: Container(
          width: LayoutConst.cornerDiameter,
          height: LayoutConst.cornerDiameter,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 2),
            shape: BoxShape.circle,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: iconData != null
                ? Icon(
                    iconData,
                    size: 12,
                    color: Colors.blue,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}