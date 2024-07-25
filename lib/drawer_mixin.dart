import 'package:creta03/lang/creta_commu_lang.dart';
import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_Vars.dart';
import 'package:creta_common/lang/creta_lang.dart';
import 'package:flutter/foundation.dart';
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
import 'pages/popup/bass_demo_popup.dart';
import 'pages/popup/creta_version_popup.dart';
import 'pages/studio/book_grid_page.dart';
import 'pages/studio/book_main_page.dart';

class TopMenuItem {
  final String caption;
  final List<CretaMenuItem> subMenuItems;
  final IconData iconData;
  void Function()? onPressed;

  TopMenuItem(
      {required this.caption, required this.subMenuItems, required this.iconData, this.onPressed});
}

mixin DrawerMixin {
  List<TopMenuItem> topMenuItems = [];

  void initMixin(BuildContext context) {
    topMenuItems = [
      TopMenuItem(
        caption: 'Community',
        iconData: Icons.language,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.communityHome);
        },
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
        iconData: Icons.edit_note,
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.studioBookGridPage);
          BookGridPage.lastGridMenu = AppRoutes.studioBookSharedPage;
        },
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
        onPressed: () {
          Routemaster.of(context).pop();
          Routemaster.of(context).push(AppRoutes.deviceMainPage);
          DeviceMainPage.lastGridMenu = AppRoutes.deviceMainPage;
        },
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
        onPressed: () {
          Routemaster.of(context).push(AppRoutes.myPageDashBoard);
        },
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
          onPressed: () {
            AdminMainPage.showSelectEnterpriseWarnning(context);
            Routemaster.of(context).push(AppRoutes.adminMainPage);
          },
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
      TopMenuItem(
        caption: 'Settings',
        iconData: Icons.settings_outlined,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return const CretaVersionPopUp();
              });
        },
        subMenuItems: [
          CretaMenuItem(
            iconData: Icons.group,
            caption: CretaLang['accountMenu']![1], // 팀전환
            onPressed: () {
              if (AccountManager.currentLoginUser.isLoginedUser == false) {
                BookMainPage.warningNeedToLogin(context);
                return;
              }
            },
          ),
          CretaMenuItem(
            iconData: Icons.info_outline,
            caption: CretaLang['accountMenu']![4], // 버전 정보
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const CretaVersionPopUp();
                  });
            },
          ),
          if (!kReleaseMode)
            CretaMenuItem(
              iconData: Icons.developer_mode_outlined,
              caption: CretaVars.instance.isDeveloper
                  ? CretaLang['accountMenu']![6]
                  : CretaLang['accountMenu']![5], //개발자모드
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const BassDemoPopUp();
                    });
                // CretaVars.instance.isDeveloper = !CretaVars.instance.isDeveloper;
                // invalidate?.call();
              },
            ),
        ],
      ),
    ];
  }
}
