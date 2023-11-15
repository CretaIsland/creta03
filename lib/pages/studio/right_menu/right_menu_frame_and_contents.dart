// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

import 'package:creta03/pages/studio/left_menu/google_map/google_map_contents.dart';
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
import '../../../model/page_model.dart';
import '../book_main_page.dart';
import '../containees/containee_nofifier.dart';
import '../containees/frame/sticker/mini_menu.dart';
import '../left_menu/left_menu_page.dart';
import '../studio_constant.dart';
import 'contents/contents_ordered_list.dart';
import 'contents/contents_property.dart';
import 'frame/frame_property.dart';
import 'frame/weather_property.dart';

class RightMenuFrameAndContents extends StatefulWidget {
  //final String selectedTap;
  const RightMenuFrameAndContents({
    super.key,
    /* required this.selectedTap */
  });

  @override
  State<RightMenuFrameAndContents> createState() => _RightMenuFrameAndContentsState();
}

class _RightMenuFrameAndContentsState extends State<RightMenuFrameAndContents> {
  // ignore: unused_field
  //late ScrollController _scrollController;
  double horizontalPadding = 24;

  String _selectedTab = '';

  @override
  void initState() {
    //_scrollController.addListener(_scrollListener);
    logger.fine('_RightMenuFrameAndContentsState.initState');
    //_scrollController = ScrollController(initialScrollOffset: 0.0);
    //_selectedTab = widget.selectedTap;
    super.initState();
  }

  @override
  void dispose() {
    //_scrollController.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Frame) {
      //print('frame=======================================================');
      _selectedTab = CretaStudioLang.frameTabBar.values.first;
    } else if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Contents) {
      _selectedTab = CretaStudioLang.frameTabBar.values.last;
      //print('contents=======================================================');
    } else {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        _tabBar(),
        _pageView(),
      ],
    );
  }

  Widget _tabBar() {
    logger.fine('selectedTab = $_selectedTab--------------------------------');

    return Container(
      height: LayoutConst.innerMenuBarHeight,
      width: LayoutConst.rightMenuWidth,
      color: CretaColor.text[100]!,
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(right: 150),
        child: CustomRadioButton(
          radioButtonValue: (value) {
            List<String> menu = CretaStudioLang.frameTabBar.values.toList();
            if (value == menu[0]) {
              MiniMenu.setShowFrame(true);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
            } else if (value == menu[1]) {
              MiniMenu.setShowFrame(false);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents);
            }
            setState(() {
              _selectedTab = value;
            });
            LeftMenuPage.treeInvalidate();
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
    PageModel? page = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frame == null) {
      return Container();
    }
    return FrameProperty(key: ValueKey(frame.mid), model: frame, pageModel: page);
  }

  Widget _contentsProperty() {
    //print('1111111111111111111111111111111111');
    BookModel? model = BookMainPage.bookManagerHolder?.onlyOne() as BookModel?;
    FrameModel? frame = BookMainPage.pageManagerHolder!.getSelectedFrame();
    if (frame == null) {
      logger.severe('Something wrong, selected Frame is null');
      return SizedBox.shrink();
    }
    // if (frame.isOverlay.value == true) {
    //   //print('this is overlay frame');
    // }
    FrameManager? frameManager =
        BookMainPage.pageManagerHolder!.findFrameManager(frame.parentMid.value);
    //FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      logger.severe('Something wrong, frameManager is null');
      return SizedBox.shrink();
    }

    //print('222222222222222222222222222222');
    ContentsManager? contentsManager = frameManager.getContentsManager(frame.mid);
    if (contentsManager == null || contentsManager.getAvailLength() == 0) {
      if (frame.isWeatherTYpe()) {
        return WeatherProperty(frameModel: frame, frameManager: frameManager);
      } else if (frame.isMapType()) {
        // return GoogleMapSavedList();
        return GoogleMapContents();
      }
      return SizedBox.shrink();
    }
    //print('333333333333333333333333');
    ContentsModel? contents = contentsManager.getCurrentModel();
    if (contents == null) {
      // if (frame.isWeatherTYpe()) {
      //   return WeatherProperty(frameModel: frame, frameManager: frameManager);
      // }
      return SizedBox.shrink();
    }

    contents = contentsManager.getFirstModel();
    if (contents == null) {
      return SizedBox.shrink();
    }
    //print('44444444444444444444444444444444');
    //logger.fine('ContentsProperty ${contents.mid}-----------------');
    //logger.fine('ContentsProperty ${contents.font.value}----------');
    return Column(
      children: [
        ContentsOrderedList(
            book: model, frameManager: frameManager, contentsManager: contentsManager),
        ContentsProperty(
            key: ValueKey(contents.mid), model: contents, frameManager: frameManager, book: model),
      ],
    );
  }
}
