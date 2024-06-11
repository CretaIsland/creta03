//import 'dart:ui';

// ignore_for_file: must_be_immutable

import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';

import 'package:creta_common/common/creta_font.dart';

class CretaAlertDialog extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Icon? icon;
  final Widget content;
  String? cancelButtonText;
  String? okButtonText;
  final double okButtonWidth;
  final Function onPressedOK;
  final Function? onPressedCancel;
  final Color? backgroundColor;
  final String? title;
  final Widget? titleTrail;
  final bool hasCancelButton;

  CretaAlertDialog(
      {super.key,
      this.width = 387.0,
      this.height = 308.0,
      this.padding = const EdgeInsets.only(left: 32.0, right: 32.0),
      this.icon,
      required this.content,
      this.cancelButtonText, // = CretaLang['cancel']!,
      this.okButtonText, // = CretaLang['confirm']!,
      this.okButtonWidth = 55,
      this.backgroundColor,
      this.title,
      this.titleTrail,
      this.hasCancelButton = true,
      required this.onPressedOK,
      this.onPressedCancel}) {
    cancelButtonText ??= CretaLang['cancel']!;
    okButtonText ??= CretaLang['confirm']!;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child:

          //  BackdropFilter(
          //   filter: ImageFilter.blur(
          //     sigmaX: 3,
          //     sigmaY: 3,
          //   ),
          //   child:

          SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              // 타이틀 Area
              height: 80,
              child: Column(
                children: [
                  title != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title!, style: CretaFont.titleMedium),
                              titleTrail != null
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        titleTrail!,
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        _closeButton(context),
                                      ],
                                    )
                                  : _closeButton(context),
                            ],
                          ),
                        )
                      : Padding(
                          padding: width > 150
                              ? EdgeInsets.only(left: width * .97 - 28, top: height * .057)
                              : EdgeInsets.only(left: width - 40, top: height * .057),
                          child: _closeButton(context),
                        ),
                  Divider(
                    height: 20,
                    indent: 20,
                    color: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
            Expanded(
              // 본체 Area
              child: Padding(
                  padding: padding,
                  child: icon != null
                      ? Column(
                          children: [icon!, content],
                        )
                      : content),
            ),
            SizedBox(
              height: 80,
              child: Column(
                children: [
                  Divider(
                    height: 30,
                    indent: 20,
                    color: Colors.grey.shade200,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                  //   child: Container(
                  //     width: width,
                  //     height: 1.0,
                  //     color: Colors.grey.shade200,
                  //   ),
                  // ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      // padding: width > 150
                      //     ? EdgeInsets.only(left: width * .97 - (63 + okButtonWidth))
                      //     : EdgeInsets.only(left: width - 120),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (hasCancelButton == true)
                            BTN.line_red_t_m(
                                text: cancelButtonText!,
                                onPressed: () {
                                  if (onPressedCancel != null) {
                                    onPressedCancel!.call();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                }),
                          const SizedBox(width: 8.0),
                          BTN.fill_red_t_m(
                              text: okButtonText!, width: okButtonWidth, onPressed: onPressedOK)
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
      //),
    );
  }

  Widget _closeButton(BuildContext context) {
    return BTN.fill_gray_i_s(
        icon: Icons.close,
        onPressed: () {
          if (onPressedCancel != null) {
            onPressedCancel!.call();
          } else {
            Navigator.of(context).pop();
          }
        });
  }
}
