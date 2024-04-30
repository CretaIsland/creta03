// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:provider/provider.dart';
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../../data_io/book_manager.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../book_main_page.dart';
import '../../studio_constant.dart';
import '../../studio_snippet.dart';
import 'book_editor_property.dart';
import 'book_history_property.dart';
import 'book_info_property.dart';
import 'book_page_property.dart';

class RightMenuBook extends StatefulWidget {
  const RightMenuBook({super.key});

  @override
  State<RightMenuBook> createState() => _RightMenuBookState();
}

class _RightMenuBookState extends State<RightMenuBook> {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 19;

  late String _selectedTab;
  BookModel? _model;
  List<String> hashTagList = [];

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_RightMenuBookState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    _selectedTab = CretaStudioLang['bookInfoTabBar']!.values.map((e) => e.toString()).first;
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookManager>(builder: (context, bookManager, child) {
      _model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
      if (_model == null) {
        return Center(
          child: Text("No CretaBook Selected", style: CretaFont.titleLarge),
        );
      }
      hashTagList = CretaCommonUtils.jsonStringToList(_model!.hashTag.value);
      return Column(
        children: [
          _menuBar(),
          _pageView(),
        ],
      );
    });
  }

  Widget _menuBar() {
    return Container(
      height: StudioSnippet.getMenuBarHeight(),
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
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
        buttonLables: CretaStudioLang['bookInfoTabBar']!.keys.toList(),
        buttonValues: [...CretaStudioLang['bookInfoTabBar']!.values.toList()],
        selectedBorderColor: Colors.transparent,
        unSelectedBorderColor: Colors.transparent,
        elevation: 0,
        enableButtonWrap: true,
        enableShape: true,
        shapeRadius: 60,
        //child: CretaTabButton(
        // onEditComplete: (value) {
        //   setState(() {
        //     _selectedTab = value;
        //   });
        // },
        // width: 95,
        // height: 24,
        // selectedTextColor: CretaColor.primary,
        // unSelectedTextColor: CretaColor.text[700]!,
        // selectedColor: Colors.white,
        // unSelectedColor: CretaColor.text[100]!,
        // defaultString: CretaStudioLang['bookInfoTabBar']!.values.first,
        // buttonLables: CretaStudioLang['bookInfoTabBar']!.keys.toList(),
        // buttonValues: CretaStudioLang['bookInfoTabBar']!.values.toList(),
      ),
    );
  }

  Widget _pageView() {
    //List<dynamic> menu = CretaStudioLang['bookInfoTabBar']!.values.toList();
    List<dynamic> menu = CretaStudioLang['bookInfoTabBar']!
        .values
        .map((e) => e.toString()) // 강제로 String으로 형변환
        .toList();
    //List<String> menu = bookInfoTabBar;
    if (_selectedTab == menu[0]) {
      return Container(
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: BookInfoProperty(
            model: _model!,
            parentNotify: () {
              setState(() {});
            }),
      );
    }
    if (_selectedTab == menu[1]) {
      // ignore: sized_box_for_whitespace
      return Container(
        padding: EdgeInsets.symmetric(vertical: horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: BookPageProperty(
            model: _model!,
            parentNotify: () {
              setState(() {});
            }),
      );
    }
    if (_selectedTab == menu[2]) {
      return Container(
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: BookEditorProperty(
            model: _model!,
            parentNotify: () {
              setState(() {});
            }),
      );
    }
    if (_selectedTab == menu[3]) {
      return Container(
        padding: EdgeInsets.all(horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: BookHistoryProperty(
            model: _model!,
            parentNotify: () {
              setState(() {});
            }),
      );
    }
    return SizedBox.shrink();
  }
}

// class _Chip extends StatelessWidget {
//   const _Chip({
//     required this.label,
//     required this.onDeleted,
//     required this.index,
//   });

//   final String label;
//   final ValueChanged<int> onDeleted;
//   final int index;

//   @override
//   Widget build(BuildContext context) {
//     return Chip(
//       clipBehavior: Clip.antiAlias,
//       backgroundColor: Colors.white,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(24),
//         side: BorderSide(
//           width: 1,
//           color: CretaColor.text[700]!,
//         ),
//       ),
//       labelPadding: const EdgeInsets.symmetric(horizontal: 4.0),
//       label: Text(
//         '#$label',
//         style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
//       ),
//       deleteIcon: Icon(
//         Icons.close,
//         size: 18,
//       ),
//       onDeleted: () {
//         onDeleted(index);
//       },
//     );
//   }
// }
