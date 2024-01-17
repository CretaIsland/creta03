import 'package:creta03/design_system/component/snippet.dart';
import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Snippet.showWaitSign(),
    );
  }
}
