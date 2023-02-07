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

class _LeftMenuState extends State<LeftMenu> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      reverseDuration: Duration(milliseconds: 200),
      vsync: this,
    );
    // Timer(Duration(microseconds: 100), () {
    //   _animationController.forward();
    // });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double closeIconSize = 20.0;
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
      ).animate(_animationController),
      child: FadeTransition(
        opacity: _animationController,
        child: Container(
          //margin: const EdgeInsets.only(top: LayoutConst.layoutMargin),
          height: height,
          width: LayoutConst.leftMenuWidth,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: StudioSnippet.basicShadow(direction: ShadowDirection.rightBottum),
          ),
          child: Stack(
            children: [
              Positioned(
                  left: LayoutConst.leftMenuWidth - 2 * closeIconSize - 6,
                  top: 6,
                  child: IconButton(
                    iconSize: closeIconSize,
                    icon: Icon(Icons.keyboard_double_arrow_left_outlined),
                    onPressed: () async {
                      await _animationController.reverse();
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
        ),
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
