import 'package:creta_common/common/creta_common_utils.dart';
import 'package:creta_common/model/creta_model.dart';
import 'package:creta_user_model/model/user_property_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'package:hycop/hycop/utils/hycop_utils.dart';

// ignore: must_be_immutable
class EnterpriseModel extends CretaModel {
  late String name;
  late String imageUrl;
  late String enterpriseUrl;
  late String description;
  late String openAiKey;
  late String openWeatherApiKey;
  late String giphyApiKey;
  late String newsApiKey;
  late String dailyWordApi;
  late String currencyXchangeApi;
  late String socketUrl;
  late String mediaApiUrl;
  late String webrtcUrl;
  List<String> admins = [];

  EnterpriseModel(String pmid) : super(pmid: pmid, type: ExModelType.enterprise, parent: '') {
    name = '';
    enterpriseUrl = '';
    imageUrl = '';
    description = '';
    openAiKey = '';
    openWeatherApiKey = '';
    giphyApiKey = '';
    newsApiKey = '';
    dailyWordApi = '';
    currencyXchangeApi = '';
    socketUrl = '';
    mediaApiUrl = '';
    webrtcUrl = '';
  }

  EnterpriseModel.dummy()
      : super(
            pmid: HycopUtils.genMid(ExModelType.enterprise),
            type: ExModelType.enterprise,
            parent: '');

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        enterpriseUrl,
        imageUrl,
        description,
        openAiKey,
        openWeatherApiKey,
        giphyApiKey,
        newsApiKey,
        dailyWordApi,
        currencyXchangeApi,
        socketUrl,
        mediaApiUrl,
        webrtcUrl,
        admins
      ];

  EnterpriseModel.withName(
      {required this.name,
      required String pparentMid,
      required String adminEmail,
      this.enterpriseUrl = '',
      this.imageUrl = '',
      this.description = '',
      this.openAiKey = '',
      this.openWeatherApiKey = '',
      this.giphyApiKey = '',
      this.newsApiKey = '',
      this.dailyWordApi = '',
      this.currencyXchangeApi = '',
      this.socketUrl = '',
      this.mediaApiUrl = '',
      this.webrtcUrl = ''})
      : super(pmid: '', type: ExModelType.enterprise, parent: pparentMid) {
    admins.add(adminEmail);
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);

    name = map['name'] ?? '';
    enterpriseUrl = map['enterpriseUrl'] ?? '';
    imageUrl = map['imageUrl'] ?? '';
    description = map['description'] ?? '';
    openAiKey = map['openAiKey'] ?? '';
    openWeatherApiKey = map['openWeatherApiKey'] ?? '';
    giphyApiKey = map['giphyApiKey'] ?? '';
    newsApiKey = map['newsApiKey'] ?? '';
    dailyWordApi = map['dailyWordApi'] ?? '';
    currencyXchangeApi = map['currencyXchangeApi'] ?? '';
    socketUrl = map['socketUrl'] ?? '';
    mediaApiUrl = map['mediaApiUrl'] ?? '';
    webrtcUrl = map['webrtcUrl'] ?? '';
    admins = CretaCommonUtils.jsonStringToList((map["admins"] ?? ''));
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'enterpriseUrl': enterpriseUrl,
        'imageUrl': imageUrl,
        'description': description,
        'openAiKey': openAiKey,
        'openWeatherApiKey': openWeatherApiKey,
        'giphyApiKey': giphyApiKey,
        'newsApiKey': newsApiKey,
        'dailyWordApi': dailyWordApi,
        'currencyXchangeApi': currencyXchangeApi,
        'socketUrl': socketUrl,
        'mediaApiUrl': mediaApiUrl,
        'webrtcUrl': webrtcUrl,
        "admins": CretaCommonUtils.listToString(admins),
      }.entries);
  }

  bool isAdmin(String email) => admins.contains(email);
  bool get isDefaultEnterprise => name == UserPropertyModel.defaultEnterprise;
  bool get isOrphanEnterprise => name == UserPropertyModel.orphanEnterprise;
}
