import 'package:creta03/model/creta_model.dart';
import 'package:hycop/hycop.dart';

import '../common/creta_utils.dart';

// ignore: must_be_immutable
class FilterModel extends CretaModel {
  late String name;
  late List<String> excludes;
  late List<String> includes;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        excludes,
        includes,
      ];

  FilterModel(String pmid) : super(pmid: pmid, type: ExModelType.link, parent: '') {
    name = '';
    excludes = [];
    includes = [];
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    excludes = CretaUtils.dynamicListToStringList(map["excludes"]);
    includes = CretaUtils.dynamicListToStringList(map["includes"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'excludes': excludes,
        'includes': includes,
      }.entries);
  }
}
