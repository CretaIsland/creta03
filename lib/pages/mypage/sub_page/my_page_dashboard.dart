import 'package:creta_user_io/data_io/team_manager.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta_user_model/model/team_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MyPageDashBoard extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageDashBoard(
      {super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageDashBoard> createState() => _MyPageDashBoardState();
}

class _MyPageDashBoardState extends State<MyPageDashBoard> {
  static const Size cardSize = Size(450, 400);
  // 계정 정보 컴포넌트
  Widget accountInfo(UserPropertyModel userProperty) {
    TextStyle propertyFontStyle = CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400);
    return Container(
      width: cardSize.width,
      height: cardSize.height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 34, left: 28),
            child: Text(CretaMyPageLang['accountInfo']!,
                /*"계정 정보",*/
                style: CretaFont.titleELarge),
          ),
          MyPageCommonWidget.divideLine(
              width: cardSize.width, padding: const EdgeInsets.only(top: 30, bottom: 48)),
          Row(
            children: [
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang["enterprise"], //"소속회사",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang["grade"], //"등급",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang["bookCount"], //"북 개수",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang["ratePlan"], //"요금제",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang["freeSpace"], //"남은 용량",
                      style: propertyFontStyle),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProperty.enterprise,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang['cretaGradeList']![userProperty.cretaGrade.index],
                      style: CretaFont.bodyMedium),
                  const SizedBox(height: 28),
                  Text("${userProperty.bookCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(CretaMyPageLang['ratePlanList']![userProperty.ratePlan.index],
                          style: CretaFont.bodyMedium),
                      const SizedBox(width: 24),
                      BTN.line_blue_t_m(
                          height: 32,
                          text: CretaMyPageLang["changePlan"], //"요금제 변경",
                          onPressed: () {})
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text("${userProperty.freeSpace} MB (Total: 1024 MB)",
                      style: CretaFont.bodyMedium),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 최근 요약 컴포넌트
  Widget recentLogInfo(UserPropertyModel userProperty) {
    TextStyle propertyFontStyle = CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400);
    return Container(
      width: cardSize.width,
      height: cardSize.height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 34, left: 28),
            child: Text(CretaMyPageLang['accountInfo']!, //"계정 정보",
                style: CretaFont.titleELarge),
          ),
          MyPageCommonWidget.divideLine(
              width: cardSize.width, padding: const EdgeInsets.only(top: 30, bottom: 48)),
          Row(
            children: [
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang['bookViewCount'], //"북 조회수",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang['bookViewTime'], //"북 시청시간",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang['likeCount'], //"좋아요 개수",
                      style: propertyFontStyle),
                  const SizedBox(height: 28),
                  Text(CretaMyPageLang['commentCount'], //"댓글 개수",
                      style: propertyFontStyle),
                ],
              ),
              const SizedBox(width: 26),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${userProperty.bookViewCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28),
                  Text("${userProperty.bookViewTime}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28),
                  Text("${userProperty.likeCount}", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28),
                  Text("${userProperty.commentCount} MB (Total 1024MB)",
                      style: CretaFont.bodyMedium),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 계정 정보 컴포넌트
  Widget teamInfo(List<TeamModel> teamList) {
    return Container(
      width: cardSize.width,
      height: cardSize.height,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 34, left: 28),
            child: Text(CretaMyPageLang['myTeam'], //"내 팀",
                style: CretaFont.titleELarge),
          ),
          MyPageCommonWidget.divideLine(
              width: cardSize.width, padding: const EdgeInsets.only(top: 30, bottom: 48)),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var team in teamList) ...[
                Text(team.name, style: CretaFont.bodyMedium),
                const SizedBox(height: 28.0)
              ]
            ]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPropertyManager, TeamManager>(
      builder: (context, userPropertyManager, teamManager, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
              child: widget.width > cardSize.width
                  ? Column(
                      children: [
                        const SizedBox(height: 60),
                        MyPageCommonWidget.profileImgComponent(
                          width: 200,
                          height: 200,
                          profileImgUrl: userPropertyManager.userPropertyModel!.profileImgUrl,
                          userName: userPropertyManager.userPropertyModel!.nickname,
                          replaceColor: widget.replaceColor,
                          borderRadius: BorderRadius.circular(200),
                        ),
                        const SizedBox(height: 40.0),
                        Text(userPropertyManager.userPropertyModel!.nickname,
                            style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 16),
                        Text(userPropertyManager.userPropertyModel!.email,
                            style: CretaFont.buttonLarge.copyWith(color: CretaColor.text.shade400)),
                        const SizedBox(height: 86.0),
                        widget.width > 1600
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  accountInfo(userPropertyManager.userPropertyModel!),
                                  SizedBox(width: widget.width * .024),
                                  recentLogInfo(userPropertyManager.userPropertyModel!),
                                  SizedBox(width: widget.width * .024),
                                  teamInfo(teamManager.teamModelList)
                                ],
                              )
                            : Column(
                                children: [
                                  accountInfo(userPropertyManager.userPropertyModel!),
                                  const SizedBox(height: 40),
                                  recentLogInfo(userPropertyManager.userPropertyModel!),
                                  const SizedBox(height: 40),
                                  teamInfo(teamManager.teamModelList)
                                ],
                              )
                      ],
                    )
                  : const SizedBox.shrink()),
        );
      },
    );
  }
}
