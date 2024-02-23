// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
//import 'package:creta03/design_system/component/custom_image.dart';
//import 'package:deep_collection/deep_collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../../design_system/component/creta_popup.dart';
//import '../../../design_system/dialog/creta_dialog.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
// import 'package:creta_common/common/creta_color.dart';
// import 'package:creta_common/common/creta_font.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../../design_system/component/creta_leftbar.dart';
import '../../../design_system/component/creta_layout_rect.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
import '../../login/creta_account_manager.dart';
import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../../../data_io/book_manager.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/channel_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/channel_model.dart';
import '../../../model/favorites_model.dart';
import '../../../model/playlist_model.dart';
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
//const double _itemDescriptionHeight = 58;

bool isInUsingCanvaskit = false;

class CommunityRightHomePane extends StatefulWidget {
  const CommunityRightHomePane({
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
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> {
  final _itemSizeRatio = _itemMinWidth / _itemMinHeight;
  final GlobalKey _key = GlobalKey();

  late BookPublishedManager bookPublishedManagerHolder;
  late ChannelManager channelManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late WatchHistoryManager dummyManagerHolder;
  final List<BookModel> _cretaBooksList = [];
  final Map<String, BookModel> _cretaBooksMap = {}; // <Book.mid, BookModel>
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final List<PlaylistModel> _playlistModelList = [];
  final Map<String, BookModel> _playlistsBooksMap = {}; // <Book.mid, Playlists.books>
  final Map<String, String> _channelIdMap = {};
  final Map<String, ChannelModel> _channelMap = {}; // <Channel.mid, ChannelModel>
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {}; // <TeamManager.mid, TeamModel>
  final Map<String, String> _userIdMap = {};
  final Map<String, UserPropertyModel> _userPropertyMap =
      {}; // <UserPropertyModel.email, UserPropertyModel>
  //bool _onceDBGetComplete = false;
  late Future<bool> _dbGetComplete;
  //Future<bool>? _dbGetComplete;

  @override
  void initState() {
    super.initState();

    bookPublishedManagerHolder = BookPublishedManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();
    channelManagerHolder = ChannelManager();
    favoritesManagerHolder = FavoritesManager();
    playlistManagerHolder = PlaylistManager();
    dummyManagerHolder = WatchHistoryManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(bookPublishedManagerHolder, _getBooksFromDBofHashtag, _resultBooksFromDBofHashtag),
        QuerySet(channelManagerHolder, _getChannelsFromDB, _resultChannelsFromDB),
        QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
        QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
        QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
        QuerySet(playlistManagerHolder, _getPlaylistsFromDB, _resultPlaylistsFromDB),
        QuerySet(bookPublishedManagerHolder, _getPlaylistsBooksFromDB, _resultPlaylistsBooksFromDB),
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

  void _getBooksFromDB(List<AbsExModel> modelList) {
    //print('_getBooksFromDB()');
    bookPublishedManagerHolder.addCretaFilters(
      bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
      sortTimeName: 'updateTime',
    );
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    //Map<String, BookModel> bookMap = {}; // appwrite에서 중복처리가 될때까지 사용
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      if (kDebugMode) print('_resultBooksFromDB(${bookModel.getMid})');
      //_cretaBooksList.add(bookModel);
      _cretaBooksMap.putIfAbsent(bookModel.getMid, () => bookModel);
      _userIdMap[bookModel.creator] = bookModel.creator;
      for (var channelId in bookModel.channels) {
        //_channelIdMap[channelId] = channelId;
        _channelIdMap.putIfAbsent(channelId, () => channelId);
      }
    }
    // _cretaBooksMap.forEach((key, value) {
    //   _cretaBooksList.add(value);
    // });
  }

  void _getBooksFromDBofHashtag(List<AbsExModel> modelList) {
    //print('_getBooksFromDB()');
    bookPublishedManagerHolder.addCretaFilters(
      bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      permissionType: widget.filterPermissionType,
      //searchKeyword: widget.filterSearchKeyword,
      hashtag: widget.filterSearchKeyword,
      sortTimeName: 'updateTime',
    );
    bookPublishedManagerHolder.queryByAddedContitions();
  }

  void _resultBooksFromDBofHashtag(List<AbsExModel> modelList) {
    //Map<String, BookModel> bookMap = {}; // appwrite에서 중복처리가 될때까지 사용
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      if (kDebugMode) print('_resultBooksFromDB(${bookModel.getMid})');
      //_cretaBooksList.add(bookModel);
      _cretaBooksMap.putIfAbsent(bookModel.getMid, () => bookModel);
      _userIdMap[bookModel.creator] = bookModel.creator;
      for (var channelId in bookModel.channels) {
        //_channelIdMap[channelId] = channelId;
        _channelIdMap.putIfAbsent(channelId, () => channelId);
      }
    }
    _cretaBooksMap.forEach((key, value) {
      _cretaBooksList.add(value);
    });
  }

  void _getChannelsFromDB(List<AbsExModel> modelList) {
    channelManagerHolder.queryFromIdMap(_channelIdMap);
  }

  void _resultChannelsFromDB(List<AbsExModel> modelList) {
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
    //print('_getUserPropertyFromDB()');
    userPropertyManagerHolder.queryFromIdMap(_userIdMap);
  }

  void _resultUserPropertyFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      UserPropertyModel userModel = model as UserPropertyModel;
      //if (kDebugMode) print('_resultBooksFromDB(${bModel.getKeyId})');
      _userPropertyMap[userModel.getMid] = userModel;
    }
  }

  void _getTeamsFromDB(List<AbsExModel> modelList) {
    teamManagerHolder.queryFromIdMap(_teamIdMap);
  }

  void _resultTeamsFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      TeamModel teamModel = model as TeamModel;
      //if (kDebugMode) print('_resultBooksFromDB(${teamModel.getKeyId})');
      _teamMap[teamModel.getMid] = teamModel;
    }
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getFavoritesFromDB');
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
    if (CretaAccountManager.getUserProperty == null) {
      playlistManagerHolder.setState(DBState.idle);
      return;
    }
    playlistManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    playlistManagerHolder.addWhereClause(
        'channelId', QueryValue(value: CretaAccountManager.getUserProperty!.channelId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _getPlaylistsBooksFromDB(List<AbsExModel> modelList) {
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
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      //if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.getKeyId})');
      _playlistsBooksMap[bModel.getMid] = bModel;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    _channelMap.forEach((key, chModel) => chModel.getModelFromMaps(_userPropertyMap, _teamMap));
    dummyManagerHolder.setState(DBState.idle);
    if (kDebugMode) print('_dummyCompleteDB(length=${modelList.length})');
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
  // void _newPlaylist(String bookId) {
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
  //
  void _addToPlaylist(BookModel bookModel) async {
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

  //int saveIdx = 0;

  Widget _getItemPane() {
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
          //if (kDebugMode) print('${bookModel.getMid} is Favorites=${_favoritesBookIdMap[bookModel.getMid]}');
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
                    // return SizedBox(
                    //   width: itemWidth,
                    //   height: itemHeight,
                    //   child: Center(child: BTN.fill_gray_t_es(text: 'create sample', onPressed: () {
                    //     if (saveIdx < bookManagerHolder!.modelList.length) {
                    //       BookModel bookData = bookManagerHolder!.modelList[saveIdx] as BookModel;
                    //       bookPublishedManagerHolder!.saveSample(bookData);
                    //       saveIdx++;
                    //     }
                    //   })),
                    // );
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (_onceDBGetComplete != null) {
    //   return _getItemPane();
    // }
    var retval = Scrollbar(
      controller: widget.scrollController,
      child: CretaManager.waitDatum(
        managerList: [
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
