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
import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
import '../creta_book_ui_item.dart';
import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';

//const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 188 + 4;
//const double _rightViewToolbarHeight = 76;
//
const double _itemDefaultWidth = 290.0;
const double _itemDefaultHeight = 256.0;

bool isInUsingCanvaskit = false;

class CommunityRightHomePane extends StatefulWidget {
  final String subPageUrl;
  final double pageWidth;
  final double pageHeight;
  final ScrollController scrollController;
  const CommunityRightHomePane(
      {super.key, required this.subPageUrl, required this.pageWidth, required this.pageHeight,
        required this.scrollController});

  @override
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> {

  @override
  void initState() {
    super.initState();
  }

  Widget getItemPane(Size paneSize) {
    int columnCount = (paneSize.width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    if (columnCount == 0) columnCount = 1;

    double itemWidth = -1;
    double itemHeight = -1;

    return Scrollbar(
      thumbVisibility: true,
      controller: widget.scrollController,
      child: GridView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
            _rightViewLeftPane,
            widget.subPageUrl == AppRoutes.communityHome ? _rightViewBannerMaxHeight : _rightViewBannerMinHeight,
            _rightViewRightPane,
            _rightViewBottomPane),
        itemCount: CommunitySampleData.cretaBookList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookItem(
                  key: CommunitySampleData.cretaBookList[index].key,
                  cretaBookData: CommunitySampleData.cretaBookList[index],
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookItem(
                      key: CommunitySampleData.cretaBookList[index].key,
                      cretaBookData: CommunitySampleData.cretaBookList[index],
                      width: itemWidth,
                      height: itemHeight,
                    );
                  },
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
