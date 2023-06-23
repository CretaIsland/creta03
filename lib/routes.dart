// ignore_for_file: prefer_const_constructors

import 'package:creta03/pages/mypage/mypage.dart';
import 'package:creta03/pages/studio/left_menu/word_pad/quill_rte.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'design_system/component/colorPicker/color_picker_demo.dart';
import 'design_system/demo_page/font_demo_page.dart';
import 'design_system/demo_page/button_demo_page.dart';
import 'design_system/demo_page/menu_demo_page.dart';
import 'design_system/demo_page/text_field_demo_page.dart';
import 'model/contents_model.dart';
import 'pages/login_page.dart';
import 'pages/intro_page.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';
import 'package:hycop/hycop.dart';
//import 'pages/studio/sample_data.dart';
import 'pages/community/community_page.dart';
import 'pages/community/sub_pages/community_right_book_pane.dart';
import 'pages/community/sub_pages/community_right_channel_pane.dart';
import 'pages/community/sub_pages/community_right_playlist_detail_pane.dart';

abstract class AppRoutes {
  static Future<bool> launchTab(String url, {bool isHttps = false}) async {
    String base = '';
    String path = '';
    try {
      base = Uri.base.origin;
      path = _getMiddlePath(Uri.base.path);
      // print('-----------------------${Uri.base.origin}');
      // print('-----------------------${Uri.base.path}');
      // print('-----------------------$path');
    } catch (e) {
      base = isHttps ? "https://" : "http://";
      final String host = Uri.base.host;
      final int port = Uri.base.port;
      base += "$host:$port";
      path = "creta03_v1";
    }
    final String finalUrl = '$base$path$url';
    //print('-----------------------$finalUrl');
    Uri uri = Uri.parse(finalUrl);
    logger.finest('$finalUrl clicked');

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    }
    logger.severe('$finalUrl connect failed');
    return false;
  }

  static String _getMiddlePath(String inputString) {
    if (!inputString.contains('creta')) {
      return '';
    }

    // Find the index of the second occurrence of '/'
    int firstSlashIndex = inputString.indexOf('/');
    int secondSlashIndex = inputString.indexOf('/', firstSlashIndex + 1);

    String result = '';

    try {
      if (firstSlashIndex < 0 || secondSlashIndex < 0) {
        return '';
      }
      result = inputString.substring(0, secondSlashIndex);
    } catch (e) {
      return '';
    }
    return result;
  }

  static const String intro = '/intro';
  static const String menuDemoPage = '/menuDemoPage';
  static const String fontDemoPage = '/fontDemoPage';
  static const String buttonDemoPage = '/buttonDemoPage';
  static const String quillDemoPage = '/quillDemoPage';
  static const String textFieldDemoPage = '/textFieldDemoPage';
  static const String studioBookMainPage = '/studio/bookMainPage';
  static const String studioBookPreviewPage = '/studio/studioBookMainPreviewPage';
  static const String studioBookGridPage = '/studio/bookGridPage';
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
    AppRoutes.login: (routeData) {
      return (AccountManager.currentLoginUser.isLoginedUser)
          ? const Redirect(AppRoutes.intro)
          : const TransitionPage(child: LoginPage());
    },
    AppRoutes.menuDemoPage: (_) => TransitionPage(child: MenuDemoPage()),
    AppRoutes.fontDemoPage: (_) => TransitionPage(child: FontDemoPage()),
    AppRoutes.buttonDemoPage: (_) => TransitionPage(child: ButtonDemoPage()),
    // AppRoutes.quillDemoPage: (_) =>
    //     TransitionPage(child: QuillPlayerWidget(document: ContentsModel.withFrame(parent: ''))),
    AppRoutes.quillDemoPage: (_) => TransitionPage(child: QuillFloatingToolBarWidget(document: ContentsModel.withFrame(parent: ''))),
    AppRoutes.textFieldDemoPage: (_) => TransitionPage(child: TextFieldDemoPage()),
    AppRoutes.studioBookMainPage: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        //skpark test code
        if (BookMainPage.selectedMid.isEmpty) {
          BookMainPage.selectedMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
        }
        logger.finest('selectedMid=${BookMainPage.selectedMid}');
        return TransitionPage(
            child: BookMainPage(bookKey: GlobalObjectKey('Book${BookMainPage.selectedMid}')));
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.studioBookPreviewPage: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        //skpark test code
        if (BookMainPage.selectedMid.isEmpty) {
          BookMainPage.selectedMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
        }
        logger.finest('selectedMid=${BookMainPage.selectedMid}');

        return TransitionPage(
            child: BookMainPage(
                //bookKey: GlobalObjectKey('BookPreivew${BookMainPage.selectedMid}'),
                bookKey: GlobalKey(),
                isPreviewX: true));
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.studioBookGridPage: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        // print('---------------------------------------${routeData.fullPath}');
        // print('---------------------------------------${routeData.path}');
        // print('---------------------------------------${routeData.publicPath}');
        return TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.myPage),
        );
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.studioBookSharedPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.sharedPage),
        ),
    AppRoutes.studioBookTeamPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.teamPage),
        ),
    AppRoutes.communityHome: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.communityHome'),
              subPageUrl: AppRoutes.communityHome,
            ),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.channel: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        String url = routeData.fullPath;
        int pos = url.indexOf('channel=');
        String channelMid = (pos > 0) ? url.substring(pos) : '';
        CommunityRightChannelPane.channelId = channelMid;
        return TransitionPage(
          child: CommunityPage(
            key: GlobalObjectKey(channelMid.isNotEmpty ? channelMid : 'NoChannelMid'),
            subPageUrl: AppRoutes.channel,
          ),
        );
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.subscriptionList: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.subscriptionList'),
              subPageUrl: AppRoutes.subscriptionList,
            ),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.playlist: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.playlist'),
              subPageUrl: AppRoutes.playlist,
            ),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.playlistDetail: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        String url = routeData.fullPath;
        int pos = url.indexOf('playlist=');
        String playlistMid = (pos > 0) ? url.substring(pos) : '';
        CommunityRightPlaylistDetailPane.playlistId = playlistMid;
        return TransitionPage(
          child: CommunityPage(
            key: GlobalObjectKey(playlistMid.isNotEmpty ? playlistMid : 'NoPlaylistMid'),
            subPageUrl: AppRoutes.playlistDetail,
          ),
        );
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.communityBook: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        String url = routeData.fullPath;
        int pos = url.indexOf('book=');
        String bookMid = (pos > 0) ? url.substring(pos) : '';
        CommunityRightBookPane.bookId = bookMid;
        return TransitionPage(
          child: CommunityPage(
            key: GlobalObjectKey(bookMid.isNotEmpty ? bookMid : 'NoBookMid'),
            subPageUrl: AppRoutes.communityBook,
          ),
        );
      } else {
        return const Redirect(AppRoutes.login);
      }
    },
    AppRoutes.watchHistory: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.watchHistory'),
              subPageUrl: AppRoutes.watchHistory,
            ),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.favorites: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.favorites'),
              subPageUrl: AppRoutes.favorites,
            ),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.colorPickerDemo: (_) => TransitionPage(
          child: ColorPickerDemo(),
        ),
    AppRoutes.myPageDashBoard: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageDashBoard),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.myPageInfo: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageInfo),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.myPageAccountManage: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageAccountManage),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.myPageSettings: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageSettings),
          )
        : const Redirect(AppRoutes.login),
    AppRoutes.myPageTeamManage: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageTeamManage),
          )
        : const Redirect(AppRoutes.login),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
