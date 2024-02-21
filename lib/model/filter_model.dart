import 'package:creta_common/model/creta_model.dart';
import 'package:hycop/hycop.dart';

import 'package:creta_common/common/creta_common_utils.dart';

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

  FilterModel(String parent) : super(pmid: '', type: ExModelType.filter, parent: parent) {
    name = '';
    excludes = [];
    includes = [];
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    excludes = CretaCommonUtils.dynamicListToStringList(map["excludes"]);
    includes = CretaCommonUtils.dynamicListToStringList(map["includes"]);
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
