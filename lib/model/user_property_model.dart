// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:creta03/model/app_enums.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../common/creta_utils.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class UserPropertyModel extends CretaModel {
  
  late String email;                  // 이메일
  late String nickname;               // 닉네임
  late String phoneNumber;            // 연락처
  late String profileImg;             // 프로필 이미지 url
  late List<String> teams;            // 속한 팀 리스트
  
  late CountryType country;           // 국가
  late LanguageType language;         // 언어
  late JobType job;                   // 직업

  late bool useDigitalSignage;        // 디지털 사이니지 사용 여부
  late bool isPublicProfile;          // 프로필 공개 여부  
  late String channelBannerImg;       // 배경 이미지 url (채널 배너)
  late bool usePushNotice;            // 푸시 알림 사용 여부
  late bool useEmailNotice;           // 이메일 알림 사용 여부

  late ThemeType themeStyle;          // 크레타 테마 (라이트모드, 다크 모드)
  late InitPageType cretaInitPage;    // 크레타 처음 시작 페이지 (커뮤니티, 스튜디오)
  late CookieType cookie;             // 쿠키 설정

  late CretaGradeType cretaGrade;     // 크레타 등급
  late RatePlanType ratePlan;         // 요금제 등급
  late int freeSpace;                 // 남은 용량

  late int bookCount;                 // 본인의 북 개수
  late int bookViewCount;             // 북 조회수
  late int bookViewTime;              // 북 시청 시간
  late int likeCount;                 // 좋아요 개수
  late int commentCount;              // 댓글 개수

  late String lastestBook;            // 마지막으로 편집한 크레타북의 아이디
  late List<String> lastestUseFrames; // 가장 최근에 사용한 프레임 7개
  late List<Color> lastestUseColors;  // 가장 최근에 사용한 색깔 7개

  late bool autoPlay;                 // 크레타 북 내 콘텐츠 자동 재생 여부
  late bool mute;                     // 크레타 북 내 콘텐츠 음소거 여부 

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        nickname,
        phoneNumber,
        profileImg,
        teams,
        country,
        language,
        job,
        useDigitalSignage,
        isPublicProfile,
        channelBannerImg,
        usePushNotice,
        useEmailNotice,
        themeStyle,
        cretaInitPage,
        cookie,
        cretaGrade,
        ratePlan,
        freeSpace,
        bookCount,
        bookViewCount,
        bookViewTime,
        likeCount,
        commentCount,
        lastestBook,
        lastestUseFrames,
        lastestUseColors,
        autoPlay,
        mute
      ];

  UserPropertyModel(String pmid) : super(pmid: pmid, type: ExModelType.user, parent: '') {
    email = '';
    nickname = '';
    phoneNumber = '';
    profileImg = '';
    teams = [];
    country = CountryType.none;
    language = LanguageType.none;
    job = JobType.none;
    useDigitalSignage = false;
    isPublicProfile = true;
    channelBannerImg = '';
    usePushNotice = false;
    useEmailNotice = false;
    themeStyle = ThemeType.none;
    cretaInitPage = InitPageType.none;
    cookie = CookieType.none;
    cretaGrade = CretaGradeType.none;
    ratePlan = RatePlanType.none;
    freeSpace = 0;
    bookCount = 0;
    bookViewCount = 0;
    bookViewTime = 0;
    likeCount = 0;
    commentCount = 0;
    lastestBook = '';
    lastestUseFrames = [];
    lastestUseColors = [];
    autoPlay = true;
    mute = false;
  }

  UserPropertyModel.withName({
    required this.email,
    required String pparentMid,
    this.nickname = '',
    this.phoneNumber = '',
    this.profileImg = '',
    this.teams = const [],
    this.country = CountryType.none,
    this.language = LanguageType.none,
    this.job = JobType.none,
    this.useDigitalSignage = false,
    this.isPublicProfile = true,
    this.channelBannerImg = '',
    this.usePushNotice = false,
    this.useEmailNotice = false,
    this.themeStyle = ThemeType.none,
    this.cretaInitPage = InitPageType.none,
    this.cookie = CookieType.none,
    this.cretaGrade = CretaGradeType.none,
    this.ratePlan = RatePlanType.none,
    this.freeSpace = 0,
    this.bookCount = 0,
    this.bookViewCount = 0,
    this.bookViewTime = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.lastestBook = '',
    this.lastestUseColors = const [],
    this.lastestUseFrames = const [],
    this.autoPlay = true,
    this.mute = false
  }) : super(pmid: '', type: ExModelType.user, parent: pparentMid);

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    UserPropertyModel srcUser = src as UserPropertyModel;
    email = srcUser.email;
    nickname = srcUser.nickname;
    phoneNumber = srcUser.phoneNumber;
    profileImg = srcUser.profileImg;
    teams = [...srcUser.teams];
    country = srcUser.country;
    language = srcUser.language;
    job = srcUser.job;
    useDigitalSignage = srcUser.useDigitalSignage;
    isPublicProfile = srcUser.isPublicProfile;
    channelBannerImg = srcUser.channelBannerImg;
    usePushNotice = srcUser.usePushNotice;
    useEmailNotice = srcUser.useEmailNotice;
    themeStyle = srcUser.themeStyle;
    cretaInitPage = srcUser.cretaInitPage;
    cookie = srcUser.cookie;
    cretaGrade = srcUser.cretaGrade;
    ratePlan = srcUser.ratePlan;
    freeSpace = srcUser.freeSpace;
    bookCount = srcUser.bookCount;
    bookViewCount = srcUser.bookViewCount;
    bookViewTime = srcUser.bookViewTime;
    likeCount = srcUser.likeCount;
    commentCount = srcUser.commentCount;
    lastestBook = srcUser.lastestBook;
    lastestUseColors = [...srcUser.lastestUseColors];
    lastestUseFrames = [...srcUser.lastestUseFrames];
    autoPlay = srcUser.autoPlay;
    mute = srcUser.mute;
    logger.finest('UserCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    email = map["email"] ?? '';
    nickname = map["nickname"] ?? '';
    phoneNumber = map["phoneNumber"] ?? '';
    profileImg = map["profileImg"] ?? '';
    teams = CretaUtils.jsonStringToList(map["teams"] ?? "[]");
    country = CountryType.fromInt(map["country"] ?? 0);
    language = LanguageType.fromInt(map["language"] ?? 0);
    job = JobType.fromInt(map["job"] ?? 0);
    useDigitalSignage = map["useDigitalSignage"] ?? false;
    isPublicProfile = map["isPublicProfile"] ?? true;
    channelBannerImg = map["channelBannerImg"] ?? '';
    usePushNotice = map["usePushNotice"] ?? false;
    useEmailNotice = map["useEmailNotice"] ?? false;
    themeStyle = ThemeType.fromInt(map["themeStyle"] ?? 0);
    cretaInitPage = InitPageType.fromInt(map["cretaInitPage"] ?? 0);
    cookie = CookieType.fromInt(map["cookie"] ?? 0);
    cretaGrade = CretaGradeType.fromInt(map["cretaGrade"] ?? 0);
    ratePlan = RatePlanType.fromInt(map["ratePlan"] ?? 0);
    freeSpace = map["freeSpace"] ?? 0;
    bookCount = map["bookCount"] ?? 0;
    bookViewCount = map["bookViewCount"] ?? 0;
    bookViewTime = map["bookViewTime"] ?? 0;
    likeCount = map["likeCount"] ?? 0;
    commentCount = map["commentCount"] ?? 0;
    lastestBook = map["lastestBook"] ?? '';
    lastestUseColors = CretaUtils.string2ColorList(map["lastestUseColors"] ?? "[]");
    lastestUseFrames = CretaUtils.jsonStringToList(map["lastestUseFrames"] ?? "[]");
    autoPlay = map["autoPlay"] ?? true;
    mute = map["mute"] ?? false;
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "email": email,
        "nickname": nickname,
        "phoneNumber" : phoneNumber,
        "profileImg": profileImg,
        "teams": CretaUtils.listToString(teams),
        "country": country.index,
        "language": language.index,
        "job": job.index,
        "useDigitalSignage" : useDigitalSignage,
        "isPublicProfile" : isPublicProfile,
        "channelBannerImg" : channelBannerImg,
        "usePushNotice" : usePushNotice,
        "useEmailNotice" : useEmailNotice,
        "themeStyle" : themeStyle.index,
        "cretaInitPage" : cretaInitPage.index,
        "cookie" : cookie.index,
        "cretaGrade": cretaGrade.index,
        "ratePlan": ratePlan.index,
        "freeSpace": freeSpace,
        "bookCount": bookCount,
        "bookViewCount": bookViewCount,
        "bookViewTime": bookViewTime,
        "likeCount": likeCount,
        "commentCount": commentCount,
        "lastestBook": lastestBook,
        "lastestUseColors": CretaUtils.colorList2String(lastestUseColors),
        "lastestUseFrames": CretaUtils.listToString(lastestUseFrames),
        "autoPlay" : autoPlay,
        "mute" : mute
      }.entries);
  }
}
