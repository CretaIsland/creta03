// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
//import 'dart:async';
//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import '../../design_system/creta_color.dart';
//import 'package:image_network/image_network.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import '../../common/cross_common_job.dart';
import '../../routes.dart';
//import 'sub_pages/community_left_menu_pane.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/creta_font.dart';
import '../../lang/creta_lang.dart';
import '../../model/app_enums.dart';

import 'community_sample_data.dart';
import 'sub_pages/community_right_home_pane.dart';
import 'sub_pages/community_right_channel_pane.dart';
import 'sub_pages/community_right_favorites_pane.dart';
import 'sub_pages/community_right_playlist_pane.dart';
import 'sub_pages/community_right_playlist_detail_pane.dart';
import 'sub_pages/community_right_subscription_pane.dart';
import 'sub_pages/community_right_watch_history_pane.dart';

class CommunityPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityPage({super.key, required this.subPageUrl});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with CretaBasicLayoutMixin {
  late final List<CretaMenuItem> _leftMenuItemList;

  late final List<CretaMenuItem> _dropDownMenuItemListPurpose;
  late final List<CretaMenuItem> _dropDownMenuItemListPermission;
  late final List<CretaMenuItem> _dropDownMenuItemListSort;

  late final Widget Function(Size)? _titlePane;

  final Map<String, CretaBookData> _subscriptionUserMap = {};

  BookType _filterBookType = BookType.none;
  BookSort _filterBookSort = BookSort.updateTime;
  PermissionType _filterPermissionType = PermissionType.none;
  //String _filterSearchKeyword = '';

  void _scrollChangedCallback(bool bannerSizeChanged) {
    setState(() {
      //
    });
  }

  @override
  void initState() {
    super.initState();

    List<CretaBookData> cretaBookList = CommunitySampleData.getCretaBookList();
    for (final cretaBookData in cretaBookList) {
      _subscriptionUserMap.putIfAbsent(cretaBookData.creator, () => cretaBookData);
    }

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
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.subscriptionList);
        },
        linkUrl: AppRoutes.subscriptionList,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '시청기록',
        iconData: Icons.article_outlined,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.watchHistory);
        },
        linkUrl: AppRoutes.watchHistory,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: '좋아요',
        iconData: Icons.favorite_outline,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.favorites);
        },
        linkUrl: AppRoutes.favorites,
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
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          //bannerMinHeight: 160,
          //bannerMaxHeight: 160,
        );
        break;
      case AppRoutes.watchHistory:
        _leftMenuItemList[2].selected = true;
        _leftMenuItemList[2].onPressed = () {};
        _leftMenuItemList[2].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        break;
      case AppRoutes.favorites:
        _leftMenuItemList[3].selected = true;
        _leftMenuItemList[3].onPressed = () {};
        _leftMenuItemList[3].linkUrl = null;
        _titlePane = _getTitlePane;
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

    _dropDownMenuItemListPurpose = [
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[0], // 용도별(전체)
        iconData: Icons.type_specimen,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.none;
            setScrollOffset(0);
          });
        },
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[1], // 프리젠테이션용
        iconData: Icons.local_library_outlined,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.presentaion;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[2], // 전차칠판용
        iconData: Icons.article_outlined,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.board;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookFilter[3], // 디지털사이니지용
        iconData: Icons.favorite_outline,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.signage;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
    ];

    _dropDownMenuItemListPermission = [
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[0], // 권한별(전체)
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.none;
            setScrollOffset(0);
          });
        },
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[1], // 소유자
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.owner;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[2], // 편집자
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.editor;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookPermissionFilter[3], // 뷰어
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.viewer;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
    ];

    _dropDownMenuItemListSort = [
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[0], // 최신순
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterBookSort = BookSort.updateTime;
            setScrollOffset(0);
          });
        },
        selected: true,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[1], // 이름순
        iconData: Icons.local_library_outlined,
        onPressed: () {
          setState(() {
            _filterBookSort = BookSort.name;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[2], // 좋아요순
        iconData: Icons.article_outlined,
        onPressed: () {
          setState(() {
            _filterBookSort = BookSort.likeCount;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang.basicBookSortFilter[3], // 조회수순
        iconData: Icons.favorite_outline,
        onPressed: () {
          setState(() {
            _filterBookSort = BookSort.viewCount;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
    ];
  }

  List<Widget> _getHashtagListOnBanner() {
    return [
      BTN.opacity_gray_it_s(
        text: '#크레타  ',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#추천  ',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#인기  ',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: '#해시태그  ',
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
      ),
    ];
  }

  Widget _getCommunityHomeTitlePane(Size size) {
    if (size.height > 176 + 40) {
      // max size
      List<Widget> titleList = [];
      if (size.width > 175) {
        titleList.add(
          Text(
            '커뮤니티 홈1',
            style: CretaFont.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: CretaFont.semiBold,
            ),
          ),
        );
      }
      if (size.width > 500) {
        titleList.addAll([
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
        ]);
      }
      List<Widget> hashtagList = [];
      if (size.width > 430) {
        hashtagList.addAll([
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _getHashtagListOnBanner(),
          ),
        ]);
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
              hasAni: false,
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
                        ...titleList,
                        ...hashtagList,
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
      // middle size
      List<Widget> titleList = [];
      if (size.width > 175) {
        titleList.add(
          Text(
            '커뮤니티 홈2',
            overflow: TextOverflow.ellipsis,
            style: CretaFont.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: CretaFont.semiBold,
            ),
          ),
        );
      }
      if (size.width > 800) {
        titleList.addAll([
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
        ]);
      }
      Widget hashtagWidget = (size.width > 630) ? Row(children: _getHashtagListOnBanner()) : Container();
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
              hasAni: false,
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
                    height: (titleList.length == 1) ? 48 : 122,
                    //color: Colors.red,
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: titleList,
                        ),
                        Expanded(child: Container()),
                        hashtagWidget,
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
    // min size
    List<Widget> titleList = [];
    if (size.width > 220) {
      titleList.addAll([
        //icon
        Icon(Icons.home_outlined, size: 20),
        SizedBox(width: 12),
        //text
        Text(
          '커뮤니티 홈',
          style: CretaFont.titleELarge.copyWith(fontWeight: CretaFont.semiBold),
        ),
      ]);
    }
    if (size.width > 885) {
      titleList.addAll([
        SizedBox(width: 24),
        //text
        Text(
          '전세계의 작가들이 업로드한 크레타북을 탐색합니다.',
          overflow: TextOverflow.ellipsis,
          style: CretaFont.bodyMedium.copyWith(fontWeight: CretaFont.regular),
        ),
      ]);
    }
    if (size.width > 540) {
      titleList.addAll([
        Expanded(child: Container()),
        Row(children: _getHashtagListOnBanner()),
      ]);
    }

    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(children: titleList),
    );
  }

  Widget _getChannelTitlePane(Size size) {
    // max size
    if (size.height > 100 + 100 + 24 + 8) {
      return Container(
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
                      hasAni: false,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        '${AccountManager.currentLoginUser.name}님의 채널',
                        overflow: TextOverflow.ellipsis,
                        style: CretaFont.displaySmall.copyWith(
                          color: CretaColor.text[700],
                          fontWeight: CretaFont.semiBold,
                        ),
                      ),
                      SizedBox(width: 8),
                      BTN.fill_gray_i_l(
                        icon: Icons.link_outlined,
                        buttonColor: CretaButtonColor.gray100light,
                        iconColor: CretaColor.text[700],
                        onPressed: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 18),
                  Row(
                    children: [
                      Text(
                        '${AccountManager.currentLoginUser.name} 외 10명',
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
      );
    } else if (size.height > 122 + 40) {
      // mid size
      // return SizedBox(
      //   width: size.width,
      //   height: size.height,
      //   child: Stack(
      //     children: [
      //       CustomImage(
      //         key: CommunitySampleData.bannerKey,
      //         duration: 500,
      //         hasMouseOverEffect: false,
      //         width: size.width,
      //         height: size.height,
      //         image: CommunitySampleData.bannerUrl,
      //         hasAni: false,
      //       ),
      //       Container(
      //         width: size.width,
      //         height: size.height,
      //         padding: EdgeInsets.fromLTRB(60, 0, 40, 0),
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           //crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             SizedBox(
      //               width: size.width,
      //               height: 122,
      //               //color: Colors.red,
      //               child: Row(
      //                 children: [
      //                   Column(
      //                     mainAxisAlignment: MainAxisAlignment.start,
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         '커뮤니티 홈',
      //                         style: CretaFont.displaySmall.copyWith(
      //                           color: Colors.white,
      //                           fontWeight: CretaFont.semiBold,
      //                         ),
      //                       ),
      //                       SizedBox(height: 23),
      //                       Text(
      //                         '전세계의 작가들이 업로드한 크레타북을 탐색합니다.',
      //                         overflow: TextOverflow.ellipsis,
      //                         style: CretaFont.bodyMedium.copyWith(
      //                           color: Colors.white,
      //                           fontSize: 16,
      //                           //fontWeight: CretaFont.regular,
      //                         ),
      //                       ),
      //                       SizedBox(height: 13),
      //                       Text(
      //                         '다양한 크레타북을 시청하고 새로운 아이디어를 얻으세요.',
      //                         overflow: TextOverflow.ellipsis,
      //                         style: CretaFont.bodyMedium.copyWith(
      //                           color: Colors.white,
      //                           fontSize: 16,
      //                           //fontWeight: CretaFont.regular,
      //                         ),
      //                       ),
      //                     ],
      //                   ),
      //                   Expanded(child: Container()),
      //                   Row(
      //                     children: _getHashtagListOnBanner(),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }
    // min size
    return Container(
      width: size.width,
      height: size.height,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // left (icon + channel-name + link)
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                clipBehavior: Clip.antiAlias,
                child: CustomImage(
                  key: CommunitySampleData.bannerKey,
                  duration: 500,
                  hasMouseOverEffect: false,
                  width: 32,
                  height: 32,
                  image: CommunitySampleData.bannerUrl,
                  hasAni: false,
                ),
              ),
              SizedBox(width: 12),
              Text(
                '${AccountManager.currentLoginUser.name}님의 채널',
                style: CretaFont.titleELarge.copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
              ),
              SizedBox(width: 20),
              Text(
                '${AccountManager.currentLoginUser.name} 외 10명',
                style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
              ),
              SizedBox(width: 20),
              BTN.fill_gray_i_l(
                icon: Icons.link_outlined,
                buttonColor: CretaButtonColor.gray100light,
                iconColor: CretaColor.text[700],
                onPressed: () {},
              ),
            ],
          ),
          // right (follow + icon)
          Row(
            children: [
              Text(
                '구독자 453명',
                style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
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
    );
  }

  Widget _getSmallTitlePane({
    Size? size,
    IconData? headIcon,
    String? titleText,
    String? descriptionText,
  }) {
    return SizedBox(
      width: size?.width,
      height: size?.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              SizedBox(width: 41),
              (headIcon == null)
                  ? SizedBox.shrink()
                  : Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 11, 0),
                      child: Icon(
                        headIcon,
                        size: 20,
                        color: Colors.grey[800],
                      ),
                    ),
              (titleText == null)
                  ? SizedBox.shrink()
                  : Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 24, 0),
                      child: Text(
                        titleText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          color: Colors.grey[800],
                          fontFamily: 'Pretendard',
                        ),
                      ),
                    ),
              (descriptionText == null)
                  ? SizedBox.shrink()
                  : Text(
                      descriptionText,
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
  }

  Widget _getTitlePane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        return _getChannelTitlePane(size);
      case AppRoutes.subscriptionList:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.local_library_outlined,
          titleText: '구독목록',
          descriptionText: '${AccountManager.currentLoginUser.name}님만을 위한 콘텐츠를 빠르게 만나보세요!',
        );
      case AppRoutes.watchHistory:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.article_outlined,
          titleText: '시청기록',
          descriptionText: '${AccountManager.currentLoginUser.name}님의 최근에 시청한 크레타북입니다.',
        );
      case AppRoutes.favorites:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.favorite_outline,
          titleText: '좋아요',
          descriptionText: '${AccountManager.currentLoginUser.name}님이 좋아요를 누른 크레타북입니다.',
        );
      case AppRoutes.playlist:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.playlist_play,
          titleText: '재생목록',
          descriptionText: '${AccountManager.currentLoginUser.name}님이 만든 재생목록입니다.',
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
                    AccountManager.currentLoginUser.name,
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
        return [_dropDownMenuItemListPurpose, _dropDownMenuItemListPermission, _dropDownMenuItemListSort];
      case AppRoutes.watchHistory:
        return [_dropDownMenuItemListPurpose, _dropDownMenuItemListPermission, _dropDownMenuItemListSort];
      case AppRoutes.favorites:
        return [_dropDownMenuItemListPurpose, _dropDownMenuItemListPermission, _dropDownMenuItemListSort];
      case AppRoutes.playlist:
        return [_dropDownMenuItemListSort];
      case AppRoutes.playlistDetail:
        break;
      case AppRoutes.communityHome:
      case AppRoutes.channel:
        return [_dropDownMenuItemListPurpose, _dropDownMenuItemListPermission, _dropDownMenuItemListSort];
    }
    return [];
  }

  List<List<CretaMenuItem>>? _getRightDropdownMenuOnBanner() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        break;
      case AppRoutes.watchHistory:
        break;
      case AppRoutes.favorites:
        break;
      case AppRoutes.playlist:
        break;
      case AppRoutes.playlistDetail:
        break;
      case AppRoutes.communityHome:
      case AppRoutes.channel:
        break;
      //return [_dropDownMenuItemListSort];
    }
    return null;
  }

  Function(String)? _getSearchFunction() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return (value) {};
      case AppRoutes.watchHistory:
        return (value) {};
      case AppRoutes.favorites:
        return (value) {};
      case AppRoutes.playlist:
        return (value) {};
      case AppRoutes.communityHome:
      case AppRoutes.channel:
        return (value) {};
    }
    return null;
  }

  ValueKey _getRightPaneKey() {
    return ValueKey('${_filterBookType.name}-${_filterBookSort.name}-${_filterPermissionType.name}');
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
        return CommunityRightSubscriptionPane(
          key: ValueKey(_selectedSubscriptionUserId),
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
          selectedUserId: _selectedSubscriptionUserId,
        );
      case AppRoutes.watchHistory:
        return CommunityRightWatchHistoryPane(
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
        );
      case AppRoutes.favorites:
        return CommunityRightFavoritesPane(
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
          key: _getRightPaneKey(),
          pageWidth: size.width,
          pageHeight: size.height,
          scrollController: getBannerScrollController,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          // filterSearchKeyword: ,
        );
    }
  }

  Widget _getRightOverlayPane(Size size) {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        break;
      case AppRoutes.subscriptionList:
        return Positioned(
          left: 310 + 40,
          top: 140, //196 - 40 - 20 + 4,
          child: Container(
            width: 286,
            height: gridArea.height + 40,
            padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
            decoration: BoxDecoration(
              color: CretaColor.text[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 20,
                runSpacing: 20,
                children: _getSubscriptionUserList(),
              ),
            ),
          ),
        );
      case AppRoutes.watchHistory:
      case AppRoutes.favorites:
      case AppRoutes.playlist:
      case AppRoutes.playlistDetail:
      case AppRoutes.communityHome:
      default:
        break;
    }
    return SizedBox.shrink();
  }

  String _selectedSubscriptionUserId = '';
  void _changeSubscriptionUser(String id) {
    setState(() {
      _selectedSubscriptionUserId = id;
    });
  }

  List<Widget> _getSubscriptionUserList() {
    List<Widget> widgetList = [];
    _subscriptionUserMap.forEach((key, cretaBookData) {
      widgetList.add(
        SubscribeUserItem(
          cretaBookData: cretaBookData,
          onChangeSelectUser: _changeSubscriptionUser,
          isSelectedUser: (_selectedSubscriptionUserId == cretaBookData.creator),
        ),
      );
    });
    return widgetList;
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
      child: Stack(
        children: [
          mainPage(
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
            leftPaddingOnFilter: (widget.subPageUrl == AppRoutes.subscriptionList) ? 306 : null,
            leftPaddingOnRightPane: 0,
            topPaddingOnRightPane: 3,
            rightPaddingOnRightPane: 2,
            bottomPaddingOnRightPane: 3,
          ),
          _getRightOverlayPane(gridArea),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////
class SubscribeUserItem extends StatefulWidget {
  final CretaBookData cretaBookData;
  final double width;
  final double height;
  final Function(String) onChangeSelectUser;
  final bool isSelectedUser;

  const SubscribeUserItem({
    super.key,
    required this.cretaBookData,
    this.width = 286,
    this.height = 80,
    required this.onChangeSelectUser,
    required this.isSelectedUser,
  });

  @override
  State<SubscribeUserItem> createState() => _SubscribeUserItemState();
}

class _SubscribeUserItemState extends State<SubscribeUserItem> {
  bool _mouseOver = false;
  late Color? textColor;

  @override
  void initState() {
    super.initState();
    textColor = widget.isSelectedUser ? CretaColor.primary[400] : CretaColor.text[700];
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _mouseOver ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (event) {
        setState(() {
          _mouseOver = true;
        });
      },
      onExit: (event) {
        setState(() {
          _mouseOver = false;
        });
      },
      child: InkWell(
        onTap: () {
          widget.onChangeSelectUser.call(widget.isSelectedUser ? '' : widget.cretaBookData.creator);
        },
        child: Container(
          width: 246,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: widget.isSelectedUser ? Colors.white : null,
          ),
          clipBehavior: Clip.antiAlias,
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Row(
            children: [
              //Icon(Icons.account_circle, size:40),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.cretaBookData.thumbnailUrl,
                  height: 40,
                  width: 40,
                ),
              ),
              SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 246 - 40 - 12 - 20 - 20,
                    child: Text(
                      widget.cretaBookData.creator,
                      style: CretaFont.buttonLarge.copyWith(color: textColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '구독자 xx명',
                    style: CretaFont.bodySmall.copyWith(color: textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
