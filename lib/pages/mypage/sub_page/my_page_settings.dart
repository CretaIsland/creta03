import 'package:flutter/material.dart';


class MyPageSettings extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageSettings({super.key, required this.width, required this.height});

  @override
  State<MyPageSettings> createState() => _MyPageSettingsState();
}

class _MyPageSettingsState extends State<MyPageSettings> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Settings"),
      ),
    );
  }
}