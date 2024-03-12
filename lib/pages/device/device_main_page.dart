import 'package:flutter/material.dart';

import '../../design_system/component/snippet.dart';

class DeviceMainPage extends StatefulWidget {
  const DeviceMainPage({super.key});

  @override
  State<DeviceMainPage> createState() => _DeviceMainPageState();
}

class _DeviceMainPageState extends State<DeviceMainPage> {
  @override
  Widget build(BuildContext context) {
    return Snippet.CretaScaffold(
        title: Snippet.logo('studio'),
        context: context,
        child: const Text('Not yet impletemented'));
  }
}
