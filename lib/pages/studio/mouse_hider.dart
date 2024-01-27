import 'dart:async';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import 'studio_getx_controller.dart';
import 'studio_variables.dart';

class MouseHider extends StatefulWidget {
  static DateTime? lastMouseMoveTime;

  final Widget child;
  final bool fromPriviewToMain;
  final void Function() onMouseHideChanged;

  const MouseHider({
    super.key,
    required this.child,
    required this.fromPriviewToMain,
    required this.onMouseHideChanged,
  });

  @override
  State<MouseHider> createState() => MouseHiderState();
}

class MouseHiderState extends State<MouseHider> {
  int _mouseMoveCount = 0;

  Timer? _mouseMovetimer;
  OffsetEventController? _sendMouseEvent;

  bool _fromPriviewToMain = false; // 돌아가기 버튼을 누르면 True  가 됨.
  @override
  void didUpdateWidget(MouseHider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.fromPriviewToMain != widget.fromPriviewToMain) {
      _fromPriviewToMain = widget.fromPriviewToMain;
    }
  }

  @override
  void initState() {
    _hideMouseTimer();
    _fromPriviewToMain = widget.fromPriviewToMain;
    super.initState();
  }

  @override
  void dispose() {
    _mouseMovetimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
        cursor: StudioVariables.hideMouse ? SystemMouseCursors.none : SystemMouseCursors.click,
        onExit: (event) {
          //print('mouse exit');
          setState(() {
            StudioVariables.hideMouse = true;
          });
        },
        onEnter: (event) {
          // 처음 떳을 때이다.
          //print('mouse enter');
          setState(() {
            StudioVariables.hideMouse = true;
          });
          // // 마우스가 위젯에 진입할 때 커서를 숨김
          // StudioVariables.hideMouse = true;
          // SystemChannels.mouseCursor.invokeMethod('mouseCursor', 'none');
          // _mouseMoveCount = 0;
        },
        onHover: (pointerEvent) {
          _mouseMoveCount++;
          MouseHider.lastMouseMoveTime = DateTime.now();
          if (_mouseMoveCount > 30) {
            //print('mouse hover');
            //SystemChannels.mouseCursor.invokeMethod('mouseCursor', 'auto');
            if (StudioVariables.hideMouse == true) {
              //true일 경우만 한다.
              setState(() {
                StudioVariables.hideMouse = false;
              });
              widget.onMouseHideChanged.call();
            }
            _mouseMoveCount = 0;
          }
        },
        child: widget.child);
  }

  void _hideMouseTimer() {
    // isPreViewMode = true 인 경우만
    // 이전 타이머를 취소하고 새 타이머를 시작

    if (StudioVariables.isPreview == true) {
      final OffsetEventController sendMouseEvent = Get.find(tag: 'on-link-to-link-widget');
      _sendMouseEvent = sendMouseEvent;

      //print('hide mouse 1');
      //StudioVariables.hideMouse = true;
      //SystemChannels.mouseCursor.invokeMethod('mouseCursor', 'none');
      //_mouseMovetimer?.cancel();
      _mouseMovetimer = Timer.periodic(const Duration(seconds: 1), (t) {
        // 3초 동안 마우스 움직임이 없으면 커서를 숨김
        if (StudioVariables.isPreview == true) {
          if (MouseHider.lastMouseMoveTime != null) {
            if (StudioVariables.hideMouse == false &&
                DateTime.now().difference(MouseHider.lastMouseMoveTime!).inSeconds >= 3) {
              logger.info('3 second passed');
              if (_fromPriviewToMain == false) {
                // 페이지가 넘어가는 중에, setState 가 동작하면 안된다.
                setState(() {
                  StudioVariables.hideMouse = true;
                  _sendMouseEvent?.sendEvent(Offset.zero);
                });
              }
              _mouseMoveCount = 0;
            }
          } else {
            // setState(() {
            //   print('hide mouse 2');
            //   StudioVariables.hideMouse = true;
            // });
          }
        }
      });
    } else {
      StudioVariables.hideMouse = false;
    }
  }
}
