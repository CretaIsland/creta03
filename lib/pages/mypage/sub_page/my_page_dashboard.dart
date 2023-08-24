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
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(
              CretaMyPageLang.accountInfo,
              style: CretaFont.titleELarge
            ),
          ),
          divideLine(topPadding: 32, bottomPadding: 40.0, width: 400.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.grade,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.bookCount,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.ratePlan,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.freeSpace,
                    style: CretaFont.bodyMedium,
                  )
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.cretaGradeList[userPropertyManager.userPropertyModel!.cretaGrade.index],
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    userPropertyManager.userPropertyModel!.bookCount.toString(),
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        CretaMyPageLang.ratePlanList[userPropertyManager.userPropertyModel!.ratePlan.index],
                        style: CretaFont.bodyMedium,
                      ),
                      const SizedBox(width: 24.0),
                      BTN.line_blue_t_m(
                        height: 32.0,
                        text: CretaMyPageLang.ratePlanChangeBTN, 
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context) => PopUpRatePlan.ratePlanPopUp(context),
                          );
                        }
                      )
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '${userPropertyManager.userPropertyModel!.freeSpace} (전체 1024MB)',
                    style: CretaFont.bodyMedium,
                  )
                ],
              )
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
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: [
                Text(
                  CretaMyPageLang.accountInfo,
                  style: CretaFont.titleELarge
                ),
                const SizedBox(width: 192.0),
                Text(
                  '지난 30일', 
                  style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  )
                )
              ],
            ),
          ),
          divideLine(topPadding: 32, bottomPadding: 40.0, width: 400.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.bookViewCount,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.bookViewTime,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.likeCount,
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    CretaMyPageLang.commentCount,
                    style: CretaFont.bodyMedium,
                  )
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userPropertyManager.userPropertyModel!.bookViewCount.toString(),
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    '${userPropertyManager.userPropertyModel!.bookViewTime.toString()} 시간',
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    userPropertyManager.userPropertyModel!.likeCount.toString(),
                    style: CretaFont.bodyMedium,
                  ),
                  const SizedBox(height: 28.0),
                  Text(
                    userPropertyManager.userPropertyModel!.commentCount.toString(),
                    style: CretaFont.bodyMedium,
                  )
                ],
              )
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
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(
              CretaMyPageLang.myTeam,
              style: CretaFont.titleELarge
            ),
          ),
          divideLine(topPadding: 32, bottomPadding: 40.0, width: 400.0),
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
        ]
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
                // profile image component
                Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    color: widget.replaceColor,
                    image: userPropertyManager.userPropertyModel!.profileImg == '' ? null : DecorationImage(image: Image.network(userPropertyManager.userPropertyModel!.profileImg).image, fit: BoxFit.cover)
                  ),
                  child: userPropertyManager.userPropertyModel!.profileImg == '' ? Center(
                    child: Text(
                      userPropertyManager.userPropertyModel!.nickname.substring(0, 1),
                      style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 64, color: Colors.white),
                    ),
                  ) : null,
                ),
                const SizedBox(height: 40.0),
                // user nickname
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