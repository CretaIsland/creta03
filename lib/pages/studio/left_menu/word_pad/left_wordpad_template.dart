import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

import '../../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/contents_model.dart';
import '../../../../model/frame_model.dart';
import '../../../../model/page_model.dart';
import '../../book_main_page.dart';
import '../../containees/frame/frame_play_mixin.dart';
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
    CretaStudioLang.paragraphTemplate,
    CretaStudioLang.tableTemplate,
  ];

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
        ..._textEditor(),
      ],
    );
  }

  List<Widget> _textEditor() {
    return [
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.only(bottom: 12),
        child: BTN.line_blue_t_m(
          text: CretaStudioLang.textEditorToolbar,
          onPressed: () {
            _createQuillEditor();
            // BookMainPage.leftMenuNotifier!.set(LeftMenuEnum.None);
          },
        ),
      ),
      _elementStyle(),
    ];
  }

  Future<ContentsModel> _quillContent(String frameMid, String bookMid) async {
    ContentsModel retval = ContentsModel.withFrame(parent: frameMid, bookMid: bookMid);

    retval.contentsType = ContentsType.document;

    retval.name = 'Word Pad 1';
    retval.remoteUrl =
        '{"document":{"type":"page","children":[{"type":"heading","data":{"level":2,"delta":[{"insert":"Welcome to Creta!!!"}]}},{"type":"paragraph","data":{"delta":[]}}]}}';
    retval.playTime.set(-1, noUndo: true, save: false);
    return retval;
  }

  Future<void> _createQuillEditor() async {
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
    ContentsModel model = await _quillContent(frameModel.mid, frameModel.realTimeKey);

    //print('_quillContent(${model.contentsType})-----------------------------');

    await createNewFrameAndContents(
      [model],
      pageModel,
      frameModel: frameModel,
    );
  }

  Widget _elementStyle() {
    return SizedBox(
      height: StudioVariables.workHeight - 200.0,
      child: ListView.builder(
        itemCount: styleTitle.length,
        itemBuilder: (BuildContext context, int listIndex) {
          return Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                // padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(styleTitle[listIndex], style: CretaFont.titleSmall),
                    BTN.fill_gray_i_m(
                      icon: Icons.arrow_forward_ios,
                      onPressed: () {},
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 230,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      childAspectRatio: 1.7 / 1),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int gridIndex) {
                    // int totalIndex = (listIndex * 4) + gridIndex;
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: CretaColor.text[200],
                        ),
                        height: 95.0,
                        width: 160.0,
                        // child: Center(
                        //   child: Text('Image $totalIndex'),
                        // ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
