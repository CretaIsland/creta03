// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

enum ActiveState {
  idle,
  active,
}

class ConnectedUserModel {
  late String name;
  late String email;
  late ImageProvider image;
  late ActiveState state;
  late String imageUrl;

  ConnectedUserModel({
    required this.name,
    required this.email,
    required this.imageUrl,
    this.state = ActiveState.idle,
  }) {
    image = NetworkImage(imageUrl);
  }
}

class ConnectedUserManager {
  List<ConnectedUserModel> userList = [];
}

ConnectedUserManager connectedUserHolder = ConnectedUserManager();
