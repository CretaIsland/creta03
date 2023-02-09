// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../book_main_page.dart';

import '../../../design_system/creta_font.dart';
import '../studio_constant.dart';
import '../left_menu/left_menu_mixin.dart';
import '../studio_snippet.dart';
import 'right_menu_book.dart';

class RightMenu extends StatefulWidget {
  //final RightMenuEnum selectedStick;
  final Function onClose;
  const RightMenu({super.key, required this.onClose});

  @override
  State<RightMenu> createState() => _RightMenuState();
}

class _RightMenuState extends State<RightMenu> with SingleTickerProviderStateMixin, LeftMenuMixin {
  @override
  void initState() {
    super.initAnimation(this);
    super.initState();
  }

  @override
  void dispose() {
    super.disposeAnimation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return super.buildAnimation(
      context,
      width: LayoutConst.rightMenuWidth,
      shadowDirection: ShadowDirection.leftTop,
      child: Stack(
        children: [
          Positioned(
              right: 24,
              top: 24,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  super.closeButton(
                      icon: Icons.keyboard_double_arrow_right_outlined, onClose: widget.onClose),
                ],
              )),
          Positioned(left: 28, top: 24, child: Text("...", style: CretaFont.titleLarge)),
          Positioned(
            top: 76,
            left: 0,
            width: LayoutConst.rightMenuWidth,
            child: eachWidget(BookMainPage.selectedClass),
          )
        ],
      ),
    );
  }

  Widget eachWidget(RightMenuEnum selected) {
    switch (selected) {
      case RightMenuEnum.Book:
        return RightMenuBook();
      case RightMenuEnum.Page:
        return Container();
      case RightMenuEnum.Frame:
        return Container();
      case RightMenuEnum.Contents:
        return Container();

      default:
        return Container();
    }
  }
}
