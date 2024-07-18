// ignore_for_file: prefer_const_constructors

//import 'dart:async';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

//import 'package:flutter/gestures.dart';
import 'package:hycop/hycop.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_strategy/url_strategy.dart';
import 'package:url_launcher/link.dart';
import '../../data_io/host_manager.dart';
import '../../lang/creta_commu_lang.dart';
import '../../routes.dart';
//import '../../pages/login_page.dart';
import '../login/login_dialog.dart';
import '../../pages/login/creta_account_manager.dart';
//import '../../common/cross_common_job.dart';
import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import '../../design_system/buttons/creta_button_wrapper.dart';
import '../../design_system/buttons/creta_button.dart';
import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/custom_image.dart';
import '../../design_system/component/snippet.dart';
//import '../../design_system/menu/creta_drop_down.dart';
import '../../design_system/menu/creta_popup_menu.dart';
//import '../../design_system/text_field/creta_search_bar.dart';
import 'package:creta_common/lang/creta_lang.dart';
import '../../data_io/book_manager.dart';
import '../../data_io/favorites_manager.dart';
import '../../data_io/subscription_manager.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/book_model.dart';
//import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import '../../model/channel_model.dart';
import '../../model/subscription_model.dart';
import '../../pages/studio/studio_constant.dart';
import '../../pages/studio/studio_snippet.dart';
import '../../pages/studio/studio_variables.dart';
import '../../model/playlist_model.dart';

import '../studio/host_select_page.dart';
import 'sub_pages/community_right_home_pane.dart';
import 'sub_pages/community_right_channel_pane.dart';
import 'sub_pages/community_right_channel_info_pane.dart';
import 'sub_pages/community_right_channel_members_pane.dart';
import 'sub_pages/community_right_channel_playlist_pane.dart';
import 'sub_pages/community_right_favorites_pane.dart';
import 'sub_pages/community_right_playlist_pane.dart';
import 'sub_pages/community_right_playlist_detail_pane.dart';
import 'sub_pages/community_right_subscription_pane.dart';
import 'sub_pages/community_right_watch_history_pane.dart';
import 'sub_pages/community_right_book_pane.dart';
import 'creta_subscription_ui_item.dart';

class CommunityPage extends StatefulWidget {
  final String subPageUrl;
  const CommunityPage({super.key, required this.subPageUrl});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> with CretaBasicLayoutMixin {
  late List<CretaMenuItem> _leftMenuItemList;

  late List<CretaMenuItem> _rightTabMenuList;
  late List<CretaMenuItem> _dropDownMenuItemListPurpose;
  late List<CretaMenuItem> _dropDownMenuItemListPermission;
  late List<CretaMenuItem> _dropDownMenuItemListSort;

  late Widget Function(Size)? _titlePane;

  final ScrollController _rightOverlayPaneScrollController = ScrollController();

  CommunityChannelType _communityChannelType = CommunityChannelType.books;

  late FavoritesManager favoritesManagerHolder;
  PlaylistModel? _currentPlaylistModel;
  BookModel? _currentBookModel;
  ChannelModel? _currentChannelModel;
  UserPropertyModel? _userPropertyModelOfBookModel;
  //TeamModel? _teamModel;
  List<SubscriptionModel>? _subscriptionModelList;
  SubscriptionModel? _selectedSubscriptionModel;
  bool _bookIsFavorites = false;
  Function? _addToPlaylist;

  late BookType _filterBookType;
  BookSort _filterBookSort = BookSort.updateTime;
  PermissionType _filterPermissionType = PermissionType.none;
  String _filterSearchKeyword = '';
  DateTime _filterSearchKeywordTime = DateTime.now();

  LanguageType oldLanguage = LanguageType.none;

  late HostManager hostManagerHolder;

  void _scrollChangedCallback(bool bannerSizeChanged) {
    setState(() {
      //
    });
  }

  @override
  void dispose() {
    super.dispose();
    StudioVariables.isFullscreen = false;
  }

  @override
  void initState() {
    super.initState();

    _filterBookType = CretaVars.instance.defaultBookType();

    favoritesManagerHolder = FavoritesManager();
    StudioVariables.isFullscreen = false;
    isLangInit = initLang();

    hostManagerHolder = HostManager();
    hostManagerHolder.configEvent(notifyModify: false);
    hostManagerHolder.clearAll();
  }

  static Future<bool>? isLangInit;

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initLeftMenu();
    _initDropdownMenu();
    _initPageVariables();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;

    return true;
  }

  void _initLeftMenu() {
    _leftMenuItemList = [
      CretaMenuItem(
        caption: CretaCommuLang['commuHome']!, // '커뮤니티 홈',
        iconData: Icons.home_outlined,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.communityHome);
        },
        linkUrl: AppRoutes.communityHome,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaCommuLang['subsList']!, // '구독목록',
        iconData: Icons.local_library_outlined,
        onPressed: () {
          if (AccountManager.currentLoginUser.isLoginedUser) {
            Routemaster.of(context).push(AppRoutes.subscriptionList);
          } else {
            LoginDialog.popupDialog(context: context, getBuildContext: getBuildContext);
          }
        },
        linkUrl: AppRoutes.subscriptionList,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaCommuLang['watchHistory']!, // '시청기록',
        iconData: Icons.article_outlined,
        onPressed: () {
          if (AccountManager.currentLoginUser.isLoginedUser) {
            Routemaster.of(context).push(AppRoutes.watchHistory);
          } else {
            LoginDialog.popupDialog(context: context, getBuildContext: getBuildContext);
          }
        },
        linkUrl: AppRoutes.watchHistory,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaCommuLang['iLikeIt']!, // '좋아요',
        iconData: Icons.favorite_outline,
        onPressed: () {
          if (AccountManager.currentLoginUser.isLoginedUser) {
            Routemaster.of(context).push(AppRoutes.favorites);
          } else {
            LoginDialog.popupDialog(context: context, getBuildContext: getBuildContext);
          }
        },
        linkUrl: AppRoutes.favorites,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaCommuLang['playList']!, // '재생목록',
        iconData: Icons.playlist_play,
        onPressed: () {
          if (AccountManager.currentLoginUser.isLoginedUser) {
            Routemaster.of(context).push(AppRoutes.playlist);
          } else {
            LoginDialog.popupDialog(context: context, getBuildContext: getBuildContext);
          }
        },
        linkUrl: AppRoutes.playlist,
        isIconText: true,
      ),
    ];
  }

  void _initDropdownMenu() {
    _dropDownMenuItemListPurpose = [
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![0], // 용도별(전체)
        iconData: Icons.type_specimen,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.none;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.none,
        disabled: CretaVars.instance.serviceType != ServiceType.none,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![1], // 프리젠테이션용
        iconData: Icons.local_library_outlined,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.presentation;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.presentation,
        disabled: CretaVars.instance.serviceType != ServiceType.presentation,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![2], // 전자칠판용
        iconData: Icons.favorite_outline,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.board;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.board,
        disabled: CretaVars.instance.serviceType != ServiceType.board,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![3], // 디지털사이니지용 전차칠판용
        iconData: Icons.article_outlined,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.signage;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.signage,
        disabled: CretaVars.instance.serviceType != ServiceType.signage,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![4], // 디지털바리케이드용
        iconData: Icons.favorite_outline,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.barricade;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.barricade,
        disabled: CretaVars.instance.serviceType != ServiceType.barricade,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookFilter']![5], // 기타
        iconData: Icons.favorite_outline,
        onPressed: () {
          setState(() {
            _filterBookType = BookType.etc;
            setScrollOffset(0);
          });
        },
        selected: CretaVars.instance.serviceType == ServiceType.etc,
        disabled: CretaVars.instance.serviceType != ServiceType.etc,
      ),
    ];
    //
    _dropDownMenuItemListPermission = [
      CretaMenuItem(
        caption: CretaLang['basicBookPermissionFilter']![0], // 권한별(전체)
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
        caption: CretaLang['basicBookPermissionFilter']![1], // 소유자
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
        caption: CretaLang['basicBookPermissionFilter']![2], // 편집자
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.writer;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
      CretaMenuItem(
        caption: CretaLang['basicBookPermissionFilter']![3], // 뷰어
        iconData: Icons.power,
        onPressed: () {
          setState(() {
            _filterPermissionType = PermissionType.reader;
            setScrollOffset(0);
          });
        },
        selected: false,
      ),
    ];
    //
    _dropDownMenuItemListSort = [
      CretaMenuItem(
        caption: CretaLang['basicBookSortFilter']![0], // 최신순
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
        caption: CretaLang['basicBookSortFilter']![1], // 이름순
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
        caption: CretaLang['basicBookSortFilter']![2], // 좋아요순
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
        caption: CretaLang['basicBookSortFilter']![3], // 조회수순
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
    //
    if (widget.subPageUrl == AppRoutes.playlist) {
      _dropDownMenuItemListSort.removeLast(); // 삭제(조회수)
      _dropDownMenuItemListSort.removeLast(); // 삭제(좋아요)
    }
  }

  void _initPageVariables() {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        //_leftMenuItemList[1].selected = true;
        //_leftMenuItemList[1].onPressed = () {};
        //_leftMenuItemList[1].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          bannerMaxHeight: 436 + 64,
          bannerMinHeight: CretaConst.cretaBannerMinHeight + 64,
        );
        _rightTabMenuList = [
          CretaMenuItem(
            caption: CretaCommuLang['cretaBook'],
            //iconData: null,
            index: CommunityChannelType.books.index,
            selected: true,
            onPressed: () {
              if (kDebugMode) print('pressed CommunityChannelType.books');
              if (_communityChannelType != CommunityChannelType.books) {
                setState(() {
                  _communityChannelType = CommunityChannelType.books;
                  for (var menuItem in _rightTabMenuList) {
                    menuItem.selected = (menuItem.index == CommunityChannelType.books.index);
                    if (menuItem.selected) {
                      if (kDebugMode) {
                        print('pressed CommunityChannelType.books (${menuItem.index})');
                      }
                    }
                  }
                  if (CommunityRightChannelPane.lastDropdownMenuCount == 0) {
                    setBannerHeight = getBannerHeight + 36;
                  }
                  double bannerHeight = 436 + 64 - getBannerHeight;
                  setBannerScrollController(ScrollController(initialScrollOffset: bannerHeight));
                });
              }
            },
            //linkUrl: null,
            //isIconText: true,
          ),
          CretaMenuItem(
            caption: CretaCommuLang['playList']!,
            //iconData: null,
            index: CommunityChannelType.playlists.index,
            onPressed: () {
              if (_communityChannelType != CommunityChannelType.playlists) {
                if (kDebugMode) print('pressed CommunityChannelType.playlists');
                setState(() {
                  _communityChannelType = CommunityChannelType.playlists;
                  for (var menuItem in _rightTabMenuList) {
                    menuItem.selected = (menuItem.index == CommunityChannelType.playlists.index);
                    if (menuItem.selected) {
                      if (kDebugMode) {
                        print('pressed CommunityChannelType.books (${menuItem.index})');
                      }
                    }
                  }
                  if (CommunityRightChannelPane.lastDropdownMenuCount == 0) {
                    setBannerHeight = getBannerHeight + 36;
                  }
                  double bannerHeight = 436 + 64 - getBannerHeight;
                  setBannerScrollController(ScrollController(initialScrollOffset: bannerHeight));
                });
              }
            },
            //linkUrl: null,
            //isIconText: true,
          ),
          CretaMenuItem(
            caption: CretaCommuLang['teamChannel'],
            //iconData: null,
            index: CommunityChannelType.memberChannels.index,
            onPressed: () {
              if (_communityChannelType != CommunityChannelType.memberChannels) {
                setState(() {
                  _communityChannelType = CommunityChannelType.memberChannels;
                  for (var menuItem in _rightTabMenuList) {
                    menuItem.selected =
                        (menuItem.index == CommunityChannelType.memberChannels.index);
                    if (menuItem.selected) {
                      if (kDebugMode) {
                        print('pressed CommunityChannelType.books (${menuItem.index})');
                      }
                    }
                  }
                  if (CommunityRightChannelPane.lastDropdownMenuCount > 0) {
                    setBannerHeight = getBannerHeight - 36;
                  }
                  double bannerHeight = 436 + 64 - getBannerHeight;
                  setBannerScrollController(ScrollController(initialScrollOffset: bannerHeight));
                });
              }
            },
            //linkUrl: null,
            //isIconText: true,
          ),
          CretaMenuItem(
            caption: CretaCommuLang['information'],
            //iconData: null,
            index: CommunityChannelType.info.index,
            onPressed: () {
              if (_communityChannelType != CommunityChannelType.info) {
                setState(() {
                  _communityChannelType = CommunityChannelType.info;
                  for (var menuItem in _rightTabMenuList) {
                    menuItem.selected = (menuItem.index == CommunityChannelType.info.index);
                    if (menuItem.selected) {
                      if (kDebugMode) {
                        print('pressed CommunityChannelType.books (${menuItem.index})');
                      }
                    }
                  }
                  if (CommunityRightChannelPane.lastDropdownMenuCount > 0) {
                    setBannerHeight = getBannerHeight - 36;
                  }
                  double bannerHeight = 436 + 64 - getBannerHeight;
                  setBannerScrollController(ScrollController(initialScrollOffset: bannerHeight));
                });
              }
            },
            //linkUrl: null,
            //isIconText: true,
          ),
        ];
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
        _rightTabMenuList = [];
        break;
      case AppRoutes.watchHistory:
        _leftMenuItemList[2].selected = true;
        _leftMenuItemList[2].onPressed = () {};
        _leftMenuItemList[2].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        _rightTabMenuList = [];
        break;
      case AppRoutes.favorites:
        _leftMenuItemList[3].selected = true;
        _leftMenuItemList[3].onPressed = () {};
        _leftMenuItemList[3].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        _rightTabMenuList = [];
        break;
      case AppRoutes.playlist:
        _leftMenuItemList[4].selected = true;
        _leftMenuItemList[4].onPressed = () {};
        _leftMenuItemList[4].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
        );
        _rightTabMenuList = [];
        break;
      case AppRoutes.playlistDetail:
        _leftMenuItemList[4].selected = true;
        _leftMenuItemList[4].onPressed = () {};
        _leftMenuItemList[4].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          bannerMinHeight: 140,
          bannerMaxHeight: 140,
        );
        _rightTabMenuList = [];
        break;
      case AppRoutes.communityBook:
        // _leftMenuItemList[4].selected = true;
        // _leftMenuItemList[4].onPressed = () {};
        // _leftMenuItemList[4].linkUrl = null;
        _titlePane = _getTitlePane;
        setUsingBannerScrollBar(
          scrollChangedCallback: _scrollChangedCallback,
          bannerMinHeight: 140,
          bannerMaxHeight: 140,
        );
        _rightTabMenuList = [];
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
        _rightTabMenuList = [];
        break;
    }
  }

  List<Widget> _getHashtagListOnBanner() {
    return [
      BTN.opacity_gray_it_s(
        text: CretaCommuLang['hashtagCreta'],
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
        sidePadding: CretaButtonSidePadding.fromLR(0, 8),
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: CretaCommuLang['hashtagRecommend'],
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
        sidePadding: CretaButtonSidePadding.fromLR(0, 8),
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: CretaCommuLang['hashtagPopular'],
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
        sidePadding: CretaButtonSidePadding.fromLR(0, 8),
      ),
      SizedBox(width: 12),
      BTN.opacity_gray_it_s(
        text: CretaCommuLang['hashtag'],
        textStyle: CretaFont.buttonMedium.copyWith(color: Colors.white),
        width: null,
        onPressed: () {},
        decoType: CretaButtonDeco.opacity,
        sidePadding: CretaButtonSidePadding.fromLR(0, 8),
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
            CretaCommuLang['commuHome']!,
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
            CretaCommuLang['exploreCretaBooks'],
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              height: 0.9,
              //fontWeight: CretaFont.regular,
            ),
          ),
          SizedBox(height: 13),
          Text(
            CretaCommuLang['watchCretaBooks'],
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              height: 0.9,
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
            // CustomImage(
            //   key: CommunitySampleData.bannerKey,
            //   duration: 500,
            //   hasMouseOverEffect: false,
            //   width: size.width,
            //   height: size.height,
            //   image: CommunitySampleData.bannerUrl,
            //   hasAni: false,
            // ),
            Image(
              image: AssetImage('assets/Artboard12.png'),
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
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
            CretaCommuLang['commuHome']!,
            overflow: TextOverflow.ellipsis,
            style: CretaFont.displaySmall.copyWith(
              color: Colors.white,
              fontWeight: CretaFont.semiBold,
              height: 0.9,
            ),
          ),
        );
      }
      if (size.width > 800) {
        titleList.addAll([
          SizedBox(height: 23),
          Text(
            CretaCommuLang['exploreCretaBooks'],
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              height: 0.9,
              //fontWeight: CretaFont.regular,
            ),
          ),
          SizedBox(height: 13),
          Text(
            CretaCommuLang['watchCretaBooks'],
            overflow: TextOverflow.ellipsis,
            style: CretaFont.bodyMedium.copyWith(
              color: Colors.white,
              fontSize: 16,
              height: 0.9,
              //fontWeight: CretaFont.regular,
            ),
          ),
        ]);
      }
      Widget hashtagWidget =
          (size.width > 630) ? Row(children: _getHashtagListOnBanner()) : Container();
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
            //   hasAni: false,
            // ),
            Image(
              image: AssetImage('assets/Artboard12.png'),
              width: size.width,
              height: size.height,
              fit: BoxFit.cover,
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
          CretaCommuLang['commuHome']!,
          style: CretaFont.titleELarge.copyWith(
            fontWeight: CretaFont.semiBold,
            height: 0.9,
          ),
        ),
      ]);
    }
    if (size.width > 885) {
      titleList.addAll([
        SizedBox(width: 24),
        //text
        Text(
          CretaCommuLang['exploreCretaBooks'],
          overflow: TextOverflow.ellipsis,
          style: CretaFont.bodyMedium.copyWith(
            fontWeight: CretaFont.regular,
            height: 0.9,
          ),
        ),
      ]);
    }
    if (size.width > 540) {
      titleList.addAll([
        Expanded(child: Container()),
        Row(children: _getHashtagListOnBanner()),
      ]);
    }
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          Image(
            image: AssetImage('assets/Artboard12.png'),
            width: size.width,
            height: size.height,
            fit: BoxFit.cover,
          ),
          Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Row(children: titleList),
          ),
        ],
      ),
    );
  }

  Widget _getChannelTitlePane(Size size) {
    if (_currentChannelModel == null) {
      return SizedBox(
        width: size.width,
        height: size.height,
      );
    }
    String profileImg = _currentChannelModel?.profileImg ?? '';
    String channelBannerImg = _currentChannelModel?.bannerImgUrl ?? '';
    Widget? bannerImage;
    if (_currentChannelModel == null) {
      bannerImage = SizedBox.shrink();
    } else if (channelBannerImg.isEmpty) {
      bannerImage = Image(
        image: AssetImage('assets/Artboard12.png'),
        width: size.width,
        height: size.height,
        fit: BoxFit.cover,
      );
    } else {
      bannerImage = CustomImage(
        key: GlobalObjectKey(channelBannerImg),
        image: channelBannerImg,
        width: size.width,
        height: size.height,
        hasMouseOverEffect: false,
        hasAni: false,
        boxFit: BoxFit.cover,
      );
    }
    String titleKey = (_currentChannelModel == null)
        ? '_getChannelTitlePane(_currentChannelModel == null)'
        : channelBannerImg.isEmpty
            ? '_getChannelTitlePane(AssetImage)'
            : '_getChannelTitlePane($channelBannerImg)';
    // max size
    if (size.height > 100 + 100 + 24 + 8) {
      return Stack(
        key: GlobalObjectKey(titleKey),
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: bannerImage,
            // child: (_currentChannelModel == null)
            //     ? SizedBox.shrink()
            //     : channelBannerImg.isEmpty
            //         ? Image(
            //             image: AssetImage('assets/Artboard12.png'),
            //             width: size.width,
            //             height: size.height,
            //             fit: BoxFit.cover,
            //           )
            //         : CustomImage(
            //             key: GlobalObjectKey(channelBannerImg),
            //             image: channelBannerImg,
            //             width: size.width,
            //             height: size.height,
            //             hasMouseOverEffect: false,
            //             hasAni: false,
            //             boxFit: BoxFit.cover,
            //           ),
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
                        child: (_currentChannelModel == null)
                            ? SizedBox.shrink()
                            : profileImg.isEmpty
                                ? CretaAccountManager.userPropertyManagerHolder.imageCircle(
                                    profileImg,
                                    CretaAccountManager.getUserProperty?.nickname ?? '',
                                    radius: 100,
                                  )
                                : CustomImage(
                                    key: GlobalObjectKey(profileImg),
                                    image: profileImg,
                                    width: 100,
                                    height: 100,
                                    hasMouseOverEffect: false,
                                    hasAni: false,
                                  ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Text(
                            (_currentChannelModel == null)
                                ? ''
                                : '${_currentChannelModel!.name}${CretaCommuLang['channelOfUser']}',
                            overflow: TextOverflow.ellipsis,
                            style: CretaFont.displaySmall.copyWith(
                              color: CretaColor.text[700],
                              fontWeight: CretaFont.semiBold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Opacity(
                            opacity: 0.25,
                            child: BTN.fill_gray_i_l(
                              icon: Icons.link_outlined,
                              buttonColor: CretaButtonColor.gray100light,
                              iconColor: CretaColor.text[700],
                              tooltip: CretaCommuLang['copyChannelAddress'],
                              onPressed: () {
                                String url = Uri.base.origin;
                                url +=
                                    '${AppRoutes.channel}?${CommunityRightChannelPane.channelId}';
                                Clipboard.setData(ClipboardData(text: url));
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      Row(
                        children: [
                          if (_currentChannelModel != null &&
                              _currentChannelModel!.teamId.isNotEmpty)
                            Text(
                              '${_currentChannelModel!.name} + ${_currentChannelModel!.followerCount}${CretaCommuLang['people']}',
                              overflow: TextOverflow.ellipsis,
                              style: CretaFont.buttonLarge.copyWith(
                                color: CretaColor.text[400],
                                //fontSize: 16,
                                fontWeight: CretaFont.medium,
                              ),
                            ),
                          // SizedBox(width: 20), // => 기획 회의중 제거 결론 (23-07-27)
                          // Text(
                          //   '구독중 453명',
                          //   overflow: TextOverflow.ellipsis,
                          //   style: CretaFont.buttonLarge.copyWith(
                          //     color: CretaColor.text[400],
                          //     //fontSize: 16,
                          //     fontWeight: CretaFont.medium,
                          //   ),
                          // ),
                          if (_currentChannelModel != null &&
                              _currentChannelModel!.teamId.isNotEmpty)
                            SizedBox(width: 20),
                          Text(
                            (_currentChannelModel == null)
                                ? ''
                                : '${CretaCommuLang['subscribers']} ${_currentChannelModel!.followerCount}',
                            overflow: TextOverflow.ellipsis,
                            style: CretaFont.buttonLarge.copyWith(
                              color: CretaColor.text[400],
                              //fontSize: 16,
                              fontWeight: CretaFont.medium,
                            ),
                          ),
                          SizedBox(width: 12),
                          (CretaAccountManager.getUserProperty?.channelId ==
                                  _currentChannelModel?.getMid)
                              ? SizedBox.shrink()
                              : BTN.fill_blue_t_m(
                                  width: 84,
                                  text: (_selectedSubscriptionModel == null)
                                      ? CretaCommuLang['subscribe']
                                      : CretaCommuLang['subscribing'],
                                  onPressed: () {
                                    SubscriptionManager subscriptionManagerHolder =
                                        SubscriptionManager();
                                    if (_selectedSubscriptionModel == null) {
                                      subscriptionManagerHolder
                                          .createSubscription(
                                        CretaAccountManager.getUserProperty!.channelId,
                                        _currentChannelModel!.getMid,
                                      )
                                          .then(
                                        (value) {
                                          showSnackBar(context, CretaCommuLang['subscribed']);
                                          setState(() {
                                            _selectedSubscriptionModel = SubscriptionModel.withName(
                                                channelId:
                                                    CretaAccountManager.getUserProperty!.channelId,
                                                subscriptionChannelId:
                                                    _currentChannelModel!.getMid);
                                          });
                                        },
                                      );
                                    } else {
                                      subscriptionManagerHolder
                                          .removeSubscription(
                                        CretaAccountManager.getUserProperty!.channelId,
                                        _currentChannelModel!.mid,
                                      )
                                          .then(
                                        (value) {
                                          showSnackBar(context, CretaCommuLang['unsubscribed']);
                                          setState(() {
                                            _selectedSubscriptionModel = null;
                                          });
                                        },
                                      );
                                    }
                                  },
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
      );
    } else if (size.height > 122 + 40) {
      // mid size
      // return SizedBox(
      // key: GlobalObjectKey(titleKey),
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
      //                         CretaCommuLang['commuHome']!,
      //                         style: CretaFont.displaySmall.copyWith(
      //                           color: Colors.white,
      //                           fontWeight: CretaFont.semiBold,
      //                         ),
      //                       ),
      //                       SizedBox(height: 23),
      //                       Text(
      //                         CretaCommuLang['exploreCretaBooks'],
      //                         overflow: TextOverflow.ellipsis,
      //                         style: CretaFont.bodyMedium.copyWith(
      //                           color: Colors.white,
      //                           fontSize: 16,
      //                           //fontWeight: CretaFont.regular,
      //                         ),
      //                       ),
      //                       SizedBox(height: 13),
      //                       Text(
      //                         CretaCommuLang['watchCretaBooks'],
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
    return SizedBox(
      key: GlobalObjectKey(titleKey),
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          SizedBox(
            width: size.width,
            height: size.height,
            child: bannerImage,
            // child: (_currentChannelModel == null)
            //     ? SizedBox.shrink()
            //     : channelBannerImg.isEmpty
            //         ? Image(
            //             image: AssetImage('assets/Artboard12.png'),
            //             width: size.width,
            //             height: size.height,
            //             fit: BoxFit.cover,
            //           )
            //         : CustomImage(
            //             key: GlobalObjectKey(channelBannerImg),
            //             image: channelBannerImg,
            //             width: size.width,
            //             height: size.height,
            //             hasMouseOverEffect: false,
            //             hasAni: false,
            //             boxFit: BoxFit.cover,
            //           ),
          ),
          Container(
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
                      // child: CustomImage(
                      //   key: CommunitySampleData.bannerKey,
                      //   duration: 500,
                      //   hasMouseOverEffect: false,
                      //   width: 32,
                      //   height: 32,
                      //   image: CommunitySampleData.bannerUrl,
                      //   hasAni: false,
                      // ),
                      child: profileImg.isEmpty
                          ? Image(
                              image: AssetImage('assets/Artboard12.png'),
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                            )
                          : CustomImage(
                              key: GlobalObjectKey(profileImg),
                              image: profileImg,
                              width: 32,
                              height: 32,
                              hasMouseOverEffect: false,
                              hasAni: false,
                            ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      (_currentChannelModel == null)
                          ? ''
                          : '${_currentChannelModel!.name} ${CretaCommuLang["channelOfUser"]}',
                      style: CretaFont.titleELarge
                          .copyWith(color: CretaColor.text[700], fontWeight: CretaFont.semiBold),
                    ),
                    SizedBox(width: 20),
                    Text(
                      (_currentChannelModel == null)
                          ? ''
                          : '${_currentChannelModel!.name} + ${_currentChannelModel!.followerCount}${CretaCommuLang['people']}',
                      style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
                    ),
                    SizedBox(width: 20),
                    BTN.fill_gray_i_l(
                      icon: Icons.link_outlined,
                      buttonColor: CretaButtonColor.gray100light,
                      iconColor: CretaColor.text[700],
                      tooltip: CretaCommuLang['copyChannelAddress'],
                      onPressed: () {
                        String url = Uri.base.origin;
                        url += '${AppRoutes.channel}?${CommunityRightChannelPane.channelId}';
                        Clipboard.setData(ClipboardData(text: url));
                      },
                    ),
                  ],
                ),
                // right (follow + icon)
                Row(
                  children: [
                    Text(
                      (_currentChannelModel == null)
                          ? ''
                          : '${CretaCommuLang['subscribers']} ${_currentChannelModel!.followerCount}${CretaCommuLang['people']}',
                      style: CretaFont.buttonLarge.copyWith(color: CretaColor.text[400]),
                    ),
                    SizedBox(width: 12),
                    (CretaAccountManager.getUserProperty?.channelId == _currentChannelModel?.getMid)
                        ? SizedBox.shrink()
                        : BTN.fill_blue_t_m(
                            width: 84,
                            text: (_selectedSubscriptionModel == null)
                                ? CretaCommuLang['subscribe']
                                : CretaCommuLang['subscribing'],
                            onPressed: () {
                              SubscriptionManager subscriptionManagerHolder = SubscriptionManager();
                              if (_selectedSubscriptionModel == null) {
                                subscriptionManagerHolder
                                    .createSubscription(
                                  CretaAccountManager.getUserProperty!.channelId,
                                  _currentChannelModel!.getMid,
                                )
                                    .then(
                                  (value) {
                                    showSnackBar(context, CretaCommuLang['subscribed']);
                                    setState(() {
                                      _selectedSubscriptionModel = SubscriptionModel.withName(
                                          channelId: CretaAccountManager.getUserProperty!.channelId,
                                          subscriptionChannelId: _currentChannelModel!.getMid);
                                    });
                                  },
                                );
                              } else {
                                subscriptionManagerHolder
                                    .removeSubscription(
                                  CretaAccountManager.getUserProperty!.channelId,
                                  _currentChannelModel!.mid,
                                )
                                    .then(
                                  (value) {
                                    showSnackBar(context, CretaCommuLang['unsubscribed']);
                                    setState(() {
                                      _selectedSubscriptionModel = null;
                                    });
                                  },
                                );
                              }
                            },
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
  }

  void _toggleBookToFavorites() async {
    if (_bookIsFavorites) {
      favoritesManagerHolder.removeFavoritesFromDB(
        _currentBookModel!.mid,
        AccountManager.currentLoginUser.email,
      );
      setState(() {
        _bookIsFavorites = false;
      });
    } else {
      favoritesManagerHolder.addFavoritesToDB(
        _currentBookModel!.mid,
        AccountManager.currentLoginUser.email,
      );
      setState(() {
        _bookIsFavorites = true;
      });
    }
  }

  Widget _getCommunityBookTitlePane(Size size) {
    final GlobalKey menuButtonKey =
        GlobalObjectKey('_getCommunityBookTitlePane.BTN.fill_gray_i_l.CretaPopupMenu.showMenu');
    final String channelLinkUrl =
        '${AppRoutes.channel}?${_userPropertyModelOfBookModel?.channelId}';
    return Container(
      width: size.width - LayoutConst.cretaScrollbarWidth,
      height: 140, //size.height,
      padding: EdgeInsets.fromLTRB(40, 40, 40 - LayoutConst.cretaScrollbarWidth, 20),
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(7.6),
          boxShadow: StudioSnippet.fullShadow(),
        ),
        clipBehavior: Clip.antiAlias,
        padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: (_currentBookModel == null)
            ? SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            _currentBookModel!.name.value,
                            overflow: TextOverflow.ellipsis,
                            style: CretaFont.titleELarge.copyWith(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20),
                        Link(
                            uri: Uri.parse(channelLinkUrl),
                            builder: (context, function) {
                              return BTN.fill_gray_it_m(
                                text: _userPropertyModelOfBookModel?.nickname ?? '',
                                icon: Icons.account_circle,
                                onPressed: () {
                                  if (_userPropertyModelOfBookModel != null) {
                                    Routemaster.of(context).push(channelLinkUrl);
                                  }
                                },
                                width: null,
                                buttonColor: CretaButtonColor.transparent,
                                textColor: Colors.white,
                                textStyle: CretaFont.bodyMedium.copyWith(color: Colors.white),
                                alwaysShowIcon: true,
                              );
                            }),
                        SizedBox(width: 20),
                        Text(
                          CretaCommonUtils.dateToDurationString(_currentBookModel!.updateTime),
                          style: CretaFont.bodyMedium.copyWith(color: Colors.white),
                        ),
                        SizedBox(width: 20),
                        Text(
                          '${CretaCommuLang['views']} ${_currentBookModel!.viewCount}회',
                          style: CretaFont.bodyMedium.copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Row(
                    children: [
                      if (_currentBookModel!.isEditable)
                        BTN.fill_gray_i_l(
                          icon: Icons.edit_outlined,
                          onPressed: () {},
                          buttonColor: CretaButtonColor.blueAndWhiteTitle,
                          iconColor: Colors.white,
                        ),
                      if (_currentBookModel!.isEditable) SizedBox(width: 12),
                      if (AccountManager.currentLoginUser.isLoginedUser)
                        BTN.fill_gray_it_l(
                          icon: _bookIsFavorites
                              ? Icons.favorite_outlined
                              : Icons.favorite_border_outlined,
                          text: '${_currentBookModel!.likeCount}',
                          onPressed: _toggleBookToFavorites,
                          buttonColor: CretaButtonColor.transparent,
                          textColor: Colors.white,
                          width: null,
                          sidePadding: CretaButtonSidePadding.fromLR(8, 8),
                        ),
                      if (AccountManager.currentLoginUser.isLoginedUser) SizedBox(width: 13),
                      if (_currentBookModel!.isCopyable)
                        BTN.fill_gray_itt_l(
                          icon: Icons.copy_rounded,
                          text: CretaCommuLang['createCopy'],
                          subText: '${_currentBookModel!.copyCount}',
                          onPressed: () {
                            if (_currentBookModel != null) {
                              final BookManager copyBookManagerHolder = BookManager();
                              copyBookManagerHolder
                                  .makeClone(
                                _currentBookModel!,
                                srcIsPublishedBook: true,
                                cloneToPublishedBook: false,
                              )
                                  .then((newBook) {
                                if (newBook == null) {
                                  showSnackBar(context, CretaCommuLang['copyCreationFailed']);
                                } else {
                                  showSnackBar(context,
                                      '${newBook.name.value}${CretaCommuLang['createdSuccessfully']}');
                                }
                              }).catchError((error, stackTrace) {
                                showSnackBar(context, CretaCommuLang['copyCreationFailed']);
                              });
                            }
                          },
                          buttonColor: CretaButtonColor.skyTitle,
                          textColor: Colors.white,
                          subTextColor: CretaColor.primary[200],
                          width: null,
                          sidePadding: CretaButtonSidePadding.fromLR(8, 0),
                        ),
                      if (_currentBookModel!.isCopyable) SizedBox(width: 12),
                      BTN.fill_gray_i_l(
                        key: menuButtonKey,
                        icon: Icons.menu_outlined,
                        onPressed: () {
                          CretaPopupMenu.showMenu(
                            context: context,
                            globalKey: menuButtonKey,
                            xOffset: -100,
                            width: 160,
                            popupMenu: [
                              //CretaMenuItem(caption: CretaCommuLang['play'], onPressed: () {}),
                              if (_currentBookModel!.isEditable)
                                CretaMenuItem(
                                  caption: CretaCommuLang['edit'],
                                  onPressed: () {
                                    String url =
                                        '${AppRoutes.studioBookMainPage}?${_currentBookModel?.sourceMid}';
                                    //Routemaster.of(context).push(url);
                                    AppRoutes.launchTab(url);
                                  },
                                ),
                              if (AccountManager.currentLoginUser.isLoginedUser)
                                CretaMenuItem(
                                  caption: CretaCommuLang['broadcast'] ?? 'Broadcast',
                                  onPressed: () {
                                    HostUtil.broadCast(context, hostManagerHolder,
                                        _currentBookModel!.mid, _currentBookModel!.name.value);
                                  },
                                ),
                              if (AccountManager.currentLoginUser.isLoginedUser)
                                CretaMenuItem(
                                  caption: CretaCommuLang['addToPlaylist'],
                                  onPressed: () {
                                    _addToPlaylist?.call();
                                  },
                                ),
                              CretaMenuItem(caption: CretaCommuLang['share'], onPressed: () {}),
                              if (AccountManager.currentLoginUser.isLoginedUser)
                                CretaMenuItem(
                                    caption: CretaCommuLang['download'], onPressed: () {}),
                              if (_currentBookModel!.isEditable)
                                CretaMenuItem(caption: CretaCommuLang['delete'], onPressed: () {}),
                              if (_currentBookModel!.isCopyable)
                                CretaMenuItem(
                                    caption: CretaCommuLang['createCopy'], onPressed: () {}),
                              if (AccountManager.currentLoginUser.isLoginedUser)
                                CretaMenuItem(
                                  caption: CretaCommuLang['copyFullScreenAddress'],
                                  onPressed: () {
                                    String url = Uri.base.origin;
                                    url +=
                                        '${AppRoutes.studioBookPreviewPage}?${CommunityRightBookPane.bookId}&mode=preview';
                                    Clipboard.setData(ClipboardData(text: url));
                                  },
                                ),
                            ],
                            initFunc: () {},
                          ).then((value) {
                            //logger.finest('팝업메뉴 닫기');
                          });
                        },
                        buttonColor: CretaButtonColor.transparent,
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
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
                        style: CretaFont.titleELarge.copyWith(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                        // TextStyle(
                        //   fontWeight: FontWeight.w600,
                        //   fontSize: 22,
                        //   color: Colors.grey[800],
                        //   fontFamily: 'Pretendard',
                        // ),
                      ),
                    ),
              (descriptionText == null)
                  ? SizedBox.shrink()
                  : Text(
                      descriptionText,
                      style: CretaFont.titleSmall.copyWith(
                        color: Colors.grey[700],
                      ),
                      // TextStyle(
                      //   fontSize: 16,
                      //   color: Colors.grey[700],
                      //   fontFamily: 'Pretendard',
                      // ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getTitlePane(Size size) {
    final String playDetailLinkUrl = ((_currentPlaylistModel?.bookIdList ?? []).isEmpty)
        ? ''
        : '${AppRoutes.communityBook}?${_currentPlaylistModel!.bookIdList[0]}&${_currentPlaylistModel!.getMid}';
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        return _getChannelTitlePane(size);
      case AppRoutes.subscriptionList:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.local_library_outlined,
          titleText: CretaCommuLang['subsList']!,
          descriptionText:
              '${AccountManager.currentLoginUser.name}${CretaCommuLang["contentForUser"]}',
        );
      case AppRoutes.watchHistory:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.article_outlined,
          titleText: CretaCommuLang['watchHistory']!,
          descriptionText:
              '${AccountManager.currentLoginUser.name}${CretaCommuLang["recentlyWatched"]}',
        );
      case AppRoutes.favorites:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.favorite_outline,
          titleText: CretaCommuLang['iLikeIt']!,
          descriptionText:
              '${AccountManager.currentLoginUser.name}${CretaCommuLang["likedCretaBooks"]}',
        );
      case AppRoutes.playlist:
        return _getSmallTitlePane(
          size: size,
          headIcon: Icons.playlist_play,
          titleText: CretaCommuLang['playList']!,
          descriptionText:
              '${AccountManager.currentLoginUser.name}${CretaCommuLang["userPlaylists"]}',
        );
      case AppRoutes.playlistDetail:
        return Container(
          width: size.width - LayoutConst.cretaScrollbarWidth,
          height: 140, //size.height,
          padding: EdgeInsets.fromLTRB(40, 40, 40 - LayoutConst.cretaScrollbarWidth, 20),
          color: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(7.6),
              boxShadow: StudioSnippet.fullShadow(),
            ),
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: (_currentPlaylistModel == null)
                  ? []
                  : [
                      Row(
                        children: [
                          Text(
                            _currentPlaylistModel!.name,
                            style: CretaFont.titleELarge.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                            ),
                            // TextStyle(
                            //   fontWeight: FontWeight.w600,
                            //   fontSize: 22,
                            //   color: Colors.grey[800],
                            //   fontFamily: 'Pretendard',
                            // ),
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
                            '${CretaCommuLang["videoCount"]} ${_currentPlaylistModel!.bookIdList.length}',
                            style: CretaFont.buttonMedium,
                          ),
                          SizedBox(width: 28),
                          Text(
                            //'최근 업데이트 ${CretaCommonUtils.dateToDurationString(_currentPlaylistModel!.lastUpdateTime)}',
                            '${CretaCommuLang["recentUpdates"]} ${CretaCommonUtils.dateToDurationString(_currentPlaylistModel!.updateTime)}',
                            style: CretaFont.buttonMedium,
                          ),
                          Expanded(child: Container()),
                          Link(
                            uri: Uri.parse(playDetailLinkUrl),
                            builder: (context, function) {
                              return BTN.fill_blue_t_m(
                                width: null,
                                text: CretaCommuLang['play'],
                                textStyle: CretaFont.buttonLarge.copyWith(color: Colors.white),
                                onPressed: () {
                                  if (playDetailLinkUrl.isNotEmpty) {
                                    Routemaster.of(context).push(playDetailLinkUrl);
                                  }
                                },
                              );
                            },
                          ),
                          SizedBox(width: 6),
                          BTN.fill_gray_i_m(icon: Icons.menu, onPressed: () {}),
                        ],
                      ),
                    ],
            ),
          ),
        );
      case AppRoutes.communityBook:
        return _getCommunityBookTitlePane(size);
      case AppRoutes.communityHome:
      default:
        return _getCommunityHomeTitlePane(size);
    }
  }

  List<List<CretaMenuItem>> _getLeftDropdownMenuOnBanner() {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return [
          _dropDownMenuItemListPurpose,
          _dropDownMenuItemListPermission,
          _dropDownMenuItemListSort
        ];
      case AppRoutes.watchHistory:
        return [
          // _dropDownMenuItemListPurpose,
          // _dropDownMenuItemListPermission,
          // _dropDownMenuItemListSort
        ];
      case AppRoutes.favorites:
        return [
          // _dropDownMenuItemListPurpose,
          // _dropDownMenuItemListPermission,
          // _dropDownMenuItemListSort
        ];
      case AppRoutes.playlist:
        return [_dropDownMenuItemListSort];
      case AppRoutes.playlistDetail:
      case AppRoutes.communityBook:
        break;
      case AppRoutes.communityHome:
      case AppRoutes.channel:
        switch (_communityChannelType) {
          case CommunityChannelType.playlists:
            return [_dropDownMenuItemListSort];
          case CommunityChannelType.memberChannels:
            return [];
          case CommunityChannelType.info:
            return [];
          case CommunityChannelType.books:
          default:
            return [
              _dropDownMenuItemListPurpose,
              _dropDownMenuItemListPermission,
              _dropDownMenuItemListSort
            ];
        }
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
      case AppRoutes.communityBook:
        break;
      case AppRoutes.communityHome:
        break;
      case AppRoutes.channel:
        break;
      //return [_dropDownMenuItemListSort];
    }
    return null;
  }

  void _getSearchFunction(String value) {
    switch (widget.subPageUrl) {
      case AppRoutes.subscriptionList:
        return;
      case AppRoutes.watchHistory:
        return;
      case AppRoutes.favorites:
        return;
      case AppRoutes.playlist:
        return;
      case AppRoutes.playlistDetail:
        return;
      case AppRoutes.communityHome:
        setState(() {
          _filterSearchKeyword = value;
          _filterSearchKeywordTime = DateTime.now();
          setScrollOffset(0);
        });
        return;

      case AppRoutes.channel:
        switch (_communityChannelType) {
          case CommunityChannelType.books:
            return;
          case CommunityChannelType.playlists:
            return;
          default:
            break;
        }
        break;
      default:
        break;
    }
  }

  GlobalObjectKey _getRightPaneKey() {
    String key = '';
    if (widget.subPageUrl == AppRoutes.channel) {
      //'${widget.subPageUrl}-$_selectedSubscriptionUserId-${_filterBookType.name}-${_filterBookSort.name}-${_filterPermissionType.name}';
      key =
          '${CretaAccountManager.currentLoginUser.email}|${Uri.base.query}|${_currentChannelModel?.getMid ?? ''}|${_communityChannelType.name}|${_subscriptionModelList?.length ?? -1}|${_filterBookType.name}|${_filterBookSort.name}|${_filterPermissionType.name}|$_filterSearchKeyword|${_filterSearchKeywordTime.toIso8601String()}';
    } else if (widget.subPageUrl == AppRoutes.communityBook) {
      key =
          '${CretaAccountManager.currentLoginUser.email}|${CommunityRightBookPane.bookId}|${_subscriptionModelList?.length ?? -1}|${_selectedSubscriptionModel?.subscriptionChannelId ?? ''}|${_filterBookType.name}|${_filterBookSort.name}|${_filterPermissionType.name}|$_filterSearchKeyword|${_filterSearchKeywordTime.toIso8601String()}';
    } else {
      key =
          '${CretaAccountManager.currentLoginUser.email}|${Uri.base.query}|${_subscriptionModelList?.length ?? -1}|${_selectedSubscriptionModel?.subscriptionChannelId ?? ''}|${_filterBookType.name}|${_filterBookSort.name}|${_filterPermissionType.name}|$_filterSearchKeyword|${_filterSearchKeywordTime.toIso8601String()}';
    }
    if (kDebugMode) print('_getRightPaneKey = $key');
    return GlobalObjectKey(key);
  }

  void _updatePlaylistModel(PlaylistModel playlistModel) {
    setState(() {
      _currentPlaylistModel = playlistModel;
    });
  }

  void _onUpdateBookModel(
    BookModel bookModel,
    UserPropertyModel userPropertyModel,
    bool isFavorites,
    Function addToPlaylist,
  ) {
    setState(() {
      _currentBookModel = bookModel;
      _userPropertyModelOfBookModel = userPropertyModel;
      _bookIsFavorites = isFavorites;
      _addToPlaylist = addToPlaylist;
    });
  }

  void _onUpdateModel({ChannelModel? channelModel, SubscriptionModel? subscriptionModel}) {
    setState(() {
      _currentChannelModel = channelModel;
      _selectedSubscriptionModel = subscriptionModel;
    });
  }

  void _onUpdateSubscriptionModelList(List<SubscriptionModel> subscriptionList) {
    if (kDebugMode) print('_onUpdateSubscriptionModelList=${subscriptionList.length}');
    setState(() {
      _subscriptionModelList = [...subscriptionList];
      _selectedSubscriptionModel = _subscriptionModelList?[0];
    });
  }

  Widget _getRightPane(BuildContext context) {
    //Size size = Size(rightPaneRect.childWidth, rightPaneRect.childHeight);
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        switch (_communityChannelType) {
          case CommunityChannelType.playlists:
            return CommunityRightChannelPlaylistPane(
              key: _getRightPaneKey(),
              cretaLayoutRect: rightPaneRect,
              scrollController: getBannerScrollController,
              filterBookType: _filterBookType,
              filterBookSort: _filterBookSort,
              filterPermissionType: _filterPermissionType,
              filterSearchKeyword: _filterSearchKeyword,
              onUpdateModel: _onUpdateModel,
              currentChannelModel: _currentChannelModel,
            );
          case CommunityChannelType.memberChannels:
            return CommunityRightChannelMembersPane(
              key: _getRightPaneKey(),
              cretaLayoutRect: rightPaneRect,
              scrollController: getBannerScrollController,
              filterBookType: _filterBookType,
              filterBookSort: _filterBookSort,
              filterPermissionType: _filterPermissionType,
              filterSearchKeyword: _filterSearchKeyword,
              onUpdateModel: _onUpdateModel,
              currentChannelModel: _currentChannelModel,
            );
          case CommunityChannelType.info:
            return CommunityRightChannelInfoPane(
              key: _getRightPaneKey(),
              cretaLayoutRect: rightPaneRect,
              scrollController: getBannerScrollController,
              filterBookType: _filterBookType,
              filterBookSort: _filterBookSort,
              filterPermissionType: _filterPermissionType,
              filterSearchKeyword: _filterSearchKeyword,
              onUpdateModel: _onUpdateModel,
              currentChannelModel: _currentChannelModel,
            );
          case CommunityChannelType.books:
          default:
            return CommunityRightChannelPane(
              key: _getRightPaneKey(),
              cretaLayoutRect: rightPaneRect,
              scrollController: getBannerScrollController,
              filterBookType: _filterBookType,
              filterBookSort: _filterBookSort,
              filterPermissionType: _filterPermissionType,
              filterSearchKeyword: _filterSearchKeyword,
              onUpdateModel: _onUpdateModel,
              currentChannelModel: _currentChannelModel,
              currentSubscriptionModel: _selectedSubscriptionModel,
            );
        }
      case AppRoutes.subscriptionList:
        return CommunityRightSubscriptionPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          subscriptionModelList: _subscriptionModelList,
          selectedSubscriptionModel: _selectedSubscriptionModel,
          onUpdateSubscriptionModelList: _onUpdateSubscriptionModelList,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          filterSearchKeyword: _filterSearchKeyword,
        );
      case AppRoutes.watchHistory:
        return CommunityRightWatchHistoryPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          filterSearchKeyword: _filterSearchKeyword,
        );
      case AppRoutes.favorites:
        return CommunityRightFavoritesPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          filterSearchKeyword: _filterSearchKeyword,
        );
      case AppRoutes.playlist:
        return CommunityRightPlaylistPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          filterSearchKeyword: _filterSearchKeyword,
        );
      case AppRoutes.playlistDetail:
        return CommunityRightPlaylistDetailPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          updatePlaylistModel: _updatePlaylistModel,
        );
      case AppRoutes.communityBook:
        return CommunityRightBookPane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          onUpdateBookModel: _onUpdateBookModel,
        );
      case AppRoutes.communityHome:
      default:
        return CommunityRightHomePane(
          key: _getRightPaneKey(),
          cretaLayoutRect: rightPaneRect,
          scrollController: getBannerScrollController,
          filterBookType: _filterBookType,
          filterBookSort: _filterBookSort,
          filterPermissionType: _filterPermissionType,
          filterSearchKeyword: _filterSearchKeyword,
        );
    }
  }

  Widget _getRightOverlayPane() {
    switch (widget.subPageUrl) {
      case AppRoutes.channel:
        break;
      case AppRoutes.subscriptionList:
        return Positioned(
          left: 310 + 40,
          top: 140, //196 - 40 - 20 + 4,
          child: Container(
            width: 286,
            height: rightPaneRect.childHeight + 102,
            padding: EdgeInsets.fromLTRB(20, 20, 5, 20),
            decoration: BoxDecoration(
              color: CretaColor.text[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Scrollbar(
              //thumbVisibility: true,
              controller: _rightOverlayPaneScrollController,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                controller: _rightOverlayPaneScrollController,
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 20,
                  runSpacing: 20,
                  children: _getSubscriptionList(),
                ),
              ),
            ),
          ),
        );
      case AppRoutes.watchHistory:
      case AppRoutes.favorites:
      case AppRoutes.playlist:
      case AppRoutes.playlistDetail:
      case AppRoutes.communityBook:
      case AppRoutes.communityHome:
      default:
        break;
    }
    return SizedBox.shrink();
  }

  void _onUpdateSubscriptionModel(SubscriptionModel? model) {
    setState(() {
      _selectedSubscriptionModel = model;
    });
  }

  List<Widget> _getSubscriptionList() {
    List<Widget> widgetList = [];
    for (final item in _subscriptionModelList ?? []) {
      widgetList.add(
        SubscriptionItem(
          subscriptionModel: item,
          onChangeSelectUser: _onUpdateSubscriptionModel,
          isSelectedUser: (_selectedSubscriptionModel?.getMid == item.getMid),
        ),
      );
    }
    return widgetList;
  }

  BuildContext getBuildContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
      ],
      child: FutureBuilder<bool>(
          future: isLangInit,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              //error가 발생하게 될 경우 반환하게 되는 부분
              logger.severe("data fetch error(WaitDatum)");
              return const Center(child: Text('data fetch error(WaitDatum)'));
            }
            if (snapshot.hasData == false) {
              //print('xxxxxxxxxxxxxxxxxxxxx');
              logger.finest("wait data ...(WaitData)");
              return Center(
                child: CretaSnippet.showWaitSign(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              logger.finest("founded ${snapshot.data!}");
              // if (snapshot.data!.isEm

              if (StudioVariables.isFullscreen) {
                return _getRightPane(context);
              }
              //resize(context);
              CommunityRightChannelPane.lastDropdownMenuCount =
                  _getLeftDropdownMenuOnBanner().length;

              return Consumer<UserPropertyManager>(
                  builder: (context, userPropertyManager, childWidget) {
                if (oldLanguage != userPropertyManager.userPropertyModel!.language) {
                  oldLanguage = userPropertyManager.userPropertyModel!.language;

                  _initLeftMenu();
                  _initDropdownMenu();
                  _initPageVariables();
                }
                return Snippet.CretaScaffoldOfCommunity(
                  onFoldButtonPressed: () {
                    setState(() {});
                  },
                  // title: Row(
                  //   children: [
                  //     SizedBox(
                  //       width: 24,
                  //     ),
                  //     Theme(
                  //       data: ThemeData(
                  //         hoverColor: Colors.transparent,
                  //       ),
                  //       child: Link(
                  //         uri: Uri.parse(logoUrl),
                  //         builder: (context, function) {
                  //           return InkWell(
                  //             onTap: () => Routemaster.of(context).push(logoUrl),
                  //             child: Image(
                  //               image: AssetImage('assets/creta_logo_blue.png'),
                  //               //width: 120,
                  //               height: 20,
                  //             ),
                  //           );
                  //         },
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 5,
                  //     ),
                  //     Text(CretaVars.instance.serviceTypeString(),
                  //         style: CretaFont.logoStyle.copyWith(color: CretaColor.primary)),
                  //   ],
                  // ),
                  context: context,
                  getBuildContext: getBuildContext,
                  child: Stack(
                    children: [
                      mainPage(
                        bannerKey: GlobalObjectKey(
                            '${_communityChannelType.name}|${_currentChannelModel?.bannerImgUrl ?? ' '}'),
                        context,
                        gotoButtonPressed: () {
                          if (CretaAccountManager.experienceWithoutLogin) {
                            CretaAccountManager.experienceWithoutLogin = true;
                            Routemaster.of(context).push(AppRoutes.studioBookMainPage);
                          } else {
                            Routemaster.of(context).push(AppRoutes.studioBookGridPage);
                          }
                        },
                        gotoButtonTitle: CretaAccountManager.experienceWithoutLogin
                            ? CretaCommuLang['tourStudio']!
                            : CretaCommuLang['myCretaBookMenu']!,

                        gotoButtonPressed2: () {
                          Routemaster.of(context).push(AppRoutes.deviceMainPage);
                        },
                        gotoButtonTitle2: (CretaVars.instance.serviceType == ServiceType.barricade)
                            ? CretaCommuLang['myDeviceMenu']!
                            : null,

                        leftMenuItemList: _leftMenuItemList,
                        bannerTitle: 'title',
                        bannerDescription: 'description',
                        listOfListFilter: _getLeftDropdownMenuOnBanner(),
                        onSearch: _getSearchFunction,
                        mainWidget: _getRightPane, //(gridArea),
                        listOfListFilterOnRight: _getRightDropdownMenuOnBanner(),
                        titlePane: _titlePane,
                        bannerPane: (widget.subPageUrl == AppRoutes.communityBook ||
                                widget.subPageUrl == AppRoutes.playlistDetail)
                            ? _titlePane
                            : null,
                        leftPaddingOnFilter:
                            (widget.subPageUrl == AppRoutes.subscriptionList) ? 306 : null,
                        leftMarginOnRightPane: 0,
                        topMarginOnRightPane: 3,
                        rightMarginOnRightPane: 1,
                        bottomMarginOnRightPane: 3,
                        tabMenuList: _rightTabMenuList,
                        onFoldButtonPressed: () {
                          setState(() {});
                        },
                      ),
                      _getRightOverlayPane(),
                    ],
                  ),
                );
              });
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
