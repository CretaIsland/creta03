// ignore_for_file: prefer_const_constructors

import 'package:routemaster/routemaster.dart';
import 'design_system/demo_page/font_demo_page.dart';
import 'design_system/demo_page/button_demo_page.dart';
import 'pages/login_page.dart';
import 'pages/intro_page.dart';

abstract class AppRoutes {
  static const String intro = '/intro';
  static const String fontDemoPage = '/fontDemoPage';
  static const String buttonDemoPage = '/buttonDemoPage';
  static const String login = '/login';
}

//final menuKey = GlobalKey<DrawerMenuPageState>();
//DrawerMenuPage menuWidget = DrawerMenuPage(key: menuKey);

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
    AppRoutes.login: (_) => TransitionPage(child: LoginPage()),
    AppRoutes.fontDemoPage: (_) => TransitionPage(child: FontDemoPage()),
    AppRoutes.buttonDemoPage: (_) => TransitionPage(child: ButtonDemoPage()),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
  routes: {
    AppRoutes.intro: (_) => TransitionPage(child: IntroPage()),
  },
);
