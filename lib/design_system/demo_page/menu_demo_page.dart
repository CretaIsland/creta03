// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../menu/creta_drop_down.dart';
import '../component/snippet.dart';
//import 'package:creta_common/common/creta_font.dart';

class MenuDemoPage extends StatefulWidget {
  MenuDemoPage({super.key});

  @override
  State<MenuDemoPage> createState() => _MenuDemoPageState();
}

class _MenuDemoPageState extends State<MenuDemoPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      //title: Snippet.logo('Menu Demo'),
              onFoldButtonPressed: () {
          setState(() {});
        },

      context: context,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('DropDown'),
                  SizedBox(width: 30),
                  Text('CretaDropDown()'),
                  SizedBox(width: 30),
                  CretaDropDown(
                      items: ['제니', '지수', '로제', '리사'],
                      defaultValue: '지수',
                      onSelected: (value) {
                        logger.finest('value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('DropDown_s'),
                  SizedBox(width: 30),
                  Text('CretaDropDown.small()'),
                  SizedBox(width: 30),
                  CretaDropDown.small(
                      items: ['제니', '지수', '로제', '리사'],
                      defaultValue: '지수',
                      onSelected: (value) {
                        logger.finest('value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
