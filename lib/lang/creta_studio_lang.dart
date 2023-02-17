import 'package:flutter/material.dart';

class CretaStudioLang {
  static Map<String, String> pageSizeMapPresentation = {
    '사용자지정': '',
    '표준 4 : 3': '960x720',
    '와이드스크린 16:9': '960x540',
    '와이드스크린 16:10': '960x600',
    '프레젠테이션': '1920x1080',
    '상세페이지': '860x1100',
    '카드뉴스': '1080x1080',
    '유튜브 썸네일': '1280x720',
    '유튜브 채널아트': '2560x1440',
    'SNS': '1200x1200',
    '16:9 PC': '2560x1440',
    '9:19 아이폰': '1080x2280',
    '3:4 아이패드': '2048x2732',
    '10:16 갤럭시 탭': '1600x2560',
    '9:16 안드로이드': '1440x2560',
    '레터': '2550x3300',
    'a4': '2480x3508',
    'a3': '3508x4961',
    'a5': '1748x2480',
    'a6': '105x148',
    'b3': '4169x5906',
    'b4': '2953x4169',
    'b5': '2079x2953',
    'c4': '2705x3827',
    'c5': '1913x2705',
    'c6': '1346x1913',
  };

  static List<String> pageSizeListSignage = [
    "사용자지정",
    "4:3 스크린",
    "16:10 스크린",
    "16:9 스크린",
    "21:9 스크린",
    "32:9 스크린",
  ];

  static List<String> copyWrightList = [
    "None",
    "자유로운 사용 가능",
    "비상업적인 목적으로만 사용 가능",
    "출처를 공개한 경우에 한해 사용 가능",
    "허가 없이 사용 불가",
    "End",
  ];

  static List<String> bookTypeList = [
    "None",
    "프리젠테이션용",
    "디지털사이니지용",
    "전자칠판용",
    "기타",
    "End",
  ];

  static Map<String, String> bookInfoTabBar = {
    '크레타북 정보': 'book_info',
    '크레타북 설정': 'book_settings',
    '편집자 권한': 'authority',
  };

  static List<String> menuStick = [
    "템플릿",
    "페이지",
    "프레임",
    "보관함",
    "이미지",
    "동영상",
    "텍스트",
    "도형",
    "위젯",
    "카메라",
    "코멘트",
  ];
  static List<IconData> menuIconList = [
    Icons.dynamic_feed_outlined, //MaterialIcons.dynamic_feed,
    Icons.insert_drive_file_outlined, //MaterialIcons.insert_drive_file,
    Icons.space_dashboard_outlined,
    Icons.inventory_2_outlined,
    Icons.image_outlined,
    Icons.slideshow_outlined,
    Icons.title_outlined,
    Icons.pentagon_outlined,
    Icons.interests_outlined,
    Icons.photo_camera_outlined,
    Icons.chat_outlined,
  ];

  static const List<String> frameKind = [
    //"전체",
    "16:9 가로형",
    "16:9 세로형",
    "4:3 가로형",
    "4:3 세로형",
    "16:10 가로형",
    "16:10 세로형",
    "사용자정의",
  ];

  static const List<String> colorTypes = [
    //"전체",
    "단색",
    "그라데이션",
  ];

  static const String myCretaBook = "내 크레타북";
  static const String sharedCretaBook = "공유 크레타북";
  static const String teamCretaBook = "팀북";
  static const String trashCan = "휴지통";

  static const String myCretaBookDesc = " 님의 크레타북 입니다";
  static const String sharedCretaBookDesc = " 님이 공유받은 크레타북입니다";
  static const String teamCretaBookDesc = " 팀의 크레타북 입니다";

  static const String latelyUsedFrame = "최근 사용한 프레임";

  static const String autoScale = "자동맞춤";

  static const String sampleBookName = "이름없는 크레타북";

  static const String publish = "발행하기";

  static const String tooltipNoti = '알림이 있습니다';
  static const String tooltipNoNoti = '알림이 없습니다';
  static const String tooltipVolume = '작업하는 동안 소리를 끄거나 켭니다';
  static const String tooltipPause = '작업하는 동안 동영상을 정지하거나 플레이합니다';
  static const String tooltipUndo = '취소';
  static const String tooltipRedo = '복원';
  static const String tooltipDownload = '다운로드';
  static const String tooltipInvite = '초대하기';
  static const String tooltipPlay = '미리보기';
  static const String tooltipScale = '항상 화면 크기에 알맞게 맞춥니다.';
  static const String tooltipDelete = '삭제하기';

  static const String gotoCommunity = '커뮤니티로 이동';

  static const String newBook = '새 크라타북';
  static const String newPage = '새 페이지 추가';
  static const String treePage = '자세히 보기';
  static const String noNamepage = '이름없는 페이지';

  static const String wide = "전체 페이지 보기";
  static const String close = "닫기";

  static const String copy = "복사하기";
  static var showUnshow = "보이기/안보이기";

  static const String description = "설명";
  static const String hashTab = "해쉬태그";
  static const String infomation = "정보";
  static const String pageSize = "페이지 크기";
  static const String bookBgColor = "전체 배경색";
  static const String pageBgColor = "페이지 배경색";
  static const String onLine = "온라인";
  static const String offLine = "오프라인";
  static const String transitionPage = "페이지 전환 효과";
  static const String fadeIn = "페이드 인";

  static const String updateDate = "마지막 수정 날짜";
  static const String createDate = "만든 날짜";
  static const String creator = "만든 사람";
  static const String copyWright = "저작권";
  static const String bookType = "크레타북 용도";
  static const String width = "너비";
  static const String height = "높이";
  static const String color = "색";
  static const String opacity = "투명도";

  static const String basicColor = '기본색';
  static const String accentColor = '강조색';
  static const String customColor = '커스텀';
  static const String bwColor = '흑백';
  static const String bgColorCodeInput = '색상 코드로 입력';

  static const String glass = '유리질';
  static const String outlineWidth = '두께';
  static const String option = '옵션';
  static const String autoPlay = '자동 페이지 넘김';
  static const String widthHeight = '(가로x세로)';
  static const String gradation = '그라데이션';

  static const String gradationTooltip = '투톤 칼러를 선택합니다';
  static const String colorTooltip = '기본색을 선택합니다';
}
