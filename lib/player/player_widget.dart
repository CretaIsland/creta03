import 'package:flutter/material.dart';

import '../model/contents_model.dart';
import 'player_handler.dart';

class PlayerWidget extends StatefulWidget {
  final PlayerHandler playerHandler;
  const PlayerWidget({super.key, required this.playerHandler});

  @override
  State<PlayerWidget> createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> {
  @override
  Widget build(BuildContext context) {
    ContentsModel? model = widget.playerHandler.getCurrentModel();
    if (model == null) {
      return const SizedBox.shrink();
    }
    return widget.playerHandler.createPlayer(model);
  }
}
