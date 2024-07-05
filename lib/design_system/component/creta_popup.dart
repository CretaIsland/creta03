import 'package:flutter/material.dart';

import '../../pages/studio/studio_variables.dart';
import '../buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            titlePadding: const EdgeInsets.all(0), // Remove default padding
            title: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 13.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: CretaFont.titleMedium),
                        BTN.fill_gray_i_s(
                            icon: Icons.close, onPressed: () => Navigator.of(context).pop())
                      ],
                    )),
                const Divider(
                  indent: 8,
                  endIndent: 8,
                ),
              ],
            ),
            content: Text(question, style: CretaFont.bodyMedium),
            actions: <Widget>[
              Column(
                children: [
                  const Divider(
                    height: 10,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      BTN.line_red_t_m(
                        //width: 55,
                        text: noBtText,
                        onPressed: () async {
                          onNo?.call();
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      const SizedBox(width: 8),
                      BTN.line_red_t_m(
                        //width: 55,
                        text: yesBtText,
                        onPressed: () async {
                          onYes?.call();
                          Navigator.of(dialogContext).pop();
                        },
                      ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: yesIsDefault
                      //         ? CretaColor.primary.withOpacity(0.15)
                      //         : CretaColor.primary.withOpacity(0.85), // Light blue background
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(5)), // Rounded corners
                      //   ),
                      //   onPressed: () {
                      //     onNo?.call();
                      //     Navigator.of(dialogContext).pop(); // Dismiss dialog
                      //   },
                      //   child: Text(noBtText, style: CretaFont.buttonMedium),
                      // ),
                      // TextButton(
                      //   style: TextButton.styleFrom(
                      //     backgroundColor: yesIsDefault
                      //         ? CretaColor.primary.withOpacity(0.85)
                      //         : CretaColor.primary.withOpacity(0.15), // Light blue background
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(5)), // Rounded corners
                      //   ),
                      //   child: Text(yesBtText, style: CretaFont.buttonMedium),
                      //   onPressed: () {
                      //     onYes?.call();
                      //     Navigator.of(dialogContext).pop(); // Dismiss dialog
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }

  static Future<void> simple({
    required BuildContext context,
    required String title,
    required IconData icon,
    required String question,
    required void Function()? onYes,
    String yesBtText = 'Close',
    bool yesIsDefault = true,
  }) {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // User must tap button for close dialog!
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            titlePadding: const EdgeInsets.all(0), // Remove default padding
            title: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 13.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(title, style: CretaFont.titleMedium),
                        BTN.fill_gray_i_s(
                            icon: Icons.close, onPressed: () => Navigator.of(context).pop())
                      ],
                    )),
                const Divider(
                  indent: 8,
                  endIndent: 8,
                ),
              ],
            ),
            content: Text(
              question,
              style: CretaFont.bodyMedium.copyWith(height: 1.5),
            ),
            actions: <Widget>[
              Column(
                children: [
                  const Divider(
                    height: 10,
                  ),
                  const SizedBox(height: 12),
                  BTN.line_red_t_m(
                    //width: 55,
                    text: yesBtText,
                    onPressed: () async {
                      onYes?.call();
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}
