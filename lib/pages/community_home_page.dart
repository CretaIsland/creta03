// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
import 'package:hycop/common/util/logger.dart';
//import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
import '../design_system/component/snippet.dart';
import '../design_system/menu/creta_drop_down.dart';
import '../design_system/menu/creta_popup_menu.dart';
import '../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';

const double _rightViewTopPane = 40;
const double _rightViewLeftPane = 40;
const double _rightViewRightPane = 40;
const double _rightViewBottomPane = 40;
const double _rightViewItemGapX = 20;
const double _rightViewItemGapY = 20;
const double _scrollbarWidth = 13;
const double _rightViewBannerMaxHeight = 436;
const double _rightViewBannerMinHeight = 188;
const double _rightViewToolbarHeight = 76;

const double _itemDefaultWidth = 290.0;
const double _itemDefaultHeight = 256.0;
const double _itemDescriptionHeight = 56;

enum PopupMenuSampleItem { itemOne, itemTwo, itemThree }

///////////////////////////////////////////////////////
class CretaBookData {
  CretaBookData({
    required this.imageUrl,
    required this.imageSize,
    required this.title,
    required this.userNickname,
    required this.favorites,
    required this.globalKey,
  });

  String imageUrl;
  double imageSize;
  String title;
  String userNickname;
  bool favorites;
  GlobalKey globalKey;
}

var _imageUrlList = [
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/99820741428583-2df54399-e5c3-414f-902b-7df5f66b3659.jpg',
    title: '크레타북 01', //'NewJeans (뉴진스) ' 'Ditto' ' Official MV (side B)',
    userNickname: '사용자 닉네임', //'HYBE LABELS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2022/03/16/11/6/48106a75-92ba-4ae5-ace8-6b9a7b579065.jpg',
    title: 'NCT DREAM 엔시티 드림 ' 'Candy' ' MV',
    userNickname: 'SMTOWN',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5926724526400602-204ace08-26d9-44fe-a9c9-8ba4f62e98e9.jpg',
    title: 'ICBM 대기권 재진입 "뿔난 北 내년에 감행할 것" [김어준의 뉴스공장 풀영상 12/22(목)]',
    userNickname: 'TBS 시민의방송',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/07/24/11/4/f8083863-638a-417e-9644-0f646a2bea72.jpg',
    title: '스트레스, 피로, 우울, 부정, 부정적인 감정의 해독을위한 치유 음악',
    userNickname: 'Lucid Dream',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7436639300021515-8546ddc5-1299-4d87-8a92-a574fa42f4b4.jpg',
    title: '크리스마스 음악 2023, 크리스마스 캐롤, 천상의 크리스마스 음악, 편안한 음악, 크리스마스 분위기',
    userNickname: 'Piano Musica',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/340405791149789-09c51072-be11-43fc-9427-b2f84a4da5b8.jpg',
    title: '한국 분식을 처음 먹어본 영국 축구선수들의 반응!?',
    userNickname: '영국남자 Korean Englishman',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/06/01/18/8/8f9f7104-1663-4dab-907e-8a5e7b03accb.jpg',
    title: '18년 장수게임 카트라이더 서비스 종료 이야기',
    userNickname: '김성회의 G식백과',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2022/10/06/11/0/f58c9008-86a8-449c-bfa8-d99ba86e2e73.jpg',
    title: '[아이유의 팔레트🎨] 내 마음속 영원히 맑은 하늘 (With god) Ep.17',
    userNickname: '이지금 [IU Official]',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/8558233514918916-3416c42b-0678-4660-a58b-54faa20e5375.jpg',
    title: '[내 몸 보고서] 소리 없이 다가오는 실명의 위험, 녹내장 / YTN 사이언스',
    userNickname: 'YTN 사이언스',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7299477591796270-63ffe77e-2792-40fe-8ce5-3a4e337ec9bb.jpg',
    title: '인류의 우주에 대한 시각을 완전히 바꿔버린 그 사건, 안드로메다는 사실 ' '이것' '이다?',
    userNickname: '리뷰엉이: Owl' 's Review',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/9105828210613186-eb28a667-1ae4-4758-853e-9bb38f010114.jpg',
    title: '[님아 그 시장을 가오_EP. 18_속초] “사장님 국수는 어디 갔어요?” 국수 찾는 데 한참 걸렸습니다! 회 먹다 식사 끝나는 희한한 회국수집!',
    userNickname: '백종원 PAIK JONG WON',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2437405925503738-c49517a0-b027-486e-aa11-95bc3dda6ee8.jpg',
    title: '철학은 어떻게 반복되는가? 에피쿠로스와 소크라테스의 철학 분석! 움베르토 에코 [경이로운 철학의 역사] 2부',
    userNickname: '일당백 : 일생동안 읽어야 할 백권의 책',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/03/17/19/2/d7fa436c-bb25-40df-b95f-b998af74d111.jpg',
    title: '지구인이 중력이 낮은 행성으로 차원 이동하면 벌어지는 일 [영화리뷰/결말포함]',
    userNickname: '리뷰 MASTER',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/10/21/16/3/88432c7e-584a-4748-9db2-9760f8080ac3.jpg',
    title: '그래서 어떤 커피가 맛있나요? 내돈내산 음식이야기 2탄! | 커피, 원두, 역사',
    userNickname: '김지윤의 지식Play',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7305328818839261-9f3fb78f-0966-4a4e-9339-8018d0299b8f.jpg',
    title: '윤하(YOUNHA) - 사건의 지평선 M/V',
    userNickname: 'YOUNHA OFFICIAL',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/399033406503243-2d2b10ef-dcc7-4a2e-ab92-cd2d1e28b7b1.jpg',
    title: '[#스트리트푸드파이터] 러시아와 중국의 오묘한 조화가 이루어지는 하얼빈 요리! 백종원도 현지 가야만 맛볼 수 있는 꿔바로우가 최초로 탄생한 식당 | #편집자는',
    userNickname: '디글 :Diggle',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/01/22/18/9/96088f38-eb71-4f68-9ddc-fe134e3d47d9.jpg',
    title: '충청·호남에 또 큰 눈‥모레까지 최고 30cm - [LIVE] MBC 930뉴스 2022년 12월 22일',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2429208925380047-ade2fbeb-30b7-47c2-9eb1-d3f4abff955e.jpg',
    title: '[#티전드] 고기 건더기 없이도 맛있게! 중화요리 대가 이연복의 비건 짬뽕&짜장요리🍜 | #현지에서먹힐까',
    userNickname: 'tvN D ENT',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/65091360063729-d8eb8649-41b7-46de-9169-ccbb709d710f.jpg',
    title: '누칼협? 중꺾마? 2022년 올해의 단어들',
    userNickname: '슈카월드',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5645972548099588-1a098763-67b8-4a50-9c90-c58d835eeb70.jpg',
    title: '아바타2 물의 길 보기 직전 총정리 [아바타: 물의 길]',
    userNickname: 'B Man 삐맨',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/3037594403797125-5633541b-82a6-41d9-b738-cb0f2ac3e6b9.jpg',
    title: '현재 넷플릭스 세계 1위, 전세계 동심파괴 중인 천재 감독의 어른용 ' '피노키오' '',
    userNickname: '무비콕콕',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/09/15/18/2/233229b1-fec3-4161-bbb3-00ea68e3aacc.jpg',
    title: '[이알뉴] 윤대통령 "거버먼트 인게이지먼트가 레귤레이션"..관저 제설 용산구 예산 써 (류밀희)[김어준의 뉴스공장]',
    userNickname: 'TBS 시민의방송',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/3045079856306658-d8ef3561-ec5d-42cf-a041-548e875e82fe.jpg',
    title: '컴퓨터 출장 AS 수리 사기 당했습니다...',
    userNickname: '뻘짓연구소',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/241136216650329-3ffb8c31-087b-421f-9dfc-70039905173e.jpg',
    title: '땅 팔고 공장 문 닫고‥ 기업들은 이미 찬바람 (2022.12.21/뉴스데스크/MBC)',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2531661649934557-e667c00e-cc9f-42a0-9808-32bed39d5c89.jpg',
    title: '급하게 먹지말라고 했더니 개빡친 강아지 ㅋㅋㅋ',
    userNickname: '솜이네 곰이탱이여우',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/06/30/19/4/7db34ccf-8b10-4b4e-9df7-af45864987a1.jpg',
    title: '[백 투 더 퓨처 3] 실수와 숨겨진 디테일 24가지',
    userNickname: '영사관',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/09/16/17/7/cf506da8-7282-4bbc-a020-b7e4a0c3b6c3.jpg',
    title: '[LIVE] 대한민국 24시간 뉴스채널 YTN',
    userNickname: 'YTN',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/14295572350658336-378c5dfd-23a8-4f19-9a71-9f6d745422b6.jpg',
    title: '[뉴스외전 Zoom人] "밟혀주겠다, 꺾이진 않는다" (2022.12.20/뉴스외전/MBC)',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5283453809047251-e1293dad-6004-45ad-b851-369f0607e5ed.jpg',
    title: '3D펜으로 가짜츄르를 만들면 핥을까?',
    userNickname: '사나고 Sanago',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/12/13/14/6/f891c874-1fae-4b45-8f92-54cd34b7f7ba.jpg',
    title: '역 승강장에 서서 먹는 일본의 국수문화',
    userNickname: '유우키의 일본이야기 YUUKI',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
  ),
];

//////////////////////////////////////////////////////////////////////
class CommunityHomePage extends StatefulWidget {
  const CommunityHomePage({super.key});

  @override
  State<CommunityHomePage> createState() => _CommunityHomePageState();
}

class _CommunityHomePageState extends State<CommunityHomePage> {
  late ScrollController _controller;
  late List<CretaMenuItem> _leftMenuItemList;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_scrollListener);

    _leftMenuItemList = [
      CretaMenuItem(caption: '커뮤니티 홈', iconData: Icons.home_outlined, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '구독목록', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청기록', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '좋아요', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '재생목록', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
    ];
  }

  double headerSize = _rightViewBannerMaxHeight;
  double scrollOffset = 0;
  void _scrollListener() {
    setState(() {
      scrollOffset = _controller.offset;
      headerSize = _rightViewBannerMaxHeight - _controller.offset;
      if (headerSize < _rightViewBannerMinHeight) headerSize = _rightViewBannerMinHeight;
    });
  }

  Widget _getLeftPane(double height) {
    return Snippet.CretaTabBar(_leftMenuItemList, height);
  }

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
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                clipBehavior: Clip.antiAlias,
                width: width - _rightViewLeftPane - _rightViewRightPane,
                height: height - _rightViewTopPane - _rightViewToolbarHeight,
                child: Image.network(
                  'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg',
                  fit: BoxFit.cover,
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
      ),
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
        controller: _controller,
        padding: EdgeInsets.fromLTRB(
            _rightViewLeftPane, _rightViewBannerMaxHeight, _rightViewRightPane, _rightViewBottomPane),
        itemCount: _imageUrlList.length, //item 개수
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 개의 행에 보여줄 item 개수
          childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // 가로÷세로 비율
          mainAxisSpacing: _rightViewItemGapX, //item간 수평 Padding
          crossAxisSpacing: _rightViewItemGapY, //item간 수직 Padding
        ),
        itemBuilder: (BuildContext context, int index) {
          return (itemWidth >= 0 && itemHeight >= 0)
              ? CretaBookItem(
                  key: _imageUrlList[index].globalKey,
                  cretaBookData: _imageUrlList[index],
                  width: itemWidth,
                  height: itemHeight,
                )
              : LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    itemWidth = constraints.maxWidth;
                    itemHeight = constraints.maxHeight;
                    return CretaBookItem(
                      key: _imageUrlList[index].globalKey,
                      cretaBookData: _imageUrlList[index],
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
                height: headerSize,
                child: _getRightBannerPane(width - CretaComponentLocation.TabBar.width, headerSize),
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
                  Image.network(
                    //width: 200,
                    //  height: 100,
                    width: double.maxFinite,
                    widget.cretaBookData.imageUrl,
                    fit: BoxFit.cover,
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
