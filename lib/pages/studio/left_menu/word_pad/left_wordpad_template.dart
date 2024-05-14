import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../data_io/contents_manager.dart';
import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../../../player/doc/creta_doc_widget.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';
import '../left_template_mixin.dart';

class LeftWordPadTemplate extends StatefulWidget {
  const LeftWordPadTemplate({super.key});

  @override
  State<LeftWordPadTemplate> createState() => _LeftWordPadTemplate();
}

class _LeftWordPadTemplate extends State<LeftWordPadTemplate>
    with LeftTemplateMixin, FramePlayMixin {
  final styleTitle = [
    CretaStudioLang['paragraphTemplate']!,
    CretaStudioLang['tableTemplate']!,
  ];
  ContentsEventController? _sendEvent;

  @override
  void initState() {
    super.initState();
    initMixin();
    //final ContentsEventController sendEvent = Get.find(tag: 'text-property-to-textplayer');
    final ContentsEventController sendEvent = Get.find(tag: 'contents-property-to-main');
    _sendEvent = sendEvent;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    resetFrameManager(BookMainPage.pageManagerHolder!.getSelectedMid());
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(bottom: 12),
      child: BTN.line_blue_t_m(
        text: CretaStudioLang['textEditorToolbar']!,
        onPressed: () {
          _createHTMLEditor(context);
          // BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
        },
      ),
    );
  }

  Future<ContentsModel> _createTextContent(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.document;

    retval.name = 'Word Pad 1';
    retval.remoteUrl = '';
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }

  Future<void> _createHTMLEditor(BuildContext context) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 80% 로 만든다. 세로는 가로의 1/6 이다.
    double width = pageModel.width.value * 0.5;
    double height = width / 2.0;
    double x = (pageModel.width.value - width) / 2;
    // double y = (pageModel.height.value - height) / 2;
    double y = 0;

    mychangeStack.startTrans();
    FrameModel frameModel = await frameManager!.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.white,
      type: FrameType.text,
    );
    ContentsModel model = await _createTextContent(frameModel.mid, frameModel.realTimeKey);

    //print('_createTextContent(${model.contentsType})-----------------------------');

    ContentsManager? contentsManager = await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );

    Size realSize = Size(width * StudioVariables.applyScale, height * StudioVariables.applyScale);

    // ignore: use_build_context_synchronously
    Size screenSize = MediaQuery.of(context).size;
    Size dialogSize = screenSize / 2;
    Offset dialogOffset = Offset(
      (screenSize.width - dialogSize.width) / 2,
      (screenSize.height - dialogSize.height) / 2,
    ); //rootBundle.loadString('assets/example.json');

    String initialText = '';

    CretaDocWidget.showHtmlEditor(
      // ignore: use_build_context_synchronously
      context,
      model,
      realSize,
      frameModel,
      frameManager!,
      initialText,
      dialogOffset,
      dialogSize,
      onPressedOK: (value) {
        setState(() {
          model.remoteUrl = value;
          contentsManager?.setToDB(model).then((value) {
            _sendEvent?.sendEvent(model);
            return null;
          });
        });
        Navigator.of(context).pop();
      },
    );
  }
}
