import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';

import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';


class MyPageDashBoard extends StatefulWidget {
  
  final double width;
  final double height;
  final ScrollController scrollController;
  const MyPageDashBoard({super.key, required this.width, required this.height, required this.scrollController});

  @override
  State<MyPageDashBoard> createState() => _MyPageDashBoardState();
}

class _MyPageDashBoardState extends State<MyPageDashBoard> {

  BoxDecoration dataComponentDeco = BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey.shade200, width: 1)
  );

  Widget divideLine(double topMargin, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      height: 1,
      color: Colors.grey.shade200,
    );
  } 

  // 계정 정보
  Widget accountInfoComponent() {
    return Container(
      width: 400,
      height: 400,
      decoration: dataComponentDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 32),
            child: Text(CretaMyPageLang.accountInfo, textAlign: TextAlign.start, style: CretaFont.titleELarge),
          ),
          divideLine(32, 32),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaMyPageLang.accountInfoField[0], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.accountInfoField[1], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.accountInfoField[2], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.accountInfoField[3], style: CretaFont.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text('Creta Star', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('10', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('무료 개인', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('256 MB (전체 1024MB)', style: CretaFont.bodyMedium),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 최근 요약
  Widget lastRecordComponent() {
    return Container(
      width: 400,
      height: 400,
      decoration: dataComponentDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 32, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(CretaMyPageLang.lastRecord, textAlign: TextAlign.start, style: CretaFont.titleELarge),
                Text("지난 30일", textAlign: TextAlign.start, style: CretaFont.titleMedium),
              ],
            ),
          ),
          divideLine(32, 32),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaMyPageLang.lastRecordField[0], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.lastRecordField[1], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.lastRecordField[2], style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text(CretaMyPageLang.lastRecordField[3], style: CretaFont.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(width: 32),
              Padding(
                padding: const EdgeInsets.only(left: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ 
                    Text('17', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('15 시간', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('3', style: CretaFont.bodyMedium),
                    const SizedBox(height: 27),
                    Text('5', style: CretaFont.bodyMedium),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // 내 팀
  Widget myTeamComponent() {
    return Container(
      width: 400,
      height: 400,
      decoration: dataComponentDeco,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32, top: 32),
            child: Text(CretaMyPageLang.accountInfo, textAlign: TextAlign.start, style: CretaFont.titleELarge),
          ),
          divideLine(32, 32),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('기적소리 (소유자)', style: CretaFont.bodyMedium),
                const SizedBox(height: 27),
                Text('위화감 (사용자)', style: CretaFont.bodyMedium),
                const SizedBox(height: 27),
                Text('이지적 (관리자)', style: CretaFont.bodyMedium),
                const SizedBox(height: 27),
                Text('고지식 (사용자)', style: CretaFont.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget dataComponent() {
    if(widget.width > 1300) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          accountInfoComponent(),
          SizedBox(width: widget.width / 40),
          lastRecordComponent(),
          SizedBox(width: widget.width / 40),
          myTeamComponent(),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          accountInfoComponent(),
          SizedBox(height: widget.width / 40),
          lastRecordComponent(),
          SizedBox(height: widget.width / 40),
          myTeamComponent(),
          SizedBox(height: widget.width / 40),
        ],
      );
    }
  }

  Widget mainComponent() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: widget.width < 500 ? Container() : SizedBox(
        width: widget.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 70),
            Container(  // 프로필 사진
              width: 200, 
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey.shade200, width: 2),
                color: Colors.yellow
              ),
            ),
            const SizedBox(height: 40),
            const Text("사용자 닉네임", style: TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
            const SizedBox(height: 16),
            Text("csy_0102@sqisoft.com", style: CretaFont.buttonLarge),
            const SizedBox(height: 86),
            dataComponent()
          ]
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}