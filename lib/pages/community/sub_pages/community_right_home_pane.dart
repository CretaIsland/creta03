// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
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
//import '../design_system/creta_color.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../../routes.dart';
//import '../../../design_system/component/creta_leftbar.dart';
import '../../../design_system/menu/creta_popup_menu.dart';
import '../../../design_system/component/creta_banner_pane.dart';
//import '../../../design_system/menu/creta_drop_down.dart';
import '../../../design_system/menu/creta_drop_down_button.dart';
import '../../../design_system/text_field/creta_search_bar.dart';
import '../creta_book_ui_item.dart';
import '../community_sample_data.dart';
import 'community_right_pane_mixin.dart';

const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
//const double _scrollbarWidth = 13;
const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 188 + 4;
const double _rightViewToolbarHeight = 76;
//
const double _itemDefaultWidth = 290.0;
const double _itemDefaultHeight = 256.0;

bool isInUsingCanvaskit = false;

class CommunityRightHomePane extends StatefulWidget {
  final String subPageUrl;
  final double pageWidth;
  final double pageHeight;
  const CommunityRightHomePane(
      {super.key, required this.subPageUrl, required this.pageWidth, required this.pageHeight});

  @override
  State<CommunityRightHomePane> createState() => _CommunityRightHomePaneState();
}

class _CommunityRightHomePaneState extends State<CommunityRightHomePane> with CommunityRightPaneMixin {
  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;
  late List<CretaMenuItem> _dropDownMenuItemList3;

  @override
  void initState() {
    super.initState();

    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        super.initSuperMixin(
          topPaneMaxHeight: _rightViewBannerMinHeight,
          topPaneMinHeight: _rightViewBannerMinHeight,
          scrollChangedCallback: scrollChangedCallback,
          topPaneFunc: getTopPane,
          itemPaneFunc: getItemPane,
        );
        break;
      case AppRoutes.playList:
        super.initSuperMixin(
          topPaneMaxHeight: _rightViewBannerMinHeight,
          topPaneMinHeight: _rightViewBannerMinHeight,
          scrollChangedCallback: scrollChangedCallback,
          topPaneFunc: getTopPane,
          itemPaneFunc: getItemPane,
        );
        break;
      case AppRoutes.communityHome:
      default:
        super.initSuperMixin(
          topPaneMaxHeight: _rightViewBannerMaxHeight,
          topPaneMinHeight: _rightViewBannerMinHeight,
          scrollChangedCallback: scrollChangedCallback,
          topPaneFunc: getTopPane,
          itemPaneFunc: getItemPane,
        );
        break;
    }

    _dropDownMenuItemList1 = [
      CretaMenuItem(caption: '용도선택', iconData: Icons.type_specimen, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '최신순', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '이름순', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '등록일순', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList2 = [
      CretaMenuItem(caption: '권한', iconData: Icons.power, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '관리자', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '편집자', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청자', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList3 = [
      CretaMenuItem(caption: '최신 크레타북', iconData: Icons.power, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '이름순', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '등록일순', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '조회순', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];
  }

  void scrollChangedCallback() {
    setState(() {});
  }

  Widget getItemPane(Size paneSize) {
    int columnCount = (paneSize.width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    if (columnCount == 0) columnCount = 1;

    double itemWidth = -1;
    double itemHeight = -1;

    return GridView.builder(
      controller: getItemPaneScrollController,
      padding: EdgeInsets.fromLTRB(
          _rightViewLeftPane,
          widget.subPageUrl == AppRoutes.communityHome ? _rightViewBannerMaxHeight : _rightViewBannerMinHeight,
          _rightViewRightPane,
          _rightViewBottomPane),
      itemCount: CommunitySampleData.cretaBookList.length, //item 개수
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
        childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // 가로÷세로 비율
        mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
        crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
      ),
      itemBuilder: (BuildContext context, int index) {
        return (itemWidth >= 0 && itemHeight >= 0)
            ? CretaBookItem(
                key: CommunitySampleData.cretaBookList[index].key,
                cretaBookData: CommunitySampleData.cretaBookList[index],
                width: itemWidth,
                height: itemHeight,
              )
            : LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  itemWidth = constraints.maxWidth;
                  itemHeight = constraints.maxHeight;
                  return CretaBookItem(
                    key: CommunitySampleData.cretaBookList[index].key,
                    cretaBookData: CommunitySampleData.cretaBookList[index],
                    width: itemWidth,
                    height: itemHeight,
                  );
                },
              );
      },
    );
  }

  List<Widget> getTopPane(Size paneSize) {
    const String bannerUrl = 'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg';
    if (widget.subPageUrl == AppRoutes.communityHome) {
      return [
        Container(
          width: paneSize.width,
          height: getHeaderSize,
          decoration: BoxDecoration(
            //borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
          ),
        ),
        Positioned(
          top: _rightViewTopPane,
          left: _rightViewLeftPane,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
            clipBehavior: Clip.antiAlias,
            width: paneSize.width - _rightViewLeftPane - _rightViewRightPane,
            height: getHeaderSize - _rightViewTopPane - _rightViewToolbarHeight,
            child: isInUsingCanvaskit
                ? ImageNetwork(
                    width: paneSize.width - _rightViewLeftPane - _rightViewRightPane,
                    height: getHeaderSize - _rightViewTopPane - _rightViewToolbarHeight,
                    image: bannerUrl,
                    imageCache: CachedNetworkImageProvider(bannerUrl),
                    duration: 1500,
                    curve: Curves.easeIn,
                    //onPointer: true,
                    debugPrint: false,
                    fullScreen: false,
                    fitAndroidIos: BoxFit.cover,
                    fitWeb: BoxFitWeb.cover,
                    onLoading: const CircularProgressIndicator(
                      color: Colors.indigoAccent,
                    ),
                    onError: const Icon(
                      Icons.error,
                      color: Colors.orange,
                    ),
                  )
                :
                // Image.network(
                //   bannerUrl,
                //   fit: BoxFit.cover,
                //   loadingBuilder: (context, child, loadingProgress) {
                //     if(loadingProgress == null){
                //       return child;
                //     }
                //     return Center(
                //       child: CircularProgressIndicator(
                //         value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                //       ),
                //     );
                //   },
                //   errorBuilder: (context, exception, stackTrack) => Center(
                //     child: Icon(Icons.error, color: Colors.red, size: 40,),
                //   ),
                // ),
                CachedNetworkImage(
                    imageUrl: bannerUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ),
          ),
        ),
        // Positioned(
        //   top: headerSize - 57,
        //   left: _rightViewLeftPane,
        //   child: CretaDropDown(
        //       width: 104,
        //       height: 36,
        //       items: const ['용도선택', '용도선택1', '용도선택2', '용도선택3'],
        //       defaultValue: '용도선택',
        //       onSelected: (value) {
        //         //logger.finest('value=$value');
        //       }),
        // ),
        Positioned(
          top: getHeaderSize - 57,
          left: _rightViewLeftPane, // + 116,
          child: Row(
            children: [
              CretaDropDownButton(
                //width: 104,
                height: 36,
                dropDownMenuItemList: _dropDownMenuItemList1,
                // items: const ['용도선택', '용도선택1', '용도선택2', '용도선택3'],
                // defaultValue: '용도선택',
                // onSelected: (value) {
                //   //logger.finest('value=$value');
                // }
              ),
              CretaDropDownButton(
                // width: 104,
                height: 36,
                dropDownMenuItemList: _dropDownMenuItemList2,
                // items: const ['권한', '권한1', '권한2', '권한3'],
                // defaultValue: '권한',
                // onSelected: (value) {
                //   //logger.finest('value=$value');
                // }
              ),
            ],
          ),
        ),
        Positioned(
          top: getHeaderSize - 57,
          left: paneSize.width - _rightViewRightPane - 134 - 246 - 2,
          child: CretaSearchBar(
            hintText: '검색어를 입력하세요',
            onSearch: (value) {},
            width: 246,
            height: 32,
          ),
        ),
        // 최신크레타북 콤보 추가
        Positioned(
          top: getHeaderSize - 57,
          left: paneSize.width - _rightViewRightPane - 134,
          child: CretaDropDownButton(
            //width: 134,
            height: 36,
            dropDownMenuItemList: _dropDownMenuItemList3,
            // items: const ['최신 크레타북', '최신 크레타북1', '최신 크레타북2', '최신 크레타북3'],
            // defaultValue: '최신 크레타북',
            // onSelected: (value) {
            //   //logger.finest('value=$value');
            // }
          ),
        ),
      ];
    }

    return [
      //Positioned(
      // Container(
      //   width: widget.pageWidth,
      //   height: widget.pageHeight,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(20.0),
      //     color: Colors.orange,
      //   ),
      // ),
      //),
      //Positioned(
      CretaBannerPane(
        width: widget.pageWidth,
        height: getHeaderSize,
        color: Colors.white,
        title: '커뮤니티 홈',
        description: '상세한 설명은 생략한다',
        listOfListFilter: [
          _dropDownMenuItemList1,
          _dropDownMenuItemList2,
        ],
      ),
      //),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return mainPage(Size(widget.pageWidth, widget.pageHeight));
  }
}
