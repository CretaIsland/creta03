// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../../design_system/component/snippet.dart';
import 'left_menu.dart';
import 'stick_menu.dart';
import 'studio_constant.dart';

class BookMainPage extends StatefulWidget {
  const BookMainPage({super.key});

  @override
  State<BookMainPage> createState() => _BookMainPageState();
}

class _BookMainPageState extends State<BookMainPage> {
  LeftMenuEnum selectedStick = LeftMenuEnum.None;
  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      title: 'Creta Studio',
      context: context,
      child: Row(
        children: [
          StickMenu(
            selectFunction: showLeftMenu,
            initSelected: selectedStick,
          ),
          selectedStick == LeftMenuEnum.None
              ? Container()
              : LeftMenu(
                  selectedStick: selectedStick,
                  onClose: () {
                    setState(() {
                      selectedStick = LeftMenuEnum.None;
                    });
                  },
                ),
        ],
      ),
    );
  }

  void showLeftMenu(LeftMenuEnum idx) {
    logger.finest("showLeftMenu ${idx.name}");

    setState(() {
      selectedStick = idx;
    });
  }
}
