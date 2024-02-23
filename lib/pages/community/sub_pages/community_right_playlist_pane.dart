// ignore_for_file: prefer_const_constructors

import 'package:creta_user_io/data_io/creta_manager.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
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
import '../creta_playlist_ui_item.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/channel_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/channel_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta_user_model/model/team_model.dart';
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
  final GlobalKey _key = GlobalKey();

  late final PlaylistManager playlistManagerHolder;
  late final BookPublishedManager bookPublishedManagerHolder;
  late final ChannelManager channelManagerHolder;
  late final TeamManager teamManagerHolder;
  late final UserPropertyManager userPropertyManagerHolder;
  late final FavoritesManager dummyManagerHolder;
  final Map<String, BookModel> _cretaBookMap = {};
  final List<PlaylistModel> _playlistModelList = [];
  final Map<String, ChannelModel> _channelMap = {};
  final Map<String, String> _userIdMap = {};
  final Map<String, UserPropertyModel> _userPropertyMap = {};
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {};

  //bool _onceDBGetComplete = false;
  late Future<bool> _dbGetComplete;

  @override
  void initState() {
    super.initState();

    playlistManagerHolder = PlaylistManager();
    bookPublishedManagerHolder = BookPublishedManager();
    channelManagerHolder = ChannelManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();

    dummyManagerHolder = FavoritesManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(playlistManagerHolder, _getPlaylistFromDB, _resultPlaylistsFromDB),
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(channelManagerHolder, _getChannelsFromDB, _resultChannelsFromDB),
        QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
        QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
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
    playlistManagerHolder.addCretaFilters(
      //bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
    );
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      _playlistModelList.add(model as PlaylistModel);
    }
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getBooksFromDB');
    if (modelList.isEmpty) {
      if (kDebugMode) print('playlistManagerHolder.modelList is empty');
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    final Map<String, String> bookIdMap = {};
    for (var plModel in modelList) {
      PlaylistModel fModel = plModel as PlaylistModel;
      for (var bookId in fModel.bookIdList) {
        bookIdMap.putIfAbsent(bookId, () => bookId);
      }
    }
    List<String> bookIdList = [];
    bookIdMap.forEach((key, value) {
      bookIdList.add(value);
    });
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
      if (kDebugMode) print('---_getBookDataFromDB(bookId=${bModel.getMid}) added');
      _cretaBookMap[bModel.getMid] = bModel;
    }
  }

  void _getChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getPlaylistChannelsFromDB()');
    if (modelList.isEmpty) {
      // no book-data ==> skip
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    final Map<String, String> channelIdMap = {};
    _cretaBookMap.forEach((bookId, bookModel) {
      channelIdMap.putIfAbsent(bookModel.channels[0], () => bookModel.channels[0]);
    });
    final List<String> channelIdList = [];
    channelIdMap.forEach((key, value) {
      channelIdList.add(value);
    });
    channelManagerHolder.queryFromIdList(channelIdList);
  }

  void _resultChannelsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _resultPlaylistChannelsFromDB(${modelList.length})');
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      _channelMap[chModel.mid] = chModel;
      if (chModel.userId.isNotEmpty) {
        _userIdMap[chModel.userId] = chModel.userId;
      }
      if (chModel.teamId.isNotEmpty) {
        _teamIdMap[chModel.teamId] = chModel.teamId;
      }
    }
  }

  void _getUserPropertyFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getUserPropertyFromDB(${modelList.length})');
    userPropertyManagerHolder.queryFromIdMap(_userIdMap);
  }

  void _resultUserPropertyFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _userPropertyMap[userModel.getMid] = userModel;
    }
  }

  void _getTeamsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('start _getUserPropertyFromDB(${modelList.length})');
    teamManagerHolder.queryFromIdMap(_teamIdMap);
  }

  void _resultTeamsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    _channelMap.forEach((channelId, channelModel) {
      channelModel.getModelFromMaps(_userPropertyMap, _teamMap);
    });
    dummyManagerHolder.setState(DBState.idle);
  }

  void _editPlaylistProperty(PlaylistModel model) {
    setState(() {
      playlistManagerHolder.modifyPlaylist(context, model);
    });
  }

  void _deletePlaylist(PlaylistModel model) {
    setState(() {
      playlistManagerHolder.removeToDB(model.getMid);
      for (var plModel in _playlistModelList) {
        if (plModel.getMid != model.getMid) continue;
        _playlistModelList.remove(plModel);
        break;
      }
    });
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
        itemCount: _playlistModelList.length,
        itemExtent: 204,
        itemBuilder: (context, index) {
          PlaylistModel plModel = _playlistModelList[index];
          return CretaPlaylistItem(
            key: GlobalObjectKey(plModel.getMid),
            playlistModel: plModel,
            width: widget.cretaLayoutRect.childWidth,
            bookMap: _cretaBookMap,
            editPopupMenu: _editPlaylistProperty,
            deletePopupMenu: _deletePlaylist,
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
        managerList: [playlistManagerHolder, bookPublishedManagerHolder, dummyManagerHolder],
        //userId: AccountManager.currentLoginUser.email,
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
