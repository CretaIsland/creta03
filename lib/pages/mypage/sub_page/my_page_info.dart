import 'dart:typed_data';

//import 'package:creta_common/lang/creta_lang.dart';
import 'package:creta_user_io/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta03/pages/mypage/mypage_common_widget.dart';
import 'package:creta03/pages/mypage/popup/chage_pwd_popup.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../design_system/component/snippet.dart';

class MyPageInfo extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageInfo(
      {super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {
  // 프로필 이미지 변경
  XFile? _selectedImg;
  Uint8List? _selectedImgBytes;
  // 닉네임 변경
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  // 국가, 언어, 직업 드롭 다운 메뉴
  List<Text> countryItemList = [];
  List<Text> languageItemList = [];
  List<Text> jobItemList = [];

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // set country dropdown menu item
    _initMenu();
  }

  void _initMenu() {
    countryItemList.clear();
    for (var element in CretaMyPageLang['countryList']!) {
      countryItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set language dropdown menu item
    languageItemList.clear();
    for (var element in CretaMyPageLang['languageList']!) {
      languageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // set job dropdown menu item
    jobItemList.clear();
    for (var element in CretaMyPageLang['jobList']!) {
      jobItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManager, child) {
        _nicknameController.text = userPropertyManager.userPropertyModel!.nickname;
        _phoneNumberController.text = userPropertyManager.userPropertyModel!.phoneNumber;
        int countryIndex = userPropertyManager.userPropertyModel!.country.index;
        int langIndex = userPropertyManager.userPropertyModel!.language.index;
        int jobIndex = userPropertyManager.userPropertyModel!.job.index;
        // print(
        //     "Consumer<UserPropertyManager>-----$langIndex------${userPropertyManager.userPropertyModel!.language}----------------------------------------");
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: widget.width > 500
                ? Padding(
                    padding: EdgeInsets.only(left: widget.width * 0.1, top: 72.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang['info']!,
                            style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 30, bottom: 50)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12.0),
                            Text(CretaMyPageLang['profileImage']!, style: CretaFont.titleMedium),
                            const SizedBox(width: 94),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MyPageCommonWidget.profileImgComponent(
                                    width: 200,
                                    height: 200,
                                    profileImgUrl:
                                        userPropertyManager.userPropertyModel!.profileImgUrl,
                                    profileImgBytes: _selectedImgBytes,
                                    userName: userPropertyManager.userPropertyModel!.nickname,
                                    replaceColor: widget.replaceColor,
                                    borderRadius: BorderRadius.circular(20),
                                    editBtn: Center(
                                      child: BTN.opacity_gray_i_l(
                                          icon: const Icon(Icons.camera_alt_outlined,
                                                  color: Colors.white)
                                              .icon!,
                                          onPressed: () async {
                                            try {
                                              _selectedImg = await ImagePicker()
                                                  .pickImage(source: ImageSource.gallery);
                                              if (_selectedImg != null) {
                                                _selectedImg!.readAsBytes().then((value) {
                                                  setState(() {
                                                    _selectedImgBytes = value;
                                                  });
                                                  HycopFactory.storage!
                                                      .uploadFile(
                                                          _selectedImg!.name,
                                                          _selectedImg!.mimeType!,
                                                          _selectedImgBytes!)
                                                      .then((value) {
                                                    if (value != null) {
                                                      userPropertyManager.userPropertyModel!
                                                          .profileImgUrl = value.url;
                                                    }
                                                  });
                                                });
                                              }
                                            } catch (error) {
                                              logger.info("error at mypage info >> $error");
                                            }
                                          }),
                                    )),
                                const SizedBox(height: 24),
                                BTN.line_blue_t_m(
                                    text: CretaMyPageLang['basicProfileImgBTN']!,
                                    onPressed: () {
                                      userPropertyManager.userPropertyModel!.profileImgUrl = '';
                                      userPropertyManager.notify();
                                    })
                              ],
                            )
                          ],
                        ),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 30, bottom: 40)),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const SizedBox(width: 12.0),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text(CretaMyPageLang['nickname']!, style: CretaFont.titleMedium),
                        //         const SizedBox(height: 30),
                        //         Text(CretaMyPageLang['email']!, style: CretaFont.titleMedium),
                        //         const SizedBox(height: 30),
                        //         Text(CretaMyPageLang['phoneNumber']!, style: CretaFont.titleMedium),
                        //         const SizedBox(height: 30),
                        //         Text(CretaMyPageLang['password']!, style: CretaFont.titleMedium),
                        //       ],
                        //     ),
                        //     const SizedBox(width: 67),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //             width: 200,
                        //             height: 20,
                        //             child: TextField(
                        //               controller: _nicknameController,
                        //               style: CretaFont.bodyMedium,
                        //               textAlignVertical: TextAlignVertical.top,
                        //               decoration: InputDecoration(
                        //                 hintText: CretaMyPageLang['nicknameInput']!,
                        //                 border: InputBorder.none,
                        //               ),
                        //               onEditingComplete: () => userPropertyManager
                        //                   .userPropertyModel!.nickname = _nicknameController.text,
                        //             )),
                        //         const SizedBox(height: 30),
                        //         Text(userPropertyManager.userPropertyModel!.email,
                        //             style: CretaFont.bodyMedium
                        //                 .copyWith(color: CretaColor.text.shade400)),
                        //         const SizedBox(height: 10),

                        //         SizedBox(
                        //             width: 200,
                        //             height: 20,
                        //             child: TextField(
                        //               controller: _phoneNumberController,
                        //               style: CretaFont.bodyMedium,
                        //               decoration: InputDecoration(
                        //                 hintText: CretaMyPageLang['phoneNumber']!,
                        //                 border: InputBorder.none,
                        //               ),
                        //               onEditingComplete: () => userPropertyManager
                        //                   .userPropertyModel!
                        //                   .phoneNumber = _phoneNumberController.text,
                        //             )),
                        //         // Text("01012341234",
                        //         //     style: CretaFont.bodyMedium
                        //         //         .copyWith(color: CretaColor.text.shade400)),
                        //         const SizedBox(height: 26),
                        //         BTN.line_blue_t_m(
                        //             height: 32,
                        //             text: CretaMyPageLang['passwordChangeBTN']!,
                        //             onPressed: () => showDialog(
                        //                 context: context,
                        //                 builder: (context) =>
                        //                     ChangePwdPopUp.changePwdPopUp(context)))
                        //       ],
                        //     )
                        //   ],
                        // ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12.0),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['nickname']!, style: CretaFont.titleMedium),
                                const SizedBox(width: 67),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  //color: Colors.amberAccent,
                                  width: 200,
                                  height: 20,
                                  child: TextField(
                                    controller: _nicknameController,
                                    style: CretaFont.bodyMedium,
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      hintText: CretaMyPageLang['nicknameInput']!,
                                      border: InputBorder.none,
                                    ),
                                    onEditingComplete: () => userPropertyManager
                                        .userPropertyModel!.nickname = _nicknameController.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['email']!, style: CretaFont.titleMedium),
                                const SizedBox(width: 67),
                                Text(
                                  userPropertyManager.userPropertyModel!.email,
                                  style: CretaFont.bodyMedium
                                      .copyWith(color: CretaColor.text.shade400),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['phoneNumber']!, style: CretaFont.titleMedium),
                                const SizedBox(width: 67),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 17),
                                  //color: Colors.amberAccent,
                                  width: 200,
                                  height: 20,
                                  child: TextField(
                                    controller: _phoneNumberController,
                                    style: CretaFont.bodyMedium,
                                    decoration: InputDecoration(
                                      hintText: CretaMyPageLang['phoneNumber']!,
                                      border: InputBorder.none,
                                    ),
                                    onEditingComplete: () => userPropertyManager.userPropertyModel!
                                        .phoneNumber = _phoneNumberController.text,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(CretaMyPageLang['password']!, style: CretaFont.titleMedium),
                                const SizedBox(width: 67),
                                BTN.line_blue_t_m(
                                  height: 32,
                                  text: CretaMyPageLang['passwordChangeBTN']!,
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => ChangePwdPopUp.changePwdPopUp(context),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 30, bottom: 40)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(CretaMyPageLang['country']!, style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text(CretaMyPageLang['language']!, style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text(CretaMyPageLang['job']!, style: CretaFont.titleMedium),
                              ],
                            ),
                            const SizedBox(width: 110),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaWidgetDropDown(
                                    width: 200,
                                    items: countryItemList,
                                    defaultValue: countryIndex > 0 ? countryIndex - 1 : 0,
                                    onSelected: (value) {
                                      userPropertyManager.userPropertyModel!.country =
                                          CountryType.fromInt(value + 1);
                                    }),
                                const SizedBox(height: 20.0),
                                CretaWidgetDropDown(
                                    width: 200,
                                    items: languageItemList,
                                    defaultValue: langIndex > 0 ? langIndex - 1 : 0,
                                    onSelected: (value) {
                                      Snippet.onLangSelected(
                                        value: value + 1,
                                        userPropertyManager: userPropertyManager,
                                        invalidate: () {
                                          userPropertyManager.notify();
                                        },
                                      );
                                      setState(() {
                                        _initMenu();
                                      });
                                      // userPropertyManager.userPropertyModel!.language =
                                      //     LanguageType.fromInt(value + 1);
                                      // setState(() {
                                      //   AbsCretaLang['changeLang']!(
                                      //       userPropertyManager.userPropertyModel!.language);
                                      // });
                                    }),
                                const SizedBox(height: 20.0),
                                CretaWidgetDropDown(
                                    width: 200,
                                    items: jobItemList,
                                    defaultValue: jobIndex > 0 ? jobIndex - 1 : 0,
                                    onSelected: (value) {
                                      userPropertyManager.userPropertyModel!.job =
                                          JobType.fromInt(value + 1);
                                    }),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 46),
                        BTN.fill_blue_t_el(
                            text: CretaMyPageLang['save']!,
                            onPressed: () async {
                              userPropertyManager.setToDB(userPropertyManager.userPropertyModel!);
                            }),
                        const SizedBox(height: 57),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
