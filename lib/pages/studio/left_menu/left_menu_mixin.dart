// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../../lang/creta_studio_lang.dart';
import '../studio_snippet.dart';

mixin LeftMenuMixin {
  late AnimationController _animationController;

  void initAnimation(TickerProvider tp, {int duration = 50}) {
    _animationController = AnimationController(
      duration: Duration(milliseconds: duration),
      reverseDuration: Duration(milliseconds: duration + 50),
      vsync: tp,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  void disposeAnimation() {
    _animationController.dispose();
  }

  Widget buildAnimation(BuildContext context,
      {required Widget child,
      required double width,
      ShadowDirection shadowDirection = ShadowDirection.rightBottum}) {
    //double height = MediaQuery.of(context).size.height;
    //double closeIconSize = 20.0;
    return SlideTransition(
      position: Tween<Offset>(
        begin: shadowDirection == ShadowDirection.rightBottum ? Offset(-1, 0) : Offset(1, 0),
        end: Offset.zero,
      ).animate(_animationController),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
            //margin: const EdgeInsets.only(top: LayoutConst.layoutMargin),
            //height: height,
            width: width,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: StudioSnippet.basicShadow(direction: shadowDirection),
            ),
            child: child),
      ),
    );
  }

  Widget verticalAnimation(
    BuildContext context, {
    required Widget child,
    required double height,
  }) {
    //double height = MediaQuery.of(context).size.height;
    //double closeIconSize = 20.0;
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(0, -1),
        end: Offset.zero,
      ).animate(_animationController),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
            //margin: const EdgeInsets.only(top: LayoutConst.layoutMargin),
            //height: height,
            height: height,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: child),
      ),
    );
  }

  Widget closeButton({required IconData icon, required Function onClose}) {
    return BTN.fill_gray_i_m(
      tooltip: CretaStudioLang['close']!,
      tooltipBg: CretaColor.text[700]!,
      icon: icon,
      onPressed: () async {
        //await _animationController.reverse();
        onClose.call();
      },
    );
  }
}
