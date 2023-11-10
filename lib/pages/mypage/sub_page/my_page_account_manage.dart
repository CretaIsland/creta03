import 'package:creta03/data_io/channel_manager.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/buttons/creta_toggle_button.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/mypage/popup/edit_banner_popup.dart';
import 'package:creta03/pages/mypage/popup/popup_rateplan.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
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
  
  
  XFile? _pickedFile;
  
  
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserPropertyManager, ChannelManager>(
      builder: (context, userPropertyManager, channelManager, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: widget.width > 800 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('계정 관리', style: CretaFont.headlineLarge.copyWith(fontWeight: FontWeight.w600, color: CretaColor.text.shade700)),
                  divideLine(width: 1000.0, topPadding: 22.0, bottomPadding: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('용도 설정', style: CretaFont.titleELarge.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 37),
                          Text('프레젠테이션 기능 사용하기', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 25),
                          Text('디지털 사이니지 기능 사용하기', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700))
                        ],
                      ),
                      const SizedBox(width: 80),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 58),
                          CretaToggleButton(
                            defaultValue: true,
                            isActive: false,
                            onSelected: (value) {},
                          ),
                          const SizedBox(height: 16),
                          CretaToggleButton(
                            defaultValue: userPropertyManager.userPropertyModel!.useDigitalSignage,
                            onSelected: (value) {
                              userPropertyManager.userPropertyModel!.useDigitalSignage = value;
                              userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                            },
                          )
                        ],
                      )
                    ],
                  ),
                  divideLine(width: 1000, topPadding: 27, bottomPadding: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('요금제', style: CretaFont.titleELarge.copyWith(color: CretaColor.text.shade700)),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Text(CretaMyPageLang.ratePlanList[userPropertyManager.userPropertyModel!.ratePlan.index], style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                            const SizedBox(width: 24),
                            BTN.line_blue_t_m(text: '요금제 변경', onPressed: () {
                               showDialog(
                                context: context, 
                                builder: (context) => PopUpRatePlan.ratePlanPopUp(context),
                              );  
                            })
                          ],
                        ),
                        const SizedBox(height: 13),
                        Text('팀 요금제를 사용해보세요!', style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                      ],
                    ),
                  ),
                  divideLine(width: 1000, topPadding: 34,  bottomPadding: 32),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('채널 설정', style: CretaFont.titleELarge.copyWith(color: CretaColor.text.shade700)),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('프로필 공개', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                            const SizedBox(width: 100),
                            CretaToggleButton(
                              defaultValue: userPropertyManager.userPropertyModel!.isPublicProfile,
                              onSelected: (value) {
                                userPropertyManager.userPropertyModel!.isPublicProfile = value;
                                userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                              },  
                            )
                          ],
                        ),
                        const SizedBox(height: 13),
                        Text('모든 사람들에게 프로필이 공개됩니다.', style: CretaFont.bodySmall.copyWith(color: CretaColor.text.shade400)),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('배경 이미지', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                            const SizedBox(width: 49),
                            bannerImgComponent()
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('정보 설명', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                            const SizedBox(width: 63),
                            channelDiscriptionComponent()
                          ],
                        ),
                      ],
                    ),
                  ),
                  divideLine(width: 1000, topPadding: 32, bottomPadding: 32),
                  Row(
                    children: [
                      const SizedBox(width: 12),
                      Text(
                        CretaMyPageLang.allDeviceLogout,
                        style: CretaFont.titleMedium,
                      ),
                      const SizedBox(width: 24.0),
                      BTN.line_red_t_m(
                        text: CretaMyPageLang.logoutBTN, 
                        onPressed: () { }
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
                        onPressed: () { }
                      ),
                    ],
                  ),
                  const SizedBox(height: 142)
                ],
              ),
            ) : null,
          ),
        );
      }
    );
  }


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

  Widget bannerImgComponent() {
    return Container(
      width: widget.width * .6,
      height: 181,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0),
        image: CretaAccountManager.getChannel!.bannerImgUrl == '' ? null : DecorationImage(
          image: Image.network(CretaAccountManager.getChannel!.bannerImgUrl).image,
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Stack(
          children: [
            CretaAccountManager.getChannel!.bannerImgUrl != '' ? const SizedBox() : 
              Center(
                child: Text(
                  '선택된 배경 이미지가 없습니다.',
                  style: CretaFont.bodySmall
                ),
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
                            builder: (context) {
                              return EditBannerImgPopUp(bannerImgBytes: fileBytes, selectedImg: _pickedFile!);
                            }
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

  Widget channelDiscriptionComponent() {
    return Container(
      width: widget.width * .6,
      height: 181.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: CretaTextField.long(
        textFieldKey: GlobalKey(), 
        value: CretaAccountManager.getChannel!.description, 
        hintText: '채널 설명을 입력하세요',
        radius: 20, 
        onEditComplete: (value) {
          CretaAccountManager.getChannel!.description = value;
          CretaAccountManager.setChannelDescription(CretaAccountManager.getChannel!);
        }
      )
    );
  }




}