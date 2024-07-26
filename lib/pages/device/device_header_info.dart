import 'dart:convert';

import 'package:flutter/material.dart';

import '../../design_system/dataTable/my_data_table.dart';
import '../login/creta_account_manager.dart';

class DeviceHeaderInfo {
  final String defaultListStr = '''{
          "columnInfoList": [
              {
                  "name": "isVNC",
                  "label": "vnc",
                  "width": 30
              },
              {
                  "name": "isUsed",
                  "label": "usage",
                  "width": 30
              },
              {
                  "name": "isOperational",
                  "label": "fault",
                  "width": 30
              },
              {
                  "name": "lastUpdateTime",
                  "label": "lastUpdateTime",
                  "width": 100
              },
              {
                  "name": "hostId",
                  "label": "ID",
                  "width": 100
              },
              {
                  "name": "hostName",
                  "label": "hostName",
                  "width": 120
              },
               {
                  "name": "enterprise",
                  "label": "enterprise",
                  "width": 120
              },
              {
                  "name": "creator",
                  "label": "owner",
                  "width": 120
              },
              {
                  "name": "netInfo",
                  "label": "wifi",
                  "width": 50
              },
              {
                  "name": "hddInfo",
                  "label": "HDD",
                  "width": 50
              },
              {
                  "name": "location",
                  "label": "location",
                  "width": 100
              },
              {
                  "name": "description",
                  "label": "description",
                  "width": 100
              },
              {
                  "name": "macAddress",
                  "label": "macAddress",
                  "width": 100
              },
              {
                  "name": "requestedBook1",
                  "label": "requestedBook1",
                  "width": 100
              },
              {
                  "name": "playingBook1",
                  "label": "playingBook1",
                  "width": 100
              },
              {
                  "name": "requestedBook2",
                  "label": "requestedBook2",
                  "width": 100
              },
              {
                  "name": "playingBook2",
                  "label": "playingBook2",
                  "width": 100
              },
              {
                  "name": "request",
                  "label": "request",
                  "width": 100
              },
              {
                  "name": "shutdownTime",
                  "label": "Auto Off Time",
                  "width": 100
              },
              {
                  "name": "bootTime",
                  "label": "Auto On Time",
                  "width": 100
              },
              {
                  "name": "requestedTime",
                  "label": "requestedTime",
                  "width": 200
              },
              {
                  "name": "updateTime",
                  "label": "updateTime",
                  "width": 200
              },
              {
                  "name": "createTime",
                  "label": "createTime",
                  "width": 200
              }
          ]
      }''';

  List<MyColumnInfo> initColumnInfo() {
    String userDefineStr = CretaAccountManager.getDeviceColumnInfo();
    //print('---------------------userDefineStr: $userDefineStr');
    if (userDefineStr.isEmpty) {
      return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
    }

    try {
      // 여기서  userDefineStr 과 defaultListStr 를 비교하여,  userDefineStr 에 없는 항목을 defaultList 에서 가져와서 추가해야 함.
      final List userDefineList = jsonDecode(userDefineStr)['columnInfoList'] as List;
      final List defaultList = jsonDecode(defaultListStr)['columnInfoList'] as List;

      //defaultColumns의 각 항목을 확인하고, userDefinedColumns에 없는 경우 추가합니다.
      for (var defaultColumn in defaultList) {
        bool exists = userDefineList
            .any((userDefinedColumn) => userDefinedColumn['name'] == defaultColumn['name']);
        if (!exists) {
          userDefineList.add(defaultColumn);
        }
      }
      return columnInfoFromJson(userDefineList);
    } catch (e) {
      //print('---------------------userDefineStr error: $e');
      return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
    }
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
