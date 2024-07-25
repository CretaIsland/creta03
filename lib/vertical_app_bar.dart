import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:creta_user_model/model/user_property_model.dart';
//import 'package:get/get.dart';
import 'package:creta03/routes.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_const.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_vars.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

import 'data_io/enterprise_manager.dart';
import 'design_system/buttons/creta_button_wrapper.dart';
import 'design_system/component/snippet.dart';
//import 'design_system/menu/creta_popup_menu.dart';
import 'design_system/menu/creta_popup_menu.dart';
import 'lang/creta_mypage_lang.dart';
import 'pages/login/creta_account_manager.dart';
//import 'pages/studio/studio_getx_controller.dart';

class MyCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double xStart = 0;
    double xEnd = CretaConst.verticalAppbarWidth;
    double xWing = xEnd - 15;

    double yStart = 0;
    double yEnd = size.height;

    double yFirstButton = _buttonStartPoint();
    double yFirstButtonWingStart = yFirstButton + 15;
    double yFirstArcEnd = yFirstButtonWingStart + 2;
    double yFirstButtonWingEnd = yFirstArcEnd + 15;

    Paint paint = Paint()
      ..color = CretaColor.primary
      ..style = PaintingStyle.fill;
    Path path = Path()..moveTo(xEnd, yStart);
    path.lineTo(xEnd, yFirstButton);
    path.quadraticBezierTo(xEnd, yFirstButtonWingStart, xWing, yFirstButtonWingStart);
    path.arcToPoint(Offset(xWing, yFirstArcEnd),
        radius: const Radius.circular(2), clockwise: false);
    path.quadraticBezierTo(xEnd, yFirstArcEnd, xEnd, yFirstButtonWingEnd);
    path.lineTo(xEnd, yEnd);
    path.lineTo(xStart, yEnd);
    path.lineTo(xStart, yStart);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  double _buttonStartPoint() {
    switch (VerticalAppBar.appBarSelected) {
      case VerticalAppBarType.community:
        return 105;
      case VerticalAppBarType.studio:
        return 105 + 15 + 60;
      case VerticalAppBarType.device:
        return 105 + 15 + 60 + 15 + 60;
      case VerticalAppBarType.mypage:
        return 105 + 15 + 60 + 15 + 60 + 15 + 60;
      case VerticalAppBarType.admin:
        return 105 + 15 + 60 + 15 + 60 + 15 + 60 + 15 + 60;
    }
  }
}

enum VerticalAppBarType { community, studio, device, mypage, admin }

class VerticalAppBar extends StatefulWidget {
  static VerticalAppBarType appBarSelected = VerticalAppBarType.community;
  static bool fold = true;

  final Function onFoldButtonPressed;

  const VerticalAppBar({super.key, required this.onFoldButtonPressed});

  @override
  State<VerticalAppBar> createState() => _VerticalAppBarState();
}

class _VerticalAppBarState extends State<VerticalAppBar> {
  //BoolEventController? _foldSendEvent;
  List<Text> languageItemList = [];
  LanguageType oldLanguage = LanguageType.none;

  // static Future<bool>? isLangInit;

  // Future<bool>? initLang() async {
  //   UserPropertyModel? userModel = CretaAccountManager.userPropertyManagerHolder.userPropertyModel;
  //   if (userModel != null) {
  //     print('initLang-----------------------------------${userModel.language}');
  //     await Snippet.setLang(language : userModel.language);
  //   }
  //   _initMenu();
  //   return true;
  // }

  void _initMenu() {
    for (var element in CretaMyPageLang['languageList']!) {
      languageItemList.add(Text(element, style: CretaFont.bodyESmall));
    }
  }

  @override
  void initState() {
    //print('VertialAppBar init');
    super.initState();
    //final BoolEventController foldSendEvent = Get.find(tag: 'vertical-app-bar-to-creta-left-bar');
    //_foldSendEvent = foldSendEvent;
    //Snippet.clearLang();
    //isLangInit = initLang();
    _initMenu();

    String directory = AppRoutes.getFirstPath();
    switch (directory) {
      case 'community':
        VerticalAppBar.appBarSelected = VerticalAppBarType.community;
        break;
      case 'studio':
        VerticalAppBar.appBarSelected = VerticalAppBarType.studio;
        break;
      case 'device':
        VerticalAppBar.appBarSelected = VerticalAppBarType.device;
        break;
      case 'mypage':
        VerticalAppBar.appBarSelected = VerticalAppBarType.mypage;
        break;
      case 'admin':
        VerticalAppBar.appBarSelected = VerticalAppBarType.admin;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size displaySize = MediaQuery.of(context).size;
    // return FutureBuilder<bool>(
    //     future: isLangInit,
    //     builder: (context, snapshot) {
    //       if (snapshot.hasError) {
    //         //error가 발생하게 될 경우 반환하게 되는 부분
    //         logger.severe("data fetch error(WaitDatum)");
    //         return const Center(child: Text('data fetch error(WaitDatum)'));
    //       }
    //       if (snapshot.hasData == false) {
    //         //print('xxxxxxxxxxxxxxxxxxxxx');
    //         logger.finest("wait data ...(WaitData)");
    //         return Center(
    //           child: CretaSnippet.showWaitSign(),
    //         );
    //       }
    //       if (snapshot.connectionState == ConnectionState.done) {
    //         logger.finest("founded ${snapshot.data!}");
    //         // if (snapshot.data!.isEmpty) {
    //         //   return const Center(child: Text('no book founded'));
    //         // }

    return Consumer<UserPropertyManager>(builder: (context, userPropertyManager, child) {
      if (oldLanguage != userPropertyManager.userPropertyModel!.language) {
        oldLanguage = userPropertyManager.userPropertyModel!.language;
        _initMenu();
      }

      return Container(
          //padding: const EdgeInsets.only(top: 20),
          width: CretaConst.verticalAppbarWidth,
          color: displaySize.height > 200 ? CretaColor.text[100] : CretaColor.primary,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              if (displaySize.height > 200)
                CustomPaint(
                    size: Size(CretaConst.verticalAppbarWidth, displaySize.height),
                    painter: MyCustomPainter()),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //const SizedBox(height: 20),
                  Column(
                    children: [
                      if (displaySize.height > 100) titleLogoVertical(),
                      //const SizedBox(height: 32),
                      if (displaySize.height > 200) communityLogo(context),
                      if (displaySize.height > 250) const SizedBox(height: 12),
                      if (displaySize.height > 250) studioLogo(context),
                      if (displaySize.height > 300) const SizedBox(height: 12),
                      if (displaySize.height > 300) deviceLogo(context),
                      if (displaySize.height > 350) const SizedBox(height: 12),
                      if (displaySize.height > 350) myPageLogo(context),
                      if (displaySize.height > 400) const SizedBox(height: 12),
                      if (displaySize.height > 450 &&
                          (AccountManager.currentLoginUser.isSuperUser ||
                              EnterpriseManager.isAdmin(AccountManager.currentLoginUser.email)))
                        adminLogo(context),
                    ],
                  ),
                  if (displaySize.height > 450) _userInfoList(displaySize),
                ],
              ),
            ],
          ));
    });
    //   }
    //   return const SizedBox.shrink();
    // });
  }

  Widget titleLogoVertical() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImage('assets/creta_logo_only_white.png'),
            //width: 120,
            height: 20,
          ),
          Text(
            CretaVars.instance.serviceTypeString(),
            style: CretaFont.logoStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _communityLogoPressed() {
    VerticalAppBar.appBarSelected = VerticalAppBarType.community;
    VerticalAppBar.fold = false;
    CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
    Routemaster.of(context).push(AppRoutes.communityHome);
    //_foldSendEvent?.sendEvent(false);
    //widget.onFoldButtonPressed();
  }

  Widget communityLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          size: const Size(40, 40),
          iconSize: 24,
          icon: Icons.language,
          onPressed: _communityLogoPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: TextButton(
            onPressed: _communityLogoPressed,
            child: Text("Community", style: CretaFont.logoStyle.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _studioLogoPressed() {
    VerticalAppBar.appBarSelected = VerticalAppBarType.studio;
    VerticalAppBar.fold = false;
    CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
    //_foldSendEvent?.sendEvent(false);
    Routemaster.of(context).push(AppRoutes.studioBookGridPage);
    //widget.onFoldButtonPressed();
  }

  Widget studioLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.edit_note_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: _studioLogoPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: TextButton(
            onPressed: _studioLogoPressed,
            child: Text(
              "Studio", //CretaDeviceLang['studio']!,
              style: CretaFont.logoStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _deviceLogoPressed() {
    VerticalAppBar.appBarSelected = VerticalAppBarType.device;
    VerticalAppBar.fold = false;
    //_foldSendEvent?.sendEvent(false);
    CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
    Routemaster.of(context).push(AppRoutes.deviceMainPage);
    //widget.onFoldButtonPressed();
  }

  Widget deviceLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.tv_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: _deviceLogoPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: TextButton(
            onPressed: _deviceLogoPressed,
            child: Text(
              "Devices", //CretaDeviceLang['device']!,
              style: CretaFont.logoStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _myPageLogoPressed() {
    VerticalAppBar.appBarSelected = VerticalAppBarType.mypage;
    VerticalAppBar.fold = false;
    //_foldSendEvent?.sendEvent(false);
    CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
    Routemaster.of(context).push(AppRoutes.myPageDashBoard);
    //widget.onFoldButtonPressed();
  }

  Widget myPageLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.person_outline,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: _myPageLogoPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: TextButton(
            onPressed: _myPageLogoPressed,
            child: Text(
              "My Page", //CretaDeviceLang['admin']!,
              style: CretaFont.logoStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _adminLogoPressed() {
    VerticalAppBar.appBarSelected = VerticalAppBarType.admin;
    VerticalAppBar.fold = false;
    //_foldSendEvent?.sendEvent(false);
    CretaComponentLocation.TabBar.width = 310.0 - CretaConst.verticalAppbarWidth;
    Routemaster.of(context).push(AppRoutes.adminMainPage);
    //widget.onFoldButtonPressed();
  }

  Widget adminLogo(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        BTN.fill_blue_i_l(
          icon: Icons.admin_panel_settings_outlined,
          size: const Size(40, 40),
          iconSize: 24,
          onPressed: _adminLogoPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 34),
          child: TextButton(
            onPressed: _adminLogoPressed,
            child: Text(
              "Admin", //CretaDeviceLang['admin']!,
              style: CretaFont.logoStyle.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _userInfoList(Size displaySize) {
    return Padding(
      padding: EdgeInsets.only(bottom: displaySize.height > 600 ? 152 : 50),
      //padding: const EdgeInsets.only(top: 34),
      child: Column(
        children: (!AccountManager.currentLoginUser.isLoginedUser)
            ? [
                Snippet.loginButton(context: context, getBuildContext: () {}),
                Snippet.signUpButton(context: context, getBuildContext: () {}),
              ]
            : [
                Snippet.notiBell(context: context),
                const SizedBox(height: 10),
                Snippet.smallUserInfo(context: context),
                _langSetting(displaySize),
              ],
      ),
    );
  }

  Widget _langSetting(Size displaySize) {
    UserPropertyModel? userModel = CretaAccountManager.userPropertyManagerHolder.userPropertyModel;
    if (userModel != null) {
      String langStr = CretaMyPageLang['languageList']![
          userModel.language.index > 0 ? userModel.language.index - 1 : 0];

      if (langStr.length > 3) {
        langStr = langStr.substring(0, 3);
      }
      //print('${userModel.language.index}--------------------------------------------');
      //print('$langStr--------------------------------------------');

      const GlobalObjectKey langSettingKey = GlobalObjectKey('_langSettingKey');

      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: TextButton(
          key: langSettingKey,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
                if (states.contains(WidgetState.hovered)) {
                  return Colors.white.withOpacity(0.3);
                }
                if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
                  return Colors.white.withOpacity(0.5);
                }
                return null; // Defer to the widget's default.
              },
            ),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
          ),
          child: Text(
            langStr,
            style: CretaFont.buttonLarge.copyWith(color: Colors.white),
          ),
          onPressed: () {
            _popupLanguageMenu(langSettingKey, context, xOffset: 72, yOffset: -190);
          },
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _popupLanguageMenu(GlobalKey key, BuildContext context,
      {double xOffset = 0, double yOffset = 0}) {
    CretaPopupMenu.showMenu(
      context: context,
      globalKey: key,
      xOffset: xOffset,
      yOffset: yOffset,
      popupMenu: (CretaMyPageLang['languageList']!)
          .asMap()
          .map((index, lang) {
            return MapEntry(
                index,
                CretaMenuItem(
                  caption: lang,
                  onPressed: () {
                    Snippet.onLangSelected(
                      value: index + 1,
                      userPropertyManager: CretaAccountManager.userPropertyManagerHolder,
                      invalidate: () {
                        setState(() {});
                        // print(
                        //     'language : ${CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language}, ${CretaAccountManager.userPropertyManagerHolder.userPropertyModel!.language.index}');
                        CretaAccountManager.userPropertyManagerHolder.notify();
                      },
                    );
                    Routemaster.of(context).pop();
                  },
                ));
          })
          .values
          .toList()
          .cast<CretaMenuItem>(),
      initFunc: () {},
    ).then((value) {
      logger.finest('팝업메뉴 닫기');
    });
  }
}
