import 'package:creta03/data_io/channel_manager.dart';
//import 'package:creta_common/model/app_enums.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';
import 'package:creta03/pages/mypage/popup/edit_banner_popup.dart';
import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? _selectedImg;

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPropertyManager, ChannelManager>(
      builder: (context, userPropertyManager, channelManager, child) {
        return Container(
            width: widget.width,
            height: widget.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: widget.width > 605
                  ? Padding(
                      padding: EdgeInsets.only(left: widget.width * 0.1, top: 72.0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(CretaMyPageLang['accountManage']!,
                            /*'계정 관리',*/
                            style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                        // MyPageCommonWidget.divideLine(
                        //     width: widget.width * .6,
                        //     padding: const EdgeInsets.only(top: 22, bottom: 32)),
                        // Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //   const SizedBox(width: 12.0),
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Text(CretaMyPageLang['purposeSetting']!,
                        //           /*'용도 설정',*/ style: CretaFont.titleELarge),
                        //       const SizedBox(height: 37),
                        //       Text(CretaMyPageLang['usePresentation']!,
                        //           /* '프레젠테이션 기능 사용하기1' */ style: CretaFont.titleMedium),
                        //       const SizedBox(height: 25),
                        //       Text(CretaMyPageLang['useDigitalSignage']!,
                        //           /*'디지털 사이니지 기능 사용하기',*/ style: CretaFont.titleMedium),
                        //       const SizedBox(height: 25),
                        //       Text(CretaMyPageLang['useDigitalBarricade']!,
                        //           /*'디지털 바리케이드 기능 사용하기',*/ style: CretaFont.titleMedium),
                        //       const SizedBox(height: 25),
                        //       Text(CretaMyPageLang['useBoard']!,
                        //           /*'전자칠판 기능 사용하기',*/ style: CretaFont.titleMedium),
                        //     ],
                        //   ),
                        //   const SizedBox(width: 80),
                        //   Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        //     const SizedBox(height: 58),
                        //     CretaToggleButton(
                        //       // 프리젠테이션 기능
                        //       defaultValue:
                        //           userPropertyManager.userPropertyModel!.purpose.isPresentation(),
                        //       onSelected: (value) {
                        //         if (value == true) {
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .unset(BookType.digitalBarricade);
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .unset(BookType.board);
                        //         }
                        //         userPropertyManager.userPropertyModel!.purpose
                        //             .set(BookType.presentation);
                        //         userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                        //       },
                        //     ),
                        //     const SizedBox(height: 16),
                        //     CretaToggleButton(
                        //       // 디지털 사이니지 기능
                        //       defaultValue:
                        //           userPropertyManager.userPropertyModel!.purpose.isDigitalSinage(),
                        //       onSelected: (value) {
                        //         if (value == true) {
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .unset(BookType.digitalBarricade);
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .unset(BookType.board);
                        //         }
                        //         userPropertyManager.userPropertyModel!.purpose
                        //             .set(BookType.signage);
                        //         userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                        //       },
                        //     ),
                        //     const SizedBox(height: 16), // 디지털 바리케이드 기능
                        //     CretaToggleButton(
                        //       defaultValue: userPropertyManager.userPropertyModel!.purpose
                        //           .isDigitalBarricade(),
                        //       onSelected: (value) {
                        //         setState(() {
                        //           if (value == true) {
                        //             userPropertyManager.userPropertyModel!.purpose.clear();
                        //           }
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .set(BookType.digitalBarricade);
                        //           userPropertyManager
                        //               .setToDB(userPropertyManager.userPropertyModel!);
                        //         });
                        //       },
                        //     ),
                        //     const SizedBox(height: 16),
                        //     CretaToggleButton(
                        //       // 전자질판 기능
                        //       defaultValue:
                        //           userPropertyManager.userPropertyModel!.purpose.isBoard(),
                        //       onSelected: (value) {
                        //         setState(() {
                        //           if (value == true) {
                        //             userPropertyManager.userPropertyModel!.purpose.clear();
                        //           }
                        //           userPropertyManager.userPropertyModel!.purpose
                        //               .set(BookType.board);
                        //           userPropertyManager
                        //               .setToDB(userPropertyManager.userPropertyModel!);
                        //         });
                        //       },
                        //     )
                        //   ])
                        // ]),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 27, bottom: 32)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(CretaMyPageLang['ratePlan'], //'요금제', s
                                  style: CretaFont.titleELarge),
                              const SizedBox(height: 32),
                              Row(
                                children: [
                                  Text(
                                      CretaMyPageLang['ratePlanList']![
                                          userPropertyManager.userPropertyModel!.ratePlan.index],
                                      style: CretaFont.titleMedium),
                                  const SizedBox(width: 12),
                                  BTN.line_blue_t_m(
                                      text: CretaMyPageLang['ratePlanChangeBTN'], //'요금제 변경',
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) =>
                                              PopUpRatePlan.ratePlanPopUp(context),
                                        );
                                      })
                                ],
                              ),
                              const SizedBox(height: 13),
                              Text(CretaMyPageLang['ratePlanTip'], //'팀 요금제를 사용해보세요!',
                                  style: CretaFont.bodySmall
                                      .copyWith(color: CretaColor.text.shade400)),
                            ],
                          ),
                        ),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 34, bottom: 32)),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(CretaMyPageLang['channelSetting'], //'채널 설정',
                                  style: CretaFont.titleELarge),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(CretaMyPageLang['publicProfile'], //"프로필 공개",
                                      style: CretaFont.titleMedium),
                                  const SizedBox(width: 100),
                                  CretaToggleButton(
                                      onSelected: (value) {
                                        userPropertyManager.userPropertyModel!.isPublicProfile =
                                            value;
                                        userPropertyManager
                                            .setToDB(userPropertyManager.userPropertyModel!);
                                      },
                                      defaultValue:
                                          userPropertyManager.userPropertyModel!.isPublicProfile)
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(CretaMyPageLang['profileTip'], //"모든 사람들에게 프로필이 공개됩니다.",
                                  style: CretaFont.bodySmall
                                      .copyWith(color: CretaColor.text.shade400)),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(CretaMyPageLang['backgroundImg'], //"배경 이미지",
                                      style: CretaFont.titleMedium),
                                  //const SizedBox(width: 50),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 50),
                                      child: MyPageCommonWidget.channelBannerImgComponent(
                                          //width: widget.width * .6,
                                          bannerImgUrl:
                                              CretaAccountManager.getChannel!.bannerImgUrl,
                                          onPressed: () async {
                                            try {
                                              _selectedImg = await ImagePicker()
                                                  .pickImage(source: ImageSource.gallery);
                                              if (_selectedImg != null) {
                                                _selectedImg!.readAsBytes().then((fileBytes) {
                                                  if (fileBytes.isNotEmpty) {
                                                    // popup 호출
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return EditBannerImgPopUp(
                                                              bannerImgBytes: fileBytes,
                                                              selectedImg: _selectedImg!);
                                                        });
                                                  }
                                                });
                                              }
                                            } catch (error) {
                                              logger.info(
                                                  'something wrong in my_page_team_manage >> $error');
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 32),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(CretaMyPageLang['introChannel'], //"채널 소개",
                                      style: CretaFont.titleMedium),
                                  //const SizedBox(width: 64),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 64, right: 50),
                                      child: MyPageCommonWidget.channelDescriptionComponent(
                                          //width: widget.width * .6,
                                          ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 34, bottom: 32)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12),
                            Text(CretaMyPageLang['allDeviceLogout']!, style: CretaFont.titleMedium),
                            const SizedBox(width: 24.0),
                            BTN.line_red_t_m(text: CretaMyPageLang['logoutBTN']!, onPressed: () {}),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12.0),
                            Text(CretaMyPageLang['removeAccount']!, style: CretaFont.titleMedium),
                            const SizedBox(width: 24.0),
                            BTN.fill_red_t_m(
                                text: CretaMyPageLang['removeAccountBTN']!,
                                width: 140,
                                onPressed: () {}),
                          ],
                        ),
                        const SizedBox(height: 142),
                      ]))
                  : const SizedBox.shrink(),
            ));
      },
    );
  }
}
