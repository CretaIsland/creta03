import 'dart:convert';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/design_system/menu/creta_drop_down.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class ReleaseNoteDialog extends StatefulWidget {
  List<String> versionList = [];
  ReleaseNoteDialog({super.key, required this.versionList});

  @override
  State<ReleaseNoteDialog> createState() => _ReleaseNoteDialogState();
}

class _ReleaseNoteDialogState extends State<ReleaseNoteDialog> {
  late String selectedVersion;
  Map<String, List<String>> releaseData = {};

  @override
  void initState() {
    super.initState();
    selectedVersion = widget.versionList.first;
    getReleaseData(widget.versionList).then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return CretaDialog(
        width: 700,
        height: 500,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 526),
              child: CretaDropDown.small(
                  items: widget.versionList.sublist(0, 5),
                  defaultValue: selectedVersion,
                  onSelected: (value) {
                    setState(() {
                      selectedVersion = value;
                    });
                  }),
            ),
            const SizedBox(height: 10),
            releaseData.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: CretaSnippet.showWaitSign(),
                  )
                : SizedBox(
                    width: 600,
                    height: 350,
                    child: ListView.builder(
                      itemCount: releaseData[selectedVersion]!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "●  ${releaseData[selectedVersion]!.elementAt(index)}",
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ));
  }

  Future<void> getReleaseData(List<String> versionList) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${CretaAccountManager.getEnterprise!.mediaApiUrl}/getReleaseInfo"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"versionList": versionList}),
      );
      var responseData = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      releaseData = responseData
          .map((key, value) => MapEntry<String, List<String>>(key, List<String>.from(value)));
    } catch (error) {
      logger.fine(error);
    }
  }
}
