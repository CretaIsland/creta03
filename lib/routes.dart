// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/mypage/mypage.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design_system/component/colorPicker/color_picker_demo.dart';
import 'design_system/demo_page/font_demo_page.dart';
import 'design_system/demo_page/button_demo_page.dart';
import 'design_system/demo_page/menu_demo_page.dart';
import 'design_system/demo_page/text_field_demo_page.dart';
import 'pages/login_page.dart';
import 'pages/intro_page.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';
import 'package:hycop/hycop.dart';
//import 'pages/studio/sample_data.dart';
import 'pages/community/community_page.dart';
//import 'pages/community/community_book_page.dart';

abstract class AppRoutes {
  static Future<bool> launchTab(String url, {bool isHttps = false}) async {
    String base = '';
    try {
      final String origin = Uri.base.origin;
      base = origin;
    } catch (e) {
      base = isHttps ? "https://" : "http://";
      final String host = Uri.base.host;
      final int port = Uri.base.port;
      base += "$host:$port";
    }
    final String finalUrl = '$base$url';
    Uri uri = Uri.parse(finalUrl);
    logger.finest('$finalUrl clicked');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    logger.severe('$finalUrl connect failed');
    return false;
  }

  static const String intro = '/intro';
  static const String menuDemoPage = '/menuDemoPage';
  static const String fontDemoPage = '/fontDemoPage';
  static const String buttonDemoPage = '/buttonDemoPage';
  static const String textFieldDemoPage = '/textFieldDemoPage';
  static const String studioBookMainPage = '/studio/bookMainPage';
  static const String studioBookPreviewPage = '/studio/studioBookMainPreviewPage';
  static const String studioBookMyPage = '/studio/bookMyPage';
  static const String studioBookSharedPage = '/studio/bookMySharedPage';
  static const String studioBookTeamPage = '/studio/bookMyTeamPage';
  static const String login = '/login';
  static const String communityHome = '/community/home';
  static const String channel = '/community/channel';
  static const String subscriptionList = '/community/subscriptionList';
  static const String playlist = '/community/playlist';
  static const String playlistDetail = '/community/playlistDetail';
  static const String communityBook = '/community/book';
  static const String watchHistory = '/community/watchHistory';
  static const String favorites = '/community/favorites';
  static const String colorPickerDemo = '/colorPickerDemoPage';

  static const String myPageDashBoard = '/mypage/dashboard';
  static const String myPageInfo = '/mypage/info';
  static const String myPageAccountManage = '/mypage/accountManage';
  static const String myPageSettings = '/mypage/settings';
  static const String myPageTeamManage = '/mypage/teamManage';
}

//final menuKey = GlobalKey<DrawerMenuPageState>();
//DrawerMenuPage menuWidget = DrawerMenuPage(key: menuKey);

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => (AccountManager.currentLoginUser.isLoginedUser)
      ? const TransitionPage(child: IntroPage())
      : const Redirect(AppRoutes.login),
  routes: {
    AppRoutes.intro: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? const TransitionPage(child: IntroPage())
        : const Redirect(AppRoutes.login),
    AppRoutes.login: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? const Redirect(AppRoutes.intro)
        : const TransitionPage(child: LoginPage()),
    AppRoutes.menuDemoPage: (_) => TransitionPage(child: MenuDemoPage()),
    AppRoutes.fontDemoPage: (_) => TransitionPage(child: FontDemoPage()),
    AppRoutes.buttonDemoPage: (_) => TransitionPage(child: ButtonDemoPage()),
    AppRoutes.textFieldDemoPage: (_) => TransitionPage(child: TextFieldDemoPage()),
    AppRoutes.studioBookMainPage: (_) {
      //skpark test code
      if (BookMainPage.selectedMid.isEmpty) {
        BookMainPage.selectedMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
      }
      logger.finest('selectedMid=${BookMainPage.selectedMid}');
      return TransitionPage(child: BookMainPage(key: ValueKey(BookMainPage.selectedMid)));
    },
    AppRoutes.studioBookPreviewPage: (_) {
      //skpark test code
      if (BookMainPage.selectedMid.isEmpty) {
        BookMainPage.selectedMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
      }
      logger.finest('selectedMid=${BookMainPage.selectedMid}');
      return TransitionPage(
          child: BookMainPage(key: ValueKey(BookMainPage.selectedMid), isPreview: true));
    },
    AppRoutes.studioBookMyPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.myPage),
        ),
    AppRoutes.studioBookSharedPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.sharedPage),
        ),
    AppRoutes.studioBookTeamPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.teamPage),
        ),
    AppRoutes.communityHome: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.communityHome,
          ),
        ),
    AppRoutes.channel: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.channel,
          ),
        ),
    AppRoutes.subscriptionList: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.subscriptionList,
          ),
        ),
    AppRoutes.playlist: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.playlist,
          ),
        ),
    AppRoutes.playlistDetail: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.playlistDetail,
          ),
        ),
    AppRoutes.communityBook: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.communityBook,
          ),
        ),
    AppRoutes.watchHistory: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.watchHistory,
          ),
        ),
    AppRoutes.favorites: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalKey(),
            subPageUrl: AppRoutes.favorites,
          ),
        ),
    AppRoutes.colorPickerDemo: (_) => TransitionPage(
          child: ColorPickerDemo(),
        ),
    AppRoutes.myPageDashBoard: (_) => TransitionPage(
          child: MyPage(selectedPage: AppRoutes.myPageDashBoard),
        ),
    AppRoutes.myPageInfo: (_) => TransitionPage(
          child: MyPage(selectedPage: AppRoutes.myPageInfo),
        ),
    AppRoutes.myPageAccountManage: (_) => TransitionPage(
          child: MyPage(selectedPage: AppRoutes.myPageAccountManage),
        ),
    AppRoutes.myPageSettings: (_) => TransitionPage(
          child: MyPage(selectedPage: AppRoutes.myPageSettings),
        ),
    AppRoutes.myPageTeamManage: (_) => TransitionPage(
          child: MyPage(selectedPage: AppRoutes.myPageTeamManage),
        ),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
