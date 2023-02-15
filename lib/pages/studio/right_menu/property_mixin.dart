import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/component/snippet_studio.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';

mixin PropertyMixin {
  late TextStyle titleStyle;
  late TextStyle dataStyle;

  void initMixin() {
    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;
  }

  Widget propertyCard({
    double padding = 0,
    required bool isOpen,
    required Function onPressed,
    required Widget titleWidget,
    Widget? trailWidget,
    required Widget bodyWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SnippetStudio.rotateWidget(
                    turns: isOpen ? 0 : 2,
                    child: BTN.fill_blue_i_menu(
                        icon: Icons.expand_circle_down_outlined,
                        width: 20,
                        height: 20,
                        onPressed: onPressed),
                  ),
                  InkWell(
                    onTap: () {
                      onPressed.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: titleWidget,
                    ),
                  ),
                ],
              ),
              isOpen ? const SizedBox.shrink() : trailWidget ?? const SizedBox.shrink(),
            ],
          ),
        ),
        isOpen ? bodyWidget : const SizedBox.shrink(),
      ],
    );
  }

  Widget propertyLine({required String name, required Widget widget, double topPadding = 20.0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          widget,
        ],
      ),
    );
  }

  Widget propertyLine2(
      {required String name,
      required Widget widget1,
      required Widget widget2,
      double topPadding = 20.0}) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: titleStyle),
          widget1,
          widget2,
        ],
      ),
    );
  }

  Widget propertyDivider({double height = 38}) {
    return Divider(
      height: 38,
      color: CretaColor.text[200]!,
      indent: 0,
      endIndent: 0,
    );
  }
}
