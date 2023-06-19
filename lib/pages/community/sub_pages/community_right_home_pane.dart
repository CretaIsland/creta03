// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
//import 'package:creta03/design_system/component/custom_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../../design_system/component/creta_popup.dart';
//import '../../../design_system/dialog/creta_dialog.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
// import '../../../design_system/creta_color.dart';
// import '../../../design_system/creta_font.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../../common/creta_utils.dart';
//import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../../design_system/component/creta_leftbar.dart';
import '../../../design_system/component/creta_layout_rect.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../../../data_io/book_manager.dart';
import '../../../data_io/creta_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import '../../../model/app_enums.dart';
import '../../../model/book_model.dart';
import '../../../model/creta_model.dart';
import '../../../model/favorites_model.dart';
import '../../../model/playlist_model.dart';

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
  late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  late WatchHistoryManager dummyManagerHolder;
  final List<BookModel> _cretaBooksList = [];
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final List<PlaylistModel> _playlistModelList = [];
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    super.initState();

    bookPublishedManagerHolder = BookPublishedManager();
    favoritesManagerHolder = FavoritesManager();
    playlistManagerHolder = PlaylistManager();
    dummyManagerHolder = WatchHistoryManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
        QuerySet(playlistManagerHolder, _getPlaylistsFromDB, _resultPlaylistsFromDB),
        QuerySet(dummyManagerHolder, _dummyCompleteDB, null),
      ],
      completeFunc: () {
        _onceDBGetComplete = true;
      },
    );
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
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
    for (var model in modelList) {
      BookModel bModel = model as BookModel;
      if (kDebugMode) print('_resultBooksFromDB(bookId=${bModel.mid})');
      _cretaBooksList.add(bModel);
    }
  }

  void _getFavoritesFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_getFavoritesFromDB');
    // if (modelList.isEmpty) {
    //   if (kDebugMode) print('bookPublishedManagerHolder.modelList is empty');
    //   favoritesManagerHolder.setState(DBState.idle);
    //   return;
    // }
    favoritesManagerHolder.queryFavoritesFromBookModelList(modelList);
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
    playlistManagerHolder.addWhereClause('userId', QueryValue(value: AccountManager.currentLoginUser.userId));
    playlistManagerHolder.queryByAddedContitions();
  }

  void _resultPlaylistsFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('_playlistModelList.modelList.length=${modelList.length}');
    for (var plModel in modelList) {
      _playlistModelList.add(plModel as PlaylistModel);
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    dummyManagerHolder.setState(DBState.idle);
  }

  void _addToFavorites(String bookId, bool isFavorites) async {
    if (isFavorites) {
      // already in favorites => remove favorites from DB
      await favoritesManagerHolder.removeFavoritesFromDB(bookId, AccountManager.currentLoginUser.userId);
      setState(() {
        _favoritesBookIdMap[bookId] = false;
      });
    } else {
      // not exist in favorites => add favorites to DB
      await favoritesManagerHolder.addFavoritesToDB(bookId, AccountManager.currentLoginUser.userId);
      setState(() {
        _favoritesBookIdMap[bookId] = true;
      });
    }
  }

  void _newPlaylistDone(String name, bool isPublic, String bookId) async {
    if (kDebugMode) print('_newPlaylistDone($name, $isPublic, $bookId)');
    PlaylistModel newPlaylist = await playlistManagerHolder.createNewPlaylist(
      name: name,
      userId: AccountManager.currentLoginUser.userId,
      channelId: 'test_channel_id',
      isPublic: isPublic,
      bookIdList: [bookId],
    );
    //
    // success messagebox
    //
    _playlistModelList.add(newPlaylist);
  }

  void _newPlaylist(String bookId) {
    showDialog(
      context: context,
      builder: (context) => PlaylistManager.newPlaylistPopUp(
        context: context,
        bookId: bookId,
        onNewPlaylistDone: _newPlaylistDone,
      ),
    );
  }

  void _playlistSelectDone(String playlistMid, String bookId) async {
    if (kDebugMode) print('_playlistSelectDone($playlistMid, $bookId)');
    await playlistManagerHolder.addBookToPlaylist(playlistMid, bookId);
    //
    // success messagebox
    //
  }

  void _addToPlaylist(String bookId) async {
    showDialog(
      context: context,
      builder: (context) => PlaylistManager.playlistSelectPopUp(
        context: context,
        bookId: bookId,
        playlistModelList: _playlistModelList,
        onNewPlaylist: _newPlaylist,
        onSelectDone: _playlistSelectDone,
      ),
    );
  }

  //int saveIdx = 0;

  Widget _getItemPane() {
    final int columnCount =
        CretaUtils.getItemColumnCount(widget.cretaLayoutRect.childWidth, _itemMinWidth, _rightViewItemGapX);

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
          if (kDebugMode) print('${bookModel.mid} is Favorites=${_favoritesBookIdMap[bookModel.mid]}');
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookUIItem(
                  key: GlobalObjectKey(bookModel.mid),
                  bookModel: bookModel,
                  width: itemWidth,
                  height: itemHeight,
                  isFavorites: _favoritesBookIdMap[bookModel.mid] ?? false,
                  addToFavorites: _addToFavorites,
                  addToPlaylist: _addToPlaylist,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookUIItem(
                      key: GlobalObjectKey(bookModel.mid),
                      bookModel: bookModel,
                      width: itemWidth,
                      height: itemHeight,
                      isFavorites: _favoritesBookIdMap[bookModel.mid] ?? false,
                      addToFavorites: _addToFavorites,
                      addToPlaylist: _addToPlaylist,
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
    if (_onceDBGetComplete) {
      return _getItemPane();
    }
    var retval = CretaModelSnippet.waitDatum(
      managerList: [bookPublishedManagerHolder, favoritesManagerHolder, playlistManagerHolder, dummyManagerHolder],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _getItemPane,
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
