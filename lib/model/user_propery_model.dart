// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import '../common/creta_utils.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class UserPropertyModel extends CretaModel {
  late String email;
  late List<Color> bgColorList1;

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        bgColorList1,
      ];

  UserPropertyModel(String pmid) : super(pmid: pmid, type: ExModelType.user, parent: '') {
    email = '';
    bgColorList1 = [];
  }

  UserPropertyModel.withName({
    required this.email,
    this.bgColorList1 = const [],
  }) : super(pmid: '', type: ExModelType.user, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    UserPropertyModel srcUser = src as UserPropertyModel;
    email = srcUser.email;
    bgColorList1 = [...srcUser.bgColorList1];
    logger.finest('UserCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    email = map["email"] ?? '';
    bgColorList1 = CretaUtils.string2ColorList(map["bgColorList1"]);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "email": email,
        "bgColorList1": CretaUtils.colorList2String(bgColorList1),
      }.entries);
  }
}
