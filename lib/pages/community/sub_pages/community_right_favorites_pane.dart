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
import '../../../common/creta_utils.dart';
import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/book_published_manager.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../../../model/app_enums.dart';
import '../../../model/creta_model.dart';
import '../../../model/book_model.dart';
import '../../../model/favorites_model.dart';

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
    final Map<String, BookModel> _cretaBookMap = {};
  final List<FavoritesModel> _favoritesBookList = []; // <Book.mid, isFavorites>
  final Map<String, bool> _favoritesBookIdMap = {}; // <Book.mid, isFavorites>
  bool _onceDBGetComplete = false;

  @override
  void initState() {
    super.initState();

    bookPublishedManagerHolder = BookPublishedManager();
    favoritesManagerHolder = FavoritesManager();

    favoritesManagerHolder.addCretaFilters(
      //bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
    );
    favoritesManagerHolder.addWhereClause(
      'userId',
      QueryValue(value: AccountManager.currentLoginUser.userId, operType: OperType.isEqualTo),
    );
    favoritesManagerHolder.queryByAddedContitions();
    favoritesManagerHolder.isGetListFromDBComplete().then((value) {
      if (kDebugMode) print('favoritesManagerHolder.model.length=${favoritesManagerHolder.modelList.length}');
      _getBookDataFromDB();
    });
  }

  void _getBookDataFromDB() {
    if (favoritesManagerHolder.modelList.isEmpty) {
      setState(() {
        _onceDBGetComplete = true;
      });
    } else {
      List<String> bookIdList = [];
      for (var exModel in favoritesManagerHolder.modelList) {
        FavoritesModel fModel = exModel as FavoritesModel;
        bookIdList.add(fModel.bookId);
        _favoritesBookList.add(fModel);
        _favoritesBookIdMap[fModel.bookId] = true;
      }
      bookPublishedManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
      bookPublishedManagerHolder.addWhereClause('mid', QueryValue(value: bookIdList, operType: OperType.whereIn));
      bookPublishedManagerHolder.queryByAddedContitions();
      bookPublishedManagerHolder.isGetListFromDBComplete().then((value) {
        if (kDebugMode) print('bookPublishedManagerHolder.model.length=${bookPublishedManagerHolder.modelList.length}');
        for (var model in bookPublishedManagerHolder.modelList) {
          BookModel bModel = model as BookModel;
          _cretaBookMap[bModel.mid] = bModel;
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

  Widget _getItemPane() {
    final int columnCount =
        CretaUtils.getItemColumnCount(widget.cretaLayoutRect.childWidth, _itemMinWidth, _rightViewItemGapX);

    double itemWidth = -1;
    double itemHeight = -1;

    BookModel dummyBookModel = BookModel('');

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
        itemCount: _favoritesBookList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemSizeRatio, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          FavoritesModel fModel = _favoritesBookList[index];
          BookModel bookModel = _cretaBookMap[fModel.bookId] ?? dummyBookModel;
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookUIItem(
                  key: GlobalObjectKey(bookModel.mid),
                  bookModel: bookModel,
                  width: itemWidth,
                  height: itemHeight,
                  isFavorites: _favoritesBookIdMap[bookModel.mid] ?? false,
                  addToFavorites: _addToFavorites,
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
      managerList: [bookPublishedManagerHolder, favoritesManagerHolder],
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _getItemPane,
    );
    //_onceDBGetComplete = true;
    return retval;
  }
}
