// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class TeamModel extends CretaModel {
  late String name;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
      ];

  TeamModel(String pmid) : super(pmid: pmid, type: ExModelType.user, parent: '') {
    name = '';
  }

  TeamModel.withName({
    required this.name,
  }) : super(pmid: '', type: ExModelType.user, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    TeamModel srcUser = src as TeamModel;
    name = srcUser.name;
    logger.finest('UserCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map["name"] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name,
      }.entries);
  }
}
