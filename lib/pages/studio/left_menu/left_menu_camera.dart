import 'package:creta03/design_system/component/snippet.dart';
import 'package:creta03/model/app_enums.dart';
import 'package:creta03/pages/studio/book_main_page.dart';
import 'package:flutter/material.dart';

import 'package:creta03/data_io/page_manager.dart';
import 'package:creta03/data_io/frame_manager.dart';
import 'package:creta03/model/page_model.dart';
import 'package:hycop/common/undo/undo.dart';

import 'package:hycop/hycop/webrtc/media_devices/media_devices_data.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';


class LeftMenuCamera extends StatefulWidget {
  const LeftMenuCamera({super.key});

  @override
  State<LeftMenuCamera> createState() => _LeftMenuCameraState();
}

class _LeftMenuCameraState extends State<LeftMenuCamera> {

  FrameManager? _frameManager;
  PageModel? _pageModel;

  List<String> videoDeviceList = [''];
  List<String> audioDeviceList = [''];


  @override
  void initState() {
    super.initState();
    mediaDeviceDataHolder = MediaDeviceData();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mediaDeviceDataHolder!.loadMediaDevice(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          return Consumer<PageManager>(
            builder: (context, pageManager, child) {
              _pageModel = pageManager.getSelected() as PageModel?;
              if(_pageModel == null) {
                return const Center(child: Text('No Page Selected'));
              }
              _frameManager = pageManager.findFrameManager(_pageModel!.mid);
              if(_frameManager == null) {
          return const Center(child: Text('No Frame fetched'));
              }

              return Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        _createCamera(frameType: FrameType.camera).then((value) {
                          BookMainPage.pageManagerHolder!.notify();
                        });
                      },
                      child: Container(
                        width: 332,
                        height: 210,
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 40),
                        ),
                      ),
                    )
                  ],
                ),  
              );
            }
          );
        } else {
          return Snippet.showWaitSign();
        }
      },
    );
  }



  Future<void> _createCamera({required FrameType frameType}) async {
    PageModel? pageModel = BookMainPage.pageManagerHolder!.getSelected() as PageModel?;
    if (pageModel == null) return;

    double width = 160;
    double height = 160;
    double x = 10;
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