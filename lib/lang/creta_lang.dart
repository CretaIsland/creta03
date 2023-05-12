// ignore_for_file: non_constant_identifier_names

class CretaLang {
  static const String billInfo = '요금제 정보';
  static const String searchBar = '검색어를 입력하세요';
  static const String all = '전체';
  static const String mute = '소리없음/있음';

  static const List<String> basicBookFilter = [
    "용도별(전체)",
    "프리젠테이션용",
    "전차칠판용",
    "디지털사이니지용",
    "기타",
  ];

  static const List<String> basicBookSortFilter = [
    "최신순",
    "이름순",
    "좋아요순",
    "조회수순",
  ];

  static const List<String> basicBookPermissionFilter = [
    "권한별(전체)",
    "소유자",
    "편집자",
    "뷰어",
  ];

  static const String edit = '편집하기';
  static const String play = '재생하기';
  static const String addToPlayList = '재생목록에 추가';
  static const String share = '공유하기';
  static const String download = '다운로드';
  static const String copy = '복사하기';

  static String yearBefore = '년 전';
  static String monthBefore = '달 전';
  static String dayBefore = '일 전';
  static String hourBefore = '시간 전';
  static String minBefore = '분 전';

  static String hours = '시간';
  static String minutes = '분';
  static String seconds = '초';
  static String playTime = '플레이 시간';
  static String playDuration = '플레이 간격';
  static String forever = '영구히';
  static String onlyOnce = '한번만';

  static List<String> contentsTypeString = [
    "없음",
    "비디오",
    "이미지",
    "텍스트",
    "유투브",
    "효과",
    "스티커",
    "뮤직",
    "날씨",
    "뉴스",
    "도큐먼트",
    "데이터시트",
    "PDF",
    "3D",
    "웹",
    "스트림",
    "끝",
  ];

  static String contentsDeleted = ' 콘텐츠가 삭제되었습니다';
  static String contentsNotDeleted = ' 콘텐츠가 삭제되지 않았습니다. 잠시 후에 다시 시도하십시오';

  static String count = "개";

  static String text = "텍스트";
  static String font = "폰트";

  static String fontNanum_Myeongjo = '나눔명조';
  static String fontJua = '유아';
  static String fontNanum_Gothic = '나눔고딕';
  static String fontNanum_Pen_Script = '나눔펜스크립트';
  static String fontNoto_Sans_KR = '노토산스KR';
  static String fontPretendard = '프리텐다드';
  static String fontMacondo = 'Macondo마콘도';
  static List<String> fontStringList = [
    fontNanum_Myeongjo,
    fontJua,
    fontNanum_Gothic,
    fontNanum_Pen_Script,
    fontNoto_Sans_KR,
    fontPretendard,
    fontMacondo,
  ];
}
