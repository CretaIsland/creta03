mixin CretaDeviceLangMixin {
  String editHost = "속성 수정";
  String setBook = "방송 변경";
  String powerOff = "전원 off";
  String powerOn = "전원 On";
  String reboot = "리부트";
  String setPower = "자동 전원 설정";

  String newHost = "새 디바이스 등록";
  String used = "사용";
  String unUsed = "미사용";
  String licensed = "등록";
  String unLicensed = "미등록";
  String myCretaDevice = "내 디바이스";
  String teamCretaDevice = "팀 디바이스";
  String sharedCretaDevice = "공유 디바이스";
  String myCretaDeviceDesc = "님의 크레타 디바이스를 관리합니다.";
  String myCretaAdminDesc = "님의 크레타 디바이스의 라이센스를 관리합니다.";
  String enterpriseDesc = "님의 크레타 고객 정보를 관리합니다.";

  String inputHostInfo = "생성할 디바이스 정보를 입력하세요";
  String deviceId = "디바이스 ID";
  String deviceName = "디바이스 이름";

  String shouldInputDeviceId = "디바이스 ID를 입력하세요.";
  String shouldInputDeviceName = "디바이스 이름을 입력하세요.";

  String deviceDetail = "디바이스 상세화면";
  String device = "디바이스";
  String studio = "스튜디오";
  String community = "커뮤니티";
  String admin = "인증센터";

  String license = "라이센스 설정";
  String enterprise = "커스터머 설정";

  String selectBook = "방송할 크레타 북을 선택하세요.";

  List<String> basicHostFilter = [
    "용도별(전체)",
    "사이니지",
    "디지털바리케이드",
    "에스컬레이터",
    "보드",
    "CDU",
    "기타",
  ];
  List<String> usageHostFilter = [
    "전체",
    "사용",
    "미사용",
  ];
  List<String> connectedHostFilter = [
    "전체",
    "연결",
    "미연결",
  ];

  String notice = "긴급공지";
}
