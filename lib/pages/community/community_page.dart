// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/community_sample_data.dart';
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
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/custom_image.dart';
import '../../lang/creta_lang.dart';

import 'package:creta03/pages/community/sub_pages/community_right_home_pane.dart';
import 'package:creta03/pages/community/sub_pages/community_right_playlist_pane.dart';

//bool _isInUsingCanvaskit = false;

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

    // CrossCommonJob ccj = CrossCommonJob();
    // _isInUsingCanvaskit = ccj.isInUsingCanvaskit();

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
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        break;
      case AppRoutes.playList:
        _leftMenuItemList[4].selected = true;
        _leftMenuItemList[4].onPressed = () {};
        _leftMenuItemList[4].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        break;
      case AppRoutes.communityHome:
      default:
        _leftMenuItemList[0].selected = true;
        _leftMenuItemList[0].onPressed = () {};
        _leftMenuItemList[0].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          bannerMaxHeight: 436,
          //bannerMinHeight: ,
        );
        break;
    }

    _dropDownMenuItemList1 = [
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[0],
        iconData: Icons.type_specimen,
        onPressed: () {},
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[1],
        iconData: Icons.local_library_outlined,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[1],
        iconData: Icons.article_outlined,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[1],
        iconData: Icons.favorite_outline,
        onPressed: () {},
        selected: false,
      ),
    ];

    _dropDownMenuItemList2 = [
      CretaMenuItem(caption: '권한', iconData: Icons.power, onPressed: () {}, selected: true),
      CretaMenuItem(caption: '관리자', iconData: Icons.local_library_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '편집자', iconData: Icons.article_outlined, onPressed: () {}, selected: false),
      CretaMenuItem(caption: '시청자', iconData: Icons.favorite_outline, onPressed: () {}, selected: false),
    ];

    _dropDownMenuItemList3 = [
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[0],
        iconData: Icons.power,
        onPressed: () {},
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[1],
        iconData: Icons.local_library_outlined,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[2],
        iconData: Icons.article_outlined,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[3],
        iconData: Icons.favorite_outline,
        onPressed: () {},
        selected: false,
      ),
    ];
  }

  Widget _getTitlePane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return Container();
      case AppRoutes.playList:
        return SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 41),
                  Icon(
                    Icons.playlist_play,
                    size: 20,
                    color: Colors.grey[800],
                  ),
                  SizedBox(width: 11),
                  Text(
                    '재생목록',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(width: 24),
                  Text(
                    '사용자 닉네임님이 만든 재생목록입니다.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontFamily: 'Pretendard',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      case AppRoutes.communityHome:
      default:
        return CustomImage(
            key: CommunitySampleData.bannerKey,
            duration: 500,
            hasMouseOverEffect: false,
            width: size.width,
            height: size.height,
            image: CommunitySampleData.bannerUrl);
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
        return CommunityRightPlayListPane(
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
