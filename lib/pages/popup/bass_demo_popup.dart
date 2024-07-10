import 'package:creta03/data_io/demo_manager.dart';
import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

import '../../model/demo_model.dart';

DemoManager demoManagerHolder = DemoManager();

class BassDemoPopUp extends StatefulWidget {
  const BassDemoPopUp({super.key});

  @override
  State<BassDemoPopUp> createState() => _BassDemoPopUpState();
}

class _BassDemoPopUpState extends State<BassDemoPopUp> {
  double widgetHeight = 440;
  double widgetWidth = 400;

  void _initData() {
    // DemoModel sampleData = DemoModel.dummy();
    // sampleData.message = "ready";
    // demoManagerHolder.createToDB(sampleData);
    //demoManagerHolder.myDataOnly(AccountManager.currentLoginUser.email);
    demoManagerHolder.initMyStream(AccountManager.currentLoginUser.email);
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    return CretaDialog(
        width: widgetWidth,
        height: widgetHeight,
        title: "카드 결제 창",
        content: demoManagerHolder.streamHost(
          consumerFunc: (resultList) {
            if (demoManagerHolder.modelList.isNotEmpty) {
              String msg = (demoManagerHolder.modelList.first as DemoModel).message;
              return Center(
                child: SizedBox(
                  height: widgetHeight - 60,
                  width: widgetWidth - 40,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 카드 투입 그림을 하나 넣는다.
                      Image.asset('assets/cardInsert.jpg', width: 100, height: 100),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: _showMsg(msg),
                      ),
                      if (msg == 'success' || msg == 'fail')
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: IconButton(
                              iconSize: 42,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(Icons.exit_to_app)),
                        ),
                    ],
                  ),
                ),
              );
            }
            return const Text("No data founded");
          },
        ));
  }

  Widget _showMsg(String msg) {
    String msgStr = "Invalid data $msg";

    if (msg == 'ready') {
      msgStr = "카드를 투입구에 넣어 주세요";
    } else if (msg == 'inserted') {
      msgStr = "카드를 인식중입니다";
    } else if (msg == 'success') {
      msgStr = "결제가 완료되었습니다";
    } else if (msg == 'fail') {
      msgStr = "결제가 실패하였습니다";
    }
    return Text(msgStr, style: CretaFont.titleLarge);
  }
}
