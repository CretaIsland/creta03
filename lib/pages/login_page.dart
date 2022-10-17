// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../design_system/component/snippet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      title: 'Login pagge',
      context: context,
      child: Container(),
    );
  }
}
