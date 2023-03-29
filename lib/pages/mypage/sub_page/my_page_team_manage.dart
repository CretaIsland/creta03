import 'package:flutter/material.dart';


class MyPageTeamManage extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageTeamManage({super.key, required this.width, required this.height});

  @override
  State<MyPageTeamManage> createState() => _MyPageTeamManageState();
}

class _MyPageTeamManageState extends State<MyPageTeamManage> {

  Widget mainComponent() {
    return Container(
      width: widget.width,
      height: widget.height
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}