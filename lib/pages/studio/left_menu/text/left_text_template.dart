// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../../../design_system/buttons/creta_rect_button.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
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
    initFrameManager();
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
        child: Text(CretaStudioLang.newText, style: CretaFont.titleSmall),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang.hugeText,
          onPressed: () {
            _createText(64.0, 0.8);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang.bigText,
          onPressed: () {
            _createText(48.0, 0.6);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang.middleText,
          onPressed: () {
            _createText(36.0, 0.4);
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: CretaRectButton(
          title: CretaStudioLang.smallText,
          onPressed: () {
            _createText(24.0, 0.2);
          },
        ),
      ),
    ];
  }

  Future<ContentsModel> _defaultTextModel(double fontSize, String frameMid) async {
    ContentsModel retval = ContentsModel(frameMid);

    retval.contentsType = ContentsType.text;
    retval.name = CretaStudioLang.defaultText;
    retval.remoteUrl = CretaStudioLang.defaultText;
    retval.fontSize.set(fontSize, noUndo: true, save: false);
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }

  Future<void> _createText(double fontSize, double widthRatio) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 80% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * widthRatio;
    double height = width / 6;
    double x = (pageModel.width.value - width) / 2;
    double y = (pageModel.height.value - height) / 2;

    FrameModel frameModel = await frameManager!.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: FrameType.text,
    );
    ContentsModel model = await _defaultTextModel(fontSize, frameModel.mid);
    await createContent(model, pageModel, frameModel);
  }
}
