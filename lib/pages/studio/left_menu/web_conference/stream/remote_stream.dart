import 'dart:math';
import 'package:creta_common/common/creta_font.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hycop/hycop/webrtc/peers/enitity/peer.dart';

import '../../../../login/creta_account_manager.dart';

// ignore: must_be_immutable
class RemoteStream extends StatelessWidget {
  final Peer peer;
  final double screenHeight;
  final double screenWidth;
  TextStyle userNameStyle =
      CretaFont.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w500);

  //  const TextStyle(
  //   fontFamily: 'Pretendard',
  //   fontWeight: FontWeight.w500,
  //   fontSize: 14,
  //   color: Colors.white,
  // );

  RemoteStream(
      {required Key key, required this.peer, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CretaAccountManager.userPropertyManagerHolder.getMemberProperty(email: peer.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          if (peer.renderer != null && peer.video != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SizedBox(
                  width: 320,
                  height: 180,
                  child: Stack(children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: RTCVideoView(peer.renderer!,
                            objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)),
                    Padding(
                      padding: const EdgeInsets.only(top: 130, left: 10.0),
                      child: Text(peer.displayName, style: userNameStyle),
                    )
                  ])),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Container(
                  width: 320,
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.0),
                      color: Colors.black,
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black87, Colors.black])),
                  child: Stack(children: [
                    Center(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                            image: snapshot.data!.profileImgUrl != ""
                                ? DecorationImage(
                                    image: Image.network(snapshot.data!.profileImgUrl).image,
                                    fit: BoxFit.cover)
                                : null),
                        child: snapshot.data!.profileImgUrl != ""
                            ? const SizedBox.shrink()
                            : Center(
                                child:
                                    Text(peer.displayName.substring(0, 1), style: userNameStyle)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 130, left: 10.0),
                      child: Text(peer.displayName, style: userNameStyle),
                    )
                  ])),
            );
          }
        } else {
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Container(
              width: 320,
              height: 180,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.0),
                  border: Border.all(width: 1.0, color: Colors.grey)),
              child: Center(child: CretaSnippet.showWaitSign()),
            ),
          );
        }
      },
    );
  }
}
