// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../lang/creta_studio_lang.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';

class LeftMenuFrame extends StatefulWidget {
  const LeftMenuFrame({super.key});

  @override
  State<LeftMenuFrame> createState() => _LeftMenuFrameState();
}

class _LeftMenuFrameState extends State<LeftMenuFrame> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.start,
          children: CretaStudioLang.frameKind.map((e) {
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: BTN.line_blue_t_m(text: e, onPressed: () {}),
              //child: CretaElevatedButton(caption: e, onPressed: () {}),
            );
          }).toList(),
        ),
        SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(CretaStudioLang.latelyUsedFrame, style: CretaFont.titleSmall),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 16,
                  color: CretaColor.text[700]!,
                )),
          ],
        ),
      ],
    );
  }
}
