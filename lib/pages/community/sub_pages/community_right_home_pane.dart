// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
//import 'package:hycop/common/util/logger.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
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
import '../../../model/app_enums.dart';
import '../../../model/book_model.dart';
import '../../../model/creta_model.dart';

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
  final CretaLayoutRect cretaLayoutRect;
  final ScrollController scrollController;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  final String filterSearchKeyword;
  const CommunityRightHomePane({
    super.key,
    required this.cretaLayoutRect,
    required this.scrollController,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    required this.filterSearchKeyword,
  });

  @override
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> {
  //late List<CretaBookData> _cretaBookList;
  bool _onceDBGetComplete = false;
  BookPublishedManager? bookPublishedManagerHolder;
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
    bookPublishedManagerHolder!.clearAll();

    // bookManagerHolder = BookManager();
    // //bookManagerHolder!.configEvent(notifyModify: false);
    // bookManagerHolder!.clearAll();

    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    //query['isPublic'] = QueryValue(value: false);
    if (widget.filterBookType.index > 0) {
      query['bookType'] = QueryValue(value: widget.filterBookType.index);
    }
    List<String> sharesList = ['public'];
    if (widget.filterPermissionType == PermissionType.owner) {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
    }
    if (widget.filterPermissionType == PermissionType.writer) {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>${AccountManager.currentLoginUser.userId}');
    }
    if (widget.filterPermissionType == PermissionType.reader) {
      sharesList.add('<${PermissionType.owner.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.writer.name}>${AccountManager.currentLoginUser.userId}');
      sharesList.add('<${PermissionType.reader.name}>${AccountManager.currentLoginUser.userId}');
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

    bookPublishedManagerHolder!.queryFromDB(
      query,
      //limit: ,
      orderBy: orderBy,
    );
  }

  int saveIdx = 0;

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
        itemCount: bookPublishedManagerHolder!.modelList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemSizeRatio, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookUIItem(
                  key: GlobalObjectKey(bookPublishedManagerHolder!.modelList[index].mid),
                  bookModel: bookPublishedManagerHolder!.modelList[index] as BookModel,
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookUIItem(
                      key: GlobalObjectKey(bookPublishedManagerHolder!.modelList[index].mid),
                      bookModel: bookPublishedManagerHolder!.modelList[index] as BookModel,
                      width: itemWidth,
                      height: itemHeight,
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
    var retval = CretaModelSnippet.waitData(
      manager: bookPublishedManagerHolder!,
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: _getItemPane,
    );
    _onceDBGetComplete = true;
    return retval;
  }
}
