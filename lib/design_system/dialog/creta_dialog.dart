import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';

class CretaDialog extends StatelessWidget {
  const CretaDialog({
    super.key,
    this.width = 406.0,
    this.height = 289.0,
    this.title = '',
    this.crossAxisAlign = CrossAxisAlignment.start,
    this.hideTopSplitLine = false,
    required this.content,
  });

  final double width;
  final double height;
  final String title;
  final CrossAxisAlignment crossAxisAlign;
  final bool hideTopSplitLine;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: crossAxisAlign,
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 13.0, right: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: CretaFont.titleMedium,
                      ),
                      BTN.fill_gray_i_s(
                          icon: Icons.close, onPressed: () => Navigator.of(context).pop())
                    ],
                  )),
              (hideTopSplitLine)
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Container(
                        width: width,
                        height: 2.0,
                        color: CretaColor.text[100], //Colors.grey.shade200,
                      ),
                    ),
              content
            ],
          ),
        ),
      ),
    );
  }
}

class CretaStackDialog extends StatelessWidget {
  const CretaStackDialog({
    super.key,
    required this.width,
    required this.height,
    this.title = '',
    this.hideTopSplitLine = true,
    this.showCloseButton = true,
    this.elevation,
    required this.content,
  });

  final double width;
  final double height;
  final String title;
  final bool hideTopSplitLine;
  final bool showCloseButton;
  final double? elevation;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            content,
            SizedBox(
              width: width,
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 13.0, right: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: CretaFont.titleMedium,
                        ),
                        if (showCloseButton)
                          BTN.fill_gray_i_s(
                              icon: Icons.close, onPressed: () => Navigator.of(context).pop()),
                      ],
                    ),
                  ),
                  (hideTopSplitLine)
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Container(
                            width: width,
                            height: 2.0,
                            color: CretaColor.text[100], //Colors.grey.shade200,
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
