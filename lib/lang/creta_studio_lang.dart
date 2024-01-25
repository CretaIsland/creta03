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
    '발행 이력': 'history',
  };

  static Map<String, String> frameTabBar = {
    '프레임 설정': 'frameTab',
    '콘텐츠 설정': 'contentsTab',
    '링크 설정': 'linkTab',
  };

  static Map<String, String> textMenuTabBar = {
    '텍스트 추가': 'add_text',
    '워드 패드': 'word_pad',
    '특수 문자': 'special_char',
  };

  static Map<String, String> imageMenuTabBar = {
    '이미지': 'image',
    '가져오기': 'upload_image',
    'AI 생성': 'AI_generated_image',
    'GIPHY의 GIF': 'GIPHY_image',
  };

  static Map<String, String> storageTypes = {
    '전체': 'all',
    '이미지': 'image',
    '영상': 'video',
    // 'CretaTest': 'test',
  };

  static Map<String, String> widgetTypes = {
    '전체': 'all',
    '뮤직': 'music',
    '날씨': 'weather',
    '날짜': 'date',
    '시계': 'clock',
    '스티커': 'sticker',
    '타임라인': 'timeline',
    '효과': 'effect',
    '카메라': 'camera',
    '구글맵': 'map',
    '뉴스': 'news',
    '환율계산': 'currency exchange',
    '오늘 영어 ': 'daily quote',
  };

  static Map<String, String> newsCategories = {
    '일반': 'general',
    '사업': 'business',
    '연예': 'entertainment',
    '헬스': 'health',
    '과학': 'science',
    '스포츠': 'sports',
    '기술': 'technology',
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
    "화상회의",
    "코멘트",
  ];

  static List<String> firstCurrency = [
    "USD",
    "GBP",
    "JPY",
    "EUR",
    "CNY",
    "VND",
  ];

  static List<String> secondCurrency = [
    "KRW",
    "KRW",
    "KRW",
    "KRW",
    "KRW",
    "KRW",
  ];

  static List<IconData> menuIconList = [
    Icons.library_books_outlined, //Icons.dynamic_feed_outlined, //MaterialIcons.dynamic_feed,
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

  static List<String> imageStyleList = [
    "사진",
    "일러스트",
    "디지털 아트",
    "팝아트",
    "수채화",
    "유화",
    "판화",
    "드로잉",
    "동양화",
    "소묘",
    "크레피스",
    "스케치",
  ];

  static const List<String> tipMessage = [
    "아래에 예제와 같이 생성하고자 하는 문구를 자세하게 입력합니다.",
    "원하는 예술가의 스타일을 입력하여 이미지를 생성할 수 있습니다."
  ];

  static const List<String> detailTipMessage1 = [
    "파란색 배경, 디지털 아트로 어항에 있는 귀여운 열대어의 3D 렌더링",
    "성운의 폭발로 묘사된 농구 선수의 덩크를 유화로 표현",
    "타임스퀘어에서 스케이트보드를 타는 테디베어의 사진",
    "우주선 안의 뾰루퉁한 고양이를 오일 파스텔로 그린 작품",
  ];

  static const List<String> detailTipMessage2 = [
    "크레타 섬의 풍경을 모네 스타일의 드로잉으로 그린 그림",
    "요하네스 베르메르의 “진주 귀걸이를 한소녀” 작품을 해달로 표현",
    "헤드폰 디제잉을 하고 있는 미켈란젤로의 다비드 조각상 사진",
    "앤디 워홀 스타일의 선글라스를 쓴 프렌치 불독 그림",
  ];

  static const String dailyQuote = "오늘의\n 명언";
  static const String dailyWord = "오늘의\n 단어";

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
  static const String channelList = "채널 목록";
  static const String tooltipNoti = '알림이 있습니다';
  static const String tooltipNoNoti = '알림이 없습니다';
  static const String tooltipVolume = '작업하는 동안 소리를 끄거나 켭니다';
  static const String tooltipEdit = '화면 편집모드로 이동';
  static const String tooltipText = '텍스트 편집';
  static const String tooltipFrame = '프레임 생성';
  static const String tooltipNoneEdit = '화면 보기모드로 이동';
  static const String tooltipPause = '작업하는 동안 동영상을 정지하거나 플레이합니다';
  static const String tooltipUndo = '취소';
  static const String tooltipRedo = '복원';
  //static const String tooltipDownload = '다운로드';
  static const String tooltipInvite = '초대하기';
  static const String tooltipPlay = '미리보기';
  static const String tooltipScale = '항상 화면 크기에 알맞게 맞춥니다.';
  static const String tooltipDelete = '삭제하기';
  static const String tooltipMenu = '메뉴';
  static const String tooltipLink = '연결하기';

  static const String gotoCommunity = '커뮤니티로 이동';

  static const String newBook = '새 크레타북';
  static const String newPage = '새 페이지 추가';
  static const String newFrame = '새 프레임 추가';
  static const String treePage = '자세히 보기';
  static const String noNamepage = '이름없는 페이지';
  static const String noNameframe = '이름없는 프레임';
  static const String newText = '기본 텍스트';

  static const String textEditorToolbar = '텍스트 편집기 열기';
  static const String paragraphTemplate = '문단';
  static const String tableTemplate = '표';
  static const String listText = '';
  static const String defaultText = '샘플 텍스트 입니다.';

  static const String wide = "전체 페이지 보기";
  static const String usual = "원본 보기";
  static const String close = "닫기";
  static const String collapsed = "접기";
  static const String open = "열기";
  static const String hidden = "압정";

  static const String copy = "복사하기";
  static const String paste = "붙여넣기";
  static const String crop = "잘라내기";
  static const String copyStyle = "서식복사";
  static const String pasteStyle = "서식붙여넣기";
  static var showUnshow = "보이기/안보이기";
  static var show = "보이기";
  static var unshow = "안보이기";

  static const String description = "설명";
  static const String hashTab = "해시태그";
  static const String infomation = "정보";
  static const String pageSize = "페이지 크기";
  static const String frameSize = "프레임 기본 속성";
  static const String linkProp = "링크 기본 속성";
  static const String clickEvent = "클릭 이벤트";
  static const String bookBgColor = "전체 배경색";
  static const String pageBgColor = "페이지 배경색";
  static const String frameBgColor = "프레임 배경색";
  static const String onLine = "온라인";
  static const String offLine = "오프라인";
  static const String bookHistory = "발행이력";

  static const String updateDate = "마지막 수정 날짜";
  static const String createDate = "만든 날짜";
  static const String creator = "만든 사람";
  static const String copyRight = "저작권";
  static const String bookType = "크레타북 용도";
  static const String width = "너비";
  static const String height = "높이";
  static const String color = "색";
  static const String linkColor = "아이콘 색";
  static const String linkIconSize = "아이콘 크기";
  static const String opacity = "투명도";
  static const String angle = "각도";
  static const String radius = "모서리";
  static const String all = "전체";

  static const String basicColor = '기본색';
  static const String accentColor = '강조색';
  static const String customColor = '커스텀';
  static const String bwColor = '흑백';
  static const String bgColorCodeInput = '색상 코드로 입력';

  static const String glass = '유리질';
  static const String outlineWidth = '두께';
  static const String option = '옵션';
  static const String filter = '필터';
  static const String nofilter = '적용된 필터 없음             ';
  static const String excludeTag = '제외할 키워드 태그';
  static const String includeTag = '포함할 키워드 태그';
  static const String newfilter = '새 필터 만들기';
  static const String filterName = '필터 이름';
  static const String filterDelete = '필터 삭제';
  static const String filterHasNoName = '필터에 이름이 없습니다. 이름을 입력하십시오';
  static const String autoPlay = '자동 페이지 넘김';
  static const String allowReply = '좋아요/댓글 허용';
  static const String widthHeight = '(가로x세로)';
  static const String gradation = '그라데이션';

  static const String gradationTooltip = '투톤 칼러를 선택합니다';
  static const String colorTooltip = '기본색을 선택합니다';
  static const String textureTooltip = '질감을 선택합니다';
  static const String angleTooltip = '45도 회전합니다';
  static const String cornerTooltip = '각각의 코너 값을 다르게 설정합니다';
  static const String fullscreenTooltip = '페이지에 꽉차게 합니다';

  static const String transitionPage = "페이지 전환 효과";
  //static const String transitionFrame = "애니메이션";
  static const String effect = "배경효과";
  static const String contentFlipEffect = "콘텐츠 넘김 효과";

  static const String iconOption = "아이콘 선택";
  static const String googleMapSavedList = "저장돤 목록";

  static const String whenOpenPage = "나타날 때";
  static const String whenClosePage = "사라질 때";

  // 사라질때,
  static Map<String, int> pageTransitionType2 = {
    "없음": 0,
    "서서히 사라지기": 1, // AnimatedOpacity
    "점점 작아지기": 2, // AnimatedScale , ScaleTransition
    "좌우 슬라이딩": 3, // AnimatedPositioned , SlideTransition
    "상하 슬라이딩": 4, // AnimatedPositioned ,SlideTransition
  };
  // 나타날때,
  static Map<String, int> pageTransitionType = {
    "없음": 0,
    "서서히 나타나기": 1, // AnimatedOpacity
    "점점 커지기": 2, // AnimatedScale , ScaleTransition
    "좌우 슬라이딩": 3, // AnimatedPositioned , SlideTransition
    "상하 슬라이딩": 4, // AnimatedPositioned ,SlideTransition
  };

  static List<String> animationTypes = [
    "없음",
    "페이드 인",
    "플립",
    "흔들기",
    "흐려지기",
    "커지기",
    "회전",
    "좌우로 움직이기",
    "상하로 움직이기",
  ];

  static List<String> nextContentTypes = [
    "없음",
    "일반 캐로셀",
    "기울어진 캐로셀",
  ];

  static const String lastestFrame = "최근에 사용한 프레임";
  static const String poligonFrame = "도형 프레임";
  static const String animationFrame = "애니메이션 프레임";

  static const String lastestFrameError = "최근에 사용한 프레임이 없습니다.";
  static const String poligonFrameError = "준비된 도형 프레임이 없습니다.";
  static const String animationFrameError = "준비된 애니메이션 프레임이 없습니다.";

  static const String queryHintText = '플레이스 홀더';

  static const String recentUsedImage = '최근 사용한 이미지';
  static const String recommendedImage = '추천 이미지';
  static const String myImage = '내 이미지';

  static const String myUploadedImage = '내 파일 가져오기';
  static const String recentUploadedImage = '최근 가져온 이미지';

  static const String aiImageGeneration = '생성할 이미지';
  static const String aiGeneratedImage = '생성된 이미지';
  static const String imageStyle = '이미지 스타일';
  static const String genAIImage = '이미지 생성하기';
  static const String genImageAgain = '다시 생성하기';
  static const String genFromBeginning = '처음부터 시작';

  static const String genAIimageTooltip = '팁';
  static const String tipSearchExample = '크레타선+드로잉+모내스타일';

  static const String music = '뮤직 플레이어';
  static const String timer = '시계';
  static const String sticker = '스티커';
  static const String effects = '효과';
  static const String viewMore = '더보기';

  static const String genAIerrorMsg = '서버가 혼잡하여 현재 이용할 수 없습니다. \n잠시 후에 다시 시도해주세요. \n불편을 드려 죄송합니다.';

  static const String fixedRatio = "가로세로비를 고정합니다";
  static const String editFilter = "필터를 편집합니다";

  static const String secondColor = "혼합색";

  static const String texture = '질감';

  static const List<String> textureTypeList = [
    "솔리드",
    "유리",
    "대리석",
    "나무",
    "캔버스",
    "종이",
    "한지",
    "가죽",
    "돌",
    "잔디",
    "모래",
    "물방울",
  ];

  static const String posX = 'X좌표';
  static const String posY = 'Y좌표';

  static const String autoFitContents = '콘텐츠 크기에 자동 맞춤';
  static const String overlayFrame = '모든 페이지에서 고정';
  static const String noOverlayFrame = '모든 페이지에서 고정 해제';
  static const String overlayExclude = '이 페이지에서만 고정 해제';
  static const String noOverlayExclude = '이 페이지에서만 고정 해제 취소';
  static const String backgroundMusic = '백그라운드 뮤직으로 고정';
  static const String foregroundMusic = '백그라운 뮤직으로 고정 해제';

  static const String ani = '애니메이션';
  static const String flip = '좌우 반전';
  static const String speed = '속도';
  static const String transitionSpeed = '진행 시간(초)';
  static const String delay = '딜레이';
  static const String border = '테두리';
  static const String shadow = '그림자';
  static const String borderWidth = '두께';
  static const String glowingBorder = '글로우 효과';
  static const String offset = '방향거리';
  static const String direction = '방향각도';
  static const String spread = '크기';
  static const String blur = '흐림';
  static const String style = '스타일';
  static const String borderPosition = '외곽선 위치';
  static const String borderCap = '선 마감';
  //static const String shadowIn = '종류';
  static const String nothing = '없음';
  static const String noBorder = '테두리 없음';
  static const String fitting = '피팅';
  static const String custom = '사용자 정의';
  static const String playersize = '사이즈';

  // static Map<String, String> borderPositionList = {
  //   '경계 외부': 'outSide',
  //   '경계 내부': 'inSide',
  //   '경계 중앙': 'center',
  // };

  static Map<String, String> borderCapList = {
    '둥근': 'round',
    '각진': 'bevel',
    '뾰족한': 'miter',
  };
  static Map<String, String> fitList = {
    '맞추기': 'cover',
    '채우기': 'fill',
    '자유롭게': 'free',
  };

  static Map<String, String> playerSize = {
    '큰': 'Big',
    '중간': 'Medium',
    '작은': 'Small',
    '미니': 'Tiny',
  };

  static Map<String, String> newsSize = {
    '큰': 'Big',
    '중간': 'Medium',
    '작은': 'Small',
  };

  static String shape = "모양";

  static String eventSend = "발신 이벤트";
  static String eventReceived = "수신 이벤트";
  static String showWhenEventReceived = "이벤트를 받았을 때만 나타남";
  static String durationType = "닫힘 조건";
  static String durationSpecifiedTime = "다음 시간 후 닫힘";
  static String repeatOrOnce = "무한반복";
  static String repeatCount = "반복횟수";
  static String reverseMove = "반대로움직이기";

  static Map<String, String> durationTypeList = {
    '닫지 않음': 'forever',
    '콘텐츠가 끝날때': 'untilContentsEnd',
    '지정된 시간이 경과하면': 'specified',
  };

  static String copyFrameTooltip = '프레임 복사';
  static String deleteFrameTooltip = '프레임 삭제';
  static String frontFrameTooltip = '앞으로 당기기';
  static String backFrameTooltip = '뒤로 보내기';
  static String rotateFrameTooltip = '15도씩 회전합니다';
  static String linkFrameTooltip = '다른 프레임 콘텐츠에 연결합니다';
  static String mainFrameTooltip = '메인 프레임으로 지정합니다';

  static String flipConTooltip = '콘텐츠 플립';
  static String rotateConTooltip = '콘텐츠 회전';
  static String cropConTooltip = '콘텐츠 재단';
  static String fullscreenConTooltip = '콘텐츠를 프레임사이즈에 맞춤';
  static String deleteConTooltip = '콘텐츠 삭제';
  static String editConTooltip = '콘텐츠 편집';

  static String imageInfo = '이미지 정보';
  static String fileName = '파일명';
  static String contentyType = '콘텐츠타입';
  static String fileSize = '파일 크기';
  static String imageFilter = '이미지 필터';
  static String imageControl = '이미지 조정';
  static String linkControl = '링크 편집';
  static String linkControlOn = '링크 이동 모드';
  static String linkControlOff = '링크 이동 모드 해제';
  static String linkClass = '링크 내용';
  static String musicMutedControl = '음소거';
  static String musicPlayerSize = '뮤직 사미즈 기능';

  static const List<String> imageFilterTypeList = [
    "화사한",
    "따듯한",
    "밝은",
    "어두운",
    "차가운",
    "빈티지한",
    "로맨틱한",
    "차분한",
    "부드러운",
    "깨긋한",
    "우아한",
    "세피아",
  ];

  static const List<String> timelineShowcase = [
    "The simplest tile",
    "A centered tile with children",
    "Manual aligning the indicator",
    "Is it the first or the last?",
    "Start to make a timeline!",
    "Customize the indicator as you wish.",
    "Give an Icon to the indicator.",
    "Or provide your own custom indicator.",
    "Customize the tile's line.",
    "Connect tiles with TimelineDivider.",
  ];

  static String toFrameMenu = '프레임 메뉴로 전환';
  static String toContentsMenu = '콘텐츠 메뉴로 전환';

  static String playList = '플레이 리스트';
  static String showPlayList = '플레이 리스트 보기';

  // static Map<String, String> shadowInList = {
  //   '외부 그림자': 'outSide',
  //   '내부 그림자': 'inSide',
  // };

  static const String hugeText = '아주 큰 텍스트';
  static const String bigText = '큰 텍스트';
  static const String middleText = '중간 텍스트';
  static const String smallText = '작은 텍스트';
  static const String userDefineText = '사용자 정의';
  static const Map<String, double> textSizeMap = {
    hugeText: 64,
    bigText: 48,
    middleText: 36,
    smallText: 24,
    userDefineText: 40,
  };

  static const String autoFontSize = '프레임 크기에 텍스트 크기 조절 ';
  static const String autoFrameHeight = '텍스트 크기에 프레임 크기 조절 ';
  static const String noAutoSize = '자동 크기 조절 사용 안함 ';
  static const String tts = '음성으로 방송';
  static const String translate = '번역';

  static const String noUnshowPage = '볼 수 있는 페이지가 없습니다. 안보이기를 해제하세요';
  static const String inSideRotate = '상자 안에서 돌리기';

  static const String publishSettings = '발행 설정';
  static const List<String> publishSteps = [
    '정보 수정',
    '공개 범위',
    '채널 선택',
    '발행 완료',
  ];

  static const String publishTo = '공개할 사람';
  static const String publishingChannelList = '발행할 채널 목록';

  static const String wrongEmail = '올바른 이메일 포맷이 아니며, 해당하는 팀명이 없습니다.  이메일 주소 또는 팀명을 입력하세요';
  static const String noExitEmail = '등록된 사용자가 아닙니다. 자동 초대 기능은 아직 구현되지 않았습니다';

  static const String publishComplete = '발행이 완료되었습니다';
  static const String publishFailed = '발행이 실패하였습니다';
  static const String update = '수정';
  static const String newely = '신규';

  static const String showGrid = '그리드 보기';
  static const String showRuler = '눈금자 보기';
  static const String linkIntro = '연결할 페이지나 프레임을 선택하세요.';

  static String filterAlreadyExist = '같은 이름의 필터가 이미 존재합니다.';
  static String editFilterDialog = '필터 편집';

  static String invitedPeople = '초대된 사람들';
  static String invitedTeam = '초대된 팀들';

  static String tickerSide = '옆으로 흐르는 문자열';
  static String tickerUpDown = '상하로 흐르는 문자열';
  static String rotateText = 'Rotate Text';
  static String waveText = 'Wave Text';
  static String fidget = 'Fidget Text';
  static String shimmer = 'Shimmer Text';
  static String typewriter = 'Typewriter Text';
  static String wavy = 'Wavy Text';
  static String neon = 'Neon Text';
  static String fade = 'Fade Text';
  static String bounce = 'Bounce Text';
  static List<String> transition = [
    '랜덤 전환',
    '서서히 전환',
    '미끄러지듯 전환',
    '작아졌다 커지기 전환',
    '회전 전환',
    '안에서 밖으로 전환',
  ];

  static String weather = '날씨 위젯';
  static String clockandWatch = '시계와 스톱워치';
  static String camera = '카메라';
  static String map = '맵';
  static String date = '날짜';
  static String timeline = '타임라인';
  static String news = '뉴스';
  static String currencyXchange = '환율계산';
  static String dailyEnglish = '오늘 영어';

  static var onlineWeather = '날씨 온라인 연결';
  static String offLineWeather = "날씨 수동으로 선택";

  static String cityName = "현위치";
  static String temperature = "온도";
  static String humidity = "습도";
  static String wind = "풍향/풍속";
  static String pressure = "기압";
  static String uv = "자외선지수";
  static String visibility = "가시거리";
  static String microDust = "미세먼지";
  static String superMicroDust = "초미세먼지";
  static String realSize = "원래 사이즈로";
  static String maxSize = "최대 사이즈로";

  static String useThisThumbnail = "이 콘텐츠를 썸네일로 사용";

  static String putInDepot = "보관함에 넣기";
  static String putInDepotContents = "현재 콘텐츠만 보관함에 넣기";
  static String putInDepotFrame = "현재 프레임의 모든 콘텐츠 보관함에 넣기";

  static String putInMyDepot = "내 보관함에 넣기";
  static String putInTeamDepot = "팀 보관함에 넣기";

  static String letterSpacing = "자간";
  static String lineHeight = "행간";
  static String fontName = "폰트";
  static String fontSize = "폰트크기";
  static String iconSize = "아이콘크기";
  static String musicAudioControl = "소리 조정";
  static String musicVol = "소리 크기";

  static String depotComplete = "보관함으로 이동이 완료되었습니다";

  static String downloadConfirm = '''이 작업은 시간이 오래 걸릴 수 있습니다.
정말로 다운로드 하시겠습니까?''';
  static String noBtDnTextDeloper = "json파일만 받기";
  static String noBtDnText = "아니오";
  static String yesBtDnText = "네";
  static String export = "크레타 북 내보내기(Export)";
  static String inviteEmailFailed = "초대 이메일 발송이 실패했습니다";
  static String inviteEmailSucceed = "초대 이메일이 발송되었습니다";
  static String zipRequestFailed = "파일 다운로드 요청이 실패했습니다";
  static String zipCompleteFailed = "파일 압축 요청이 실패했습니다";
  static String zipStarting = "요청하신 파일의 압축작업을 진행하고 있습니다";
  static String fileDownloading = "요청하신 파일의 다운로드가 시작되었습니다";
  static String cretaInviteYou = "님이 당신을 크레타에 초대하였습니다";
  static String pressLinkToJoinCreta1 = "님이 당신을 크레타에 초대하였습니다. 아래의 링크를 눌러 크레타에 참여해 보세요. ";
  static String isSendEmail = "아직 가입되지 않은 이메일입니다. 초대 이메일을 보내시겠습니까?";
  //static String carouselWarning = '캐러셀 디스플레이를 적용하려면 최소 3개의 이미지가 있어야 합니다.';
  static String mainFrameExTooltip = '메인 프레임 입니다. 이 프레임의 콘텐츠가 끝나면 자동으로 다음페이지로 넘어갑니다.';
  static String deleteLink = '링크 삭제';

  static String textOverflow1 = '텍스트 길이 제한에 걸렸습니다';
  static String textOverflow2 = '글자 이내로 입력하세요요.';
  static String hashTagHint = '추가할 해쉬 태그를 입력하고 엔터키를 누르세요.';

  static String notImpl = '아직 구현되지 않았습니다.';
  static String isOverlayFrame = '이 프레임은 전체 페이지에 고정된 프레임입니다. 삭제하면 모든 페이지에서 이 프레임이 없어집니다';
  static String deleteConfirm = '정말로 삭제하시겠습니까?';

  static String gobackToStudio = 'Studio로 돌아가기';
}
