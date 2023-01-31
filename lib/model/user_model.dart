// ignore_for_file: must_be_immutable, prefer_const_constructors

//import 'dart:convert';

import 'package:hycop/common/util/logger.dart';
import 'package:hycop/hycop/absModel/abs_ex_model.dart';
import 'package:hycop/hycop/enum/model_enums.dart';
import 'creta_model.dart';

// ignore: camel_case_types
class UserModel extends CretaModel {
  late String name;
  late String email;
  late String imageUrl;
  late String nickName;
  late String password;

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        email,
        imageUrl,
        nickName,
        password,
      ];

  UserModel() : super(type: ExModelType.user, parent: '') {
    name = '';
    email = '';
    imageUrl = '';
    nickName = '';
    password = '';
  }

  UserModel.withName(
      {required this.name,
      required this.email,
      required this.imageUrl,
      required this.nickName,
      this.password = ''})
      : super(type: ExModelType.user, parent: '');

  @override
  void copyFrom(AbsExModel src, {String? newMid, String? pMid}) {
    super.copyFrom(src, newMid: newMid, pMid: pMid);
    UserModel srcUser = src as UserModel;
    name = srcUser.name;
    email = srcUser.email;
    imageUrl = srcUser.imageUrl;
    nickName = srcUser.nickName;
    password = srcUser.password;
    logger.finest('UserCopied($mid)');
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map["name"] ?? '';
    email = map["email"] ?? '';
    imageUrl = map["imageUrl"] ?? '';
    nickName = map["nickName"] ?? '';
    password = map["password"] ?? '';
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        "name": name,
        "email": email,
        "imageUrl": imageUrl,
        "nickName": nickName,
        "password": password,
      }.entries);
  }
}
