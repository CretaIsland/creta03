import 'package:flutter/material.dart';

import '../model/contents_model.dart';
import 'player_handler.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerHandler playManager;
  const PlayerWidget({super.key, required this.playManager});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    ContentsModel? model = widget.playManager.getCurrentModel();
    if (model == null) {
      return const SizedBox.shrink();
    }
    return const Placeholder();
  }
}
