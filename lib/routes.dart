// ignore_for_file: prefer_const_constructors
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
//import 'package:appflowy_editor/appflowy_editor.dart';
//import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta03/pages/landing_page.dart';
import 'package:creta03/pages/mypage/mypage.dart';
import 'package:creta03/pages/privacy_policy_page.dart';
import 'package:creta03/pages/service_terms_page.dart';
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
import 'package:creta_studio_model/model/book_model.dart';
import 'pages/admin/admin_main_page.dart';
import 'pages/device/device_main_page.dart';
import 'pages/login/creta_account_manager.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';
import 'package:hycop/hycop.dart';
//import 'pages/studio/sample_data.dart';
import 'pages/community/community_page.dart';
import 'pages/community/sub_pages/community_right_book_pane.dart';
import 'pages/community/sub_pages/community_right_channel_pane.dart';
import 'pages/community/sub_pages/community_right_playlist_detail_pane.dart';
import 'pages/reset_password_confirm_page.dart';
import 'pages/verify_email_page.dart';
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

  static String getFirstPath() {
    Uri uri = Uri.parse(window.location.href);
    // URL의 경로 세그먼트를 가져옵니다.
    List<String> pathSegments = uri.pathSegments;
    // 첫 번째 디렉토리 이름을 반환합니다. 경로가 없거나 첫 번째 디렉토리가 없는 경우 빈 문자열을 반환합니다.
    return pathSegments.isNotEmpty ? pathSegments[0] : '';
  }

  static String _getMiddlePath(String inputString) {
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
  static const String deviceMainPage = '/device/deviceMainPage';
  static const String deviceSharedPage = '/device/deviceSharedPage';
  //static const String deviceDetailPage = '/device/deviceDetailPage';
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

  static const String resetPasswordConfirm = '/resetPasswordConfirm';
  static const String verifyEmail = '/verifyEmail';

  static const String privacyPolicy = '/policy/privacy';
  static const String serviceTerms = '/terms/service';

  static const String adminMainPage = '/admin/adminMainPage';
  static const String adminTeamPage = '/admin/adminTeamPage';
  static const String adminUserPage = '/admin/adminUserPage';
}

//final menuKey = GlobalKey<DrawerMenuPageState>();
//DrawerMenuPage menuWidget = DrawerMenuPage(key: menuKey);

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => (AccountManager.currentLoginUser.isLoginedUser)
      ? const Redirect(AppRoutes.communityHome)
      : const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.wait: (_) => const TransitionPage(child: WaitPage()),
    AppRoutes.intro: (_) => (AccountManager.currentLoginUser.isLoginedUser)
        ? const Redirect(AppRoutes.communityHome)
        : const TransitionPage(child: LandingPage()),
    //: const TransitionPage(child: IntroPage()),
    //AppRoutes.intro: (_) => const TransitionPage(child: LandingPage()),
    AppRoutes.login: (routeData) {
      return (AccountManager.currentLoginUser.isLoginedUser)
          ? const Redirect(AppRoutes.communityHome)
          : const Redirect(AppRoutes.intro);
    },
    AppRoutes.privacyPolicy: (_) => const TransitionPage(child: PrivacyPolicyPage()),
    AppRoutes.serviceTerms: (_) => const TransitionPage(child: ServiceTermsPage()),
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
    AppRoutes.deviceMainPage: (_) => TransitionPage(
        child: DeviceMainPage(
            key: GlobalObjectKey('deviceMyPage'), selectedPage: DeviceSelectedPage.myPage)),
    AppRoutes.deviceSharedPage: (_) => TransitionPage(
        child: DeviceMainPage(
            key: GlobalObjectKey('deviceSharedPage'), selectedPage: DeviceSelectedPage.sharedPage)),
    AppRoutes.adminMainPage: (_) =>
        TransitionPage(child: AdminMainPage(key: GlobalObjectKey('AdminMainPage'), selectedPage: AdminSelectedPage.enterprise)),
    AppRoutes.adminTeamPage: (_) =>
        TransitionPage(child: AdminMainPage(key: GlobalObjectKey('AdminTeamPage'),selectedPage: AdminSelectedPage.team)),
    AppRoutes.adminUserPage: (_) =>
        TransitionPage(child: AdminMainPage(key: GlobalObjectKey('AdminUserPage'),selectedPage: AdminSelectedPage.user)),

    //AppRoutes.deviceDetailPage: (_) => TransitionPage(child: DeviceDetailPage()),
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
        StudioVariables.selectedBookMid = '';
        //logger.severe('체험하기.....start (${StudioVariables.selectedBookMid}) ');
        // 체험하기의 경우.
        // 체험하기버튼 => http://locahost/book
        if (StudioVariables.selectedBookMid == '') {
          BookMainPage.bookManagerHolder ??= BookManager();
          BookModel book = BookMainPage.bookManagerHolder!.createSample();
          StudioVariables.selectedBookMid = book.mid;
          BookMainPage.bookManagerHolder!.createNewBook(book).then((book) {
            logger.severe('Book created');
          });
        }
        //logger.severe('체험하기.....end : (${StudioVariables.selectedBookMid})');
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
    AppRoutes.communityHome: (_) {
      // superAdmin 인데, Enterprise 가 없으면, Enterprise 선택 페이지로 간다.
      if (AccountManager.currentLoginUser.isSuperUser &&
          CretaAccountManager.getEnterprise == null) {
        return const Redirect(AppRoutes.adminMainPage);
      }
      return TransitionPage(
        child: CommunityPage(
          key: GlobalObjectKey('AppRoutes.communityHome'),
          subPageUrl: AppRoutes.communityHome,
        ),
      );
    },
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
    AppRoutes.resetPasswordConfirm: (routeData) {
      Map<String, String> paramMap = routeData.queryParameters;
      String userId = '';
      String secret = '';
      paramMap.forEach((key, value) {
        if (key == 'userId') {
          userId = value;
        } else if (key == 'secret') {
          secret = value;
        }
      });
      return TransitionPage(
        child: ResetPasswordConfirmPage(
          key: GlobalObjectKey('$userId-$secret'),
          userId: userId,
          secretKey: secret,
        ),
      );
    },
    AppRoutes.verifyEmail: (routeData) {
      Map<String, String> paramMap = routeData.queryParameters;
      String userId = '';
      String secret = '';
      paramMap.forEach((key, value) {
        if (key == 'userId') {
          userId = value;
        } else if (key == 'secret') {
          secret = value;
        }
      });
      return TransitionPage(
        child: VerifyEmailPage(
          key: GlobalObjectKey('VerifyEmailPage-$userId-$secret'),
          userId: userId,
          secretKey: secret,
        ),
      );
    },
  },
);

final routesWait = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.wait),
  routes: {
    AppRoutes.wait: (_) => const TransitionPage(child: WaitPage()),
    // AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
