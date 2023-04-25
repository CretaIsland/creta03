// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import '../../../../design_system/creta_color.dart';
import '../../../../design_system/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import '../../../../model/book_model.dart';
import '../../../data_io/contents_manager.dart';
import '../../../data_io/frame_manager.dart';
import '../../../model/contents_model.dart';
import '../../../model/frame_model.dart';
import '../book_main_page.dart';
import '../studio_constant.dart';
import 'contents/contents_ordered_list.dart';
import 'contents/contents_property.dart';
import 'frame/frame_property.dart';

class RightMenuFrameAndContents extends StatefulWidget {
  final String selectedTap;
  const RightMenuFrameAndContents({super.key, required this.selectedTap});

  @override
  State<RightMenuFrameAndContents> createState() => _RightMenuFrameAndContentsState();
}

class _RightMenuFrameAndContentsState extends State<RightMenuFrameAndContents> {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;

  late String _selectedTab;

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.finer('_RightMenuFrameAndContentsState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    _selectedTab = widget.selectedTap;
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _tabBar(),
        _pageView(),
      ],
    );
  }

  Widget _tabBar() {
    logger.info('selectedTab = $_selectedTab--------------------------------');

    return Container(
      height: LayoutConst.innerMenuBarHeight,
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 150),
        child: CustomRadioButton(
          radioButtonValue: (value) {
            setState(() {
              _selectedTab = value;
            });
          },
          width: 84,
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
          buttonLables: CretaStudioLang.frameTabBar.keys.toList(),
          buttonValues: CretaStudioLang.frameTabBar.values.toList(),
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

  Widget _pageView() {
    List<String> menu = CretaStudioLang.frameTabBar.values.toList();
    if (_selectedTab == menu[0]) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: _frameProperty(),
      );
    }
    if (_selectedTab == menu[1]) {
      // ignore: sized_box_for_whitespace
      return Container(
        padding: EdgeInsets.symmetric(vertical: horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: _contentsProperty(),
      );
    }

    return SizedBox.shrink();
  }

  Widget _frameProperty() {
    FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frame == null) {
      return Container();
    }
    return FrameProperty(key: ValueKey(frame.mid), model: frame);
  }

  Widget _contentsProperty() {
    BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
    FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frame != null && frameManager != null) {
      ContentsManager? contentsManager = frameManager.getContentsManager(frame.mid);
      ContentsModel? contents = frameManager.getCurrentModel(frame.mid);
      if (contents != null) {
        logger.info('ContentsProperty ${contents.mid}');
        return Column(
          children: [
            if (contentsManager != null) ContentsOrderedList(contentsManager: contentsManager),
            ContentsProperty(
                key: ValueKey(contents.mid),
                model: contents,
                frameManager: frameManager,
                book: model),
          ],
        );
      }
    }
    return Container();
  }
}
