import 'creta_device_lang.dart';

class CretaDeviceLangKR extends AbsCretaDeviceLang {
  CretaDeviceLangKR() {
    editHost = "속성 수정";
    setBook = "방송 변경";
    powerOff = "전원 off";
    powerOn = "전원 On";
    reboot = "리부트";
    setPower = "자동 전원 설정";

    newHost = "새 디바이스 등록";
    used = "사용";
    unUsed = "미사용";
    licensed = "등록";
    unLicensed = "미등록";
    myCretaDevice = "내 디바이스";
    teamCretaDevice = "팀 디바이스";
    sharedCretaDevice = "공유 디바이스";
    myCretaDeviceDesc = "님의 크레타 디바이스를 관리합니다.";
    myCretaAdminDesc = "님의 크레타 디바이스의 라이센스를 관리합니다.";
    enterpriseDesc = "님의 크레타 고객 정보를 관리합니다.";

    inputHostInfo = "생성할 디바이스 정보를 입력하세요";
    deviceId = "디바이스 ID";
    deviceName = "디바이스 이름";

    shouldInputDeviceId = "디바이스 ID를 입력하세요.";
    shouldInputDeviceName = "디바이스 이름을 입력하세요.";

    deviceDetail = "디바이스 상세화면";
    device = "디바이스";
    studio = "스튜디오";
    community = "커뮤니티";
    admin = "인증센터";

    license = "라이센스 설정";
    enterprise = "커스터머 설정";

    selectBook = "방송할 크레타 북을 선택하세요.";

    basicHostFilter = [
      "용도별(전체)",
      "사이니지",
      "디지털바리케이드",
      "에스컬레이터",
      "보드",
      "CDU",
      "기타",
    ];
    usageHostFilter = [
      "전체",
      "사용",
      "미사용",
    ];
    connectedHostFilter = [
      "전체",
      "연결",
      "미연결",
    ];

    notice = "긴급공지";
  }
}
