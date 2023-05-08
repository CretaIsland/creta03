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
//import '../design_system/creta_color.dart';
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
//import '../creta_book_ui_item.dart';
import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../creta_playlist_ui_item.dart';

//const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;
//
const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;

class CommunityRightPlaylistPane extends StatefulWidget {
  final double pageWidth;
  final double pageHeight;
  final ScrollController scrollController;
  const CommunityRightPlaylistPane({
    super.key,
    required this.pageWidth,
    required this.pageHeight,
    required this.scrollController,
  });

  @override
  State<CommunityRightPlaylistPane> createState() => _CommunityRightPlaylistPaneState();
}

class _CommunityRightPlaylistPaneState extends State<CommunityRightPlaylistPane> {
  late List<CretaPlaylistData> _cretaPlaylistList;

  @override
  void initState() {
    super.initState();

    _cretaPlaylistList = CommunitySampleData.getCretaPlaylistList();
  }

  Widget getItemPane(Size paneSize) {
    int columnCount = (paneSize.width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    if (columnCount == 0) columnCount = 1;

    return Scrollbar(
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
            _rightViewLeftPane, _rightViewBannerMinHeight, _rightViewRightPane, _rightViewBottomPane),
        itemCount: _cretaPlaylistList.length,
        itemExtent: 204,
        itemBuilder: (context, index) {
          return CretaPlaylistItem(
            key: _cretaPlaylistList[index].uiKey,
            cretaPlayListData: _cretaPlaylistList[index],
            width: widget.pageWidth - _rightViewLeftPane - _rightViewRightPane,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getItemPane(Size(widget.pageWidth, widget.pageHeight));
  }
}
