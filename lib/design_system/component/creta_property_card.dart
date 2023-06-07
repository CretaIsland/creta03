import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../pages/studio/studio_snippet.dart';
import '../buttons/creta_button_wrapper.dart';

class CretaPropertyUtility {
  static Widget propertyCard({
    double padding = 0,
    required bool isOpen,
    required Function onPressed,
    required Widget titleWidget,
    Widget? trailWidget,
    bool? showTrail,
    required Widget bodyWidget,
    required bool hasRemoveButton,
    required Function onDelete,
    bool animate = false,
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
                  StudioSnippet.rotateWidget(
                    turns: isOpen ? 2 : 0,
                    child: BTN.fill_blue_i_menu(
                        icon: Icons.expand_circle_down_outlined,
                        width: 24,
                        height: 24,
                        iconSize: 20,
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
              isOpen && (showTrail == null || showTrail == false)
                  ? hasRemoveButton
                      ? BTN.fill_gray_i_m(
                          icon: Icons.close_outlined,
                          onPressed: () {
                            onDelete.call();
                          })
                      : const SizedBox.shrink()
                  : hasRemoveButton
                      ? SizedBox(
                          width: 200,
                          //color: Colors.amber,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  onPressed.call();
                                },
                                child: trailWidget ?? const SizedBox.shrink(),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: BTN.fill_gray_i_m(
                                    icon: Icons.close_outlined,
                                    onPressed: () {
                                      onDelete.call();
                                    }),
                              ),
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            onPressed.call();
                          },
                          child: trailWidget ?? const SizedBox.shrink(),
                        ),
            ],
          ),
        ),
        isOpen
            ? animate
                ? bodyWidget.animate().scaleY(alignment: Alignment.topCenter)
                : bodyWidget
            : const SizedBox.shrink(),
      ],
    );
  }
}
