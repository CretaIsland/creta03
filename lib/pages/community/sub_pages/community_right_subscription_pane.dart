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
//import '../../../pages/login_page.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import '../../../pages/login/creta_account_manager.dart';
import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../creta_playlist_ui_item.dart';
import 'package:creta_common/model/app_enums.dart';
import '../../../model/subscription_model.dart';
import '../../../model/channel_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/favorites_model.dart';
import '../../../model/playlist_model.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/channel_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/subscription_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/watch_history_manager.dart';

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
  const CommunityRightSubscriptionPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.subscriptionModelList,
    required this.selectedSubscriptionModel,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    required this.filterSearchKeyword,
    required this.onUpdateSubscriptionModelList,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final List<SubscriptionModel>? subscriptionModelList;
  final SubscriptionModel? selectedSubscriptionModel;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  final String filterSearchKeyword;
  final Function(List<SubscriptionModel>)? onUpdateSubscriptionModelList;

  @override
  State<CommunityRightSubscriptionPane> createState() => _CommunityRightSubscriptionPaneState();
}

class _CommunityRightSubscriptionPaneState extends State<CommunityRightSubscriptionPane> {
  late final GlobalKey _key;

  late BookPublishedManager bookPublishedManagerHolder;
  late ChannelManager channelManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  late SubscriptionManager subscriptionManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late WatchHistoryManager dummyManagerHolder;

  //bool _onceDBGetComplete = false;
  late Future<bool> _dbGetComplete;

  final List<SubscriptionModel> _subscriptionList = [];
  final Map<String, ChannelModel> _channelMap = {};
  final Map<String, UserPropertyModel> _userMap = {};
  final Map<String, TeamModel> _teamMap = {};
  final List<BookModel> _cretaBooksList = [];
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final List<PlaylistModel> _playlistModelList = [];
  final Map<String, BookModel> _playlistsBooksMap = {}; // <Book.mid, Playlists.books>

  final _itemSizeRatio = _itemMinHeight / _itemMinWidth;
  double _itemWidth = 0;
  double _itemHeight = 0;

  @override
  void initState() {
    super.initState();

    _key = GlobalObjectKey(
        '_CommunityRightSubscriptionPaneState|${widget.subscriptionModelList?.length}|${widget.selectedSubscriptionModel?.channelId}|${widget.selectedSubscriptionModel?.subscriptionChannelId}');

    subscriptionManagerHolder = SubscriptionManager();
    bookPublishedManagerHolder = BookPublishedManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();
    channelManagerHolder = ChannelManager();
    favoritesManagerHolder = FavoritesManager();
    playlistManagerHolder = PlaylistManager();
    dummyManagerHolder = WatchHistoryManager();

    if (widget.subscriptionModelList == null) {
      if (kDebugMode) print('widget.subscriptionModelList == null');
      CretaManager.startQueries(
        joinList: [
          QuerySet(
              subscriptionManagerHolder, _getSubscriptionListFromDB, _resultSubscriptionListFromDB),
          QuerySet(channelManagerHolder, _getChannelListFromDB, _resultChannelListFromDB),
          QuerySet(
              userPropertyManagerHolder, _getUserPropertyListFromDB, _resultUserPropertyListFromDB),
          QuerySet(teamManagerHolder, _getTeamListFromDB, _resultTeamListFromDB),
          QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
        ],
        completeFunc: () {
          //_onceDBGetComplete = true;
        },
      );
    } else {
      if (kDebugMode) {
        print('widget.subscriptionModelList.length=${widget.subscriptionModelList!.length}');
      }
      CretaManager.startQueries(
        joinList: [
          QuerySet(bookPublishedManagerHolder, _getBookListFromDB, _resultBookListFromDB),
          QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
          QuerySet(playlistManagerHolder, _getPlaylistsFromDB, _resultPlaylistsFromDB),
          QuerySet(
              bookPublishedManagerHolder, _getPlaylistsBooksFromDB, _resultPlaylistsBooksFromDB),
          QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
        ],
        completeFunc: () {
          //_onceDBGetComplete = true;
        },
      );
    }
    _dbGetComplete = _getDBGetComplete();
  }

  Future<bool> _getDBGetComplete() async {
    // while(_onceDBGetComplete == false) {
    //   await Future.delayed(const Duration(milliseconds: 250));
    // }
    await dummyManagerHolder.isGetListFromDBComplete();
    return true;
  }

  void _getSubscriptionListFromDB(List<AbsExModel> modelList) {
    // subscriptionManagerHolder.addCretaFilters(
    //   //bookType: widget.filterBookType,
    //   bookSort: BookSort.updateTime, //widget.filterBookSort,
    //   //permissionType: widget.filterPermissionType,
    //   //searchKeyword: widget.filterSearchKeyword,
    //   sortTimeName: 'lastPublishTime',
    // );
    subscriptionManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    subscriptionManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    subscriptionManagerHolder.queryByAddedContitions();
  }

  void _resultSubscriptionListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultSubscriptionListFromDB=${modelList.length}');
    for (var model in modelList) {
      SubscriptionModel subModel = model as SubscriptionModel;
      _subscriptionList.add(subModel);
    }
  }

  void _getChannelListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getChannelListFromDB=${modelList.length}');
    final List<String> channelIdList = [];
    for (var subModel in _subscriptionList) {
      channelIdList.add(subModel.subscriptionChannelId);
    }
    if (channelIdList.isEmpty) {
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    channelManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    channelManagerHolder.addWhereClause(
        'mid', QueryValue(value: channelIdList, operType: OperType.whereIn));
    channelManagerHolder.queryByAddedContitions();
  }

  void _resultChannelListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultChannelListFromDB=${modelList.length}');
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      _channelMap[chModel.getMid] = chModel;
    }
  }

  void _getUserPropertyListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getUserPropertyListFromDB=${modelList.length}');
    final List<String> userIdList = [];
    _channelMap.forEach((mid, chModel) {
      if (chModel.userId.isNotEmpty) {
        userIdList.add(chModel.userId);
      }
    });
    if (userIdList.isEmpty) {
      userPropertyManagerHolder.setState(DBState.idle);
      return;
    }
    userPropertyManagerHolder.queryFromIdList(userIdList);
  }

  void _resultUserPropertyListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultUserPropertyListFromDB=${modelList.length}');
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      _userMap[userModel.getMid] = userModel;
    }
  }

  void _getTeamListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getTeamListFromDB=${modelList.length}');
    final List<String> teamIdList = [];
    _channelMap.forEach((mid, chModel) {
      if (chModel.teamId.isNotEmpty) {
        teamIdList.add(chModel.teamId);
      }
    });
    if (teamIdList.isEmpty) {
      teamManagerHolder.setState(DBState.idle);
      return;
    }
    teamManagerHolder.queryFromIdList(teamIdList);
  }

  void _resultTeamListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultTeamListFromDB=${modelList.length}');
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _getBookListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getBookListFromDB=${modelList.length}');
    if (widget.selectedSubscriptionModel == null) {
      if (kDebugMode) print('_selectedSubscriptionModel == null');
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    List<String> channelIdList = [widget.selectedSubscriptionModel!.subscriptionChannelId];
    bookPublishedManagerHolder.addCretaFilters(
      bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType, // => arrayContainsAny 때문에 permissionType를 사용할수가 없음
      // searchKeyword: widget.filterSearchKeyword,
      sortTimeName: 'updateTime',
    );
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause(
        'channels', QueryValue(value: channelIdList, operType: OperType.arrayContainsAny));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBookListFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultBookListFromDB=${modelList.length}');
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      _cretaBooksList.add(bookModel);
    }
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getFavoritesFromDB=${modelList.length}');
    favoritesManagerHolder.queryFavoritesFromBookModelList(_cretaBooksList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultFavoritesFromDB=${modelList.length}');
    for (var model in modelList) {
      FavoritesModel fModel = model as FavoritesModel;
      _favoritesBookIdMap[fModel.bookId] = true;
    }
  }

  void _getPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getPlaylistsFromDB=${modelList.length}');
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultPlaylistsFromDB=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _getPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getPlaylistsBooksFromDB=${modelList.length}');
    final List<String> bookIdList = [];
    for (var model in modelList) {
      PlaylistModel plModel = model as PlaylistModel;
      if (plModel.bookIdList.isNotEmpty) {
        bookIdList.add(plModel.bookIdList[0]);
      }
    }
    bookPublishedManagerHolder.queryFromIdList(bookIdList);
  }

  void _resultPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultPlaylistsBooksFromDB=${modelList.length}');
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      _playlistsBooksMap[bModel.getMid] = bModel;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_dummyCompleteDB=${modelList.length}');
    if (widget.subscriptionModelList == null) {
      for (var subModel in _subscriptionList) {
        subModel.getModelFromMaps(_channelMap, _userMap, _teamMap);
      }
      widget.onUpdateSubscriptionModelList?.call(_subscriptionList);
      return;
    }
    dummyManagerHolder.setState(DBState.idle);
  }

  void _addToFavorites(String bookId, bool isFavorites) async {
    if (isFavorites) {
      // already in favorites => remove favorites from DB
      await favoritesManagerHolder.removeFavoritesFromDB(
          bookId, AccountManager.currentLoginUser.email);
      setState(() {
        _favoritesBookIdMap[bookId] = false;
      });
    } else {
      // not exist in favorites => add favorites to DB
      await favoritesManagerHolder.addFavoritesToDB(bookId, AccountManager.currentLoginUser.email);
      setState(() {
        _favoritesBookIdMap[bookId] = true;
      });
    }
  }

  // void _newPlaylistDone(String name, bool isPublic, String bookId) async {
  //   //if (kDebugMode) print('_newPlaylistDone($name, $isPublic, $bookId)');
  //   PlaylistModel newPlaylist = await playlistManagerHolder.createNewPlaylist(
  //     name: name,
  //     userId: AccountManager.currentLoginUser.email,
  //     channelId: 'test_channel_id',
  //     isPublic: isPublic,
  //     bookIdList: [bookId],
  //   );
  //   //
  //   // success messagebox
  //   //
  //   _playlistModelList.add(newPlaylist);
  // }
  //
  // void _newPlaylist(BuildContext context, String bookId) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => PlaylistManager.newPlaylistPopUp(
  //       context: context,
  //       bookId: bookId,
  //       onNewPlaylistDone: _newPlaylistDone,
  //     ),
  //   );
  // }
  //
  // void _playlistSelectDone(String playlistMid, String bookId) async {
  //   //if (kDebugMode) print('_playlistSelectDone($playlistMid, $bookId)');
  //   await playlistManagerHolder.addBookToPlaylist(playlistMid, bookId);
  //   //
  //   // success messagebox
  //   //
  // }

  void _addToPlaylist(BookModel bookModel) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => PlaylistManager.playlistSelectPopUp(
    //     context: context,
    //     bookModel: bookModel,
    //     playlistModelList: _playlistModelList,
    //     bookModelMap: _playlistsBooksMap,
    //     onNewPlaylist: _newPlaylist,
    //     onSelectDone: _playlistSelectDone,
    //   ),
    // );
    playlistManagerHolder.addToPlaylist(context, bookModel, _playlistsBooksMap);
  }

  void _onRemoveBook(String bookId) async {
    for (int i = 0; i < _cretaBooksList.length; i++) {
      BookModel bookModel = _cretaBooksList[i];
      if (bookModel.getMid != bookId) continue;
      bookModel.isRemoved.set(true);
      bookPublishedManagerHolder.setToDB(bookModel).then((value) {
        setState(() {
          _cretaBooksList.removeAt(i);
        });
      });
      break;
    }
  }

  List<Widget> _getBookList() {
    List<Widget> widgetList = [];
    for (final bookModel in _cretaBooksList) {
      widgetList.add(
        CretaBookUIItem(
          key: GlobalObjectKey(bookModel.getMid),
          bookModel: bookModel,
          userPropertyModel: _userMap[bookModel.creator],
          channelModel: widget.selectedSubscriptionModel!.subscriptionChannel,
          width: _itemWidth,
          height: _itemHeight,
          isFavorites: _favoritesBookIdMap[bookModel.getMid] ?? false,
          addToFavorites: _addToFavorites,
          addToPlaylist: _addToPlaylist,
          onRemoveBook: _onRemoveBook,
        ),
      );
    }
    return widgetList;
  }

  Widget _getItemPane() {
    final width = widget.cretaLayoutRect.childWidth - 286 - 20;
    final int columnCount =
        CretaCommonUtils.getItemColumnCount(width, _itemMinWidth, _rightViewItemGapX);
    _itemWidth = ((width + _rightViewItemGapX) ~/ columnCount) - _rightViewItemGapX;
    _itemHeight = _itemWidth * _itemSizeRatio;

    return SizedBox(
      width: widget.cretaLayoutRect.childWidth, // - 286,
      height: widget.cretaLayoutRect.childHeight, // - 40,
      child: Scrollbar(
        key: _key,
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
              children: _getBookList(),
            ),
          ),
        ),
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
        managerList: (widget.subscriptionModelList == null)
            ? [
                subscriptionManagerHolder,
                channelManagerHolder,
                userPropertyManagerHolder,
                teamManagerHolder,
                dummyManagerHolder,
              ]
            : [
                bookPublishedManagerHolder,
                favoritesManagerHolder,
                playlistManagerHolder,
                bookPublishedManagerHolder,
                dummyManagerHolder,
              ],
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    return retval;
  }
}
