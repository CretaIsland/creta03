mixin CretaMyPageLangMixin {
  // 좌측 메뉴
  String dashboard = '대시보드';
  String info = '개인 정보';
  String accountManage = '계정 관리';
  String settings = '알림과 설정';
  String teamManage = '팀 관리';

  // 대시보드
  String accountInfo = '계정 정보';
  String grade = '등급';
  String bookCount = '북 개수';
  String ratePlan = '요금제';
  String freeSpace = '남은 용량';

  String recentSummary = '최근 요약';
  String bookViewCount = '북 조회수';
  String bookViewTime = '북 시청시간';
  String likeCount = '좋아요 개수';
  String commentCount = '댓글 개수';

  String myTeam = '내 팀';

  String ratePlanChangeBTN = '요금제 전환';

  // 개인 정보
  String profileImage = '사진';
  String nickname = '닉네임';
  String nicknameInput = '닉네임을 입력해주세요.';
  String email = '이메일';
  String phoneNumber = '연락처';
  String password = '비밀번호';
  String country = '국가';
  String language = '언어';
  String job = '직업';

  String save = "변경사항 저장";

  List<String> countryList = ['대한민국', '미국', '일본', '중국', '베트남', '프랑스', '독일'];

  List<String> languageList = [
    '한국어',
    'English',
    '日本語',
    '中文',
    'Tiếng Việt',
    'français',
    'Deutsche',
  ];

  List<String> jobList = ['일반', '학생', '선생님', '디자이너', '개발자'];

  String basicProfileImgBTN = '기본 이미지로 변경';
  String passwordChangeBTN = '비밀번호 변경';
  String saveChangeBTN = '변경사항 저장';

  // 계정 관리
  String purposeSetting = '용도 설정';
  String usePresentation = '프레젠테이션 기능 사용하기';
  String useDigitalSignage = '디지털 사이니지 기능 사용하기';
  String useDigitalBarricade = '디지털 바리케이드 기능 사용하기';
  String useBoard = '전자칠판 기능 사용하기';

  String ratePlanTip = '팀 요금제를 사용해보세요!';

  String channelSetting = '채널 설정';
  String publicProfile = '프로필 공개';
  String profileTip = '모든 사람들에게 프로필이 공개됩니다.';
  String backgroundImgSetting = '배경 이미지 설정';

  String allDeviceLogout = '모든 기기에서 로그아웃';
  String removeAccount = '계정 탈퇴';

  String selectImgBTN = '이미지 선택';
  String logoutBTN = '로그아웃';
  String removeAccountBTN = '계정 탈퇴';

  // 알림과 설정
  String myNotice = '내 알림';
  String pushNotice = '푸시 알림';
  String emailNotice = '이메일 알림';

  String mySetting = '내 설정';
  String theme = '테마';
  String themeTip = '내 기기에서 크레타의 모습을 바꿔보세요.';
  String initPage = '시작 페이지';
  String initPageTip = '크레타를 시작할 때 표시할 페이지를 선택하세요.';
  String cookieSetting = '쿠키 설정';
  String cookieSettingTip = '쿠키를 설정하세요.';

  List<String> themeList = ['라이트 모드', '다크 모드'];
  List<String> initPageList = ['커뮤니티', '스튜디오'];
  List<String> cookieList = ['쿠키 허용', '쿠키 거부'];

  // 팀 관리
  String teamInfo = '팀 정보';
  String teamName = '팀 이름';
  String teamChannel = '팀 채널';
  String backgroundImg = '배경 이미지';
  String teamMemberManage = '팀원 관리';
  String inviteablePeopleNumber = '초대 가능 인원';
  String teamExit = '팀에서 나가기';
  String deleteTeam = '팀 삭제';

  String throwBTN = '내보내기';
  String addMemberBTN = '팀원 추가';
  String exitBTN = '나가기';
  String deleteTeamBTN = '팀 삭제';

  // 크레타 등급
  List<String> cretaGradeList = ['크레타 루키', '크레타 스타', '크레타 셀럽'];

  // 요금제 등급
  List<String> ratePlanList = ['개인 무료', '개인 유료', '팀 유료', '엔터프라이즈'];

  // 팀 등급
  List<String> teamPermissionList = ['소유자', '관리자', '팀원'];

  String teamnameInput = '팀 이름을 입력해주세요.';
  String openChannel = '채널 공개';
  String  openChannelForEverybody = '모든 사람들에게 채널이 공개됩니다.';
  String  openTeamChannel = '팀 채널에 팀원의 채널이 공개됩니다.';
  String  openTeamMember = '팀원 공개';

  String     introChannel = '채널 소개';

}
