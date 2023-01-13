// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../community_home_page.dart';


const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
// const double _rightViewItemGapX = 20;
// const double _rightViewItemGapY = 20;
const double _scrollbarWidth = 13;
//const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 196;
const double _rightViewToolbarHeight = 76;

// const double _itemDefaultWidth = 290.0;
// const double _itemDefaultHeight = 256.0;
// const double _itemDescriptionHeight = 56;

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  late ScrollController _controller;
  late List<CretaMenuItem> _leftMenuItemList;
  late List<CretaMenuItem> _dropDownMenuItemList;

  late List<CretaPlayListData> _cretaPlayList;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _cretaPlayList = [
      CretaPlayListData(
        title: '재생목록 01',
        locked: false,
        userNickname: '사용자 닉네임',
        lastUpdatedTime: DateTime.now(),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '당신이 몰랐던 유튜브의 기능 TOP14',
        locked: false,
        userNickname: '스토리',
        lastUpdatedTime: DateTime.now(),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '한국 좀비사태 발생시 필요한 현실능력 월드컵',
        locked: true,
        userNickname: '침착맨',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 1)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '💀 미국은 왜 센티미터를 안 쓰고 인치를 쓸까? / 💀 도량형의 통일',
        locked: false,
        userNickname: '지식해적단',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: 'F는 이래서 안돼',
        locked: false,
        userNickname: '빠더너스 BDNS',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '[#고독한미식가] ''추운 겨울하면 떠오르는 대표적인 이 메뉴!''',
        locked: false,
        userNickname: '도라마코리아',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '세계에서 가장 추운 곳으로 가다 (-71°C) 야쿠츠크/야쿠티아',
        locked: false,
        userNickname: 'Ruhi Çenet 한국어',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '시신도 못 찾은 ''자살'' 사건...9년 만에 드러난 충격 반전 / KBS 2023.01.11.',
        locked: false,
        userNickname: 'KBS News',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '15분간 옛이야기 듣듯 정리하는 ''고려 역사 500년''',
        locked: false,
        userNickname: '쏨작가의지식사전',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '화산이 폭발하면 주변 동물들은 어떻게 될까? 백두산이 폭발하면 우리나라는? / 최재천의 아마존',
        locked: false,
        userNickname: '최재천의 아마존',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
      CretaPlayListData(
        title: '리트리버에게 냉장고를 열어줬더니 똑똑한 행동을 해요ㅋㅋㅋ',
        locked: false,
        userNickname: '소녀의행성 Girlsplanet',
        lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
        cretaBookDataList: cretaBookList,
      ),
    ];

    _leftMenuItemList = [
      CretaMenuItem(caption: '커뮤니티 홈', iconData: Icons.home_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '구독목록', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청기록', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '좋아요', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '재생목록', iconData: Icons.playlist_play, onPressed: () {}, selected: true),
    ];

    _dropDownMenuItemList = [
      CretaMenuItem(caption: '최신순', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '최신순1', iconData: Icons.article_outlined, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '최신순2', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '최신순3', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '최신순4', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
    ];

    for (int i = 0; i < 10; i++) {
      _controllers.add(ScrollController());
    }
  }

  // double headerSize = _rightViewBannerMaxHeight;
  double scrollOffset = 0;
  void _scrollListener() {
    setState(() {
      scrollOffset = _controller.offset;
      //headerSize = _rightViewBannerMaxHeight - _controller.offset;
      //if (headerSize < _rightViewBannerMinHeight) headerSize = _rightViewBannerMinHeight;
    });
  }

  Widget _getLeftPane(double height) {
    return Snippet.CretaTabBar(_leftMenuItemList, height);
  }

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  Widget _getRightBannerPane(double width, double height) {
    return Listener(
      onPointerSignal: (PointerSignalEvent event) {
        if (event is PointerScrollEvent) {
          //print('x: ${event.position.dx}, y: ${event.position.dy}');
          //print('scroll delta: ${event.scrollDelta}');
          scrollOffset += event.scrollDelta.dy;
          if (scrollOffset < 0) scrollOffset = 0;
          if (scrollOffset > _controller.position.maxScrollExtent) scrollOffset = _controller.position.maxScrollExtent;
          _controller.animateTo(scrollOffset, duration: Duration(milliseconds: 1), curve: Curves.easeIn);
        }
      },
      child: Container(
        width: width,
        height: height,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              top: _rightViewTopPane,
              left: _rightViewLeftPane,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                width: width - _rightViewLeftPane - _rightViewRightPane,
                height: height - _rightViewTopPane - _rightViewToolbarHeight,
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 41,
                        top: 30,
                        child: Icon(
                          Icons.playlist_play,
                          size: 20,
                          color: Colors.grey[800],
                        ),
                      ),
                      Positioned(
                        left: 72,
                        top: 27,
                        child: Text(
                          '재생목록',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 22,
                            color: Colors.grey[800],
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      Positioned(
                        left: 173,
                        top: 31,
                        child: Text(
                          '사용자 닉네임님이 만든 재생목록입니다.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: height - 56,
              left: _rightViewLeftPane - 7,
              child: CretaDropDown(
                  width: 91,
                  height: 36,
                  items: const ['최신순', '최신순1', '최신순2', '최신순3', '최신순4'],
                  defaultValue: '최신순',
                  onSelected: (value) {
                    //logger.finest('value=$value');
                  }),
            ),
            Positioned(
              top: height - 56,
              left: _rightViewLeftPane + 107,
              child: ElevatedButton(
                key: dropDownButtonKey,
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered)) {
                        return Colors.white;
                      }
                      return Colors.white; //Colors.grey[100];
                    },
                  ),
                  elevation: MaterialStateProperty.all<double>(0.0),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                  foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.hovered) || dropDownButtonOpened) {
                        return Color.fromARGB(255, 89, 89, 89);
                      }
                      return Color.fromARGB(255, 140, 140, 140);
                    },
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  shape: MaterialStateProperty.resolveWith<OutlinedBorder?>(
                    (Set<MaterialState> states) {
                      return RoundedRectangleBorder(
                          borderRadius: dropDownButtonOpened
                              ? BorderRadius.only(topLeft: Radius.circular(8.0), topRight: Radius.circular(8.0))
                              : BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: (states.contains(MaterialState.hovered) || dropDownButtonOpened)
                                  ? Color.fromARGB(255, 89, 89, 89)
                                  : Colors.white));
                    },
                  ),
                ),
                onPressed: () {
                  setState(() {
                    CretaDropDownMenu.showMenu(
                        context: context,
                        globalKey: dropDownButtonKey,
                        popupMenu: _dropDownMenuItemList,
                        initFunc: () {
                          dropDownButtonOpened = true;
                        }).then((value) {
                      logger.finest('팝업메뉴 닫기');
                      setState(() {
                        dropDownButtonOpened = false;
                      });
                    });

                    dropDownButtonOpened = !dropDownButtonOpened;
                  });
                },
                child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '최신순',
                          style: TextStyle(
                            //color: Colors.grey[700],
                            fontSize: 20,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                        Expanded(child: Container()),
                        Icon(Icons.keyboard_arrow_down),
                      ],
                    )),
              ),
            ),
            Positioned(
              top: height - 54,
              left: width - _rightViewRightPane - 246,
              child: CretaSearchBar(
                hintText: '검색어를 입력하세요',
                onSearch: (value) {},
                width: 246,
                height: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<ScrollController> _controllers = [];

  Widget _getRightItemPane(double width, double height) {
    // int columnCount = (width - _rightViewLeftPane - _rightViewRightPane) ~/ _itemDefaultWidth;
    // if (columnCount == 0) columnCount = 1;
    //
    // double itemWidth = -1;
    // double itemHeight = -1;

    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: _controller,
        padding: EdgeInsets.fromLTRB(
            _rightViewLeftPane, _rightViewBannerMinHeight, _rightViewRightPane, _rightViewBottomPane),
        itemCount: _cretaPlayList.length,
        itemExtent: 204,
        itemBuilder: (context, index) {
          return CretaPlayListItem(key: _cretaPlayList[index].globalKey, cretaPlayListData: _cretaPlayList[index], width: width);
        }),
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
class CretaPlayListData {
  CretaPlayListData({
    required this.title,
    required this.locked,
    required this.userNickname,
    //required this.userId,
    required this.lastUpdatedTime,
    this.cretaBookDataList = const [],
  }) {
    globalKey = GlobalKey();
  }

  late GlobalKey globalKey;
  String title;
  bool locked;
  String userNickname;
  //String userId;
  DateTime lastUpdatedTime;
  List<CretaBookData> cretaBookDataList;
}

class CretaPlayListItem extends StatefulWidget {
  final CretaPlayListData cretaPlayListData;
  final double width;
  //final double height;

  const CretaPlayListItem({
    required super.key,
    required this.cretaPlayListData,
    required this.width,
    //required this.height,
  });

  @override
  CretaPlayListItemState createState() => CretaPlayListItemState();
}

class CretaPlayListItemState extends State<CretaPlayListItem> {
  bool mouseOver = false;
  bool popmenuOpen = false;

  //late List<CretaMenuItem> _popupMenuList;
  final ScrollController _controller = ScrollController();

  // void _openPopupMenu() {
  //   CretaPopupMenu.showMenu(
  //           context: context,
  //           globalKey: widget.cretaPlayListData.globalKey,
  //           popupMenu: _popupMenuList,
  //           initFunc: setPopmenuOpen)
  //       .then((value) {
  //     logger.finest('팝업메뉴 닫기');
  //     setState(() {
  //       popmenuOpen = false;
  //     });
  //   });
  // }
  //
  // void _editItem() {
  //   logger.finest('편집하기(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuPlay() {
  //   logger.finest('재생하기(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuEdit() {
  //   logger.finest('편집하기(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuAddToPlayList() {
  //   logger.finest('재생목록에 추가(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuShare() {
  //   logger.finest('공유하기(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuDownload() {
  //   logger.finest('다운로드(${widget.cretaPlayListData.title})');
  // }
  //
  // void _doPopupMenuCopy() {
  //   logger.finest('복사하기(${widget.cretaPlayListData.title})');
  // }

  @override
  void initState() {
    super.initState();

    // _popupMenuList = [
    //   CretaMenuItem(
    //     caption: '재생하기',
    //     onPressed: _doPopupMenuPlay,
    //   ),
    //   CretaMenuItem(
    //     caption: '편집하기',
    //     onPressed: _doPopupMenuEdit,
    //   ),
    //   CretaMenuItem(
    //     caption: '재생목록에 추가',
    //     onPressed: _doPopupMenuAddToPlayList,
    //   ),
    //   CretaMenuItem(
    //     caption: '공유하기',
    //     onPressed: _doPopupMenuShare,
    //   ),
    //   CretaMenuItem(
    //     caption: '다운로드',
    //     onPressed: _doPopupMenuDownload,
    //   ),
    //   CretaMenuItem(
    //     caption: '복사하기',
    //     onPressed: _doPopupMenuCopy,
    //   ),
    // ];
  }

  void setPopmenuOpen() {
    popmenuOpen = true;
  }

  @override
  Widget build(BuildContext context) {

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
        height: 204,
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.2),
                  color: Color.fromARGB(255, 242, 242, 242),
                ),
                width: widget.width,
                //height: 184,
                child: Stack(
                  children: [
                    Positioned(
                      left: 40,
                      top: 40,
                      child: Container(
                        width: 270,
                        color: Color.fromARGB(255, 242, 242, 242),
                        child: Row(
                          children: [
                            Container(
                              constraints: BoxConstraints(maxWidth: 270-16-16, ),
                              child:Text(
                              widget.cretaPlayListData.title,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 22,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),
                            ),),
                            SizedBox(width:16,),
                            widget.cretaPlayListData.locked ?
                            Icon(Icons.lock_outline, size:16, color: Colors.grey[700],)
                                : Icon(Icons.lock_open_outlined, size:16, color: Colors.grey[700],),
                            Expanded(child: Container()),
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   left: 154,
                    //   top: 45,
                    //   child: widget.cretaPlayListData.locked ?
                    //     Icon(Icons.lock_outline, size:16, color: Colors.grey[700],)
                    //     : Icon(Icons.lock_open_outlined, size:16, color: Colors.grey[700],
                    //   ),
                    // ),
                    Positioned(
                      left: 48,
                      top: 107,
                      child: Text(
                        widget.cretaPlayListData.userNickname,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontFamily: 'Pretendard',
                          //fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 48,
                      top: 129,
                      child: Text(
                        '영상 ${widget.cretaPlayListData.cretaBookDataList.length}개  최근 업데이트 1일전',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                          fontFamily: 'Pretendard',
                          //fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 331,
                      top: 48,
                      child: Icon(Icons.menu, size:16, color: Colors.grey[700],),
                    ),
                    Positioned(
                      left: 277+1,
                      top: 77-1,
                      width: 77,
                      height: 32,
                      //BTN.fill_gray_t_m
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.grey[700]!),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          elevation: MaterialStateProperty.all<double>(0.0),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Colors.white))),
                        ),
                        onPressed: () {},
                        child: Text(
                          '전체보기',
                          style: TextStyle(
                            //color: Colors.grey[700],
                            fontSize: 13,
                            fontFamily: 'Pretendard',
                            //fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 278,
                      top: 112,
                      width: 77,
                      height: 32,
                      //BTN.fill_blue_t_m
                      child: ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 90, 142, 242)),
                          elevation: MaterialStateProperty.all<double>(0.0),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: Color.fromARGB(255, 90, 142, 242)))),
                        ),
                        onPressed: () {},
                        child: Text(
                          '재생하기',
                          style: TextStyle(
                            //color: Colors.white,
                            fontSize: 13,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 495,
                      top: 20,
                      width: widget.width - 495 - 20 - _rightViewLeftPane - _rightViewRightPane,
                      height: 144,
                      child: Scrollbar(
                        thumbVisibility: false,
                        controller: _controller,
                        child: ListView(
                          controller: _controller,
                          // 스크롤 방향 설정. 수평적으로 스크롤되도록 설정
                          scrollDirection: Axis.horizontal,
                          // 컨테이너들을 ListView의 자식들로 추가
                          children: <Widget>[
                            Wrap(
                              direction: Axis.horizontal,
                              spacing: 20, // <-- Spacing between children
                              children: <Widget>[
                                ...List<Widget>.generate(cretaBookList.length, (idx) {
                                  return Container(
                                    width: 187,
                                    height: 144,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.4),
                                      color: Colors.grey,//Color.fromARGB(255, 242, 242, 242),
                                    ),
                                    //padding: EdgeInsets.all(10),
                                    //color: Colors.red[100],
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5.4),
                                      child: CachedNetworkImage(
                                        imageUrl: cretaBookList[idx].imageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => Center(
                                          child: Icon(Icons.error, color: Colors.red, size: 40,),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////
class CretaDropDownMenu {
  static Widget _createDropDownMenu(
    BuildContext context,
    double x,
    double y,
    double width,
    List<CretaMenuItem> menuItem,
  ) {
    return Stack(
      children: [
        Positioned(
          left: x,
          top: y,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white, //Color.fromARGB(255, 89, 89, 89),
              border: Border.all(color: Color.fromARGB(255, 89, 89, 89)),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
              // shadow
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.black,
              //     //offset: Offset(0.0, 20.0),
              //     spreadRadius: -10.0,
              //     blurRadius: 20.0,
              //   )
              // ],
            ),
            padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 5, // <-- Spacing between children
              children: <Widget>[
                ...menuItem
                    .map((item) => SizedBox(
                          width: width - 2,
                          height: 39,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 242, 242, 242);
                                  }
                                  return Colors.white;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(0.0),
                              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                              foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (item.selected) {
                                    return Color.fromARGB(255, 0, 122, 255);
                                  } else if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 89, 89, 89);
                                  }
                                  return Color.fromARGB(255, 140, 140, 140);
                                },
                              ),
                              backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return Color.fromARGB(255, 242, 242, 242);
                                  }
                                  return Colors.white;
                                },
                              ),
                              shape: null,
                              // MaterialStateProperty.all<RoundedRectangleBorder>(
                              //   RoundedRectangleBorder(
                              //     borderRadius: BorderRadius.circular(18.0),
                              //     side: BorderSide(color: Colors.white),
                              //   ),
                              // ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              item.onPressed();
                            },
                            child: Row(
                              children: [
                                //SizedBox(width:16,),
                                Text(
                                  item.caption,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                Expanded(
                                  child: Container(),
                                ),
                                item.selected
                                    ? Icon(
                                        Icons.check,
                                        size: 24,
                                      )
                                    : Container(),
                                //SizedBox(width:16,),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Future<void> showMenu(
      {required BuildContext context,
      required GlobalKey globalKey,
      required List<CretaMenuItem> popupMenu,
      Function? initFunc}) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // Dialog를 제외한 다른 화면 터치 x
      barrierColor: null,
      builder: (BuildContext context) {
        if (initFunc != null) initFunc();

        final RenderBox renderBox = globalKey.currentContext!.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        final size = renderBox.size;

        double x = position.dx;
        double y = position.dy + size.height - 1;

        return _createDropDownMenu(
          context,
          x,
          y,
          size.width,
          popupMenu,
        );
      },
    );

    return Future.value();
  }
}
