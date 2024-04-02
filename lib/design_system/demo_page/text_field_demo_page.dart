// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../text_field/creta_search_bar.dart';
import '../component/snippet.dart';
import '../text_field/creta_text_field.dart';
//import 'package:creta_common/common/creta_font.dart';

class TextFieldDemoPage extends StatefulWidget {
  TextFieldDemoPage({super.key});

  @override
  State<TextFieldDemoPage> createState() => _TextFieldDemoPageState();
}

class _TextFieldDemoPageState extends State<TextFieldDemoPage> {
  ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      //title: Snippet.logo('TextField Demo'),
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
                  Text('TF_searchbar'),
                  SizedBox(width: 30),
                  Text('CretaSearchBar()'),
                  SizedBox(width: 30),
                  CretaSearchBar(
                      hintText: '플레이스홀더',
                      onSearch: (value) {
                        logger.finest('value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('TF_searchbar_long'),
                  SizedBox(width: 30),
                  Text('CretaSearchBar.long()'),
                  SizedBox(width: 30),
                  CretaSearchBar.long(
                      hintText: '플레이스홀더',
                      onSearch: (value) {
                        logger.finest('value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox (free size)'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild().'),
                  SizedBox(width: 30),
                  SizedBox(
                    width: 400,
                    child: CretaTextField(
                        textFieldKey: GlobalKey(),
                        value: '',
                        hintText: '플레이스홀더',
                        onEditComplete: (value) {
                          logger.finest('onEditComplete value=$value');
                        }),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_short'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild().short()'),
                  SizedBox(width: 30),
                  CretaTextField.short(
                      textFieldKey: GlobalKey(),
                      value: '',
                      hintText: '플레이스홀더',
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_short_small'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild.small()'),
                  SizedBox(width: 30),
                  CretaTextField.small(
                      textFieldKey: GlobalKey(),
                      value: '',
                      hintText: '플레이스홀더',
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_long'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild.long()'),
                  SizedBox(width: 30),
                  CretaTextField.long(
                      textFieldKey: GlobalKey(),
                      value: '',
                      hintText: '플레이스홀더',
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_xs'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild.xshortNumber()'),
                  SizedBox(width: 30),
                  CretaTextField.xshortNumber(
                      textFieldKey: GlobalKey(),
                      value: '1',
                      hintText: '1',
                      maxNumber: 99,
                      minNumber: 0,
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_s'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild.shortNumber()'),
                  SizedBox(width: 30),
                  CretaTextField.shortNumber(
                      textFieldKey: GlobalKey(),
                      value: '1',
                      hintText: '1',
                      maxNumber: 99,
                      minNumber: 0,
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_medium'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild.colorText()'),
                  SizedBox(width: 30),
                  CretaTextField.colorText(
                      textFieldKey: GlobalKey(),
                      value: '#123456',
                      hintText: '#000000',
                      onEditComplete: (value) {
                        logger.finest('onEditComplete value=$value');
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
