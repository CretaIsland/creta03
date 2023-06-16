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
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/playlist_manager.dart';
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
  //late List<CretaBookData> _cretaBookList;
  bool _onceDBGetComplete = false;
  late BookPublishedManager bookPublishedManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late PlaylistManager playlistManagerHolder;
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  final List<PlaylistModel> _playlistModelList = [];
  //BookManager? bookManagerHolder;
  //late final ValueKey _key = ValueKey('CRHP-${widget.filterBookType.name}-${widget.filterBookSort.name}-${widget.filterPermissionType.name}');
  final GlobalKey _key = GlobalKey();
  final _itemSizeRatio = _itemMinWidth / _itemMinHeight;

  @override
  void initState() {
    super.initState();

    //_cretaBookList = CommunitySampleData.getCretaBookList();
    bookPublishedManagerHolder = BookPublishedManager();
    //bookManagerHolder!.configEvent(notifyModify: false);
    //bookPublishedManagerHolder.clearAll();

    // bookManagerHolder = BookManager();
    // //bookManagerHolder!.configEvent(notifyModify: false);
    // bookManagerHolder!.clearAll();

    favoritesManagerHolder = FavoritesManager();
    //bookManagerHolder!.configEvent(notifyModify: false);
    //favoritesManagerHolder.clearAll();

    playlistManagerHolder = PlaylistManager();

/*
    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    //query['isPublic'] = QueryValue(value: false);
    if (widget.filterBookType.index > 0) {
      query['bookType'] = QueryValue(value: widget.filterBookType.index);
    }
    final List<String> sharesList = [];
    if (widget.filterPermissionType == PermissionType.owner) {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
      //sharesList.add('<${PermissionType.owner.name}>public'); // <owner>public 은 없음
    } else if (widget.filterPermissionType == PermissionType.writer) {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>public');
    } else /*if (widget.filterPermissionType == PermissionType.reader)*/ {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>public');
      sharesList.add('<${PermissionType.reader.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.reader.name}>public');
    }
    query['shares'] = QueryValue(value: sharesList, operType: OperType.arrayContainsAny);

    if (widget.filterSearchKeyword.isNotEmpty) {
      // Elasticsearch 될때까지 막아둠
      //query['name'] = QueryValue(value: widget.filterSearchKeyword, operType: OperType.like ??? );
    }

    Map<String, OrderDirection> orderBy = {};
    switch (widget.filterBookSort) {
      case BookSort.name:
        orderBy['name'] = OrderDirection.ascending;
        break;
      case BookSort.likeCount:
        orderBy['likeCount'] = OrderDirection.descending;
        break;
      case BookSort.viewCount:
        orderBy['viewCount'] = OrderDirection.descending;
        break;
      case BookSort.updateTime:
      default:
        orderBy['updateTime'] = OrderDirection.descending;
        break;
    }

    bookPublishedManagerHolder.queryFromDB(
      query,
      //limit: ,
      orderBy: orderBy,
    );
 */
    bookPublishedManagerHolder.addCretaFilters(
      bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
      sortTimeName: 'updateTime',
    );
    bookPublishedManagerHolder.queryByAddedContitions();
    bookPublishedManagerHolder.isGetListFromDBComplete().then((value) {
      _getFavoritesFromDB();
    });

    playlistManagerHolder.addWhereClause('userId', QueryValue(value: AccountManager.currentLoginUser.userId));
    playlistManagerHolder.queryByAddedContitions();
    playlistManagerHolder.isGetListFromDBComplete().then((value) {
      for(var plModel in playlistManagerHolder.modelList) {
        _playlistModelList.add(plModel as PlaylistModel);
      }
    });
  }

  void _getFavoritesFromDB() {
    if (kDebugMode) print('_getFavoritesFromDB');
    if (bookPublishedManagerHolder.modelList.isEmpty) {
      if (kDebugMode) print('bookPublishedManagerHolder.modelList is empty');
      setState(() {
        _onceDBGetComplete = true;
      });
    } else {
      // List<String> bookIdList = [];
      // if (kDebugMode) print('bookPublishedManagerHolder.modelList count=${bookPublishedManagerHolder.modelList.length}');
      // for (var exModel in bookPublishedManagerHolder.modelList) {
      //   BookModel bookModel = exModel as BookModel;
      //   bookIdList.add(bookModel.mid);
      //   if (kDebugMode) print('_favoritesBookIdMap add ${bookModel.mid}');
      //   _favoritesBookIdMap[bookModel.mid] = false;
      // }
      // if (kDebugMode) print('getFavoritesFromBookIdList');
      // favoritesManagerHolder.getFavoritesFromBookIdList(bookIdList);
      favoritesManagerHolder.queryFavoritesFromBookModelList(bookPublishedManagerHolder.modelList);
      favoritesManagerHolder.isGetListFromDBComplete().then((value) {
        if (kDebugMode) print('favoritesManagerHolder.modelList count=${favoritesManagerHolder.modelList.length}');
        for (var model in favoritesManagerHolder.modelList) {
          FavoritesModel fModel = model as FavoritesModel;
          if (kDebugMode) print('_favoritesBookIdMap[${fModel.bookId}] = true');
          _favoritesBookIdMap[fModel.bookId] = true;
        }
        _onceDBGetComplete = true;
        // CretaModelSnippet.waitDatum 에서 화면 갱신됨
      });
    }
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
    if(kDebugMode) print('_newPlaylistDone($name, $isPublic, $bookId)');
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
    if(kDebugMode) print('_playlistSelectDone($playlistMid, $bookId)');
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
        itemCount: bookPublishedManagerHolder.modelList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemSizeRatio, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          BookModel bookModel = bookPublishedManagerHolder.modelList[index] as BookModel;
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
      managerList: [bookPublishedManagerHolder, favoritesManagerHolder, playlistManagerHolder],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _getItemPane,
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
