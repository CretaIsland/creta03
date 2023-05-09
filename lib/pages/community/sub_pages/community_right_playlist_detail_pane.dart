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
import '../../../design_system/component/creta_layout_rect.dart';
import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../creta_playlist_detail_ui_item.dart';

//import '../../../design_system/component/custom_image.dart';
//import 'package:creta03/design_system/component/custom_image.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40-4;
//const double _rightViewRightPane = 40-4;
//const double _rightViewBottomPane = 40-4;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 168-4;
// const double _rightViewToolbarHeight = 76;
//
//const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 230.0;

class CommunityRightPlaylistDetailPane extends StatefulWidget {
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  const CommunityRightPlaylistDetailPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
  });

  @override
  State<CommunityRightPlaylistDetailPane> createState() => _CommunityRightPlaylistDetailPaneState();
}

class _CommunityRightPlaylistDetailPaneState extends State<CommunityRightPlaylistDetailPane> {
  late CretaPlaylistData _cretaPlaylistData;

  @override
  void initState() {
    super.initState();

    List<CretaPlaylistData> cretaPlaylistList = CommunitySampleData.getCretaPlaylistList();
    _cretaPlaylistData = cretaPlaylistList[0];
  }

  Widget getItemPane() {
    return Scrollbar(
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        scrollController: widget.scrollController,
        onReorder: (oldIndex, newIndex) {
          //print('onReorder($oldIndex, $newIndex)');
          setState(() {
            if (newIndex > oldIndex) {
              newIndex = newIndex - 1;
            }
            final item = _cretaPlaylistData.cretaBookDataList.removeAt(oldIndex);
            _cretaPlaylistData.cretaBookDataList.insert(newIndex, item);
          });
        },
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: _cretaPlaylistData.cretaBookDataList.length,
        //itemExtent: 204, // <== 아이템 드래그시 버그 있음
        itemBuilder: (context, index) {
          CretaBookData data = _cretaPlaylistData.cretaBookDataList[index];
          return CretaPlaylistDetailItem(
            key: data.uiKey,
            cretaBookData: data,
            width: widget.cretaLayoutRect.childWidth,
            index: index,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        widget.cretaLayoutRect.margin.left,
        widget.cretaLayoutRect.margin.top,
        widget.cretaLayoutRect.margin.right,
        widget.cretaLayoutRect.margin.bottom,
      ),
      child: getItemPane(),
    );
  }
}
