import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class ScrshotModel extends CretaModel {
  String hostId = ''; // read only
  String parentName = '';
  DateTime scrshotTime = DateTime(1970, 1, 1); //read only
  String scrshotFile = ''; // read only

  ScrshotModel(String pmid) : super(pmid: pmid, type: ExModelType.scrshot, parent: '');
  ScrshotModel.dummy()
      : super(pmid: HycopUtils.genMid(ExModelType.scrshot), type: ExModelType.scrshot, parent: '');

  ScrshotModel.withName({
    super.type = ExModelType.scrshot,
    required this.hostId,
    this.parentName = '',
    super.parent = '',
    required super.pmid,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        hostId,
        parentName,
        scrshotFile,
        scrshotTime,
      ];

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    ScrshotModel srcHost = src as ScrshotModel;

    hostId = srcHost.hostId;
    parentName = srcHost.parentName;
    scrshotFile = srcHost.scrshotFile;
    scrshotTime = srcHost.scrshotTime;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    ScrshotModel srcHost = src as ScrshotModel;
    hostId = srcHost.hostId;
    parentName = srcHost.parentName;
    scrshotFile = srcHost.scrshotFile;
    scrshotTime = srcHost.scrshotTime;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    hostId = map["hostId"] ?? '';
    parentName = map["parentName"] ?? '';
    scrshotFile = map["scrshotFile"] ?? '';
    scrshotTime = HycopUtils.dateTimeFromDB(map["scrshotTime"] ?? '');
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "hostId": hostId,
        "parentName": parentName,
        "scrshotFile": scrshotFile,
        "scrshotTime": HycopUtils.dateTimeToDB(scrshotTime),
      }.entries);
  }
}
