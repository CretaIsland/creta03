import 'package:flutter/material.dart';

class StudioSnippet {
  static List<BoxShadow> basicShadow() {
    return [
      BoxShadow(
        color: Colors.grey[200]!,
        spreadRadius: 4,
        blurRadius: 4,
        offset: const Offset(-4, 0),
      ),
      BoxShadow(
        color: Colors.grey[200]!,
        spreadRadius: 4,
        blurRadius: 4,
        offset: const Offset(0, -4),
      ),
    ];
  }
}
