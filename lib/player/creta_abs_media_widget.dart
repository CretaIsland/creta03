// ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';

import 'creta_abs_player.dart';

abstract class CretaAbsPlayerWidget extends StatefulWidget {
  final CretaAbsPlayer player;
  const CretaAbsPlayerWidget({super.key, required this.player});
}

class CretaEmptyPlayerWidget extends CretaAbsPlayerWidget {
  const CretaEmptyPlayerWidget({super.key, required super.player});

  @override
  State<CretaEmptyPlayerWidget> createState() => CretaEmptyPlayerWidgetState();
}

class CretaEmptyPlayerWidgetState extends State<CretaEmptyPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
