// ignore_for_file: prefer_const_constructors

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
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/channel_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/subscription_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/channel_model.dart';
import '../../../model/favorites_model.dart';
import '../../../model/playlist_model.dart';
import '../../../model/subscription_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 188 + 4;
//const double _rightViewToolbarHeight = 76;
//
const double _itemMinWidth = 290.0;
const double _itemMinHeight = 230.0;

bool isInUsingCanvaskit = false;

class CommunityRightChannelPane extends StatefulWidget {
  const CommunityRightChannelPane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    required this.filterSearchKeyword,
    required this.onUpdateModel,
    required this.currentChannelModel,
    required this.currentSubscriptionModel,
  });
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  final String filterSearchKeyword;
  final Function({ChannelModel? channelModel, SubscriptionModel? subscriptionModel})? onUpdateModel;
  final ChannelModel? currentChannelModel;
  final SubscriptionModel? currentSubscriptionModel;

  static String channelId = '';
  static double lastScreenHeight = 0;
  static double lastScrollPosition = 0;
  static int lastDropdownMenuCount = 0;

  @override
  State<CommunityRightChannelPane> createState() => _CommunityRightChannelPaneState();
}

class _CommunityRightChannelPaneState extends State<CommunityRightChannelPane> {
  //late List<CretaBookData> _cretaBookList;
  final _itemSizeRatio = _itemMinWidth / _itemMinHeight;
  final GlobalKey _key = GlobalKey();

  late ChannelManager channelManagerHolder;
  late BookPublishedManager bookPublishedManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  late SubscriptionManager subscriptionManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late WatchHistoryManager dummyManagerHolder;
  ChannelModel? _currentChannelModel;
  SubscriptionModel? _currentSubscriptionModel;
  final List<BookModel> _cretaBooksList = [];
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final List<PlaylistModel> _playlistModelList = [];
  final Map<String, BookModel> _playlistsBooksMap = {}; // <Book.mid, Playlists.books>
  final Map<String, String> _channelIdMap = {};
  final Map<String, ChannelModel> _channelMap = {}; // <UserPropertyModel.email, UserPropertyModel>
  final Map<String, String> _userIdMap = {};
  final Map<String, UserPropertyModel> _userPropertyMap =
      {}; // <UserPropertyModel.email, UserPropertyModel>
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {}; // <TeamManager.mid, TeamModel>
  //bool _onceDBGetComplete = false;
  bool _hasNoChannelModel = false;
  late Future<bool> _dbGetComplete;

  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(_scrollListener);

    channelManagerHolder = ChannelManager();
    bookPublishedManagerHolder = BookPublishedManager();
    favoritesManagerHolder = FavoritesManager();
    playlistManagerHolder = PlaylistManager();
    userPropertyManagerHolder = UserPropertyManager();
    subscriptionManagerHolder = SubscriptionManager();
    teamManagerHolder = TeamManager();
    dummyManagerHolder = WatchHistoryManager();

    if (widget.currentChannelModel == null) {
      CretaManager.startQueries(
        joinList: [
          QuerySet(channelManagerHolder, _getCurrentChannelFromDB, _resultCurrentChannelFromDB),
          QuerySet(subscriptionManagerHolder, _getSubscriptionFromDB, _resultSubscriptionFromDB),
          QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
          QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
          QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
        ],
        completeFunc: () {
          //_onceDBGetComplete = true;
        },
      );
    } else {
      _currentChannelModel = widget.currentChannelModel;
      _currentSubscriptionModel = widget.currentSubscriptionModel;
      CretaManager.startQueries(
        joinList: [
          QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
          QuerySet(channelManagerHolder, _getBooksChannelFromDB, _resultBooksChannelFromDB),
          QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
          QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
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

  @override
  void dispose() {
    super.dispose();
    widget.scrollController.removeListener(_scrollListener);
  }

  void _scrollListener() {
    CommunityRightChannelPane.lastScreenHeight =
        MediaQuery.of(context).size.height + widget.scrollController.position.maxScrollExtent - 60;
    CommunityRightChannelPane.lastScrollPosition = widget.scrollController.offset;
    if (kDebugMode) {
      print('lastScreenHeight=${CommunityRightChannelPane.lastScreenHeight}');
      print('lastScrollPosition=${CommunityRightChannelPane.lastScrollPosition}');
    }
  }

  void _getCurrentChannelFromDB(List<AbsExModel> modelList) {
    channelManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    channelManagerHolder.addWhereClause(
        'mid', QueryValue(value: CommunityRightChannelPane.channelId));
    channelManagerHolder.queryByAddedContitions();
  }

  void _resultCurrentChannelFromDB(List<AbsExModel> modelList) {
    if (modelList.isEmpty) return;
    _currentChannelModel = modelList[0] as ChannelModel; // 오직 1개만 있다고 가정
    if (_currentChannelModel!.userId.isNotEmpty) {
      _userIdMap[_currentChannelModel!.userId] = _currentChannelModel!.userId; // <= email
    }
    if (_currentChannelModel!.teamId.isNotEmpty) {
      _teamIdMap[_currentChannelModel!.teamId] = _currentChannelModel!.teamId;
    }
  }

  void _getSubscriptionFromDB(List<AbsExModel> modelList) {
    if (_currentChannelModel == null) {
      subscriptionManagerHolder.setState(DBState.idle);
      return;
    }
    if (AccountManager.currentLoginUser.isLoginedUser == false) {
      subscriptionManagerHolder.setState(DBState.idle);
      return;
    }
    subscriptionManagerHolder.queryMySubscription(_currentChannelModel!.getMid);
  }

  void _resultSubscriptionFromDB(List<AbsExModel> modelList) {
    if (modelList.isEmpty) return;
    _currentSubscriptionModel = modelList[0] as SubscriptionModel; // 오직 1개만 있다고 가정
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (_currentChannelModel == null) {
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    ////////////////
    // ==> 필터 사용에 문제 있음 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! (23-07-26)
    ////////////////
    // bookPublishedManagerHolder.addCretaFilters(
    //   bookType: widget.filterBookType,
    //   bookSort: widget.filterBookSort,
    //   permissionType: widget.filterPermissionType,
    //   searchKeyword: widget.filterSearchKeyword,
    //   sortTimeName: 'updateTime',
    // );
    List<String> channelIdList = [CommunityRightChannelPane.channelId];
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause(
        'channels', QueryValue(value: channelIdList, operType: OperType.arrayContainsAny));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      if (kDebugMode) print('_resultBooksFromDB(${bookModel.getMid})');
      _cretaBooksList.add(bookModel);
      _userIdMap[bookModel.creator] = bookModel.creator; // <= email
      for (var channelId in bookModel.channels) {
        _channelIdMap[channelId] = channelId;
      }
    }
  }

  void _getBooksChannelFromDB(List<AbsExModel> modelList) {
    if (_channelIdMap.isEmpty) {
      channelManagerHolder.setState(DBState.idle);
      return;
    }
    channelManagerHolder.queryFromIdMap(_channelIdMap);
  }

  void _resultBooksChannelFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      _channelMap[chModel.getMid] = chModel;
      if (chModel.userId.isNotEmpty) {
        _userIdMap[chModel.userId] = chModel.userId;
      }
      if (chModel.teamId.isNotEmpty) {
        _teamIdMap[chModel.teamId] = chModel.teamId;
      }
    }
  }

  void _getUserPropertyFromDB(List<AbsExModel> modelList) {
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
    teamManagerHolder.queryFromIdMap(_teamIdMap);
  }

  void _resultTeamsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      //if (kDebugMode) print('_resultBooksFromDB(${bModel.getKeyId})');
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getFavoritesFromDB');
    if (_currentChannelModel == null) {
      favoritesManagerHolder.setState(DBState.idle);
      return;
    }
    // if (modelList.isEmpty) {
    //   if (kDebugMode) print('bookPublishedManagerHolder.modelList is empty');
    //   favoritesManagerHolder.setState(DBState.idle);
    //   return;
    // }
    favoritesManagerHolder.queryFavoritesFromBookModelList(_cretaBooksList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('favoritesManagerHolder.modelList.length=${modelList.length}');
    for (var model in modelList) {
      FavoritesModel fModel = model as FavoritesModel;
      if (kDebugMode) print('_favoritesBookIdMap[${fModel.bookId}] = true');
      _favoritesBookIdMap[fModel.bookId] = true;
    }
  }

  void _getPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getPlaylistsFromDB');
    if (_currentChannelModel == null) {
      playlistManagerHolder.setState(DBState.idle);
      return;
    }
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CommunityRightChannelPane.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _getPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    if (_currentChannelModel == null) {
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    final List<String> bookIdList = [];
    for (var model in modelList) {
      PlaylistModel plModel = model as PlaylistModel;
      if (plModel.bookIdList.isNotEmpty) {
        bookIdList.add(plModel.bookIdList[0]);
      }
    }
    bookPublishedManagerHolder.clearAll();
    bookPublishedManagerHolder.clearConditions();
    if (bookIdList.isEmpty) {
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    bookPublishedManagerHolder.addWhereClause(
        'mid', QueryValue(value: bookIdList, operType: OperType.whereIn));
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsBooksFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      //if (kDebugMode) print('_resultBooksFromDB(${bModel.getKeyId})');
      _playlistsBooksMap[bModel.getMid] = bModel;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    if (widget.currentChannelModel == null) {
      if (_currentChannelModel != null) {
        _currentChannelModel?.getModelFromMaps(_userPropertyMap, _teamMap);
        widget.onUpdateModel?.call(
            channelModel: _currentChannelModel, subscriptionModel: _currentSubscriptionModel);
      } else {
        _hasNoChannelModel = true;
      }
      return;
    }
    _channelMap.forEach((key, chModel) => chModel.getModelFromMaps(_userPropertyMap, _teamMap));
    if (CommunityRightChannelPane.lastScrollPosition > 0) {
      //widget.scrollController.jumpTo(CommunityRightChannelPane.lastScrollPosition);
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
  //   if (kDebugMode) print('_newPlaylistDone($name, $isPublic, $bookId)');
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
  //   if (kDebugMode) print('_playlistSelectDone($playlistMid, $bookId)');
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

  Widget _getItemPane() {
    if (_hasNoChannelModel) {
      return Scrollbar(
        key: _key,
        thumbVisibility: true,
        controller: widget.scrollController,
        child: SizedBox(
          child: Center(
            child: Text('No channel Info !!!'),
          ),
        ),
      );
    }

    final int columnCount = CretaCommonUtils.getItemColumnCount(
        widget.cretaLayoutRect.childWidth, _itemMinWidth, _rightViewItemGapX);

    double itemWidth = -1;
    double itemHeight = -1;

    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      // return ScrollConfiguration( // 스크롤바 감추기
      //   behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // 스크롤바 감추기
      child: GridView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: _cretaBooksList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemSizeRatio, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          BookModel bookModel = _cretaBooksList[index];
          ChannelModel? chModel =
              bookModel.channels.isEmpty ? null : _channelMap[bookModel.channels[0]];
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookUIItem(
                  key: GlobalObjectKey(bookModel.getMid),
                  bookModel: bookModel,
                  userPropertyModel: _userPropertyMap[bookModel.creator],
                  channelModel: chModel,
                  width: itemWidth,
                  height: itemHeight,
                  isFavorites: _favoritesBookIdMap[bookModel.getMid] ?? false,
                  addToFavorites: _addToFavorites,
                  addToPlaylist: _addToPlaylist,
                  onRemoveBook: _onRemoveBook,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookUIItem(
                      key: GlobalObjectKey(bookModel.getMid),
                      bookModel: bookModel,
                      userPropertyModel: _userPropertyMap[bookModel.creator],
                      channelModel: chModel,
                      width: itemWidth,
                      height: itemHeight,
                      isFavorites: _favoritesBookIdMap[bookModel.getMid] ?? false,
                      addToFavorites: _addToFavorites,
                      addToPlaylist: _addToPlaylist,
                      onRemoveBook: _onRemoveBook,
                    );
                  },
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
        initScreenHeight: CommunityRightChannelPane.lastScreenHeight,
        managerList: [
          channelManagerHolder,
          bookPublishedManagerHolder,
          channelManagerHolder,
          userPropertyManagerHolder,
          teamManagerHolder,
          favoritesManagerHolder,
          playlistManagerHolder,
          bookPublishedManagerHolder,
          dummyManagerHolder,
        ],
        //userId: AccountManager.currentLoginUser.email,
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
