// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:intl/intl.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../../design_system/creta_color.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
//import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
import '../../../common/creta_utils.dart';
import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../creta_playlist_ui_item.dart';
//import 'package:deep_collection/deep_collection.dart';
import '../../../design_system/creta_font.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;
//
const double _itemMinWidth = 290.0;
const double _itemMinHeight = 230.0;

class CommunityRightWatchHistoryPane extends StatefulWidget {
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  const CommunityRightWatchHistoryPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
  });

  @override
  State<CommunityRightWatchHistoryPane> createState() => _CommunityRightWatchHistoryPaneState();
}

class _CommunityRightWatchHistoryPaneState extends State<CommunityRightWatchHistoryPane> {
  late Map<String, List<CretaBookData>> _cretaBookDataMap;
  final _itemSizeRatio = _itemMinHeight / _itemMinWidth;
  double _itemWidth = 0;
  double _itemHeight = 0;

  @override
  void initState() {
    super.initState();

    _cretaBookDataMap = _rearrangeCretaBookData(CommunitySampleData.getCretaBookList());
  }

  // <!-- my code
  // Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
  //   Map<String, List<CretaBookData>> rearrangeMap = {};
  //   for(CretaBookData bookData in bookDataList) {
  //     String createDate = '${bookData.createDate.year}.${bookData.createDate.month}.${bookData.createDate.day}';
  //     List<CretaBookData>? dataList = rearrangeMap[createDate];
  //     if (dataList == null) {
  //       rearrangeMap[createDate] = [bookData];
  //     } else {
  //       dataList.add(bookData);
  //     }
  //   }
  //   return rearrangeMap;
  // }
  // -->
  // <!-- GPT3.5 code
  // Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
  //   final Map<String, List<CretaBookData>> rearrangeMap = {};
  //   for (final bookData in bookDataList) {
  //     final String createDate = bookData.createDate.toString("yyyy.MM.dd");
  //     rearrangeMap.putIfAbsent(createDate, () => []).add(bookData);
  //   }
  //   return rearrangeMap;
  // }
  // -->
  // <!-- final code
  Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
    final Map<String, List<CretaBookData>> rearrangeMap = {};
    for (final bookData in bookDataList) {
      final String createDate = DateFormat('yyyy.MM.dd').format(bookData.createDate);
      rearrangeMap.putIfAbsent(createDate, () => []).add(bookData);
    }
    return rearrangeMap;
  }
  // -->

  // <!-- my code
  // List<Widget> _getItemWidgetList() {
  //   final List<Widget> itemWidgetList = [];
  //   final List<String> keyList = _cretaBookDataMap.deepSortByKey().keys.toList();
  //   for (int i = keyList.length - 1; i >= 0; i--) {
  //     final String key = keyList[i];
  //     final List<CretaBookData>? dataList = _cretaBookDataMap[key];
  //     if (dataList == null) continue;
  //     itemWidgetList.add(Text(key));
  //     itemWidgetList.add(Wrap(
  //       children: dataList
  //           .map((data) => CretaBookItem(key: data.uiKey, cretaBookData: data, width: 320, height: 240))
  //           .toList(),
  //     ));
  //   }
  //   return itemWidgetList;
  // }
  // -->
  // <!-- GPT3.5
  // List<Widget> _getItemWidgetList() {
  //   final List<Widget> itemWidgetList = [];
  //   final List<String> keyList = _cretaBookDataMap.keys.toList()..sort();
  //   for (final key in keyList.reversed) {
  //     final List<CretaBookData>? dataList = _cretaBookDataMap[key];
  //     if (dataList == null) continue;
  //     itemWidgetList
  //       ..add(Text(key))
  //       ..addAll(dataList.expand((data) => [
  //       CretaBookItem(key: data.uiKey, cretaBookData: data, width: 320, height: 240),
  //     ]));
  //   }
  //   return itemWidgetList;
  // }
  // -->
  // <!-- final code
  List<Widget> _getItemWidgetList(double width) {
    final List<Widget> itemWidgetList = [];
    final List<String> keyList = _cretaBookDataMap.keys.toList()..sort();
    for (final key in keyList.reversed) {
      final List<CretaBookData> dataList = _cretaBookDataMap[key] ?? [];
      itemWidgetList
        ..add(Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            key,
            style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
          ),
        ))
        ..add(Wrap(
          direction: Axis.horizontal,
          spacing: _rightViewItemGapX, // 좌우 간격
          runSpacing: _rightViewItemGapY, // 상하 간격
          children: dataList
              .map(
                  (data) => CretaBookItem(key: data.uiKey, cretaBookData: data, width: _itemWidth, height: _itemHeight))
              .toList(),
        ));
    }
    return itemWidgetList;
  }
  // -->

  Widget _getItemPane() {
    final width = widget.cretaLayoutRect.childWidth;
    final int columnCount = CretaUtils.getItemColumnCount(width, _itemMinWidth, _rightViewItemGapX);
    _itemWidth = ((width + _rightViewItemGapX) ~/ columnCount) - _rightViewItemGapX;
    _itemHeight = _itemWidth * _itemSizeRatio;
    return SizedBox(
      width: widget.cretaLayoutRect.width,
      child: SingleChildScrollView(
        controller: widget.scrollController,
        child: Container(
          padding: EdgeInsets.fromLTRB(
            widget.cretaLayoutRect.childLeftPadding,
            widget.cretaLayoutRect.childTopPadding,
            widget.cretaLayoutRect.childRightPadding,
            widget.cretaLayoutRect.childBottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _getItemWidgetList(widget.cretaLayoutRect.childWidth),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _getItemPane();
  }
}
