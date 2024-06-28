import 'dart:convert';

import 'package:flutter/material.dart';

import '../../design_system/dataTable/my_data_table.dart';
//import '../login/creta_account_manager.dart';

class EnterpriseHeaderInfo {
  final String defaultListStr = '''{
          "columnInfoList": [
              {
                  "name": "name",
                  "label": "name",
                  "width": 100
              },
              {
                  "name": "description",
                  "label": "description",
                  "width": 200
              },
              {
                  "name": "admins",
                  "label": "admins",
                  "width": 200
              }
          ]
      }''';

  List<MyColumnInfo> initColumnInfo() {
    return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
    // String userDefineStr = CretaAccountManager.getDeviceColumnInfo();
    // //print('---------------------userDefineStr: $userDefineStr');
    // if (userDefineStr.isEmpty) {
    //   return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
    // }

    // try {
    //   // 여기서  userDefineStr 과 defaultListStr 를 비교하여,  userDefineStr 에 없는 항목을 defaultList 에서 가져와서 추가해야 함.
    //   final List userDefineList = jsonDecode(userDefineStr)['columnInfoList'] as List;
    //   final List defaultList = jsonDecode(defaultListStr)['columnInfoList'] as List;

    //   //defaultColumns의 각 항목을 확인하고, userDefinedColumns에 없는 경우 추가합니다.
    //   for (var defaultColumn in defaultList) {
    //     bool exists = userDefineList
    //         .any((userDefinedColumn) => userDefinedColumn['name'] == defaultColumn['name']);
    //     if (!exists) {
    //       userDefineList.add(defaultColumn);
    //     }
    //   }
    //   return columnInfoFromJson(userDefineList);
    // } catch (e) {
    //   //print('---------------------userDefineStr error: $e');
    //   return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
    // }
  }

  List<MyColumnInfo> columnInfoFromJson(List list) {
    return list
        .map((item) => MyColumnInfo(
              name: item['name'],
              label: item['label'],
              width: item['width'],
              dataCell: (value, key) => MyDataCell(Text('$value')),
            ))
        .toList();
  }
}
