// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
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
//import 'package:creta_common/common/creta_color.dart';
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
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../creta_playlist_ui_item.dart';
import '../../../design_system/text_field/creta_comment_bar.dart';
import '../../../design_system/component/custom_image.dart';
import 'package:creta_common/model/app_enums.dart';
import '../../../model/comment_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import '../../../data_io/comment_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
//import '../../../pages/login_page.dart';
import '../../../pages/login/creta_account_manager.dart';

//import '../../../data_io/watch_history_manager.dart';
//import 'package:creta_user_io/data_io/creta_manager.dart';

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
  const CommunityCommentPane({
    super.key,
    required this.paneWidth,
    required this.paneHeight,
    required this.showAddCommentBar,
    required this.bookId,
    required this.isAdminMode,
  });
  final double? paneWidth;
  final double? paneHeight;
  final bool showAddCommentBar;
  final String bookId;
  final bool isAdminMode;

  @override
  State<CommunityCommentPane> createState() => _CommunityCommentPaneState();
}

class _CommunityCommentPaneState extends State<CommunityCommentPane> {
  List<CommentModel> _commentList = [];
  late CommentManager _commentManagerHolder;
  late UserPropertyManager _userPropertyManagerHolder;
  //late WatchHistoryManager _dummyManagerHolder;
  late CommentModel _newAddingCommentData;
  final Map<String, UserPropertyModel> _userPropertyMap = {};

  @override
  void initState() {
    super.initState();
    // new data for comment-bar before adding
    _newAddingCommentData = _getNewCommentData(barType: CommentBarType.addCommentMode);

    _commentManagerHolder = CommentManager();
    //_dummyManagerHolder = WatchHistoryManager();
    _userPropertyManagerHolder = UserPropertyManager();

    _commentManagerHolder.getCommentList(widget.bookId).whenComplete(() {
      List<String> userIdList = _getUserIdList(_commentManagerHolder.commentList);
      _userPropertyManagerHolder.getUserPropertyFromEmail(userIdList).then((value) {
        for (var userModel in value) {
          _userPropertyMap[userModel.email] = userModel;
        }
        setState(() {
          _commentList = _getRearrangedList(_commentManagerHolder.commentList);
        });
      });
    });
  }

  List<String> _getUserIdList(List<CommentModel> commentList) {
    List<String> userIdList = [];
    for (var commentModel in commentList) {
      userIdList.add(commentModel.userId);
    }
    return userIdList;
  }

  CommentModel _getNewCommentData({required CommentBarType barType, String parentId = ''}) {
    CommentModel model = CommentModel.withName(
      userId: AccountManager.currentLoginUser.email,
      bookId: widget.bookId,
      parentId: parentId,
      comment: '',
    );
    model.barType = barType;
    model.profileImg = CretaAccountManager.getUserProperty?.profileImgUrl ??
        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif';
    return model;
  }

  List<CommentModel> _getRearrangedList(List<CommentModel> oldList) {
    List<CommentModel> returnCommentList = [];
    Map<String, CommentModel> rootMap = {};
    // get root-items
    for (CommentModel data in oldList) {
      if (data.parentId.isNotEmpty) {
        // exist parentId => not root comment => bypass
        continue;
      }
      UserPropertyModel? userProperty = _userPropertyMap[data.userId];
      data.name = userProperty?.nickname ?? '';
      data.profileImg = userProperty?.profileImgUrl ?? '';
      returnCommentList.add(data);
      rootMap[data.getMid] = data;
      data.replyList.clear();
    }
    // get sub-items of root-items
    for (CommentModel data in oldList) {
      if (data.parentId.isEmpty) {
        // not exist parentId => root comment => bypass
        continue;
      }
      UserPropertyModel? userProperty = _userPropertyMap[data.userId];
      data.name = userProperty?.nickname ?? '';
      data.profileImg = userProperty?.profileImgUrl ?? '';
      CommentModel? parentData = rootMap[data.parentId];
      parentData?.replyList.add(data);
      parentData?.hasNoReply = false;
    }
    return returnCommentList;
  }

  Widget _getCommentWidget(double width, CommentModel data) {
    //if (kDebugMode) print('data(parentKey=${data.parentKey}, key=${data.key}, beginToEditMode=${data.beginToEditMode})');
    double indentSize = data.parentId.isEmpty ? 0 : (40 + 18 - 8);
    return Container(
      //height: 61,
      key: ValueKey(data.getMid),
      padding: EdgeInsets.fromLTRB(indentSize, 0, 0, 0),
      child: CretaCommentBar(
        width: width - indentSize,
        thumb: CustomImage(
          hasMouseOverEffect: false,
          hasAni: false,
          width: 40,
          height: 40,
          image: data.profileImg,
        ),
        data: data,
        hintText: '',
        //onClickedAdd: _onClickedAdd,
        onClickedRemove:
            (widget.isAdminMode || data.userId == AccountManager.currentLoginUser.email)
                ? _onClickedRemove
                : null,
        onClickedModify:
            (data.userId == AccountManager.currentLoginUser.email) ? _onClickedModify : null,
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
    for (CommentModel data in _commentList) {
      //print('key:${data.parentKey}, name:${data.name}, comment:${data.comment}, replyCount=${data.replyList?.length}');
      commentWidgetList.add(_getCommentWidget(width, data));
      if (data.showReplyList == false) continue;
      for (CommentModel replyData in data.replyList) {
        commentWidgetList.add(_getCommentWidget(width, replyData));
      }
    }
    //print('_getCommentWidgetList end');
    return commentWidgetList;
  }

  void _onClickedAdd(CommentModel addingData) {
    CommentModel newData = CommentModel.withName(
      userId: addingData.userId,
      bookId: addingData.bookId,
      parentId: addingData.parentId,
      comment: addingData.comment,
    );
    newData.name = addingData.name;
    newData.profileImg = addingData.profileImg;
    _commentManagerHolder.createToDB(newData).then((value) {
      setState(() {
        newData.barType = CommentBarType.modifyCommentMode;
        _commentList.insert(0, newData);
        _newAddingCommentData = _getNewCommentData(barType: CommentBarType.addCommentMode);
      });
    });
  }

  void _onClickedRemove(CommentModel removingData) {
    _commentManagerHolder.removeCommentFromDB(removingData).then((value) {
      setState(() {
        for (int i = 0; i < _commentList.length; i++) {
          CommentModel data = _commentList[i];
          if (data.getMid == removingData.getMid) {
            // root-comment
            _commentList.removeAt(i);
            return;
          } else {
            // reply-comment
            for (int sub = 0; sub < data.replyList.length; sub++) {
              CommentModel replyData = data.replyList[sub];
              if (replyData.getMid == removingData.getMid) {
                data.replyList.removeAt(sub);
                if (data.replyList.isEmpty) {
                  data.hasNoReply = true;
                }
                return;
              }
            }
          }
        }
      });
    });
  }

  void _onClickedModify(CommentModel data) {
    //
    // data.createTime = DateTime.now(); // 생성시간 갱신에 문제가 있음
    //
    _commentManagerHolder.setToDB(data).then((value) {
      setState(() {
        if (data.parentId.isNotEmpty) {
          for (var comment in _commentList) {
            if (comment.getMid != data.parentId) continue;
            comment.hasNoReply = false;
            break;
          }
        }
        //
        // _commentList 데이터 확인 필요
        //
      });
    });
  }

  void _onClickedReply(CommentModel data) {
    //if (kDebugMode) print('_onClickedReply(${data.name}, ${data.key})');
    setState(() {
      CommentModel replyData = _getNewCommentData(
        parentId: data.getMid,
        barType: CommentBarType.addReplyMode,
      );
      data.showReplyList = true;
      data.replyList.add(replyData);
    });
  }

  void _onClickedShowReply(CommentModel data) {
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
          (!widget.showAddCommentBar || AccountManager.currentLoginUser.isLoginedUser == false)
              ? Container()
              : CretaCommentBar(
                  data: _newAddingCommentData,
                  hintText: '욕설, 비방 등은 경고 없이 삭제될 수 있습니다.',
                  onClickedAdd: _onClickedAdd,
                  width: widget.paneWidth,
                  thumb: CustomImage(
                    hasMouseOverEffect: false,
                    hasAni: false,
                    width: 40,
                    height: 40,
                    image: CretaAccountManager.getUserProperty?.profileImgUrl ??
                        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
                  ),
                ),
          Container(
            padding: EdgeInsets.fromLTRB(
                16, (AccountManager.currentLoginUser.isLoginedUser == false) ? 0 : 20, 0, 0),
            child: Column(
              children:
                  _getCommentWidgetList(widget.paneWidth == null ? 0 : widget.paneWidth! - 16),
            ),
          ),
        ],
      ),
    );
  }
}
