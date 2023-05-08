import 'dart:math';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';


class MyPageDashBoard extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageDashBoard({super.key, required this.width, required this.height});

  @override
  State<MyPageDashBoard> createState() => _MyPageDashBoardState();
}

class _MyPageDashBoardState extends State<MyPageDashBoard> {


  // 구분선
  Widget divideLine({double leftPadding = 0, double topPadding = 0, double rightPadding = 0, double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding), 
      child: Container(
        width: 400,
        height: 1,
        color: Colors.grey.shade200 ,
      ),
    );
  }

  // 프로필 이미지
  Widget profileImageBox(UserPropertyManager userPropertyManager) {
    return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(200.0),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            image: userPropertyManager.propertyModel!.profileImg == ''
                ? null
                : DecorationImage(image: Image.network(userPropertyManager.propertyModel!.profileImg).image, fit: BoxFit.cover)),
        child: userPropertyManager.propertyModel!.profileImg == '' ?
          Center(
            child: Text(userPropertyManager.userModel.name.substring(0, 1),
            style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 64, color: Colors.white))
          )
          : Container()
    );
  }

  // 계정 정보
  Widget accountInfoBox(UserPropertyManager propertyManager) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(CretaMyPageLang.accountInfo, style: CretaFont.titleELarge),
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.grade, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.bookCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.ratePlan, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.freeSpace, style: CretaFont.bodyMedium)
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.cretaGradeList[propertyManager.propertyModel!.cretaGrade.index], style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("${propertyManager.propertyModel!.bookCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 22.0),
                  Row(
                    children: [
                      Text(CretaMyPageLang.ratePlanList[propertyManager.propertyModel!.ratePlan.index], style: CretaFont.bodyMedium),
                      const SizedBox(width: 24),
                      BTN.line_blue_t_m(text: CretaMyPageLang.ratePlanChangeBTN, onPressed: (){ })
                    ],
                  ),
                  const SizedBox(height: 22.0),
                  Text("${propertyManager.propertyModel!.freeSpace}MB (전체 1024MB)", style: CretaFont.bodyMedium)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 최근 요약
  Widget recentInfoBox(UserPropertyManager propertyManager) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: [
                Text(CretaMyPageLang.recentSummary, style: CretaFont.titleELarge), 
                const SizedBox(width: 192),
                Text("지난 30일", style: CretaFont.titleMedium),
              ],
            )
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.bookViewCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.bookViewTime, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.likeCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.commentCount, style: CretaFont.bodyMedium)
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${propertyManager.propertyModel!.bookViewCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("${propertyManager.propertyModel!.bookViewTime} 시간", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("${propertyManager.propertyModel!.likeCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("${propertyManager.propertyModel!.commentCount}", style: CretaFont.bodyMedium)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 내 팀
  Widget myTeamInfoBox(TeamManager teamManager) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(CretaMyPageLang.myTeam, style: CretaFont.titleELarge),
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(var element in teamManager.teamModelList)...[
                  Text(element.name, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                ]
              ],
            )
          )
        ],
      ),
    );
  }

  Widget mainComponent() {
    return Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return SizedBox(
        width: widget.width,
        height: widget.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: widget.width > 400 ? Column(
            children: [
              const SizedBox(height: 60),
              profileImageBox(userPropertyManager),
              const SizedBox(height: 40),
              Text(userPropertyManager.propertyModel!.nickname, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
              const SizedBox(height: 16),
              Text(userPropertyManager.userModel.email, style: CretaFont.buttonLarge),
              const SizedBox(height: 86),
              widget.width > 1280 ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    accountInfoBox(userPropertyManager),
                    const SizedBox(width: 40.0),
                    recentInfoBox(userPropertyManager),
                    const SizedBox(width: 40.0),
                    myTeamInfoBox(teamManager)
                  ],
                ) : 
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    accountInfoBox(userPropertyManager),
                    const SizedBox(height: 40.0),
                    recentInfoBox(userPropertyManager),
                    const SizedBox(height: 40.0),
                    myTeamInfoBox(teamManager)
                  ],
                ),
              const SizedBox(height: 100)
            ],
          ) : Container()
        )
      );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}