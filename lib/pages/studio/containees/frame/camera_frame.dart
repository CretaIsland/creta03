import 'package:creta_studio_model/model/frame_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

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
  bool initComplete = false;

  @override
  void initState() {
    super.initState();
    renderer = RTCVideoRenderer();
    renderer!.initialize();
  }

  @override
  void dispose() {
    super.dispose();
    if (videoStream != null && audioStream != null) {
      videoStream!.getTracks().forEach((track) => track.stop());
      videoStream!.dispose();
      audioStream!.getTracks().forEach((track) => track.stop());
      audioStream!.dispose();
    }
    renderer?.dispose();
  }

  Future<void> setStream() async {
    Map<String, dynamic> videoConstraints = <String, dynamic>{
      'audio': false,
      'video': {
        'optional': [
          {
            'sourceId': '',
          },
        ],
      },
    };
    videoStream = await navigator.mediaDevices.getUserMedia(videoConstraints);
    Map<String, dynamic> audioConstraints = {
      'audio': {
        'optional': [
          {
            'sourceId': '',
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
    return Stack(
      children: [
        initComplete
            ? const SizedBox.shrink()
            : Center(
                child: SizedBox(
                  child: IconButton(
                    onPressed: () async {
                      await setStream();
                      setState(() {
                        initComplete = true;
                      });
                    },
                    icon: const Icon(Icons.play_arrow, size: 24),
                  ),
                ),
              ),
        initComplete
            ? RTCVideoView(renderer!, objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover)
            : const SizedBox.shrink(),
        initComplete
            ? Container(width: double.infinity, height: double.infinity, color: Colors.transparent)
            : const SizedBox.shrink(),
      ],
    );

    // return FutureBuilder(
    //   future: setStream(),
    //   builder: (context, snapshot) {
    //     if(snapshot.connectionState == ConnectionState.done) {
    //       return RTCVideoView(renderer!);
    //     } else {
    //        return CretaSnippet.showWaitSign();
    //     }
    //   },
    // );
  }
}
