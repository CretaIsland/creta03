import 'package:creta03/pages/studio/containees/page/top_menu_notifier.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import '../../../../common/creta_utils.dart';
import '../../../../data_io/frame_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_getx_controller.dart';
import '../../studio_variables.dart';
import '../frame/frame_play_mixin.dart';

class TopMenuTracer extends StatefulWidget {
  final FrameManager frameManager;
  const TopMenuTracer({super.key, required this.frameManager});

  @override
  State<TopMenuTracer> createState() => _TopMenuTracerState();
}

class _TopMenuTracerState extends State<TopMenuTracer> with FramePlayMixin {
  bool _isHover = false;
  Offset? _hoverPos;
  bool _isBusy = false;
  FrameEventController? _sendEvent;

  @override
  void initState() {
    super.initState();
    setFrameManager(widget.frameManager);
    //setFrameManager(BookMainPage.pageManagerHolder!.findSelectedFrameManager()!);
    final FrameEventController sendEvent = Get.find(tag: 'frame-main-to-property');
    _sendEvent = sendEvent;
  }

  @override
  Widget build(BuildContext context) {
    //setFrameManager(BookMainPage.pageManagerHolder!.findSelectedFrameManager()!);
    return Consumer<TopMenuNotifier>(builder: (context, topMenuNotifier, child) {
      if (topMenuNotifier.isNormalCreate()) {
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
            onLongPressDown: (detail) async {
              await _pageClicked(detail);
            },
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
    if (BookMainPage.topMenuNotifier!.isTextCreate()) {
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
    if (BookMainPage.topMenuNotifier!.isFrameCreate()) {
      Offset center = Offset(
        (CretaVars.instance.defaultFrameSize().width / 2) * StudioVariables.applyScale,
        (CretaVars.instance.defaultFrameSize().height / 2) * StudioVariables.applyScale,
      );
      Offset pos = _hoverPos! - center;
      return Positioned(
        left: pos.dx,
        top: pos.dy,
        child: Container(
          width: CretaVars.instance.defaultFrameSize().width * StudioVariables.applyScale,
          height: CretaVars.instance.defaultFrameSize().height * StudioVariables.applyScale,
          color: Colors.grey.withOpacity(0.2),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Future<void> _pageClicked(LongPressDownDetails details) async {
    if (_isHover == false) return;

    if (_isBusy == true) {
      return;
    }
    _isBusy = true;

    Offset center = Offset(
      (CretaVars.instance.defaultFrameSize().width / 2) * StudioVariables.applyScale,
      (CretaVars.instance.defaultFrameSize().height / 2) * StudioVariables.applyScale,
    );
    Offset pos = BookMainPage.bookManagerHolder!.positionInPage(
      details.localPosition - center,
      null,
      applyStickerOffset: false,
    );

    if (BookMainPage.topMenuNotifier!.isTextCreate()) {
      StudioVariables.isHandToolMode = false;
      await frameManager!.createTextAndFrame(context, pos: pos);

      BookMainPage.topMenuNotifier?.clear(); // 커서의 모양을 되돌린다.
      BookMainPage.containeeNotifier!.setFrameClick(true); //  바탕페이지가 눌리는 것을 막기위해
    } else if (BookMainPage.topMenuNotifier!.isFrameCreate()) {
      StudioVariables.isHandToolMode = false;

      FrameModel frameModel = await frameManager!
          .createNextFrame(pos: pos, size: CretaVars.instance.defaultFrameSize());
      frameManager!.afterCreateFrame(frameModel, sendEvent: _sendEvent);

      BookMainPage.topMenuNotifier?.clear();
    }
    _isBusy = false;
    return;
  }
}
