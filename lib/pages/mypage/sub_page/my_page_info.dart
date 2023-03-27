import 'package:flutter/material.dart';


class MyPageInfo extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageInfo({super.key, required this.width, required this.height});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Info"),
      ),
    );
  }
}