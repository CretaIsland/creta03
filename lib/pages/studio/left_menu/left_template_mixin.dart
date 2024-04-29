import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

mixin LeftTemplateMixin {
  final double horizontalPadding = 19;
  late TextStyle titleStyle;
  late TextStyle dataStyle;

  void initMixin() {
    titleStyle = CretaFont.bodySmall.copyWith(color: CretaColor.text[400]!);
    dataStyle = CretaFont.bodySmall;
  }
}
