import 'dart:math';
import 'dart:typed_data';

import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:image_picker/image_picker.dart';


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
  Uint8List? _pickedFileBytes;
  

  @override
  void initState() {
    super.initState();

    // 나라 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.countryList) {
      countryItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 언어 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.languageList) {
      languageItemList.add(Text(element, style: CretaFont.bodyMedium));
    }
    // 직업 드롭다운 아이템 정의
    for(var element in CretaMyPageLang.jobList) {
      jobItemList.add(Text(element, style: CretaFont.bodyMedium));
    }

  }


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

  // 프로필 이미지 박스
  Widget profileImageBox() {
    return Container(
      width: 200.0,
      height: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
        image: _pickedFileBytes == null ? null : DecorationImage(image: Image.memory(_pickedFileBytes!).image, fit: BoxFit.cover) 
      ),
      child: Stack(
        children: [
          _pickedFileBytes == null ? const Center(
            child: Text("채", style: TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 64, color: Colors.white))
          ) : Container(),
          Center(
            child: BTN.opacity_gray_i_l(
              icon: Icons.photo_camera_outlined, 
              onPressed: () async {
                try {
                  _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  if(_pickedFile!=null) {
                    _pickedFile!.readAsBytes().then((fileBytes) {
                      setState(() {
                        _pickedFileBytes = fileBytes;
                      });
                    });
                  }
                } catch (error) {
                  logger.info(error);
                }
              }
            ),
          )
        ],
      )
    );
  }

  Widget mainComponent(){
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.width > 300 ? Padding(
          padding: const EdgeInsets.only(left: 165.0, top: 72.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children : [
              Text(CretaMyPageLang.info, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
              divideLine(topPadding: 22.0, bottomPadding: 32.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0), 
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CretaMyPageLang.profileImage, style: CretaFont.titleMedium),
                    const SizedBox(width: 95.0),
                    profileImageBox()
                  ]
                )
              ),
              Padding(
                padding: const EdgeInsets.only(left: 135.0, top: 24.0),
                child: BTN.line_blue_t_m(text: "기본 이미지로 변경", onPressed: () {}),
              ),
              divideLine(topPadding: 32.0, bottomPadding: 39.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.nickname, style: CretaFont.titleMedium),
                        const SizedBox(height: 30.0),
                        Text(CretaMyPageLang.email, style: CretaFont.titleMedium),
                        const SizedBox(height: 30.0),
                        Text(CretaMyPageLang.phoneNumber, style: CretaFont.titleMedium),
                        const SizedBox(height: 30.0),
                        Text(CretaMyPageLang.password, style: CretaFont.titleMedium),
                      ]
                    ),
                    const SizedBox(width: 81.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8.0),
                        Text("채서윤", style: CretaFont.bodyMedium),
                        const SizedBox(height: 26.0),
                        Text("csy_0102@sqisoft.com", style: CretaFont.bodyMedium),
                        const SizedBox(height: 33.0),
                        Text("01012345678", style: CretaFont.bodyMedium),
                        const SizedBox(height: 24.0),
                        BTN.line_blue_t_m(text: CretaMyPageLang.passwordChangeBTN, onPressed: () {})
                      ]
                    )
                  ]
                )
              ),
              divideLine(topPadding: 32.0, bottomPadding: 39.0),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(CretaMyPageLang.country, style: CretaFont.titleMedium),
                        const SizedBox(height: 30.0),
                        Text(CretaMyPageLang.language, style: CretaFont.titleMedium),
                        const SizedBox(height: 30.0),
                        Text(CretaMyPageLang.job, style: CretaFont.titleMedium),
                      ]
                    ),
                    const SizedBox(width: 111.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CretaWidgetDropDown(
                          width: 116,
                          items: countryItemList, 
                          defaultValue: 0, 
                          onSelected: (value) {}
                        ),
                        const SizedBox(height: 17.0),
                        CretaWidgetDropDown(
                          width: 102,
                          items: languageItemList, 
                          defaultValue: 0, 
                          onSelected: (value) {}
                        ),
                        const SizedBox(height: 17.0),
                        CretaWidgetDropDown(
                          width: 102,
                          items: jobItemList, 
                          defaultValue: 0, 
                          onSelected: (value) {}
                        )
                      ]
                    )
                  ]
                )
              ),
              const SizedBox(height: 40.0),
              BTN.fill_blue_t_el(text: CretaMyPageLang.saveChangeBTN, onPressed: () {}),
              const SizedBox(height: 60.0),
            ]
          ),
        ) : Container()
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
  
}