// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:intl/intl.dart';
import 'package:creta_common/common/creta_common_utils.dart';

//import '../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import 'package:creta_common/common/creta_color.dart';
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
import '../../../design_system/component/creta_layout_rect.dart';
import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
//import '../creta_playlist_ui_item.dart';
//import 'package:deep_collection/deep_collection.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
import '../../../data_io/watch_history_manager.dart';
import '../../../data_io/book_published_manager.dart';
import '../../../data_io/favorites_manager.dart';
import '../../../data_io/book_manager.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import '../../../data_io/channel_manager.dart';
import 'package:creta_common/model/app_enums.dart';
//import '../../../design_system/component/snippet.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../../../model/watch_history_model.dart';
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
// //const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 196;
// const double _rightViewToolbarHeight = 76;
//
const double _itemMinWidth = 290.0;
const double _itemMinHeight = 230.0;

class CommunityRightWatchHistoryPane extends StatefulWidget {
  const CommunityRightWatchHistoryPane({
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
  State<CommunityRightWatchHistoryPane> createState() => _CommunityRightWatchHistoryPaneState();
}

class _CommunityRightWatchHistoryPaneState extends State<CommunityRightWatchHistoryPane> {
  final GlobalKey _key = GlobalKey();

  final Map<String, List<WatchHistoryModel>> _cretaBookDataMap = {};
  final _itemSizeRatio = _itemMinHeight / _itemMinWidth;
  double _itemWidth = 0;
  double _itemHeight = 0;

  late WatchHistoryManager watchHistoryManagerHolder;
  late BookPublishedManager bookPublishedManagerHolder;
  late TeamManager teamManagerHolder;
  late UserPropertyManager userPropertyManagerHolder;
  late ChannelManager channelManagerHolder;
  late FavoritesManager favoritesManagerHolder;
  late BookManager dummyManagerHolder;
  final Map<String, bool> _favoritesBookIdMap = {};
  final Map<String, BookModel> _cretaBooksMap = {}; // <Book.Mid, Book>
  final Map<String, String> _teamIdMap = {};
  final Map<String, TeamModel> _teamMap = {}; // <TeamManager.mid, TeamModel>
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

    watchHistoryManagerHolder = WatchHistoryManager();
    bookPublishedManagerHolder = BookPublishedManager();
    favoritesManagerHolder = FavoritesManager();
    dummyManagerHolder = BookManager();
    teamManagerHolder = TeamManager();
    userPropertyManagerHolder = UserPropertyManager();
    channelManagerHolder = ChannelManager();

    CretaManager.startQueries(
      joinList: [
        QuerySet(watchHistoryManagerHolder, _getWatchHistoriesFromDB, null),
        QuerySet(bookPublishedManagerHolder, _getBooksFromDB, _resultBooksFromDB),
        QuerySet(channelManagerHolder, _getChannelsFromDB, _resultChannelsFromDB),
        QuerySet(userPropertyManagerHolder, _getUserPropertyFromDB, _resultUserPropertyFromDB),
        QuerySet(teamManagerHolder, _getTeamsFromDB, _resultTeamsFromDB),
        QuerySet(favoritesManagerHolder, _getFavoritesFromDB, _resultFavoritesFromDB),
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

  void _getWatchHistoriesFromDB(List<AbsExModel> modelList) {
    watchHistoryManagerHolder.addCretaFilters(
      //bookType: widget.filterBookType,
      bookSort: widget.filterBookSort,
      //permissionType: widget.filterPermissionType,
      searchKeyword: widget.filterSearchKeyword,
    );
    watchHistoryManagerHolder.addWhereClause('isRemoved', QueryValue(value: false));
    watchHistoryManagerHolder.addWhereClause(
      'userId',
      QueryValue(value: AccountManager.currentLoginUser.email),
    );
    watchHistoryManagerHolder.queryByAddedContitions();
  }

  void _getBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('---_getDBDataList');
    if (modelList.isEmpty) {
      bookPublishedManagerHolder.setState(DBState.idle);
      return;
    }
    // join 이 불가능하므로, ID리스트로부터 데이터를 get
    List<String> bookIdList = [];
    for (var model in modelList) {
      WatchHistoryModel whModel = model as WatchHistoryModel;
      bookIdList.add(whModel.bookId);
    }
    bookPublishedManagerHolder.queryFromIdList(bookIdList);
  }

  void _resultBooksFromDB(List<AbsExModel> modelList) {
    if (kDebugMode) print('bookPublishedManagerHolder.model.length=${modelList.length}');
    for (var model in modelList) {
      BookModel bookModel = model as BookModel;
      _cretaBooksMap[bookModel.getMid] = bookModel;
      _userIdMap[bookModel.creator] = bookModel.creator; // <= email
      for (var channelId in bookModel.channels) {
        _channelIdMap[channelId] = channelId;
      }
    }
  }

  void _getChannelsFromDB(List<AbsExModel> modelList) {
    if (_channelIdMap.isEmpty) {
      channelManagerHolder.setState(DBState.idle);
      return;
    }
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
    if (modelList.isEmpty) {
      favoritesManagerHolder.setState(DBState.idle);
      return;
    }
    List<String> bookIdList = [];
    _cretaBooksMap.forEach((key, bookModel) {
      bookIdList.add(bookModel.getMid);
      _favoritesBookIdMap[bookModel.getMid] = false;
    });
    // for (var exModel in modelList) {
    //   BookModel bookModel = exModel as BookModel;
    //   bookIdList.add(bookModel.getMid);
    //   _favoritesBookIdMap[bookModel.getMid] = false;
    // }
    favoritesManagerHolder.queryFavoritesFromBookIdList(bookIdList);
  }

  void _resultFavoritesFromDB(List<AbsExModel> modelList) {
    for (var model in modelList) {
      FavoritesModel fModel = model as FavoritesModel;
      _favoritesBookIdMap[fModel.bookId] = true;
    }
  }

  void _dummyCompleteDB(List<AbsExModel> modelList) {
    dummyManagerHolder.setState(DBState.idle);
  }

  // <!-- my code
  // Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
  //   Map<String, List<CretaBookData>> rearrangeMap = {};
  //   for(CretaBookData bookData in bookDataList) {
  //     String createDate = '${bookData.createDate.year}.${bookData.createDate.month}.${bookData.createDate.day}';
  //     List<CretaBookData>? dataList = rearrangeMap[createDate];
  //     if (dataList == null) {
  //       rearrangeMap[createDate] = [bookData];
  //     } else {
  //       dataList.add(bookData);
  //     }
  //   }
  //   return rearrangeMap;
  // }
  // -->
  // <!-- GPT3.5 code
  // Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
  //   final Map<String, List<CretaBookData>> rearrangeMap = {};
  //   for (final bookData in bookDataList) {
  //     final String createDate = bookData.createDate.toString("yyyy.MM.dd");
  //     rearrangeMap.putIfAbsent(createDate, () => []).add(bookData);
  //   }
  //   return rearrangeMap;
  // }
  // -->
  // <!-- final code
  // Map<String, List<CretaBookData>> _rearrangeCretaBookData(List<CretaBookData> bookDataList) {
  //   final Map<String, List<CretaBookData>> rearrangeMap = {};
  //   for (final bookData in bookDataList) {
  //     final String createDate = DateFormat('yyyy.MM.dd').format(bookData.createDate);
  //     rearrangeMap.putIfAbsent(createDate, () => []).add(bookData);
  //   }
  //   return rearrangeMap;
  // }
  // -->

  // <!-- my code
  // List<Widget> _getItemWidgetList() {
  //   final List<Widget> itemWidgetList = [];
  //   final List<String> keyList = _cretaBookDataMap.deepSortByKey().keys.toList();
  //   for (int i = keyList.length - 1; i >= 0; i--) {
  //     final String key = keyList[i];
  //     final List<CretaBookData>? dataList = _cretaBookDataMap[key];
  //     if (dataList == null) continue;
  //     itemWidgetList.add(Text(key));
  //     itemWidgetList.add(Wrap(
  //       children: dataList
  //           .map((data) => CretaBookItem(key: data.uiKey, cretaBookData: data, width: 320, height: 240))
  //           .toList(),
  //     ));
  //   }
  //   return itemWidgetList;
  // }
  // -->
  // <!-- GPT3.5
  // List<Widget> _getItemWidgetList() {
  //   final List<Widget> itemWidgetList = [];
  //   final List<String> keyList = _cretaBookDataMap.keys.toList()..sort();
  //   for (final key in keyList.reversed) {
  //     final List<CretaBookData>? dataList = _cretaBookDataMap[key];
  //     if (dataList == null) continue;
  //     itemWidgetList
  //       ..add(Text(key))
  //       ..addAll(dataList.expand((data) => [
  //       CretaBookItem(key: data.uiKey, cretaBookData: data, width: 320, height: 240),
  //     ]));
  //   }
  //   return itemWidgetList;
  // }
  // -->
  // <!-- final code
  List<Widget> _getItemWidgetList(double width) {
    final List<Widget> itemWidgetList = [];
    final List<String> keyList = _cretaBookDataMap.keys.toList()..sort();
    for (final key in keyList.reversed) {
      final List<WatchHistoryModel> dataList = _cretaBookDataMap[key] ?? [];
      itemWidgetList
        ..add(Container(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
          child: Text(
            key,
            style: CretaFont.titleELarge
                .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
          ),
        ))
        ..add(Wrap(
          direction: Axis.horizontal,
          spacing: _rightViewItemGapX, // 좌우 간격
          runSpacing: _rightViewItemGapY, // 상하 간격
          children: dataList.map((data) {
            if (kDebugMode) print('---watchhistorykey=${data.getMid}');
            ChannelModel? chModel =
                data.bookModel!.channels.isEmpty ? null : _channelMap[data.bookModel!.channels[0]];
            return CretaBookUIItem(
              key: GlobalObjectKey(data.getMid), //GlobalObjectKey('${index++}+${data.getMid}'),
              bookModel: data.bookModel!,
              userPropertyModel: _userPropertyMap[data.bookModel!.creator],
              channelModel: chModel,
              watchHistoryModel: data,
              width: _itemWidth,
              height: _itemHeight,
              isFavorites: _favoritesBookIdMap[data.bookModel?.getMid ?? ''] ?? false,
            );
          }).toList(),
        ));
    }
    return itemWidgetList;
  }
  // -->

  void _rearrangeCretaBookData() {
    if (kDebugMode) print('---_rearrangeCretaBookData');
    for (var exModel in watchHistoryManagerHolder.modelList) {
      final whModel = exModel as WatchHistoryModel;
      if (kDebugMode) print('---add(${whModel.getMid})');
      for (var model in bookPublishedManagerHolder.modelList) {
        final bookModel = model as BookModel;
        if (bookModel.getMid == whModel.bookId) {
          whModel.bookModel = bookModel;
          //final String lastUpdateTime = DateFormat('yyyy.MM.dd').format(whModel.lastUpdateTime);
          final String lastUpdateTime = DateFormat('yyyy.MM.dd').format(whModel.updateTime);
          _cretaBookDataMap.putIfAbsent(lastUpdateTime, () => []).add(whModel);
          break;
        }
      }
    }
  }

  Widget _getItemPane() {
    if (kDebugMode) print('---_getItemPane');
    if (_cretaBookDataMap.isEmpty) _rearrangeCretaBookData();
    final width = widget.cretaLayoutRect.childWidth;
    final int columnCount =
        CretaCommonUtils.getItemColumnCount(width, _itemMinWidth, _rightViewItemGapX);
    _itemWidth = ((width + _rightViewItemGapX) ~/ columnCount) - _rightViewItemGapX;
    _itemHeight = _itemWidth * _itemSizeRatio;
    return Scrollbar(
      key: _key,
      thumbVisibility: true,
      controller: widget.scrollController,
      child: SizedBox(
        width: widget.cretaLayoutRect.width,
        child: SingleChildScrollView(
          controller: widget.scrollController,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              widget.cretaLayoutRect.childLeftPadding,
              widget.cretaLayoutRect.childTopPadding,
              widget.cretaLayoutRect.childRightPadding,
              widget.cretaLayoutRect.childBottomPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getItemWidgetList(widget.cretaLayoutRect.childWidth),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _waitSignWidget() {
  //   if (kDebugMode) print('---_waitSignWidget');
  //   return Center(child: CretaSnippet.showWaitSign());
  // }

  // Future<List<AbsExModel>>? wait() async {
  //   List<CretaManager> mngList = [watchHistoryManagerHolder!, bookPublishedManagerHolder!];
  //   List<AbsExModel>? value;
  //   for (var mng in mngList) {
  //     value = await mng.isGetListFromDBComplete();
  //   }
  //   if (kDebugMode) print('---_onceDBDataListGetComplete(true)');
  //   _onceDBDataListGetComplete = true;
  //   return Future.value(value);
  // }

  @override
  Widget build(BuildContext context) {
    //if (_onceDBIDListGetComplete && _onceDBDataListGetComplete) {
    // if (_onceDBDataListGetComplete) {
    //   if (kDebugMode) print('---build-1');
    //   return _getItemPane();
    // }
    // Widget retval = SizedBox.shrink();
    // if (_onceDBIDListGetComplete == false) {
    //   if (kDebugMode) print('---build-2');
    //   retval = CretaManager.waitData(
    //     manager: watchHistoryManagerHolder!,
    //     consumerFunc: _waitSignWidget,
    //     completeFunc: _getDBDataList,
    //   );
    // }
    // else if (_onceDBDataListGetComplete == false) {
    //   if (kDebugMode) print('---build-3');
    //   retval = CretaManager.waitData(
    //     manager: bookPublishedManagerHolder!,
    //     consumerFunc: _getItemPane,
    //     completeFunc: () { _onceDBDataListGetComplete = true; },
    //   );
    // }
    // var retval = FutureBuilder<List<AbsExModel>>(
    //     future: wait(),
    //     builder: (context, AsyncSnapshot<List<AbsExModel>> snapshot) {
    //       if (snapshot.hasError) {
    //         //error가 발생하게 될 경우 반환하게 되는 부분
    //         logger.severe("data fetch error(WaitDatat)");
    //         return const Center(child: Text('data fetch error(WaitDatat)'));
    //       }
    //       if (snapshot.hasData == false) {
    //         logger.finest("wait data ...(WaitDatat)");
    //         return Center(
    //           child: CretaSnippet.showWaitSign(),
    //         );
    //       }
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         logger.finest("founded ${snapshot.data!.length}");
    //         // if (snapshot.data!.isEmpty) {
    //         //   return const Center(child: Text('no book founded'));
    //         // }
    //         if (kDebugMode) print('FutureBuilder end');
    //         return _getItemPane();
    //       }
    //       return Container();
    //     });
    // if (_onceDBGetComplete == false) {
    //   if (kDebugMode) print('---build-3');
    return Scrollbar(
      controller: widget.scrollController,
      child: CretaManager.waitDatum(
        managerList: [
          watchHistoryManagerHolder,
          bookPublishedManagerHolder,
          channelManagerHolder,
          userPropertyManagerHolder,
          teamManagerHolder,
          favoritesManagerHolder,
          dummyManagerHolder
        ],
        consumerFunc: _getItemPane,
        dbComplete: _dbGetComplete,
      ),
    );
    // }
    // return _getItemPane();
  }
}
