import 'dart:typed_data';

import 'package:creta03/data_io/user_property_manager.dart';
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
  // 국가, 언어, 직업 드롭 다운 메뉴
  List<Text> countryItemList = [];
  List<Text> languageItemList = [];
  List<Text> jobItemList = [];

  @override
  initState() {
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManager, child) {
        _nicknameController.text = userPropertyManager.userPropertyModel!.nickname;
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: widget.width > 500
                ? Padding(
                    padding: const EdgeInsets.only(left: 165.0, top: 72.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("개인 정보",
                            style: CretaFont.displaySmall.copyWith(fontWeight: FontWeight.w600)),
                        MyPageCommonWidget.divideLine(
                            width: widget.width * .6,
                            padding: const EdgeInsets.only(top: 30, bottom: 50)),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12.0),
                            Text("사진", style: CretaFont.titleMedium),
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
                                    text: "기본 이미지로 변경",
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 12.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("닉네임", style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text("이메일", style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text("연락처", style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text("비밀번호", style: CretaFont.titleMedium),
                              ],
                            ),
                            const SizedBox(width: 67),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                    width: 200,
                                    height: 20,
                                    child: TextField(
                                      controller: _nicknameController,
                                      style: CretaFont.bodyMedium,
                                      decoration: const InputDecoration(
                                        hintText: '닉네임을 입력해주세요',
                                        border: InputBorder.none,
                                      ),
                                      onEditingComplete: () => userPropertyManager
                                          .userPropertyModel!.nickname = _nicknameController.text,
                                    )),
                                const SizedBox(height: 30),
                                Text(userPropertyManager.userPropertyModel!.email,
                                    style: CretaFont.bodyMedium
                                        .copyWith(color: CretaColor.text.shade400)),
                                const SizedBox(height: 30),
                                Text("01012341234",
                                    style: CretaFont.bodyMedium
                                        .copyWith(color: CretaColor.text.shade400)),
                                const SizedBox(height: 26),
                                BTN.line_blue_t_m(
                                    height: 32,
                                    text: "비밀번호 변경",
                                    onPressed: () => showDialog(
                                        context: context,
                                        builder: (context) =>
                                            ChangePwdPopUp.changePwdPopUp(context)))
                              ],
                            )
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
                                Text("국가", style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text("언어", style: CretaFont.titleMedium),
                                const SizedBox(height: 30),
                                Text("직업", style: CretaFont.titleMedium),
                              ],
                            ),
                            const SizedBox(width: 110),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CretaWidgetDropDown(
                                    width: 116,
                                    items: countryItemList,
                                    defaultValue:
                                        userPropertyManager.userPropertyModel!.country.index,
                                    onSelected: (value) {
                                      userPropertyManager.userPropertyModel!.country =
                                          CountryType.fromInt(value);
                                    }),
                                const SizedBox(height: 20.0),
                                CretaWidgetDropDown(
                                    width: 102,
                                    items: languageItemList,
                                    defaultValue:
                                        userPropertyManager.userPropertyModel!.language.index,
                                    onSelected: (value) {
                                      userPropertyManager.userPropertyModel!.language =
                                          LanguageType.fromInt(value);
                                    }),
                                const SizedBox(height: 20.0),
                                CretaWidgetDropDown(
                                    width: 102,
                                    items: jobItemList,
                                    defaultValue: userPropertyManager.userPropertyModel!.job.index,
                                    onSelected: (value) {
                                      userPropertyManager.userPropertyModel!.job =
                                          JobType.fromInt(value);
                                    }),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 46),
                        BTN.fill_blue_t_el(
                            text: '변경사항 저장',
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
