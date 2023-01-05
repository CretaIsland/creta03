// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_brace_in_string_interps

//import 'dart:ui';

import 'package:creta03/lang/creta_studio_lang.dart';
import 'package:creta03/model/connected_user_model.dart';
import 'package:creta03/pages/studio/sample_data.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../common/creta_constant.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_label_text_editor.dart';
import '../../design_system/buttons/creta_scale_button.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/creta_font.dart';
import '../../model/book_model.dart';
import 'left_menu.dart';
import 'stick_menu.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';
//import 'package:cross_scroll/cross_scroll.dart';

class BookMainPage extends StatefulWidget {
  final BookModel model;

  const BookMainPage({super.key, required this.model});

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  final ScrollController controller = ScrollController();
  double pageWidth = 0;
  double pageHeight = 0;
  double pageTop = 0;
  double pageLeft = 0;
  double physicalRatio = 0;
  double widthRatio = 0;
  double heightRatio = 0;

  LeftMenuEnum selectedStick = LeftMenuEnum.None;
  @override
  Widget build(BuildContext context) {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width; // 전체화면의 80% 만쓴다.
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;

    StudioVariables.workWidth = StudioVariables.displayWidth - LayoutConst.menuStickWidth;
    StudioVariables.workHeight =
        StudioVariables.displayHeight - CretaConstant.appbarHeight - LayoutConst.topMenuBarHeight;

    StudioVariables.workRatio = StudioVariables.workHeight / StudioVariables.workWidth;

    //StudioVariables.workHorizontalMargin = workHeight * 0.01;
    //StudioVariables.workVerticalMargin = workHeight * 0.01;

    return Snippet.CretaScaffold(
      title: Snippet.logo('studio'),
      context: context,
      child: Container(
        color: LayoutConst.studioBGColor,
        child: Column(
          children: [
            topMenu(),
            SizedBox(
              height: StudioVariables.workHeight,
              child: Row(
                children: [
                  StickMenu(
                    selectFunction: showLeftMenu,
                    initSelected: selectedStick,
                  ),
                  Expanded(
                    child: Stack(children: [
                      drawPage(context, 1920, 1080),
                      selectedStick == LeftMenuEnum.None
                          ? Container(width: 1, height: 1, color: Colors.transparent)
                          : LeftMenu(
                              selectedStick: selectedStick,
                              onClose: () {
                                setState(() {
                                  selectedStick = LeftMenuEnum.None;
                                });
                              },
                            ),
                      // bottomMenuBar(
                      //     selectedStick == LeftMenuEnum.None ? 0 : LayoutConst.leftMenuWidth),
                    ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topMenu() {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: StudioSnippet.basicShadow(),
        ),
        height: LayoutConst.topMenuBarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Icon(Icons.menu_outlined),
                SizedBox(width: 8),
                CretaLabelTextEditor(
                  height: 32,
                  width: 300,
                  text: widget.model.name,
                  textStyle: CretaFont.titleSmall,
                ),
              ],
            ),
            Visibility(
              visible: StudioVariables.workWidth > 725 ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VerticalDivider(),
                  CretaScaleButton(
                    onPressedMinus: () {},
                    onPressedPlus: () {},
                    onPressedAutoScale: () {},
                    defaultScale: widthRatio,
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.volume_off_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.pause_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  VerticalDivider(),
                  BTN.floating_l(
                    icon: Icons.undo_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.redo_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: StudioVariables.workWidth > 1032 ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: SampleData.connectedUserList.map((e) {
                  return SizedBox(
                    width: 34,
                    height: 34,
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: CircleAvatar(
                        //radius: 28,
                        backgroundColor: e.state == ActiveState.active ? Colors.red : Colors.grey,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: CircleAvatar(
                            //radius: 25,
                            backgroundImage: e.image,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Visibility(
              visible: StudioVariables.workWidth > LayoutConst.minWorkWidth ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VerticalDivider(),
                  BTN.floating_l(
                    icon: Icons.person_add_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.file_download_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.smart_display_outlined,
                    onPressed: () {},
                    hasShadow: false,
                  ),
                  SizedBox(width: 8),
                  BTN.line_blue_it_m_animation(
                      text: CretaStudioLang.publish,
                      image: NetworkImage(
                          'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      onPressed: () {}),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ],
        ));
  }

  Widget drawPage(BuildContext context, double pagePhysicalWidth, double pagePhysicalHeight) {
    //if (pageWidth > pageHeight) {}
    logger.fine(
        "height=${StudioVariables.workHeight}, width=${StudioVariables.workWidth}, top=0, left=0,");

    widthRatio = StudioVariables.workWidth / pagePhysicalWidth;
    heightRatio = StudioVariables.workHeight / pagePhysicalHeight;
    physicalRatio = pagePhysicalHeight / pagePhysicalWidth;

    if (widthRatio < heightRatio) {
      pageWidth = StudioVariables.workWidth * 0.9;
      pageHeight = pageWidth * physicalRatio;
    } else {
      pageHeight = StudioVariables.workHeight * 0.9;
      pageWidth = pageHeight / physicalRatio;
    }
    pageLeft = StudioVariables.workWidth * 0.1;
    pageTop = StudioVariables.workHeight * 0.1;

    return Center(
      child: Container(
        width: StudioVariables.workWidth,
        height: StudioVariables.workHeight,
        color: LayoutConst.studioBGColor,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: StudioSnippet.basicShadow(),
            ),
            width: pageWidth,
            height: pageHeight,
          ),
        ),
      ),
    );
  }

  Widget bottomMenuBar(double leftOffset) {
    return Positioned(
      top: StudioVariables.workHeight - LayoutConst.bottomMenuBarHeight,
      left: leftOffset,
      child: Center(
        child: Container(
          height: LayoutConst.bottomMenuBarHeight,
          width: StudioVariables.workWidth - leftOffset,
          color: Colors.grey.withOpacity(0.2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CretaScaleButton(
                    onPressedMinus: () {},
                    onPressedPlus: () {},
                    onPressedAutoScale: () {},
                    defaultScale: widthRatio,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BTN.floating_l(
                    icon: Icons.volume_off_outlined,
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BTN.floating_l(
                    icon: Icons.pause_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BTN.floating_l(
                    icon: Icons.undo_outlined,
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  BTN.floating_l(
                    icon: Icons.redo_outlined,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showLeftMenu(LeftMenuEnum idx) {
    logger.finest("showLeftMenu ${idx.name}");
    setState(() {
      if (selectedStick == idx) {
        selectedStick = LeftMenuEnum.None;
      } else {
        selectedStick = idx;
      }
    });
  }
}
