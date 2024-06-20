import 'dart:convert';

import 'package:flutter/material.dart';

import 'my_data_table.dart';

mixin MyDataMixin {
  static const int defaultRowPerPage = 10;

  List<String> selectedRowKeys = [];
  List<String>? filterTexts;

  late List<MyColumnInfo> columnInfoList;

  late String sortColumnName;
  late bool sortAscending;
  late ScrollController scrollContoller;
  late ScrollController horizontalController;
  late bool rowPerChanged;
  int initialRowPerPage = defaultRowPerPage;
  List<int> availableRowPerPage = [];

  void initMixin({String columName = 'name', bool ascending = false, ScrollController? scroll}) {
    sortColumnName = columName;
    sortAscending = ascending;
    scrollContoller = scroll ?? ScrollController();
    horizontalController = ScrollController();
    rowPerChanged = false;
  }

  void initAvailableRowPerPage(int rowPerPage) {
    availableRowPerPage = [
      rowPerPage,
      rowPerPage * 2,
      rowPerPage * 4,
      rowPerPage * 8,
      rowPerPage * 10
    ];
  }

  void disposeMixin() {
    scrollContoller.dispose();
    horizontalController.dispose();
  }

  final double rowHeight = 20;
  final double headingRowHeight = 30;
  final double appbarHeight = 60;

  double getDataAreaHeight(BuildContext context, {double offset = 280}) {
    return MediaQuery.of(context).size.height - appbarHeight - headingRowHeight - offset;
  }

  int getInitialRowPerPages(double dataListHeight, double rowHeight) {
    if (dataListHeight > 100) {
      return dataListHeight ~/ (rowHeight * 2);
    }
    return MyDataMixin.defaultRowPerPage;
  }

  String columnInfoToJson() {
    Map<String, dynamic> map = {
      'columnInfoList': columnInfoList.map((item) => item.toJson()).toList(),
    };

    return jsonEncode(map);
  }

  // void columnInfoFromJson(String jsonString) {
  //   final parsedJson = jsonDecode(jsonString);
  //   columnInfoList = (parsedJson['columnInfoList'] as List)
  //       .map((item) => MyColumnInfo(
  //             name: item['name'],
  //             label: item['label'],
  //             width: item['width'],
  //             dataCell: (value, key) => MyDataCell(Text('$value')),
  //           ))
  //       .toList();
  // }
}
