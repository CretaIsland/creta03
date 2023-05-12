// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../../../design_system/creta_color.dart';
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

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = (40 + 286 + 20);
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;

const double _itemMinWidth = 290.0;
const double _itemMinHeight = 230.0;

class CommunityRightSubscriptionPane extends StatefulWidget {
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final String selectedUserId;
  const CommunityRightSubscriptionPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    this.selectedUserId = '',
  });

  @override
  State<CommunityRightSubscriptionPane> createState() => _CommunityRightSubscriptionPaneState();
}

class _CommunityRightSubscriptionPaneState extends State<CommunityRightSubscriptionPane> {
  late List<CretaBookData> _cretaBookList;
  final _itemSizeRatio = _itemMinHeight / _itemMinWidth;
  double _itemWidth = 0;
  double _itemHeight = 0;

  @override
  void initState() {
    super.initState();

    if (widget.selectedUserId.isEmpty) {
      _cretaBookList = CommunitySampleData.getCretaBookList();
    } else {
      List<CretaBookData> allCretaBookList = CommunitySampleData.getCretaBookList();
      _cretaBookList = [];
      for (final cretaBookData in allCretaBookList) {
        if (cretaBookData.creator != widget.selectedUserId) continue;
        _cretaBookList.add(cretaBookData);
      }
    }
  }

  List<Widget> _getSubscriptionUserList() {
    List<Widget> widgetList = [];
    for (final cretaBookData in _cretaBookList) {
      widgetList.add(
        CretaBookItem(
          key: cretaBookData.uiKey,
          cretaBookData: cretaBookData,
          width: _itemWidth,
          height: _itemHeight,
        ),
      );
    }
    return widgetList;
  }

  Widget _getItemPane() {
    final width = widget.cretaLayoutRect.childWidth - 286 - 20;
    final int columnCount = CretaUtils.getItemColumnCount(width, _itemMinWidth, _rightViewItemGapX);
    _itemWidth = ((width + _rightViewItemGapX) ~/ columnCount) - _rightViewItemGapX;
    _itemHeight = _itemWidth * _itemSizeRatio;

    return SizedBox(
      width: widget.cretaLayoutRect.childWidth, // - 286,
      height: widget.cretaLayoutRect.childHeight, // - 40,
      child: Scrollbar(
        controller: widget.scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              widget.cretaLayoutRect.childLeftPadding + 286 + 20,
              widget.cretaLayoutRect.childTopPadding,
              widget.cretaLayoutRect.childRightPadding,
              widget.cretaLayoutRect.childBottomPadding,
            ),
            child: Wrap(
              direction: Axis.horizontal,
              spacing: _rightViewItemGapX, // 좌우 간격
              runSpacing: _rightViewItemGapY, // 상하 간격
              children: _getSubscriptionUserList(),
            ),
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
