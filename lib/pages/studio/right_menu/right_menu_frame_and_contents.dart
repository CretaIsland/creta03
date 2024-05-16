// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors

// 구글맵 임시로 사용안함.
//import 'package:creta03/pages/studio/left_menu/google_map/google_map_contents.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import '../../../../lang/creta_studio_lang.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../data_io/contents_manager.dart';
import '../../../data_io/frame_manager.dart';
import '../../../data_io/link_manager.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../book_main_page.dart';
import '../containees/containee_nofifier.dart';
import '../containees/frame/sticker/mini_menu.dart';
import '../left_menu/left_menu_page.dart';
import '../studio_constant.dart';
import 'contents/contents_ordered_list.dart';
import 'contents/contents_property.dart';
import 'frame/frame_property.dart';
import 'frame/weather_property.dart';
import 'link/link_property.dart';

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
  double horizontalPadding = 19;

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
      _selectedTab = CretaStudioLang['frameTabBar']!.values.first;
    } else if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Contents) {
      var valuesList = CretaStudioLang['frameTabBar']!.values.toList();
      _selectedTab = valuesList[1];
      //print('contents=======================================================');
    } else if (BookMainPage.containeeNotifier!.selectedClass == ContaineeEnum.Link) {
      _selectedTab = CretaStudioLang['frameTabBar']!.values.last;
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
        padding: const EdgeInsets.only(right: 20),
        child: CustomRadioButton(
          radioButtonValue: (value) {
            List<dynamic> menu = CretaStudioLang['frameTabBar']!.values.toList();
            if (value == menu[0]) {
              MiniMenu.setShowFrame(true);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Frame);
            } else if (value == menu[1]) {
              MiniMenu.setShowFrame(false);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Contents);
            } else if (value == menu[2]) {
              MiniMenu.setShowFrame(false);
              BookMainPage.containeeNotifier!.set(ContaineeEnum.Link);
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
          buttonLables: CretaStudioLang['frameTabBar']!.keys.toList(),
          buttonValues: [...CretaStudioLang['frameTabBar']!.values.toList()],
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
    List<dynamic> menu = CretaStudioLang['frameTabBar']!.values.toList();
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
    if (_selectedTab == menu[2]) {
      // ignore: sized_box_for_whitespace
      return Container(
        padding: EdgeInsets.symmetric(vertical: horizontalPadding),
        width: LayoutConst.rightMenuWidth,
        child: _linkProperty(),
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
        // 구글맵 임시로 사용안함.
        // } else if (frame.isMapType()) {
        //   return GoogleMapContents();
      }
      return SizedBox.shrink();
    }
    //print('333333333333333333333333');
    ContentsModel? contents = contentsManager.getCurrentModel();
    if (contents == null) {
      // if (frame.isWeatherTYpe()) {
      //   return WeatherProperty(frameModel: frame, frameManager: frameManager);
      contents = contentsManager.getFirstModel();
      if (contents == null) {
        return SizedBox.shrink();
      }
      // }
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

  Widget _linkProperty() {
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
      return SizedBox.shrink();
    }
    //print('333333333333333333333333');
    ContentsModel? contents = contentsManager.getCurrentModel();
    if (contents == null) {
      return SizedBox.shrink();
    }
    contents = contentsManager.getFirstModel();
    if (contents == null) {
      return SizedBox.shrink();
    }
    LinkManager? linkManager = contentsManager.findLinkManager(contents.mid);
    if (linkManager == null) {
      return SizedBox.shrink();
    }
    LinkModel? linkModel = linkManager.getSelected() as LinkModel?;
    if (linkModel == null) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        LinkProperty(
          key: ValueKey(contents.mid),
          contentsModel: contents,
          linkModel: linkModel,
          frameManager: frameManager,
          book: model,
          onColorChanged: (color) {
            linkModel.bgColor.set(color);
            linkManager.notify();
          },
          onOpacityChanged: (opacity) {
            linkModel.bgColor.set(linkModel.bgColor.value.withOpacity(opacity));
            linkManager.notify();
          },
          onPosChanged: () {
            linkManager.notify();
          },
          onSizeChanged: (size) {
            linkModel.iconSize.set(size);
            linkManager.notify();
          },
          onIconDataChanged: (icon) {
            linkModel.iconData.set(icon);
            linkManager.notify();
          },
        ),
      ],
    );
  }
}
