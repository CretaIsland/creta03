import 'package:flutter/material.dart';

import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';

mixin LeftTemplateMixin {
  final double horizontalPadding = 24;
  late TextStyle titleStyle;
  late TextStyle dataStyle;

  void initMixin() {
    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;
  }
}
