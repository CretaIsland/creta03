// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import '../text_field/creta_search_bar.dart';
import '../component/snippet.dart';
import '../text_field/creta_text_field.dart';
//import '../creta_font.dart';

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
      title: 'TextField Demo pagge',
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
                  Text('TF_sarchbar'),
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
                  Text('TF_sarchbar_long'),
                  SizedBox(width: 30),
                  Text('CretaSearchBar.long()'),
                  SizedBox(width: 30),
                  CretaSearchBar.long(
                      hintText: '플레이스홀더',
                      onSearch: (value) {
                        logger.finest('alue=$value');
                      }),
                ],
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Textbox_short'),
                  SizedBox(width: 30),
                  Text('CretaTextFeild()'),
                  SizedBox(width: 30),
                  CretaTextField(
                      textFieldKey: GlobalKey(),
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
                      hintText: '플레이스홀더',
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
