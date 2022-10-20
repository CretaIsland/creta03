// ignore_for_file: must_be_immutable, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import '../text_field/creta_search_bar.dart';
import '../component/snippet.dart';
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
              CretaSearchBar(),
            ],
          ),
        ),
      ),
      //),
    );
  }
}
