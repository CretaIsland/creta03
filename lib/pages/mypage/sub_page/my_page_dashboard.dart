import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/creta_font.dart';


class MyPageDashBoard extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageDashBoard({super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageDashBoard> createState() => _MyPageDashBoardState();
}



class _MyPageDashBoardState extends State<MyPageDashBoard> {


  Widget divideLine({double leftPadding = 0.0, double topPadding = 0.0, double rightPadding = 0.0, double bottomPadding = 0.0, double width = 10.0, double height = 1.0}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(leftPadding, topPadding, rightPadding, bottomPadding),
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
      ),
    );
  }

  Widget profileImgComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(100.0),
        color: widget.replaceColor,
        image: userPropertyManager.userPropertyModel!.profileImgUrl == '' ? null : DecorationImage(
          image: NetworkImage(userPropertyManager.userPropertyModel!.profileImgUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: userPropertyManager.userPropertyModel!.profileImgUrl == '' ? Center(
        child: Text(
          userPropertyManager.userPropertyModel!.nickname.substring(0, 1),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 80,
            color: Colors.white,
          ),
        ),
      ) : null
    );
  }

  Widget accountInfoComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: 400.0,
      height: 400.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
            child: Text('계정 정보', style: CretaFont.titleELarge),
          ),
          divideLine(width: 400.0, bottomPadding: 40.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('등급', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('북 개수', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('요금제', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('남은 용량', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400))
                ],
              ),
              const SizedBox(width: 40), 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.cretaGradeList[userPropertyManager.userPropertyModel!.cretaGrade.index], style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                  const SizedBox(height: 28 ),
                  Text(userPropertyManager.userPropertyModel!.bookCount.toString(), style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(CretaMyPageLang.ratePlanList[userPropertyManager.userPropertyModel!.ratePlan.index], style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                      const SizedBox(width: 10),
                      BTN.line_blue_t_m(text: '요금제 변경', onPressed: () {
                        showDialog(
                          context: context, 
                          builder: (context) => PopUpRatePlan.ratePlanPopUp(context),
                        );
                      })
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('${userPropertyManager.userPropertyModel!.freeSpace} (전체 1024MB)', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget recentInfoComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: 400.0,
      height: 400.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('최근 요약', style: CretaFont.titleELarge),
                const SizedBox(width: 180),
                Text('지난 30일', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade400)),
              ],
            ),
          ),
          divideLine(width: 400.0, bottomPadding: 40.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('북 조회수', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('북 시청시간', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('좋아요 개수', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                  const SizedBox(height: 28),
                  Text('댓글 개수', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400))
                ],
              ),
              const SizedBox(width: 40), 
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${userPropertyManager.userPropertyModel!.bookViewCount}', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                  const SizedBox(height: 28 ),
                  Text('${userPropertyManager.userPropertyModel!.bookViewTime} 시간', style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                  const SizedBox(height: 28),
                  Text(userPropertyManager.userPropertyModel!.likeCount.toString(), style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700)),
                  const SizedBox(height: 28),
                  Text(userPropertyManager.userPropertyModel!.commentCount.toString(), style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget teamInfoComponent(TeamManager teamManager) {
    return Container(
      width: 400.0,
      height: 400.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
            child: Text('내 팀', style: CretaFont.titleELarge),
          ),
          divideLine(width: 400.0, bottomPadding: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for(var team in teamManager.teamModelList)...[
                  Text(
                    team.name,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0)
                ]
              ],
            ),
          )
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
            scrollDirection: Axis.vertical,
            child: widget.width > 400 ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 60.0),
                profileImgComponent(userPropertyManager),
                const SizedBox(height: 40.0),
                Text(
                  userPropertyManager.userPropertyModel!.nickname,
                  style: const TextStyle(
                    fontFamily: 'Pretendard', 
                    fontWeight: CretaFont.semiBold, 
                    fontSize: 40, 
                    color: CretaColor.text
                  ),
                ),
                const SizedBox(height: 16.0),
                // user email
                Text(
                  userPropertyManager.userPropertyModel!.email,
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Colors.grey.shade400,
                  )
                ),
                const SizedBox(height: 86.0),
                // data components
                widget.width > 1600 ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    accountInfoComponent(userPropertyManager),
                    SizedBox(width: widget.width * .024),
                    recentInfoComponent(userPropertyManager),
                    SizedBox(width: widget.width * .024),
                    teamInfoComponent(teamManager)
                  ],
                ) : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    accountInfoComponent(userPropertyManager),
                    const SizedBox(height: 40.0),
                    recentInfoComponent(userPropertyManager),
                    const SizedBox(height: 40.0),
                    teamInfoComponent(teamManager)
                  ],
                ),
                const SizedBox(height: 60.0)
              ],
            ) : const SizedBox(), 
          ),
        );
      }
    );
  }



}