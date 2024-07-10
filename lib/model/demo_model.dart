import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

// ignore: must_be_immutable
class DemoModel extends CretaModel {
  String message = ''; // read only
  String creator = ''; // read only

  DemoModel(String pmid) : super(pmid: pmid, type: ExModelType.demo, parent: '');
  DemoModel.dummy()
      : super(pmid: HycopUtils.genMid(ExModelType.demo), type: ExModelType.demo, parent: '');

  @override
  List<Object?> get props => [
        ...super.props,
        message,
        creator,
      ];

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    DemoModel srcHost = src as DemoModel;

    message = srcHost.message;
    creator = srcHost.creator;
  }

  @override
  void updateFrom(AbsExModel src) {
    super.updateFrom(src);
    DemoModel srcHost = src as DemoModel;
    message = srcHost.message;
    creator = srcHost.creator;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    message = map["message"] ?? '';
    creator = map["creator"] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "message": message,
        "creator": creator,
      }.entries);
  }
}
