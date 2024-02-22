import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/login/login_dialog.dart';
import 'package:creta03/routes.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  // screen vertical scroll controller
  late ScrollController _verticalScroller;
  // screen width
  double? _screenWidth;
  // appbar effect
  BoxShadow? appBarShadow;
  // dropdown menu item
  late List<DropdownMenuItem> languageItems;
  late String selectedLanguage;

  TextStyle titleELarge = CretaFont.titleELarge.copyWith(color: CretaColor.text.shade700);
  TextStyle titleMedium = CretaFont.titleMedium.copyWith(color: CretaColor.text.shade700);
  TextStyle bodyLarge = CretaFont.bodyLarge.copyWith(color: CretaColor.text.shade700);
  TextStyle bodyMedium = CretaFont.bodyMedium.copyWith(color: CretaColor.text.shade700);

  BuildContext getBuildContext() {
    return context;
  }

  @override
  void initState() {
    super.initState();
    TextStyle languageMenuStyle = CretaFont.buttonLarge
        .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: CretaColor.primary);
    languageItems = [
      DropdownMenuItem(value: "ko", child: Text("한국어", style: languageMenuStyle)),
      // DropdownMenuItem(value: "en", child: Text("EN", style: languageMenuStyle)),
      // DropdownMenuItem(value: "ja", child: Text("日本語", style: languageMenuStyle))
    ];
    selectedLanguage = languageItems.first.value;
    _verticalScroller = ScrollController();
    _verticalScroller.addListener(() {
      if (_verticalScroller.offset > 10) {
        setState(() {
          appBarShadow = BoxShadow(
              color: const Color(0xff1A1A1A).withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 2));
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _verticalScroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = _screenWidth == null || _screenWidth! < MediaQuery.sizeOf(context).width
        ? MediaQuery.sizeOf(context).width
        : _screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: MediaQuery.sizeOf(context).height < 140
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  appBar(),
                  SizedBox(
                    width: _screenWidth,
                    height: MediaQuery.sizeOf(context).height - 117,
                    child: SingleChildScrollView(
                      controller: _verticalScroller,
                      child: Column(
                        children: [mainSection(), footer()],
                      ),
                    ),
                  )
                ],
              )),
    );
  }

  // ************************************ common widget ************************************
  Widget customButton(
      {required double width,
      required double height,
      required Widget child,
      required void Function() onTap,
      Color backgroundColor = Colors.white,
      Border? border,
      BorderRadius? borderRadius,
      List<BoxShadow>? boxShadow}) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            color: backgroundColor,
            boxShadow: boxShadow),
        child: Center(
          child: child,
        ),
      ),
    );
  }

  Widget dropdownMenu(
      {required double width,
      required double height,
      required List<DropdownMenuItem> items,
      required dynamic defaultValue,
      required void Function(dynamic) onSelected,
      Icon icon = const Icon(Icons.expand_more, color: CretaColor.primary),
      double iconSize = 10}) {
    dynamic selectedValue = defaultValue;
    return SizedBox(
      width: width,
      height: height,
      child: DropdownButtonHideUnderline(
          child: DropdownButton(
              value: selectedValue,
              items: items,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                  onSelected(value);
                });
              },
              icon: icon,
              iconSize: iconSize,
              isExpanded: true,
              elevation: 0,
              focusColor: Colors.white,
              dropdownColor: Colors.white)),
    );
  }

  // ************************************ app bar ************************************
  Widget appBar() {
    TextStyle appBarBTNStyle = CretaFont.buttonLarge
        .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: CretaColor.primary);
    return Container(
      width: _screenWidth,
      decoration: BoxDecoration(
          color: Colors.white, boxShadow: appBarShadow != null ? [appBarShadow!] : null),
      child: Padding(
        padding: const EdgeInsets.only(top: 45, left: 160, right: 160, bottom: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Routemaster.of(context).push(AppRoutes.intro);
              },
              child: const Image(
                image: AssetImage("assets/creta_logo_blue.png"),
                width: 136,
                height: 40,
              ),
            ),
            SizedBox(
              width: 329,
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountManager.currentLoginUser.isLoginedUser
                      ? customButton(
                          width: 52,
                          height: 19,
                          child: Text("Logout", style: appBarBTNStyle),
                          onTap: () {
                            setState(() {
                              CretaAccountManager.logout();
                            });
                          })
                      : customButton(
                          width: 40,
                          height: 19,
                          child: Text("Login", style: appBarBTNStyle),
                          onTap: () => LoginDialog.popupDialog(
                            context: context,
                            getBuildContext: getBuildContext,
                          ),
                        ),
                  customButton(
                      width: 140,
                      height: 48,
                      child: Text("Sign up", style: appBarBTNStyle),
                      onTap: () => LoginDialog.popupDialog(
                          context: context,
                          getBuildContext: getBuildContext,
                          loginPageState: LoginPageState.singup),
                      border: Border.all(color: CretaColor.primary),
                      borderRadius: BorderRadius.circular(6.6)),
                  dropdownMenu(
                      width: 64,
                      height: 19,
                      items: languageItems,
                      defaultValue: selectedLanguage,
                      onSelected: (value) => selectedLanguage = value)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // ************************************ main section ************************************
  Widget mainSection() {
    return Container(
      width: _screenWidth,
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.only(top: 48, bottom: 80, left: 160),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text("개인정보 처리 방침", style: titleELarge)),
            const SizedBox(height: 12),
            Center(child: Text("개인정보 처리 방침에 대해 안내드립니다.", style: titleMedium)),
            const SizedBox(height: 40),
            Text("에스큐아이소프트(주) 개인정보 처리 방침", style: titleMedium),
            const SizedBox(height: 12),
            Text(
                "에스큐아이소프트(주)는 개인정보 보호법 제30조에 따라 정보 주체의 개인정보를 보호하고 이와 관련한 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보 처리 지침을 수립, 공개합니다.",
                style: bodyMedium),
            const SizedBox(height: 32),
            clauseComponent(clauseTitle: "제1조 (개인정보의 처리 목적)", cluaseDescriptionList: [
              "에스큐아이소프트(주)는 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는 다음의 목적 이외의 용도로는 이용되지 않으며, \n이용 목적이 변경되는 경우에는 개인정보 보호법 제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다."
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("홈페이지 회원 가입 및 관리", style: titleMedium),
                  const SizedBox(height: 16),
                  Text(
                      "회원 가입 의사 확인, 회원제 서비스 제공에 따른 본인 식별 · 인증, 회원자격 유지 관리, 제한적 본인확인제 시행에 따른 본인 확인, 서비스 부정 이용 방지, 만 14세 미만 아동의 개인정보 처리 시 법정대리인의 동의 여부 확인, 각종 고지, 통지, 고충 처리 등을 \n목적으로 개인정보를 처리합니다.",
                      style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("재화 또는 서비스 제공", style: titleMedium),
                  const SizedBox(height: 16),
                  Text(
                      "물품 배송, 서비스 제공, 계약서 · 청구서 발송, 콘텐츠 제공, 맞춤 서비스 제공, 본인 인증, 나이 인증, 요금 결제 · 정산, 채권추심 등을 목적으로 개인정보를 처리합니다.",
                      style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("고충 처리", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("민원인의 신원 확인 민원 사항 확인, 사실 조사를 위한 연락 · 통지, 처리결과 통보 등의 목적으로 개인정보를 처리합니다.",
                      style: bodyMedium),
                ])),
            clauseComponent(clauseTitle: "제2조 (개인정보의 처리 및 보유기간)", cluaseDescriptionList: [
              " 1. 에스큐아이소프트(주)는 법령에 따른 개인정보 보유 · 이용 기간 또는 정보 주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유 · 이용 기간 내에서 개인정보를 처리 · 보유합니다.",
              " 2. 각각의 개인정보 처리 · 보유기간은 다음과 같습니다."
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("홈페이지 회원 가입 및 관리", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 사업자/단체 홈페이지 탈퇴 시까지. 다만, 다음의 사유에 해당하는 경우 해당 사유 종료 시까지.",
                      style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 관계 법령 위반에 따른 수사 · 조사 등이 진행 중인 경우 해당 수사 · 조사 종료 시까지.",
                      style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 홈페이지 이용에 따른 채권 · 채무 관계 잔존 시 해당 채권 · 채무관계 정산 시까지.", style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("재화 또는 서비스 제공", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 재화 · 서비스 공급 완료 및 요금 결제 · 정산 완료 시까지. 다만, 다음의 사유에 해당하는 경우 해당 기간 종료 시까지.",
                      style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 전자상거래 등에서의 소비자 보호에 관한 법률에 따른 표시 · 광고, 계약 내용 및 이행 등 거래에 관한 기록",
                      style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("            ⦁ 표시 · 광고에 관한 기록 : 6개월", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("            ⦁ 계약 또는 청약 철회, 대금결제, 재화 등의 공급기록 : 5년", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("            ⦁ 소비자 불만 또는 분쟁 처리에 관한 기록 : 3년", style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("  ⦁ 통신비밀보호법 제41조에 따른 통신사실확인 자료 보관", style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("            ⦁ 가입자 전기통신일시, 개시 · 종료 시각, 상대방 가입자 번호, 사용도수, 발신기지국 위치추적자료 : 1년",
                      style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("            ⦁ 컴퓨터통신, 인터넷 로그 기록 자료, 접속지 추적자료 : 3개월", style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("  ⦁ 정보통신망 이용촉진 및 정보보호 등에 관한 법률 시행령 제29조에 따른 본인확인 정보 보관", style: bodyMedium),
                  const SizedBox(height: 20),
                  Text("            ⦁ 게시판에 정보 게시가 종료된 후 6개월", style: bodyMedium),
                ])),
            clauseComponent(clauseTitle: "제3조 (개인정보의 제삼자 제공)", cluaseDescriptionList: [
              "에스큐아이소프트(주)는 정보 주체의 개인정보를 제1조(개인정보의 처리 목적)에서 명시한 범위 내에서만 처리하며, 정보 주체의 동의, 법률의 특별한 규정 등 개인정보 보호법 제17조 · 제18조에 해당하는 경우에만 개인정보를 제삼자에게 제공합니다."
            ]),
            const SizedBox(height: 20),
            clauseComponent(clauseTitle: "제4조 (개인정보처리의 위탁)", cluaseDescriptionList: [
              " 1. 에스큐아이소프트(주)는 원활한 개인정보 업무처리를 위하여 다음과 같이 개인정보 처리 업무를 위탁하고 있습니다.",
              " 2. 에스큐아이소프트(주)는 위탁계약 체결 시 개인정보 보호법 제25조에 따라 위탁 업무 수행 목적 외 개인정보 처리금지, 기술적 · 관리적 보호조치, 재위탁 제한, 수탁자에 대한 관리 · 감독, 손해배상 등 책임에 관한 사항을 계약서 등 문서에 명시하고, \n수탁자가 개인정보를 안전하게 처리하는지 감독하고 있습니다.",
              " 3. 위탁 업무의 내용이나 수탁자가 변경될 때는 바로 본 개인정보 처리 방침을 통하여 공개하도록 하겠습니다."
            ]),
            const SizedBox(height: 20),
            clauseComponent(
                clauseTitle: "제5조 (정보 주체와 법정대리인의 권리 · 의무 및 행사 방법)",
                cluaseDescriptionList: [
                  " 1. 정보 주체는 에스큐아이소프트(주)에 대해 언제든지 개인정보 열람·정정·삭제·처리정지 요구 등의 권리를 행사할 수 있습니다.",
                  " 2. 제1항에 따른 권리 행사는 에스큐아이소프트(주)에 대해 개인정보보호법 시행령 제41조 제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며, 에스큐아이소프트(주)는 이에 대해 지체없이 조치하겠습니다.",
                  " 3. 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.",
                  " 4. 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제5항, 제37조 제2항에 의하여 정보주체의 권리가 제한될 수 있습니다.",
                  " 5. 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시된 경우에는 그 삭제를 요구할 수 없습니다.",
                  " 6. 에스큐아이소프트(주)는 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.",
                ]),
            const SizedBox(height: 20),
            clauseComponent(
                clauseTitle: "제6조 (처리하는 개인정보 항목)",
                cluaseDescriptionList: [" 에스큐아이소프트(주)는 다음의 개인정보 항목을 처리하고 있습니다."]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("홈페이지 회원 가입 및 관리", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 필수항목 : 아이디, 비밀번호, 이메일 주소", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 선택항목 : 사용용도, 관심 키워드", style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("재화 또는 서비스 제공", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 필수항목 : 카드 번호, 유효기간, 비밀번호 앞 2자리, 카드 소유자 이름, 생년월일 또는 사업자등록번호, 연락처, 이메일",
                      style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 선택항목 : 없음", style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("인터넷 서비스 이용과정에서 아래 개인정보 항목이 자동으로 생성되어 수집될 수 있습니다.", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ IP주소, 쿠키, MAC주소, 서비스 이용기록, 방문기록", style: bodyMedium),
                ])),
            clauseComponent(clauseTitle: "제7조 (개인정보의 파기)", cluaseDescriptionList: [
              " 1. 에스큐아이소프트(주)는 개인정보 보유기간의 경과, 처리목적 달성 등 개인정보가 불필요하게 되었을 때에는 지체없이 해당 개인정보를 파기합니다.",
              " 2. 정보주체로부터 동의받은 개인정보 보유기간이 경과하거나 처리목적이 달성되었음에도 다른 법령에 따라 개인정보를 계속 보존하여야 할 때에는, 해당 개인정보를 별도의 데이터베이스(DB)로 옮기거나 보관장소를 달리하여 보존합니다.",
              " 3. 개인정보 파기의 절차 및 방법은 다음과 같습니다."
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("파기절차", style: titleMedium),
                  const SizedBox(height: 16),
                  Text(
                      "  에스큐아이소프트(주)는 파기 사유가 발생한 개인정보를 선정하고, 에스큐아이소프트(주)의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.",
                      style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("파기방법", style: titleMedium),
                  const SizedBox(height: 16),
                  Text(
                      "  에스큐아이소프트(주)는 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없도록 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.",
                      style: bodyMedium),
                ])),
            clauseComponent(
                clauseTitle: "제8조 (개인정보의 안전성 확보조치)",
                cluaseDescriptionList: [" 에스큐아이소프트(주)는 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다."]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("관리적 조치", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  내부관리계획 수립·시행, 정기적 직원 교육 등", style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("개인정보 처리 시스템 등의 접근권한 관리, 접근통제시스템 설치, 고유식별정보 등의 암호화, 보안프로그램 설치",
                      style: titleMedium),
                  const SizedBox(height: 24),
                  Text("물리적 조치", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  전산실, 자료보관실 등의 접근 통제", style: bodyMedium),
                ])),
            clauseComponent(
                clauseTitle: "제9조 (개인정보 자동 수집 장치의 설치·운영 및 거부에 관한 사항)",
                cluaseDescriptionList: [
                  " 1. 에스큐아이소프트(주)는 이용자에게 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다.",
                  " 2. 쿠키는 웹사이트를 운영하는 데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에 보내는 소량의 정보이며 이용자들의 PC 컴퓨터 내의 하드디스크에 저장되기도 합니다.",
                ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("쿠키의 사용 목적", style: titleMedium),
                  const SizedBox(height: 16),
                  Text(
                      "  이용자가 방문한 각 서비스와 웹사이트들에 대한 방문 및 이용 형태, 인기 검색어, 보안접속 여부 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다.",
                      style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("쿠키의 설치·운영 및 거부", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  웹 브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부할 수 있습니다.",
                      style: bodyMedium),
                  const SizedBox(height: 24),
                  Text("쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.", style: titleMedium),
                ])),
            clauseComponent(clauseTitle: "제10조 (개인정보 보호 책임자)", cluaseDescriptionList: [
              " 에스큐아이소프트(주)는 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보보호 책임자를 지정하고 있습니다."
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("개인정보 보호 책임자", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 성명 : 박선견", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 직책 : 전무", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 연락처 : 02-2284-3333, webmaster@sqisoft.com", style: bodyMedium),
                  const SizedBox(height: 10),
                ])),
            clauseComponent(clauseTitle: "제11조 (개인정보 열람청구)", cluaseDescriptionList: [
              " 정보 주체는 개인정보 보호법 제35조에 따른 개인정보의 열람 청구를 아래의 부서에 할 수 있습니다. 회사는 정보주체의 개인정보 열람 청구가 신속하게 처리되도록 노력하겠습니다."
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("개인정보 열람청구 접수·처리 담당자", style: titleMedium),
                  const SizedBox(height: 16),
                  Text("  ⦁ 성명 : 박선견", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 직책 : 전무", style: bodyMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 연락처 : 02-2284-3333, webmaster@sqisoft.com", style: bodyMedium),
                  const SizedBox(height: 10),
                ])),
            clauseComponent(clauseTitle: "제12조 (권익침해 구제방법)", cluaseDescriptionList: [
              " 정보 주체는 아래의 기관에 대해 개인정보 침해에 대한 피해구제, 상담 등을 문의하실 수 있습니다. \n<아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 더욱 자세한 도움이 필요하시면 문의하여주시기 바랍니다.>"
            ]),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("  ⦁ 개인정보 침해신고센터 (https://privacy.kisa.or.kr/kor/main.jsp / 국번없이 118)",
                      style: titleMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 대검찰청 인터넷범죄수사센터 (http://www.spo.go.kr / 02-3480-2000)",
                      style: titleMedium),
                  const SizedBox(height: 10),
                  Text("  ⦁ 경찰청 사이버안전국(http://cyberbureau.police.go.kr / 국번없이 182)",
                      style: titleMedium)
                ])),
            clauseComponent(
                clauseTitle: "제13조 (개인정보 처리방침 변경)",
                cluaseDescriptionList: [" 이 개인정보 처리 방침은 2024.1.1 부터 적용됩니다."]),
            const SizedBox(height: 32)
          ],
        ),
      ),
    );
  }

  Widget clauseComponent({required String clauseTitle, List<String>? cluaseDescriptionList}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(clauseTitle, style: bodyLarge),
      const SizedBox(height: 12),
      for (var cluaseDescription in cluaseDescriptionList!)
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(cluaseDescription, style: bodyMedium),
        )
    ]);
  }

  // ************************************ footer ************************************
  Widget footer() {
    TextStyle footerBTNStyle = CretaFont.buttonLarge
        .copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white);
    return Container(
        width: _screenWidth,
        height: 280,
        color: Colors.black,
        child: Center(
          child: SizedBox(
              width: 1360,
              height: 127,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Image(
                      image: AssetImage("assets/creta_logo_blue.png"),
                      width: 136,
                      height: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 219,
                    height: 48,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AccountManager.currentLoginUser.isLoginedUser
                            ? customButton(
                                width: 52,
                                height: 19,
                                child: Text("Logout", style: footerBTNStyle),
                                backgroundColor: Colors.black,
                                onTap: () {
                                  setState(() {
                                    CretaAccountManager.logout();
                                  });
                                })
                            : customButton(
                                width: 40,
                                height: 19,
                                child: Text("Login", style: footerBTNStyle),
                                backgroundColor: Colors.black,
                                onTap: () => LoginDialog.popupDialog(
                                    context: context, getBuildContext: getBuildContext)),
                        customButton(
                            width: 140,
                            height: 48,
                            child: Text("Sign up", style: footerBTNStyle),
                            backgroundColor: Colors.black,
                            onTap: () => LoginDialog.popupDialog(
                                context: context,
                                getBuildContext: getBuildContext,
                                loginPageState: LoginPageState.singup),
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(6.6)),
                      ],
                    ),
                  )
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 24),
                  child: Container(width: 1360, height: 1, color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        width: 251,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 20),
                            customButton(
                                width: 56,
                                height: 19,
                                child: Text("이용약관",
                                    style: CretaFont.bodyMedium.copyWith(color: Colors.white)),
                                backgroundColor: Colors.black,
                                onTap: () {
                                  Routemaster.of(context).push(AppRoutes.serviceTerms);
                                }),
                            customButton(
                                width: 115,
                                height: 19,
                                child: Text("개인정보처리방침",
                                    style: CretaFont.bodyMedium.copyWith(color: Colors.white)),
                                backgroundColor: Colors.black,
                                onTap: () {
                                  Routemaster.of(context).push(AppRoutes.privacyPolicy);
                                })
                          ],
                        )),
                    Text("© 2024 SQISOFT All Rights Reserved",
                        style: CretaFont.bodyESmall.copyWith(color: Colors.white.withOpacity(.2)))
                  ],
                )
              ])),
        ));
  }
}
