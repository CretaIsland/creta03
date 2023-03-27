import 'package:flutter/material.dart';


class MyPageAccountManage extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageAccountManage({super.key, required this.width, required this.height});

  @override
  State<MyPageAccountManage> createState() => _MyPageAccountManageState();
}

class _MyPageAccountManageState extends State<MyPageAccountManage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("AccountManage"),
      ),
    );
  }
}