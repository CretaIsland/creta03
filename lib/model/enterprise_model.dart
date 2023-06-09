import 'package:creta03/model/creta_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';

// ignore: must_be_immutable
class EnterpriseModel extends CretaModel {

  late String name;
  late String description;
  late String openAiKey;


  EnterpriseModel(String pmid) : super(pmid: pmid, type: ExModelType.enterprise, parent: '') {
    name = '';
    description = '';
    openAiKey = '';
  }

  @override
  List<Object?> get props => [
    ...super.props,
    name,
    description,
    openAiKey
  ];

  EnterpriseModel.withName({
    required this.name,
    required String pparentMid,
    this.description = '',
    this.openAiKey = ''
  }) : super(pmid: '', type: ExModelType.enterprise, parent: pparentMid);

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);

    name = map['name'] ?? '';
    description = map['description'] ?? '';
    openAiKey = map['openAiKey'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'description': description,
        'openAiKey': openAiKey
      }.entries);
  }







}