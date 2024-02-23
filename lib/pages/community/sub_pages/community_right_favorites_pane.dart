// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/foundation.dart';
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
import 'package:creta_common/common/creta_common_utils.dart';

import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/channel_manager.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/favorites_model.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import '../../../model/channel_model.dart';

//const double _rightViewTopPane = 40;
//const double _rightViewLeftPane = 40;
//const double _rightViewRightPane = 40;
//const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 188 + 4 + 4;
//const double _rightViewToolbarHeight = 76;
//
const double _itemMinWidth = 290.0;
const double _itemMinHeight = 230.0;

bool isInUsingCanvaskit = false;

class CommunityRightFavoritesPane extends StatefulWidget {
  const CommunityRightFavoritesPane({
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
  State<CommunityRightFavoritesPane> createState() => _CommunityRightFavoritesPaneState();
}

class _CommunityRightFavoritesPaneState extends State<CommunityRightFavoritesPane> {
  final _itemSizeRatio = _itemMinWidth / _itemMinHeight;
  final GlobalKey _key = GlobalKey();

  late BookPublishedManager bookPublishedManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late ChannelManager channelManagerHolder;
  late WatchHistoryManager dummyManagerHolder;
  final List<String> _bookIdList = [];
  final Map<String, BookModel> _cretaBooksMap = {}; // <Book.Mid, Book>
  final List<FavoritesModel> _favoritesBookList = []; // <Book.mid, isFavorites>
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {}; // <UserPropertyModel.email, UserPropertyModel>
  final Map<String, String> _userIdMap = {};
  final Map<String, UserPropertyModel> _userPropertyMap =
      {}; // <UserPropertyModel.email, UserPropertyModel>
  final Map<String, String> _channelIdMap = {};
  final Map<String, ChannelModel> _channelMap = {}; // <ChannelModel.mid, ChannelModel>
  //bool _onceDBGetComplete = false;
  late Future<bool> _dbGetComplete;

  @override
  void initState() {
    super.initState();

    bookPublishedManagerHolder = BookPublishedManager();
    channelManagerHolder = ChannelManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();
    favoritesManagerHolder = FavoritesManager();
    dummyManagerHolder = WatchHistoryManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
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

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    favoritesManagerHolder.addCretaFilters(
      //bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
    );
    favoritesManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    favoritesManagerHolder.addWhereClause(
      'userId',
      QueryValue(value: AccountManager.currentLoginUser.email),
    );
    favoritesManagerHolder.queryByAddedContitions();
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_resultFavoritesFromDB.length=${modelList.length}');
    for (var exModel in modelList) {
      FavoritesModel favModel = exModel as FavoritesModel;
      if (kDebugMode) print('_resultFavoritesFromDB.mid=${favModel.bookId}');
      _favoritesBookList.add(favModel);
      _favoritesBookIdMap[favModel.bookId] = true;
      _bookIdList.add(favModel.bookId);
    }
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    bookPublishedManagerHolder.queryFromIdList(_bookIdList);
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('bookPublishedManagerHolder.model.length=${modelList.length}');
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      _cretaBooksMap[bookModel.getMid] = bookModel;
      _userIdMap[bookModel.creator] = bookModel.creator; // <= email
      if (bookModel.channels.isNotEmpty) {
        for (var channelId in bookModel.channels) {
          _channelIdMap[channelId] = channelId;
        }
      }
    }
  }

  void _getChannelsFromDB(List<AbsExModel> modelList) {
    channelManagerHolder.queryFromIdMap(_channelIdMap);
  }

  void _resultChannelsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      ChannelModel chModel = model as ChannelModel;
      //if (kDebugMode) print('_resultBooksFromDB(${chModel.getKeyId})');
      _channelMap[chModel.getMid] = chModel;
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

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    _channelMap.forEach((key, chModel) => chModel.getModelFromMaps(_userPropertyMap, _teamMap));
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

  Widget _getItemPane() {
    final int columnCount = CretaCommonUtils.getItemColumnCount(
        widget.cretaLayoutRect.childWidth, _itemMinWidth, _rightViewItemGapX);

    double itemWidth = -1;
    double itemHeight = -1;

    //BookModel dummyBookModel = BookModel('');

    // return ScrollConfiguration( // 스크롤바 감추기
    //   behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // 스크롤바 감추기
    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      child: GridView.builder(
        controller: widget.scrollController,
        padding: EdgeInsets.fromLTRB(
          widget.cretaLayoutRect.childLeftPadding,
          widget.cretaLayoutRect.childTopPadding,
          widget.cretaLayoutRect.childRightPadding,
          widget.cretaLayoutRect.childBottomPadding,
        ),
        itemCount: _favoritesBookList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemSizeRatio, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          FavoritesModel fModel = _favoritesBookList[index];
          BookModel bookModel = _cretaBooksMap[fModel.bookId] ?? BookModel('');
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
        managerList: [
          favoritesManagerHolder,
          bookPublishedManagerHolder,
          channelManagerHolder,
          userPropertyManagerHolder,
          teamManagerHolder,
          dummyManagerHolder,
        ],
        //userId: AccountManager.currentLoginUser.email,
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    return retval;
  }
}
