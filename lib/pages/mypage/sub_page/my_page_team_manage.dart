import 'dart:math';
import 'dart:typed_data';

import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:image_picker/image_picker.dart';

import '../../../design_system/buttons/creta_toggle_button.dart';

class MyPageTeamManage extends StatefulWidget {
  final double width;
  final double height;
  const MyPageTeamManage({super.key, required this.width, required this.height});

  @override
  State<MyPageTeamManage> createState() => _MyPageTeamManageState();
}

class _MyPageTeamManageState extends State<MyPageTeamManage> {
  XFile? _pickedFile;
  Uint8List? _pickedFileBytes;

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
  Widget profileImageBox() {
    return Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
            image: _pickedFileBytes == null
                ? null
                : DecorationImage(image: Image.memory(_pickedFileBytes!).image, fit: BoxFit.cover)),
        child: Stack(
          children: [
            _pickedFileBytes == null
                ? const Center(
                    child: Text("채",
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: CretaFont.semiBold,
                            fontSize: 64,
                            color: Colors.white)))
                : Container(),
            Center(
              child: BTN.opacity_gray_i_l(
                  icon: Icons.photo_camera_outlined,
                  onPressed: () async {
                    try {
                      _pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (_pickedFile != null) {
                        _pickedFile!.readAsBytes().then((fileBytes) {
                          setState(() {
                            _pickedFileBytes = fileBytes;
                          });
                        });
                      }
                    } catch (error) {
                      logger.fine(error);
                    }
                  }),
            )
          ],
        ));
  }

  Widget memberBox(String? memberProfileImg, String memberNickname) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(24),
                image: memberProfileImg == null
                    ? null
                    : DecorationImage(
                        image: Image.network(memberProfileImg).image, fit: BoxFit.cover)),
          ),
          const SizedBox(width: 14.0),
          Text(memberNickname),
          const SizedBox(width: 190.0),
          BTN.line_blue_t_m(text: CretaMyPageLang.throwBTN, onPressed: () {})
        ],
      ),
    );
  }

  Widget mainComponent() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: widget.width > 400
              ? Padding(
                  padding: const EdgeInsets.only(left: 165.0, top: 72.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(CretaMyPageLang.teamManage,
                        style: const TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: CretaFont.semiBold,
                            fontSize: 40,
                            color: CretaColor.text)),
                    divideLine(topPadding: 22.0, bottomPadding: 32.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(CretaMyPageLang.teamInfo, style: CretaFont.titleELarge),
                          const SizedBox(height: 32.0),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(CretaMyPageLang.profileImage, style: CretaFont.titleMedium),
                              const SizedBox(height: 215.0),
                              Text(CretaMyPageLang.nickname, style: CretaFont.titleMedium),
                              const SizedBox(height: 32.0),
                              Text('팀 for 4', style: CretaFont.titleMedium)
                            ]),
                            const SizedBox(width: 95.0),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              profileImageBox(),
                              const SizedBox(height: 32.0),
                              Text('채서윤', style: CretaFont.titleMedium),
                              const SizedBox(height: 28.0),
                              BTN.line_blue_t_m(
                                  text: CretaMyPageLang.ratePlanChangeBTN, onPressed: () {})
                            ])
                          ])
                        ])),
                    divideLine(topPadding: 32.0, bottomPadding: 32.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(CretaMyPageLang.teamChannel, style: CretaFont.titleELarge),
                          const SizedBox(height: 32.0),
                          Row(children: [
                            Text(CretaMyPageLang.publicProfile, style: CretaFont.titleMedium),
                            const SizedBox(width: 199.0),
                            CretaToggleButton(onSelected: (value) {}, defaultValue: false)
                          ]),
                          const SizedBox(height: 16.0),
                          Text(CretaMyPageLang.profileTip, style: CretaFont.bodySmall),
                          const SizedBox(height: 23.0),
                          Row(children: [
                            Text(CretaMyPageLang.backgroundImgSetting,
                                style: CretaFont.titleMedium),
                            const SizedBox(width: 24.0),
                            BTN.line_blue_t_m(text: CretaMyPageLang.selectImgBTN, onPressed: () {})
                          ])
                        ])),
                    divideLine(topPadding: 32.0, bottomPadding: 32.0),
                    Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            children: [
                              Text(CretaMyPageLang.teamMemberManage, style: CretaFont.titleELarge),
                              const SizedBox(width: 40.0),
                              Text('${CretaMyPageLang.inviteablePeopleNumber} 2/4',
                                  style: CretaFont.bodySmall)
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              memberBox(
                                  "https://static.ebs.co.kr/images/ebs/WAS-HOME/portal/upload/img/programinfo/person/per/1242723602807_VcCnrrJwzW.jpg",
                                  "포비"),
                              memberBox(
                                  "https://static.ebs.co.kr/images/ebs/WAS-HOME/portal/upload/img/programinfo/person/per/1242723549377_49L83YjvJL.jpg",
                                  "해리"),
                              memberBox(
                                  "https://static.ebs.co.kr/images/ebs/WAS-HOME/portal/upload/img/programinfo/person/per/1242723588618_dphGgSgOAp.jpg",
                                  "패티")
                            ],
                          ),
                          const SizedBox(height: 32.0),
                          BTN.fill_blue_t_m(
                              width: 81.0, text: CretaMyPageLang.addMemberBTN, onPressed: () {})
                        ])),
                    const SizedBox(height: 120.0)
                  ]))
              : Container()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}
