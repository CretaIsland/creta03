import 'package:flutter/material.dart';

import '../../../design_system/buttons/creta_button_wrapper.dart';
import '../../../design_system/buttons/creta_toggle_button.dart';
import '../../../design_system/creta_color.dart';
import '../../../design_system/creta_font.dart';
import '../../../lang/creta_mypage_lang.dart';


class MyPageAccountManage extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageAccountManage({super.key, required this.width, required this.height});

  @override
  State<MyPageAccountManage> createState() => _MyPageAccountManageState();
}

class _MyPageAccountManageState extends State<MyPageAccountManage> {


  Widget divideLine(double topMargin, double bottomMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin, bottom: bottomMargin),
      height: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget mainContainer(Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: widget.width < 700 ? Container() : Container( 
        width: widget.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 165.0, top: 72.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(CretaMyPageLang.accountManage, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
              divideLine(20.0, 38.0),
              Text(CretaMyPageLang.setPurpose, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 22, color: CretaColor.text)),
              const SizedBox(height: 32),
              Row(  
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(CretaMyPageLang.usePresentation, style: CretaFont.titleMedium),
                      const SizedBox(height: 30),  
                      Text(CretaMyPageLang.useDisitalSignage, style: CretaFont.titleMedium),
                    ],
                  ),
                  const SizedBox(width: 80),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CretaToggleButton(onSelected: (value) {}, defaultValue: true),
                      const SizedBox(height: 16),  
                      CretaToggleButton(onSelected: (value) {}, defaultValue: true)
                    ],
                  ),
                ],
              ),
              divideLine(27.0, 30.0),
              Text(CretaMyPageLang.paymentSystem, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 22, color: CretaColor.text)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Text("무료 개인", style: CretaFont.titleMedium),
                  const SizedBox(width: 24.0),
                  BTN.line_blue_t_m(text: "요금제 변경", onPressed: () {})
                ],
              ),
              const SizedBox(height: 13),
              Text(CretaMyPageLang.teamPaymentPhrase, style: CretaFont.bodySmall),
              divideLine(35.0, 30.0),
              Text(CretaMyPageLang.setChannel, style: const TextStyle(fontFamily: 'Pretendard', fontWeight: FontWeight.w600, fontSize: 22, color: CretaColor.text)),
              const SizedBox(height: 32),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(CretaMyPageLang.isPublicProfile, style: CretaFont.titleMedium),
                  ),
                  const SizedBox(width: 199.0),
                  CretaToggleButton(onSelected: (value) {}, defaultValue: true)
                ],
              ),
              const SizedBox(height: 16),
              Text(CretaMyPageLang.publicProfilePhrase, style: CretaFont.bodySmall),
              const SizedBox(height: 23),
              Row(
                children: [
                  Text(CretaMyPageLang.setBackgroundImg, style: CretaFont.titleMedium),
                  const SizedBox(width: 24.0),
                  BTN.line_blue_t_m(text: "이미지 선택", onPressed: () {})
                ],
              ),
              divideLine(32.0, 31.0),
              Row(
                children: [
                  Text(CretaMyPageLang.logout, style: CretaFont.titleMedium),
                  const SizedBox(width: 24.0),
                  BTN.line_red_t_m(text: "로그아웃", onPressed: () {}),
                  const SizedBox(width: 80.0),
                  Text(CretaMyPageLang.removeAccount, style: CretaFont.titleMedium),
                  const SizedBox(width: 24.0),
                  BTN.fill_red_t_m(text: "계정 탈퇴", onPressed: () {}, width: 81),
                ],
              ),
              widget.height > 842 ? SizedBox(height: widget.height - 842 / 2) : Container()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainContainer(Size(widget.width, widget.height));
  }

}