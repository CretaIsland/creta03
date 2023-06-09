import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/model/creta_model.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class UserPropertyModel extends CretaModel {
  late String email;
  late String nickname;
  late String phoneNumber;

  late CretaGradeType cretaGrade;
  late RatePlanType ratePlan;

  late String profileImg;
  late String channelBannerImg;

  late CountryType country;
  late LanguageType language;
  late JobType job;

  late int freeSpace;
  late int bookCount;
  late int bookViewCount;
  late int bookViewTime;
  late int likeCount;
  late int commentCount;

  late bool useDigitalSignage;
  late bool usePushNotice;
  late bool useEmailNotice;
  late bool isPublicProfile;
  late ThemeType theme;
  late InitPageType initPage;
  late CookieType cookie;

  late bool autoPlay;
  late bool mute;
  late String latestBook;
  late List<String> latestUseFrames;
  late List<Color> latestUseColors;

  late List<String> teams;
  late String enterprise;

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        nickname,
        phoneNumber,
        profileImg,
        channelBannerImg,
        freeSpace,
        bookCount,
        bookViewCount,
        bookViewTime,
        likeCount,
        commentCount,
        useDigitalSignage,
        usePushNotice,
        useEmailNotice,
        isPublicProfile,
        theme,
        initPage,
        cookie,
        autoPlay,
        mute,
        latestBook,
        latestUseFrames,
        latestUseColors,
        teams,
        enterprise
      ];

  UserPropertyModel(String pmid) : super(pmid: pmid, type: ExModelType.user, parent: '') {
    email = '';
    nickname = '';
    phoneNumber = '';
    cretaGrade = CretaGradeType.none;
    ratePlan = RatePlanType.none;
    profileImg = '';
    channelBannerImg = '';
    country = CountryType.none;
    language = LanguageType.none;
    job = JobType.none;
    freeSpace = 0;
    bookCount = 0;
    bookViewCount = 0;
    bookViewTime = 0;
    likeCount = 0;
    commentCount = 0;
    useDigitalSignage = false;
    usePushNotice = false;
    useEmailNotice = false;
    isPublicProfile = true;
    theme = ThemeType.none;
    initPage = InitPageType.none;
    cookie = CookieType.none;
    autoPlay = true;
    mute = false;
    latestBook = '';
    latestUseFrames = [];
    latestUseColors = [];
    teams = [];
    enterprise = '';
  }

  UserPropertyModel.withName(
      {required this.email,
      required String pparentMid,
      this.nickname = '',
      this.phoneNumber = '',
      this.cretaGrade = CretaGradeType.none,
      this.ratePlan = RatePlanType.none,
      this.profileImg = '',
      this.channelBannerImg = '',
      this.country = CountryType.none,
      this.language = LanguageType.none,
      this.job = JobType.none,
      this.freeSpace = 0,
      this.bookCount = 0,
      this.bookViewCount = 0,
      this.bookViewTime = 0,
      this.likeCount = 0,
      this.commentCount = 0,
      this.useDigitalSignage = false,
      this.usePushNotice = false,
      this.useEmailNotice = false,
      this.isPublicProfile = true,
      this.theme = ThemeType.none,
      this.initPage = InitPageType.none,
      this.cookie = CookieType.none,
      this.autoPlay = true,
      this.mute = false,
      this.latestBook = '',
      this.latestUseFrames = const [],
      this.latestUseColors = const [],
      this.teams = const [],
      this.enterprise = ''
      })
      : super(pmid: '', type: ExModelType.user, parent: pparentMid);

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);

    email = map['email'] ?? '';
    nickname = map['nickname'] ?? '';
    phoneNumber = map['phoneNumber'] ?? '';
    cretaGrade = CretaGradeType.fromInt(map['cretaGrade'] ?? 0);
    ratePlan = RatePlanType.fromInt(map['ratePlan'] ?? 0);
    profileImg = map['profileImg'] ?? '';
    channelBannerImg = map['channelBannerImg'] ?? '';
    country = CountryType.fromInt(map['country'] ?? 0);
    language = LanguageType.fromInt(map['language'] ?? 0);
    job = JobType.fromInt(map['job'] ?? 0);
    freeSpace = map['freeSpace'] ?? 0;
    bookCount = map['bookCount'] ?? 0;
    bookViewCount = map['bookViewCount'] ?? 0;
    bookViewTime = map['bookViewTime'] ?? 0;
    likeCount = map['likeCount'] ?? 0;
    commentCount = map['commentCount'] ?? 0;
    useDigitalSignage = map['useDigitalSignage'] ?? false;
    usePushNotice = map['usePushNotice'] ?? false;
    useEmailNotice = map['useEmailNotice'] ?? false;
    isPublicProfile = map['isPublicProfile'] ?? true;
    theme = ThemeType.fromInt(map['theme'] ?? 0);
    initPage = InitPageType.fromInt(map['initPage'] ?? 0);
    cookie = CookieType.fromInt(map['cookie'] ?? 0);
    autoPlay = map['autoPlay'] ?? true;
    mute = map['mute'] ?? false;
    latestBook = map['latestBook'] ?? '';
    latestUseFrames = CretaUtils.jsonStringToList(map["latestUseFrames"] ?? "[]");
    latestUseColors = CretaUtils.string2ColorList(map["lastestUseColors"] ?? "[]");
    //teams = CretaUtils.jsonStringToMapList(map["teams"] ?? "[]") as List<Map<String, String>>;
    //teams = List<String>.from(map['teams'] ?? "[]" as List);
    //teams = List<String>.from(map['teams'] ?? "[]" as List);
    teams = CretaUtils.dynamicListToStringList(map["teams"]);
    enterprise = map['enterprise'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'email': email,
        'nickname': nickname,
        'phoneNumber': phoneNumber,
        'cretaGrade': cretaGrade.index,
        'ratePlan': ratePlan.index,
        'profileImg': profileImg,
        'channelBannerImg': channelBannerImg,
        'country': country.index,
        'language': language.index,
        'job': job.index,
        'freeSpace': freeSpace,
        'bookCount': bookCount,
        'bookViewCount': bookViewCount,
        'bookViewTime': bookViewTime,
        'likeCount': likeCount,
        'commentCount': commentCount,
        'useDigitalSignage': useDigitalSignage,
        'usePushNotice': usePushNotice,
        'useEmailNotice': useEmailNotice,
        'isPublicProfile': isPublicProfile,
        'theme': theme.index,
        'initPage': initPage.index,
        'cookie': cookie.index,
        'autoPlay': autoPlay,
        'mute': mute,
        'latestBook': latestBook,
        'latestUseFrames': CretaUtils.listToString(latestUseFrames),
        'latestUseColors': CretaUtils.colorList2String(latestUseColors),
        // 'teams' : CretaUtils.mapListToString(teams)
        'teams': teams,
        'enterprise' : enterprise
      }.entries);
  }
}
