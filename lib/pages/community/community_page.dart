// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/sub_pages/community_right_home_pane.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
//import '../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
//import '../design_system/creta_color.dart';
import 'package:image_network/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/cross_common_job.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';

bool _isInUsingCanvaskit = false;

class CommunityPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityPage({super.key, this.subPageUrl = ''});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with CretaBasicLayoutMixin {
  late List<CretaMenuItem> _leftMenuItemList;

  late List<CretaMenuItem> _dropDownMenuItemList1;
  late List<CretaMenuItem> _dropDownMenuItemList2;
  late List<CretaMenuItem> _dropDownMenuItemList3;

  Widget Function(Size)? _titlePane;

  void _scrollChangedCallback(bool bannerSizeChanged) {
    setState(() {
      //
    });
  }

  @override
  void initState() {
    super.initState();

    print('_CommunityPageState@initState');

    CrossCommonJob ccj = CrossCommonJob();
    _isInUsingCanvaskit = ccj.isInUsingCanvaskit();

    setUsingBannerScrollBar(
      scrollChangedCallback: _scrollChangedCallback,
      bannerMaxHeight: 436,
      //bannerMinHeight: ,
    );

    _leftMenuItemList = [
      CretaMenuItem(
        caption: '커뮤니티 홈',
        iconData: Icons.home_outlined,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.communityHome);
        },
        linkUrl: AppRoutes.communityHome,
      ),
      CretaMenuItem(
        caption: '구독목록',
        iconData: Icons.local_library_outlined,
        onPressed: () {},
        linkUrl: AppRoutes.subscriptionList,
      ),
      CretaMenuItem(
        caption: '시청기록',
        iconData: Icons.article_outlined,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: '좋아요',
        iconData: Icons.favorite_outline,
        onPressed: () {},
      ),
      CretaMenuItem(
        caption: '재생목록',
        iconData: Icons.playlist_play,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.playList);
        },
        linkUrl: AppRoutes.playList,
      ),
    ];

    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        _leftMenuItemList[1].selected = true;
        _leftMenuItemList[1].onPressed = () {};
        _leftMenuItemList[1].linkUrl = null;
        break;
      case AppRoutes.playList:
        _leftMenuItemList[4].selected = true;
        _leftMenuItemList[4].onPressed = () {};
        _leftMenuItemList[4].linkUrl = null;
        break;
      case AppRoutes.communityHome:
      default:
        _leftMenuItemList[0].selected = true;
        _leftMenuItemList[0].onPressed = () {};
        _leftMenuItemList[0].linkUrl = null;
        _titlePane = _getTitlePane;
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

  Widget _getTitlePane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return Container();
      case AppRoutes.playList:
        return Container();
      case AppRoutes.communityHome:
      default:
        const String bannerUrl =
            'https://static.coupangcdn.com/za/cmg_paperboy/image/1671771512787/PC_C1-Recovered.jpg';
        return _isInUsingCanvaskit
            ? ImageNetwork(
                width: size.width,
                height: size.height,
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
            : CachedNetworkImage(
                width: size.width,
                height: size.height,
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
              );
    }
  }

  Widget _getRightPane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
      case AppRoutes.playList:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
      case AppRoutes.communityHome:
      default:
        return CommunityRightHomePane(
          subPageUrl: widget.subPageUrl,
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    resize(context);
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
      child: mainPage(
        context,
        gotoButtonPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookMyPage);
        },
        gotoButtonTitle: '커뮤니티 홈',
        leftMenuItemList: _leftMenuItemList,
        bannerTitle: 'title',
        bannerDescription: 'description',
        listOfListFilter: [_dropDownMenuItemList1, _dropDownMenuItemList2],
        onSearch: (value) {
          //bookManagerHolder!.onSearch(value, () => setState(() {}));
        },
        mainWidget: _getRightPane(gridArea),
        listOfListFilterOnRight: [_dropDownMenuItemList3],
        titlePane: _titlePane,
      ),
    );
  }
}
