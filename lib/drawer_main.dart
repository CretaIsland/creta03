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

import 'data_io/enterprise_manager.dart';
import 'design_system/menu/creta_popup_menu.dart';
import 'lang/creta_device_lang.dart';
import 'lang/creta_mypage_lang.dart';
import 'lang/creta_studio_lang.dart';
import 'pages/admin/admin_main_page.dart';
import 'pages/device/device_main_page.dart';
import 'pages/login/login_dialog.dart';
import 'pages/studio/book_grid_page.dart';

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
  State<DrawerMain> createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {
  List<TopMenuItem> _topMenuItems = [];

  @override
  void initState() {
    super.initState();

    _topMenuItems = [
      TopMenuItem(
        caption: 'Community',
        iconData: Icons.language,
        subMenuItems: [
          CretaMenuItem(
            caption: CretaCommuLang['commuHome'] ?? '커뮤니티 홈',
            iconData: Icons.home_outlined,
            onPressed: () {
              Routemaster.of(context).push(AppRoutes.communityHome);
            },
          ),
          CretaMenuItem(
            caption: CretaCommuLang['subsList'] ?? '구독목록',
            iconData: Icons.local_library_outlined,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser) {
                Routemaster.of(context).push(AppRoutes.subscriptionList);
              } else {
                LoginDialog.popupDialog(context: context, getBuildContext: () => context);
              }
            },
          ),
          CretaMenuItem(
            caption: CretaCommuLang['watchHistory'] ?? '시청기록',
            iconData: Icons.article_outlined,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser) {
                Routemaster.of(context).push(AppRoutes.watchHistory);
              } else {
                LoginDialog.popupDialog(context: context, getBuildContext: () => context);
              }
            },
          ),
          CretaMenuItem(
            caption: CretaCommuLang['iLikeIt'] ?? '좋아요',
            iconData: Icons.favorite_outline,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser) {
                Routemaster.of(context).push(AppRoutes.favorites);
              } else {
                LoginDialog.popupDialog(context: context, getBuildContext: () => context);
              }
            },
          ),
          CretaMenuItem(
            caption: CretaCommuLang['playList'] ?? '재생목록',
            iconData: Icons.playlist_play,
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser) {
                Routemaster.of(context).push(AppRoutes.playlist);
              } else {
                LoginDialog.popupDialog(context: context, getBuildContext: () => context);
              }
            },
          ),
        ],
      ),
      TopMenuItem(
        caption: 'Studio',
        iconData: Icons.edit_note_outlined,
        subMenuItems: [
          CretaMenuItem(
            caption: CretaStudioLang['myCretaBook']!,
            onPressed: () {
              Routemaster.of(context).push(AppRoutes.studioBookGridPage);
              BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
            },
            iconData: Icons.import_contacts_outlined,
          ),
          CretaMenuItem(
            caption: CretaStudioLang['sharedCretaBook']!,
            onPressed: () {
              Routemaster.of(context).pop();
              Routemaster.of(context).push(AppRoutes.studioBookSharedPage);
              BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
            },
            iconData: Icons.share_outlined,
          ),
          CretaMenuItem(
            caption: CretaStudioLang['teamCretaBook']!,
            onPressed: () {
              Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
              BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
            },
            iconData: Icons.group_outlined,
          ),
          CretaMenuItem(
            caption: CretaStudioLang['trashCan']!,
            onPressed: () {
              //Routemaster.of(context).push(AppRoutes.studioBookTrashCanPage);
              //BookGridPage.lastGridMenu = AppRoutes.studioBookTrashCanPage;
            },
            iconData: Icons.delete_outline,
            isIconText: true,
          ),
        ],
      ),
      TopMenuItem(
        caption: 'Devices',
        iconData: Icons.tv_outlined,
        subMenuItems: [
          CretaMenuItem(
            caption: CretaDeviceLang['myCretaDevice']!,
            onPressed: () {
              Routemaster.of(context).pop();
              Routemaster.of(context).push(AppRoutes.deviceMainPage);
              DeviceMainPage.lastGridMenu = AppRoutes.deviceMainPage;
            },
            iconData: Icons.import_contacts_outlined,
          ),
          CretaMenuItem(
            caption: CretaDeviceLang['sharedCretaDevice']!,
            onPressed: () {
              Routemaster.of(context).pop();
              Routemaster.of(context).push(AppRoutes.deviceSharedPage);
              DeviceMainPage.lastGridMenu = AppRoutes.deviceSharedPage;
            },
            iconData: Icons.share_outlined,
          ),
          CretaMenuItem(
            caption: CretaDeviceLang['teamCretaDevice']!,
            onPressed: () {
              // Routemaster.of(context).push(AppRoutes.studioBookTeamPage);
              // DeviceMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
            },
            iconData: Icons.group_outlined,
          ),
          CretaMenuItem(
            caption: CretaStudioLang['trashCan']!,
            onPressed: () {
              //Routemaster.of(context).push(AppRoutes.studioBookTrashCanPage);
              //DeviceMainPage.lastGridMenu = AppRoutes.studioBookTrashCanPage;
            },
            iconData: Icons.delete_outline,
          ),
        ],
      ),
      TopMenuItem(
        caption: 'My Page',
        iconData: Icons.person_outline,
        subMenuItems: [
          CretaMenuItem(
              caption: CretaMyPageLang['dashboard']!,
              iconData: Icons.account_circle_outlined,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.myPageDashBoard);
              }),
          CretaMenuItem(
              caption: CretaMyPageLang['info']!,
              iconData: Icons.lock_person_outlined,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.myPageInfo);
              }),
          CretaMenuItem(
              caption: CretaMyPageLang['accountManage']!,
              iconData: Icons.manage_accounts_outlined,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.myPageAccountManage);
              }),
          CretaMenuItem(
              caption: CretaMyPageLang['settings']!,
              iconData: Icons.notifications_outlined,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.myPageSettings);
              }),
          CretaMenuItem(
              caption: CretaMyPageLang['teamManage']!,
              iconData: Icons.group_outlined,
              onPressed: () {
                Routemaster.of(context).push(AppRoutes.myPageTeamManage);
              }),
        ],
      ),
      if ((AccountManager.currentLoginUser.isSuperUser ||
          EnterpriseManager.isAdmin(AccountManager.currentLoginUser.email)))
        TopMenuItem(
          caption: 'Admin',
          iconData: Icons.admin_panel_settings_outlined,
          subMenuItems: [
            CretaMenuItem(
              caption: CretaDeviceLang['enterprise']!,
              onPressed: () {
                AdminMainPage.showSelectEnterpriseWarnning(context);
                Routemaster.of(context).push(AppRoutes.adminMainPage);
              },
              iconData: Icons.business_outlined,
            ),
            CretaMenuItem(
              caption: CretaDeviceLang['teamManage'] ?? 'Team Management',
              onPressed: () {
                AdminMainPage.showSelectEnterpriseWarnning(context);
                Routemaster.of(context).push(AppRoutes.adminTeamPage);
              },
              iconData: Icons.groups_2_outlined,
            ),
            CretaMenuItem(
              caption: CretaDeviceLang['userManage'] ?? 'User Management',
              onPressed: () {
                AdminMainPage.showSelectEnterpriseWarnning(context);
                Routemaster.of(context).push(AppRoutes.adminUserPage);
              },
              iconData: Icons.person_2_outlined,
            ),
          ],
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {

    return Drawer(
      //backgroundColor: CretaColor.primary,
      child: MouseRegion(
        onExit: (event) {
          if (widget.scaffoldKey.currentState!.isDrawerOpen) {
            widget.scaffoldKey.currentState?.closeDrawer();
          }
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: CretaColor.primary,
                image: CretaAccountManager.getEnterprise != null
                    ? DecorationImage(
                        image: CretaAccountManager.getEnterprise!.imageUrl.isNotEmpty
                            ? NetworkImage(CretaAccountManager.getEnterprise!.imageUrl)
                            : const NetworkImage(
                                'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Snippet.serviceTypeLogo(),
                  ),
                ],
              ),
            ),
            for (var topItem in _topMenuItems)
              ExpansionTile(
                onExpansionChanged: (value) {},
                //iconColor: CretaColor.text[600]!,
                collapsedIconColor: CretaColor.text[400]!,
                leading: Icon(topItem.iconData),
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Text(topItem.caption,
                      style:
                          CretaFont.logoStyle.copyWith(fontSize: 32, color: CretaColor.text[400]!)),
                ),
                children: <Widget>[
                  for (var item in topItem.subMenuItems)
                    ListTile(
                      leading: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(item.iconData, color: CretaColor.text[400]!),
                      ),
                      title: Text(
                        item.caption,
                        style: CretaFont.buttonMedium,
                      ),
                      onTap: () {
                        item.onPressed?.call();
                        widget.scaffoldKey.currentState?.closeDrawer();
                      },
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
