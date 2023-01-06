// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../community_home_page.dart';

const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 188;
const double _rightViewToolbarHeight = 76;

const double _itemDefaultWidth = 290.0;
const double _itemDefaultHeight = 256.0;
const double _itemDescriptionHeight = 56;


class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  //late ScrollController _controller;
  late List<CretaMenuItem> _leftMenuItemList;

  @override
  void initState() {
    super.initState();
    //_controller = ScrollController();
    //_controller.addListener(_scrollListener);

    _leftMenuItemList = [
      CretaMenuItem(caption: '커뮤니티 홈', iconData: Icons.home_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '구독목록', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청기록', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '좋아요', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '재생목록', iconData: Icons.playlist_play, onPressed: () {}, selected: true),
    ];
  }

  // double headerSize = _rightViewBannerMaxHeight;
  // double scrollOffset = 0;
  // void _scrollListener() {
  //   setState(() {
  //     scrollOffset = _controller.offset;
  //     headerSize = _rightViewBannerMaxHeight - _controller.offset;
  //     if (headerSize < _rightViewBannerMinHeight) headerSize = _rightViewBannerMinHeight;
  //   });
  // }

  Widget _getLeftPane(double height) {
    return Snippet.CretaTabBar(_leftMenuItemList, height);
  }

  Widget _getRightBannerPane(double width, double height) {
    return
      // Listener(
      // onPointerSignal: (PointerSignalEvent event) {
      //   if (event is PointerScrollEvent) {
      //     //print('x: ${event.position.dx}, y: ${event.position.dy}');
      //     //print('scroll delta: ${event.scrollDelta}');
      //     scrollOffset += event.scrollDelta.dy;
      //     if (scrollOffset < 0) scrollOffset = 0;
      //     if (scrollOffset > _controller.position.maxScrollExtent) scrollOffset = _controller.position.maxScrollExtent;
      //     _controller.animateTo(scrollOffset, duration: Duration(milliseconds: 1), curve: Curves.easeIn);
      //   }
      // },
      // child:
      Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: _rightViewTopPane,
              left: _rightViewLeftPane,
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                clipBehavior: Clip.antiAlias,
                width: width - _rightViewLeftPane - _rightViewRightPane,
                height: height - _rightViewTopPane - _rightViewToolbarHeight,
                child:
                //Image.network(
                //  'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg',
                //  fit: BoxFit.cover,
                //),
                ImageNetwork(
                  width: width - _rightViewLeftPane - _rightViewRightPane,
                  height: height - _rightViewTopPane - _rightViewToolbarHeight,
                  image: 'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg',
                  imageCache: CachedNetworkImageProvider('https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg'),
                  duration: 1500,
                  curve: Curves.easeIn,
                  onPointer: true,
                  debugPrint: false,
                  fullScreen: false,
                  fitAndroidIos: BoxFit.cover,
                  fitWeb: BoxFitWeb.cover,
                  onLoading: const CircularProgressIndicator(
                    color: Colors.indigoAccent,
                  ),
                  onError: const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Positioned(
              top: height - 57,
              left: _rightViewLeftPane,
              child: CretaDropDown(
                  width: 104,
                  height: 36,
                  items: const ['용도선택', '용도선택1', '용도선택2', '용도선택3'],
                  defaultValue: '용도선택',
                  onSelected: (value) {
                    //logger.finest('value=$value');
                  }),
            ),
            Positioned(
              top: height - 57,
              left: _rightViewLeftPane + 116,
              child: CretaDropDown(
                  width: 104,
                  height: 36,
                  items: const ['권한', '권한1', '권한2', '권한3'],
                  defaultValue: '권한',
                  onSelected: (value) {
                    //logger.finest('value=$value');
                  }),
            ),
            Positioned(
              top: height - 57,
              left: width - _rightViewRightPane - 134 - 246 - 2,
              child: CretaSearchBar(
                hintText: '검색어를 입력하세요',
                onSearch: (value) {},
                width: 246,
                height: 32,
              ),
            ),
            // 최신크레타북 콤보 추가
            Positioned(
              top: height - 57,
              left: width - _rightViewRightPane - 134,
              child: CretaDropDown(
                  width: 134,
                  height: 36,
                  items: const ['최신 크레타북', '최신 크레타북1', '최신 크레타북2', '최신 크레타북3'],
                  defaultValue: '최신 크레타북',
                  onSelected: (value) {
                    //logger.finest('value=$value');
                  }),
            ),
          ],
        ),
      //),
    );
  }

  Widget _getRightItemPane(double width, double height) {
    int columnCount = (width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    if (columnCount == 0) columnCount = 1;

    double itemWidth = -1;
    double itemHeight = -1;

    return Container(
      color: Colors.white,
      child: GridView.builder(
        //controller: _controller,
        padding: EdgeInsets.fromLTRB(
            _rightViewLeftPane, _rightViewBannerMinHeight, _rightViewRightPane, _rightViewBottomPane),
        itemCount: cretaBookList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookItem(
                  key: cretaBookList[index].globalKey,
                  cretaBookData: cretaBookList[index],
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookItem(
                      key: cretaBookList[index].globalKey,
                      cretaBookData: cretaBookList[index],
                      width: itemWidth,
                      height: itemHeight,
                    );
                  },
                );
        },
      ),
    );
  }

  Widget _mainPage() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
        child: Row(
      children: [
        // 왼쪽 메뉴
        _getLeftPane(height - CretaComponentLocation.BarTop.height),
        // 오른쪽 컨텐츠
        Container(
          width: width - CretaComponentLocation.TabBar.width,
          height: height,
          color: Colors.white,
          child: Stack(
            children: [
              SizedBox(
                width: width - CretaComponentLocation.TabBar.width,
                height: height,
                child: _getRightItemPane(width - CretaComponentLocation.TabBar.width, height),
              ),
              SizedBox(
                width: width - CretaComponentLocation.TabBar.width - _scrollbarWidth,
                height: _rightViewBannerMinHeight,
                child: _getRightBannerPane(width - CretaComponentLocation.TabBar.width, _rightViewBannerMinHeight),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    //print('screen_width=$width, screen_height=$height');
    return Snippet.CretaScaffoldOfCommunity(
      //title: Text('Community page'),
      title: Row(
        children: const [
          SizedBox(
            width: 24,
          ),
          Image(
            image: AssetImage('assets/creta_logo_blue.png'),
            //width: 120,
            height: 20,
          ),
        ],
      ),
      context: context,
      child: _mainPage(),
    );
  }
}

//////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////

class CretaBookItem extends StatefulWidget {
  final CretaBookData cretaBookData;
  final double width;
  final double height;

  const CretaBookItem({
    required super.key,
    required this.cretaBookData,
    required this.width,
    required this.height,
  });

  @override
  CretaBookItemState createState() => CretaBookItemState();
}

class CretaBookItemState extends State<CretaBookItem> {
  bool mouseOver = false;
  bool popmenuOpen = false;

  late List<CretaMenuItem> _popupMenuList;

  void _openPopupMenu() {
    CretaPopupMenu.showMenu(
            context: context,
            globalKey: widget.cretaBookData.globalKey,
            popupMenu: _popupMenuList,
            initFunc: setPopmenuOpen)
        .then((value) {
      logger.finest('팝업메뉴 닫기');
      setState(() {
        popmenuOpen = false;
      });
    });
  }

  void _editItem() {
    logger.finest('편집하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuPlay() {
    logger.finest('재생하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuEdit() {
    logger.finest('편집하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('재생목록에 추가(${widget.cretaBookData.title})');
  }

  void _doPopupMenuShare() {
    logger.finest('공유하기(${widget.cretaBookData.title})');
  }

  void _doPopupMenuDownload() {
    logger.finest('다운로드(${widget.cretaBookData.title})');
  }

  void _doPopupMenuCopy() {
    logger.finest('복사하기(${widget.cretaBookData.title})');
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
    popmenuOpen = true;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> overlayMenu = !(mouseOver || popmenuOpen)
        ? [
            Container(),
          ]
        : [
            Positioned(
              left: 8,
              top: 8,
              // BTN.opacity_gray_it_s
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _editItem(),
                  child: SizedBox(
                    width: 91,
                    height: 29,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: SizedBox(
                            width: 91,
                            height: 29,
                            child: FloatingActionButton.extended(
                              onPressed: () => _editItem(),
                              label: Container(),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 91,
                          height: 29,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.edit_outlined,
                                size: 12.0,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                '편집하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: widget.width - 68,
              top: 8,
              //BTN.opacity_gray_i_s
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _openPopupMenu(),
                  child: SizedBox(
                    width: 29,
                    height: 29,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.25,
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: FloatingActionButton.extended(
                              onPressed: () => _openPopupMenu(),
                              label: Container(),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 29,
                          height: 29,
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: widget.width - 36,
              top: 8,
              child: Stack(
                children: [
                  Opacity(
                    opacity: 0.25,
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: FloatingActionButton.extended(
                        onPressed: () {},
                        label: Text(
                          '',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        // icon: Icon(
                        //   Icons.menu,
                        //   size: 12.0,
                        // ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ),
                  PopupMenuButton<PopupMenuSampleItem>(
                    tooltip: '',
                    offset: Offset(100, 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child: Icon(
                        Icons.menu,
                        size: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    //initialValue: selectedMenu,
                    // Callback that sets the selected popup menu item.
                    onSelected: (PopupMenuSampleItem item) {
                      setState(() {
                        //selectedMenu = item;
                        popmenuOpen = false;
                      });
                    },
                    onCanceled: () {
                      setState(() {
                        popmenuOpen = false;
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<PopupMenuSampleItem>>[
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemOne,
                        child: Text('Item 1'),
                      ),
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemTwo,
                        child: Text('Item 2'),
                      ),
                      const PopupMenuItem<PopupMenuSampleItem>(
                        value: PopupMenuSampleItem.itemThree,
                        child: Text('Item 3'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ];

    return MouseRegion(
      onEnter: (value) {
        setState(() {
          mouseOver = true;
        });
      },
      onExit: (value) {
        setState(() {
          mouseOver = false;
        });
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
            Container(
              width: widget.width,
              height: widget.height - _itemDescriptionHeight,
              color: Colors.white,
              child: Stack(
                children: [
                  // 콘텐츠 프리뷰 이미지
                  // Image.network(
                  //   //width: 200,
                  //   //  height: 100,
                  //   width: double.maxFinite,
                  //   widget.cretaBookData.imageUrl,
                  //   fit: BoxFit.cover,
                  // ),
                  ImageNetwork(
                    width: widget.width,
                    height: widget.height - _itemDescriptionHeight,
                    image: widget.cretaBookData.imageUrl,
                    imageCache: CachedNetworkImageProvider(widget.cretaBookData.imageUrl),
                    duration: 1500,
                    curve: Curves.easeIn,
                    onPointer: true,
                    debugPrint: false,
                    fullScreen: false,
                    fitAndroidIos: BoxFit.cover,
                    fitWeb: BoxFitWeb.cover,
                    onLoading: const CircularProgressIndicator(
                      color: Colors.indigoAccent,
                    ),
                    onError: const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                  // 편집하기, 추가, 메뉴 버튼 (반투명 배경)
                  ...overlayMenu,
                ],
              ),
            ),
            Container(
              height: _itemDescriptionHeight,
              color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
              child: Stack(
                children: [
                  Positioned(
                      left: widget.width - 37,
                      top: 17,
                      child: Container(
                        width: 20,
                        height: 20,
                        color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                        child: Icon(
                          Icons.favorite_outline,
                          size: 20.0,
                          color: Colors.grey[700],
                        ),
                      )),
                  Positioned(
                    left: 15,
                    top: 7,
                    child: Container(
                        width: widget.width - 45 - 15,
                        color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                        child: Text(
                          widget.cretaBookData.title,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontFamily: 'Pretendard',
                          ),
                        )),
                  ),
                  Positioned(
                    left: 16,
                    top: 29,
                    child: Container(
                      width: widget.width - 45 - 15,
                      color: (mouseOver || popmenuOpen) ? Colors.grey[100] : Colors.white,
                      child: Text(
                        widget.cretaBookData.userNickname,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
