import 'package:flutter/material.dart';

enum ActiveState {
  idle,
  active,
}

class ConnectedUserModel {
  late String name;
  late ImageProvider image;
  late ActiveState state;

  ConnectedUserModel({
    required this.name,
    required this.image,
    this.state = ActiveState.idle,
  });
}

class ConnectedUserManager {
  List<ConnectedUserModel> userList = [];
}

ConnectedUserManager connectedUserHolder = ConnectedUserManager();
