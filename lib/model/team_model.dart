// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:creta03/common/creta_utils.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class TeamModel extends CretaModel {

  late String name;                 // 팀의 이름
  late String profileImg;           // 팀 프로필 사진
  late String channelBannerImg;     // 팀 채널 배너 사진
  late String owner;                // 팀 요금제를 가입한 사람
  late List<String> managers;       // owner가 manager로 지정한 사람들 
  late List<String> generalMembers;  // 일반 멤버
  late bool isPublicProfile;        // 팀 채널 공개 여부
  late List<String> teamMembers;    // manager, member, owner 모든 value를 통합한 List (where 검색을 위한 필드)

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        profileImg,
        channelBannerImg,
        owner,
        managers,
        generalMembers,
        isPublicProfile,
        teamMembers
      ];

  TeamModel(String pmid) : super(pmid: pmid, type: ExModelType.team, parent: '') {
    name = '';
    profileImg = '';
    channelBannerImg = '';
    owner = '';
    managers = [];
    generalMembers = [];
    isPublicProfile = true;
    teamMembers = [];
  }

  TeamModel.withName({
    required this.name,
    required this.owner,
    this.profileImg = '',
    this.channelBannerImg = '',
    this.managers = const [],
    this.generalMembers = const [],
    this.isPublicProfile = true
  }) : super(pmid: '', type: ExModelType.team, parent: '') {
    teamMembers = [owner, ...managers, ...generalMembers];
  }

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    TeamModel srcTeam = src as TeamModel;
    name = srcTeam.name;
    profileImg = srcTeam.profileImg;
    channelBannerImg = srcTeam.channelBannerImg;
    owner = srcTeam.owner;
    managers = [...srcTeam.managers];
    generalMembers = [...srcTeam.generalMembers];
    isPublicProfile = srcTeam.isPublicProfile;
    teamMembers = [srcTeam.owner, ...srcTeam.managers, ...srcTeam.generalMembers];
    logger.finest('TeamCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map["name"] ?? '';
    profileImg = map["profileImg"];
    channelBannerImg = map["channelBannerImg"];
    owner = map["owner"] ?? '';
    managers = CretaUtils.jsonStringToList(map["managers"]);
    generalMembers = CretaUtils.jsonStringToList(map["generalMembers"]);
    isPublicProfile = map["isPublicProfile"];
    teamMembers = List<String>.from(map["teamMembers"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name,
        "profileImg" : profileImg,
        "channelBannerImg" : channelBannerImg,
        "owner" : owner,
        "managers" : CretaUtils.listToString(managers),
        "generalMembers" : CretaUtils.listToString(generalMembers),
        "isPublicProfile" : isPublicProfile,
        "teamMembers" : teamMembers
      }.entries);
  }
}
