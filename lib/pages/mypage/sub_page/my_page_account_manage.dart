import 'package:creta03/data_io/user_property_manager.dart';
import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_toggle_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../lang/creta_mypage_lang.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class MyPageAccountManage extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageAccountManage({super.key, required this.width, required this.height});

  @override
  State<MyPageAccountManage> createState() => _MyPageAccountManageState();
}

class _MyPageAccountManageState extends State<MyPageAccountManage> {


  // 구분선
  Widget divideLine({double leftPadding = 0, double topPadding = 0, double rightPadding = 0, double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding), 
      child: Container(
        width: widget.width * .7,
        height: 1,
        color: Colors.grey.shade200 ,
      ),
    );
  }

  Widget mainContainer() {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManagerHolder, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 670 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.accountManage, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
                  divideLine(topPadding: 22.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.purposeSetting, style: CretaFont.titleELarge),
                        const SizedBox(height: 32.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang.usePresentation, style: CretaFont.titleMedium),
                                const SizedBox(height: 25.0),
                                Text(CretaMyPageLang.useDigitalSignage, style: CretaFont.titleMedium)
                              ],
                            ),
                            const SizedBox(width: 32.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaToggleButton(
                                  onSelected: (value) {}, 
                                  defaultValue: true,
                                  isActive: false,
                                ),
                                const SizedBox(height: 16.0),
                                CretaToggleButton(
                                  onSelected: (value) {
                                    userPropertyManagerHolder.propertyModel!.useDigitalSignage = value;
                                    userPropertyManagerHolder.setToDB(userPropertyManagerHolder.propertyModel!);
                                  }, 
                                  defaultValue: userPropertyManagerHolder.propertyModel!.useDigitalSignage
                                )
                              ] 
                            )
                          ]
                        )
                      ]
                    )
                  ),
                  divideLine(topPadding: 27.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.ratePlan, style: CretaFont.titleELarge),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.ratePlanList[userPropertyManagerHolder.propertyModel!.ratePlan.index], style: CretaFont.titleMedium),
                            const SizedBox(width: 24.0),
                            BTN.line_blue_t_m(text: CretaMyPageLang.ratePlanChangeBTN, onPressed: () {})
                          ],
                        ),
                        const SizedBox(height: 13.0),
                        Text(CretaMyPageLang.ratePlanTip, style: CretaFont.bodySmall)
                      ]
                    )
                  ),
                  divideLine(topPadding: 35.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.channelSetting, style: CretaFont.titleELarge),
                        const SizedBox(height: 32.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.publicProfile, style: CretaFont.titleMedium),
                            const SizedBox(width: 199.0),
                            CretaToggleButton(
                              onSelected: (value) {
                                userPropertyManagerHolder.propertyModel!.isPublicProfile = value;
                                userPropertyManagerHolder.setToDB(userPropertyManagerHolder.propertyModel!);
                              }, 
                              defaultValue: userPropertyManagerHolder.propertyModel!.isPublicProfile
                            )
                          ]
                        ),
                        const SizedBox(height: 16.0),
                        Text(CretaMyPageLang.profileTip, style: CretaFont.bodySmall),
                        const SizedBox(height: 23.0),
                        Row(
                          children: [
                            Text(CretaMyPageLang.backgroundImgSetting, style: CretaFont.titleMedium),
                            const SizedBox(width: 24.0),
                            BTN.line_blue_t_m(text: CretaMyPageLang.selectImgBTN, onPressed: () {})
                          ]
                        )
                      ]
                    )
                  ),
                  divideLine(topPadding: 32.0, bottomPadding: 32.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Row(
                      children: [
                        Text(CretaMyPageLang.allDeviceLogout, style: CretaFont.titleMedium),
                        const SizedBox(width: 24.0),
                        BTN.line_red_t_m(text: CretaMyPageLang.logoutBTN, onPressed: () {}),
                        const SizedBox(width: 80.0),
                        Text(CretaMyPageLang.removeAccount, style: CretaFont.titleMedium),
                        const SizedBox(width: 24.0),
                        BTN.fill_red_t_m(width: 81.0, text: CretaMyPageLang.removeAccountBTN, onPressed: () {})
                      ]
                    )
                  ),
                  const SizedBox(height: 210.0)
                ]
              )
            ) : Container()
          )
        ); 
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainContainer();
  }

}