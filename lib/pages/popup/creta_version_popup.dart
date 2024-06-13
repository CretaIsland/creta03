import 'dart:convert';

import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/pages/intro_page.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hycop/hycop.dart';

import '../../design_system/component/snippet.dart';

class CretaVersionPopUp extends StatefulWidget {
  const CretaVersionPopUp({super.key});

  @override
  State<CretaVersionPopUp> createState() => _CretaVersionPopUpState();
}

class _CretaVersionPopUpState extends State<CretaVersionPopUp> {
  double widgetHeight = 160;
  bool isFold = true;
  List<String> releaseData = [];
  bool _alreadyDataGet = false;

  @override
  Widget build(BuildContext context) {
    return CretaDialog(
      width: 364,
      height: widgetHeight,
      title: "About Creta",
      content: Padding(
          padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Copywrite by SQISOFT",
                style: CretaFont.buttonSmall.copyWith(color: CretaColor.text.shade300),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Snippet.versionInfo(),
                  // Text(
                  //   "Version ${IntroPage.cretaVersionList.first} (hycop ${IntroPage.hycopVersion}) \nbuild ${IntroPage.buildNumber}",
                  //   style: CretaFont.bodySmall
                  //       .copyWith(fontWeight: FontWeight.w500, color: CretaColor.text.shade700),
                  // ),
                  IconButton(
                      iconSize: 16,
                      icon:
                          const Icon(Icons.expand_circle_down_outlined, color: CretaColor.primary),
                      onPressed: () {
                        if (isFold) {
                          setState(() {
                            getLastReleaseInfo(IntroPage.cretaVersionList.first);
                            isFold = false;
                            widgetHeight = 292;
                          });
                        }
                      })
                ],
              ),
              const SizedBox(height: 20),
              isFold
                  ? const SizedBox.shrink()
                  : Container(
                      width: 332,
                      height: 124,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200, width: 1),
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _alreadyDataGet
                              ? ListView.builder(
                                  itemCount: releaseData.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "⦁  ${releaseData[index]}",
                                        style: CretaFont.bodySmall
                                            .copyWith(color: CretaColor.text.shade700),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: CretaSnippet.showWaitSign(),
                                )),
                    )
            ],
          )),
    );
  }

  Future<void> getLastReleaseInfo(String version) async {
    try {
      http.Response response = await http.post(
        Uri.parse("${CretaAccountManager.getEnterprise!.mediaApiUrl}/getLastReleaseInfo"),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({"version": version}),
      );
      var responseData = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      releaseData = List<String>.from(responseData["result"]);
      setState(() {
        _alreadyDataGet = true;
      });
    } catch (error) {
      logger.severe(error);
    }
  }
}
