import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';

import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';

import 'package:creta03/design_system/buttons/creta_tapbar_button.dart';
import 'package:creta03/design_system/component/creta_basic_layout_mixin.dart';
import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/menu/creta_popup_menu.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/creta_model.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_account_manage.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_dashboard.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_info.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_settings.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_team_manage.dart';
import 'package:creta03/pages/studio/studio_constant.dart';
import 'package:creta03/routes.dart';

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

  @override
  void initState() {
    super.initState();

    _leftMenuItem = [
      CretaMenuItem(
          caption: CretaMyPageLang.dashboard,
          iconData: Icons.account_circle_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageDashBoard,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageDashBoard);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang.info,
          iconData: Icons.lock_person_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageInfo,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageInfo);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang.accountManage,
          iconData: Icons.manage_accounts_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageAccountManage,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageAccountManage);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang.settings,
          iconData: Icons.notifications_outlined,
          isIconText: true,
          linkUrl: AppRoutes.myPageSettings,
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageSettings);
          }),
      CretaMenuItem(
          caption: CretaMyPageLang.teamManage,
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

  Widget _getCretaTapBarButton(CretaMenuItem item) {
    return CretaTapBarButton(
      iconData: item.iconData,
      iconSize: item.iconSize,
      caption: item.caption,
      isIconText: item.isIconText,
      selected: item.selected,
      onPressed: () {
        setState(() {
          for (var element in _leftMenuItem) {
            element.selected = false;
          }
          item.selected = true;
        });
        item.onPressed?.call();
      },
    );
  }

  Widget leftMenu() {
    return Container(
      width: CretaComponentLocation.TabBar.width,
      height: leftPaneRect.height,
      color: CretaColor.text[100],
      padding: CretaComponentLocation.TabBar.padding,
      child: ListView.builder(
          padding: CretaComponentLocation.ListInTabBar.padding,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Wrap(
                direction: Axis.vertical,
                spacing: 8, // <-- Spacing between children
                children: _leftMenuItem
                    .map((item) => (item.linkUrl == null)
                        ? _getCretaTapBarButton(item)
                        : Link(
                            uri: Uri.parse(item.linkUrl!),
                            builder: (context, function) {
                              return InkWell(
                                onTap: () => {},
                                child: _getCretaTapBarButton(item),
                              );
                            },
                          ))
                    .toList());
          }),
    );
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
            height: rightPaneRect.childHeight + LayoutConst.cretaBannerMinHeight,
            child: CretaModelSnippet.waitData(
                consumerFunc: rightArea, manager: LoginPage.enterpriseHolder!))
      ],
    );
    _alreadyDataGet = true;

    return retval;
  }

  @override
  Widget build(BuildContext context) {
    resize(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: LoginPage.userPropertyManagerHolder!),
        ChangeNotifierProvider<TeamManager>.value(value: LoginPage.teamManagerHolder!),
      ],
      child: Snippet.CretaScaffoldOfMyPage(
          title: Container(
            padding: const EdgeInsets.only(left: 24),
            child: InkWell(
              onTap: () => Routemaster.of(context).push(AppRoutes.communityHome),
              child: const Image(
                image: AssetImage("assets/creta_logo_blue.png"),
                height: 20,
              ),
            ),
          ),
          context: context,
          child: myPageMain()),
    );
  }
}
