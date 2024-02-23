import 'package:creta03/data_io/frame_manager.dart';
import 'package:creta_common/common/creta_snippet.dart';
import 'package:creta_common/model/app_enums.dart';
import 'package:creta_studio_model/model/page_model.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';
import 'package:hycop/common/undo/undo.dart';
import 'package:hycop/hycop/webrtc/media_devices/media_devices_data.dart';

class LeftMenuCamera extends StatefulWidget {
  final double width;
  final double height;
  final String title;
  final TextStyle titleStyle;
  final TextStyle dataStyle;

  const LeftMenuCamera({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.titleStyle,
    required this.dataStyle,
  });

  @override
  State<LeftMenuCamera> createState() => _LeftMenuCameraState();
}

class _LeftMenuCameraState extends State<LeftMenuCamera> {
  @override
  void initState() {
    super.initState();
    mediaDeviceDataHolder ??= MediaDeviceData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0),
          child: Text(widget.title, style: widget.dataStyle),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, left: 24.0),
          child: FutureBuilder(
            future: mediaDeviceDataHolder!.loadMediaDevice(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GestureDetector(
                  child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                      )),
                  onTap: () {
                    _createCamera(frameType: FrameType.camera)
                        .then((value) => BookMainPage.pageManagerHolder!.notify());
                  },
                );
              } else {
                return CretaSnippet.showWaitSign();
              }
            },
          ),
        )
      ],
    );
  }

  Future<void> _createCamera({required FrameType frameType}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 320;
    double height = 320;
    double x = 15;
    double y = (pageModel.height.value - height);

    FrameManager? frameManager = BookMainPage.pageManagerHolder!.getSelectedFrameManager();
    if (frameManager == null) {
      return;
    }

    mychangeStack.startTrans();
    await frameManager.createNextFrame(
      doNotify: false,
      size: Size(width, height),
      pos: Offset(x, y),
      bgColor1: Colors.transparent,
      type: frameType,
      shape: ShapeType.circle,
    );
    mychangeStack.endTrans();
  }
}
