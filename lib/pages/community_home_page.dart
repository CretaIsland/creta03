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
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../common/cross_common_job.dart';

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

late bool isInUsingCanvaskit;

///////////////////////////////////////////////////////
class CretaBookData {
  CretaBookData({
    required this.imageUrl,
    required this.imageSize,
    required this.title,
    required this.userNickname,
    required this.favorites,
    required this.globalKey,
    required this.totalPages,
  });

  String imageUrl;
  double imageSize;
  String title;
  String userNickname;
  bool favorites;
  GlobalKey globalKey;
  int totalPages;
}

var cretaBookList = [
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/99820741428583-2df54399-e5c3-414f-902b-7df5f66b3659.jpg',
    title: '???????????? 01', //'NewJeans (?????????) ' 'Ditto' ' Official MV (side B)',
    userNickname: '????????? ?????????', //'HYBE LABELS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 5,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2022/03/16/11/6/48106a75-92ba-4ae5-ace8-6b9a7b579065.jpg',
    title: 'NCT DREAM ????????? ?????? ' 'Candy' ' MV',
    userNickname: 'SMTOWN',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 12,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5926724526400602-204ace08-26d9-44fe-a9c9-8ba4f62e98e9.jpg',
    title: 'ICBM ????????? ????????? "?????? ??? ????????? ????????? ???" [???????????? ???????????? ????????? 12/22(???)]',
    userNickname: 'TBS ???????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 8,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/07/24/11/4/f8083863-638a-417e-9644-0f646a2bea72.jpg',
    title: '????????????, ??????, ??????, ??????, ???????????? ????????? ??????????????? ?????? ??????',
    userNickname: 'Lucid Dream',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 21,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7436639300021515-8546ddc5-1299-4d87-8a92-a574fa42f4b4.jpg',
    title: '??????????????? ?????? 2023, ??????????????? ??????, ????????? ??????????????? ??????, ????????? ??????, ??????????????? ?????????',
    userNickname: 'Piano Musica',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 4,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/340405791149789-09c51072-be11-43fc-9427-b2f84a4da5b8.jpg',
    title: '?????? ????????? ?????? ????????? ?????? ?????????????????? ??????!?',
    userNickname: '???????????? Korean Englishman',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 3,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/06/01/18/8/8f9f7104-1663-4dab-907e-8a5e7b03accb.jpg',
    title: '18??? ???????????? ??????????????? ????????? ?????? ?????????',
    userNickname: '???????????? G?????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 17,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2022/10/06/11/0/f58c9008-86a8-449c-bfa8-d99ba86e2e73.jpg',
    title: '[???????????? ?????????????] ??? ????????? ????????? ?????? ?????? (With god) Ep.17',
    userNickname: '????????? [IU Official]',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 22,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/8558233514918916-3416c42b-0678-4660-a58b-54faa20e5375.jpg',
    title: '[??? ??? ?????????] ?????? ?????? ???????????? ????????? ??????, ????????? / YTN ????????????',
    userNickname: 'YTN ????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 3,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7299477591796270-63ffe77e-2792-40fe-8ce5-3a4e337ec9bb.jpg',
    title: '????????? ????????? ?????? ????????? ????????? ???????????? ??? ??????, ?????????????????? ?????? ' '??????' '???????',
    userNickname: '????????????: Owl' 's Review',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 28,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/9105828210613186-eb28a667-1ae4-4758-853e-9bb38f010114.jpg',
    title: '[?????? ??? ????????? ??????_EP. 18_??????] ???????????? ????????? ?????? ????????????? ?????? ?????? ??? ?????? ???????????????! ??? ?????? ?????? ????????? ????????? ????????????!',
    userNickname: '????????? PAIK JONG WON',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 45,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2437405925503738-c49517a0-b027-486e-aa11-95bc3dda6ee8.jpg',
    title: '????????? ????????? ???????????????? ?????????????????? ?????????????????? ?????? ??????! ???????????? ?????? [???????????? ????????? ??????] 2???',
    userNickname: '????????? : ???????????? ????????? ??? ????????? ???',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 2,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/03/17/19/2/d7fa436c-bb25-40df-b95f-b998af74d111.jpg',
    title: '???????????? ????????? ?????? ???????????? ?????? ???????????? ???????????? ??? [????????????/????????????]',
    userNickname: '?????? MASTER',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 11,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/10/21/16/3/88432c7e-584a-4748-9db2-9760f8080ac3.jpg',
    title: '????????? ?????? ????????? ????????????? ???????????? ??????????????? 2???! | ??????, ??????, ??????',
    userNickname: '???????????? ??????Play',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 23,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/7305328818839261-9f3fb78f-0966-4a4e-9339-8018d0299b8f.jpg',
    title: '??????(YOUNHA) - ????????? ????????? M/V',
    userNickname: 'YOUNHA OFFICIAL',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 34,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail6.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/399033406503243-2d2b10ef-dcc7-4a2e-ab92-cd2d1e28b7b1.jpg',
    title: '[#???????????????????????????] ???????????? ????????? ????????? ????????? ??????????????? ????????? ??????! ???????????? ?????? ????????? ?????? ??? ?????? ??????????????? ????????? ????????? ?????? | #????????????',
    userNickname: '?????? :Diggle',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 4,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/01/22/18/9/96088f38-eb71-4f68-9ddc-fe134e3d47d9.jpg',
    title: '????????????????? ??? ??? ?????????????????? ?????? 30cm - [LIVE] MBC 930?????? 2022??? 12??? 22???',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 19,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2429208925380047-ade2fbeb-30b7-47c2-9eb1-d3f4abff955e.jpg',
    title: '[#?????????] ?????? ????????? ????????? ?????????! ???????????? ?????? ???????????? ?????? ??????&???????????????? | #?????????????????????',
    userNickname: 'tvN D ENT',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 25,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/65091360063729-d8eb8649-41b7-46de-9169-ccbb709d710f.jpg',
    title: '?????????? ?????????? 2022??? ????????? ?????????',
    userNickname: '????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 24,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail8.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5645972548099588-1a098763-67b8-4a50-9c90-c58d835eeb70.jpg',
    title: '?????????2 ?????? ??? ?????? ?????? ????????? [?????????: ?????? ???]',
    userNickname: 'B Man ??????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 10,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/3037594403797125-5633541b-82a6-41d9-b738-cb0f2ac3e6b9.jpg',
    title: '?????? ???????????? ?????? 1???, ????????? ???????????? ?????? ?????? ????????? ????????? ' '????????????' '',
    userNickname: '????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 43,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2020/09/15/18/2/233229b1-fec3-4161-bbb3-00ea68e3aacc.jpg',
    title: '[?????????] ???????????? "???????????? ????????????????????? ???????????????"..?????? ?????? ????????? ?????? ??? (?????????)[???????????? ????????????]',
    userNickname: 'TBS ???????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 23,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/3045079856306658-d8ef3561-ec5d-42cf-a041-548e875e82fe.jpg',
    title: '????????? ?????? AS ?????? ?????? ???????????????...',
    userNickname: '???????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 28,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail7.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/241136216650329-3ffb8c31-087b-421f-9dfc-70039905173e.jpg',
    title: '??? ?????? ?????? ??? ????????? ???????????? ?????? ????????? (2022.12.21/???????????????/MBC)',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 5,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2531661649934557-e667c00e-cc9f-42a0-9808-32bed39d5c89.jpg',
    title: '????????? ??????????????? ????????? ????????? ????????? ?????????',
    userNickname: '????????? ??????????????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 7,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/06/30/19/4/7db34ccf-8b10-4b4e-9df7-af45864987a1.jpg',
    title: '[??? ??? ??? ?????? 3] ????????? ????????? ????????? 24??????',
    userNickname: '?????????',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 15,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail9.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/09/16/17/7/cf506da8-7282-4bbc-a020-b7e4a0c3b6c3.jpg',
    title: '[LIVE] ???????????? 24?????? ???????????? YTN',
    userNickname: 'YTN',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 31,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/14295572350658336-378c5dfd-23a8-4f19-9a71-9f6d745422b6.jpg',
    title: '[???????????? Zoom???] "???????????????, ????????? ?????????" (2022.12.20/????????????/MBC)',
    userNickname: 'MBCNEWS',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 18,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/5283453809047251-e1293dad-6004-45ad-b851-369f0607e5ed.jpg',
    title: '3D????????? ??????????????? ????????? ??????????',
    userNickname: '????????? Sanago',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 3,
  ),
  CretaBookData(
    imageUrl:
        'https://thumbnail10.coupangcdn.com/thumbnails/remote/230x230ex/image/retail/images/2021/12/13/14/6/f891c874-1fae-4b45-8f92-54cd34b7f7ba.jpg',
    title: '??? ???????????? ?????? ?????? ????????? ????????????',
    userNickname: '???????????? ??????????????? YUUKI',
    imageSize: 0,
    favorites: false,
    globalKey: GlobalKey(),
    totalPages: 6,
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
      CretaMenuItem(caption: '???????????? ???', iconData: Icons.home_outlined, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '????????????', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '????????????', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '?????????', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '????????????', iconData: Icons.playlist_play, onPressed: () {}, selected: false),
    ];

    CrossCommonJob ccj = CrossCommonJob();
    isInUsingCanvaskit = ccj.isInUsingCanvaskit();
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
    const String bannerUrl = 'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg';
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
                child: isInUsingCanvaskit ?
                ImageNetwork(
                  width: width - _rightViewLeftPane - _rightViewRightPane,
                  height: height - _rightViewTopPane - _rightViewToolbarHeight,
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
                ) :
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
                    child: Icon(Icons.error, color: Colors.red, size: 40,),
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
                  items: const ['????????????', '????????????1', '????????????2', '????????????3'],
                  defaultValue: '????????????',
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
                  items: const ['??????', '??????1', '??????2', '??????3'],
                  defaultValue: '??????',
                  onSelected: (value) {
                    //logger.finest('value=$value');
                  }),
            ),
            Positioned(
              top: height - 57,
              left: width - _rightViewRightPane - 134 - 246 - 2,
              child: CretaSearchBar(
                hintText: '???????????? ???????????????',
                onSearch: (value) {},
                width: 246,
                height: 32,
              ),
            ),
            // ?????????????????? ?????? ??????
            Positioned(
              top: height - 57,
              left: width - _rightViewRightPane - 134,
              child: CretaDropDown(
                  width: 134,
                  height: 36,
                  items: const ['?????? ????????????', '?????? ????????????1', '?????? ????????????2', '?????? ????????????3'],
                  defaultValue: '?????? ????????????',
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
        itemCount: cretaBookList.length, //item ??????
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnCount, //1 ?????? ?????? ????????? item ??????
          childAspectRatio: _itemDefaultWidth / _itemDefaultHeight, // ?????????????? ??????
          mainAxisSpacing: _rightViewItemGapX, //item??? ?????? Padding
          crossAxisSpacing: _rightViewItemGapY, //item??? ?????? Padding
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
        // ?????? ??????
        _getLeftPane(height - CretaComponentLocation.BarTop.height),
        // ????????? ?????????
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
      logger.finest('???????????? ??????');
      setState(() {
        popmenuOpen = false;
      });
    });
  }

  void _editItem() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuPlay() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuEdit() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuAddToPlayList() {
    logger.finest('??????????????? ??????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuShare() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuDownload() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  void _doPopupMenuCopy() {
    logger.finest('????????????(${widget.cretaBookData.title})');
  }

  @override
  void initState() {
    super.initState();

    _popupMenuList = [
      CretaMenuItem(
        caption: '????????????',
        onPressed: _doPopupMenuPlay,
      ),
      CretaMenuItem(
        caption: '????????????',
        onPressed: _doPopupMenuEdit,
      ),
      CretaMenuItem(
        caption: '??????????????? ??????',
        onPressed: _doPopupMenuAddToPlayList,
      ),
      CretaMenuItem(
        caption: '????????????',
        onPressed: _doPopupMenuShare,
      ),
      CretaMenuItem(
        caption: '????????????',
        onPressed: _doPopupMenuDownload,
      ),
      CretaMenuItem(
        caption: '????????????',
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
                                '????????????',
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
                  isInUsingCanvaskit ?
                  // ????????? ????????? ?????????
                  ImageNetwork(
                    width: widget.width,
                    height: widget.height - _itemDescriptionHeight,
                    image: widget.cretaBookData.imageUrl,
                    imageCache: CachedNetworkImageProvider(widget.cretaBookData.imageUrl),
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
                  ) :
                  // Image.network(
                  //   //width: 200,
                  //   //height: 100,
                  //   width: double.maxFinite,
                  //   widget.cretaBookData.imageUrl,
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
                    imageUrl: widget.cretaBookData.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40,),
                    ),
                  ),
                  // ????????????, ??????, ?????? ?????? (????????? ??????)
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
