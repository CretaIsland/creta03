import 'package:creta03/pages/studio/containees/page/top_menu_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import '../../../../design_system/creta_color.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_variables.dart';
import '../frame/frame_play_mixin.dart';

class TopMenuTracer extends StatefulWidget {
  final FrameManager? frameManager;
  const TopMenuTracer({super.key, required this.frameManager});

  @override
  State<TopMenuTracer> createState() => _TopMenuTracerState();
}

class _TopMenuTracerState extends State<TopMenuTracer> with FramePlayMixin {
  bool _isHover = false;
  Offset? _hoverPos;

  @override
  void initState() {
    super.initState();
    frameManager = widget.frameManager;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TopMenuNotifier>(builder: (context, topMenuNotifier, child) {
      if (topMenuNotifier.isNormal()) {
        return const SizedBox.shrink();
      }
      return Center(
        child: MouseRegion(
          cursor: CretaUtils.getCursorShape(),
          //onEnter: (event) {},
          onExit: (event) {
            if (_isHover == true) {
              setState(() {
                _isHover = false;
                BookMainPage.topMenuNotifier!.clear();
              });
            }
          },
          onHover: (event) {
            setState(() {
              _isHover = true;
              _hoverPos = event.localPosition;
            });
          }, // <-- 커서모양을 바꾸기 위해
          child: GestureDetector(
            onLongPressDown: _pageClicked,
            child: Container(
              color: Colors.amber.withOpacity(0.1),
              width: StudioVariables.virtualWidth,
              height: StudioVariables.virtualHeight,
              child: _isHover && _hoverPos != null
                  ? Stack(
                      children: [_traceMark()],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      );
    });
  }

  Widget _traceMark() {
    if (BookMainPage.topMenuNotifier!.isText()) {
      Offset pos = Offset(
        (_hoverPos!.dx - LayoutConst.topMenuCursorSize > 0
            ? _hoverPos!.dx - LayoutConst.topMenuCursorSize
            : 0),
        (_hoverPos!.dy - LayoutConst.topMenuCursorSize > 0
            ? _hoverPos!.dy - LayoutConst.topMenuCursorSize
            : 0),
      );
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: const Icon(
          Icons.text_fields,
          size: 48,
          color: CretaColor.primary,
        ),
      );
    }
    if (BookMainPage.topMenuNotifier!.isFrame()) {
      Offset center = Offset(
        (LayoutConst.defaultFrameSize.width / 2) * StudioVariables.applyScale,
        (LayoutConst.defaultFrameSize.height / 2) * StudioVariables.applyScale,
      );
      Offset pos = _hoverPos! - center;
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: Container(
          width: LayoutConst.defaultFrameSize.width * StudioVariables.applyScale,
          height: LayoutConst.defaultFrameSize.height * StudioVariables.applyScale,
          color: Colors.grey.withOpacity(0.2),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _pageClicked(LongPressDownDetails details) async {
    if (_isHover == false) return;

    if (BookMainPage.topMenuNotifier!.isText()) {
      // create text box here
      //print('createTextBox');
      StudioVariables.isHandToolMode = false;
      await createTextByClick(context, details.localPosition);
      //await createTextByClick(context, _hoverPos!);
      BookMainPage.topMenuNotifier?.clear(); // 커서의 모양을 되돌린다.
      BookMainPage.containeeNotifier!.setFrameClick(true); //  바탕페이지가 눌리는 것을 막기위해
      return;
    } else if (BookMainPage.topMenuNotifier!.isFrame()) {
      // create frame box here
      //print('createFrame');
      Offset center = Offset(
        (LayoutConst.defaultFrameSize.width / 2) * StudioVariables.applyScale,
        (LayoutConst.defaultFrameSize.height / 2) * StudioVariables.applyScale,
      );
      Offset pos = CretaUtils.positionInPage(details.localPosition - center, null);
      frameManager!.createNextFrame(pos: pos, size: LayoutConst.defaultFrameSize).then((value) {
        frameManager!.notify();
        return null;
      });

      BookMainPage.topMenuNotifier?.clear();
      return; // 커서의 모양을 되돌린다.
    }
  }
}
