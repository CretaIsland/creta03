import 'package:flutter/material.dart';

import '../../pages/studio/studio_variables.dart';

class CretaPopup {
  static Future<void> popup({
    required BuildContext context,
    GlobalKey? globalKey,
    required Widget child,
    required double width,
    required double height,
    Function? initFunc,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();

        //StudioVariables.displayHeight
        double x = 0;
        double y = 0;
        double margin = 40;

        if (globalKey != null) {
          final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;

          x = position.dx;
          y = position.dy + size.height - 1;

          if (x + width + margin > StudioVariables.displayWidth) {
            x = StudioVariables.displayWidth - width - margin;
          }
          if (y + height + margin > StudioVariables.displayHeight) {
            y = StudioVariables.displayHeight - height - margin;
          }

          if (x < 0) x = 0;
          if (y < 0) y = 0;
        } else {
          // 화면 중앙에 나간다.
          x = StudioVariables.displayWidth - width - margin;
          y = StudioVariables.displayHeight - height - margin;
        }

        return SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Positioned(left: x, top: y, child: child),
            ],
          ),
        );
      },
    );
    return Future.value();
  }
}
