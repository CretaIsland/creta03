// ignore_for_file: non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:routemaster/routemaster.dart';
import '../../routes.dart';

class Snippet {
  static Widget CretaScaffold(
      {required String title, required BuildContext context, required Widget child}) {
    return Scaffold(
      appBar: Snippet.CretaAppBar(title),
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
      body: child,
    );
  }

  static PreferredSizeWidget CretaAppBar(String title) {
    return AppBar(
      // Here we take the value from the MyHomePage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
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
          child: Icon(Icons.font_download),
          onTap: () {
            //Routemaster.of(context).push(AppRoutes.fontDemoPage);
            dummy(context);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.smart_button),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.buttonDemoPage);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.text_fields_outlined),
          onTap: () {
            Routemaster.of(context).push(AppRoutes.textFieldDemoPage);
          },
        ),
      ],
    );
  }

  static Future<void> dummy(BuildContext context) async {
    Routemaster.of(context).push(AppRoutes.fontDemoPage);
  }
}
