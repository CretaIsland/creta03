// ignore_for_file: prefer_const_constructors

import 'package:hycop/hycop/enum/model_enums.dart';

import 'package:creta_common/model/creta_model.dart';

// ignore: must_be_immutable
class ConnectedUserModel extends CretaModel {
  late String name;
  late String email;
  late bool isConnected;
  late String imageUrl;

  // ImageProvider? _image;
  // ImageProvider? get image => _image;

  ConnectedUserModel({
    required String bookMid,
    required this.name,
    required this.email,
    required this.imageUrl,
    this.isConnected = false,
  }) : super(pmid: '', type: ExModelType.connected_user, parent: bookMid, realTimeKey: bookMid) {
    //_image =
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        email,
        isConnected,
        imageUrl,
      ];

  ConnectedUserModel.withBook(String bookMid)
      : super(pmid: '', type: ExModelType.connected_user, parent: bookMid, realTimeKey: bookMid) {
    name = '';
    email = '';
    imageUrl = '';
    isConnected = false;
  }

  @override
  void fromMap(Map<String, dynamic> map) {
    super.fromMap(map);
    name = map['name'] ?? '';
    email = map["email"] ?? '';
    imageUrl = map["imageUrl"] ?? '';
    isConnected = (map["isConnected"] ?? false);
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addEntries({
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'isConnected': isConnected,
      }.entries);
  }
}
