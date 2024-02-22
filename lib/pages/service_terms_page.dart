import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_color.dart';
import 'package:creta03/pages/login/creta_account_manager.dart';
import 'package:creta03/pages/login/login_dialog.dart';
import 'package:creta03/routes.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';
import 'package:routemaster/routemaster.dart';

class ServiceTermsPage extends StatefulWidget {
  const ServiceTermsPage({super.key});

  @override
  State<ServiceTermsPage> createState() => _ServiceTermsPageState();
}

class _ServiceTermsPageState extends State<ServiceTermsPage> {
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
      alignment: Alignment.center,
      child: SizedBox(
        width: _screenWidth == null ? 1000 : _screenWidth! * .7,
        child: Padding(
          padding: const EdgeInsets.only(top: 48, bottom: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("이용약관", style: titleELarge)),
              const SizedBox(height: 40),
              clauseComponent(clauseTitle: "제1조 (목적)", cluaseDescriptionList: [
                "본 약관은 에스큐아이소프트 주식회사 (\"회사\" 또는 \"에스큐아이소프트\")가 크레타 (“서비스”)의 이용과 관련하여 회사와 사용자 간의 권리, 의무 및 책임사항, 기타 필요한 사항을 규정함을 목적으로 합니다."
              ]),
              const SizedBox(height: 32),
              clauseComponent(
                  clauseTitle: "제2조 (용어의 정의)",
                  cluaseDescriptionList: ["본 약관에서 사용하는 용어의 정의는 다음과 같습니다"]),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("1. \"서비스\"라 함은 \"회사\"에서 운영하는 크레타 서비스를 의미합니다.", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"사용자\"라 함은 회원, 비회원, 기업 등 \"회사\"가 제공하는 \"서비스\"를 이용하는 모든 단체, 법인을 말하며 개인, 사업자, 법인 등을 포함합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("3. \"회원\"이라 함은 \"서비스\"에 회원가입 이후 서비스 이용에 대한 계정을 부여받은 \"사용자\"를 뜻합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("4. \"단말\"이라 함은 \"회원\"이 운용하는 키오스크, 디지털 사이니지 등의 디지털 미디어 기기를 통칭하는 말입니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "5. \"콘텐츠\"란 사진, 비트맵 이미지, 벡터 이미지, GIF 애니메이션, 아이콘, 선, 도형, 일러스트, 글꼴, 영상, 음원, 폰트 등 \"사용자\"가 디자인을 하기 위해 사용하는 데이터를 의미합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "6. \"위젯\"이란  \"사용자\"가 \"서비스\"를 통해 사용할 수 있도록 \"회사\"가 제공하는 음악, 날씨, 날짜, 시계, 효과, 뉴스 등의 요소를 의미합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "7. \"템플릿\"이란, \"사용자\"가 \"서비스\"를 통해 편집 및 사용할 수 있도록 복수의 \"위젯\"과 \"콘텐츠\"를 조합한 데이터를 의미합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("8. \"프레임\"이란 하나 이상의 \"콘텐츠\"를 담고 있는 형태의 요소를 의미합니다.", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("9. \"크레타북\"이란, \"사용자\"가 크레타 서비스 내 편집기를 통해 제작한 페이지로 이루어진 작업물을 의미합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("10. \"페이지\"란 “사용자”가 \"크레타북\" 내의 편집기를 디자인한 한 화면을 의미합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("11. \"채널\"이란 “사용자”가 만든 \"크레타북\"을 게시하고 공유하는 공간을 의미합니다.", style: bodyMedium)
                  ])),
              clauseComponent(clauseTitle: "제3조 (이용약관의 효력 및 개정)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. 본 약관은 귀하가 \"회사\"의 \"서비스\" 접속 또는 이용 시 본 약관 및 개인 정보 보호 정책 등 \"회사\"가 명시한 정책에 동의한 것으로 간주하며 즉시 효력이 발생합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"회사\"는 \"약관의규제에관한법률\", \"정보통신망이용촉진및정보보호등에관한법률\" 등 관련 법령에 위배되지 않는 범위에서 사전 고지 없이 본 약관을 개정할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"는 변경된 약관 정보를 적용일 기준 7일 이전에 적용 일자 및 개정 사유를 \"회사\"의 웹사이트 \"서비스\" 공지 및 전자우편 등의 방법으로 고지함으로써 \"사용자\"의 동의 및 적용이 된 것으로 간주, 즉시 변경된 약관의 효력이 발생합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "4. \"회사\"는 변경된 약관 정보에 \"사용자\"에게 불리한 내용이 포함된 경우 최소 30일 이전에 이를 공지해야 하며, \"사용자\"에게 일정기간 서비스내 전자적 수단을 통해 따로 명확히 통지하도록 합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "5. \"사용자\"는 변경된 약관에 동의하지 않을 경우 회원 탈퇴 및 해지가 가능하며, \"사용자\"가 변경된 약관의 효력 발생일 이후 \"서비스\"를 사용할 경우 약관의 변경 사항에 동의한 것으로 간주합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "6. \"회사\"는 \"사용자\"가 \"회사\"의 \"서비스\"를 통해 고지 또는 명시한 변경된 약관에 대한 정보를 인지하지 못해 발생한 피해에 대해 책임을 지지 않습니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제4조 (서비스 이용계약의 성립)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. 이용계약은 \"회원\"이 되고자 하는 자가 약관의 내용에 대하여 동의를 한 다음 회원가입신청을 하고 \"회사\"가 이러한 신청에 대하여 승낙함으로써 체결됩니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. 이용계약은 \"서비스\" 회원 가입 시 등록한 이용 신청 정보에 대해 회사가 승인함으로써 즉시 효력이 발생하며, 이와 동시에 본 약관과 개인정보 처리방침에 동의한 것으로 간주합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"는 \"가입신청자\"의 신청에 대하여 \"서비스\" 이용을 승낙함을 원칙으로 하지만 다음 각 호에 대항하는 신청에 대하여는 이용계약을 취소하거나 거절할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 회원가입을 신청한 \"사용자\"가 본 약관에 의하여 회원자격을 상실한 적이 있는 경우", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 타인의 명의를 도용하여 \"회원가입\"을 신청한 경우", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 회원가입 신청 시 허위의 정보를 기재하거나, 회사가 요구하는 내용을 기재하지 않은 경우", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 회원가입 신청 시 귀책사유로 인하여 승인이 불가능한 경우", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 회원가입 신청 시 기타 규정한 제반 사항을 위반하여 신청하는 경우", style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제5조 (개인정보 보호)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\"는 개인정보 취급 방침 및  \"정보통신망법\" 등 관련 법령을 통해 \"회원\"의 정보를 보호하여야 할 의무가 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. 개인정보의 보호 및 사용에 대해서는 관련법 및 \"회사\"의 개인정보처리방침이 적용됩니다. 다만, \"회사\"의 공식 사이트 이외의 링크된 사이트에서는 \"회사\"의 개인정보처리방침이 적용되지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회원\"은 비밀번호, 이메일 등 계정 정보 유출에 유의해야 하며, \"회사\"는 \"회원\"의 귀책 사유로 노출된 정보에 대해 책임을 지지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("4. \"회사\"는 다음과 같은 경우에 법이 허용하는 범위 내에서 \"회원\"의 개인 정보를 제 3자에게 제공할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 이용자들이 사전에 동의한 경우", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 통계작성, 학술연구 또는 시장조사를 위하여 필요한 경우로서 특정개인을 식별할 수 없는 형태로 제공하는 경우",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "  ⦁ 영업의 양도·합병 등에 관한 사유가 발생하는 경우(단, 회사는 영업의 양도 등에 관한 사유가 발생하여 이용자의 개인정보 이전이 필요한 경우, 관계법률에서 규정한 절차와 방법에 따라 개인정보 이전에 관한 사실 등을 사전에 고지하며, 이용자에게는 개인정보 이전에 관한 동의 철회권을 부여합니다.)",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 법령의 규정에 의거하거나, 수사 목적으로 사기관의 요구가 있는 경우", style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제6조 (회원의 계정)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회원\"은 \"회사\"가 \"서비스\"를 통해 제공하는 가입 해지 메뉴 또는 고객 센터를 통해 이용계약을 해지할 수 있습니다. ",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"사용자\"는 계정을 만들 때 정확하고 완전한 정보를 제공해야 하며, \"회사\"는 관계 법령상 개인 정보 취급 방침에 따라 \"사용자\" 또는 \"회원\"의 개인 정보를 관리 및 변경할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"사용자\"는 허가 없이 다른 \"사용자\"의 계정을 이용할 수 없으며, 타인의 정보를 도용하거나 허위로 정보를 등록할 경우 \"서비스\" 권리 침해 및 보안 등 이슈가 발생하여도 아무런 권리를 주장할 수 없고 관계 법령에 따라 민사상 손해배상책임 또는 형사 처벌을 받을 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "4. \"회사\"는 타인의 정보(타인의 이름, 이메일)를 도용하여 이용 계약을 체결한 \"회원\"의 계정을 삭제할 수 있으며, 그에 따른 책임은 전적으로 \"회원\"이 부담합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("5. \"회사\"는 \"사용자\"의 이메일 계정을 다음에 해당하는 사유로 변경 또는 해지할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ \"사용자\" 이메일 계정이 개인을 식별할 수 있는 정보를 포함하여 타인의 사생활을 침해할 우려가 있는 경우",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁  \"사용자\" 이메일 계정이 타인에게 혐오감을 주거나 사회의 불안감을 조성할 수 있는 정보를 포함한 경우",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "  ⦁ \"사용자\" 이메일 계정이 \"회사\", \"회사\" 의 \"서비스\" 또는 \"서비스\" 운영자 등과 명칭이 동일하거나 오인 등의 우려가 있는 경우",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ \"사용자\" 이메일 계정이 기타 법적인 문제, 사회적 분쟁 등을 야기할 수 있는 합리적인 사유가 있는 경우",
                        style: bodyMedium),
                    const SizedBox(height: 16),
                    Text(
                        "6. \"회원\"의 계정에서 발생하는 활동으로 인하여 발생하는 분쟁에 대한 사실상/법률상 책임은 전적으로 \"회원\" 회사자에게 있으며, \"회사\"는 어떠한 책임을 부담하지 않으므로 \"회원\"은 계정의 암호를 안전하게 유지해야 합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "7. \"회원\"은 다른 사람이 \"회원\" 회사자의 고유한 사용자 이름, 비밀번호 또는 기타 보안 코드로 \"서비스\"에 액세스하거나 \"서비스\"를 이용하도록 허용할 수 없으며, \"회원\"은 보안 위반 또는 계정 무단 사용이 발생하면 즉시 \"회사\"에 알려야 합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "8. \"회원\"의 계정과 비밀번호에 대한 모든 관리 및 책임은 “회원”에게 있으며, \"회사\"는 \"회원\"이 이메일 계정 또는 비밀 번호를 사용 및 관리하는 과정에서 발생하는 과실로 인해 제 3자에 의한 부정 사용 등의 침해를 입은 경우 책임을 지지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "9. \"회사\"는 계정의 무단 사용으로 인한 손실에 대해 책임을 지지 않으며, \"회원\"이 본인의 계정에 대한 강력한 암호를 설정할 것을 권고합니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제 7조 (\"서비스\"의 변경)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\"는 상당한 이유가 있는 경우에 운영상, 기술상의 필요에 따라 제공하고 있는 전부 또는 일부 \"서비스\"를 변경할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"서비스\"의 내용, 이용방법, 이용시간에 대하여 변경이 있는 경우에는 변경사유, 변경될 서비스의 내용 및 제공일자 등은 그 변경 전에 해당 서비스 초기화면에 게시하여야 합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"는 제공되는 서비스의 일부 또는 전부를 회사의 정책 및 운영의 필요상 수정, 중단, 변경할 수 있으며, 이에 대하여 관련법에 특별한 규정이 없는 한 \"회원\"에게 별도의 보상을 하지 않습니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제8조 (서비스 이용 시간)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\"는 원칙적으로 \"서비스\"를 휴일과 무관하게 매일 24시간 내내 이용이 가능하도록 운영하지만, 정보통신설비의 보수점검, 교체 및 고장, 통신두절 또는 운영상 상당한 이유가 있는 경우 별도의 예고 또는 통지 없이 \"서비스\"를 일시적으로 중단할 수 있으며, 합리적인 사유에 의해 현재 제공되는 \"서비스\"를 완전히 중단할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"회사\"는 국가 비상 사태, 정전, 설비 등의 장애 또는 \"서비스\" 이용의 폭주 등으로 정상적인 \"서비스\" 제공이 불가능한 경우, 그 사유 및 기간을 \"회원\"에게 사전 또는 사후 공지하고 \"서비스\"의 전부 또는 일부를 제한 또는 중지할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"는 서비스의 제공에 필요한 경우 정기점검을 실시할 수 있으며, 정기점검시간은 서비스제공화면에 공지한 바에 따릅니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제9조 (서비스 이용 제한 범위)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\"는 \"회원\"이 약관의 의무를 위반하거나 \"서비스\"의 정상적인 운영을 방해한 경우, \"서비스\" 이용을 제한할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"회사\"는 \"사용자\" 또는 \"회원\"의 사용자 콘텐츠 또는 행위가 아래의 사용 금지 범위에 해당하는 경우, 사전의 통지 없이 \"사용자\"의 콘텐츠 및 \"회원\"이 업로드 한 \"채널\"을 즉시 삭제할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("3. \"회사\"는 \"사용자\" 또는 \"회원\" 간의 분쟁을 모니터링 할 권한이 있지만 의무는 없습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "4. \"회사\"는 \"사용자\" 또는 \"회원\" 상호 간의 분쟁에 대한 책임을 지지 않으며, 이에 대한 책임은 \"사용자\" 또는 \"회원\" 본인에게 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "5. \"회사\"는 회사의 설비, 기술적인 문제 또는 기타 \"회사\"의 귀책 사유로 인해 불가피한 경우 \"회원\" 및 \"사용자\"의 \"서비스\" 이용을 제한할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "6. \"회원\"은 관계법령, 이 약관의 규정, 이용지침, \"서비스\" 이용안내 및 \"서비스\"와 관련하여 공지한 주의사항, \"회사\"가 통지하는 사항 등을 준수하여야 하며, 기타 \"회사\"의 업무에 방해되는 행위 및 다음 각호에 해당하는 행위를 해서는 안 됩니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 회원가입 또는 회원정보 변경 시 허위 내용을 등록하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 타인의 정보를 수집, 저장, 공개하거나 도용하여 부정하게 사용하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ \"서비스\"의 이용권한, 기타 이용 계약상 지위를 타인에게 양도, 증여하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "  ⦁ 저작권법에 위반하여 기술적 보호조치를 무력화하는 불법 프로그램 이용 등 비정상적인 경로를 통해 \"서비스\"를 이용하는 행위",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "  ⦁ 회사의 동의 없이 \"서비스\", 콘텐츠 또는 이에 포함된 소프트웨어의 일부를 복사, 수정, 배포, 판매, 양도, 대여하거나 타인에게 그 이용을 허락하는 행위와 소프트웨어를 역설계하거나 소스 코드의 추출을 시도하는 등 \"서비스\"를 복제, 분해 또는 모방하거나 기타 변형하는 행위",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁  \"회사\"의 운영자, 임직원, \"회사\"를 사칭하거나 관련 정보를 도용하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ \"회사\"와 기타 제3자의 저작권, 영업비밀, 특허권 등 지적재산권을 침해하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 제공되는 \"서비스\"를 사적 목적이 아닌 공공장소에서 공개하거나 영리를 목적으로 이용하는 행위",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "  ⦁ 자신의 재산상 이익을 위하여 \"회사\" 또는 \"회사\"의 \"서비스\"와 관련된 허위의 정보를 유통하거나 비정상적으로 \"서비스\"를 이용하는 행위",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁  \"회사\"와 다른 \"회원\" 및 기타 제3자를 희롱하거나, 위협하거나 명예를 손상시키는 행위",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 외설, 폭력적인 메시지, 기타 공서양속에 반하는 정보를 공개 또는 게시하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 고객센터 문의 시 욕설, 폭언, 성희롱, 반복적인 민원을 통해 업무를 방해하는 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 현행 법령에 위반되는 불법적인 행위", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("  ⦁ 기타 \"회사\"의 건전한 \"서비스\" 운영을 방해하는 일체의 행위", style: bodyMedium),
                    const SizedBox(height: 16),
                    Text(
                        "7. \"회사\"는 \"회원\"이 전항에서 금지한 행위를 하는 경우, 위반 행위의 경중에 따라 \"서비스\"의 이용정지/계약의 해지 등 \"서비스\" 이용 제한, 수사 기관에의 고발 조치 등 합당한 조치를 취할 수 있습니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제10조 (회사의 의무)", cluaseDescriptionList: [
                "\"회사\"는 관련법과 이 약관이 금지하거나 미풍양속에 반하는 행위를 하지 않으며, 계속적이고 안정적으로 \"서비스\"를 제공하기 위하여 최선을 다하여 노력합니다."
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\" 는 지속적이고 안정적인 \"서비스\"의 제공을 위하여 설비에 장애 발생 시 지체 없이 설비를 수리 및 복구합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("2. \"회사\"는 개인 정보 보호를 위해 개인정보취급방침을 공시하고 준수합니다.", style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"는 \"사용자\" 또는 \"회원\"이 제시한 의견, 불만, 건의 내용이 정당하다고 판단되는 경우, 적절한 절차를 걸쳐 반영 및 개선할 의무가 있고 즉각적인 반영 및 개선의 불가능한 경우 \"사용자\"에게 그 사유와 처리 일정을 통지합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "4. \"회사\"는 \"서비스\"의 개선 또는 보완 등을 위해 예정된 작업으로 일시적인 \"서비스\" 중단이 필요한 경우, 사전에 \"회원\" 또는 \"사용자\"에게 \"회사\"의 \"서비스\"를 통해 공지합니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제11조 (회원의 의무)", cluaseDescriptionList: [
                "\"회원\"은 관계법, 이 약관의 규정, 이용안내 및 \"서비스\"와 관련하여 공지한 주의사항, \"회사\"가 통지하는 사항 등을 준수하여야 하며, 기타 \"회사\"의 업무에 방해되는 행위를 하여서는 안 됩니다."
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회원\"은 회원 가입 신청 또는 회원 정보 변경 시 모든 사항을 사실에 근거하여 작성하여야 하며 허위 정보 또는 타인의 정보를 이용한 사실이 발견된 경우, \"서비스\" 이용과 관련한 일체의 권리를 주장할 수 없습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"회원\"은 본 약관에서 규정하는 사항과 기타 \"회사\"가 정한 제반 규정, \"회사\"가 공지하는 사항 및 관계 법령을 준수하여야 하며, \"회사\"의 업무에 방해되는 행위, \"회사\"의 명예를 손상 시키는 행위, 타인에게 피해를 주는 행위를 해서는 안 됩니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("3. \"회원\"은 청소년보호법 등 관계 법령을 준수하여야 하며, 이를 위반한 경우 관계 법령에 따라 처벌을 받을 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "4. \"회원\"은 회원에게 부여된 이메일 아이디와 비밀번호를 직접 관리해야 하며, 회원의 관리 소홀로 발생한 문제의 책임은 회원에게 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "5. \"회원\"은 \"회사\"의 사전 승낙 없이 \"서비스\"를 이용하여 영업 활동을 할 수 없으며, 그 영업 활동의 결과에 대한 책임은 회원에게 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "6. \"회원\"이 \"회사\"의 사전 승낙 없이 \"회사\" 의 \"서비스\" 를 이용하여 영업 활동을 하고 그 과정 또는 결과로 인해 \"회사\" 또는 \"회사\"의 \"서비스\"에 손해를 끼칠 경우, \"회사\"는 해당 \"회원\" 에게 \"서비스\" 이용을 제한하고 적법한 절차를 통한 손해 배상을 요구할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "7. \"회원\"은 \"회사\"의 명시적 동의가 없는 한 \"서비스\"의 이용 권한, 기타 이용 계약 상의 지위를 타인에게 양도, 증여할 수 없으며 이를 담보로 제공할 수 없습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "8. \"회원\"은 \"회사\" 및 \"회사\"의 제휴사, 기여자(CP), 제공자, 개인 또는 기업 사용자를 포함한 제 3자의 지적 재산권을 침해하는 행위를 해서는 안 됩니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "9. \"회원\"이 본 약관의 제 9조 (\"서비스\" 이용 제한 범위)에 해당하는 행위를 하는 경우, \"회사\"는 해당 \"회원\"의 \"서비스\" 이용 제한 및 적법한 조치를 포함한 제재를 할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "10. \"회원\"은 \"서비스\"를 이용하여 제작한 \"크레타북\"을 \"회사\"가 사용사례의 공유 목적으로 \"회사\"의 웹사이트 및 소셜 미디어 등에 게재함을 허락합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "11. \"회원\"은 \"서비스\"를 이용하는 과정에서 입력하는 데이터 및 사용자 디자인을 \"회사\"가 \"서비스\" 품질 개선 및 성능 향상, 사용자들에 대한 \"서비스\" 고도화 및 최적화 등을 목적으로 저장하는 것을 허락합니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제12조 (분쟁)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. \"회사\"는 필요한 경우 \"회원\", \"사용자\"가 제기하는 정당한 의견 또는 불만 사항을 해소 및 처리하기 위해 피해보상처리회의를 소집 및 운영할 수 있습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "2. \"회사\"는 \"회원\", \"사용자\"가 제기한 정당한 의견 또는 불만 사항을 처리하기 위해 우선적인 노력을 하고, 신속한 처리가 힘든 경우 \"회원\" 또는 \"사용자\"에게 그 사유와 처리 가능한 일정 등의 정보를 제공합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회사\"와 \"회원\" 또는 \"사용자\" 간에 발생한 전자상거래 분쟁에 대하여 \"회원\" 또는 \"사용자\"의 피해구제신청이 있는 경우, 공정거래위원회 또는 시 • 도지사가 의뢰한 분쟁조정기관의 조정에 따를 수 있습니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제13조 (회사의 면책)", cluaseDescriptionList: [
                "\"회사\" 관련 법률이 허용하는 최대 범위 내에서 아래와 같은 모든 성격의 손실 또는 재산적 피해에 대해 어떠한 책임도 지지 않습니다."
              ]),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(
                        "1. 천재지변, 전쟁 및 기타 이에 준하는 불가항력으로 인하여 \"서비스\"를 제공할 수 없는 경우 발생한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("2. \"회원\" 또는 \"사용자\"의 귀책사유로 인한 \"서비스\" 이용의 장애 및 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "3. \"회원\" 또는 \"사용자\"의 컴퓨터 오류 또는 \"회원\" 또는 \"사용자\"가 신상 정보 및 전자우편 주소를 부실하게 기재하여 발생한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("4. \"회원\" 또는 \"사용자\" 가 \"서비스\"를 통해 얻은 정보 또는 자료로 인한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "5. \"회원\" 또는 \"사용자\"가 \"서비스\"를 이용하며 다른 \"회원\" 또는 \"사용자\"로부터 받은 정신적/물질적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "6. \"서비스\"를 통해 제공되는 각종 \"콘텐츠\", \"템플릿\", \"위젯\" 등의 정보에 대한 오류, 실수 또는 부정확성으로 발생한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "7. \"회원\" 이 크레타북에 사용한 \"콘텐츠\", \"템플릿\", \"위젯\" 등이 타인의 저작권, 지적재산권 또는 인격저작권을 침해하여 발생한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "8. \"사용자\"가 \"회사\"로부터 제공받은 \"콘텐츠\", \"템플릿\", \"위젯\" 등을 이용하는 과정에서 회사와의 계약 범위를 넘어 이용함으로써 제3자의 권리 등을 침해하는 경우 발생한 모든 성격의 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "9. \"사용자\" 상호간 또는 \"사용자\"와 제3자 상호 간에 \"서비스\"를 매개로 발생한 분쟁으로 인한 모든 손실 또는 재산적 피해",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "10. \"회사\"의 \"서비스\" 장애 혹은 통신장애 등으로 인해 \"서비스\"를 사용할 수 없게 됨으로써 발생하는 사용자의 데이터의 유실, 물질적/정신적 손실, 비즈니스의 중단 등으로 인한 피해에 대하여 회사는 책임을 지지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "11.  기타 관련 법령, 본 약관, 운영정책의 변경, 회원 공지사항 등의 확인의무를 게을리하여 발생한 피해에 대해서 \"회사\"는 책임을 지지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("12. \"회사\"는 제공되는 서비스 이용과 관련하여 관련법에 특별한 규정이 없는 한 책임을 지지 않습니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text(
                        "13. \"회사\"는 무료로 제공하는 \"서비스\"와 관련하여 발생하는 사항에 대하여는 어떠한 손해도 책임을 지지 않습니다. 단, \"회사\"의 고의나 중과실로 인한 손해인 경우는 예외로 합니다.",
                        style: bodyMedium),
                  ])),
              clauseComponent(clauseTitle: "제14조 (관할법원 및 준거법)", cluaseDescriptionList: []),
              Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 32),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("1. 본 약관에 명시되지 않은 사항이 관계 법령에 규정되어 있을 경우, 관계 법령의 해당 규정에 따릅니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("2. \"회사\"의 \"서비스\" 이용으로 발생한 분쟁에 대한 소송은 대한민국 서울동부지방법원을 관할 법원으로 합니다.",
                        style: bodyMedium),
                    const SizedBox(height: 10),
                    Text("3. \"회사\"와 \"사용자\" 또는 \"회원\" 간에 제기된 소송은 대한민국 법에 따라 적용을 받습니다.",
                        style: bodyMedium),
                  ])),
            ],
          ),
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
