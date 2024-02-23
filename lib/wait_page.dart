import 'package:creta_common/common/creta_snippet.dart';
import 'package:flutter/material.dart';

class WaitPage extends StatelessWidget {
  const WaitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CretaSnippet.showWaitSign(),
    );
  }
}
