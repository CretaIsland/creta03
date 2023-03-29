import 'package:creta03/design_system/buttons/creta_button_wrapper.dart';
import 'package:creta03/design_system/creta_color.dart';
import 'package:creta03/design_system/creta_font.dart';
import 'package:creta03/lang/creta_mypage_lang.dart';
import 'package:flutter/material.dart';


class MyPageDashBoard extends StatefulWidget {
  
  final double width;
  final double height;
  const MyPageDashBoard({super.key, required this.width, required this.height});

  @override
  State<MyPageDashBoard> createState() => _MyPageDashBoardState();
}

class _MyPageDashBoardState extends State<MyPageDashBoard> {


  // 구분선
  Widget divideLine({double leftPadding = 0, double topPadding = 0, double rightPadding = 0, double bottomPadding = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: topPadding, right: rightPadding, bottom: bottomPadding), 
      child: Container(
        width: 400,
        height: 1,
        color: Colors.grey.shade200 ,
      ),
    );
  }

  // 프로필 이미지
  Widget profileImg() {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(200.0),
        image: DecorationImage(image: Image.network("https://image.genie.co.kr/Y/IMAGE/IMG_ARTIST/080/574/299/80574299_1603344703162_2_600x600.JPG").image, fit: BoxFit.cover)  
      ),
    );
  }

  // 계정 정보
  Widget accountInfoBox() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(CretaMyPageLang.accountInfo, style: CretaFont.titleELarge),
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.grade, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.bookCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.ratePlan, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.freeSpace, style: CretaFont.bodyMedium)
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Creta Star", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("10", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Row(
                    children: [
                      Text("무료 개인", style: CretaFont.bodyMedium),
                      const SizedBox(width: 24),
                      BTN.line_blue_t_m(text: CretaMyPageLang.ratePlanChangeBTN, onPressed: (){ })
                    ],
                  ),
                  const SizedBox(height: 28.0),
                  Text("256MB (전체 1024MB)", style: CretaFont.bodyMedium)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 최근 요약
  Widget recentInfoBox() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Row(
              children: [
                Text(CretaMyPageLang.recentSummary, style: CretaFont.titleELarge), 
                const SizedBox(width: 192),
                Text("지난 30일", style: CretaFont.titleMedium),
              ],
            )
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Row(
            children: [
              const SizedBox(width: 32.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(CretaMyPageLang.bookViewCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.bookViewTime, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.likeCount, style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text(CretaMyPageLang.commentCount, style: CretaFont.bodyMedium)
                ],
              ),
              const SizedBox(width: 40.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("17", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("15 시간", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("3", style: CretaFont.bodyMedium),
                  const SizedBox(height: 28.0),
                  Text("5", style: CretaFont.bodyMedium)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  // 내 팀
  Widget myTeamInfoBox() {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 32.0),
            child: Text(CretaMyPageLang.myTeam, style: CretaFont.titleELarge),
          ),
          divideLine(topPadding: 32.0, bottomPadding: 40.0),
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("기적소리 (소유자)", style: CretaFont.bodyMedium),
                const SizedBox(height: 28.0),
                Text("위화감 (사용자)", style: CretaFont.bodyMedium),
                const SizedBox(height: 28.0),
                Text("이지적 (관리자)", style: CretaFont.bodyMedium),
                const SizedBox(height: 28.0),
                Text("고지식 (사용자)", style: CretaFont.bodyMedium)
              ],
            )
          )
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
        child: widget.width > 400 ? Column(
          children: [
            const SizedBox(height: 60),
            profileImg(),
            const SizedBox(height: 40),
            const Text("사용자 닉네임", style: TextStyle(fontFamily: 'Pretendard', fontWeight: CretaFont.semiBold, fontSize: 40, color: CretaColor.text)),
            const SizedBox(height: 16),
            Text("csy_0102@sqisoft.com", style: CretaFont.buttonLarge),
            const SizedBox(height: 86),
            widget.width > 1280 ?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  accountInfoBox(),
                  const SizedBox(width: 40.0),
                  recentInfoBox(),
                  const SizedBox(width: 40.0),
                  myTeamInfoBox()
                ],
              ) : 
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  accountInfoBox(),
                  const SizedBox(height: 40.0),
                  recentInfoBox(),
                  const SizedBox(height: 40.0),
                  myTeamInfoBox()
                ],
              ),
            const SizedBox(height: 100)
          ],
        ) : Container()
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return mainComponent();
  }
}