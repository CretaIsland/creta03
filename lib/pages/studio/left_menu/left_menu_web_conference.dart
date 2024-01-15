// stream list


import 'package:creta03/pages/studio/left_menu/left_template_mixin.dart';
import 'package:creta03/pages/studio/left_menu/web_conference/stream/list_remote_stream.dart';
import 'package:creta03/pages/studio/left_menu/web_conference/stream/local_stream.dart';
import 'package:flutter/material.dart';
import 'package:hycop/hycop/account/account_manager.dart';
import 'package:hycop/hycop/webrtc/media_devices/media_devices_data.dart';
import 'package:hycop/hycop/webrtc/peers/peers_data.dart';
import 'package:hycop/hycop/webrtc/producers/producers_data.dart';
import 'package:hycop/hycop/webrtc/webrtc_client.dart';

import '../../login/creta_account_manager.dart';
import '../studio_variables.dart';

class LeftMenuWebConference extends StatefulWidget {
  final double maxHeight;
  const LeftMenuWebConference({super.key, required this.maxHeight});

  @override
  State<LeftMenuWebConference> createState() => _LeftMenuWebConferenceState();
}

class _LeftMenuWebConferenceState extends State<LeftMenuWebConference> with LeftTemplateMixin  {

  @override
  void initState() {
    super.initState();
    initMixin();
    //for webRTC
    //connectServer();
  }

  @override
  void dispose() {
    super.dispose();
    webRTCClient!.close();
    webRTCClient = null;
  }

  Future<void> connectServer() async {
    //for webRTC
    mediaDeviceDataHolder ??= MediaDeviceData();
    peersDataHolder = PeersData();   
    producerDataHolder = ProducerData();
    await mediaDeviceDataHolder!.loadMediaDevice();
    webRTCClient = WebRTCClient(
      roomId: StudioVariables.selectedBookMid,
      peerId: AccountManager.currentLoginUser.email,
      serverUrl: CretaAccountManager.getEnterprise!.webrtcUrl,
      peerName: CretaAccountManager.getUserProperty!.nickname
    );
    webRTCClient!.connectSocket();
  }
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxHeight,
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: horizontalPadding),
            child: const SingleChildScrollView(
              child: Column(
                children: [
                  LocalStream(),
                  ListRemoteStreams()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}