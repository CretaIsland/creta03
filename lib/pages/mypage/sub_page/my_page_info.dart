import 'package:creta03/data_io/user_property_manager.dart';
import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/design_system/menu/creta_widget_drop_down.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:creta03/pages/mypage/popup/chage_pwd_popup.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';



class MyPageInfo extends StatefulWidget {
  final double width;
  final double height;
  final Color replaceColor;
  const MyPageInfo({super.key, required this.width, required this.height, required this.replaceColor});

  @override
  State<MyPageInfo> createState() => _MyPageInfoState();
}

class _MyPageInfoState extends State<MyPageInfo> {

  final TextEditingController _nicknameController = TextEditingController();
  List<Text> countryItemList = [];
  List<Text> languageItemList = [];
  List<Text> jobItemList = [];


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
            child: widget.width > 500 ? Padding(
              padding: const EdgeInsets.only(left: 165.0, top: 72.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('개인 정보', style: CretaFont.headlineLarge.copyWith(fontWeight: FontWeight.w600, color: CretaColor.text.shade700)),
                  divideLine(width: 1000.0, topPadding: 22.0, bottomPadding: 32.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12),
                      Text('사진', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                      const SizedBox(width: 95),
                      profileImgComponent(userPropertyManager),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:  135.0, top: 24.0),
                    child: BTN.line_blue_t_m(
                      text: '기본 이미지로 변경', 
                      onPressed: () {
                        userPropertyManager.userPropertyModel!.profileImg = '';
                        userPropertyManager.notify();
                      }
                    ),
                  ),
                  divideLine(width: 1000.0, topPadding: 32.0, bottomPadding: 38.0),
                  Row(
                    children: [
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('닉네임', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 30),
                          Text('이메일', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 30),
                          Text('연락처', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 30),
                          Text('비밀번호', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                        ],
                      ),
                      const SizedBox(width: 67),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextField(
                              controller: _nicknameController,
                              style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700),
                              decoration: const InputDecoration(
                                hintText: '닉네임을 입력해주세요',
                                border: InputBorder.none
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(userPropertyManager.userPropertyModel!.email, style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                          const SizedBox(height: 30),
                          Text(userPropertyManager.userPropertyModel!.phoneNumber, style: CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade400)),
                          const SizedBox(height: 24),
                          BTN.line_blue_t_m(
                            text: '비밀번호 변경', 
                            onPressed: () {
                               showDialog(
                                context: context, 
                                builder: (context) => ChangePwdPopUp.changePwdPopUp(context),
                               );
                            }
                          )
                        ],
                      )
                    ],
                  ),
                  divideLine(width: 1000.0, topPadding: 32.0, bottomPadding: 46.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('국가', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 30),
                          Text('언어', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                          const SizedBox(height: 30),
                          Text('직업', style: CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700)),
                        ],
                      ),
                      const SizedBox(width: 110),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CretaWidgetDropDown(width: 116, items: countryItemList, defaultValue: userPropertyManager.userPropertyModel!.country.index, onSelected: (value) {}),
                          const SizedBox(height: 20.0),
                          CretaWidgetDropDown(width: 102, items: languageItemList, defaultValue: userPropertyManager.userPropertyModel!.language.index, onSelected: (value) {}),
                          const SizedBox(height: 20.0),
                          CretaWidgetDropDown(width: 102, items: jobItemList, defaultValue: userPropertyManager.userPropertyModel!.job.index, onSelected: (value) {}),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 46),
                  BTN.fill_blue_t_el(text: '변경사항 저장', onPressed: () {  userPropertyManager.setToDB(userPropertyManager.userPropertyModel!); }),
                  const SizedBox(height: 57),
                ],
              ),
            ) : null,  
          ),
        );  
      },
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

  Widget profileImgComponent(UserPropertyManager userPropertyManager) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
        color: widget.replaceColor,
        image: userPropertyManager.userPropertyModel!.profileImg == '' ? null : DecorationImage(
          image: NetworkImage(userPropertyManager.userPropertyModel!.profileImg),
          fit: BoxFit.cover,
        )
      ),
      child: userPropertyManager.userPropertyModel!.profileImg == '' ? Center(
        child: Text(
          userPropertyManager.userPropertyModel!.nickname.substring(0, 1),
          style: const TextStyle(
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 80,
            color: Colors.white,
          ),
        ),
      ) : null
    );
  }



}