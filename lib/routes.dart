// ignore_for_file: prefer_const_constructors

//import 'package:appflowy_editor/appflowy_editor.dart';
//import 'package:creta03/model/contents_model.dart';
import 'package:creta03/pages/landing_page.dart';
import 'package:creta03/pages/mypage/mypage.dart';
//import 'package:creta03/pages/studio/left_menu/word_pad/quill_appflowy.dart';
// import 'package:creta03/pages/studio/left_menu/word_pad/quill_html_enhanced.daxt';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_io/book_manager.dart';
import 'design_system/component/colorPicker/color_picker_demo.dart';
import 'design_system/demo_page/font_demo_page.dart';
import 'design_system/demo_page/button_demo_page.dart';
import 'design_system/demo_page/menu_demo_page.dart';
import 'design_system/demo_page/text_field_demo_page.dart';
//import 'pages/login_page.dart';
import 'developer/gen_collections_page.dart';
// import 'pages/intro_page.dart';
import 'pages/login/creta_account_manager.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';
import 'package:hycop/hycop.dart';
//import 'pages/studio/sample_data.dart';
import 'pages/community/community_page.dart';
import 'pages/community/sub_pages/community_right_book_pane.dart';
import 'pages/community/sub_pages/community_right_channel_pane.dart';
import 'pages/community/sub_pages/community_right_playlist_detail_pane.dart';
import 'pages/studio/studio_variables.dart';
import 'wait_page.dart';
//import 'pages/login/creta_account_manager.dart';

abstract class AppRoutes {
  static Future<bool> launchTab(String url, {bool isHttps = false, bool isFullUrl = false}) async {
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
    final String finalUrl = isFullUrl ? url : '$base$path$url';
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

  static const String wait = '/wait';
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
  static const String genCollections = '/genCollectionPage';

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
      ? const Redirect(AppRoutes.communityHome)
      : const Redirect(AppRoutes.intro),
  routes: {
    // AppRoutes.intro: (_) => (AccountManager.currentLoginUser.isLoginedUser)
    //     ? const Redirect(AppRoutes.communityHome)
    //     : const TransitionPage(child: LandingPage()),
    //     //: const TransitionPage(child: IntroPage()),
    AppRoutes.wait: (_) => const TransitionPage(child: WaitPage()),
    AppRoutes.intro: (_) => const TransitionPage(child: LandingPage()),
    AppRoutes.login: (routeData) {
      return (AccountManager.currentLoginUser.isLoginedUser)
          ? const Redirect(AppRoutes.communityHome)
          : const Redirect(AppRoutes.intro);
    },
    AppRoutes.menuDemoPage: (_) => TransitionPage(child: MenuDemoPage()),
    AppRoutes.fontDemoPage: (_) => TransitionPage(child: FontDemoPage()),
    AppRoutes.buttonDemoPage: (_) => TransitionPage(child: ButtonDemoPage()),
    // AppRoutes.quillDemoPage: (_) => TransitionPage(
    //         child: MaterialApp(
    //       localizationsDelegates: const [
    //         AppFlowyEditorLocalizations.delegate,
    //       ],
    //       debugShowCheckedModeBanner: false,
    //       home: AppFlowyEditorWidget(
    //         model: ContentsModel.withFrame(parent: '', bookMid: ''),
    //         size: Size.zero,
    //         onComplete: () {},
    //       ),
    //     )),
    // AppRoutes.quillDemoPage: (_) =>
    //     TransitionPage(child: QuillPlayerWidget(document: ContentsModel.withFrame(parent: ''))),
    // AppRoutes.quillDemoPage: (_) => TransitionPage(
    //     child:
    //     QuillFloatingToolBarWidget(document: ContentsModel.withFrame(parent: '', bookMid: ''))),
    AppRoutes.textFieldDemoPage: (_) => TransitionPage(child: TextFieldDemoPage()),
    AppRoutes.studioBookMainPage: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        //skpark test code
        // if (StudioVariables.selectedBookMid.isEmpty) {
        //   StudioVariables.selectedBookMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
        // }
        logger.info('routeData fullpath=${routeData.fullPath}');
        logger.info('routeData path=${routeData.path}');
        logger.info('routeData parameters=${routeData.queryParameters.toString()}');

        // if (StudioVariables.selectedBookMid.isEmpty) {
        //   logger.severe('selectedMid is empty');
        //   String? uid = routeData.queryParameters['book'];
        //   if (uid != null) {
        //     StudioVariables.selectedBookMid = 'book=$uid';
        //   } else {
        //     logger.severe('StudioVariables.selectedBookMid and routeData is null !!!!');
        //   }
        // }
        Map<String, String> paramMap = routeData.queryParameters;
        paramMap.forEach((key, value) {
          if (key == 'book') {
            StudioVariables.selectedBookMid = '$key=$value';
          }
        });

        return TransitionPage(
            child:
                BookMainPage(bookKey: GlobalObjectKey('Book${StudioVariables.selectedBookMid}')));
      } else {
        // 로그인도 안한 경우

        if (CretaAccountManager.experienceWithoutLogin == false) {
          // 체험하기가 아닌 경우,  인트로로 간다.
          return const Redirect(AppRoutes.intro);
        }
        // 체험하기의 경우.
        // 체험하기버튼 => http://locahost/book
        if (StudioVariables.selectedBookMid == '') {
          BookMainPage.bookManagerHolder ??= BookManager();
          BookMainPage.bookManagerHolder!.createNewBook().then((book) {
            StudioVariables.selectedBookMid = book.mid;
            return Redirect('${AppRoutes.studioBookMainPage}?${StudioVariables.selectedBookMid}');
          });
          return const Redirect(AppRoutes.intro);
        }
        return TransitionPage(
            child:
                BookMainPage(bookKey: GlobalObjectKey('Book${StudioVariables.selectedBookMid}')));
      }
    },
    AppRoutes.studioBookPreviewPage: (routeData) {
      //if (AccountManager.currentLoginUser.isLoginedUser) { // 로그인없이도 프리뷰는 재생 (2023-10-13 seventhstone)
      //skpark test code
      // if (StudioVariables.selectedBookMid.isEmpty) {
      //   StudioVariables.selectedBookMid = "book=a5948eae-03ae-410f-8efa-f1a3c28e4f05";
      // }
      logger.finest('selectedMid=${StudioVariables.selectedBookMid}');

      Map<String, String> paramMap = routeData.queryParameters;
      // String mode = paramMap['mode'] ?? '';
      bool? isPublishedMode;
      // if (mode.compareTo('preview') == 0) {
      //   isPublishedMode = true;
      // }

      paramMap.forEach((key, value) {
        if (key == 'book') {
          StudioVariables.selectedBookMid = '$key=$value';
        } else if (key == 'mode' && value == 'preview') {
          isPublishedMode = true;
        }
      });

      return TransitionPage(
        child: BookMainPage(
          bookKey: GlobalObjectKey('BookPreivew${StudioVariables.selectedBookMid}'),
          //bookKey: GlobalKey(),
          isPreviewX: true,
          isPublishedMode: isPublishedMode,
        ),
      );
      // } else {
      //   return const Redirect(AppRoutes.intro);
      // }
    },
    AppRoutes.studioBookGridPage: (routeData) {
      if (AccountManager.currentLoginUser.isLoginedUser) {
        // print('---------------------------------------${routeData.fullPath}');
        // print('---------------------------------------${routeData.path}');
        // print('---------------------------------------${routeData.publicPath}');
        return TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.myPage),
          //child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.sharedPage),
        );
      } else {
        return const Redirect(AppRoutes.intro);
      }
    },
    AppRoutes.studioBookSharedPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.sharedPage),
        ),
    AppRoutes.studioBookTeamPage: (_) => TransitionPage(
          child: BookGridPage(key: UniqueKey(), selectedPage: SelectedPage.teamPage),
        ),
    // AppRoutes.communityHome: (_) => (AccountManager.currentLoginUser.isLoginedUser)
    //     ? TransitionPage(
    //         child: CommunityPage(
    //           key: GlobalObjectKey('AppRoutes.communityHome'),
    //           subPageUrl: AppRoutes.communityHome,
    //         ),
    //       )
    //     : const Redirect(AppRoutes.intro),
    AppRoutes.communityHome: (_) => TransitionPage(
          child: CommunityPage(
            key: GlobalObjectKey('AppRoutes.communityHome'),
            subPageUrl: AppRoutes.communityHome,
          ),
        ),
    AppRoutes.channel: (routeData) {
      // if (AccountManager.currentLoginUser.isLoginedUser) {
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
      // } else {
      //   return const TransitionPage(child: IntroPage());
      // }
    },
    AppRoutes.subscriptionList: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.subscriptionList'),
              subPageUrl: AppRoutes.subscriptionList,
            ),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.playlist: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.playlist'),
              subPageUrl: AppRoutes.playlist,
            ),
          )
        : const Redirect(AppRoutes.intro),
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
        return const Redirect(AppRoutes.intro);
      }
    },
    AppRoutes.communityBook: (routeData) {
      //if (AccountManager.currentLoginUser.isLoginedUser) {
      // String url = routeData.fullPath;
      // int pos = url.indexOf('book=');
      // String bookMid = (pos > 0) ? url.substring(pos) : '';
      // CommunityRightBookPane.bookId = bookMid;
      CommunityRightBookPane.bookId = '';
      CommunityRightBookPane.playlistId = '';
      routeData.queryParameters.forEach((key, value) {
        if (key == 'book') {
          CommunityRightBookPane.bookId = '$key=$value';
        } else if (key == 'playlist') {
          CommunityRightBookPane.playlistId = '$key=$value';
        }
      });
      StudioVariables.selectedBookMid = CommunityRightBookPane.bookId;
      return TransitionPage(
        child: CommunityPage(
          key: GlobalObjectKey(CommunityRightBookPane.bookId.isNotEmpty
              ? CommunityRightBookPane.bookId
              : 'NoBookMid'),
          subPageUrl: AppRoutes.communityBook,
        ),
      );
      // } else {
      //   return const Redirect(AppRoutes.intro);
      // }
    },
    AppRoutes.watchHistory: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.watchHistory'),
              subPageUrl: AppRoutes.watchHistory,
            ),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.favorites: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: CommunityPage(
              key: GlobalObjectKey('AppRoutes.favorites'),
              subPageUrl: AppRoutes.favorites,
            ),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.colorPickerDemo: (_) => TransitionPage(
          child: ColorPickerDemo(),
        ),
    AppRoutes.genCollections: (_) => TransitionPage(
          child: GenCollectionsPage(),
        ),
    AppRoutes.myPageDashBoard: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageDashBoard),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.myPageInfo: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageInfo),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.myPageAccountManage: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageAccountManage),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.myPageSettings: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageSettings),
          )
        : const Redirect(AppRoutes.intro),
    AppRoutes.myPageTeamManage: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? TransitionPage(
            child: MyPage(selectedPage: AppRoutes.myPageTeamManage),
          )
        : const Redirect(AppRoutes.intro),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: LandingPage()),
    // AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
