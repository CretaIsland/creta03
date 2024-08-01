// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';

//import '../../common/window_resize_lisnter.dart';
import 'package:hycop/common/util/logger.dart';

import '../../design_system/component/creta_basic_layout_mixin.dart';
import '../../design_system/component/creta_popup.dart';
import '../../design_system/component/snippet.dart';
import '../../design_system/menu/creta_popup_menu.dart';
import '../../lang/creta_device_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../routes.dart';
import '../login/creta_account_manager.dart';
import 'enterprise_list_widget.dart';
import 'team_list_widget.dart';
import 'user_list_widget.dart';
//import '../login_page.dart';

// EnterpriseSelectNotifier selectNotifierHolder = EnterpriseSelectNotifier();

// class EnterpriseSelectNotifier extends ChangeNotifier {
//   Map<String, bool> _selectedItems = {};
//   Map<String, GlobalKey<EnterpriseGridItemState>> _selectedKey = {};

//   GlobalKey<EnterpriseGridItemState> getKey(String mid) {
//     if (_selectedKey[mid] == null) {
//       _selectedKey[mid] = GlobalKey<EnterpriseGridItemState>();
//     }
//     return _selectedKey[mid]!;
//   }

//   void selected(String mid, bool value) {
//     _selectedItems[mid] = value;
//     notify(mid);
//   }

//   void toggleSelect(String mid) {
//     _selectedItems[mid] = !(_selectedItems[mid] ?? true);
//     notify(mid);
//   }

//   bool isSelected(String mid) {
//     return _selectedItems[mid] ?? false;
//   }

//   bool hasSelected() {
//     return _selectedItems.values.contains(true);
//   }

//   void notify(String mid) {
//     notifyListeners();
//     _selectedKey[mid]?.currentState?.notify(mid);
//   }

//   void delete(String mid) {
//     _selectedItems.remove(mid);
//   }

//   void init(EnterpriseManager enterpriseMangaer) {
//     for (var model in enterpriseMangaer.modelList) {
//       _selectedItems[model.mid] = false;
//     }
//     //_selectedItems = List.generate(length, (index) => false);
//   }

//   void add(String mid, bool value) {
//     _selectedItems[mid] = value;
//   }

//   int get length => _selectedItems.length;
// }

enum AdminSelectedPage {
  none,
  enterprise,
  team,
  user,
  end;
}

// ignore: must_be_immutable
class AdminMainPage extends StatefulWidget {
  final AdminSelectedPage selectedPage;
  const AdminMainPage({Key? key, required this.selectedPage}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();

  static void showSelectEnterpriseWarnning(BuildContext context) {
    // superAdmin 인데, Enterprise 가 없으면, Enterprise 선택 pop up dialog 띄우기
    if (AccountManager.currentLoginUser.isSuperUser && CretaAccountManager.getEnterprise == null) {
      Future.delayed(Duration.zero, () {
        CretaPopup.simple(
          context: context,
          title: "Warning : No Enterprise Selected",
          icon: Icons.warning_amber_outlined,
          question: CretaDeviceLang['chooseEnterprise'] ?? 'Choose Enterprise',
          yesBtText: 'OK',
          yesIsDefault: true,
          onYes: () {},
        );
      });
    }
  }
}

class _AdminMainPageState extends State<AdminMainPage> with CretaBasicLayoutMixin {
  late List<CretaMenuItem> _leftMenuItemList;
  AdminSelectedPage _selectedPage = AdminSelectedPage.enterprise;

  bool dropDownButtonOpened = false;
  GlobalKey dropDownButtonKey = GlobalKey();

  LanguageType oldLanguage = LanguageType.none;

  List<String> filterTexts = [];

  static Future<bool>? isLangInit;

  @override
  void initState() {
    logger.fine('initState start');

    super.initState();

    _selectedPage = widget.selectedPage;
    setUsingBannerScrollBar(
      scrollChangedCallback: _scrollListener,
      // bannerMaxHeight: 196 + 200,
      // bannerMinHeight: 196,
    );

    isLangInit = initLang();
    logger.fine('initState end');

    afterBuild();
  }

  Future<void> afterBuild() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      AdminMainPage.showSelectEnterpriseWarnning(context);
    });
  }

  void _initMenu() {
    _leftMenuItemList = [
      // CretaMenuItem(
      //   caption: CretaDeviceLang['license']!,
      //   onPressed: () {
      //     //Routemaster.of(context).push(AppRoutes.studioAdminMainPage);
      //     //AdminMainPage.lastGridMenu = AppRoutes.studioBookSharedPage;
      //   },
      //   selected: widget._selectedPage == AdminSelectedPage.license,
      //   iconData: Icons.admin_panel_settings_outlined,
      //   iconSize: 20,
      //   isIconText: true,
      // ),
      CretaMenuItem(
        caption: CretaDeviceLang['enterprise']!,
        onPressed: () {
          //Routemaster.of(context).push(AppRoutes.adminMainPage);
          setState(() {
            _selectedPage = AdminSelectedPage.enterprise;
          });
          AdminMainPage.showSelectEnterpriseWarnning(context);
        },
        selected: _selectedPage == AdminSelectedPage.enterprise,
        iconData: Icons.business_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['teamManage'] ?? 'Team Management',
        onPressed: () {
          setState(() {
            _selectedPage = AdminSelectedPage.team;
          });
          AdminMainPage.showSelectEnterpriseWarnning(context);
        },
        selected: _selectedPage == AdminSelectedPage.team,
        iconData: Icons.groups_2_outlined,
        iconSize: 20,
        isIconText: true,
      ),
      CretaMenuItem(
        caption: CretaDeviceLang['userManage'] ?? 'User Management',
        onPressed: () {
          setState(() {
            _selectedPage = AdminSelectedPage.user;
          });
          AdminMainPage.showSelectEnterpriseWarnning(context);
        },
        selected: _selectedPage == AdminSelectedPage.user,
        iconData: Icons.person_2_outlined,
        iconSize: 20,
        isIconText: true,
      ),
    ];

    // _dropDownMenuItemList1 = getFilterMenu((() => setState(() {})));
    // _dropDownMenuItemList2 = getSortMenu((() => setState(() {})));
    // _dropDownMenuItemList3 = getConnectedFilterMenu((() => setState(() {})));
    // _dropDownMenuItemList4 = getUsageFilterMenu((() => setState(() {})));
  }

  void _scrollListener(bool bannerSizeChanged) {}

  @override
  void dispose() {
    logger.finest('_AdminMainPageState dispose');
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  Future<bool>? initLang() async {
    await Snippet.setLang();
    _initMenu();
    oldLanguage = CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //double windowWidth = MediaQuery.of(context).size.width;
    //logger.fine('`````````````````````````window width = $windowWidth');

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserPropertyManager>.value(
            value: CretaAccountManager.userPropertyManagerHolder),
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
              return Consumer<UserPropertyManager>(
                  builder: (context, userPropertyManager, childWidget) {
                if (oldLanguage != userPropertyManager.userPropertyModel!.language) {
                  oldLanguage = userPropertyManager.userPropertyModel!.language;
                  _initMenu();
                }
                return Snippet.CretaScaffold(
                    //title: Snippet.logo(CretaVars.instance.serviceTypeString()),
                    onFoldButtonPressed: () {
                      setState(() {});
                    },

                    // additionals: SizedBox(
                    //   height: 36,
                    //   width: windowWidth > 535 ? 130 : 60,
                    //   child: BTN.fill_gray_it_l(
                    //     width: windowWidth > 535 ? 106 : 36,
                    //     text: windowWidth > 535 ? CretaStudioLang['newBook']! : '',
                    //     onPressed: () {
                    //       Routemaster.of(context).push(AppRoutes.communityHome);
                    //     },
                    //     icon: Icons.add_outlined,
                    //   ),
                    // ),
                    context: context,
                    child: mainPage(
                      context,
                      key: GlobalObjectKey('adminMainPage_$_selectedPage'),
                      scrollbarOnRight: false,
                      gotoButtonPressed: () {
                        Routemaster.of(context).push(AppRoutes.communityHome);
                      },
                      gotoButtonTitle: CretaStudioLang['gotoCommunity']!,
                      leftMenuItemList: _leftMenuItemList,
                      bannerTitle: getAdminTitle(),
                      bannerDescription: getAdminDesc(),
                      listOfListFilter: [
                        // _dropDownMenuItemList1,
                        // _dropDownMenuItemList2,
                        // _dropDownMenuItemList3,
                        // _dropDownMenuItemList4
                      ],
                      onSearch: (value) {
                        //   if (_isGridView) {
                        //     EnterpriseManager.instance.onSearch(value, () => setState(() {}));
                        //   } else {
                        //     //print('onSearch : value = $value');
                        setState(() {
                          filterTexts = value.trim().split(' ');
                        });
                        //   }
                      },
                      mainWidget: (_) {
                        switch (_selectedPage) {
                          case AdminSelectedPage.enterprise:
                            return EnterpriseListWidget(
                                width: rightPaneRect.childWidth,
                                height: rightPaneRect.childHeight - 46);
                          case AdminSelectedPage.team:
                            return TeamListWidget(
                              width: rightPaneRect.childWidth,
                              height: rightPaneRect.childHeight - 46,
                              enterprise: CretaAccountManager.getEnterprise,
                            );
                          case AdminSelectedPage.user:
                            return UserListWidget(
                              width: rightPaneRect.childWidth,
                              height: rightPaneRect.childHeight - 46,
                              enterprise: CretaAccountManager.getEnterprise,
                              filterTexts: filterTexts,
                            );
                          default:
                            return EnterpriseListWidget(
                                width: rightPaneRect.childWidth,
                                height: rightPaneRect.childHeight - 46);
                        }
                      }, // _bookGrid, //_bookGrid(context),
                      onFoldButtonPressed: () {
                        setState(() {});
                      },
                    ));
              });
            }
            return const SizedBox.shrink();
          }),
    );
  }

  String getAdminTitle() {
    switch (_selectedPage) {
      // case AdminSelectedPage.license:
      //   return CretaDeviceLang['license']!;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang['enterprise']!;
      case AdminSelectedPage.team:
        return CretaDeviceLang['teamManage'] ?? 'Team Management';
      default:
        return CretaDeviceLang['userManage'] ?? 'User Management';
    }
  }

  String getAdminDesc() {
    switch (_selectedPage) {
      // case AdminSelectedPage.license:
      //   return CretaDeviceLang['myCretaAdminDesc']!;
      case AdminSelectedPage.enterprise:
        return CretaDeviceLang['enterpriseDesc']!;
      case AdminSelectedPage.team:
        return CretaDeviceLang['teamDesc'] ?? 'Manage your team information';
      default:
        return CretaDeviceLang['myCretaAdminDesc']!;
    }
  }
}
