import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

mixin ExampleBoxStateMixin {
  bool? isHover;
  bool isClicked = false;

  final double height = 106;
  final double width = 156;

  void initMixin(bool selected) {
    isClicked = selected;
  }

  Widget buildMixin(
    BuildContext context, {
    bool? isSelected,
    required void Function() setState,
    required void Function() onSelected,
    required void Function() onUnselected,
    required Widget Function() selectWidget,
  }) {
    //return _selectAnimation();
    return MouseRegion(
      onHover: (value) {
        if (isHover == null || isHover! == false) {
          logger.finest('transition hovered');
          isHover = true;
          setState();
        }
      },
      onExit: (value) {
        if (isHover == null || isHover! == true) {
          logger.finest('transition exit');
          isHover = false;
          setState();
        }
      },
      child: GestureDetector(
        onLongPressDown: (details) {
          isClicked = !isClicked;
          if (isClicked) {
            onSelected();
          } else {
            onUnselected();
          }
          // setState();
        },
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: _outLineColor(isSelected),
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Container(
            height: height - 8,
            width: width - 8,
            decoration: BoxDecoration(
              color: CretaColor.text[200]!,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Center(
              child: selectWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Color _outLineColor(bool? isSelected) {
    if (isSelected != null) {
      return isSelected ? CretaColor.primary : Colors.white;
    }
    return isClicked ? CretaColor.primary : Colors.white;
  }

  bool isAni() {
    if (isHover == null) return true;
    return isHover!;
  }

  Widget normalBox(String name) {
    return Container(
      height: height - 56,
      width: width - 46,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Center(
        child: Text(name, style: CretaFont.titleSmall),
      ),
    );
  }

  Widget noAnimation(String name, {required void Function() onNormalSelected}) {
    return GestureDetector(
      onLongPressDown: (details) {
        isClicked = !isClicked;
        onNormalSelected();
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isClicked ? CretaColor.primary : Colors.white,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Container(
          height: height - 8,
          width: width - 8,
          decoration: BoxDecoration(
            color: CretaColor.text[200]!,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
          ),
          child: Center(
            child: Text(name, style: CretaFont.titleSmall),
          ),
        ),
      ),
    );
  }
}
