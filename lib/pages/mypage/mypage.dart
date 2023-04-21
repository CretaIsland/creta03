import 'package:creta03/design_system/component/creta_basic_layout_mixin.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_account_manage.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_dashboard.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_info.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_settings.dart';
import 'package:creta03/pages/mypage/sub_page/my_page_team_manage.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:url_launcher/link.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../data_io/user_property_manager.dart';
import '../../design_system/buttons/creta_tapbar_button.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_mypage_lang.dart';
import '../../model/creta_model.dart';
import '../../routes.dart';
import '../studio/studio_constant.dart';

class MyPage extends StatefulWidget {

  final String selectedPage;
  const MyPage({super.key, required this.selectedPage});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with CretaBasicLayoutMixin {

  
  late List<CretaMenuItem> _leftMeunItem;
  UserPropertyManager? userPropertyManagerHolder;
  bool _alreadyDataGet = false;

  @override
  void initState() {
    super.initState();
    _leftMeunItem = [
      CretaMenuItem(
        caption: CretaMyPageLang.dashboard, 
        iconData: Icons.account_circle_outlined,
        linkUrl: AppRoutes.myPageDashBoard,
        isIconText: true,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageDashBoard);
        }
      ),
      CretaMenuItem(
        caption: CretaMyPageLang.info, 
        iconData: Icons.lock_person_outlined,
        linkUrl: AppRoutes.myPageInfo,
        isIconText: true,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageInfo);
        }
      ),
      CretaMenuItem(
        caption: CretaMyPageLang.accountManage, 
        iconData: Icons.manage_accounts_outlined,
        linkUrl: AppRoutes.myPageAccountManage,
        isIconText: true,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageAccountManage);
        }
      ),
      CretaMenuItem(
        caption: CretaMyPageLang.settings, 
        iconData: Icons.notifications_outlined,
        linkUrl: AppRoutes.myPageSettings,
        isIconText: true,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageSettings);
        }
      ),
      CretaMenuItem(
        caption: CretaMyPageLang.teamManage, 
        iconData: Icons.group_outlined,
        linkUrl: AppRoutes.myPageTeamManage,
        isIconText: true,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageTeamManage);
        }
      ),
    ];

    switch(widget.selectedPage) {
      case AppRoutes.myPageInfo:
        _leftMeunItem[1].selected = true;
        _leftMeunItem[1].onPressed = () {};
        _leftMeunItem[1].linkUrl = null;
        break;
      case AppRoutes.myPageAccountManage:
        _leftMeunItem[2].selected = true;
        _leftMeunItem[2].onPressed = () {};
        _leftMeunItem[2].linkUrl = null;
        break;
      case AppRoutes.myPageSettings:
        _leftMeunItem[3].selected = true;
        _leftMeunItem[3].onPressed = () {};
        _leftMeunItem[3].linkUrl = null;
        break;
      case AppRoutes.myPageTeamManage:
        _leftMeunItem[4].selected = true;
        _leftMeunItem[4].onPressed = () {};
        _leftMeunItem[4].linkUrl = null;
        break;
      default:
        _leftMeunItem[0].selected = true;
        _leftMeunItem[0].onPressed = () {};
        _leftMeunItem[0].linkUrl = null;
        break;
    }

    userPropertyManagerHolder = UserPropertyManager();
    userPropertyManagerHolder!.configEvent();
    userPropertyManagerHolder!.clearAll();
    userPropertyManagerHolder!.initUserProperty();

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
          for(var element in _leftMeunItem) {
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
      height: leftBarArea.height,
      color: CretaColor.text[100],
      padding: CretaComponentLocation.TabBar.padding,
      child: ListView.builder(
        padding: CretaComponentLocation.ListInTabBar.padding,
        itemCount: 1,
        itemBuilder: (context, index) {
          return Wrap(
            direction: Axis.vertical,
            spacing: 8, // <-- Spacing between children
            children: _leftMeunItem.map((item) => (item.linkUrl == null) ? _getCretaTapBarButton(item) : Link(
              uri: Uri.parse(item.linkUrl!),
              builder: (context, function) {
                return InkWell(
                  onTap: () => {},
                  child: _getCretaTapBarButton(item),
                );
              },
            )).toList()
          );
        }
      ),
    );
  }

  Widget rightArea() {
    switch(widget.selectedPage) {
      case AppRoutes.myPageInfo:
        return MyPageInfo(width: gridArea.width, height: gridArea.height + LayoutConst.cretaBannerMinHeight);
      case AppRoutes.myPageAccountManage:
        return MyPageAccountManage(width: gridArea.width, height: gridArea.height + LayoutConst.cretaBannerMinHeight);
      case AppRoutes.myPageSettings:
        return MyPageSettings(width: gridArea.width, height: gridArea.height + LayoutConst.cretaBannerMinHeight);
      case AppRoutes.myPageTeamManage:
        return MyPageTeamManage(width: gridArea.width, height: gridArea.height + LayoutConst.cretaBannerMinHeight);
      default:
        return MyPageDashBoard(width: gridArea.width, height: gridArea.height + LayoutConst.cretaBannerMinHeight);
    }
  }

  Widget myPageMain() {
    if(_alreadyDataGet) {
      return Row(
        children: [
          leftMenu(),
          rightArea()
        ],
      );
    }

    var retval = Row(
      children: [
        leftMenu(),
        SizedBox(
          width: gridArea.width, 
          height: gridArea.height + LayoutConst.cretaBannerMinHeight,
          child: CretaModelSnippet.waitData(consumerFunc: rightArea, manager: userPropertyManagerHolder!)
        )
      ],
    );
    _alreadyDataGet = true;

    return retval;
  }

  @override
  Widget build(BuildContext context) {
    resize(context);
    return MultiProvider(
      providers: [ ChangeNotifierProvider<UserPropertyManager>.value(value: userPropertyManagerHolder!) ],
      child: Snippet.CretaScaffoldOfMyPage(
        title:  Container(
          padding: const EdgeInsets.only(left: 24),
          child: const Image(
            image: AssetImage("assets/creta_logo_blue.png"),
            height: 20,
          ),
        ),
        context: context, 
        child: myPageMain()
      ),
    );
  }
}