import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/lang/creta_commu_lang.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:routemaster/routemaster.dart';

import 'design_system/buttons/creta_button_wrapper.dart';
import 'design_system/menu/creta_popup_menu.dart';
import 'drawer_mixin.dart';
import 'pages/studio/studio_variables.dart';

class TopMenuItem {
  final String caption;
  final List<CretaMenuItem> subMenuItems;
  final IconData iconData;

  TopMenuItem({required this.caption, required this.subMenuItems, required this.iconData});
}

class DrawerMain extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const DrawerMain({super.key, required this.scaffoldKey});

  @override
  State<DrawerMain> createState() => DrawerMainState();

  static GlobalObjectKey drawerMainKey = const GlobalObjectKey<DrawerMainState>('DrawerMain');
}

class DrawerMainState extends State<DrawerMain> with DrawerMixin {
  static int? _expandedMenuItemIndex;

  @override
  void initState() {
    super.initState();
    initMixin(context);
  }

  void invalidate() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print(
    //     '--------------------------${CretaAccountManager.getEnterprise!.imageUrl}-----------------------');
    return Drawer(
      //backgroundColor: CretaColor.primary,
      elevation: 5,
      child: MouseRegion(
        onExit: (event) {
          if (widget.scaffoldKey.currentState!.isDrawerOpen) {
            widget.scaffoldKey.currentState?.closeDrawer();
          }
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(children: _expandedWidget()),
        ),
      ),
    );
  }

  List<Widget> _expandedWidget() {
    return [
      Expanded(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: CretaColor.primary,
                image: CretaAccountManager.getEnterprise != null &&
                        CretaAccountManager.getEnterprise!.imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(
                          CretaAccountManager.getEnterprise!.imageUrl,
                        ),
                        fit: BoxFit.fill, // 이미지가 DrawerHeader 영역을 꽉 채우도록 설정
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Snippet.outlineText(
                      CretaAccountManager.getEnterprise != null
                          ? CretaAccountManager.getEnterprise!.name
                          : UserPropertyModel.defaultEnterprise,
                      style: CretaFont.logoStyle.copyWith(fontSize: 48, color: Colors.white),
                    ),
                  ),
                  Positioned(right: 0, bottom: 0, child: Snippet.serviceTypeLogo(true)),
                ],
              ),
            ),
            ...List.generate(topMenuItems.length, (index) {
              var topItem = topMenuItems[index];
              //print('DrawerExpansionTile$index${_expandedMenuItemIndex ?? ""}');
              return ExpansionTile(
                key: GlobalObjectKey('DrawerExpansionTile$index${_expandedMenuItemIndex ?? ""}'),
                initiallyExpanded: _expandedMenuItemIndex == index, // 초기 확장 상태 설정
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    if (expanded) {
                      _expandedMenuItemIndex = index; // 현재 확장된 메뉴 항목 업데이트
                    } else if (_expandedMenuItemIndex == index) {
                      _expandedMenuItemIndex = null; // 확장이 취소된 경우
                    }
                  });
                },
                leading: Icon(topItem.iconData),
                textColor: CretaColor.primary,
                //collapsedBackgroundColor: Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(topItem.caption,
                      style: CretaFont.logoStyle.copyWith(
                        fontSize: 32,
                        color: _expandedMenuItemIndex == index
                            ? CretaColor.primary
                            : CretaColor.text[400]!, // 확장된 경우와 축소된 경우에 다른 색상 적용
                      )),
                ),
                children: <Widget>[
                  for (var item in topItem.subMenuItems)
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(item.iconData, color: CretaColor.primary),
                      ),
                      title: Text(item.caption,
                          style: CretaFont.buttonMedium.copyWith(color: CretaColor.primary)),
                      onTap: () {
                        item.onPressed?.call();
                        widget.scaffoldKey.currentState?.closeDrawer();
                      },
                    ),
                ],
              );
            }),
            // 기존 ExpansionTile 위젯 리스트 마지막에 추가
            ListTile(
              leading: const Icon(Icons.exit_to_app), // 로그아웃 아이콘
              title: Text('Logout',
                  style: CretaFont.logoStyle.copyWith(
                    fontSize: 32,
                    color: CretaColor.text[400]!, // 확장된 경우와 축소된 경우에 다른 색상 적용
                  )), // 로그아웃 텍스트
              onTap: () {
                // 로그아웃 로직을 여기에 추가
                StudioVariables.selectedBookMid = '';
                CretaAccountManager.logout()
                    .then((value) => Routemaster.of(context).push(AppRoutes.login));
                // 예: FirebaseAuth.instance.signOut();
                //widget.scaffoldKey.currentState?.closeDrawer();
              },
            ),
          ],
        ),
      ),
      //const Spacer(),
      Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Center(child: _userInfoButton()),
      ),
    ];
  }

  Widget _userInfoButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        //color: Colors.amberAccent,
        // crop
        borderRadius: BorderRadius.circular(42),
      ),
      clipBehavior: Clip.antiAlias, // crop method
      width: 195 + 4 + 4,
      height: 76 + 4 + 4,
      padding: const EdgeInsets.all(4),
      child: BTN.fill_gray_l_profile_sub_widget(
        width: 195,
        text: AccountManager.currentLoginUser.name,
        // sideWidget: IconButton(
        //     onPressed: () {}, icon: const Icon(Icons.notifications_outlined, color: Colors.grey)),
        subWidget: Text(
          '${CretaCommuLang["subscriber"]!} ${CretaAccountManager.getChannel?.followerCount ?? 0}',
          style: CretaFont.buttonLarge.copyWith(color: Colors.grey),
        ),
        //_langSetting(context),
        image: NetworkImage(CretaAccountManager.getUserProperty!.profileImgUrl),
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageInfo);
          // if (channelId.isNotEmpty) {
          //   Routemaster.of(context).push(channelLinkUrl);
          // }
        },
      ),
    );
  }

  // Widget _langSetting(BuildContext context) {
  //   UserPropertyModel? userModel = CretaAccountManager.userPropertyManagerHolder.userPropertyModel;
  //   if (userModel != null) {
  //     String langStr = CretaMyPageLang['languageList']![
  //         userModel.language.index > 0 ? userModel.language.index - 1 : 0];

  //     if (langStr.length > 3) {
  //       langStr = langStr.substring(0, 3);
  //     }

  //     return Text(
  //       langStr,
  //       style: CretaFont.buttonLarge.copyWith(color: Colors.grey),
  //     );
  //   }
  //   return const SizedBox.shrink();

  //print('${userModel.language.index}--------------------------------------------');
  //print('$langStr--------------------------------------------');

  //   const GlobalObjectKey langSettingKey = GlobalObjectKey('_langSettingKey');

  //   return TextButton(
  //     key: langSettingKey,
  //     style: ButtonStyle(
  //       overlayColor: WidgetStateProperty.resolveWith<Color?>(
  //         (Set<WidgetState> states) {
  //           if (states.contains(WidgetState.hovered)) {
  //             return Colors.white.withOpacity(0.3);
  //           }
  //           if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
  //             return Colors.white.withOpacity(0.5);
  //           }
  //           return null; // Defer to the widget's default.
  //         },
  //       ),
  //       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
  //         RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //       ),
  //     ),
  //     child: Text(
  //       langStr,
  //       style: CretaFont.buttonLarge.copyWith(color: Colors.grey),
  //     ),
  //     onPressed: () {
  //       _popupLanguageMenu(langSettingKey, context, xOffset: 30, yOffset: -190);
  //     },
  //   );
  // }
  // return const SizedBox.shrink();
  //}

//   void popupLanguageMenu(GlobalKey key, BuildContext context,
//       {double xOffset = 0, double yOffset = 0}) {
//     CretaPopupMenu.showMenu(
//       context: context,
//       globalKey: key,
//       xOffset: xOffset,
//       yOffset: yOffset,
//       popupMenu: (CretaMyPageLang['languageList']!)
//           .asMap()
//           .map((index, lang) {
//             return MapEntry(
//                 index,
//                 CretaMenuItem(
//                   caption: lang,
//                   onPressed: () {
//                     Snippet.onLangSelected(
//                       value: index + 1,
//                       userPropertyManager: CretaAccountManager.userPropertyManagerHolder,
//                       invalidate: () {
//                         setState(() {});
//                         // print(
//                         //     'language : ${CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language}, ${CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language.index}');
//                         CretaAccountManager.userPropertyManagerHolder.notify();
//                       },
//                     );
//                     Routemaster.of(context).pop();
//                   },
//                 ));
//           })
//           .values
//           .toList()
//           .cast<CretaMenuItem>(),
//       initFunc: () {},
//     ).then((value) {
//       logger.finest('팝업메뉴 닫기');
//     });
//   }
// }
}
