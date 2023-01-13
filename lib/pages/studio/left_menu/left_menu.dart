// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'left_menu_frame.dart';
import '../../../lang/creta_studio_lang.dart';
import '../../../design_system/creta_font.dart';
import '../studio_constant.dart';
import '../studio_snippet.dart';
import 'left_menu_page.dart';

class LeftMenu extends StatefulWidget {
  final LeftMenuEnum selectedStick;
  final Function onClose;
  const LeftMenu({super.key, required this.selectedStick, required this.onClose});

  @override
  State<LeftMenu> createState() => _LeftMenuState();
}

class _LeftMenuState extends State<LeftMenu> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double closeIconSize = 20.0;
    return Container(
      margin: const EdgeInsets.only(top: LayoutConst.layoutMargin),
      height: height,
      width: LayoutConst.leftMenuWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: StudioSnippet.basicShadow(),
      ),
      child: Stack(
        children: [
          Positioned(
              left: LayoutConst.leftMenuWidth - 2 * closeIconSize - 6,
              top: 6,
              child: IconButton(
                iconSize: closeIconSize,
                icon: Icon(Icons.keyboard_double_arrow_left_outlined),
                onPressed: () {
                  widget.onClose();
                },
              )),
          Positioned(
              left: 28,
              top: 24,
              child: Text(CretaStudioLang.menuStick[widget.selectedStick.index],
                  style: CretaFont.titleLarge)),
          Positioned(
            top: 76,
            left: 0,
            width: LayoutConst.leftMenuWidth,
            child: eachWidget(widget.selectedStick),
          )
        ],
      ),
    );
  }

  Widget eachWidget(LeftMenuEnum selected) {
    switch (selected) {
      case LeftMenuEnum.Template:
        return Container();
      case LeftMenuEnum.Page:
        return LeftMenuPage();
      case LeftMenuEnum.Frame:
        return LeftMenuFrame();
      case LeftMenuEnum.Storage:
        return Container();
      case LeftMenuEnum.Image:
        return Container();
      case LeftMenuEnum.Video:
        return Container();
      case LeftMenuEnum.Text:
        return Container();
      case LeftMenuEnum.Figure:
        return Container();
      case LeftMenuEnum.Widget:
        return Container();
      case LeftMenuEnum.Camera:
        return Container();
      case LeftMenuEnum.Comment:
        return Container();
      default:
        return Container();
    }
  }
}
