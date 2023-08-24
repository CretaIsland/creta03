import 'package:creta03/design_system/dialog/creta_dialog.dart';
import 'package:flutter/material.dart';

import 'dart:typed_data';
import 'package:hycop/hycop.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

import 'package:creta03/data_io/team_manager.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/text_field/creta_text_field.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';




class MyPageInfo extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageInfo({super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {

  // dropdown menu item
  List<Text> countryItemList = [];
  List<Text> languageItemList = [];
  List<Text> jobItemList = [];

  // local load image for profile
  XFile? _pickedFile;
  String _nowPassword = '';
  String _newPassword = '';
  String _checkNewPassword = '';


  @override
  void initState() {
    super.initState();

    // set country dropdown menu item
    for (var element in CretaMyPageLang.countryList) {
      countryItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set language dropdown menu item
    for (var element in CretaMyPageLang.languageList) {
      languageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set job dropdown menu item
    for (var element in CretaMyPageLang.jobList) {
      jobItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
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

  Widget profileImageComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: widget.replaceColor,
        image: userPropertyManager.userPropertyModel!.profileImg == '' ? null : DecorationImage(
          image: Image.network(userPropertyManager.userPropertyModel!.profileImg).image,
          fit: BoxFit.cover
        )
      ),
      child: Center(
        child: Stack(
          children: [
            userPropertyManager.userPropertyModel!.profileImg != '' ? const SizedBox() : 
              Text(
                userPropertyManager.userPropertyModel!.nickname.substring(0, 1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: CretaFont.semiBold,
                  fontSize: 64,
                  color: Colors.white
                )
              ),
            BTN.opacity_gray_i_l(
              icon: Icons.photo_camera_outlined, 
              onPressed: () async {
                try {
                  _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(_pickedFile != null) {
                    Uint8List fileBytes = await _pickedFile!.readAsBytes();
                    if(fileBytes.isNotEmpty) {
                      HycopFactory.storage!.uploadFile(_pickedFile!.name, _pickedFile!.mimeType!, fileBytes, folderName: "profile/").then((fileModel) {
                        if(fileModel != null) {
                          userPropertyManager.userPropertyModel!.profileImg = fileModel.fileView;
                          userPropertyManager.notify();
                        }
                      });
                    }
                    _pickedFile = null;
                  }
                } catch (error) {
                  logger.info('something wrong in my_page_info >> $error');
                }
              }
            ) 
          ],
        ),
      ),
    );
  }

  Widget changePwdPopUp() {
    return CretaDialog(
      width: 406.0,
      height: 289.0,
      title: '비밀번호 변경',
      crossAxisAlign: CrossAxisAlignment.center,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 28.0),
          CretaTextField(
              textFieldKey: GlobalKey(),
              value: '', 
              hintText: '현재 비밀번호', 
              width: 294.0,
              height: 30.0,
              onChanged: (value) => _nowPassword = value,
              onEditComplete: (String value) => _nowPassword = value,
            ),
            const SizedBox(height: 20.0),
            CretaTextField(
              textFieldKey: GlobalKey(),
              value: '', 
              hintText: '새 비밀번호', 
              width: 294.0,
              height: 30.0,
              onChanged: (value) => _newPassword = value,
              onEditComplete: (String value) => _newPassword = value,
            ),
            const SizedBox(height: 20.0),
            CretaTextField(
              textFieldKey: GlobalKey(),
              value: '', 
              hintText: '새 비밀번호 확인', 
              width: 294.0,
              height: 30.0,
              onChanged: (value) => _checkNewPassword = value,
              onEditComplete: (String value) => _checkNewPassword = value,
            ),
            const SizedBox(height: 24.0),
            BTN.fill_blue_t_m(
              text: CretaMyPageLang.passwordChangeBTN, 
              width: 294.0,
              height: 32.0,
              onPressed: () {
                if(_nowPassword.isEmpty || _newPassword.isEmpty || _checkNewPassword.isEmpty) {
                  logger.info('empty textfield');
                  return;
                }
                if(_newPassword != _checkNewPassword) {
                  logger.info('not match new password');
                  return;
                }
                if(_newPassword == _checkNewPassword) {
                  HycopFactory.account!.updateAccountPassword(_newPassword, _nowPassword).onError((error, stackTrace) {
                    if(error.toString().contains('no exist')) {
                     logger.info('wrong password');
                    }
                  }).then((value) => Navigator.of(context).pop());
                }
              }
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
            child: widget.width > 300 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CretaMyPageLang.info,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: CretaFont.semiBold,
                      fontSize: 40,
                      color: CretaColor.text
                    )
                  ),
                  divideLine(width: widget.width * .7, topPadding: 22.0, bottomPadding: 32.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      Text(
                        CretaMyPageLang.profileImage,
                        style: CretaFont.titleMedium,
                      ),
                      const SizedBox(width: 95.0),
                      profileImageComponent(userPropertyManager)
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 135.0, top: 24.0),
                    child: BTN.line_blue_t_m(
                      text: CretaMyPageLang.basicProfileImgBTN, 
                      onPressed: () {
                        userPropertyManager.userPropertyModel!.profileImg = '';
                        userPropertyManager.notify();
                      }
                    ),
                  ),
                  divideLine(width: widget.width * .7, topPadding: 32.0, bottomPadding: 39.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CretaMyPageLang.nickname,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            CretaMyPageLang.email,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            CretaMyPageLang.phoneNumber,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            CretaMyPageLang.password,
                            style: CretaFont.titleMedium,
                          )
                        ],
                      ),
                      const SizedBox(width: 67.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 16,
                            child: TextField(
                              cursorHeight: 16,
                              maxLines: 1,
                              style: CretaFont.bodyMedium,
                              decoration: InputDecoration(
                                hintText: userPropertyManager.userPropertyModel!.nickname,
                                border: InputBorder.none,
                                hintMaxLines: 1
                              ),
                              onChanged: (value) {
                                userPropertyManager.userPropertyModel!.nickname = value;
                                userPropertyManager.notify();
                              }
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Text(
                            userPropertyManager.userPropertyModel!.email,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 32.0),
                          Text(
                            "01012341234",
                            //userPropertyManager.userPropertyModel!.phoneNumber,
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          BTN.line_blue_t_m(
                            text: CretaMyPageLang.passwordChangeBTN, 
                            onPressed: () {
                              showDialog(
                                context: context, 
                                builder: (context) => changePwdPopUp()
                              );
                            }
                          )
                        ],
                      )
                    ],
                  ),
                  divideLine(width: widget.width * .7, topPadding: 32.0, bottomPadding: 39.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            CretaMyPageLang.country,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            CretaMyPageLang.language,
                            style: CretaFont.titleMedium,
                          ),
                          const SizedBox(height: 30.0),
                          Text(
                            CretaMyPageLang.job,
                            style: CretaFont.titleMedium,
                          )
                        ],
                      ),
                      const SizedBox(width: 67.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CretaWidgetDropDown(
                            items: countryItemList, 
                            defaultValue: userPropertyManager.userPropertyModel!.country.index, 
                            width: 116,
                            height: 32,
                            onSelected: (value) {
                              userPropertyManager.userPropertyModel!.country = CountryType.fromInt(value);
                            }
                          ),
                          const SizedBox(height: 17.0),
                          CretaWidgetDropDown(
                            items: languageItemList, 
                            defaultValue: userPropertyManager.userPropertyModel!.language.index, 
                            width: 102,
                            height: 32,
                            onSelected: (value) {
                              userPropertyManager.userPropertyModel!.language = LanguageType.fromInt(value);
                            }
                          ),
                          const SizedBox(height: 17.0),
                          CretaWidgetDropDown(
                            items: jobItemList, 
                            defaultValue: userPropertyManager.userPropertyModel!.job.index, 
                            width: 102,
                            height: 32,
                            onSelected: (value) {
                              userPropertyManager.userPropertyModel!.job = JobType.fromInt(value);
                            }
                          )
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 40.0, bottom: 60.0),
                    child: BTN.fill_blue_t_el(
                      text: CretaMyPageLang.saveChangeBTN, 
                      onPressed: () {
                        userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                      }
                    ),
                  )
                ],
              ),
            ) : const SizedBox()
          ),
        );
      },
    );
  }
}