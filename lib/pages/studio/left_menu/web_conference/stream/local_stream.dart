import 'dart:math';
import 'package:creta_common/common/creta_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hycop/hycop/webrtc/producers/producers_data.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

import '../../../../login/creta_account_manager.dart';
import '../button/audio_btn.dart';
import '../button/video_btn.dart';

class LocalStream extends StatefulWidget {
  const LocalStream({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LocalStreamState createState() => _LocalStreamState();
}

class _LocalStreamState extends State<LocalStream> {
  late RTCVideoRenderer renderer;

  void initRenderers() async {
    renderer = RTCVideoRenderer();
    await renderer.initialize();
  }

  @override
  void initState() {
    super.initState();
    initRenderers();
  }

  @override
  void dispose() {
    renderer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle userNameStyle =
        CretaFont.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w500);
    // const TextStyle(
    //   fontFamily: 'Pretendard',
    //   fontWeight: FontWeight.w500,
    //   fontSize: 14,
    //   color: Colors.white,
    // );

    return MultiProvider(
      providers: [ChangeNotifierProvider<ProducerData>.value(value: producerDataHolder!)],
      child: Consumer<ProducerData>(
        builder: (context, producerDataManager, child) {
          if (producerDataManager.webcam != null) {
            if (renderer.srcObject != producerDataManager.webcam!.stream) {
              renderer.srcObject = producerDataManager.webcam!.stream;
            }
          }

          if (renderer.srcObject != null &&
              renderer.renderVideo &&
              producerDataManager.webcam != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: SizedBox(
                  width: 320,
                  height: 180,
                  child: Stack(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(18.0),
                          child: RTCVideoView(renderer,
                              objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)),
                      Padding(
                        padding: const EdgeInsets.only(top: 142, left: 10.0, right: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(CretaAccountManager.getUserProperty!.nickname,
                                style: userNameStyle),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [AudioBTN(), SizedBox(width: 10), VideoBTN()],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
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
                        colors: [Colors.black87, Colors.black]),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                              image: CretaAccountManager.getUserProperty!.profileImgUrl != ""
                                  ? DecorationImage(
                                      image: Image.network(
                                              CretaAccountManager.getUserProperty!.profileImgUrl)
                                          .image,
                                      fit: BoxFit.cover)
                                  : null),
                          child: CretaAccountManager.getUserProperty!.profileImgUrl != ""
                              ? const SizedBox.shrink()
                              : Center(
                                  child: Text(
                                      CretaAccountManager.getUserProperty!.nickname.substring(0, 1),
                                      style: userNameStyle)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 142, left: 10.0, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(CretaAccountManager.getUserProperty!.nickname,
                                style: userNameStyle),
                            const Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [AudioBTN(), SizedBox(width: 10), VideoBTN()],
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          }
        },
      ),
    );
  }
}
