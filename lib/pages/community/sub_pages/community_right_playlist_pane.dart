// ignore_for_file: prefer_const_constructors

import 'package:creta03/data_io/creta_manager.dart';
import 'package:flutter/foundation.dart';
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
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../creta_playlist_ui_item.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../model/app_enums.dart';
import '../../../model/creta_model.dart';
import '../../../model/book_model.dart';
import '../../../model/playlist_model.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
// //const double _scrollbarWidth = 13;
// const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;
//
//const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 230.0;

class CommunityRightPlaylistPane extends StatefulWidget {
  const CommunityRightPlaylistPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    required this.filterSearchKeyword,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  final String filterSearchKeyword;

  @override
  State<CommunityRightPlaylistPane> createState() => _CommunityRightPlaylistPaneState();
}

class _CommunityRightPlaylistPaneState extends State<CommunityRightPlaylistPane> {
  late PlaylistManager playlistManagerHolder;
  late BookPublishedManager bookPublishedManagerHolder;
  late FavoritesManager dummyManagerHolder;
  final GlobalKey _key = GlobalKey();
  final Map<String, BookModel> _cretaBookMap = {};
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    super.initState();

    playlistManagerHolder = PlaylistManager();
    bookPublishedManagerHolder = BookPublishedManager();
    dummyManagerHolder = FavoritesManager();

    CretaManager.startQueries([
      QuerySet(playlistManagerHolder, _getPlaylistFromDB, null),
      QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
      QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
    ]);
  }

  void _getPlaylistFromDB(List<AbsExModel> modelList) {
    playlistManagerHolder.addCretaFilters(
      //bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
    );
    playlistManagerHolder.queryByAddedContitions();
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getBooksFromDB');
    if (modelList.isEmpty) {
      if (kDebugMode) print('playlistManagerHolder.modelList is empty');
      setState(() {
        _dummyCompleteDB([]);
        _onceDBGetComplete = true;
      });
      return;
    }
    List<String> bookAllList = [];
    for (var plModel in modelList) {
      PlaylistModel fModel = plModel as PlaylistModel;
      for (var bookId in fModel.bookIdList) {
        bookAllList.add(bookId);
      }
    }
    bookPublishedManagerHolder.addWhereClause('mid', QueryValue(value: bookAllList, operType: OperType.whereIn));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      if (kDebugMode) print('---_getBookDataFromDB(bookId=${bModel.mid}) added');
      _cretaBookMap[bModel.mid] = bModel;
    }
    _onceDBGetComplete = true;
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    dummyManagerHolder.setState(DBState.idle);
  }

  Widget _getItemPane() {
    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      child: ListView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: playlistManagerHolder.modelList.length,
        itemExtent: 204,
        itemBuilder: (context, index) {
          PlaylistModel plModel = playlistManagerHolder.modelList[index] as PlaylistModel;
          return CretaPlaylistItem(
            key: GlobalObjectKey(plModel.mid),
            playlistModel: plModel,
            width: widget.cretaLayoutRect.childWidth,
            bookMap: _cretaBookMap,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_onceDBGetComplete) {
      return _getItemPane();
    }
    var retval = CretaModelSnippet.waitDatum(
      managerList: [playlistManagerHolder, bookPublishedManagerHolder, dummyManagerHolder],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _getItemPane,
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
