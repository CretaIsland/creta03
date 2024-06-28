import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'my_data_table.dart';
import 'my_paginated_data_table.dart';
import 'web_data_table_source.dart';

export 'web_data_column.dart';
export 'web_data_table_source.dart';

///
/// WebDataTable
///
class WebDataTable extends StatelessWidget {
  const WebDataTable({
    super.key,
    this.onPanEnd,
    this.onDragComplete,
    this.header,
    this.actions,
    this.dataRowMinHeight = kMinInteractiveDimension / 2,
    this.dataRowMaxHeight = kMinInteractiveDimension / 2,
    this.headingRowHeight = 56.0,
    this.horizontalMargin = 24.0,
    this.columnSpacing = 56.0,
    this.initialFirstRowIndex = 0,
    this.onPageChanged,
    this.rowsPerPage = defaultRowsPerPage,
    this.availableRowsPerPage = const [
      defaultRowsPerPage,
      defaultRowsPerPage * 2,
      defaultRowsPerPage * 5,
      defaultRowsPerPage * 10,
    ],
    this.onRowsPerPageChanged,
    this.dragStartBehavior = DragStartBehavior.start,
    this.onSort,
    required this.source,
    required this.columnInfo,
    this.controller,
    //this.maxViewWidth = 2000.0,
    this.showCheckboxColumn = true,
  });

  static const int defaultRowsPerPage = 10;
  final Widget? header;
  final List<Widget>? actions;
  final double dataRowMinHeight;
  final double dataRowMaxHeight;
  final double headingRowHeight;
  final double horizontalMargin;
  final double columnSpacing;
  final int initialFirstRowIndex;
  final ValueChanged<int>? onPageChanged;
  final int rowsPerPage;
  final List<int> availableRowsPerPage;
  final Function(int? rowsPerPage)? onRowsPerPageChanged;
  final DragStartBehavior dragStartBehavior;
  final Function(String columnName, bool ascending)? onSort;
  final WebDataTableSource source;
  final ScrollController? controller;
  //final double maxViewWidth;
  final bool showCheckboxColumn;
  final List<MyColumnInfo> columnInfo;
  final void Function()? onPanEnd;
  final void Function()? onDragComplete;

  @override
  Widget build(BuildContext context) {
    //Size displaySize = CretaUtils.getDisplaySize(context);

    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: MyPaginatedDataTable(
          header: header,
          onPanEnd: onPanEnd,
          onDragComplete: onDragComplete,
          columnInfo: columnInfo,
          actions: actions,
          columns: source.columns.map((config) {
            return MyDataColumn(
              columnInfo: columnInfo,
              label: config.label,
              tooltip: config.tooltip,
              numeric: config.numeric,
              onSort: config.sortable && onSort != null
                  ? (columnIndex, ascending) {
                      source.sortColumnName = source.columns[columnIndex].name;
                      source.sortAscending = ascending;
                      if (onSort != null && source.sortColumnName != null) {
                        onSort!(source.sortColumnName!, source.sortAscending);
                      }
                    }
                  : null,
            );
          }).toList(),
          sortColumnIndex: source.sortColumnIndex,
          sortAscending: source.sortAscending,
          onSelectAll: (selected) {
            if (selected != null) source.selectAll(selected);
          },
          dataRowMinHeight: dataRowMinHeight,
          dataRowMaxHeight: dataRowMaxHeight,
          headingRowHeight: headingRowHeight,
          horizontalMargin: horizontalMargin,
          columnSpacing: columnSpacing,
          //showCheckboxColumn: source.onSelectRows != null,
          showCheckboxColumn: showCheckboxColumn,
          initialFirstRowIndex: initialFirstRowIndex,
          onPageChanged: onPageChanged,
          rowsPerPage: rowsPerPage,
          availableRowsPerPage: availableRowsPerPage,
          onRowsPerPageChanged: onRowsPerPageChanged,
          dragStartBehavior: dragStartBehavior,
          source: source,
        ),
      ),
    );
  }
}
