// ignore_for_file: prefer_const_constructors

//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/hycop/account/account_manager.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:url_launcher/link.dart';
import '../../../design_system/buttons/creta_button_wrapper.dart';
//import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
//import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
// import 'package:image_network/image_network.dart';
// import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../../common/creta_utils.dart';
import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
// import '../../../design_system/menu/creta_popup_menu.dart';
// import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
// import '../../../design_system/menu/creta_drop_down_button.dart';
// import '../../../design_system/text_field/creta_search_bar.dart';
//import '../creta_book_ui_item.dart';
//import '../community_sample_data.dart';
//import 'community_right_pane_mixin.dart';
import '../../../data_io/book_manager.dart';
import '../../../model/app_enums.dart';
import '../../../model/book_model.dart';
import '../../../model/creta_model.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/component/custom_image.dart';
import '../../../design_system/creta_font.dart';
import '../../../design_system/creta_color.dart';
//import '../../../design_system/buttons/creta_button.dart';
import '../../../design_system/component/snippet.dart';

//const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
const double _rightViewBannerMaxHeight = 436;
//const double _rightViewBannerMinHeight = 188 + 4;
//const double _rightViewToolbarHeight = 76;
//
const double _itemDefaultWidth = 290.0;
const double _itemDefaultHeight = 230.0;
const double _itemDescriptionHeight = 58;

bool isInUsingCanvaskit = false;

class CommunityRightHomePane extends StatefulWidget {
  final double pageWidth;
  final double pageHeight;
  final ScrollController scrollController;
  final BookType filterBookType;
  final BookSort filterBookSort;
  final PermissionType filterPermissionType;
  //String filterSearchKeyword;
  const CommunityRightHomePane({
    super.key,
    required this.pageWidth,
    required this.pageHeight,
    required this.scrollController,
    required this.filterBookType,
    required this.filterBookSort,
    required this.filterPermissionType,
    //required this.filterSearchKeyword,
  });

  @override
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> {
  //late List<CretaBookData> _cretaBookList;
  bool _onceDBGetComplete = false;
  BookManager? bookManagerHolder;
  //late final ValueKey _key = ValueKey('CRHP-${widget.filterBookType.name}-${widget.filterBookSort.name}-${widget.filterPermissionType.name}');
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    //_cretaBookList = CommunitySampleData.getCretaBookList();
    bookManagerHolder = BookManager();
    //bookManagerHolder!.configEvent(notifyModify: false);
    bookManagerHolder!.clearAll();

    Map<String, QueryValue> query = {};
    query['isRemoved'] = QueryValue(value: false);
    //query['isPublic'] = QueryValue(value: false);
    if (widget.filterBookType.index > 0) {
      query['bookType'] = QueryValue(value: widget.filterBookType.index);
    }
    if (widget.filterPermissionType != PermissionType.none) {
      List<String> sharesList = [AccountManager.currentLoginUser.userId, 'public'];
      query['shares'] = QueryValue(value: sharesList, operType: OperType.arrayContainsAny);
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
        orderBy['likeCount'] = OrderDirection.descending;
        break;
      case BookSort.updateTime:
      default:
        orderBy['updateTime'] = OrderDirection.descending;
        break;
    }

    bookManagerHolder!.queryFromDB(
      query,
      //limit: ,
      orderBy: orderBy,
    );
    // bookManagerHolder!.myDataOnly(
    //   AccountManager.currentLoginUser.email,
    // );
  }

  Widget getItemPane() {
    Size paneSize = Size(widget.pageWidth, widget.pageHeight);
    int columnCount = (paneSize.width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    if (columnCount == 0) columnCount = 1;

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
            _rightViewLeftPane, _rightViewBannerMaxHeight, _rightViewRightPane, _rightViewBottomPane),
        itemCount: bookManagerHolder!.modelList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookUIItem(
                  key: GlobalObjectKey(bookManagerHolder!.modelList[index].mid),
                  bookModel: bookManagerHolder!.modelList[index] as BookModel,
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookUIItem(
                      key: GlobalObjectKey(bookManagerHolder!.modelList[index].mid),
                      bookModel: bookManagerHolder!.modelList[index] as BookModel,
                      width: itemWidth,
                      height: itemHeight,
                    );
                  },
                );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_onceDBGetComplete) {
      return getItemPane();
    }
    var retval = CretaModelSnippet.waitData(
      manager: bookManagerHolder!,
      //userId: AccountManager.currentLoginUser.email,
      consumerFunc: getItemPane,
    );
    _onceDBGetComplete = true;
    return retval;
  }
}

class HoverImage extends StatefulWidget {
  final String image;

  const HoverImage({super.key, required this.image});

  @override
  State<HoverImage> createState() => _HoverImageState();
}

class _HoverImageState extends State<HoverImage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  late Animation padding;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 275),
      vsync: this,
    );
    _animation = Tween(begin: 1.0, end: 1.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    padding = Tween(begin: 0.0, end: -25.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.ease, reverseCurve: Curves.easeIn));
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _controller.forward();
        });
      },
      onExit: (value) {
        setState(() {
          _controller.reverse();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0.0, 20.0),
              spreadRadius: -10.0,
              blurRadius: 20.0,
            )
          ],
        ),
        child: Container(
          height: 220.0,
          width: 170.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          clipBehavior: Clip.hardEdge,
          transform: Matrix4(
              _animation.value, 0, 0, 0, 0, _animation.value, 0, 0, 0, 0, 1, 0, padding.value, padding.value, 0, 1),
          child: Image.network(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CretaBookUIItem extends StatefulWidget {
  final BookModel bookModel;
  final double width;
  final double height;

  const CretaBookUIItem({
    required super.key,
    required this.bookModel,
    required this.width,
    required this.height,
  });

  @override
  State<CretaBookUIItem> createState() => _CretaBookUIItemState();
}

class _CretaBookUIItemState extends State<CretaBookUIItem> {
  bool _mouseOver = false;
  bool _popmenuOpen = false;

  late List<CretaMenuItem> _popupMenuList;

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
            context: context, globalKey: widget.key as GlobalKey, popupMenu: _popupMenuList, initFunc: setPopmenuOpen)
        .then((value) {
      logger.finest('팝업메뉴 닫기');
      setState(() {
        _popmenuOpen = false;
      });
    });
  }

  void _editItem() {
    logger.finest('편집하기(${widget.bookModel.name})');
  }

  void _doPopupMenuPlay() {
    logger.finest('재생하기(${widget.bookModel.name})');
  }

  void _doPopupMenuEdit() {
    logger.finest('편집하기(${widget.bookModel.name})');
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('재생목록에 추가(${widget.bookModel.name})');
  }

  void _doPopupMenuShare() {
    logger.finest('공유하기(${widget.bookModel.name})');
  }

  void _doPopupMenuDownload() {
    logger.finest('다운로드(${widget.bookModel.name})');
  }

  void _doPopupMenuCopy() {
    logger.finest('복사하기(${widget.bookModel.name})');
  }

  @override
  void initState() {
    super.initState();

    _popupMenuList = [
      CretaMenuItem(
        caption: '재생하기',
        onPressed: _doPopupMenuPlay,
      ),
      CretaMenuItem(
        caption: '편집하기',
        onPressed: _doPopupMenuEdit,
      ),
      CretaMenuItem(
        caption: '재생목록에 추가',
        onPressed: _doPopupMenuAddToPlayList,
      ),
      CretaMenuItem(
        caption: '공유하기',
        onPressed: _doPopupMenuShare,
      ),
      CretaMenuItem(
        caption: '다운로드',
        onPressed: _doPopupMenuDownload,
      ),
      CretaMenuItem(
        caption: '복사하기',
        onPressed: _doPopupMenuCopy,
      ),
    ];
  }

  void setPopmenuOpen() {
    _popmenuOpen = true;
  }

  List<Widget> _getOverlayMenu() {
    if (!(_mouseOver || _popmenuOpen)) {
      return [];
    }

    return [
      Container(
        width: widget.width,
        height: 37,
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Row(
          children: [
            BTN.opacity_gray_it_s(
              width: 91,
              icon: Icons.edit_outlined,
              text: '편집하기',
              onPressed: () => _editItem(),
              alwaysShowIcon: true,
              textStyle: CretaFont.buttonSmall.copyWith(color: CretaColor.text[100]),
            ),
            Expanded(child: Container()),
            BTN.opacity_gray_i_s(
              icon: Icons.favorite_border,
              iconColor: CretaColor.text[100],
              onPressed: () {},
            ),
            SizedBox(width: 4),
            BTN.opacity_gray_i_s(
              icon: Icons.content_copy_rounded,
              iconColor: CretaColor.text[100],
              onPressed: () {},
            ),
            SizedBox(width: 4),
            BTN.opacity_gray_i_s(
              icon: Icons.menu,
              iconColor: CretaColor.text[100],
              onPressed: () => _openPopupMenu(),
            ),
          ],
        ),
      ),
      SizedBox(
        width: widget.width,
        height: widget.height - _itemDescriptionHeight,
        child: Center(
          child: Icon(Icons.play_arrow, size: 40, color: CretaColor.text[100]),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (value) {
        setState(() {
          _mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          _mouseOver = false;
        });
      },
      child: Link(
        uri: Uri.parse(AppRoutes.communityBook),
        builder: (context, function) {
          return InkWell(
            onTap: () {
              Routemaster.of(context).push(AppRoutes.communityBook);
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                // crop
                borderRadius: BorderRadius.circular(20.0),
              ),
              clipBehavior: Clip.antiAlias, // crop method
              child: Column(
                children: [
                  // 이미지 부분
                  Container(
                    width: widget.width,
                    height: widget.height - _itemDescriptionHeight,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        // 썸네일 이미지
                        ClipRect(
                          child: CustomImage(
                            key: ValueKey(widget.bookModel.thumbnailUrl.value),
                            duration: 500,
                            //hasMouseOverEffect: true,
                            width: widget.width,
                            height: widget.height - _itemDescriptionHeight,
                            image: widget.bookModel.thumbnailUrl.value,
                            hasAni: false,
                          ),
                        ),
                        // 그라데이션
                        Container(
                          width: widget.width,
                          height: widget.height - _itemDescriptionHeight,
                          decoration: (_mouseOver || _popmenuOpen) ? Snippet.shadowDeco() : null,
                        ),
                        // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                        ..._getOverlayMenu(),
                      ],
                    ),
                  ),
                  // 텍스트 부분
                  Container(
                    width: widget.width,
                    height: _itemDescriptionHeight,
                    color: (_mouseOver || _popmenuOpen) ? CretaColor.text[100] : Colors.white,
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: widget.width - 16 - 16,
                          child: Text(
                            widget.bookModel.name.value,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: CretaFont.titleMedium.copyWith(color: CretaColor.text[700]),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            // creator
                            Expanded(
                              child: Text(
                                widget.bookModel.creator,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
                              ),
                            ),
                            // gap
                            SizedBox(width: 8),
                            // time
                            Text(
                              CretaUtils.dateToDurationString(widget.bookModel.updateTime),
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // child: InkWell(
      //   onTap: () {
      //     Routemaster.of(context).push(AppRoutes.communityBook);
      //   },
      //   child: Container(
      //     width: widget.width,
      //     height: widget.height,
      //     decoration: BoxDecoration(
      //       // crop
      //       borderRadius: BorderRadius.circular(20.0),
      //     ),
      //     clipBehavior: Clip.antiAlias, // crop method
      //     child: Column(
      //       children: [
      //         // 이미지 부분
      //         Container(
      //           width: widget.width,
      //           height: widget.height - _itemDescriptionHeight,
      //           color: Colors.white,
      //           child: Stack(
      //             children: [
      //               // 썸네일 이미지
      //               ClipRect(
      //                 child: CustomImage(
      //                   key: ValueKey(widget.bookModel.thumbnailUrl.value),
      //                   duration: 500,
      //                   //hasMouseOverEffect: true,
      //                   width: widget.width,
      //                   height: widget.height - _itemDescriptionHeight,
      //                   image: widget.bookModel.thumbnailUrl.value,
      //                   hasAni: false,
      //                 ),
      //               ),
      //               // 그라데이션
      //               Container(
      //                 width: widget.width,
      //                 height: widget.height - _itemDescriptionHeight,
      //                 decoration: (_mouseOver || _popmenuOpen) ? Snippet.shadowDeco() : null,
      //               ),
      //               // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
      //               ..._getOverlayMenu(),
      //             ],
      //           ),
      //         ),
      //         // 텍스트 부분
      //         Container(
      //           width: widget.width,
      //           height: _itemDescriptionHeight,
      //           color: (_mouseOver || _popmenuOpen) ? CretaColor.text[100] : Colors.white,
      //           padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
      //           child: Column(
      //             children: [
      //               SizedBox(
      //                 width: widget.width - 16 - 16,
      //                 child: Text(
      //                   widget.bookModel.name.value,
      //                   overflow: TextOverflow.ellipsis,
      //                   textAlign: TextAlign.left,
      //                   style: CretaFont.titleMedium.copyWith(color: CretaColor.text[700]),
      //                 ),
      //               ),
      //               SizedBox(height: 5),
      //               Row(
      //                 children: [
      //                   // creator
      //                   Expanded(
      //                     child: Text(
      //                       widget.bookModel.creator,
      //                       overflow: TextOverflow.ellipsis,
      //                       textAlign: TextAlign.left,
      //                       style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
      //                     ),
      //                   ),
      //                   // gap
      //                   SizedBox(width: 8),
      //                   // time
      //                   Text(
      //                     CretaUtils.dateToDurationString(widget.bookModel.updateTime),
      //                     overflow: TextOverflow.ellipsis,
      //                     textAlign: TextAlign.left,
      //                     style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[300]),
      //                   ),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           // child: Row(
      //           //   children: [
      //           //     Expanded(
      //           //       //width: widget.width - 15 - 8 - 36 - 8,
      //           //       child: Column(
      //           //         mainAxisAlignment: MainAxisAlignment.start,
      //           //         crossAxisAlignment: CrossAxisAlignment.start,
      //           //         children: [
      //           //           SizedBox(height: 8),
      //           //           Text(
      //           //             widget.bookModel.name.value,
      //           //             overflow: TextOverflow.ellipsis,
      //           //             textAlign: TextAlign.left,
      //           //             style: CretaFont.bodyMedium.copyWith(color: CretaColor.text[700]),
      //           //           ),
      //           //           SizedBox(height: 4),
      //           //           Text(
      //           //             widget.bookModel.creator,
      //           //             overflow: TextOverflow.ellipsis,
      //           //             textAlign: TextAlign.left,
      //           //             style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[400]),
      //           //           ),
      //           //         ],
      //           //       ),
      //           //     ),
      //           //     //Expanded(child: Container()),
      //           //     SizedBox(width: 8),
      //           //     Column(
      //           //       mainAxisAlignment: MainAxisAlignment.start,
      //           //       children: [
      //           //         SizedBox(height: 9),
      //           //         BTN.fill_gray_i_l(
      //           //           icon: Icons.content_copy_rounded,
      //           //           buttonColor: CretaButtonColor.transparent,
      //           //           onPressed: () {},
      //           //         ),
      //           //       ],
      //           //     ),
      //           //     SizedBox(width: 8),
      //           //   ],
      //           // ),
      //           // child: Stack(
      //           //   children: [
      //           //     Positioned(
      //           //         left: widget.width - 37,
      //           //         top: 17,
      //           //         child: Container(
      //           //           width: 20,
      //           //           height: 20,
      //           //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
      //           //           child: Icon(
      //           //             Icons.favorite_outline,
      //           //             size: 20.0,
      //           //             color: Colors.grey[700],
      //           //           ),
      //           //         )),
      //           //     Positioned(
      //           //       left: 15,
      //           //       top: 7,
      //           //       child: Container(
      //           //           width: widget.width - 45 - 15,
      //           //           color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
      //           //           child: Text(
      //           //             widget.cretaBookData.name,
      //           //             overflow: TextOverflow.ellipsis,
      //           //             textAlign: TextAlign.left,
      //           //             style: TextStyle(
      //           //               fontSize: 16,
      //           //               color: Colors.grey[700],
      //           //               fontFamily: 'Pretendard',
      //           //             ),
      //           //           )),
      //           //     ),
      //           //     Positioned(
      //           //       left: 16,
      //           //       top: 29,
      //           //       child: Container(
      //           //         width: widget.width - 45 - 15,
      //           //         color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
      //           //         child: Text(
      //           //           widget.cretaBookData.creator,
      //           //           overflow: TextOverflow.ellipsis,
      //           //           textAlign: TextAlign.left,
      //           //           style: TextStyle(
      //           //             fontSize: 13,
      //           //             color: Colors.grey[500],
      //           //             fontFamily: 'Pretendard',
      //           //           ),
      //           //         ),
      //           //       ),
      //           //     ),
      //           //   ],
      //           // ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
