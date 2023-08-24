import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';



class MyPageAccountManage extends StatefulWidget {

  final double width;
  final double height;
  const MyPageAccountManage({super.key, required this.width, required this.height});

  @override
  State<MyPageAccountManage> createState() => _MyPageAccountManageState();
}

class _MyPageAccountManageState extends State<MyPageAccountManage> {


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
            child: Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.accountManage,
                    style: const TextStyle(
                      fontFamily: 'Pretendard', 
                      fontWeight: CretaFont.semiBold, 
                      fontSize: 40, color: 
                      CretaColor.text
                    ),
                  ),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.purposeSetting,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  CretaMyPageLang.usePresentation,
                                  style: CretaFont.titleMedium,
                                ),
                                const SizedBox(height: 25.0),
                                Text(
                                  CretaMyPageLang.useDigitalSignage,
                                  style: CretaFont.titleMedium,
                                ),
                              ],
                            ),
                            const SizedBox(width: 81.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaToggleButton(
                                  isActive: false,
                                  defaultValue: true,
                                  onSelected: (value) { },
                                ),
                                const SizedBox(height: 16.0),
                                CretaToggleButton(
                                  defaultValue: userPropertyManager.userPropertyModel!.useDigitalSignage,
                                  onSelected: (value) { 
                                    userPropertyManager.userPropertyModel!.useDigitalSignage = value;
                                    userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                                  },
                                )
                              ],
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 27.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.ratePlan,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.ratePlanList[userPropertyManager.userPropertyModel!.ratePlan.index],
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 24.0),
                            BTN.line_blue_t_m(
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
                        const SizedBox(height: 13.0),
                        Text(
                          CretaMyPageLang.ratePlanTip,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 35.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.channelSetting,
                          style: CretaFont.titleELarge,
                        ),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.publicProfile,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 199.0),
                            CretaToggleButton(
                              defaultValue: userPropertyManager.userPropertyModel!.isPublicProfile,
                              onSelected: (value) {
                                userPropertyManager.userPropertyModel!.isPublicProfile = value;
                                userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                              }, 
                            )
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          CretaMyPageLang.profileTip,
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const SizedBox(height: 23.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              CretaMyPageLang.backgroundImgSetting,
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 24.0),
                            BTN.line_blue_t_m(
                              text: CretaMyPageLang.selectImgBTN, 
                              onPressed: () {

                              }
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  divideLine(topPadding: 32.0, bottomPadding: 32.0, width: widget.width * .7),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          CretaMyPageLang.allDeviceLogout,
                          style: CretaFont.titleMedium,
                        ),
                        const SizedBox(width: 24.0),
                        BTN.line_red_t_m(
                          text: CretaMyPageLang.logoutBTN, 
                          onPressed: () {

                          }
                        ),
                        const SizedBox(width: 80.0),
                        Text(
                          CretaMyPageLang.removeAccount,
                          style: CretaFont.titleMedium,
                        ),
                        const SizedBox(width: 24.0),
                        BTN.fill_red_t_m(
                          text: CretaMyPageLang.removeAccountBTN, 
                          width: 81,
                          onPressed: () {

                          }
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 120.0)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}