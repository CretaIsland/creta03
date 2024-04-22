// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../../design_system/buttons/creta_rect_button.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../../studio_constant.dart';
import '../left_template_mixin.dart';

class LeftTextTemplate extends StatefulWidget {
  const LeftTextTemplate({super.key});

  @override
  State<LeftTextTemplate> createState() => _LeftTextTemplateState();
}

class _LeftTextTemplateState extends State<LeftTextTemplate>
    with LeftTemplateMixin, FramePlayMixin {
  @override
  void initState() {
    super.initState();
    initMixin();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resetFrameManager(BookMainPage.pageManagerHolder!.getSelectedMid());
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ..._newText(),
      ],
    );
  }

  List<Widget> _newText() {
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(CretaStudioLang['newText']!, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang['hugeText']!,
          onPressed: () {
            createText(0.8, FontSizeType.enumToVal[FontSizeType.huge]!, FontSizeType.huge);
            BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None); // leftMenu 를 닫는다.
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang['bigText']!,
          onPressed: () {
            createText(0.6, FontSizeType.enumToVal[FontSizeType.big]!, FontSizeType.big);
            BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None); // leftMenu 를 닫는다.
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang['middleText']!,
          onPressed: () {
            createText(0.4, FontSizeType.enumToVal[FontSizeType.middle]!, FontSizeType.middle);
            BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None); // leftMenu 를 닫는다.
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang['smallText']!,
          onPressed: () {
            createText(0.2, FontSizeType.enumToVal[FontSizeType.small]!, FontSizeType.small);
            BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None); // leftMenu 를 닫는다.
          },
        ),
      ),
    ];
  }
}
