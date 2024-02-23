// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
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
import '../../../design_system/component/creta_layout_rect.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../creta_playlist_detail_ui_item.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
//import 'package:creta_common/model/app_enums.dart';
//import '../../../design_system/component/snippet.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/playlist_model.dart';

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
  const CommunityRightPlaylistDetailPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.updatePlaylistModel,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final Function(PlaylistModel) updatePlaylistModel;

  static String playlistId = '';

  @override
  State<CommunityRightPlaylistDetailPane> createState() => _CommunityRightPlaylistDetailPaneState();
}

class _CommunityRightPlaylistDetailPaneState extends State<CommunityRightPlaylistDetailPane> {
  final Map<String, BookModel> _cretaBookMap = {};
  PlaylistModel? _currentPlaylistModel;

  late PlaylistManager playlistManagerHolder;
  late BookPublishedManager bookPublishedManagerHolder;
  late FavoritesManager dummyManagerHolder;
  //bool _onceDBGetComplete = false;
  late Future<bool> _dbGetComplete;

  @override
  void initState() {
    super.initState();

    if (CommunityRightPlaylistDetailPane.playlistId.isEmpty) {
      //String url = Uri.base.origin;
      String query = Uri.base.query;

      int pos = query.indexOf('&');
      CommunityRightPlaylistDetailPane.playlistId = (pos > 0) ? query.substring(0, pos) : query;
    }
    if (kDebugMode) print('---initState(${CommunityRightPlaylistDetailPane.playlistId})');

    playlistManagerHolder = PlaylistManager();
    bookPublishedManagerHolder = BookPublishedManager();
    dummyManagerHolder = FavoritesManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(playlistManagerHolder, _getPlaylistFromDB, null),
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
      ],
      completeFunc: () {
        //_onceDBGetComplete = true;
      },
    );
    _dbGetComplete = _getDBGetComplete();
  }

  Future<bool> _getDBGetComplete() async {
    // while(_onceDBGetComplete == false) {
    //   await Future.delayed(const Duration(milliseconds: 250));
    // }
    await dummyManagerHolder.isGetListFromDBComplete();
    return true;
  }

  void _getPlaylistFromDB(List<AbsExModel> modelList) {
    playlistManagerHolder.addWhereClause(
        'mid', QueryValue(value: CommunityRightPlaylistDetailPane.playlistId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getBookDataFromDB');
    if (modelList.isEmpty) {
      if (kDebugMode) print('playlistManagerHolder.modelList is empty');
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    _currentPlaylistModel = modelList[0] as PlaylistModel; // 무조건 1개만 있다고 가정
    widget.updatePlaylistModel(_currentPlaylistModel!);
    if (_currentPlaylistModel!.bookIdList.isEmpty) {
      if (kDebugMode) print('_currentPlaylistModel.bookIdList is empty');
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    List<String> bookIdList = [];
    for (var bookId in _currentPlaylistModel!.bookIdList) {
      bookIdList.add(bookId);
    }
    if (bookIdList.isEmpty) {
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause(
        'mid', QueryValue(value: bookIdList, operType: OperType.whereIn));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      _cretaBookMap[bModel.getMid] = bModel;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    dummyManagerHolder.setState(DBState.idle);
  }

  void _removeBookInPlaylist(int index) {
    setState(() {
      _currentPlaylistModel!.bookIdList.removeAt(index);
      playlistManagerHolder.setToDB(_currentPlaylistModel!);
    });
  }

  Widget _getItemPane() {
    if (_currentPlaylistModel == null) {
      return SizedBox.shrink();
    }
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
            final item = _currentPlaylistModel!.bookIdList.removeAt(oldIndex);
            _currentPlaylistModel!.bookIdList.insert(newIndex, item);
            playlistManagerHolder.setToDB(_currentPlaylistModel!);
          });
        },
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: _currentPlaylistModel!.bookIdList.length,
        //itemExtent: 204, // <== 아이템 드래그시 버그 있음
        itemBuilder: (context, index) {
          BookModel bModel =
              _cretaBookMap[_currentPlaylistModel!.bookIdList[index]] ?? BookModel('dummy');
          return CretaPlaylistDetailItem(
            key: GlobalObjectKey('$index-${bModel.getMid}'),
            bookModel: bModel,
            width: widget.cretaLayoutRect.childWidth,
            index: index,
            removeBook: _removeBookInPlaylist,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_onceDBGetComplete) {
    //   return _getItemPane();
    // }
    var retval = Scrollbar(
      controller: widget.scrollController,
      child: CretaManager.waitDatum(
        managerList: [bookPublishedManagerHolder, playlistManagerHolder, dummyManagerHolder],
        //userId: AccountManager.currentLoginUser.email,
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    return retval;
  }
}
