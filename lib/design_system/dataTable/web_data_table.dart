import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'web_data_table_source.dart';

export 'web_data_column.dart';
export 'web_data_table_source.dart';

///
/// WebDataTable
///
class WebDataTable extends StatelessWidget {
  const WebDataTable({
    Key? key,
    this.header,
    this.actions,
    this.dataRowHeight = kMinInteractiveDimension,
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
    this.controller,
    this.maxViewWidth = 2000.0,
  }) : super(key: key);

  static const int defaultRowsPerPage = 10;
  final Widget? header;
  final List<Widget>? actions;
  final double dataRowHeight;
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
  final double maxViewWidth;

  @override
  Widget build(BuildContext context) {
    //Size displaySize = CretaUtils.getDisplaySize(context);
    return Scrollbar(
      thumbVisibility: true,
      controller: controller,
      child: SingleChildScrollView(
        controller: controller,
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: maxViewWidth,
          child: PaginatedDataTable(
            //header: header,
            actions: actions,
            columns: source.columns.map((config) {
              return DataColumn(
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
            dataRowMinHeight: dataRowHeight,
            headingRowHeight: headingRowHeight,
            horizontalMargin: horizontalMargin,
            columnSpacing: columnSpacing,
            showCheckboxColumn: source.onSelectRows != null,
            initialFirstRowIndex: initialFirstRowIndex,
            onPageChanged: onPageChanged,
            rowsPerPage: rowsPerPage,
            availableRowsPerPage: availableRowsPerPage,
            onRowsPerPageChanged: onRowsPerPageChanged,
            dragStartBehavior: dragStartBehavior,
            source: source,
          ),
        ),
      ),
    );
  }
}
