import 'dart:typed_data';

import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

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

  XFile? _pickedFile;

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

  Widget bannerImageComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: widget.width * .6,
      height: 181.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0),
        color: CretaColor.primary.shade200,
        image: userPropertyManager.userPropertyModel!.channelBannerImg == '' ? null : DecorationImage(
          image: Image.network(userPropertyManager.userPropertyModel!.channelBannerImg).image,
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Stack(
          children: [
            userPropertyManager.userPropertyModel!.channelBannerImg != '' ? const SizedBox() : 
              Text(
                '선택된 배경 이미지가 없습니다.',
                style: CretaFont.bodySmall
              ),
            Container(
              margin: EdgeInsets.only(top: 110, left: widget.width * .6 - 68.0),
              child: BTN.opacity_gray_i_l(
                icon: Icons.photo_camera_outlined, 
                onPressed: () async {
                  try {
                    _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(_pickedFile != null) {
                      _pickedFile!.readAsBytes().then((fileBytes) {
                        if(fileBytes.isNotEmpty) {
                          // popup 호출
                          showDialog(
                            context: context, 
                            builder: (context) => editBannerImgPopUp(fileBytes, userPropertyManager),
                          );
                        }
                      });
                    }
                  } catch (error) {
                    logger.info('something wrong in my_page_team_manage >> $error');
                  }
                }
              ),
            ) 
          ],
        ),
      ),
    );
  }

  // popup screen
  Widget editBannerImgPopUp(Uint8List bannerImgBytes, UserPropertyManager userPropertyManager) {
    return CretaDialog(
      width: 897,
      height: 518,
      title: '배경 이미지 설정',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 865,
            height: 375,
            margin: const EdgeInsets.only(top: 20.0, left: 16.0),
            decoration: BoxDecoration(
              image: DecorationImage(image: Image.memory(bannerImgBytes).image, fit: BoxFit.cover)
            ),
          ),
          divideLine(topPadding: 10.0, bottomPadding: 10.0, width: 897),
          Padding(
            padding: const EdgeInsets.only(left: 826.0),
            child: BTN.fill_blue_t_m(
              text: '완료', 
              width: 55,
              onPressed: () {
                HycopFactory.storage!.uploadFile(_pickedFile!.name, _pickedFile!.mimeType!, bannerImgBytes, folderName: "banner/").then((fileModel) {
                  if(fileModel != null) {
                    Navigator.of(context).pop();
                  }
                });
              }
            ),
          )
        ],
      )
    );
  }

  Widget channelDiscriptionComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: widget.width * .6,
      height: 181.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: CretaTextField.long(
        textFieldKey: GlobalKey(), 
        value: '', 
        hintText: '',
        radius: 20, 
        onEditComplete: (value) {
          
        }
      )
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '배경 이미지',
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 50),
                            // image select box
                            bannerImageComponent(userPropertyManager)
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '정보 설명',
                              style: CretaFont.titleMedium,
                            ),
                            const SizedBox(width: 63),
                            // image select box
                            channelDiscriptionComponent(userPropertyManager)
                          ],
                        ),
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