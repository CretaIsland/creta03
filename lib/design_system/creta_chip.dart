import 'package:flutter/material.dart';

import 'package:creta_common/common/creta_color.dart';
import 'package:creta_common/common/creta_font.dart';

class CretaChip extends StatelessWidget {
  const CretaChip({
    super.key,
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      clipBehavior: Clip.antiAlias,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side: BorderSide(
          width: 1,
          color: CretaColor.text[700]!,
        ),
      ),
      labelPadding: const EdgeInsets.only(left: 6.0, right: 1.0),
      label: Text(
        '#$label',
        style: CretaFont.buttonMedium.copyWith(color: CretaColor.text[700]!),
      ),
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
