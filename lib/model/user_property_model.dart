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
  // late String phoneNumber;            // 연락처
  late String profileImg;             // 프로필 이미지 url
  late List<String> teamMembers;      // 팀원
  
  // late int country;                   // 국가
  // late int language;                  // 언어
  // late int job;                       // 직업

  // late bool useDigitalSignage;        // 디지털 사이니지 사용 여부
  // late bool isPublicProfile;          // 프로필 공개 여부  
  // late String channelBannerImg;       // 배경 이미지 url (채널 배너)
  // late bool usePushNotice;            // 푸시 알림 사용 여부
  // late bool useEmailNotice;           // 이메일 알림 사용 여부

  // late int themeStyle;                // 크레타 테마 (라이트모드, 다크 모드)
  // late int cretaInitPage;             // 크레타 처음 시작 페이지 (커뮤니티, 스튜디오)

  late CretaGrade cretaGrade;             // 크레타 등급
  late RatePlan ratePlan;               // 요금제 등급
  late int freeSpace;                 // 남은 용량

  late int bookCount;                 // 본인의 북 개수
  late int bookViewCount;             // 북 조회수
  late int bookViewTime;              // 북 시청 시간
  late int likeCount;                 // 좋아요 개수
  late int commentCount;              // 댓글 개수

  late String lastestBook;            // 마지막으로 편집한 크레타북의 아이디
  late List<String> lastestUseFrames; // 가장 최근에 사용한 프레임 7개
  late List<Color> lastestUseColors; // 가장 최근에 사용한 색깔 7개

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        nickname,
        profileImg,
        teamMembers,
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
      ];

  UserPropertyModel(String pmid) : super(pmid: pmid, type: ExModelType.user, parent: '') {
    email = '';
    nickname = '';
    profileImg = '';
    teamMembers = [];
    cretaGrade = CretaGrade.none;
    ratePlan = RatePlan.none;
    freeSpace = 0;
    bookCount = 0;
    bookViewCount = 0;
    bookViewTime = 0;
    likeCount = 0;
    commentCount = 0;
    lastestBook = '';
    lastestUseFrames = [];
    lastestUseColors = [];
  }

  UserPropertyModel.withName({
    required this.email,
    required String pparentMid,
    this.nickname = '',
    this.profileImg = '',
    this.teamMembers = const [],
    this.cretaGrade = CretaGrade.none,
    this.ratePlan = RatePlan.none,
    this.freeSpace = 0,
    this.bookCount = 0,
    this.bookViewCount = 0,
    this.bookViewTime = 0,
    this.likeCount = 0,
    this.commentCount = 0,
    this.lastestBook = '',
    this.lastestUseColors = const [],
    this.lastestUseFrames = const [],
  }) : super(pmid: '', type: ExModelType.user, parent: pparentMid);

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    UserPropertyModel srcUser = src as UserPropertyModel;
    email = srcUser.email;
    nickname = srcUser.nickname;
    profileImg = srcUser.profileImg;
    teamMembers = [...srcUser.teamMembers];
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
    logger.finest('UserCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    email = map["email"] ?? '';
    nickname = map["nickname"];
    profileImg = map["profileImg"];
    teamMembers = CretaUtils.jsonStringToList(map["teamMembers"]);
    cretaGrade = CretaGrade.fromInt(map["cretaGrade"] ?? 1);
    ratePlan = RatePlan.fromInt(map["ratePlan"] ?? 0);
    freeSpace = map["freeSpace"];
    bookCount = map["bookCount"];
    bookViewCount = map["bookViewCount"];
    bookViewTime = map["bookViewTime"];
    likeCount = map["likeCount"];
    commentCount = map["commentCount"];
    lastestBook = map["lastestBook"];
    lastestUseColors = CretaUtils.string2ColorList(map["lastestUseColors"]);
    lastestUseFrames = CretaUtils.jsonStringToList(map["lastestUseFrames"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "email": email,
        "nickname": nickname,
        "profileImg": profileImg,
        "teamMembers": CretaUtils.listToString(teamMembers),
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
      }.entries);
  }
}
