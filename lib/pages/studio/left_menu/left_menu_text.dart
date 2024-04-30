// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:creta03/pages/studio/left_menu/word_pad/left_wordpad_template.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_font.dart';
import '../../../lang/creta_studio_lang.dart';
import 'package:creta_common/common/creta_color.dart';
//import '../studio_constant.dart';
import '../studio_constant.dart';
import 'text/left_text_template.dart';

class LeftMenuText extends StatefulWidget {
  const LeftMenuText({super.key});

  @override
  State<LeftMenuText> createState() => _LeftMenuTextState();
}

class _LeftMenuTextState extends State<LeftMenuText> {
  final double verticalPadding = 10;
  final double horizontalPadding = 19;
  //final double cardHeight = 246;
  final double headerHeight = 36;
  final double menuBarHeight = 36;

  final double borderThick = 4;

  late double bodyHeight;
  late double bodyWidth;
  late double cardHeight;

  double itemWidth = -1;
  double itemHeight = -1;

  late String _selectedTab;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _menuBar(),
        _textView(),
      ],
    );
  }

  @override
  void initState() {
    logger.fine('_LeftMenuPageState.initState');
    _selectedTab = CretaStudioLang['textMenuTabBar']!.values.first;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _menuBar() {
    return Container(
      height: LayoutConst.innerMenuBarHeight, //StudioSnippet.getMenuBarHeight(),
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: CustomRadioButton(
          radioButtonValue: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          width: 95,
          autoWidth: true,
          height: 24,
          buttonTextStyle: ButtonTextStyle(
            selectedColor: CretaColor.primary,
            unSelectedColor: CretaColor.text[700]!,
            textStyle: CretaFont.buttonMedium,
          ),
          selectedColor: Colors.white,
          unSelectedColor: CretaColor.text[100]!,
          defaultSelected: _selectedTab,
          buttonLables: CretaStudioLang['textMenuTabBar']!.keys.toList(),
          buttonValues: [...CretaStudioLang['textMenuTabBar']!.values.toList()],
          selectedBorderColor: Colors.transparent,
          unSelectedBorderColor: Colors.transparent,
          elevation: 0,
          enableButtonWrap: true,
          enableShape: true,
          shapeRadius: 60,
        ),
      ),
    );
  }

  Widget _textView() {
    List<dynamic> menu = CretaStudioLang['textMenuTabBar']!.values.toList();
    if (_selectedTab == menu[0]) {
      // 텍스트 추가
      return Container(
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: LeftTextTemplate(),
      );
    }
    if (_selectedTab == menu[1]) {
      // ignore: sized_box_for_whitespace
      return Container(
        // padding: EdgeInsets.symmetric(vertical: horizontalPadding),
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        //child: Center(child: Text('HTML EDITOR')),
        child: LeftWordPadTemplate(),
      );
    }
    if (_selectedTab == menu[2]) {
      return Container(
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: Center(child: Text(_selectedTab)),
      );
    }

    return SizedBox.shrink();
  }
}
