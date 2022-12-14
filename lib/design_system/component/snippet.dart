// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:creta03/design_system/buttons/creta_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
import 'package:hycop/hycop.dart';
import '../../common/creta_constant.dart';
import '../../lang/creta_studio_lang.dart';
import '../../routes.dart';
import '../creta_font.dart';
import '../text_field/creta_text_field.dart';
import '../buttons/creta_button_wrapper.dart';
import '../menu/creta_drop_down.dart';
import '../menu/creta_popup_menu.dart';

// get widgets Global Size and Position
extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      final offset = Offset(translation.x, translation.y);
      return renderObject!.paintBounds.shift(offset);
    } else {
      return null;
    }
  }
}

class Snippet {
  static List<LogicalKeyboardKey> keys = [];

  static Widget CretaScaffold(
      {required Widget title, required BuildContext context, required Widget child}) {
    return Scaffold(
      appBar: Snippet.CretaAppBarOfStudio(context, title),
      floatingActionButton: Snippet.CretaDial(context),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressDown: ((details) {
          LastClicked.clickedOutSide(details.globalPosition);
        }),
        child: child,
      ),
    );
  }

  static Widget CretaScaffoldOfCommunity(
      {required Widget title, required BuildContext context, required Widget child}) {
    return Scaffold(
      appBar: Snippet.CretaAppBarOfCommunity(context, title),
      floatingActionButton: Snippet.CretaDial(context),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressDown: ((details) {
          logger.finest('onLongPressDown');
          LastClicked.clickedOutSide(details.globalPosition);
        }),
        child: Container(
          child: child,
        ),
      ),
    );
  }

  static PreferredSizeWidget CretaAppBarOfCommunity(BuildContext context, Widget title) {
    return AppBar(
      backgroundColor: Colors.white,
      shadowColor: Colors.grey[500],
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: title,
      toolbarHeight: 60,
      actions: [
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 125,
                height: 36,
                child: BTN.fill_blue_it_l(
                    icon: Icons.add,
                    text: '??? ????????????',
                    onPressed: () {
                      Routemaster.of(context).push(AppRoutes.intro);
                    }),
              ),
            ],
          ),
        ),
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
              ),
            ],
          ),
        ),

        // user info
        SizedBox(
          child:
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              Center(
            child: SizedBox(
              //width: 166,
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        // crop
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.hardEdge,
                      // color: Colors.grey[700],
                      child: Container(
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CretaDropDown(
                      width: 130,
                      height: 40,
                      items: const ['????????? ?????????', '????????? ?????????1', '????????? ?????????2', '????????? ?????????3'],
                      defaultValue: '????????? ?????????',
                      onSelected: (value) {
                        //logger.finest('value=$value');
                      }),
                  SizedBox(
                    width: 40,
                  ),
                ],
              ),
            ),
            //],
          ),
        ),
        // user's dropdown menu
      ],
    );
  }

  static Widget logo(String title) {
    return Row(children: [
      // SizedBox(
      //   width: 24,
      // ),
      Image(
        image: AssetImage('assets/logo_en.png'),
        height: 20,
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

  static PreferredSizeWidget CretaAppBarOfStudio(BuildContext context, Widget title) {
    return AppBar(
      toolbarHeight: CretaConstant.appbarHeight,
      title: title,
      actions: [
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
              buttonColor: CretaButtonColor.blue,
              text: "Tuttle Rabbit",
              icon: Icons.arrow_drop_down_outlined,
              image: NetworkImage('https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'),
              onPressed: () {},
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
      ],
    );
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
                label: Text('+ ??? ????????????'),
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
        SpeedDialChild(
          label: 'Studio Book',
          child: Icon(Icons.stadium),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.studioBookMainPage);
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
          label: 'Subscription List',
          child: Icon(Icons.subscriptions),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.subscriptionList);
          },
        ),
        SpeedDialChild(
          label: 'Play List',
          child: Icon(Icons.playlist_add_check),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.playList);
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
      // textField ??? focus bug ?????????, delete  key ??? ????????? ??? ??????.
      // if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
      //   logHolder.log('delete pressed');
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
                                  onPressed: () => item.onPressed(),
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

          //?????? ????????? ??????
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
                        text: '????????? ?????????',
                        subText: '????????? ??????',
                        image: AssetImage('assets/creta_default.png'),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BTN.fill_blue_ti_el(
                        icon: Icons.arrow_forward_outlined,
                        text: '??? ???????????? ??????',
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
      textStyle: CretaFont.bodyESmall.copyWith(color: fgColor),
      decoration: BoxDecoration(
          color: bgColor.withOpacity(0.7), borderRadius: BorderRadius.all(Radius.circular(24))),
      message: tooltip,
      child: child,
    );
  }
}

class CretaComponentLocation {
  EdgeInsets margin; // ????????????
  EdgeInsets padding; // ????????????
  double width;
  double height;

  static const EdgeInsets noSpace = EdgeInsets.all(0);

  CretaComponentLocation(
      {this.margin = noSpace,
      this.padding = noSpace,
      this.width = double.infinity,
      this.height = double.infinity});

  // ??? ???????????? ?????? & ??????
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
