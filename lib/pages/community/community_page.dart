// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/community/community_sample_data.dart';
import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
//import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_button.dart';
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
import '../../design_system/creta_font.dart';
import '../../lang/creta_lang.dart';

import 'package:creta03/pages/community/sub_pages/community_right_home_pane.dart';
import 'package:creta03/pages/community/sub_pages/community_right_playlist_pane.dart';
import 'package:creta03/pages/community/sub_pages/community_right_playlist_detail_pane.dart';

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
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '구독목록',
        iconData: Icons.local_library_outlined,
        onPressed: () {},
        linkUrl: AppRoutes.subscriptionList,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '시청기록',
        iconData: Icons.article_outlined,
        onPressed: () {},
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '좋아요',
        iconData: Icons.favorite_outline,
        onPressed: () {},
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '재생목록',
        iconData: Icons.playlist_play,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.playlist);
        },
        linkUrl: AppRoutes.playlist,
        isIconText: true,
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
      case AppRoutes.playlist:
        _leftMenuItemList[4].selected = true;
        _leftMenuItemList[4].onPressed = () {};
        _leftMenuItemList[4].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        break;
      case AppRoutes.playlistDetail:
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
        caption: CretaLang.basicBookFilter[2],
        iconData: Icons.article_outlined,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[3],
        iconData: Icons.favorite_outline,
        onPressed: () {},
        selected: false,
      ),
    ];

    _dropDownMenuItemList2 = [
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[0],
        iconData: Icons.power,
        onPressed: () {},
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[1],
        iconData: Icons.power,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[2],
        iconData: Icons.power,
        onPressed: () {},
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[3],
        iconData: Icons.power,
        onPressed: () {},
        selected: false,
      ),
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

  Widget _getCommunityHomeTitlePane(Size size) {
    if (size.height > 176 + 40) {
      return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            CustomImage(
              key: CommunitySampleData.bannerKey,
              duration: 500,
              hasMouseOverEffect: false,
              width: size.width,
              height: size.height,
              image: CommunitySampleData.bannerUrl,
            ),
            Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.fromLTRB(60,0,0,0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: 176,
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '커뮤니티 홈',
                          style: CretaFont.displaySmall.copyWith(
                            color: Colors.white,
                            fontWeight: CretaFont.semiBold,
                          ),
                        ),
                        SizedBox(height: 23),
                        Text(
                          '전세계의 작가들이 업로드한 크레타북을 탐색합니다.',
                            style: CretaFont.bodyMedium.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              //fontWeight: CretaFont.regular,
                            ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          '다양한 크레타북을 시청하고 새로운 아이디어를 얻으세요.',
                          style: CretaFont.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            //fontWeight: CretaFont.regular,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            BTN.opacity_gray_it_s(
                              text: '# 해시태그해시태그1  ',
                              //textStyle: CretaFont.buttonMedium,
                              width: null,
                              onPressed: () {}, decoType: CretaButtonDeco.opacity,
                            ),
                            SizedBox(width: 12),
                            BTN.opacity_gray_it_s(
                              text: '# 해시태그2  ',
                              //textStyle: CretaFont.buttonMedium,
                              onPressed: () {}, decoType: CretaButtonDeco.opacity,
                            ),
                            SizedBox(width: 12),
                            BTN.opacity_gray_it_s(
                              text: '# 해시태그3  ',
                              //textStyle: CretaFont.buttonMedium,
                              onPressed: () {}, decoType: CretaButtonDeco.opacity,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          CustomImage(
            key: CommunitySampleData.bannerKey,
            duration: 500,
            hasMouseOverEffect: false,
            width: size.width,
            height: size.height,
            image: CommunitySampleData.bannerUrl,
          ),
          Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.all(100),
            child: Text('커뮤니티 홈2'),
          ),
        ],
      ),
    );
  }

  Widget _getTitlePane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return Container();
      case AppRoutes.playlist:
      case AppRoutes.playlistDetail:
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
        return _getCommunityHomeTitlePane(size);
    }
  }

  List<List<CretaMenuItem>> _getLeftDropdownMenuOnBanner() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        break;
      case AppRoutes.playlist:
        return [_dropDownMenuItemList3];
      case AppRoutes.playlistDetail:
        break;
      case AppRoutes.communityHome:
        return [_dropDownMenuItemList1, _dropDownMenuItemList2];
    }
    return [];
  }

  List<List<CretaMenuItem>>? _getRightDropdownMenuOnBanner() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        break;
      case AppRoutes.playlist:
        break;
      case AppRoutes.playlistDetail:
        break;
      case AppRoutes.communityHome:
        return [_dropDownMenuItemList3];
    }
    return null;
  }

  Function(String)? _getSearchFunction() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        break;
      case AppRoutes.playlist:
        return (value) {};
      case AppRoutes.communityHome:
        return (value) {};
    }
    return null;
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
      case AppRoutes.playlist:
        return CommunityRightPlaylistPane(
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
        listOfListFilter: _getLeftDropdownMenuOnBanner(),
        onSearch: _getSearchFunction(),
        mainWidget: _getRightPane(gridArea),
        listOfListFilterOnRight: _getRightDropdownMenuOnBanner(),
        titlePane: _titlePane,
      ),
    );
  }
}
