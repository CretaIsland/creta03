import 'package:flutter/material.dart';

import 'my_data_table.dart';

///
/// WebDataColumn
///
class WebDataColumn {
  const WebDataColumn({
    required this.name,
    required this.label,
    required this.dataCell,
    required this.width,
    this.tooltip,
    this.numeric = false,
    this.sortable = true,
    this.comparable,
    this.filterText,
  });

  final String name;
  final Widget label;
  final MyDataCell Function(dynamic value, String key) dataCell;
  final String? tooltip;
  final bool numeric;
  final bool sortable;
  final Comparable Function(dynamic value)? comparable;
  final String Function(dynamic value)? filterText;
  final double width;
}
