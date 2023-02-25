import 'dart:async';

import 'package:get/get.dart';
import 'package:hycop/common/util/logger.dart';

import '../../model/frame_model.dart';

class FrameEventController extends GetxController {
  // Define an event stream
  final eventStream = StreamController<FrameModel>.broadcast();

  // Method to send an event
  void sendEvent(FrameModel model) {
    eventStream.add(model);
  }
}

class StudioGetXController extends GetxController {
  FrameEventController? framEvent;
  @override
  void onInit() {
    // Initialize EventController1 instance with a tag
    logger.info('==========================StudioGetXController initialized================');
    Get.put(FrameEventController(), tag: 'frameEvent1');
    // Initialize EventController2 instance with a tag
    super.onInit();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  //   // Dispose of eventController here
  //   //framEvent?.onClose();
  // }
}
