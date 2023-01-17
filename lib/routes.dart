// ignore_for_file: prefer_const_constructors

import 'package:routemaster/routemaster.dart';
import 'design_system/demo_page/font_demo_page.dart';
import 'design_system/demo_page/button_demo_page.dart';
import 'design_system/demo_page/menu_demo_page.dart';
import 'design_system/demo_page/text_field_demo_page.dart';
import 'pages/login_page.dart';
import 'pages/intro_page.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';
import 'package:hycop/hycop.dart';
//import 'pages/community_home_page.dart';
import 'pages/studio/sample_data.dart';
//import 'pages/subscription_list_page.dart';
//import 'pages/play_list/play_list_page.dart';
import 'pages/community/community_page.dart';

abstract class AppRoutes {
  static const String intro = '/intro';
  static const String menuDemoPage = '/menuDemoPage';
  static const String fontDemoPage = '/fontDemoPage';
  static const String buttonDemoPage = '/buttonDemoPage';
  static const String textFieldDemoPage = '/textFieldDemoPage';
  static const String studioBookMainPage = '/studio/bookMainPage';
  static const String studioBookListPage = '/studio/bookListPage';
  static const String login = '/login';
  static const String communityHome = '/communityHome';
  static const String subscriptionList = '/subscriptionList';
  static const String playList = '/playList';
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
    AppRoutes.studioBookMainPage: (_) => TransitionPage(
          child: BookMainPage(model: SampleData.sampleBook),
        ),
    AppRoutes.studioBookListPage: (_) => TransitionPage(
          child: BookListPage(),
        ),
    AppRoutes.communityHome: (_) => TransitionPage(child: CommunityPage(subPageUrl: AppRoutes.communityHome,),),
    AppRoutes.subscriptionList: (_) => TransitionPage(child: CommunityPage(subPageUrl: AppRoutes.subscriptionList,),),
    AppRoutes.playList: (_) => TransitionPage(child: CommunityPage(subPageUrl: AppRoutes.playList,),),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
