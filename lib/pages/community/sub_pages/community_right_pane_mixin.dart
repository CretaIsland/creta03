// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
// import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
// import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
// import '../creta_book_ui_item.dart';
// import '../community_sample_data.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
// const double _rightViewBannerMinHeight = 188 + 4;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;

bool isInUsingCanvaskit = false;

mixin CommunityRightPaneMixin {

  final ScrollController _itemPaneScrollController = ScrollController();
  double _headerSize = double.infinity;
  double _scrollOffset = 0;
  double _topPaneMaxHeight = double.infinity;
  double _topPaneMinHeight = double.infinity;
  void Function()? _scrollChangedCallback;
  List<Widget> Function(Size)? _getTopPane;
  Widget Function(Size)? _getItemPane;

  double get getHeaderSize => _headerSize;
  ScrollController get getItemPaneScrollController => _itemPaneScrollController;

  void initSuperMixin(
      {required double topPaneMaxHeight,
      required double topPaneMinHeight,
      required void Function() scrollChangedCallback,
      required List<Widget> Function(Size) topPaneFunc,
      required Widget Function(Size) itemPaneFunc}) {
    _itemPaneScrollController.addListener(scrollListener);
    _headerSize = topPaneMaxHeight;
    _topPaneMaxHeight = topPaneMaxHeight;
    _topPaneMinHeight = topPaneMinHeight;
    _scrollChangedCallback = scrollChangedCallback;
    _getTopPane = topPaneFunc;
    _getItemPane = itemPaneFunc;
  }

  void scrollListener() {
    _scrollOffset = _itemPaneScrollController.offset;
    _headerSize = _topPaneMaxHeight - _itemPaneScrollController.offset;
    if (_headerSize < _topPaneMinHeight) _headerSize = _topPaneMinHeight;
    if (_scrollChangedCallback != null) _scrollChangedCallback!();
  }

  Size _itemPaneSize = Size.zero;
  Size _topPaneSize = Size.zero;
  void _resizePane(Size paneSize) {
    _itemPaneSize = Size(paneSize.width, paneSize.height);
    _topPaneSize = Size(paneSize.width - _scrollbarWidth, _headerSize);
  }

  Widget mainPage(Size paneSize) {
    _resizePane(paneSize);
    return Stack(
      children: [
        // 아이템
        Container(
          width: _itemPaneSize.width,
          height: _itemPaneSize.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.orange,
          ),
          child: Container(
            color: Colors.white,
            child: _getItemPane!(_itemPaneSize),
          ),
        ),
        // 배너
        Listener(
          onPointerSignal: (PointerSignalEvent event) {
            if (event is PointerScrollEvent) {
              //print('x: ${event.position.dx}, y: ${event.position.dy}');
              //print('scroll delta: ${event.scrollDelta}');
              _scrollOffset += event.scrollDelta.dy;
              if (_scrollOffset < 0) _scrollOffset = 0;
              if (_scrollOffset > _itemPaneScrollController.position.maxScrollExtent) {
                _scrollOffset = _itemPaneScrollController.position.maxScrollExtent;
              }
              //itemPaneScrollController.animateTo(scrollOffset, duration: Duration(milliseconds: 1), curve: Curves.easeIn);
              _itemPaneScrollController.jumpTo(_scrollOffset);
            }
          },
          child: Container(
            width: _topPaneSize.width,
            height: _topPaneSize.height,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
            ),
            child: Stack(
              children: [
                ..._getTopPane!(_topPaneSize),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
