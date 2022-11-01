// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
//import 'package:hycop/common/util/logger.dart';
import 'package:routemaster/routemaster.dart';
import 'package:hycop/hycop.dart';
import '../../routes.dart';
import '../text_field/creta_text_field.dart';

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

  static Widget CretaScaffold({required String title, required BuildContext context, required Widget child}) {
    return Scaffold(
      appBar: Snippet.CretaAppBar(context, title),
      floatingActionButton:
          // Row(
          //   children: [
          //     ElevatedButton(
          //         onPressed: () {
          //           Routemaster.of(context).push(AppRoutes.intro);
          //         },
          //         child: Icon(Icons.house)),
          //     ElevatedButton(
          //         onPressed: () {
          //           Routemaster.of(context).push(AppRoutes.buttonDemoPage);
          //         },
          //         child: Icon(Icons.smart_button))
          //   ],
          // ),
          Snippet.CretaDial(context),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onLongPressDown: ((details) {
          logger.finest('onLongPressDown');
          LastClicked.clickedOutSide(details.globalPosition);
        }),
        // onTapDown: ((details) {
        //   logger.finest('clicked=${details.globalPosition}');
        // }),
        child: Container(
          //color: Colors.amber,
          child: child,
        ),
      ),
    );
    // body: RawKeyboardListener(
    //   onKey: keyEventHandler,
    //   focusNode: FocusNode(),
    //   child: child,
    // ));
  }

  static PreferredSizeWidget CretaAppBar(BuildContext context, String title) {
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
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
                  AccountManager.logout().then((value) { Routemaster.of(context).push(AppRoutes.intro); });
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
      //   logHolder.log('delete pressed');
      //   accManagerHolder!.removeACC(context);
      // }
      if (event.isKeyPressed(LogicalKeyboardKey.tab)) {
        logger.finest('tab pressed');
      }
      keys.add(key);
      // Ctrl Key Area
      if ((keys.contains(LogicalKeyboardKey.controlLeft) || keys.contains(LogicalKeyboardKey.controlRight))) {
        if (keys.contains(LogicalKeyboardKey.keyZ)) {
          logger.finest('Ctrl+Z pressed');
        }
      }
    } else {
      keys.remove(key);
    }
  }
}
