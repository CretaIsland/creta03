// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

//import 'package:creta_studio_model/model/book_model.dart';
//import '../pages/studio/book_main_page.dart';
import 'package:creta_studio_model/model/book_model.dart';
import '../model/channel_model.dart';
import '../model/comment_model.dart';
import '../model/connected_user_model.dart';
import 'package:creta_studio_model/model/contents_model.dart';
import 'package:creta_studio_model/model/depot_model.dart';
import '../model/favorites_model.dart';
import '../model/filter_model.dart';
import 'package:creta_studio_model/model/frame_model.dart';
import 'package:creta_studio_model/model/link_model.dart';
import 'package:creta_studio_model/model/page_model.dart';
import '../model/playlist_model.dart';
import '../model/subscription_model.dart';
import '../routes.dart';
import 'dev_const.dart';

class GenCollectionsPage extends StatefulWidget {
  const GenCollectionsPage({super.key});

  @override
  State<GenCollectionsPage> createState() => _GenCollectionsPageState();
}

class _GenCollectionsPageState extends State<GenCollectionsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Column(
            children: [
              TextButton(
                child: const Text('Generate Studio Collection Json'),
                onPressed: () {
                  // print('Generate Collection Json');
                  String jsonStr = genJson();
                  saveLogToFile(jsonStr, "log.json");
                },
              ),
              IconButton(
                  onPressed: () {
                    Routemaster.of(context).push(AppRoutes.communityHome);
                  },
                  icon: const Icon(Icons.home)),
              IconButton(
                  onPressed: () {
                    Routemaster.of(context).push(AppRoutes.studioBookGridPage);
                  },
                  icon: const Icon(Icons.edit)),
            ],
          ),
        ),
      ),
    );
  }
}

void saveLogToFile(String logData, String outFileName, {String folder = "download"}) {
  final blob = html.Blob([logData]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute(folder, outFileName)
    ..click();
  html.Url.revokeObjectUrl(url);
}

String projectId = '65362b549aa9f85f813d';
String projectName = 'hycop-example';
String databaseId = '653b10ed3629614bbd48';
String databaseName = 'hycopTestDB';

String genJson() {
  String header = '''
  {
    "projectId": "$projectId",
    "projectName": "$projectName",
    "databases": [
      {
        "\$id": "$databaseId",
        "name": "$databaseName",
        "enabled": true
      }
    ],
    "collections": [
''';
  String footer = '''
  ]
  }
  ''';

  String body = genInfo();

  return header + body + footer;
}

String genInfo() {
  String retval = eachCollection(BookModel(''), 'creta_book');
  retval += ",\n";
  retval += eachCollection(BookModel(''), 'creta_book_published');
  retval += ",\n";
  // retval += eachCollection(ChannelModel(''), 'creta_channel');
  // retval += ",\n";
  retval += eachCollection(CommentModel(''), 'creta_comment');
  retval += ",\n";
  retval += eachCollection(ConnectedUserModel.withBook(''), 'creta_connected_user');
  retval += ",\n";
  retval += eachCollection(ContentsModel('', ''), 'creta_contents');
  retval += ",\n";
  retval += eachCollection(ContentsModel('', ''), 'creta_contents_published');
  retval += ",\n";
  retval += eachCollection(DepotModel('', ''), 'creta_depot');
  retval += ",\n";
  // retval += eachCollection(ChannelModel(''), 'creta_enterprise');
  // retval += ",\n";
  retval += eachCollection(FavoritesModel(''), 'creta_favorites');
  retval += ",\n";
  retval += eachCollection(FilterModel(''), 'creta_filter');
  retval += ",\n";
  retval += eachCollection(FrameModel('', ''), 'creta_frame');
  retval += ",\n";
  retval += eachCollection(FrameModel('', ''), 'creta_frame_published');
  retval += ",\n";
  retval += eachCollection(LinkModel('', ''), 'creta_link');
  retval += ",\n";
  retval += eachCollection(PageModel('', BookModel('')), 'creta_page');
  retval += ",\n";
  retval += eachCollection(PageModel('', BookModel('')), 'creta_page_published');
  retval += ",\n";
  retval += eachCollection(PlaylistModel(''), 'creta_playlist');
  retval += ",\n";
  retval += eachCollection(SubscriptionModel(''), 'creta_subscription');
  retval += ",\n";
  // retval += eachCollection(ChannelModel(''), 'creta_team');
  // retval += ",\n";
  // retval += eachCollection(ChannelModel(''), 'creta_user_property');
  // retval += ",\n";
  retval += eachCollection(ChannelModel(''), 'creta_watch_history');
  return retval;
}

String eachCollection(AbsExModel model, String collectionId) {
  String header = '''
      {
        "\$id": "$collectionId",
        "\$permissions": [
          "create(\\"users\\")",
          "read(\\"users\\")",
          "update(\\"users\\")",
          "delete(\\"users\\")"
        ],
        "databaseId": "$databaseId",
        "name": "$collectionId",
        "enabled": true,
        "documentSecurity": false,
        "attributes": [
  ''';
  String footer = '''
      }
  ''';

  String attrList = '';
  var map = model.toMap();

  for (var ele in map.entries) {
    String type = 'string';
    bool isArray = false;
    bool isRequired = false;
    if (ele.key == 'mid') {
      isRequired = true;
    }

    if (ele.value is double) {
      type = 'double';
      if (ele.key.contains('Type') == true) {
        type = 'integer';
      }
      if (ele.key.contains('Types') == true) {
        type = 'integer';
      }
      if (ele.key.contains('Enum') == true) {
        type = 'integer';
      }
      if (ele.key.contains('Count') == true) {
        type = 'integer';
      }
      if (ele.key == 'copyRight') {
        type = 'integer';
      }
      if (ele.key == 'borderCap') {
        type = 'integer';
      }
      if (ele.key == 'shape') {
        type = 'integer';
      }
      if (ele.key == 'transitionEffect') {
        type = 'integer';
      }
      if (ele.key == 'transitionEffect2') {
        type = 'integer';
      }
      if (ele.key == 'duration') {
        type = 'integer';
      }
      if (ele.key == 'bytes') {
        type = 'integer';
      }
      if (ele.key == 'filter') {
        type = 'integer';
      }
      if (ele.key == 'fit') {
        type = 'integer';
      }
      if (ele.key == 'musicPlayerSize') {
        type = 'integer';
      }
      if (ele.key == 'fontWeight') {
        type = 'integer';
      }
      if (ele.key == 'align') {
        type = 'integer';
      }
      if (ele.key == 'valign') {
        type = 'integer';
      }
      if (ele.key == 'effect') {
        type = 'integer';
      }
      if (ele.key == 'borderCap') {
        type = 'integer';
      }
      if (ele.key == 'shape') {
        type = 'integer';
      }
    } else if (ele.value is int) {
      type = 'integer';
    } else if (ele.value is bool) {
      type = 'boolean';
    } else if (ele.value is List) {
      type = 'string';
      isArray = true;
    }
    int length = 128;
    if (ele.key.toLowerCase().contains('url') == true) {
      length = 1024;
    }
    if (ele.key.toLowerCase().contains('img') == true) {
      length = 1024;
    }
    if (ele.key.toLowerCase().contains('image') == true) {
      length = 1024;
    }

    if (attrList.isNotEmpty) {
      attrList += ",\n";
    }
    attrList += eachAttr(
      name: ele.key,
      type: type,
      isArray: isArray,
      isRequired: isRequired,
      length: length,
    );
  }
  attrList += "\n          ],\n";

  String indexList = indexes(collectionId);

  return header + attrList + indexList + footer;
}

String eachAttr({
  required String name,
  required String type,
  String defaultVal = 'null',
  int length = 128,
  bool isArray = false,
  bool isRequired = false,
}) {
  String additional = '';

//   if (type == 'integer') {
//     additional = '''              "min": "-999999999",
//               "max": "9999999999",
// ''';
//   }
//   if (type == 'double') {
//     additional = '''              "min": "-999999999",
//               "max": "9999999999",
// ''';
//   }
  String retval = '''
            {
              "key": "$name",
              "type": "$type",
              "status": "available",
              "required": false,
              "array": $isArray,
              "size": $length,
$additional
              "default": $defaultVal
            }''';
  return retval;
}

String indexes(String collectionId) {
  String header = '''
        "indexes": [
  ''';

  String indexBodies = '';
  List<Map<String, String>>? indexList = DevConst.indexMap[collectionId];
  if (indexList != null) {
    int idx = 0;
    for (var mapEle in indexList) {
      String attrList = '';
      String orderList = '';
      for (var ele in mapEle.entries) {
        if (attrList.isNotEmpty) {
          attrList += ",\n";
        }
        attrList += '              "${ele.key}"';

        if (orderList.isNotEmpty) {
          orderList += ",\n";
        }
        String order = ele.value;
        if (order == "array") {
          order = "ASC";
        }
        orderList += '              "$order"';
      }
      idx++;
      if (indexBodies.isNotEmpty && idx <= indexList.length) {
        indexBodies += ',\n';
      }
      indexBodies += eachIndex(idx, collectionId, attrList, orderList);
    }
  }
  String footer = '        ]';

  return '$header$indexBodies\n$footer\n';
}

String eachIndex(int idx, String collectionId, String attrList, String orderList) {
  String header = '''
          {
            "key": "index_${collectionId}_$idx",
            "type": "key",
            "status": "available",
            "attributes": [
$attrList
            ],
            "orders": [
$orderList
            ]
          }''';
  return header;
}
