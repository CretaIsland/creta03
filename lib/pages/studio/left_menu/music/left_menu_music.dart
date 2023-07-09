import 'package:creta03/model/contents_model.dart';
import 'package:flutter/material.dart';

class LeftMenuMusic extends StatefulWidget {
  final ContentsModel music;
  const LeftMenuMusic({super.key, required this.music});

  @override
  State<LeftMenuMusic> createState() => _LeftMenuMusicState();
}

class _LeftMenuMusicState extends State<LeftMenuMusic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pink[200],
    );
  }
}
