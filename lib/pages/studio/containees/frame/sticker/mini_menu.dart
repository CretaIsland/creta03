import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../../design_system/creta_color.dart';
import '../../../studio_constant.dart';

class MiniMenu extends StatefulWidget {
  final Offset parentPosition;
  final Size parentSize;
  final double parentBorderWidth;
  final double pageHeight;

  const MiniMenu({
    super.key,
    required this.parentPosition,
    required this.parentSize,
    required this.parentBorderWidth,
    required this.pageHeight,
  });

  @override
  State<MiniMenu> createState() => _MiniMenuState();
}

class _MiniMenuState extends State<MiniMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    logger.fine('MiniMenu build');

    double centerX =
        widget.parentPosition.dx + (widget.parentSize.width + LayoutConst.stikerOffset) / 2;
    double left = centerX - LayoutConst.miniMenuWidth / 2;
    double top = widget.parentPosition.dy +
        widget.parentSize.height +
        LayoutConst.miniMenuGap +
        LayoutConst.stikerOffset / 2;

    if (top + LayoutConst.miniMenuHeight > widget.pageHeight) {
      // 화면의 영역을 벗어나면 어쩔 것인가...
      // 겨...올라간다...

      top = widget.parentPosition.dy +
          widget.parentSize.height -
          LayoutConst.miniMenuGap -
          LayoutConst.miniMenuHeight;
    }

    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: LayoutConst.miniMenuWidth,
        height: LayoutConst.miniMenuHeight,
        decoration: BoxDecoration(
          color: CretaColor.primary.withOpacity(0.5),
          border: Border.all(
            width: 1,
            color: CretaColor.primary,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(45)),
        ),
      ),
    );
  }
}
