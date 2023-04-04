// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
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
  final String _currentNickname = 'Tester테스터123';
  final String _currentUserId = GlobalKey().toString();

  late List<CretaCommentData> _cretaCommentList;
  late CretaCommentData _newAddingCommentData;

  @override
  void initState() {
    super.initState();
    // new data for comment-bar before adding
    _newAddingCommentData = _getNewCommentData(barType: CretaCommentBarType.addCommentMode);
    _cretaCommentList = _getRearrangedList(CommunitySampleData.getCretaCommentList());
  }

  CretaCommentData _getNewCommentData({required CretaCommentBarType barType, String parentMid=''}) {
    return CretaCommentData(
      mid: GlobalKey().toString(),
      nickname: _currentNickname,
      creator: _currentUserId,
      comment: '',
      dateTime: DateTime.now(),
      parentMid: parentMid,
      barType: barType,//CretaCommentBarType.addCommentMode,
    );
  }

  List<CretaCommentData> _getRearrangedList(List<CretaCommentData> oldList) {
    List<CretaCommentData> newList = [];
    Map<String, CretaCommentData> newMap = {};
    // get root-items
    for (CretaCommentData data in oldList) {
      if (data.parentMid.isNotEmpty) continue;
      newList.add(data);
      newMap[data.mid] = data;
      data.replyList.clear();
    }
    // get sub-items of root-items
    for (CretaCommentData data in oldList) {
      if (data.parentMid.isEmpty) continue;
      CretaCommentData? parentData = newMap[data.parentMid];
      //if (parentData == null) continue;
      //parentData.replyList.add(data);
      parentData?.replyList.add(data);
    }
    return newList;
  }

  Widget _getCommentWidget(double width, CretaCommentData data) {
    //if (kDebugMode) print('data(parentKey=${data.parentKey}, key=${data.key}, beginToEditMode=${data.beginToEditMode})');
    double indentSize = data.parentMid.isEmpty ? 0 : (40 + 18 - 8);
    return Container(
      //height: 61,
      key: ValueKey(data.mid),
      padding: EdgeInsets.fromLTRB(indentSize, 0, 0, 0),
      child: CretaCommentBar(
        width: width - indentSize,
        thumb: Container(
          color: Colors.red,
        ),
        data: data,
        hintText: '',
        //onClickedAdd: _onClickedAdd,
        onClickedRemove: _onClickedRemove,
        onClickedModify: _onClickedModify,
        onClickedReply: _onClickedReply,
        onClickedShowReply: _onClickedShowReply,
        //editModeOnly: false,
        //showEditButton: true,
      ),
    );
  }

  List<Widget> _getCommentWidgetList(double width) {
    //if (kDebugMode) print('_getCommentWidgetList start...');
    List<Widget> commentWidgetList = [];
    for (CretaCommentData data in _cretaCommentList) {
      //print('key:${data.parentKey}, name:${data.name}, comment:${data.comment}, replyCount=${data.replyList?.length}');
      commentWidgetList.add(_getCommentWidget(width, data));
      if (data.showReplyList == false) continue;
      for (CretaCommentData replyData in data.replyList) {
        commentWidgetList.add(_getCommentWidget(width, replyData));
      }
    }
    //print('_getCommentWidgetList end');
    return commentWidgetList;
  }

  void _onClickedAdd(CretaCommentData addingData) {
    setState(() {
      addingData.barType = CretaCommentBarType.modifyCommentMode;
      _cretaCommentList.insert(0, addingData);
      _newAddingCommentData = _getNewCommentData(barType: CretaCommentBarType.addCommentMode);
      //     CretaCommentData(
      //   key: GlobalKey().toString(),
      //   name: 'Tester123',
      //   creator: '',
      //   comment: '',
      //   dateTime: DateTime.now(),
      //   //parentKey: null,
      // );
    });
  }

  void _onClickedRemove(CretaCommentData removingData) {
    //if (kDebugMode) print('_onRemoveComment($key)');
    setState(() {
      for (int i = 0; i < _cretaCommentList.length; i++) {
        CretaCommentData data = _cretaCommentList[i];
        if (data.mid == removingData.mid) {
          _cretaCommentList.removeAt(i);
          return;
        } else {
          for (int sub = 0; sub < data.replyList.length; sub++) {
            CretaCommentData replyData = data.replyList[sub];
            if (replyData.mid == removingData.mid) {
              data.replyList.removeAt(sub);
              return;
            }
          }
        }
      }
    });
  }

  void _onClickedModify(CretaCommentData data) {
    // no nothing
  }

  void _onClickedReply(CretaCommentData data) {
    //if (kDebugMode) print('_onAddReply(${data.name}, ${data.key})');
    setState(() {
      CretaCommentData replyData = _getNewCommentData(
        parentMid: data.mid,
        barType: CretaCommentBarType.addReplyMode,
      );
      // CretaCommentData(
      //   mid: GlobalKey().toString(),
      //   nickname: _currentNickname,
      //   creator: _currentUserId,
      //   comment: '',
      //   dateTime: DateTime.now(),
      //   parentMid: data.mid,
      //   barType: CretaCommentBarType.addReplyMode,
      // );
      //if (kDebugMode) print('replyData(key=${replyData.key}, beginToEditMode=${replyData.beginToEditMode})');
      data.showReplyList = true;
      data.replyList.insert(0, replyData);
    });
  }

  void _onClickedShowReply(CretaCommentData data) {
    if (data.hasNoReply) return;
    setState(() {
      data.showReplyList = !data.showReplyList;
    });
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
                  data: _newAddingCommentData,
                  hintText: '욕설, 비방 등은 경고 없이 삭제될 수 있습니다.',
                  onClickedAdd: _onClickedAdd,
                  width: widget.paneWidth,
                  thumb: Icon(Icons.account_circle),
                ),
          Container(
            padding: EdgeInsets.fromLTRB(16, 20, 0, 0),
            child: Column(
              children: _getCommentWidgetList(widget.paneWidth == null ? 0 : widget.paneWidth! - 16),
            ),
          ),
        ],
      ),
    );
  }
}
