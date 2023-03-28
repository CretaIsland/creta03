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
//import '../creta_playlist_ui_item.dart';
import '../../../design_system/text_field/creta_comment_bar.dart';

// const double _rightViewTopPane = 40;
// const double _rightViewLeftPane = 40;
// const double _rightViewRightPane = 40;
// const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
// const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;
//
// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;

class CommunityCommentPane extends StatefulWidget {
  final double? paneWidth;
  final double? paneHeight;
  final bool showAddCommentBar;
  const CommunityCommentPane({
    super.key,
    required this.paneWidth,
    required this.paneHeight,
    required this.showAddCommentBar,
  });

  @override
  State<CommunityCommentPane> createState() => _CommunityCommentPaneState();
}

class _CommunityCommentPaneState extends State<CommunityCommentPane> {
  late List<CretaCommentData> _cretaCommentList;
  late CretaCommentData _newData;

  @override
  void initState() {
    super.initState();
    _cretaCommentList = CommunitySampleData.getCretaCommentList();
    _newData = CretaCommentData(
      key: GlobalKey().toString(),
      name: '',
      creator: '',
      comment: '',
      dateTime: DateTime.now(),
      //parentKey: null,
    );
  }

  Widget _getCommentWidget(double width, CretaCommentData commentData, {double indentSize = 0}) {
    return Container(
      ///height: 61,
      padding: EdgeInsets.fromLTRB(indentSize, 0, 0, 0),
      child: CretaCommentBar(
        data : commentData,
        onSearch: (value) {},
        hintText: '',
        showEditButton: true,
        width: width - indentSize,
        thumb: Container(color: Colors.red,),
      ),
    );
  }

  List<Widget> _getCommentList(double width, String parentKey) {
    List<Widget> retList = [];
    for(CretaCommentData data in _cretaCommentList) {
      if (data.parentKey == parentKey) {
        //print('key:${data.parentKey}, name:${data.name}, comment:${data.comment}');
        retList.add(_getCommentWidget(width, data, indentSize: parentKey.isEmpty ? 0 : 40+18));
        if (parentKey.isEmpty) {
          retList.addAll(_getCommentList(width, data.key));
        }
      }
    }
    return retList;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.paneWidth,
      height: widget.paneHeight,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          !widget.showAddCommentBar
              ? Container()
              : CretaCommentBar(
                  data: _newData,
                  hintText: '욕설, 비방 등은 경고 없이 삭제될 수 있습니다.',
                  onSearch: (text) {},
                  width: widget.paneWidth,
                  thumb: Icon(Icons.account_circle),
                  showEditButton: false,
                ),
          ..._getCommentList(widget.paneWidth ?? 0, ''),
        ],
      ),
    );
  }
}
