// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../design_system/component/snippet.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _errMsg = '';
  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
      title: 'Login pagge',
      context: context,
      child: Center(
        child: ElevatedButton(
          onPressed: _login,
          child: Text('login'),
        ),
      ),
    );
  }

  void _login() {
    AccountManager.login("b54@sqisoft.com", "-507263a").then((value) {
      HycopFactory.setBucketId();
      showSnackBar(context, "login succeed");
      setState(() {});
    }).onError((error, stackTrace) {
      if (error is HycopException) {
        HycopException ex = error;
        _errMsg = ex.message;
      } else {
        _errMsg = 'Uknown DB Error !!!';
      }
      logger.severe(_errMsg);
      showSnackBar(context, _errMsg);
      setState(() {});
    });
  }
}
