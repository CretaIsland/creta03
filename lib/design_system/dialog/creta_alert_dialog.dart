import 'package:creta03/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';

class CretaAlertDialog extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Icon? icon;
  final Widget content;
  final String cancelButtonText;
  final String okButtonText;
  final double okButtonWidth;
  final Function onPressedOK;
  final Function? onPressedCancel;

  const CretaAlertDialog(
      {super.key,
      this.width = 387.0,
      this.height = 208.0,
      this.padding = const EdgeInsets.only(left: 32.0),
      this.icon,
      required this.content,
      this.cancelButtonText = CretaLang.cancel,
      this.okButtonText = CretaLang.confirm,
      this.okButtonWidth = 55,
      required this.onPressedOK,
      this.onPressedCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: width > 150
                    ? EdgeInsets.only(left: width * .97 - 28, top: height * .057)
                    : EdgeInsets.only(left: width - 40, top: height * .057),
                child: BTN.fill_gray_i_s(
                    icon: Icons.close,
                    onPressed: () {
                      if (onPressedCancel != null) {
                        onPressedCancel!.call();
                      } else {
                        Navigator.of(context).pop();
                      }
                    })),
            Padding(
                padding: padding,
                child: icon != null
                    ? Column(
                        children: [icon!, content],
                      )
                    : content),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
              child: Container(
                width: width,
                height: 1.0,
                color: Colors.grey.shade200,
              ),
            ),
            Padding(
                padding: width > 150
                    ? EdgeInsets.only(left: width * .97 - (63 + okButtonWidth))
                    : EdgeInsets.only(left: width - 120),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BTN.line_red_t_m(
                        text: cancelButtonText,
                        onPressed: () {
                          if (onPressedCancel != null) {
                            onPressedCancel!.call();
                          } else {
                            Navigator.of(context).pop();
                          }
                        }),
                    const SizedBox(width: 8.0),
                    BTN.fill_red_t_m(
                        text: okButtonText, width: okButtonWidth, onPressed: onPressedOK)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
