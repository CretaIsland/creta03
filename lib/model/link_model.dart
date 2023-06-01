import 'package:creta03/model/creta_model.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class LinkModel extends CretaModel {
  late String name;
  late double posX;
  late double posY;
  late String conenctedMid;
  late String connectedClass;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        posX,
        posY,
        conenctedMid,
        connectedClass,
      ];

  LinkModel(String pmid) : super(pmid: pmid, type: ExModelType.link, parent: '') {
    name = '';
    posX = 0;
    posY = 0;
    conenctedMid = '';
    connectedClass = '';
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    posX = map['posX'] ?? 0;
    posY = map['posY'] ?? 0;
    conenctedMid = map['conenctedMid'] ?? '';
    connectedClass = map['connectedClass'] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'conenctedMid': conenctedMid,
        'connectedClass': connectedClass,
        'posX': posX,
        'posY': posY,
      }.entries);
  }
}
