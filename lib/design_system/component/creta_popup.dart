import 'package:flutter/material.dart';

import '../../pages/studio/studio_variables.dart';
import '../creta_color.dart';
import '../creta_font.dart';

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

  static Future<void> yesNoDialog({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String question,
    required void Function()? onNo,
    required void Function()? onYes,
    String noBtText = 'No',
    String yesBtText = 'Yes',
    bool yesIsDefault = true,
  }) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button for close dialog!
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(0), // Remove default padding
            title: Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                5,
                10,
              ), // Add custom padding
              color: CretaColor.primary, // Background color for the title
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(icon, color: Colors.white), // The icon in front of the title
                      const SizedBox(width: 10), // Space between icon and title
                      Text(
                        title,
                        style: CretaFont.titleELarge.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Dismiss dialog
                    },
                    icon: const Icon(Icons.close_outlined),
                  )
                ],
              ),
            ),
            content: Text(question, style: CretaFont.bodyMedium),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: yesIsDefault
                      ? CretaColor.primary.withOpacity(0.15)
                      : CretaColor.primary.withOpacity(0.85), // Light blue background
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)), // Rounded corners
                ),
                onPressed: () {
                  onNo?.call();
                  Navigator.of(dialogContext).pop(); // Dismiss dialog
                },
                child: Text(noBtText, style: CretaFont.buttonMedium),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: yesIsDefault
                      ? CretaColor.primary.withOpacity(0.85)
                      : CretaColor.primary.withOpacity(0.15), // Light blue background
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)), // Rounded corners
                ),
                child: Text(yesBtText, style: CretaFont.buttonMedium),
                onPressed: () {
                  onYes?.call();
                  Navigator.of(dialogContext).pop(); // Dismiss dialog
                },
              ),
            ],
          );
        });
  }
}
