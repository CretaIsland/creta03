import 'package:flutter/material.dart';

class SnippetStudio {
  static Widget rotateWidget({required Widget child, int turns = 2}) {
    return RotatedBox(quarterTurns: turns, child: child);
  }
}
