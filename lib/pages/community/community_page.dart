// ignore_for_file: prefer_const_constructors

import 'package:creta03/design_system/creta_color.dart';
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

import 'package:creta03/pages/community/community_sample_data.dart';
import 'package:creta03/pages/community/sub_pages/community_right_home_pane.dart';
import 'package:creta03/pages/community/sub_pages/community_right_channel_pane.dart';
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
      case AppRoutes.channel:
        //_leftMenuItemList[1].selected = true;
        //_leftMenuItemList[1].onPressed = () {};
        //_leftMenuItemList[1].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          bannerMaxHeight: 436,
        );
        break;
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
          bannerMinHeight: 160,
          bannerMaxHeight: 160,
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

  List<Widget> _getHashtagListOnBanner() {
    return [
      BTN.opacity_gray_it_s(
        text: '#크레타',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#추천',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#인기',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#해시태그',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
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
              padding: EdgeInsets.fromLTRB(60, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
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
                          overflow: TextOverflow.ellipsis,
                          style: CretaFont.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            //fontWeight: CretaFont.regular,
                          ),
                        ),
                        SizedBox(height: 13),
                        Text(
                          '다양한 크레타북을 시청하고 새로운 아이디어를 얻으세요.',
                          overflow: TextOverflow.ellipsis,
                          style: CretaFont.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            //fontWeight: CretaFont.regular,
                          ),
                        ),
                        SizedBox(height: 24),
                        (size.width > 300)
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: _getHashtagListOnBanner(),
                        )
                            : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (size.height > 122 + 40) {
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
              padding: EdgeInsets.fromLTRB(60, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width,
                    height: 122,
                    //color: Colors.red,
                    child: Row(
                      children: [
                        Column(
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
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                //fontWeight: CretaFont.regular,
                              ),
                            ),
                            SizedBox(height: 13),
                            Text(
                              '다양한 크레타북을 시청하고 새로운 아이디어를 얻으세요.',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                //fontWeight: CretaFont.regular,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: _getHashtagListOnBanner(),
                        ),
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
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          //icon
          Icon(Icons.home_outlined, size: 20),
          SizedBox(width: 12),
          //text
          Text(
            '커뮤니티 홈',
            style: CretaFont.titleELarge.copyWith(fontWeight: CretaFont.semiBold),
          ),
          SizedBox(width: 24),
          //text
          Text(
            '전세계의 작가들이 업로드한 크레타북을 탐색합니다.',
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(fontWeight: CretaFont.regular),
          ),
          //space
          Expanded(
            child: Container(),
          ),
          //hash tag
          ..._getHashtagListOnBanner(),
        ],
      ),
    );
  }

  Widget _getChannelTitlePane(Size size) {
    if (size.height > 176 + 40) {
      return SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // CustomImage(
            //   key: CommunitySampleData.bannerKey,
            //   duration: 500,
            //   hasMouseOverEffect: false,
            //   width: size.width,
            //   height: size.height,
            //   image: CommunitySampleData.bannerUrl,
            // ),
            Container(
              width: size.width,
              height: size.height,
              padding: EdgeInsets.fromLTRB(60, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width,
                    height: 224,
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CustomImage(
                            key: CommunitySampleData.bannerKey,
                            duration: 500,
                            hasMouseOverEffect: false,
                            width: 100,
                            height: 100,
                            image: CommunitySampleData.bannerUrl,
                          ),
                        ),
                        SizedBox(height: 24),
                        Row(
                          children: [
                            Text(
                              '사용자 닉네임2님의 채널',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.displaySmall.copyWith(
                                color: CretaColor.text[700],
                                fontWeight: CretaFont.semiBold,
                              ),
                            ),
                            SizedBox(width: 8),
                            BTN.fill_gray_i_l(icon: Icons.link_outlined, onPressed: () {}),
                          ],
                        ),
                        SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              '사용자 닉네임 외 10명',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.buttonLarge.copyWith(
                                color: CretaColor.text[400],
                                //fontSize: 16,
                                fontWeight: CretaFont.medium,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              '구독중 453명',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.buttonLarge.copyWith(
                                color: CretaColor.text[400],
                                //fontSize: 16,
                                fontWeight: CretaFont.medium,
                              ),
                            ),
                            SizedBox(width: 20),
                            Text(
                              '구독자 453명',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.buttonLarge.copyWith(
                                color: CretaColor.text[400],
                                //fontSize: 16,
                                fontWeight: CretaFont.medium,
                              ),
                            ),
                            SizedBox(width: 12),
                            BTN.fill_blue_t_m(
                              width: 84,
                              text: '구독하기',
                              onPressed: () {},
                              textStyle: CretaFont.buttonLarge.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (size.height > 122 + 40) {
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
              padding: EdgeInsets.fromLTRB(60, 0, 40, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: size.width,
                    height: 122,
                    //color: Colors.red,
                    child: Row(
                      children: [
                        Column(
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
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                //fontWeight: CretaFont.regular,
                              ),
                            ),
                            SizedBox(height: 13),
                            Text(
                              '다양한 크레타북을 시청하고 새로운 아이디어를 얻으세요.',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.bodyMedium.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                //fontWeight: CretaFont.regular,
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          children: _getHashtagListOnBanner(),
                        ),
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
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        children: [
          //icon
          Icon(Icons.home_outlined, size: 20),
          SizedBox(width: 12),
          //text
          Text(
            '커뮤니티 홈',
            style: CretaFont.titleELarge.copyWith(fontWeight: CretaFont.semiBold),
          ),
          SizedBox(width: 24),
          //text
          Text(
            '전세계의 작가들이 업로드한 크레타북을 탐색합니다.',
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(fontWeight: CretaFont.regular),
          ),
          //space
          Expanded(
            child: Container(),
          ),
          //hash tag
          ..._getHashtagListOnBanner(),
        ],
      ),
    );
  }

  Widget _getTitlePane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        return _getChannelTitlePane(size);
      case AppRoutes.subscriptionList:
        return Container();
      case AppRoutes.playlist:
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
      case AppRoutes.playlistDetail:
        return Container(
          width: size.width,
          height: size.height,
          //color: Colors.red,
          padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    '재생목록 01',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      color: Colors.grey[800],
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                  ),
                  SizedBox(width: 28),
                  Text(
                    '사용자 닉네임',
                    style: CretaFont.buttonMedium,
                  ),
                  SizedBox(width: 28),
                  Text(
                    '영상 54개',
                    style: CretaFont.buttonMedium,
                  ),
                  SizedBox(width: 28),
                  Text(
                    '최근 업데이트 1일전',
                    style: CretaFont.buttonMedium,
                  ),
                  Expanded(child: Container()),
                  BTN.fill_blue_t_m(
                    text: '재생하기',
                    width: null,
                    onPressed: () {},
                    textStyle: CretaFont.buttonLarge.copyWith(color: Colors.white),
                  ),
                  SizedBox(width: 6),
                  BTN.fill_gray_i_m(icon: Icons.menu, onPressed: () {}),
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
      case AppRoutes.channel:
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
      case AppRoutes.channel:
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
      case AppRoutes.channel:
        return (value) {};
    }
    return null;
  }

  Widget _getRightPane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        return CommunityRightChannelPane(
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
      case AppRoutes.subscriptionList:
        return CommunityRightHomePane(
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
      case AppRoutes.playlistDetail:
        return CommunityRightPlaylistDetailPane(
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
      case AppRoutes.communityHome:
      default:
        return CommunityRightHomePane(
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
        gotoButtonTitle: '내 크레타북 관리',
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
