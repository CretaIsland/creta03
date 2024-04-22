import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../../book_main_page.dart';
import '../left_menu_ele_button.dart';

class LeftMenuQuote extends StatefulWidget {
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuQuote({
    super.key,
    required this.title,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuQuote> createState() => _LeftMenuQuoteState();
}

class _LeftMenuQuoteState extends State<LeftMenuQuote> {
  double x = 0;
  double y = 0;
  int frameCount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0),
          child: Wrap(
            spacing: 6.0,
            runSpacing: 12.0,
            children: [
              _getElement(FrameType.dailyQuote, CretaStudioLang['dailyQuote']!),
              _getElement(FrameType.dailyWord, CretaStudioLang['dailyWord']!),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getElement(FrameType frameType, String type) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: LeftMenuEleButton(
        width: 90.0,
        height: 90.0,
        onPressed: () async {
          _createQuote(frameType);
          BookMainPage.pageManagerHolder!.notify();
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              color: Colors.black45,
            ),
            Text(
              type,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createQuote(FrameType frameType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = pageModel.width.value * 0.4;
    double height = pageModel.height.value;

    x += 40.0 * frameCount;

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
    );

    frameCount++;
    mychangeStack.endTrans();
  }
}
