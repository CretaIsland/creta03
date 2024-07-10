import 'package:creta03/data_io/channel_manager.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
//import 'package:url_launcher/link.dart';

//import 'package:creta03/design_system/buttons/creta_tapbar_button.dart';
import 'package:creta03/design_system/component/creta_basic_layout_mixin.dart';
import 'package:creta03/design_system/component/snippet.dart';
//import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta_user_io/data_io/creta_manager.dart';
//import 'package:creta03/pages/login_page.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_account_manage.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_dashboard.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_info.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_settings.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_team_manage.dart';
import 'package:creta03/routes.dart';
import '../../design_system/component/creta_leftbar.dart';
import '../login/creta_account_manager.dart';

class MyPage extends StatefulWidget {
  final String selectedPage;
  const MyPage({super.key, required this.selectedPage});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with CretaBasicLayoutMixin {
  late List<CretaMenuItem> _leftMenuItem;
  Color replaceColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  bool _alreadyDataGet = false;
  LanguageType oldLanguage = LanguageType.none;

  @override
  void initState() {
    super.initState();

    isLangInit = initLang();
  }

  static Future<bool>? isLangInit;

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initMenu();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;

    return true;
  }

  void _initMenu() {
    _leftMenuItem = [
      CretaMenuItem(
          caption: CretaMyPageLang['dashboard']!,
          iconData: Icons.account_circle_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageDashBoard,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageDashBoard);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang['info']!,
          iconData: Icons.lock_person_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageInfo,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageInfo);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang['accountManage']!,
          iconData: Icons.manage_accounts_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageAccountManage,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageAccountManage);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang['settings']!,
          iconData: Icons.notifications_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageSettings,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageSettings);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang['teamManage']!,
          iconData: Icons.group_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageTeamManage,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageTeamManage);
          })
    ];
    switch (widget.selectedPage) {
      case AppRoutes.myPageInfo:
        _leftMenuItem[1].selected = true;
        break;
      case AppRoutes.myPageAccountManage:
        _leftMenuItem[2].selected = true;
        break;
      case AppRoutes.myPageSettings:
        _leftMenuItem[3].selected = true;
        break;
      case AppRoutes.myPageTeamManage:
        _leftMenuItem[4].selected = true;
        break;
      default:
        _leftMenuItem[0].selected = true;
        break;
    }
  }

  // ignore: unused_element
  // Widget _getCretaTapBarButton(CretaMenuItem item) {
  //   return CretaTapBarButton(
  //     iconData: item.iconData,
  //     iconSize: item.iconSize,
  //     caption: item.caption,
  //     isIconText: item.isIconText,
  //     selected: item.selected,
  //     onPressed: () {
  //       setState(() {
  //         for (var element in _leftMenuItem) {
  //           element.selected = false;
  //         }
  //         item.selected = true;
  //       });
  //       item.onPressed?.call();
  //     },
  //   );
  // }

  Widget leftMenu() {
    return CretaLeftBar(
      width: leftPaneRect.width,
      height: leftPaneRect.height,
      menuItem: _leftMenuItem,
      onFoldButtonPressed: () {
        setState(() {});
      },
      // gotoButtonPressed: gotoButtonPressed,
      // gotoButtonTitle: gotoButtonTitle,
      // gotoButtonPressed2: gotoButtonPressed2,
      // gotoButtonTitle2: gotoButtonTitle2,
    );

    //   return Container(
    //     width: CretaComponentLocation.TabBar.width,
    //     height: leftPaneRect.height,
    //     color: CretaColor.text[100],
    //     padding: CretaComponentLocation.TabBar.padding,
    //     child: ListView.builder(
    //         padding: CretaComponentLocation.ListInTabBar.padding,
    //         itemCount: 1,
    //         itemBuilder: (context, index) {
    //           return Wrap(
    //               direction: Axis.vertical,
    //               spacing: 8, // <-- Spacing between children
    //               children: _leftMenuItem
    //                   .map((item) => (item.linkUrl == null)
    //                       ? _getCretaTapBarButton(item)
    //                       : Link(
    //                           uri: Uri.parse(item.linkUrl!),
    //                           builder: (context, function) {
    //                             return InkWell(
    //                               onTap: () => {},
    //                               child: _getCretaTapBarButton(item),
    //                             );
    //                           },
    //                         ))
    //                   .toList());
    //         }),
    //   );
  }

  Widget rightArea() {
    switch (widget.selectedPage) {
      case AppRoutes.myPageInfo:
        return MyPageInfo(
            width: rightPaneRect.width, height: rightPaneRect.height, replaceColor: replaceColor);
      case AppRoutes.myPageAccountManage:
        return MyPageAccountManage(width: rightPaneRect.width, height: rightPaneRect.height);
      case AppRoutes.myPageSettings:
        return MyPageSettings(width: rightPaneRect.width, height: rightPaneRect.height);
      case AppRoutes.myPageTeamManage:
        return MyPageTeamManage(
            width: rightPaneRect.width, height: rightPaneRect.height, replaceColor: replaceColor);
      default:
        return MyPageDashBoard(
            width: rightPaneRect.width, height: rightPaneRect.height, replaceColor: replaceColor);
    }
  }

  Widget myPageMain() {
    if (_alreadyDataGet) {
      return Row(
        children: [leftMenu(), rightArea()],
      );
    }

    var retval = Row(
      children: [
        leftMenu(),
        SizedBox(
            width: rightPaneRect.childWidth,
            height: rightPaneRect.childHeight + CretaConst.cretaBannerMinHeight,
            child: CretaManager.waitData(
                consumerFunc: rightArea, manager: CretaAccountManager.enterpriseManagerHolder))
      ],
    );
    _alreadyDataGet = true;

    return retval;
  }

  @override
  Widget build(BuildContext context) {
    // if (UserPropertyManager.getUserProperty == null) {
    //   print('myPage.dart build-------------------------------------------------2');
    //   return const SizedBox.shrink();
    // }
    resize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
        ChangeNotifierProvider<TeamManager>.value(value: CretaAccountManager.teamManagerHolder),
        ChangeNotifierProvider<ChannelManager>.value(
            value: CretaAccountManager.channelManagerHolder),
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

              return Consumer<UserPropertyManager>(builder: (context, userPropertyManager, child) {
                if (userPropertyManager.userPropertyModel != null &&
                    oldLanguage != userPropertyManager.userPropertyModel!.language) {
                  oldLanguage = userPropertyManager.userPropertyModel!.language;
                  _initMenu();
                }
                return Snippet.CretaScaffoldOfMyPage(
                    onFoldButtonPressed: () {
                      setState(() {});
                    },
                    title: Container(
                      padding: const EdgeInsets.only(left: 24),
                      child: InkWell(
                        onTap: () => Routemaster.of(context).push(AppRoutes.intro),
                        child: const Image(
                          image: AssetImage("assets/creta_logo_blue.png"),
                          height: 20,
                        ),
                      ),
                    ),
                    context: context,
                    child: myPageMain());
              });
            }
            return const SizedBox.shrink();
          }),
    );
  }
}
