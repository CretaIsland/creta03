import 'package:creta03/common/creta_utils.dart';
import 'package:creta03/model/creta_model.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class TeamModel extends CretaModel {
  late String name;
  late String profileImg;
  late String channelBannerImg;
  late bool isPublicProfile;

  late String owner;
  late List<String> managers;
  late List<String> generalMembers;
  late List<String> removedMembers;
  late List<String> teamMembers;

  late String channelId;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        profileImg,
        channelBannerImg,
        isPublicProfile,
        owner,
        managers,
        generalMembers,
        removedMembers,
        teamMembers,
        channelId,
      ];

  TeamModel(String pmid) : super(pmid: pmid, type: ExModelType.team, parent: '') {
    name = '';
    profileImg = '';
    channelBannerImg = '';
    isPublicProfile = true;
    owner = '';
    managers = [];
    generalMembers = [];
    removedMembers = [];
    teamMembers = [];
    channelId = '';
  }

  TeamModel.withName({
    required this.name,
    required this.owner,
    this.profileImg = '',
    this.channelBannerImg = '',
    this.isPublicProfile = true,
    this.managers = const [],
    this.generalMembers = const [],
    this.removedMembers = const [],
    this.channelId = '',
  }) : super(pmid: '', type: ExModelType.team, parent: '') {
    if (managers.contains(owner)) {
      teamMembers = [...managers, ...generalMembers];
    } else {
      teamMembers = [owner, ...managers, ...generalMembers];
    }
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    profileImg = map['profileImg'] ?? '';
    channelBannerImg = map['channelBannerImg'] ?? '';
    isPublicProfile = map['isPublicProfile'] ?? true;
    owner = map['owner'] ?? '';
    managers = CretaUtils.jsonStringToList(map['managers'] ?? '[]');
    generalMembers = CretaUtils.jsonStringToList(map['generalMembers'] ?? '[]');
    removedMembers = CretaUtils.jsonStringToList(map['removedMembers'] ?? '[]');
    teamMembers = List<String>.from(map['teamMembers'] ?? "[]" as List);
    channelId = map['channelId'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'profileImg': profileImg,
        'channelBannerImg': channelBannerImg,
        'isPublicProfile': isPublicProfile,
        'owner': owner,
        'managers': CretaUtils.listToString(managers),
        'generalMembers': CretaUtils.listToString(generalMembers),
        'removedMembers': CretaUtils.listToString(removedMembers),
        'teamMembers': teamMembers,
        'channelId': channelId,
      }.entries);
  }
}
