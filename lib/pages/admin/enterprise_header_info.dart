import 'dart:convert';

import 'package:flutter/material.dart';

import '../../design_system/dataTable/my_data_table.dart';
//import '../login/creta_account_manager.dart';

class AbsHeaderInfo {
  String defaultListStr = '';

  List<MyColumnInfo> initColumnInfo() {
    return columnInfoFromJson(jsonDecode(defaultListStr)['columnInfoList'] as List);
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

class EnterpriseHeaderInfo extends AbsHeaderInfo {
  EnterpriseHeaderInfo() {
    defaultListStr = '''{
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
                  "width": 400
              }
          ]
      }''';
  }
}

class TeamHeaderInfo extends AbsHeaderInfo {
  TeamHeaderInfo() {
    defaultListStr = '''{
          "columnInfoList": [
              {
                  "name": "name",
                  "label": "name",
                  "width": 100
              },
              {
                  "name": "owner",
                  "label": "owner",
                  "width": 200
              },
              {
                  "name": "managers",
                  "label": "managers",
                  "width": 400
              },
              {
                  "name": "generalMembers",
                  "label": "members",
                  "width": 400
              }
          ]
      }''';
  }
}

class UserHeaderInfo extends AbsHeaderInfo {
  UserHeaderInfo() {
    defaultListStr = '''{
          "columnInfoList": [
              {
                  "name": "verified",
                  "label": "verified",
                  "width": 30
              },
              {
                  "name": "email",
                  "label": "email",
                  "width": 200
              },
              {
                  "name": "nickname",
                  "label": "nickname",
                  "width": 200
              },
              {
                  "name": "enterprise",
                  "label": "enterprise",
                  "width": 200
              },
              {
                  "name": "createTime",
                  "label": "created",
                  "width": 200
              },
              {
                  "name": "teams",
                  "label": "teams",
                  "width": 400
              }
          ]
      }''';
  }
}
