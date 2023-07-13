// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:creta03/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
import 'package:hycop/hycop.dart';
import '../../common/creta_constant.dart';
import '../../lang/creta_lang.dart';
import '../../lang/creta_studio_lang.dart';
import '../../pages/studio/book_main_page.dart';
import '../../pages/studio/containees/frame/sticker/draggable_stickers.dart';
import '../../pages/studio/studio_variables.dart';
import '../../routes.dart';
import '../creta_color.dart';
import '../creta_font.dart';
import '../buttons/creta_button_wrapper.dart';
import '../menu/creta_drop_down.dart';
import '../menu/creta_popup_menu.dart';
import '../../pages/login/login_dialog.dart';

// get widgets Global Size and Position
extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    if (currentContext == null) return null;
    try {
      final renderObject = currentContext?.findRenderObject();
      if (renderObject == null) return null;
      final translation = renderObject.getTransformTo(null).getTranslation();
      final offset = Offset(translation.x, translation.y);
      return renderObject.paintBounds.shift(offset);
    } catch (e) {
      logger.warning('*****************${e.toString()}');
    }
    return null;
  }
}

class Snippet {
  static List<LogicalKeyboardKey> keys = [];

  static Widget showWaitSign({double size = 40.0}) {
    return LoadingAnimationWidget.fourRotatingDots(
      color: CretaColor.primary,
      size: 40.0,
    );
  }

  static Widget errMsgWidget(AsyncSnapshot<Object> snapshot) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        'Error: ${snapshot.error}',
        style: const TextStyle(fontSize: 8),
      ),
    );
  }

  static Widget defaultImage = Image.asset('creta_default.png', fit: BoxFit.cover);

  static Widget SvgIcon({
    required String iconImageFile,
    required double iconSize,
    required Color? iconColor,
  }) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: iconSize,
      child: SvgPicture.asset(
        iconImageFile,
        fit: BoxFit.contain,
        width: iconSize,
        height: iconSize,
        // ignore: deprecated_member_use
        color: iconColor,
      ),
    );
  }

  static Widget CretaScaffold({
    required Widget title,
    required BuildContext context,
    required Widget child,
    Widget? floatingActionButton,
    Widget? additionals,
  }) {
    return Scaffold(
        appBar: Snippet.CretaAppBarOfStudio(context, title, additionals),
        //floatingActionButton: floatingActionButton ?? Snippet.CretaDial(context),
        //floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        //body: child,
        body: StudioVariables.isHandToolMode == false
            ? GestureDetector(
                behavior: HitTestBehavior.opaque,
                onLongPressDown: ((details) {
                  //LastClicked.clickedOutSide(details.globalPosition);
                  if (BookMainPage.outSideClick == false) {
                    BookMainPage.outSideClick = true;
                    return;
                  }
                  print(
                      'space clicked ${details.globalPosition}-------------------------------------------');
                  DraggableStickers.frameSelectNotifier?.set("", doNotify: true);
                  BookMainPage.miniMenuNotifier?.set(false, doNoti: true);
                }),
                child: child,
              )
            : child);
  }

  static Widget CretaScaffoldOfCommunity({
    required Widget title,
    required BuildContext context,
    required Widget child,
    // Function? doAfterLogin,
    // Function? doAfterSignup,
    // Function(String)? onErrorReport,
    required Function getBuildContext,
  }) {
    return Scaffold(
      appBar: Snippet.CretaAppBarOfCommunity(
        context: context,
        title: title,
        // doAfterLogin: doAfterLogin,
        // doAfterSignup: doAfterSignup,
        // onErrorReport: onErrorReport,
        getBuildContext: getBuildContext,
      ),
      //floatingActionButton: Snippet.CretaDial(context),
      body:
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onLongPressDown: ((details) {
          //     logger.finest('onLongPressDown');
          //     LastClicked.clickedOutSide(details.globalPosition);
          //   }),
          //   child:
          Container(
        child: child,
      ),
      //),
    );
  }

  static PreferredSizeWidget CretaAppBarOfCommunity({
    required BuildContext context,
    required Widget title,
    // Function? doAfterLogin,
    // Function? doAfterSignup,
    // Function(String)? onErrorReport,
    required Function getBuildContext,
  }) {
    return AppBar(
      title: title,
      toolbarHeight: CretaConstant.appbarHeight,
      backgroundColor: Colors.white,
      shadowColor: Colors.grey[500],
      actions: (!AccountManager.currentLoginUser.isLoginedUser)
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Center(
                  child: SizedBox(
                    height: 36,
                    child: BTN.fill_blue_t_l(
                      //key: GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'),
                      buttonColor: CretaButtonColor.white,
                      //fgColor: CretaColor.text[700]!,
                      height: 36,
                      text: '로그인',
                      //image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      //image:
                      //    NetworkImage(LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg),
                      textStyle: CretaFont.buttonLarge.copyWith(color: CretaColor.text[700]),
                      onPressed: () {
                        // _popupAccountMenu(
                        //     GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'), context);
                        LoginDialog.popupDialog(
                          context: context,
                          // doAfterLogin: doAfterLogin,
                          // doAfterSignup: doAfterSignup,
                          // onErrorReport: onErrorReport,
                          getBuildContext: getBuildContext,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: Center(
                  child: SizedBox(
                    width: 112,
                    height: 36,
                    child: BTN.fill_blue_ti_l(
                      //key: GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'),
                      //buttonColor: CretaButtonColor.white,
                      //fgColor: CretaColor.text[700]!,
                      width: 112,
                      text: '회원가입',
                      icon: Icons.arrow_forward,
                      //image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                      //image:
                      //    NetworkImage(LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg),
                      onPressed: () {
                        LoginDialog.popupDialog(
                          context: context,
                          // doAfterLogin: doAfterLogin,
                          // onErrorReport: onErrorReport,
                          getBuildContext: getBuildContext,
                          loginPageState: LoginPageState.singup,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]
          : [
              // new book
              Center(
                child: SizedBox(
                  height: 36,
                  width: 130,
                  child: BTN.fill_gray_it_l(
                    text: CretaStudioLang.newBook,
                    buttonColor: CretaButtonColor.blueAndWhiteTitle,
                    textColor: Colors.white,
                    onPressed: () {
                      Routemaster.of(context).push(AppRoutes.studioBookMainPage);
                    },
                    icon: Icons.add_outlined,
                  ),
                ),
              ),
              SizedBox(width: 8),
              // noti
              Center(
                child: SizedBox(
                  height: 36,
                  child: BTN.fill_blue_i_l(
                    //tooltip: CretaStudioLang.tooltipNoti,
                    icon: Icons.notifications_outlined,
                    buttonColor: CretaButtonColor.white,
                    iconColor: CretaColor.text[700],
                    onPressed: () {},
                  ),
                ),
              ),
              SizedBox(width: 5),
              // user info
              Center(
                child: SizedBox(
                  height: 40,
                  child: BTN.fill_gray_iti_l(
                    key: GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'),
                    buttonColor: CretaButtonColor.white,
                    fgColor: CretaColor.text[700]!,
                    text: AccountManager.currentLoginUser.name,
                    icon: Icons.arrow_drop_down_outlined,
                    image: NetworkImage(
                        'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                    //image:
                    //    NetworkImage(LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg),
                    onPressed: () {
                      _popupAccountMenu(
                          GlobalObjectKey('CretaAppBarOfCommunity.BTN.fill_gray_iti_l'), context);
                    },
                  ),
                ),
              ),
              SizedBox(width: 20),
            ],
    );
  }

  // MyPage Scaffold
  static Widget CretaScaffoldOfMyPage(
      {required Widget title, required BuildContext context, required Widget child}) {
    return Scaffold(
      appBar: Snippet.CretaAppBarOfMyPage(context, title),
      //floatingActionButton: Snippet.CretaDial(context),
      body:
          // GestureDetector(
          //   behavior: HitTestBehavior.opaque,
          //   onLongPressDown: ((details) {
          //     logger.finest('onLongPressDown');
          //     LastClicked.clickedOutSide(details.globalPosition);
          //   }),
          //   child:
          Container(
        child: child,
      ),
      //),
    );
  }

  // Creta MyPage AppBar
  static PreferredSizeWidget CretaAppBarOfMyPage(BuildContext context, Widget title) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey[500],
      title: title,
      toolbarHeight: 60,
      actions: [
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 44,
                height: 36,
                child: Icon(
                  Icons.notifications_outlined,
                  color: Colors.grey[700],
                  size: 20,
                ),
              )
            ],
          ),
        ),
        SizedBox(
            child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration:
                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  clipBehavior: Clip.hardEdge,
                  child: Container(color: Colors.green))
            ],
          ),
        )),
        SizedBox(width: 8),
        CretaDropDown(
            width: 130,
            height: 40,
            items: const ["사용자 닉네임1", "사용자 닉네임2", "사용자 닉네임3"],
            defaultValue: "사용자 닉네임1",
            onSelected: (value) {
              logger.finest(value);
            }),
        SizedBox(width: 40)
      ],
    );
  }

  static Widget logo(String title, {void Function()? route}) {
    return Row(children: [
      // SizedBox(
      //   width: 24,
      // ),
      GestureDetector(
        onLongPressDown: (d) {
          route?.call();
        },
        child: Image(
          image: AssetImage('assets/logo_en.png'),
          height: 20,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 6.0, top: 6.0),
        child: Text(
          title,
          style: CretaFont.titleSmall.copyWith(color: Colors.white),
        ),
      ),
    ]);
  }

  static void _popupAccountMenu(GlobalKey key, BuildContext context) {
    CretaPopupMenu.showMenu(
      context: context,
      globalKey: key,
      xOffset: -60,
      popupMenu: [
        CretaMenuItem(
          caption: CretaLang.accountMenu[0], // 마이페이지
          onPressed: () {
            Routemaster.of(context).push(AppRoutes.myPageDashBoard);
          },
        ),
        CretaMenuItem(
          caption: CretaLang.accountMenu[1], // 팀전환
          onPressed: () {},
        ),
        CretaMenuItem(
          caption: CretaLang.accountMenu[2], // 로그아웃
          onPressed: () {
            LoginPage.logout().then((value) => Routemaster.of(context).push(AppRoutes.login));
          },
        ),
        CretaMenuItem(
          caption: CretaLang.accountMenu[3], //도움말
          onPressed: () {},
        ),
      ],
      initFunc: () {},
    ).then((value) {
      logger.finest('팝업메뉴 닫기');
    });
  }

  static PreferredSizeWidget CretaAppBarOfStudio(
      BuildContext context, Widget title, Widget? additionals) {
    return AppBar(
      toolbarHeight: CretaConstant.appbarHeight,
      title: title,
      actions: [
        Center(
          child: additionals ?? Container(),
        ),
        SizedBox(width: 15),
        (!AccountManager.currentLoginUser.isLoginedUser)
            ? SizedBox.shrink()
            : Center(
                child: SizedBox(
                  height: 36,
                  child: BTN.fill_blue_i_l(
                    tooltip: CretaStudioLang.tooltipNoti,
                    onPressed: () {},
                    icon: Icons.notifications_outlined,
                  ),
                ),
              ),
        SizedBox(
          width: 10,
        ),
        (!AccountManager.currentLoginUser.isLoginedUser)
            ? SizedBox.shrink()
            : Center(
                child: SizedBox(
                  height: 40,
                  // child: BTN.fill_gray_wti_l(
                  //   buttonColor: CretaButtonColor.blue,
                  //   text: AccountManager.currentLoginUser.name,
                  //   icon: Icons.arrow_drop_down_outlined,
                  //   leftWidget: LoginPage.userPropertyManagerHolder!.profileImageBox(
                  //     radius: 28,
                  //   ),
                  //   onPressed: () {},
                  // ),
                  child: BTN.fill_gray_iti_l(
                    key: GlobalObjectKey('CretaAppBarOfStudio.BTN.fill_gray_iti_l'),
                    buttonColor: CretaButtonColor.blue,
                    //text: AccountManager.currentLoginUser.name,
                    text: LoginPage.userPropertyManagerHolder!.userPropertyModel!.nickname,
                    icon: Icons.arrow_drop_down_outlined,
                    // image: NetworkImage(
                    //     'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                    image: NetworkImage(
                        LoginPage.userPropertyManagerHolder!.userPropertyModel!.profileImg),
                    onPressed: () {
                      _popupAccountMenu(
                          GlobalObjectKey('CretaAppBarOfStudio.BTN.fill_gray_iti_l'), context);
                    },
                  ),
                ),
              ),
        SizedBox(
          width: 20,
        ),
      ],
    );
  }

  static PreferredSizeWidget MyCretaAppBarOfStudio(BuildContext context, Widget title) {
    return PreferredSize(
        preferredSize: Size.fromHeight(CretaConstant.appbarHeight),
        child: Row(
          children: [
            title,
            Center(
              child: SizedBox(
                height: 36,
                width: 200,
                child: BTN.fill_gray_it_l(
                  text: CretaStudioLang.newBook,
                  onPressed: () {
                    Routemaster.of(context).push(AppRoutes.studioBookMainPage);
                  },
                  icon: Icons.add_outlined,
                ),
              ),
            ),
            Center(
              child: SizedBox(
                height: 36,
                child: BTN.fill_blue_i_l(
                  tooltip: CretaStudioLang.tooltipNoti,
                  onPressed: () {},
                  icon: Icons.notifications_outlined,
                ),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Center(
              child: SizedBox(
                height: 40,
                child: BTN.fill_gray_iti_l(
                  key: GlobalObjectKey('MyCretaAppBarOfStudio.BTN.fill_gray_iti_l'),
                  buttonColor: CretaButtonColor.blue,
                  text: AccountManager.currentLoginUser.name,
                  icon: Icons.arrow_drop_down_outlined,
                  image:
                      NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
                  onPressed: () {
                    _popupAccountMenu(
                        GlobalObjectKey('MyCretaAppBarOfStudio.BTN.fill_gray_iti_l'), context);
                  },
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ));
  }

  static PreferredSizeWidget CretaAppBar(BuildContext context, String title) {
    return AppBar(
      toolbarHeight: CretaConstant.appbarHeight,
      title: Text(title),
      actions: AccountManager.currentLoginUser.isLoginedUser
          ? [
              ElevatedButton.icon(
                onPressed: () {
                  Routemaster.of(context).push(AppRoutes.intro);
                },
                icon: Icon(
                  Icons.person,
                  //size: 24.0,
                ),
                label: Text('+ 새 크레타북'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  AccountManager.logout().then((value) {
                    Routemaster.of(context).push(AppRoutes.intro);
                  });
                  //Routemaster.of(context).push(AppRoutes.intro);
                },
                icon: Icon(
                  Icons.person,
                  //size: 24.0,
                ),
                label: Text(AccountManager.currentLoginUser.name),
              )
            ]
          : [
              ElevatedButton.icon(
                onPressed: () {
                  Routemaster.of(context).push(AppRoutes.login);
                },
                icon: Icon(
                  Icons.person,
                  //size: 24.0,
                ),
                label: Text('Log in'),
              ),
            ],
    );
  }

  static Widget CretaDial(BuildContext context) {
    return SpeedDial(
      //key: GlobalKey(),
      animatedIcon: AnimatedIcons.menu_close,
      childrenButtonSize: const Size(48, 48),
      children: [
        SpeedDialChild(
          child: Icon(Icons.house),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.intro);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.login),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.login);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.text_fields_outlined),
          onTap: () {
            //Routemaster.of(context).push(AppRoutes.fontDemoPage);
            dummy(context);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.radio_button_checked),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.buttonDemoPage);
          },
        ),
        // SpeedDialChild(
        //   child: Icon(Icons.abc_outlined),
        //   onTap: () {
        //     Routemaster.of(context).push(AppRoutes.quillDemoPage);
        //   },
        // ),
        SpeedDialChild(
          child: Icon(Icons.smart_button),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.textFieldDemoPage);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.menu_book),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.menuDemoPage);
          },
        ),
        // SpeedDialChild(
        //   label: 'Studio Book',
        //   child: Icon(Icons.stadium),
        //   onTap: () {
        //     Routemaster.of(context).push(AppRoutes.studioBookMainPage);
        //   },
        // ),
        SpeedDialChild(
          label: 'Studio Book List',
          child: Icon(Icons.list_alt_outlined),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.studioBookGridPage);
          },
        ),
        SpeedDialChild(
          label: 'Community Home',
          child: Icon(Icons.explore),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.communityHome);
          },
        ),
        SpeedDialChild(
          label: 'Channel',
          child: Icon(Icons.category_outlined),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.channel);
          },
        ),
        // SpeedDialChild(
        //   label: 'Subscription List',
        //   child: Icon(Icons.subscriptions),
        //   onTap: () {
        //     Routemaster.of(context).push(AppRoutes.subscriptionList);
        //   },
        // ),
        SpeedDialChild(
          label: 'Playlist',
          child: Icon(Icons.playlist_add_check),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.playlist);
          },
        ),
        SpeedDialChild(
          label: 'Playlist Detail',
          child: Icon(Icons.playlist_play_outlined),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.playlistDetail);
          },
        ),
        SpeedDialChild(
          label: 'colorPickerDemoPage',
          child: Icon(Icons.colorize),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.colorPickerDemo);
          },
        ),
        SpeedDialChild(
          label: 'My Page',
          child: Icon(Icons.person),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.myPageDashBoard);
          },
        ),
      ],
    );
  }

  static Future<void> dummy(BuildContext context) async {
    Routemaster.of(context).push(AppRoutes.fontDemoPage);
  }

  static void keyEventHandler(RawKeyEvent event) {
    final key = event.logicalKey;
    logger.finest('key pressed $key');
    if (event is RawKeyDownEvent) {
      if (keys.contains(key)) return;
      // textField 의 focus bug 때문에, delete  key 를 사용할 수 없다.
      // if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
      //   logger.finest('delete pressed');
      //   accManagerHolder!.removeACC(context);
      // }
      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
        logger.finest('tab pressed');
      }
      keys.add(key);
      // Ctrl Key Area
      if ((keys.contains(LogicalKeyboardKey.controlLeft) ||
          keys.contains(LogicalKeyboardKey.controlRight))) {
        if (keys.contains(LogicalKeyboardKey.keyZ)) {
          logger.finest('Ctrl+Z pressed');
        }
      }
    } else {
      keys.remove(key);
    }
  }

  static Widget CretaTabBar(List<CretaMenuItem> menuItem, double height) {
    double userMenuHeight = height -
        CretaComponentLocation.TabBar.padding.top -
        CretaComponentLocation.TabBar.padding.bottom;
    if (userMenuHeight > CretaComponentLocation.UserMenuInTabBar.height) {
      userMenuHeight = CretaComponentLocation.UserMenuInTabBar.height;
    }

    return Container(
      width: CretaComponentLocation.TabBar.width,
      height: height,
      color: Colors.grey[100],
      padding: CretaComponentLocation.TabBar.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                padding: CretaComponentLocation.ListInTabBar.padding,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Wrap(
                    direction: Axis.vertical,
                    spacing: 8, // <-- Spacing between children
                    children: <Widget>[
                      ...menuItem
                          .map((item) =>
                              // BTN.fill_color_ic_el
                              SizedBox(
                                width: 246,
                                height: 56,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return const Color.fromARGB(255, 249, 249, 249);
                                        }
                                        return (item.selected ? Colors.white : Colors.grey[100]);
                                      },
                                    ),
                                    elevation: MaterialStateProperty.all<double>(0.0),
                                    shadowColor:
                                        MaterialStateProperty.all<Color>(Colors.transparent),
                                    foregroundColor: MaterialStateProperty.resolveWith<Color?>(
                                      (Set<MaterialState> states) {
                                        if (states.contains(MaterialState.hovered)) {
                                          return Colors.blue[400];
                                        }
                                        return (item.selected
                                            ? Colors.blue[400]
                                            : Colors.grey[700]);
                                      },
                                    ),
                                    backgroundColor: MaterialStateProperty.all<Color>(
                                        item.selected ? Colors.white : Colors.grey[100]!),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(38.0),
                                            side: BorderSide(
                                                color: item.selected
                                                    ? Colors.white
                                                    : Colors.grey[100]!))),
                                  ),
                                  onPressed: () => item.onPressed?.call(),
                                  child: SizedBox(
                                      width: double.infinity,
                                      height: 24,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Icon(item.iconData),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Text(
                                            item.caption,
                                            style: const TextStyle(
                                              //color: Colors.blue[400],
                                              fontSize: 20,
                                              fontFamily: 'Pretendard',
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ))
                          .toList(),
                    ],
                  );
                }),
          ),

          //하단 사용자 메뉴
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              // crop
              borderRadius: BorderRadius.circular(19.2),
            ),
            clipBehavior: Clip.antiAlias, // crop method
            width: CretaComponentLocation.UserMenuInTabBar.width,
            height: userMenuHeight, //CretaComponentLocation.UserMenuInTabBar.height,
            padding: CretaComponentLocation.UserMenuInTabBar.padding,
            child: ListView.builder(
                //padding: EdgeInsets.fromLTRB(leftMenuViewLeftPane, leftMenuViewTopPane, 0, 0),
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BTN.fill_gray_l_profile(
                        text: '사용자 닉네임',
                        subText: '요금제 정보',
                        image: AssetImage('assets/creta_default.png'),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BTN.fill_blue_ti_el(
                        icon: Icons.arrow_forward_outlined,
                        text: '내 크레타북 관리',
                        onPressed: () {},
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  static Widget TooltipWrapper({
    required String tooltip,
    required Color fgColor,
    required Color bgColor,
    required Widget child,
  }) {
    return Tooltip(
      preferBelow: false,
      textStyle: CretaFont.bodyESmall.copyWith(color: fgColor),
      decoration: BoxDecoration(
          color: bgColor.withOpacity(0.7), borderRadius: BorderRadius.all(Radius.circular(24))),
      message: tooltip,
      child: child,
    );
  }

  static BoxDecoration gradationShadowDeco(
      {Color color = Colors.black,
      AlignmentGeometry begin = Alignment.topCenter,
      AlignmentGeometry end = Alignment.bottomCenter}) {
    return BoxDecoration(
      //color: Colors.black.withOpacity(0.4),
      gradient: LinearGradient(begin: begin, end: end, colors: [
        color.withOpacity(0.6),
        color.withOpacity(0.5),
        color.withOpacity(0.3),
        color.withOpacity(0.2),
        color.withOpacity(0.1),
        color.withOpacity(0.0),
        color.withOpacity(0.0),
        color.withOpacity(0.1),
        color.withOpacity(0.2),
        color.withOpacity(0.3),
        color.withOpacity(0.5),
        color.withOpacity(0.6),
      ]),
    );
  }

  static BoxDecoration shadowDeco({
    Color color = Colors.black,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    double opacity = 0.4,
  }) {
    return BoxDecoration(
      //color: Colors.black.withOpacity(0.4),
      gradient: LinearGradient(begin: begin, end: end, colors: [
        color.withOpacity(opacity),
        color.withOpacity(opacity),
      ]),
    );
  }
}

class CretaComponentLocation {
  EdgeInsets margin; // 바깥여백
  EdgeInsets padding; // 안쪽여백
  double width;
  double height;

  static const EdgeInsets noSpace = EdgeInsets.all(0);

  CretaComponentLocation(
      {this.margin = noSpace,
      this.padding = noSpace,
      this.width = double.infinity,
      this.height = double.infinity});

  // 각 컴포넌트 좌표 & 크기
  static CretaComponentLocation BarTop = CretaComponentLocation(
    height: 60,
  );
  static CretaComponentLocation TabBar = CretaComponentLocation(
    padding: EdgeInsets.fromLTRB(32, 40, 32, 40),
    width: 310.0,
  );
  static CretaComponentLocation ListInTabBar = CretaComponentLocation(
    padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
    width: 246.0,
  );
  static CretaComponentLocation UserMenuInTabBar = CretaComponentLocation(
    padding: EdgeInsets.fromLTRB(16, 20, 16, 20),
    width: 246.0,
    height: 192.0,
  );
}
