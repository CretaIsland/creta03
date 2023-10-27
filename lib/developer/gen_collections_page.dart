import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

//import '../model/book_model.dart';
//import '../pages/studio/book_main_page.dart';
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

                  // BookModel book = BookModel('');

                  // var map = book.toMap();
                  // for (var ele in map.entries) {
                  //   print(ele.key);
                  //   if (ele.value is String) {
                  //     print('type : String...');
                  //   } else if (ele.value is int) {
                  //     print('type : int...');
                  //   } else if (ele.value is bool) {
                  //     print('type : bool...');
                  //   } else if (ele.value is double) {
                  //     print('type : double...');
                  //   } else if (ele.value is List) {
                  //     print('type : List...');
                  //   } else if (ele.value is DateTime) {
                  //     print('type : DateTime...');
                  //   } else {
                  //     print('type : unkown type');
                  //   }
                  // }
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

String projectId = '65362b549aa9f85f813d';
String projectName = 'hycop-example';
String databaseId = 'testDB';
String databaseName = 'testDB';

String genJson() {
  String header = '''
    {\n
    \t"projectId": $projectId,\n
    \t"projectName": $projectName,\n
    \t\t"databases": [\n
    \t\t{\n
    \t\t\t"\$id": $databaseId,\n
    \t\t\t"name": $databaseName,\n
    \t\t\t"enabled": true\n
    \t\t\t}\n
    \t\t],\n

    \t"collections": [\n
  ''';
  String footer = '''
    \t]\n
    \n
  ''';

  return header + footer;
}

void genInfo(AbsExModel model, String collectionId) {}

String eachCollection(String collectionId) {
  String header = '''
    {
      "\$id": $collectionId,
      "\$permissions": [
        "create(\\"users\\")",
        "read(\\"users\\")",
        "update(\\"users\\")",
        "delete(\\"users\\")"
      ],
       "databaseId": $databaseId,
      "name": $collectionId,
      "enabled": true,
      "documentSecurity": false,
      "attributes": [
''';

  String footer = '''
      ]
    }
  ''';

  return header + footer;
}

String eachAttr({
  required String name,
  required String type,
  String defaultVal = 'null',
  int length = 256,
  bool isArray = false,
}) {
  String additional = '';

  if (type == 'integer') {
    additional = '''
        "min": "-9223372036854775808",
        "max": "9223372036854775807",
''';
  }
  if (type == 'double') {
    additional = '''
         "min": "-1.7976931348623157e+308",
          "max": "1.7976931348623157e+308",
''';
  }
  String header = '''
        {
          "key": "$name",
          "type": "$type",
          "status": "available",
          "required": true,
          "array": $isArray,
          "size": $length,
          $additional
          "default": $defaultVal
        }
        ''';
  return header;
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
        attrList += '"${ele.key}"';

        if (orderList.isNotEmpty) {
          orderList += ",\n";
        }
        String order = ele.value;
        if (order == "array") {
          order = "ASC";
        }
        orderList += '"$order"';
      }
      idx++;
      if (indexBodies.isNotEmpty) {
        indexBodies += ",\n";
      }
      indexBodies += eachIndex(idx, collectionId, attrList, orderList);
    }
  }

  String footer = ']';

  return '$header\n$indexBodies\n$footer\n';
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
        }
      
    ''';
  return header;
}


/*

      "attributes": [
        {
          "key": "email",
          "type": "string",
          "status": "available",
          "error": "",
          "required": true,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "name",
          "type": "string",
          "status": "available",
          "error": "",
          "required": true,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "accountSignUpType",
          "type": "integer",
          "status": "available",
          "error": "",
          "required": true,
          "array": false,
          "min": "-9223372036854775808",
          "max": "9223372036854775807",
          "default": null
        },
        {
          "key": "userId",
          "type": "string",
          "status": "available",
          "error": "",
          "required": true,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "password",
          "type": "string",
          "status": "available",
          "error": "",
          "required": true,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "userForeignKey",
          "type": "string",
          "status": "available",
          "error": "",
          "required": false,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "phone",
          "type": "string",
          "status": "available",
          "error": "",
          "required": false,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "imagefile",
          "type": "string",
          "status": "available",
          "error": "",
          "required": false,
          "array": false,
          "size": 128,
          "default": null
        },
        {
          "key": "userType",
          "type": "integer",
          "status": "available",
          "error": "",
          "required": false,
          "array": false,
          "min": "-9223372036854775808",
          "max": "9223372036854775807",
          "default": null
        }
      ],
      "indexes": [
        {
          "key": "index_1",
          "type": "key",
          "status": "available",
          "error": "",
          "attributes": [
            "email"
          ],
          "orders": [
            "ASC"
          ]
        }
      ]
    },';

''';
}
*/