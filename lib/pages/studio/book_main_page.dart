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
import '../../design_system/component/cross_scrollbar.dart';
import 'left_menu.dart';
import 'stick_menu.dart';
import 'studio_constant.dart';
import 'studio_snippet.dart';
import 'studio_variables.dart';

class BookMainPage extends StatefulWidget {
  final BookModel model;

  const BookMainPage({super.key, required this.model});

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  final ScrollController controller = ScrollController();
  final ScrollController horizontalScroll = ScrollController();
  final ScrollController verticalScroll = ScrollController();

  double pageWidth = 0;
  double pageHeight = 0;
  double physicalRatio = 0;
  double widthRatio = 0;
  double heightRatio = 0;
  double applyScale = 1;
  bool scaleChanged = false;

  LeftMenuEnum selectedStick = LeftMenuEnum.None;
  @override
  Widget build(BuildContext context) {
    _resize();
    return Snippet.CretaScaffold(
      title: Snippet.logo('studio'),
      context: context,
      child: _mainPage(),
    );
  }

  void _resize() {
    StudioVariables.displayWidth = MediaQuery.of(context).size.width;
    StudioVariables.displayHeight = MediaQuery.of(context).size.height;

    StudioVariables.workWidth = StudioVariables.displayWidth - LayoutConst.menuStickWidth;
    StudioVariables.workHeight =
        StudioVariables.displayHeight - CretaConstant.appbarHeight - LayoutConst.topMenuBarHeight;
    StudioVariables.workRatio = StudioVariables.workHeight / StudioVariables.workWidth;

    applyScale = StudioVariables.scale / StudioVariables.fitScale;
    if (StudioVariables.autoScale == true || scaleChanged == true) {
      StudioVariables.virtualWidth = StudioVariables.workWidth * applyScale;
      StudioVariables.virtualHeight = StudioVariables.workHeight * applyScale;
    }
    scaleChanged = false;

    StudioVariables.availWidth = StudioVariables.virtualWidth * 0.9;
    StudioVariables.availHeight = StudioVariables.virtualHeight * 0.9;

    widthRatio = StudioVariables.availWidth / widget.model.width;
    heightRatio = StudioVariables.availHeight / widget.model.height;
    physicalRatio = widget.model.height / widget.model.width;

    if (widthRatio < heightRatio) {
      pageWidth = StudioVariables.availWidth;
      pageHeight = pageWidth * physicalRatio;
      if (StudioVariables.autoScale == true) {
        StudioVariables.fitScale = widthRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = widthRatio;
      }
    } else {
      pageHeight = StudioVariables.availHeight;
      pageWidth = pageHeight / physicalRatio;
      if (StudioVariables.autoScale == true) {
        StudioVariables.fitScale = heightRatio; // 화면에 꽉찾을때의 최적의 값
        StudioVariables.scale = heightRatio;
      }
    }

    logger.fine(
        "height=${StudioVariables.workHeight}, width=${StudioVariables.workWidth}, scale=${StudioVariables.fitScale}}");
  }

  Widget _mainPage() {
    if (StudioVariables.workHeight < 1) {
      return Container();
    }
    return Column(
      children: [
        _topMenu(),
        Container(
          color: LayoutConst.studioBGColor,
          height: StudioVariables.workHeight,
          child: Row(
            children: [
              StickMenu(
                selectFunction: _showLeftMenu,
                initSelected: selectedStick,
              ),
              Expanded(
                child: _workArea(),
              ),
              // StudioVariables.autoScale == true
              //     ? Expanded(
              //         child: _workArea(),
              //       )
              //     : SizedBox(
              //         width: StudioVariables.workWidth,
              //         child: _workArea(),
              //       )
            ],
          ),
        ),
      ],
    );
  }

  Widget _workArea() {
    return Stack(children: [
      _scrollArea(context),
      selectedStick == LeftMenuEnum.None
          ? Container(width: 0, height: 0, color: Colors.transparent)
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
    ]);
  }

  Widget _topMenu() {
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
            Visibility(
              // 제목
              visible: StudioVariables.workHeight > 1 ? true : false,
              child: Row(
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
            ),
            Visibility(
              // Scale, Undo
              visible:
                  StudioVariables.workHeight > 1 && StudioVariables.workWidth > 800 ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VerticalDivider(),
                  CretaScaleButton(
                    onPressedMinus: () {
                      setState(() {
                        scaleChanged = true;
                      });
                    },
                    onPressedPlus: () {
                      setState(() {
                        scaleChanged = true;
                      });
                    },
                    onPressedAutoScale: () {
                      setState(() {
                        scaleChanged = StudioVariables.autoScale;
                        logger.finest("scaleChanged=$scaleChanged");
                      });
                    },
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipScale,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.volume_off_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipVolume,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.pause_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipPause,
                  ),
                  BTN.floating_l(
                    icon: Icons.undo_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipUndo,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.redo_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipRedo,
                  ),
                  VerticalDivider(),
                ],
              ),
            ),
            Visibility(
              // 아바타
              visible:
                  StudioVariables.workHeight > 1 && StudioVariables.workWidth > 1100 ? true : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: SampleData.connectedUserList.map((e) {
                  return Snippet.TooltipWrapper(
                    tooltip: e.name,
                    bgColor: (e.state == ActiveState.active ? Colors.red : Colors.grey),
                    fgColor: Colors.white,
                    child: SizedBox(
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
                    ),
                  );
                }).toList(),
              ),
            ),
            Visibility(
              //  발행하기 등
              visible: StudioVariables.workHeight > 1 &&
                      StudioVariables.workWidth > LayoutConst.minWorkWidth
                  ? true
                  : false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  VerticalDivider(),
                  BTN.floating_l(
                    icon: Icons.person_add_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipInvite,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.file_download_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipDownload,
                  ),
                  SizedBox(width: 8),
                  BTN.floating_l(
                    icon: Icons.smart_display_outlined,
                    onPressed: () {},
                    hasShadow: false,
                    tooltip: CretaStudioLang.tooltipPlay,
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

  Widget _scrollArea(BuildContext context) {
    // if (StudioVariables.autoScale == true ||
    //     StudioVariables.scale - StudioVariables.fitScale <= 0) {
    if (StudioVariables.autoScale == true) {
      return _drawPage(context);
    }
    return CrossScrollBar(
      key: GlobalKey(),
      width: StudioVariables.virtualWidth,
      child: _drawPage(context),
    );
  }

  Widget _drawPage(BuildContext context) {
    return Center(
      child: Container(
        width: StudioVariables.virtualWidth,
        height: StudioVariables.virtualHeight,
        //color: LayoutConst.studioBGColor,
        color: Colors.amber,
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

  void _showLeftMenu(LeftMenuEnum idx) {
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
