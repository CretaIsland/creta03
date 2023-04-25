import 'dart:math';

import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:image_picker/image_picker.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';


class MyPageInfo extends StatefulWidget {
  final double width;
  final double height;
  const MyPageInfo({super.key, required this.width, required this.height});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {
  List<Text> countryItemList = [];
  List<Text> languageItemList = [];
  List<Text> jobItemList = [];

  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();

    // 나라 드롭다운 아이템 정의
    for (var element in CretaMyPageLang.countryList) {
      countryItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 언어 드롭다운 아이템 정의
    for (var element in CretaMyPageLang.languageList) {
      languageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 직업 드롭다운 아이템 정의
    for (var element in CretaMyPageLang.jobList) {
      jobItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
  }

  // 구분선
  Widget divideLine(
      {double leftPadding = 0,
      double topPadding = 0,
      double rightPadding = 0,
      double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(
          left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding),
      child: Container(
        width: widget.width * .7,
        height: 1,
        color: Colors.grey.shade200,
      ),
    );
  }

  // 프로필 이미지 박스
  Widget profileImageBox(UserPropertyManager userPropertyManager, double width, double height, double radius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: userPropertyManager.propertyModel!.profileImg != '' ? Colors.transparent : Colors.primaries[Random().nextInt(Colors.primaries.length)],
        image: userPropertyManager.propertyModel!.profileImg != '' ? DecorationImage(image: Image.network(userPropertyManager.propertyModel!.profileImg).image, fit: BoxFit.cover) : null
      ),
      child: Stack(
        children: [
          userPropertyManager.propertyModel!.profileImg != '' ? const SizedBox() : 
            Center(
              child: Text(
                userPropertyManager.propertyModel!.nickname.substring(0, 1),
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: CretaFont.semiBold,
                  fontSize: 64,
                  color: Colors.white
                )
              )
            ),
          Center(
            child: BTN.opacity_gray_i_l(
              icon: Icons.photo_camera_outlined, 
              onPressed: () async {
                try {
                  _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(_pickedFile != null) {
                    _pickedFile!.readAsBytes().then((fileBytes) {
                      HycopFactory.storage!.uploadFile(_pickedFile!.name, _pickedFile!.mimeType.toString(), fileBytes).then((value){
                        setState(() {
                          value != null ? userPropertyManager.propertyModel!.profileImg = value.thumbnailUrl : logger.info("upload error");
                        });
                      });
                      _pickedFile = null;
                    });
                  }
                } catch (error) {
                  logger.info(error);
                }
              }
            ),
          )
        ],
      ),
    );
  }

  Widget mainComponent() {
    return Consumer<UserPropertyManager>(
      builder: (context, userPropertyManagerHolder, child) {
        return SizedBox(
          width: widget.width,
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.width > 300
              ? Padding(
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
                      divideLine(topPadding: 22.0, bottomPadding: 32.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(CretaMyPageLang.profileImage, style: CretaFont.titleMedium),
                          const SizedBox(width: 95.0),
                          profileImageBox(userPropertyManagerHolder, 200.0, 200.0, 20.0)
                        ])
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 135.0, top: 24.0),
                        child: BTN.line_blue_t_m(
                          text: CretaMyPageLang.basicProfileImgBTN, 
                          onPressed: () {
                            setState(() {
                              userPropertyManagerHolder.propertyModel!.profileImg = '';
                            });
                          }
                        ),
                      ),
                      divideLine(topPadding: 32.0, bottomPadding: 39.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(CretaMyPageLang.nickname, style: CretaFont.titleMedium),
                            const SizedBox(height: 30.0),
                            Text(CretaMyPageLang.email, style: CretaFont.titleMedium),
                            const SizedBox(height: 30.0),
                            Text(CretaMyPageLang.phoneNumber, style: CretaFont.titleMedium),
                            const SizedBox(height: 30.0),
                            Text(CretaMyPageLang.password, style: CretaFont.titleMedium),
                          ]),
                          const SizedBox(width: 81.0),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const SizedBox(height: 8.0),
                            Text(userPropertyManagerHolder.propertyModel!.nickname, style: CretaFont.bodyMedium),
                            const SizedBox(height: 26.0),
                            Text(userPropertyManagerHolder.propertyModel!.email, style: CretaFont.bodyMedium),
                            const SizedBox(height: 33.0),
                            Text(userPropertyManagerHolder.propertyModel!.phoneNumber, style: CretaFont.bodyMedium),
                            const SizedBox(height: 24.0),
                            BTN.line_blue_t_m(
                              text: CretaMyPageLang.passwordChangeBTN, 
                              onPressed: () {}
                            )
                          ])
                        ])
                      ),
                      divideLine(topPadding: 32.0, bottomPadding: 39.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Row(children: [
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(CretaMyPageLang.country, style: CretaFont.titleMedium),
                            const SizedBox(height: 30.0),
                            Text(CretaMyPageLang.language, style: CretaFont.titleMedium),
                            const SizedBox(height: 30.0),
                            Text(CretaMyPageLang.job, style: CretaFont.titleMedium),
                          ]),
                          const SizedBox(width: 111.0),
                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            CretaWidgetDropDown(
                              width: 116,
                              items: countryItemList,
                              defaultValue: userPropertyManagerHolder.propertyModel!.country.index,
                              onSelected: (value) {
                                userPropertyManagerHolder.propertyModel!.country = Country.fromInt(value);
                              }),
                            const SizedBox(height: 17.0),
                            CretaWidgetDropDown(
                              width: 102,
                              items: languageItemList,
                              defaultValue: userPropertyManagerHolder.propertyModel!.language.index,
                              onSelected: (value) {
                                userPropertyManagerHolder.propertyModel!.language = Language.fromInt(value);
                              }),
                            const SizedBox(height: 17.0),                            
                            CretaWidgetDropDown(
                              width: 102,
                              items: jobItemList,
                              defaultValue: userPropertyManagerHolder.propertyModel!.job.index,
                              onSelected: (value) {
                                userPropertyManagerHolder.propertyModel!.job = Job.fromInt(value);
                              })
                          ])
                        ])
                      ),
                      const SizedBox(height: 40.0),
                      BTN.fill_blue_t_el(
                        text: CretaMyPageLang.saveChangeBTN, 
                        onPressed: () {
                          userPropertyManagerHolder.setToDB(userPropertyManagerHolder.propertyModel!);
                        }
                      ),
                      const SizedBox(height: 60.0),
                  ])
                ) : Container()
              )
        );
      },
    );



    
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}
