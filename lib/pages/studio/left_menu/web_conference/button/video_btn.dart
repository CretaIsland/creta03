import 'package:flutter/material.dart';
import 'package:hycop/hycop/webrtc/media_devices/media_devices_data.dart';
import 'package:hycop/hycop/webrtc/producers/producers_data.dart';
import 'package:hycop/hycop/webrtc/webrtc_client.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:creta_common/common/creta_color.dart';

class VideoBTN extends StatelessWidget {
  const VideoBTN({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: producerDataHolder!),
        ChangeNotifierProvider.value(value: mediaDeviceDataHolder!)
      ],
      child: Consumer2<ProducerData, MediaDeviceData>(
        builder: (context, producerDataManager, mediaDeviceDataManager, child) {
          if (mediaDeviceDataManager.videoInputs!.isEmpty) {
            return GestureDetector(
              child: Container(
                  width: 28,
                  height: 28,
                  decoration:
                      BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Icon(Icons.videocam_off_outlined, color: Colors.white, size: 14))),
            );
          }

          return GestureDetector(
              onTap: () {
                if (producerDataManager.webcam == null) {
                  webRTCClient!.enableWebCam();
                } else {
                  webRTCClient!.disableWebCam();
                }
              },
              child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                      color: producerDataManager.webcam == null
                          ? CretaColor.stateCritical
                          : CretaColor.stateNormal,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Icon(
                          producerDataManager.webcam == null
                              ? Icons.videocam_off_outlined
                              : Icons.videocam_outlined,
                          color: Colors.white,
                          size: 14))));
        },
      ),
    );
  }
}
