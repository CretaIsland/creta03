import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/model/frame_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:hycop/hycop/webrtc/media_devices/media_devices_data.dart';

class CameraFrame extends StatefulWidget {
  final FrameModel model;
  const CameraFrame({super.key, required this.model});

  @override
  State<CameraFrame> createState() => _CameraFrameState();
}

class _CameraFrameState extends State<CameraFrame> {

  RTCVideoRenderer? renderer;
  MediaStream? videoStream;
  MediaStream? audioStream;

  @override
  void initState() {
    super.initState();
    renderer = RTCVideoRenderer();
    renderer!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    videoStream?.dispose();
    audioStream?.dispose();
    renderer?.dispose();
  }


  Future<void> setStream() async {
    Map<String, dynamic> videoConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'optional': [
          {
            'sourceId': mediaDeviceDataHolder!.selectedVideoInput,
          },
        ],
      },
    };
    videoStream = await navigator.mediaDevices.getUserMedia(videoConstraints);
    Map<String, dynamic> audioConstraints = {
      'audio': {
        'optional': [
          {
            'sourceId': mediaDeviceDataHolder!.selectedAudioInput,
          },
        ],
      },
    };
    audioStream = await navigator.mediaDevices.getUserMedia(audioConstraints);

    renderer!.srcObject = videoStream;
    renderer!.srcObject = audioStream;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setStream(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return RTCVideoView(renderer!);
        } else {
           return Snippet.showWaitSign();
        }
      },
    );
  }
}