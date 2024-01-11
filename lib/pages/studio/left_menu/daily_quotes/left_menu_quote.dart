import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../model/app_enums.dart';
import '../../../../model/page_model.dart';
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
          child: LeftMenuEleButton(
            width: 90.0,
            height: 90.0,
            onPressed: () async {
              _createQuote(FrameType.quote);
              BookMainPage.pageManagerHolder!.notify();
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('quote_BG.jpg'),
                Container(
                  color: Colors.black45,
                ),
                const Text(
                  "Quote of the Day",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _createQuote(FrameType frameType) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    //페이지폭의 50% 로 만든다. 세로는 가로의 1/6 이다.
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
