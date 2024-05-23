import 'package:creta_common/common/creta_color.dart';
import 'package:flutter/material.dart';

import 'web_data_column.dart';

// class MyDataCell extends DataCell {
//   final String keyValue;

//   MyDataCell(DataCell dataCell, this.keyValue)
//       : super(
//           dataCell.child,
//           placeholder: dataCell.placeholder,
//           showEditIcon: dataCell.showEditIcon,
//           onTap: dataCell.onTap,
//           onLongPress: dataCell.onLongPress,
//           onTapDown: dataCell.onTapDown,
//           onDoubleTap: dataCell.onDoubleTap,
//           onTapCancel: dataCell.onTapCancel,
//         );
// }

class ConditionColor {
  final Color bgColor;
  final bool condition;

  ConditionColor(this.bgColor, this.condition);
}

///
/// WebDataTableSource
///
///
///
///
class WebDataTableSource extends DataTableSource {
  WebDataTableSource({
    required this.columns,
    required this.rows,
    this.onTapRow,
    this.onSelectRows,
    this.sortColumnName,
    this.sortAscending = true,
    this.primaryKeyName,
    this.filterTexts,
    this.selectedRowKeys = const [],
    this.conditionalRowColor,
    this.keyName = 'mid',
  }) {
    if (onSelectRows != null) {
      assert(primaryKeyName != null);
    }
    _rows = [...rows];
    _executeFilter();
    _executeSort();
  }

  final List<WebDataColumn> columns;
  final List<Map<String, dynamic>> rows;
  late List<Map<String, dynamic>> _rows;
  final Function(List<Map<String, dynamic>> rows, int index)? onTapRow;
  final Function(List<String> selectedRowKeys)? onSelectRows;
  String? sortColumnName;
  bool sortAscending;
  final String? primaryKeyName;
  final List<String>? filterTexts;
  final List<String> selectedRowKeys;
  final Map<String, ConditionColor>? conditionalRowColor;
  final String keyName;

  @override
  DataRow getRow(int index) {
    List<DataCell> cells = [];
    for (final column in columns) {
      cells.add(
        column.dataCell(_rows[index][column.name], _rows[index][keyName]),
      );
    }

    final key = primaryKeyName != null ? _rows[index][primaryKeyName].toString() : null;
    return DataRow.byIndex(
        color: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return CretaColor.primary.withOpacity(0.2);
          }
          if (conditionalRowColor != null) {
            for (var key in conditionalRowColor!.keys) {
              if (_rows[index][key] as bool == conditionalRowColor![key]!.condition) {
                return conditionalRowColor![key]!.bgColor;
              }
            }
          }
          return null; // Use the default value.
        }),
        index: index,
        cells: cells,
        selected: key != null ? selectedRowKeys.contains(key) : false,
        onSelectChanged: (selected) {
          //print('1.onSelectChanged: $selected');
          if (onTapRow != null) {
            onTapRow!(_rows, index);
          }
          //print('2.onSelectChanged: $selected');
          if (onSelectRows != null && key != null) {
            final keys = [...selectedRowKeys];
            if (selected != null && selected) {
              keys.add(key);
            } else {
              keys.remove(key);
            }
            onSelectRows!(keys);
          }
          //print('3.onSelectChanged: $selected');
        });
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _rows.length;

  @override
  int get selectedRowCount => 0;

  void _executeSort() {
    if (sortColumnName == null) {
      return;
    }

    final column = _findColumn(sortColumnName!);
    final cmp = column?.comparable;
    _rows.sort((Map<String, dynamic> a, Map<String, dynamic> b) {
      final aValue = cmp != null ? cmp(a[sortColumnName]) : a[sortColumnName].toString();
      final bValue = cmp != null ? cmp(b[sortColumnName]) : b[sortColumnName].toString();
      return sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });
  }

  void _executeFilter() {
    if (filterTexts == null || filterTexts!.isEmpty) {
      return;
    }

    _rows.clear();
    for (Map<String, dynamic> row in rows) {
      final List<String> valueTexts = [];
      for (final name in row.keys.toList()) {
        final column = _findColumn(name);
        String text = row[name].toString();
        if (column?.filterText != null) {
          text = column!.filterText!(row[name]);
        }
        valueTexts.add(text);
      }

      int containCount = 0;
      for (final filterText in filterTexts!) {
        for (final valueText in valueTexts) {
          if (valueText.contains(filterText)) {
            containCount++;
            break;
          }
        }
      }
      if (containCount == filterTexts!.length) {
        _rows.add(row);
      }
    }
  }

  WebDataColumn? _findColumn(String name) {
    final founds = columns.where((column) => column.name == name);
    if (founds.isNotEmpty) {
      return founds.first;
    }
    return null;
  }

  int? get sortColumnIndex {
    int? index;
    if (sortColumnName != null) {
      columns.asMap().forEach((i, column) {
        if (column.name == sortColumnName) {
          index = i;
          return;
        }
      });
    }
    return index;
  }

  void selectAll(bool selected) {
    if (onSelectRows == null || primaryKeyName == null) {
      return;
    }

    final List<String> keys = [];
    if (selected) {
      keys.addAll(_rows.map((row) => row[primaryKeyName].toString()).toList());
    }
    onSelectRows!(keys);
  }
}