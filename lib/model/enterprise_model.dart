import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

// ignore: must_be_immutable
class EnterpriseModel extends CretaModel {
  late String name;
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

  EnterpriseModel(String pmid) : super(pmid: pmid, type: ExModelType.enterprise, parent: '') {
    name = '';
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

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        description,
        openAiKey,
        openWeatherApiKey,
        giphyApiKey,
        newsApiKey,
        dailyWordApi,
        currencyXchangeApi,
        socketUrl,
        mediaApiUrl,
        webrtcUrl
      ];

  EnterpriseModel.withName(
      {required this.name,
      required String pparentMid,
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
      : super(pmid: '', type: ExModelType.enterprise, parent: pparentMid);

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);

    name = map['name'] ?? '';
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
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'description': description,
        'openAiKey': openAiKey,
        'openWeatherApiKey': openWeatherApiKey,
        'giphyApiKey': giphyApiKey,
        'newsApiKey': newsApiKey,
        'dailyWordApi': dailyWordApi,
        'currencyXchangeApi': currencyXchangeApi,
        'socketUrl': socketUrl,
        'mediaApiUrl': mediaApiUrl,
        'webrtcUrl': webrtcUrl
      }.entries);
  }
}
