// // ignore_for_file: prefer_const_constructors
//
// import 'package:flutter/material.dart';
// //import 'package:creta03/model/connected_user_model.dart';
// //import 'package:flutter/cupertino.dart';
//
// //import '../../lang/creta_studio_lang.dart';
// //import 'package:creta_studio_model/model/book_model.dart';
// //import 'package:creta_studio_model/model/page_model.dart';
//
// class CommunitySampleData {
//   static int _randomIndex = 2;
//   static const String bannerUrl = 'https://picsum.photos/200/?random=1';
//   static GlobalKey bannerKey = GlobalKey();
//
//   static List<CretaBookData> getCretaBookList() {
//     return _sampleCretaBookList.map((item) {
//       CretaBookData clone = CretaBookData.clone(item);
//       clone.thumbnailUrl = 'https://picsum.photos/200/?random=$_randomIndex';
//       _randomIndex++;
//       return clone;
//     }).toList();
//   }
//
//   static List<CretaPlaylistData> getCretaPlaylistList() {
//     return _sampleCretaPlaylistList.map((item) {
//       CretaPlaylistData clone = CretaPlaylistData.clone(item);
//       _randomIndex++;
//       return clone;
//     }).toList();
//   }
//
//   static List<CretaCommentData> getCretaCommentList() {
//     return _sampleCretaCommentList.map((item) {
//       CretaCommentData clone = CretaCommentData.clone(item);
//       _randomIndex++;
//       return clone;
//     }).toList();
//   }
//
//   static final DateTime _bookDate1 = DateTime.now().subtract(Duration(days: 1));
//   static final DateTime _bookDate2 = DateTime.now().subtract(Duration(days: 7));
//   static final DateTime _bookDate3 = DateTime.now().subtract(Duration(days: 32));
//
//   static final List<CretaBookData> _sampleCretaBookList = [
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '크레타북 01', //'NewJeans (뉴진스) ' 'Ditto' ' Official MV (side B)',
//       creator: '사용자 닉네임', //'HYBE LABELS',
//       totalPageCount: 5,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: 'NCT DREAM 엔시티 드림 ' 'Candy' ' MV',
//       creator: 'SMTOWN',
//       favorites: true,
//       totalPageCount: 12,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: 'ICBM 대기권 재진입 "뿔난 北 내년에 감행할 것" [김어준의 뉴스공장 풀영상 12/22(목)]',
//       creator: 'TBS 시민의방송',
//       totalPageCount: 8,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '스트레스, 피로, 우울, 부정, 부정적인 감정의 해독을위한 치유 음악',
//       creator: 'Lucid Dream',
//       totalPageCount: 21,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '크리스마스 음악 2023, 크리스마스 캐롤, 천상의 크리스마스 음악, 편안한 음악, 크리스마스 분위기',
//       creator: 'Piano Musica',
//       totalPageCount: 4,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '한국 분식을 처음 먹어본 영국 축구선수들의 반응!?',
//       creator: '영국남자 Korean Englishman',
//       totalPageCount: 3,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '18년 장수게임 카트라이더 서비스 종료 이야기',
//       creator: '김성회의 G식백과',
//       totalPageCount: 17,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[아이유의 팔레트🎨] 내 마음속 영원히 맑은 하늘 (With god) Ep.17',
//       creator: '이지금 [IU Official]',
//       totalPageCount: 22,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[내 몸 보고서] 소리 없이 다가오는 실명의 위험, 녹내장 / YTN 사이언스',
//       creator: 'YTN 사이언스',
//       totalPageCount: 3,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '인류의 우주에 대한 시각을 완전히 바꿔버린 그 사건, 안드로메다는 사실 ' '이것' '이다?',
//       creator: '리뷰엉이: Owl' 's Review',
//       totalPageCount: 28,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[님아 그 시장을 가오_EP. 18_속초] “사장님 국수는 어디 갔어요?” 국수 찾는 데 한참 걸렸습니다! 회 먹다 식사 끝나는 희한한 회국수집!',
//       creator: '백종원 PAIK JONG WON',
//       totalPageCount: 45,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '철학은 어떻게 반복되는가? 에피쿠로스와 소크라테스의 철학 분석! 움베르토 에코 [경이로운 철학의 역사] 2부',
//       creator: '일당백 : 일생동안 읽어야 할 백권의 책',
//       totalPageCount: 2,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '지구인이 중력이 낮은 행성으로 차원 이동하면 벌어지는 일 [영화리뷰/결말포함]',
//       creator: '리뷰 MASTER',
//       totalPageCount: 11,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '그래서 어떤 커피가 맛있나요? 내돈내산 음식이야기 2탄! | 커피, 원두, 역사',
//       creator: '김지윤의 지식Play',
//       totalPageCount: 23,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '윤하(YOUNHA) - 사건의 지평선 M/V',
//       creator: 'YOUNHA OFFICIAL',
//       totalPageCount: 34,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[#스트리트푸드파이터] 러시아와 중국의 오묘한 조화가 이루어지는 하얼빈 요리! 백종원도 현지 가야만 맛볼 수 있는 꿔바로우가 최초로 탄생한 식당 | #편집자는',
//       creator: '디글 :Diggle',
//       totalPageCount: 4,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '충청·호남에 또 큰 눈‥모레까지 최고 30cm - [LIVE] MBC 930뉴스 2022년 12월 22일',
//       creator: 'MBCNEWS',
//       totalPageCount: 19,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[#티전드] 고기 건더기 없이도 맛있게! 중화요리 대가 이연복의 비건 짬뽕&짜장요리🍜 | #현지에서먹힐까',
//       creator: 'tvN D ENT',
//       totalPageCount: 25,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '누칼협? 중꺾마? 2022년 올해의 단어들',
//       creator: '슈카월드',
//       totalPageCount: 24,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '아바타2 물의 길 보기 직전 총정리 [아바타: 물의 길]',
//       creator: 'B Man 삐맨',
//       totalPageCount: 10,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '현재 넷플릭스 세계 1위, 전세계 동심파괴 중인 천재 감독의 어른용 ' '피노키오' '',
//       creator: '무비콕콕',
//       totalPageCount: 43,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[이알뉴] 윤대통령 "거버먼트 인게이지먼트가 레귤레이션"..관저 제설 용산구 예산 써 (류밀희)[김어준의 뉴스공장]',
//       creator: 'TBS 시민의방송',
//       totalPageCount: 23,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '컴퓨터 출장 AS 수리 사기 당했습니다...',
//       creator: '뻘짓연구소',
//       totalPageCount: 28,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '땅 팔고 공장 문 닫고‥ 기업들은 이미 찬바람 (2022.12.21/뉴스데스크/MBC)',
//       creator: 'MBCNEWS',
//       totalPageCount: 5,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '급하게 먹지말라고 했더니 개빡친 강아지 ㅋㅋㅋ',
//       creator: '솜이네 곰이탱이여우',
//       totalPageCount: 7,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[백 투 더 퓨처 3] 실수와 숨겨진 디테일 24가지',
//       creator: '영사관',
//       totalPageCount: 15,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[LIVE] 대한민국 24시간 뉴스채널 YTN',
//       creator: 'YTN',
//       totalPageCount: 31,
//       createDate: _bookDate3,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '[뉴스외전 Zoom人] "밟혀주겠다, 꺾이진 않는다" (2022.12.20/뉴스외전/MBC)',
//       creator: 'MBCNEWS',
//       totalPageCount: 18,
//       createDate: _bookDate1,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '3D펜으로 가짜츄르를 만들면 핥을까?',
//       creator: '사나고 Sanago',
//       totalPageCount: 3,
//       createDate: _bookDate2,
//     ),
//     CretaBookData(
//       thumbnailUrl: '',
//       name: '역 승강장에 서서 먹는 일본의 국수문화',
//       creator: '유우키의 일본이야기 YUUKI',
//       totalPageCount: 6,
//       createDate: _bookDate3,
//     ),
//   ];
//
//   static final List<CretaPlaylistData> _sampleCretaPlaylistList = [
//     CretaPlaylistData(
//       title: '재생목록 01',
//       locked: false,
//       userNickname: '사용자 닉네임',
//       lastUpdatedTime: DateTime.now(),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '당신이 몰랐던 유튜브의 기능 TOP14',
//       locked: false,
//       userNickname: '스토리',
//       lastUpdatedTime: DateTime.now(),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '한국 좀비사태 발생시 필요한 현실능력 월드컵',
//       locked: true,
//       userNickname: '침착맨',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 1)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '💀 미국은 왜 센티미터를 안 쓰고 인치를 쓸까? / 💀 도량형의 통일',
//       locked: false,
//       userNickname: '지식해적단',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: 'F는 이래서 안돼',
//       locked: false,
//       userNickname: '빠더너스 BDNS',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '[#고독한미식가] ' '추운 겨울하면 떠오르는 대표적인 이 메뉴!' '',
//       locked: false,
//       userNickname: '도라마코리아',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '세계에서 가장 추운 곳으로 가다 (-71°C) 야쿠츠크/야쿠티아',
//       locked: false,
//       userNickname: 'Ruhi Çenet 한국어',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '시신도 못 찾은 ' '자살' ' 사건...9년 만에 드러난 충격 반전 / KBS 2023.01.11.',
//       locked: false,
//       userNickname: 'KBS News',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '15분간 옛이야기 듣듯 정리하는 ' '고려 역사 500년' '',
//       locked: false,
//       userNickname: '쏨작가의지식사전',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '화산이 폭발하면 주변 동물들은 어떻게 될까? 백두산이 폭발하면 우리나라는? / 최재천의 아마존',
//       locked: false,
//       userNickname: '최재천의 아마존',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//     CretaPlaylistData(
//       title: '리트리버에게 냉장고를 열어줬더니 똑똑한 행동을 해요ㅋㅋㅋ',
//       locked: false,
//       userNickname: '소녀의행성 Girlsplanet',
//       lastUpdatedTime: DateTime.now().subtract(const Duration(days: 7)),
//       cretaBookDataList: [],
//     ),
//   ];
//
//   static final String _commentMid1 = GlobalKey().toString();
//   static final String _commentMid2 = GlobalKey().toString();
//   static final String _commentMid3 = GlobalKey().toString();
//
//   static final List<CretaCommentData> _sampleCretaCommentList = [
//     CretaCommentData(
//       mid: _commentMid1,
//       nickname: '쿠릉쿠릉',
//       creator: '쿠릉쿠릉',
//       comment: '공직사회에서도 정착 못 시킨걸 민간기업에 하겠다는게 참 대단한듯',
//       dateTime: DateTime.now().subtract(Duration(days: 4)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'ㅇㄹㅇㄷ',
//       creator: 'ㅇㄹㅇㄷ',
//       comment: 'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ',
//       dateTime: DateTime.now().subtract(Duration(days: 4)),
//       parentMid: _commentMid1,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '설',
//       creator: '설',
//       comment: '내 일을 남이 대신 해주지 못한다는 가장 큰 문제를 안 말한게 아쉽네요',
//       dateTime: DateTime.now().subtract(Duration(days: 4)),
//       parentMid: _commentMid1,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '젝다니엘',
//       creator: '젝다니엘',
//       comment: 'ㄹㅇ ㅋㅋㅋ',
//       dateTime: DateTime.now().subtract(Duration(days: 4)),
//       parentMid: _commentMid1,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '가온',
//       creator: '가온',
//       comment: '공직사회는 프로젝트 급의 일이 많지 않고 꾸준히 적정량을 처리해야 하는 일이 많으니 그런거죠',
//       dateTime: DateTime.now().subtract(Duration(days: 4)),
//       parentMid: _commentMid1,
//     ),
//
//     CretaCommentData(
//       mid: _commentMid2,
//       nickname: 'Hakarov Anderi',
//       creator: 'Hakarov Anderi',
//       comment: '영상 끝부분에서 생산성을 높이는 방법을 근면함으로 해결하려한다는 말에 감탄이 나오네요. 영상 잘봤습니다.',
//       dateTime: DateTime.now().subtract(Duration(days: 5)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'IN J',
//       creator: 'IN J',
//       comment: '근면함 말고 뭐가 있을까요.. 높은 임금이나 추가 수당이 있을까요.. 가뜩이나 52시간 때문에 소득 줄어든 사람들은 오히려 생산성을 떨어뜨려 추가수당까지 다 받아 가려 하지 않을까요',
//       dateTime: DateTime.now().subtract(Duration(days: 5)),
//       parentMid: _commentMid2,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'K Moon',
//       creator: 'K Moon',
//       comment: '대안없는 불평 발견!',
//       dateTime: DateTime.now().subtract(Duration(days: 5)),
//       parentMid: _commentMid2,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'IN J',
//       creator: 'IN J',
//       comment: '정작 이제도가 필요한 생산직은 일하고 있고 컴터 앞에서 일보는 사무직들만 댓글 다는거같네..',
//       dateTime: DateTime.now().subtract(Duration(days: 5)),
//       parentMid: _commentMid2,
//     ),
//
//     CretaCommentData(
//       mid: _commentMid3,
//       nickname: '어억',
//       creator: '어억',
//       comment: '사실 가장 큰 문제는  52시간에서 69시간으로 규제를 완화하게 되었을때 적절한 보상이 이루어지지 않는다는 겁니다. 12시간만 할 수 있는 야근도 포괄임금제 때문에 휴가든 수당이든 안 줬는데 2주동안 25시간씩 야근해도 결국 포괄임금제 때문에 휴가든 수당이든 안준다는겁니다. 포괄임금제 개선이 선행되지 않는다면 보상없는 야근만 늘려주는 제도라는 겁니다.',
//       dateTime: DateTime.now().subtract(Duration(days: 6)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '어억',
//       creator: '어억',
//       comment: '2012년 부터 일했는데 2018년에 40시간+12시간 으로 바꼈을 때의 행복감을 잊을 수 없습니다. 당연한 야근이 사라질 정도였어요. 제발 역사를 거꾸로 가지 맙시다.',
//       dateTime: DateTime.now().subtract(Duration(days: 7)),
//       parentMid: _commentMid3,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '꾸옹영원',
//       creator: '꾸옹영원',
//       comment: '진짜 이번 정책 들이민 사람들은 책임을 져야함',
//       dateTime: DateTime.now().subtract(Duration(days: 8)),
//       parentMid: _commentMid3,
//     ),
//
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'Live Line',
//       creator: 'Live Line',
//       comment: '이런 주제를 가져와주신것에 대해 감사드려요',
//       dateTime: DateTime.now().subtract(Duration(days: 9)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: '월영',
//       creator: '월영',
//       comment: '사실 아직 대학생인지라 이게 뭐 때문에 난리인지를 몰랐는데 알고리즘에 떠서 이렇게 쉽게 정리해주시니 감사할 따름입니다.',
//       dateTime: DateTime.now().subtract(Duration(days: 29)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'Skim On West',
//       creator: 'Skim On West',
//       comment: '미국은 연장근로 제한은 없어도 추가 근무에 대해 시간당 1.5-2배 씩 돈을 더 줘야해서 회사가 알아서 최소한으로 일하게하는 것 같습니다.',
//       dateTime: DateTime.now().subtract(Duration(days: 30)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'A J',
//       creator: 'A J',
//       comment: '솔직하게 모두가 정직해져야 합니다.\n\n근로자는 출퇴근 초과근무를 정직하게 작성하고\n사업자는 근무시간에 맞게 급여를 지급하여야 하고\n\n정직이 사회 제일의 규범이 되어야 한다고 봅니다\n정직한 사회를 망치는 사기꾼과 경제사범에 강력한 처벌이 필요하구요',
//       dateTime: DateTime.now().subtract(Duration(days: 31)),
//       //parentMid: null,
//     ),
//     CretaCommentData(
//       mid: GlobalKey().toString(),
//       nickname: 'ksc-591',
//       creator: 'ksc-591',
//       comment: '뭔가 회사 생활을 안해본 사람들이 만든 정책 같군요',
//       dateTime: DateTime.now().subtract(Duration(days: 32)),
//       //parentMid: null,
//     ),
//   ];
// }
//
// class CretaBookData {
//   CretaBookData({
//     required this.name,
//     required this.creator,
//     required this.thumbnailUrl,
//     required this.totalPageCount,
//     required this.createDate,
//     this.favorites = false,
//   });
//   CretaBookData.clone(CretaBookData src)
//       : this(
//     name: src.name,
//     creator: src.creator,
//     thumbnailUrl: src.thumbnailUrl,
//     totalPageCount: src.totalPageCount,
//     createDate: src.createDate,
//     favorites: src.favorites,
//   );
//
//   final GlobalKey uiKey = GlobalKey();
//   final GlobalKey uiKeyEx = GlobalKey();
//   final GlobalKey imgKey = GlobalKey();
//   String name;
//   String creator;
//   String thumbnailUrl;
//   DateTime createDate;
//   int totalPageCount;
//   bool favorites;
// }
//
// class CretaPlaylistData {
//   CretaPlaylistData({
//     required this.title,
//     required this.locked,
//     required this.userNickname,
//     //required this.userId,
//     required this.lastUpdatedTime,
//     this.cretaBookDataList = const [],
//   });
//   CretaPlaylistData.clone(CretaPlaylistData src)
//       : this(
//     title: src.title,
//     locked: src.locked,
//     userNickname: src.userNickname,
//     //userId: src.userId,
//     lastUpdatedTime: src.lastUpdatedTime,
//     cretaBookDataList: CommunitySampleData.getCretaBookList(),
//   );
//
//   final GlobalKey uiKey = GlobalKey();
//   String title;
//   bool locked;
//   String userNickname;
//   //String userId;
//   DateTime lastUpdatedTime;
//   List<CretaBookData> cretaBookDataList;
// }
//
// enum CretaCommentBarType {
//   addCommentMode,
//   modifyCommentMode,
//   addReplyMode,
// }
//
// class CretaCommentData {
//   CretaCommentData({
//     required this.mid,
//     required this.nickname,
//     required this.creator,
//     required this.comment,
//     required this.dateTime,
//     this.parentMid = '',
//     this.barType = CretaCommentBarType.modifyCommentMode,
//     this.showReplyList = false,
//   });
//   CretaCommentData.clone(CretaCommentData src)
//       : this(
//     mid: src.mid,
//     nickname: src.nickname,
//     creator: src.creator,
//     comment: src.comment,
//     dateTime: src.dateTime,
//     parentMid: src.parentMid,
//   );
//
//   final String mid;
//   final String nickname;
//   final String creator;
//   String comment;
//   DateTime dateTime;
//   final String parentMid;
//   // below-items is not copied in clone()
//   CretaCommentBarType barType;
//   bool showReplyList;
//   List<CretaCommentData> replyList = [];
//
//   bool get hasReply => replyList.isNotEmpty;
//   bool get hasNoReply => replyList.isEmpty;
// }
