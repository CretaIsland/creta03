// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../design_system/component/snippet.dart';
import '../design_system/creta_font.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      title: 'Intro pagge',
      context: context,
      child: Center(
        child: Text(
          "Version 0.0.1",
          style: CretaFont.headlineLarge,
        ),
      ),
    );
  }
}
