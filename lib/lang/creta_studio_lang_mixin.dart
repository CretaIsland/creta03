import 'package:flutter/material.dart';

mixin CretaStudioLangMixin {
  Map<String, String> pageSizeMapPresentation = {
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

  List<String> pageSizeListSignage = [
    "사용자지정",
    "4:3 스크린",
    "16:10 스크린",
    "16:9 스크린",
    "21:9 스크린",
    "32:9 스크린",
  ];

  List<String> pageSizeListBarricade = [
    "사용자지정",
    "3장",
    "1장",
    "2장",
    "4장",
    "5장",
  ];

  List<String> copyWrightList = [
    "None",
    "자유로운 사용 가능",
    "비상업적인 목적으로만 사용 가능",
    "출처를 공개한 경우에 한해 사용 가능",
    "허가 없이 사용 불가",
    "End",
  ];

  //  List<String> bookTypeList = [
  //   "None",
  //   "프리젠테이션용",
  //   "디지털사이니지용",
  //   "디지털바리케이트용"
  //       "전자칠판용",
  //   "기타",
  //   "End",
  // ];

  Map<String, String> bookInfoTabBar = {
    '크레타북 정보': 'book_info',
    '크레타북 설정': 'book_settings',
    '편집자 권한': 'authority',
    '발행 이력': 'history',
  };

  Map<String, String> frameTabBar = {
    '프레임 설정': 'frameTab',
    '콘텐츠 설정': 'contentsTab',
    '링크 설정': 'linkTab',
  };

  Map<String, String> textMenuTabBar = {
    '텍스트 추가': 'add_text',
    '워드 패드': 'word_pad',
    '특수 문자': 'special_char',
  };

  Map<String, String> imageMenuTabBar = {
    '이미지': 'image',
    '가져오기': 'upload_image',
    'AI 생성': 'AI_generated_image',
    'GIPHY의 GIF': 'GIPHY_image',
  };

  Map<String, String> storageTypes = {
    '전체': 'all',
    '이미지': 'image',
    '영상': 'video',
    // 'CretaTest': 'test',
  };

  Map<String, String> widgetTypes = {
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

  Map<String, String> newsCategories = {
    '일반': 'general',
    '사업': 'business',
    '연예': 'entertainment',
    '헬스': 'health',
    '과학': 'science',
    '스포츠': 'sports',
    '기술': 'technology',
  };

  List<String> menuStick = [
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

  List<String> firstCurrency = [
    "USD",
    "GBP",
    "JPY",
    "EUR",
    "CNY",
    "VND",
  ];

  List<String> secondCurrency = [
    "KRW",
    "KRW",
    "KRW",
    "KRW",
    "KRW",
    "KRW",
  ];

  List<IconData> menuIconList = [
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

  List<String> frameKind = [
    //"전체",
    "16:9 가로형",
    "16:9 세로형",
    "4:3 가로형",
    "4:3 세로형",
    "16:10 가로형",
    "16:10 세로형",
    "사용자정의",
  ];

  List<String> colorTypes = [
    //"전체",
    "단색",
    "그라데이션",
  ];

  List<String> imageStyleList = [
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

  List<String> tipMessage = [
    "아래에 예제와 같이 생성하고자 하는 문구를 자세하게 입력합니다.",
    "원하는 예술가의 스타일을 입력하여 이미지를 생성할 수 있습니다."
  ];

  List<String> detailTipMessage1 = [
    "파란색 배경, 디지털 아트로 어항에 있는 귀여운 열대어의 3D 렌더링",
    "성운의 폭발로 묘사된 농구 선수의 덩크를 유화로 표현",
    "타임스퀘어에서 스케이트보드를 타는 테디베어의 사진",
    "우주선 안의 뾰루퉁한 고양이를 오일 파스텔로 그린 작품",
  ];

  List<String> detailTipMessage2 = [
    "크레타 섬의 풍경을 모네 스타일의 드로잉으로 그린 그림",
    "요하네스 베르메르의 “진주 귀걸이를 한소녀” 작품을 해달로 표현",
    "헤드폰 디제잉을 하고 있는 미켈란젤로의 다비드 조각상 사진",
    "앤디 워홀 스타일의 선글라스를 쓴 프렌치 불독 그림",
  ];

  String dailyQuote = "오늘의\n 명언";
  String dailyWord = "오늘의\n 단어";

  String myCretaBook = "내 크레타북";
  String sharedCretaBook = "공유 크레타북";
  String teamCretaBook = "팀북";
  String trashCan = "휴지통";

  String myCretaBookDesc = " 님의 크레타북 입니다";
  String sharedCretaBookDesc = " 님이 공유받은 크레타북입니다";
  String teamCretaBookDesc = " 팀의 크레타북 입니다";

  String latelyUsedFrame = "최근 사용한 프레임";

  String autoScale = "자동맞춤";

  String publish = "발행하기";
  String channelList = "채널 목록";
  String tooltipNoti = '알림이 있습니다';
  String tooltipNoNoti = '알림이 없습니다';
  String tooltipVolume = '작업하는 동안 소리를 끄거나 켭니다';
  String tooltipEdit = '화면 편집모드로 이동';
  String tooltipText = '텍스트 편집';
  String tooltipFrame = '프레임 생성';
  String tooltipNoneEdit = '화면 보기모드로 이동';
  String tooltipPause = '작업하는 동안 동영상을 정지하거나 플레이합니다';
  String tooltipUndo = '취소';
  String tooltipRedo = '복원';
  //  String tooltipDownload = '다운로드';
  String tooltipInvite = '초대하기';
  String tooltipPlay = '미리보기';
  String tooltipScale = '항상 화면 크기에 알맞게 맞춥니다.';
  String tooltipDelete = '삭제하기';
  String tooltipApply = '사용하기';
  String tooltipMenu = '메뉴';
  String tooltipLink = '연결하기';

  String gotoCommunity = '커뮤니티로 이동';

  String newBook = '새 크레타북';
  String newPage = '새 페이지 추가';
  String newTemplate = '현재 페이지를 템플릿으로 저장';
  String newFrame = '새 프레임 추가';
  String treePage = '자세히 보기';
  String newText = '기본 텍스트';

  String templateCreating = '템플릿을 생성중입니다...';
  String templateCreated = '새로운 템플릿이 저장되었습니다.';
  String templateUpdated = '템플릿이 업데이트 되었습니다.';
  String inputTemplateName = '템플릿의 이름을 넣어주세요';
  String templateName = '템플릿 이름';

  String textEditorToolbar = '텍스트 편집기 열기';
  String paragraphTemplate = '문단';
  String tableTemplate = '표';
  String listText = '';
  String defaultText = '샘플 텍스트 입니다.';

  String wide = "전체 페이지 보기";
  String usual = "원본 보기";
  String close = "닫기";
  String collapsed = "접기";
  String open = "열기";
  String hidden = "압정";

  String copy = "복사하기";
  String paste = "붙여넣기";
  String crop = "잘라내기";
  String copyStyle = "서식복사";
  String pasteStyle = "서식붙여넣기";
  var showUnshow = "보이기/안보이기";
  var show = "보이기";
  var unshow = "안보이기";

  String description = "설명";
  String hashTab = "해시태그";
  String infomation = "정보";
  String pageSize = "페이지 크기";
  String frameSize = "프레임 기본 속성";
  String linkProp = "링크 기본 속성";
  String clickEvent = "클릭 이벤트";
  String bookBgColor = "전체 배경색";
  String pageBgColor = "페이지 배경색";
  String frameBgColor = "프레임 배경색";
  String onLine = "온라인";
  String offLine = "오프라인";
  String bookHistory = "발행이력";

  String updateDate = "마지막 수정 날짜";
  String createDate = "만든 날짜";
  String creator = "만든 사람";
  String copyRight = "저작권";
  String bookType = "크레타북 용도";
  String width = "너비";
  String height = "높이";
  String color = "색";
  String linkColor = "아이콘 색";
  String linkIconSize = "아이콘 크기";
  String opacity = "투명도";
  String angle = "각도";
  String radius = "모서리";
  String all = "전체";

  String basicColor = '기본색';
  String accentColor = '강조색';
  String customColor = '커스텀';
  String bwColor = '흑백';
  String bgColorCodeInput = '색상 코드로 입력';

  String glass = '유리질';
  String outlineWidth = '두께';
  String option = '옵션';
  String filter = '필터';
  String nofilter = '적용된 필터 없음             ';
  String excludeTag = '제외할 키워드 태그';
  String includeTag = '포함할 키워드 태그';
  String newfilter = '새 필터 만들기';
  String filterName = '필터 이름';
  String filterDelete = '필터 삭제';
  String filterHasNoName = '필터에 이름이 없습니다. 이름을 입력하십시오';
  String autoPlay = '자동 페이지 넘김';
  String allowReply = '좋아요/댓글 허용';
  String widthHeight = '(가로x세로)';
  String gradation = '그라데이션';

  String gradationTooltip = '투톤 칼러를 선택합니다';
  String colorTooltip = '기본색을 선택합니다';
  String textureTooltip = '질감을 선택합니다';
  String angleTooltip = '45도 회전합니다';
  String cornerTooltip = '각각의 코너 값을 다르게 설정합니다';
  String fullscreenTooltip = '페이지에 꽉차게 합니다';

  String transitionPage = "페이지 전환 효과";
  //  String transitionFrame = "애니메이션";
  String effect = "배경효과";
  String contentFlipEffect = "콘텐츠 넘김 효과";

  String iconOption = "아이콘 선택";
  String googleMapSavedList = "저장돤 목록";

  String whenOpenPage = "나타날 때";
  String whenClosePage = "사라질 때";

  // 사라질때,
  List<String> nextContentTypes = [
    "없음",
    "일반 캐로셀",
    "기울어진 캐로셀",
  ];

  String lastestFrame = "최근에 사용한 프레임";
  String poligonFrame = "도형 프레임";
  String animationFrame = "애니메이션 프레임";

  String lastestFrameError = "최근에 사용한 프레임이 없습니다.";
  String poligonFrameError = "준비된 도형 프레임이 없습니다.";
  String animationFrameError = "준비된 애니메이션 프레임이 없습니다.";

  String queryHintText = '플레이스 홀더';

  String recentUsedImage = '최근 사용한 이미지';
  String recommendedImage = '추천 이미지';
  String myImage = '내 이미지';

  String myUploadedImage = '내 파일 가져오기';
  String recentUploadedImage = '최근 가져온 이미지';

  String aiImageGeneration = '생성할 이미지';
  String aiGeneratedImage = '생성된 이미지';
  String imageStyle = '이미지 스타일';
  String genAIImage = '이미지 생성하기';
  String genImageAgain = '다시 생성하기';
  String genFromBeginning = '처음부터 시작';

  String genAIimageTooltip = '팁';
  String tipSearchExample = '크레타선+드로잉+모내스타일';

  String music = '뮤직 플레이어';
  String timer = '시계';
  String sticker = '스티커';
  String effects = '효과';
  String viewMore = '더보기';

  String genAIerrorMsg = '서버가 혼잡하여 현재 이용할 수 없습니다. \n잠시 후에 다시 시도해주세요. \n불편을 드려 죄송합니다.';

  String fixedRatio = "가로세로비를 고정합니다";
  String editFilter = "필터를 편집합니다";

  String secondColor = "혼합색";

  String texture = '질감';

  List<String> textureTypeList = [
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

  String posX = 'X좌표';
  String posY = 'Y좌표';

  String autoFitContents = '콘텐츠 크기에 자동 맞춤';
  String overlayFrame = '모든 페이지에서 고정';
  String noOverlayFrame = '모든 페이지에서 고정 해제';
  String overlayExclude = '이 페이지에서만 고정 해제';
  String noOverlayExclude = '이 페이지에서만 고정 해제 취소';
  String backgroundMusic = '백그라운드 뮤직으로 고정';
  String foregroundMusic = '백그라운 뮤직으로 고정 해제';

  String ani = '애니메이션';
  String flip = '좌우 반전';
  String speed = '속도';
  String transitionSpeed = '진행 시간(초)';
  String delay = '딜레이';
  String border = '테두리';
  String shadow = '그림자';
  String borderWidth = '두께';
  String glowingBorder = '글로우 효과';
  String offset = '방향거리';
  String direction = '방향각도';
  String spread = '크기';
  String blur = '흐림';
  String style = '스타일';
  String borderPosition = '외곽선 위치';
  String borderCap = '선 마감';
  //  String shadowIn = '종류';
  String nothing = '없음';
  String noBorder = '테두리 없음';
  String fitting = '피팅';
  String custom = '사용자 정의';
  String playersize = '사이즈';

  //  Map<String, String> borderPositionList = {
  //   '경계 외부': 'outSide',
  //   '경계 내부': 'inSide',
  //   '경계 중앙': 'center',
  // };

  Map<String, String> borderCapList = {
    '둥근': 'round',
    '각진': 'bevel',
    '뾰족한': 'miter',
  };
  Map<String, String> fitList = {
    '맞추기': 'cover',
    '채우기': 'fill',
    '자유롭게': 'free',
  };

  Map<String, String> playerSize = {
    '큰': 'Big',
    '중간': 'Medium',
    '작은': 'Small',
    '미니': 'Tiny',
  };

  Map<String, String> newsSize = {
    '큰': 'Big',
    '중간': 'Medium',
    '작은': 'Small',
  };

  String shape = "모양";

  String eventSend = "발신 이벤트";
  String eventReceived = "수신 이벤트";
  String showWhenEventReceived = "이벤트를 받았을 때만 나타남";
  String durationType = "닫힘 조건";
  String durationSpecifiedTime = "다음 시간 후 닫힘";
  String repeatOrOnce = "무한반복";
  String repeatCount = "반복횟수";
  String reverseMove = "반대로움직이기";

  Map<String, String> durationTypeList = {
    '닫지 않음': 'forever',
    '콘텐츠가 끝날때': 'untilContentsEnd',
    '지정된 시간이 경과하면': 'specified',
  };

  String copyFrameTooltip = '프레임 복사';
  String deleteFrameTooltip = '프레임 삭제';
  String frontFrameTooltip = '앞으로 당기기';
  String backFrameTooltip = '뒤로 보내기';
  String rotateFrameTooltip = '15도씩 회전합니다';
  String linkFrameTooltip = '다른 프레임 콘텐츠에 연결합니다';
  String mainFrameTooltip = '메인 프레임으로 지정합니다';

  String flipConTooltip = '콘텐츠 플립';
  String rotateConTooltip = '콘텐츠 회전';
  String cropConTooltip = '콘텐츠 재단';
  String fullscreenConTooltip = '콘텐츠를 프레임사이즈에 맞춤';
  String deleteConTooltip = '콘텐츠 삭제';
  String editConTooltip = '콘텐츠 편집';

  String imageInfo = '이미지 정보';
  String fileName = '파일명';
  String contentyType = '콘텐츠타입';
  String fileSize = '파일 크기';
  String imageFilter = '이미지 필터';
  String imageControl = '이미지 조정';
  String linkControl = '링크 편집';
  String linkControlOn = '링크 이동 모드';
  String linkControlOff = '링크 이동 모드 해제';
  String linkClass = '링크 내용';
  String musicMutedControl = '음소거';
  String musicPlayerSize = '뮤직 사미즈 기능';

  List<String> imageFilterTypeList = [
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

  List<String> timelineShowcase = [
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

  String toFrameMenu = '프레임 메뉴로 전환';
  String toContentsMenu = '콘텐츠 메뉴로 전환';

  String playList = '플레이 리스트';
  String showPlayList = '플레이 리스트 보기';

  //  Map<String, String> shadowInList = {
  //   '외부 그림자': 'outSide',
  //   '내부 그림자': 'inSide',
  // };

  String hugeText = '아주 큰 텍스트';
  String bigText = '큰 텍스트';
  String middleText = '중간 텍스트';
  String smallText = '작은 텍스트';
  String userDefineText = '사용자 정의';

  Map<String, double> textSizeMap = {
    // hugeText: 64,
    // bigText: 48,
    // middleText: 36,
    // smallText: 24,
    // userDefineText: 40,
  };

  String noAutoSize = '자동 크기 조절 사용 안함 ';
  String tts = '음성으로 방송';
  String translate = '번역';

  String noUnshowPage = '볼 수 있는 페이지가 없습니다. 안보이기를 해제하세요';
  String inSideRotate = '상자 안에서 돌리기';

  String publishSettings = '발행 설정';
  List<String> publishSteps = [
    '정보 수정',
    '공개 범위',
    '채널 선택',
    '발행 완료',
  ];

  String publishTo = '공개할 사람';
  String publishingChannelList = '발행할 채널 목록';

  String wrongEmail = '올바른 이메일 포맷이 아니며, 해당하는 팀명이 없습니다.  이메일 주소 또는 팀명을 입력하세요';
  String noExitEmail = '등록된 사용자가 아닙니다. 자동 초대 기능은 아직 구현되지 않았습니다';

  String publishComplete = '발행이 완료되었습니다';
  String publishFailed = '발행이 실패하였습니다';
  String update = '수정';
  String newely = '신규';

  String showGrid = '그리드 보기';
  String showRuler = '눈금자 보기';
  String linkIntro = '연결할 페이지나 프레임을 선택하세요.';

  String filterAlreadyExist = '같은 이름의 필터가 이미 존재합니다.';
  String editFilterDialog = '필터 편집';

  String invitedPeople = '초대된 사람들';
  String invitedTeam = '초대된 팀들';

  String tickerSide = '옆으로 흐르는 문자열';
  String tickerUpDown = '상하로 흐르는 문자열';
  String rotateText = 'Rotate Text';
  String waveText = 'Wave Text';
  String fidget = 'Fidget Text';
  String shimmer = 'Shimmer Text';
  String typewriter = 'Typewriter Text';
  String wavy = 'Wavy Text';
  String neon = 'Neon Text';
  String fade = 'Fade Text';
  String bounce = 'Bounce Text';
  List<String> transition = [
    '랜덤 전환',
    '서서히 전환',
    '미끄러지듯 전환',
    '작아졌다 커지기 전환',
    '회전 전환',
    '안에서 밖으로 전환',
  ];

  String weather = '날씨 위젯';
  String clockandWatch = '시계와 스톱워치';
  String camera = '카메라';
  String map = '맵';
  String date = '날짜';
  String timeline = '타임라인';
  String news = '뉴스';
  String currencyXchange = '환율계산';
  String dailyEnglish = '오늘 영어';

  var onlineWeather = '날씨 온라인 연결';
  String offLineWeather = "날씨 수동으로 선택";

  String cityName = "현위치";
  String temperature = "온도";
  String humidity = "습도";
  String wind = "풍향/풍속";
  String pressure = "기압";
  String uv = "자외선지수";
  String visibility = "가시거리";
  String microDust = "미세먼지";
  String superMicroDust = "초미세먼지";
  String realSize = "원래 사이즈로";
  String maxSize = "최대 사이즈로";

  String useThisThumbnail = "이 콘텐츠를 썸네일로 사용";

  String putInDepot = "보관함에 넣기";
  String putInDepotContents = "현재 콘텐츠만 보관함에 넣기";
  String putInDepotFrame = "현재 프레임의 모든 콘텐츠 보관함에 넣기";

  String putInMyDepot = "내 보관함에 넣기";
  String putInTeamDepot = "팀 보관함에 넣기";

  String letterSpacing = "자간";
  String lineHeight = "행간";
  String fontName = "폰트";
  String fontSize = "폰트크기";
  String iconSize = "아이콘크기";
  String musicAudioControl = "소리 조정";
  String musicVol = "소리 크기";

  String depotComplete = "보관함으로 이동이 완료되었습니다";

  String downloadConfirm = '''이 작업은 시간이 오래 걸릴 수 있습니다.
정말로 다운로드 하시겠습니까?''';
  String noBtDnTextDeloper = "json파일만 받기";
  String noBtDnText = "아니오";
  String yesBtDnText = "네";
  String export = "크레타 북 내보내기(Export)";
  String inviteEmailFailed = "초대 이메일 발송이 실패했습니다";
  String inviteEmailSucceed = "초대 이메일이 발송되었습니다";
  String zipRequestFailed = "파일 다운로드 요청이 실패했습니다";
  String zipCompleteFailed = "파일 압축 요청이 실패했습니다";
  String zipStarting = "요청하신 파일의 압축작업을 진행하고 있습니다";
  String fileDownloading = "요청하신 파일의 다운로드가 시작되었습니다";
  String cretaInviteYou = "님이 당신을 크레타에 초대하였습니다";
  String pressLinkToJoinCreta1 = "님이 당신을 크레타에 초대하였습니다. 아래의 링크를 눌러 크레타에 참여해 보세요. ";
  String isSendEmail = "아직 가입되지 않은 이메일입니다. 초대 이메일을 보내시겠습니까?";
  // String carouselWarning = '캐러셀 디스플레이를 적용하려면 최소 3개의 이미지가 있어야 합니다.';
  String mainFrameExTooltip = '메인 프레임 입니다. 이 프레임의 콘텐츠가 끝나면 자동으로 다음페이지로 넘어갑니다.';
  String deleteLink = '링크 삭제';

  String textOverflow1 = '텍스트 길이 제한에 걸렸습니다';
  String textOverflow2 = '글자 이내로 입력하세요요.';
  String hashTagHint = '추가할 해쉬 태그를 입력하고 엔터키를 누르세요.';

  String notImpl = '아직 구현되지 않았습니다.';
  String isOverlayFrame = '이 프레임은 전체 페이지에 고정된 프레임입니다. 삭제하면 모든 페이지에서 이 프레임이 없어집니다';
  String deleteConfirm = '정말로 삭제하시겠습니까?';

  String gobackToStudio = 'Studio로 돌아가기';

  String myTemplate = '나의 템플릿';
  String sharedTemplate = '공용 템플릿';
  String saveAsSharedTemplate = '공용 템플릿으로 저장';

  String startDate = '시작 일자';
  String startTime = '시작 시간';
  String endDate = '종료 일자';
  String endTime = '종료 시간';
  String timeBasePage = '시간 지정';
  String useTimeBasePage = '시간 지정 사용';
}
